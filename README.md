
SGDK for Linux
==============

This is an attempt to make SGDK linux builds easier. I found myself the need to
use a more up-to-date toolchain and the one provided by kubilus1/gendev tends
to lag behind.

The aim is to do this in a very non-invasive way, so I keep some patches
against SGDK to unixfy the makefiles essentially.

At the time of writing the toolchain features:

GCC 10.1.0 + Binutils 2.34 (+ Newlib 3.3.0) SGDK 1.51


Pre-built packages
------------------

So far there's unoffical packages for the following platforms:

 -  [Fedora](https://copr.fedorainfracloud.org/coprs/davidgf/sgdk-toolchain/)
    Can be enabled in your system via copr running `dnf copr enable davidgf/sgdk-toolchain`

More platforms to come soon. For now only x86/x64 platforms supported, this should
be fixed in the next release (plan to support armv7/8).


How to
------

The build will place all the files at /opt/gendev by default. You can change
this in the config.mk file.

To build gcc and binutils (+newlib) run the following:

```
make
```

Please ensure the output directory exists and it is owned by the user.



