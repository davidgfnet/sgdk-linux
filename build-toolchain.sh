
set -e

source config.mk

echo "Unpacking..."
mkdir -p sources
if [[ ! -d sources/binutils-${BINUTILS_VERSION} ]]; then
	(cd sources/ && tar xf ../downloads/binutils-${BINUTILS_VERSION}.tar.gz)
fi
if [[ ! -d sources/gcc-${GCC_VERSION} ]]; then
	(cd sources/ && tar xf ../downloads/gcc-${GCC_VERSION}.tar.gz)
fi
if [[ ! -d sources/newlib-${NEWLIB_VERSION} ]]; then
	(cd sources/ && tar xf ../downloads/newlib-${NEWLIB_VERSION}.tar.gz)
fi

# Prepare the build space
rm -rf build/
mkdir -p build/{gcc1,gcc2,newlib,binutils,binutils2,temproot}
TEMP_ROOT=`realpath build/temproot`

GCC_FLAGS="--with-cpu=m68000 --disable-werror --disable-nls --disable-multilib --disable-libssp --disable-tls --disable-werror"
NEWLIB_FLAGS="--with-cpu=m68000 --disable-werror --disable-nls --disable-multilib"

# First build binutils and gcc "locally" so we can use them
echo "Building and installing binutils..."
(cd build/binutils && ../../sources/binutils-${BINUTILS_VERSION}/configure --prefix=${TEMP_ROOT} --target=m68k-elf && make -j `nproc` && make install-strip)

export PATH=$PATH:${TEMP_ROOT}/bin

echo "Building gcc ..."
(cd build/gcc1 && ../../sources/gcc-${GCC_VERSION}/configure --target=m68k-elf --enable-languages=c --prefix=${TEMP_ROOT} --without-headers ${GCC_FLAGS} && make -j `nproc` all && make install-strip)

echo "Building newlib ..."
(cd build/newlib && ../../sources/newlib-${NEWLIB_VERSION}/configure --target=m68k-elf --prefix=${PREFIX} ${NEWLIB_FLAGS} && make -j `nproc` all && make install DESTDIR=${INSTALLDIR})

# Rebuild second pass
echo "Building and installing binutils..."
(cd build/binutils2 && ../../sources/binutils-${BINUTILS_VERSION}/configure --prefix=${PREFIX} --target=m68k-elf && make -j `nproc` && make install-strip DESTDIR=${INSTALLDIR})

echo "Building final gcc ..."
(cd build/gcc2 && ../../sources/gcc-${GCC_VERSION}/configure --target=m68k-elf --enable-languages=c --with-build-sysroot=${INSTALLDIR} --prefix=${PREFIX} --with-newlib ${GCC_FLAGS} && make -j `nproc` all && make install-strip DESTDIR=${INSTALLDIR})

echo "Toolchain built successfully!"

