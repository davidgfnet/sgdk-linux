Name:           sgdk-toolchain
Version:        1
Release:        51%{?dist}
Summary:        Framework and toolchain to build Megadrive/Genesis games

License:        GPL3 and MIT
URL:            https://github.com/davidgfnet/sgdk-linux
Source0:        ftp://ftp.gnu.org/pub/gnu/binutils/binutils-2.34.tar.gz
Source1:        ftp://ftp.gnu.org/pub/gnu/gcc/gcc-10.1.0/gcc-10.1.0.tar.gz
Source2:        ftp://sourceware.org/pub/newlib/newlib-3.3.0.tar.gz
Source3:        https://github.com/Stephane-D/SGDK/archive/v1.51.tar.gz
Source4:        https://github.com/davidgfnet/sgdk-linux/archive/v1.0.tar.gz


BuildRequires: patchutils, dos2unix
BuildRequires: java-devel
BuildRequires: gcc, gcc-c++
BuildRequires: make, texinfo, texinfo-tex
BuildRequires: glibc-static, glibc-devel
BuildRequires: elfutils-devel, elfutils-libelf-devel
BuildRequires: gmp-devel >= 4.1.2-8, mpfr-devel >= 2.2.1, libmpc-devel >= 0.8.1
BuildRequires: zlib-devel, gettext, dejagnu, bison, flex, sharutils


%description
SGDK is a development kit to create Megadrive/Genesis videogames. Ships a full
m68k gcc toolchain, libraries and docs.


%prep
mkdir -p downloads/
cp %{SOURCE0} %{SOURCE1} %{SOURCE2} downloads/
cp %{SOURCE3} downloads/SGDK-1.51.tar.gz
tar xf %{SOURCE4} --strip-components=1

%build
%make_build


%install
# Do not attempt to strip any binaries nor libraries
# The building scripts already strip binaries for you, plus the rpm tool
# tries to use 'strip' causing it to use the wrong bintuils for the arch.
# Simplification of cross-gcc.spec
cp -r output/* %{buildroot}/
%undefine __strip
%global __strip /bin/true


%files
/opt/*


%changelog
* Sun Jun 7 2020 David Guillen Fandos <david@davidgf.net> - 1-51
- First SGDK package

