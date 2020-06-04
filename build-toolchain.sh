
source config.mk

echo "Dowloading sources..."
mkdir -p downloads
if [[ ! -f downloads/binutils-${BINUTILS_VERSION}.tar.gz ]]; then
	wget -O downloads/binutils-${BINUTILS_VERSION}.tar.gz "ftp://ftp.gnu.org/pub/gnu/binutils/binutils-${BINUTILS_VERSION}.tar.gz"
fi
if [[ ! -f downloads/gcc-${GCC_VERSION}.tar.gz ]]; then
	wget -O downloads/gcc-${GCC_VERSION}.tar.gz "ftp://ftp.gnu.org/pub/gnu/gcc/gcc-${GCC_VERSION}/gcc-${GCC_VERSION}.tar.gz"
fi
if [[ ! -f downloads/newlib-${NEWLIB_VERSION}.tar.gz ]]; then
	wget -O downloads/newlib-${NEWLIB_VERSION}.tar.gz "ftp://sourceware.org/pub/newlib/newlib-${NEWLIB_VERSION}.tar.gz"
fi

echo "Unpacking..."
if [[ ! -d binutils-${BINUTILS_VERSION} ]]; then
	tar xf downloads/binutils-${BINUTILS_VERSION}.tar.gz
fi
if [[ ! -d gcc-${GCC_VERSION} ]]; then
	tar xf downloads/gcc-${GCC_VERSION}.tar.gz
fi
if [[ ! -d newlib-${NEWLIB_VERSION} ]]; then
	tar xf downloads/newlib-${NEWLIB_VERSION}.tar.gz
fi

echo "Building and installing binutils..."
(cd binutils-${BINUTILS_VERSION} && ./configure --prefix=${PREFIX} --target=m68k-elf && make -j `nproc` && make install)

export PATH=$PATH:${PREFIX}/bin/

GCC_FLAGS="--with-cpu=m68000 --disable-werror --disable-nls --disable-multilib --disable-libssp --disable-tls --disable-werror"
NEWLIB_FLAGS="--with-cpu=m68000 --disable-werror --disable-nls --disable-multilib"

echo "Building gcc ..."
rm -rf gcc-build1 gcc-build2
mkdir -p gcc-build1 gcc-build2
(cd gcc-build1/ && ../gcc-${GCC_VERSION}/configure --target=m68k-elf --enable-languages=c --prefix=${PREFIX} --without-headers ${GCC_FLAGS} && make -j `nproc` install && make install)

echo "Building newlib ..."
(cd newlib-${NEWLIB_VERSION} && ./configure --target=m68k-elf --prefix=${PREFIX} ${NEWLIB_FLAGS} && make -j `nproc` all && make install)

echo "Building final gcc ..."
(cd gcc-build2/ && ../gcc-${GCC_VERSION}/configure --target=m68k-elf --enable-languages=c --prefix=${PREFIX} --with-newlib ${GCC_FLAGS} && make -j `nproc` all && make install)


