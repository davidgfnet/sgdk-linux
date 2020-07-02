
set -e

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
if [[ ! -f downloads/SGDK-${SGDK_VERSION}.tar.gz ]]; then
	wget -O downloads/SGDK-${SGDK_VERSION}.tar.gz "https://github.com/Stephane-D/SGDK/archive/v${SGDK_VERSION}.tar.gz"
fi

