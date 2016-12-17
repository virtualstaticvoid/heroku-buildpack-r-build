
Libraries have been installed in:
   /app/.tools/fakechroot/lib/fakechroot

If you ever happen to want to link against installed libraries
in a given directory, LIBDIR, you must either use libtool, and
specify the full pathname of the library, or use the `-LLIBDIR'
flag during linking and do at least one of the following:
   - add LIBDIR to the `LD_LIBRARY_PATH' environment variable
     during execution
   - add LIBDIR to the `LD_RUN_PATH' environment variable
     during linking
   - use the `-Wl,-rpath -Wl,LIBDIR' linker flag
   - have your system administrator add LIBDIR to `/etc/ld.so.conf'

See any operating system documentation about shared libraries for
more information, such as the ld(1) and ld.so(8) manual pages.


docker run -it -v `pwd`:/tmp/build heroku/cedar:14 /bin/bash

mkdir /app;
cd /app;
tar xzf /tmp/build/R-3.3.2-binaries-

<!--
APP_DIR="/app"
TOOLS_DIR="$APP_DIR/.tools"
CHROOT_DIR="$APP_DIR/.root"
FAKECHROOT_DIR="$TOOLS_DIR/fakechroot"
export LD_LIBRARY_PATH="/app/.root/usr/lib:/app/.root/usr/lib/x86_64-linux-gnu:$LD_LIBRARY_PATH"
export PKG_CONFIG_PATH="/usr/lib/pkgconfig:/usr/lib/x86_64-linux-gnu/pkgconfig:/usr/share/pkgconfig:$PKG_CONFIG_PATH"
$FAKECHROOT_DIR/bin/fakechroot /usr/bin/fakeroot /usr/sbin/chroot $CHROOT_DIR /bin/bash
 -->

APP_DIR="/app"
TOOLS_DIR="$APP_DIR/.tools"
CHROOT_DIR="$APP_DIR/.root"
FAKECHROOT_DIR="$TOOLS_DIR/fakechroot"
export PATH="$FAKECHROOT_DIR/sbin:$FAKECHROOT_DIR/bin:$PATH"
fakechroot fakeroot chroot $CHROOT_DIR /bin/bash
