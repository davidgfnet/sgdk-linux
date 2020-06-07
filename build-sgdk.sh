
set -e

source config.mk

# Fetch the SGDK tarball and unpack it
mkdir -p downloads
if [[ ! -f downloads/SGDK-${SGDK_VERSION}.tar.gz ]]; then
	wget -O downloads/SGDK-${SGDK_VERSION}.tar.gz "https://github.com/Stephane-D/SGDK/archive/v${SGDK_VERSION}.tar.gz"
fi
if [[ ! -d SGDK-${SGDK_VERSION} ]]; then
	tar xf downloads/SGDK-${SGDK_VERSION}.tar.gz
	# Proceed to apply patches to it. Unfortunately this is necessary
	if [[ ! -f patches/SGDK-${SGDK_VERSION}.patch ]]; then
		echo "Cannot find the SGDK patch for version ${SGDK_VERSION}"
		exit 1
	else
		# Patch does not like Windows CLRF files so...
		for fn in `lsdiff --strip=1 patches/SGDK-${SGDK_VERSION}.patch`; do
			dos2unix "SGDK-${SGDK_VERSION}/$fn"
		done
		(cd SGDK-${SGDK_VERSION} && patch -p1 < ../patches/SGDK-${SGDK_VERSION}.patch)
	fi
fi

# Build sjasm since it is needed later
# From https://github.com/Konamiman/Sjasm/tree/v0.39
(cd sjasm && make)
cp sjasm/sjasm SGDK-${SGDK_VERSION}/bin/

# Now build it
cd SGDK-${SGDK_VERSION}

# First build the tools we need
TOOLS_FLAGS="-O2 -ggdb"
gcc -o bin/sizebnd tools/sizebnd/src/sizebnd.c ${TOOLS_FLAGS}
gcc -o bin/bintos tools/bintos/src/bintos.c ${TOOLS_FLAGS}
strip -s bin/bintos
strip -s bin/sizebnd

# User tools
(cd tools/xgmtool/ && gcc -O2 -ggdb src/*.c -Iinc -o xgmtool -lm)
cp tools/xgmtool/xgmtool bin/
strip -s bin/xgmtool

# More tools, this is a bit hacky but does work
if [ `getconf LONG_BIT` = "64" ]; then
	(cd tools/appack && make -f makefile.elf64)
else
	(cd tools/appack && make -f makefile.elf)
fi
cp ./tools/appack/appack bin/

# Actually build the thing
OUTDIR=$INSTALLDIR/$PREFIX
export PATH=$PATH:$OUTDIR/bin
export GDK=.
rm lib/*   # This ships some pre-compiled stuff, wipe it!
make -f makelib.gen cleanrelease
make -f makelib.gen release
make -f makelib.gen cleandebug
make -f makelib.gen debug

# libgcc is linked at this location, dunno why
# I suppose the Win toolchain does not ship it or something
cp ${OUTDIR}/lib/gcc/m68k-elf/${GCC_VERSION}/libgcc.a lib/

# Copy the resulting toolchain to the output path
mkdir -p ${OUTDIR}/sgdk
mkdir -p ${OUTDIR}/sgdk/src
cp -r lib ${OUTDIR}/sgdk
cp -r inc ${OUTDIR}/sgdk
cp -r doc ${OUTDIR}/sgdk
cp -r res ${OUTDIR}/sgdk
cp -r src/boot ${OUTDIR}/sgdk/src
cp -r md.ld ${OUTDIR}/sgdk/

# Copy the tools too
cp -r bin/*.jar ${OUTDIR}/bin
cp bin/appack ${OUTDIR}/bin
cp bin/bintos ${OUTDIR}/bin
cp bin/sizebnd ${OUTDIR}/bin
cp bin/sjasm ${OUTDIR}/bin
cp bin/xgmtool ${OUTDIR}/bin

# The makefile needs to be tweaked a bit unfortunately
# since it is very windows specific :(
mkdir -p ${OUTDIR}/sgdk/mkfiles
cp makefile.gen ${OUTDIR}/sgdk/mkfiles/

echo "SGDK built successfully"

