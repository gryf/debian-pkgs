#!/bin/sh -x
#
# to build this package, you need to install following dev packages:
# # aptitude install libc6-dev libgcc2-4.7-dev libice-dev libpam0g-dev \
# > libsm-dev libstdc++6-4.7-dev libx11-dev libxext-dev
# TODO: check the above as a dependecies

STUFF_TO_INSTALL=""
for pkg in libpam0g-dev mesa-common-dev libglu1-mesa-dev libxt-dev; do
    dpkg -l |grep -q $pkg
    if [ $? != 0 ]; then
        STUFF_TO_INSTALL="$STUFF_TO_INSTALL ${pkg}"
    fi
done
if [ ! -e "$STUFF_TO_INSTALL" ]; then
    echo apt-get -y install $STUFF_TO_INSTALL
    apt-get -y install $STUFF_TO_INSTALL
fi

JOBS=-j$(($(nproc) + 1))

wget http://www.sillycycle.com/xlock/recent-releases/xlockmore-5.50.tar.xz


rm -fr _xlockmore xlockmore-5.50 xlockmore-5.50.deb && \
    mkdir -p _xlockmore/DEBIAN _xlockmore/usr/bin \
        _xlockmore/usr/share/doc/xlockmore \
        _xlockmore/usr/share/man/man1 \
        _xlockmore/etc/pam.d \
        _xlockmore/etc/X11/Xresources && \
    tar xf xlockmore-5.50.tar.xz && \
    cd xlockmore-5.50 && \
    
    patch -Np1 < ../recipies/xlockmore/xlockmore-5.46-freetype261.patch && \
    patch -Np1 < ../recipies/xlockmore/xlockmore-5.47-CXX.patch && \
    patch -Np1 < ../recipies/xlockmore/xlockmore-5.47-strip.patch && \
    # autoreconf && \
    
    ./configure --without-ftgl --disable-mb --with-ttf --with-freetype \
		--enable-appdefaultdir=/usr/share/X11/app-defaults \
		--enable-syslog --enable-vtlock --without-esound \
		--without-gtk2 --without-gtk --with-crypt --enable-pam && \
    make $JOBS && \

    strip xlock/xlock && \

    gzip README && \
    gzip xlock/xlock.man && \

    mv xlock/xlock ../_xlockmore/usr/bin/ && \
    mv README.gz ../_xlockmore/usr/share/doc/xlockmore/ && \
    pwd
    mv xlock/xlock.man.gz ../_xlockmore/usr/share/man/man1/xlock.1.gz && \
    cd .. && \

    echo "root" > _xlockmore/etc/xlock.staff && \
    echo "wheel" >> _xlockmore/etc/xlock.staff && \
    echo "@include common-auth" > _xlockmore/etc/pam.d/xlock && \
    echo "! number of minutes to logout button, -1 disables" > _xlockmore/etc/X11/Xresources/xlockmore && \
    echo "! this will take effect the next time X is started" >> _xlockmore/etc/X11/Xresources/xlockmore && \
    echo "XLock*logoutButton: -1" >> _xlockmore/etc/X11/Xresources/xlockmore && \
    echo "XLock.background: Black" >> _xlockmore/etc/X11/Xresources/xlockmore && \
    echo "XLock.foreground: White" >> _xlockmore/etc/X11/Xresources/xlockmore && \

    rm -fr xlockmore-5.50.tar.xz xlockmore-5.50 && \
SIZE=`du -ks _xlockmore/usr|cut -f 1` && \
cat > _xlockmore/DEBIAN/control << EOF
Package: xlockmore
Version: 5.50
Section: user/hidden
Priority: optional
Architecture: amd64
Maintainer: Roman Dobosz <gryf@vimja.com>
Description: Just another screensaver application for X
EOF
echo "Installed-Size: ${SIZE}" >> _xlockmore/DEBIAN/control && \
mv _xlockmore xlockmore-5.50 && dpkg-deb -b xlockmore-5.50 && \
rm -fr xlockmore-5.50 && \
echo xlockmore done.
