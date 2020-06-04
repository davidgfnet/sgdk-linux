
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

# User tools
(cd tools/xgmtool/ && gcc -O2 -ggdb src/*.c -Iinc -o xgmtool -lm)
cp tools/xgmtool/xgmtool bin/

# More tools, this is a bit hacky but does work
if [ `getconf LONG_BIT` = "64" ]; then
	(cd tools/appack && make -f makefile.elf64)
else
	(cd tools/appack && make -f makefile.elf)
fi
cp ./tools/appack/appack bin/

# Actually build the thing
export PATH=$PATH:$PREFIX/bin
export GDK=.
rm lib/*   # This ships some pre-compiled stuff, wipe it!
make -f makelib.gen cleanrelease
make -f makelib.gen release
make -f makelib.gen cleandebug
make -f makelib.gen debug

# libgcc is linked at this location, dunno why
# I suppose the Win toolchain does not ship it or something
cp ${PREFIX}/lib/gcc/m68k-elf/${GCC_VERSION}/libgcc.a lib/

# Copy the resulting toolchain to the output path
mkdir -p ${PREFIX}/sgdk
mkdir -p ${PREFIX}/sgdk/src
cp -r lib ${PREFIX}/sgdk
cp -r inc ${PREFIX}/sgdk
cp -r doc ${PREFIX}/sgdk
cp -r res ${PREFIX}/sgdk
cp -r src/boot ${PREFIX}/sgdk/src
cp -r md.ld ${PREFIX}/sgdk/

# Copy the tools too
cp -r bin/*.jar ${PREFIX}/bin
cp bin/appack ${PREFIX}/bin
cp bin/bintos ${PREFIX}/bin
cp bin/sizebnd ${PREFIX}/bin
cp bin/sjasm ${PREFIX}/bin
cp bin/xgmtool ${PREFIX}/bin

# The makefile needs to be tweaked a bit unfortunately
# since it is very windows specific :(
mkdir -p ${PREFIX}/sgdk/mkfiles
cp makefile.gen ${PREFIX}/sgdk/mkfiles/

