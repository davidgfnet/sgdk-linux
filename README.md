
SGDK for Linux
==============

This is an attempt to make SGDK linux builds easier. I found myself the need to
use a more up-to-date toolchain and the one provided by kubilus1/gendev tends
to lag behind.

The aim is to do this in a very non-invasive way, so I keep some patches
against SGDK to unixfy the makefiles essentially.

At the time of writing the toolchain features:

GCC 10.1.0 + Binutils 2.34 (+ Newlib 3.3.0)
SGDK 1.51


How to
------

The build will place all the files at /opt/gendev by default. You can change
this in the config.mk file.

To build gcc and binutils (+newlib) run the following:

./build.sh

Please ensure the output directory exists and it is owned by the user.



