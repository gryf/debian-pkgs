#!/bin/sh

rm -fr bubblemon-1.46 bubblemon-dockapp-1.46 bubblemon-1.46.deb

dpkg -l |grep -q libgdk-pixbuf2.0-dev
if [ $? != 0 ]; then
    apt-get -y install libgdk-pixbuf2.0-dev
fi

dpkg -l |grep -q libgtkmm-2.4-dev
if [ $? != 0 ]; then
    apt-get -y install libgtkmm-2.4-dev
fi

JOBS=-j$(($(nproc) + 1))

wget "http://www.ne.jp/asahi/linux/timecop/software/bubblemon-dockapp-1.46.tar.gz"

mkdir -p bubblemon-1.46/DEBIAN bubblemon-1.46/usr/bin \
    bubblemon-1.46/usr/share/bubblemon \
    bubblemon-1.46/usr/share/doc/bubblemon && \
    tar zxf bubblemon-dockapp-1.46.tar.gz && \
    cd bubblemon-dockapp-1.46 && \
patch -Np0 < ../recipies/bubblemon/bubblemon-1.46-gtk.patch
patch -Np0 < ../recipies/bubblemon/bubblemon-1.46-asneeded.patch
patch -Np0 < ../recipies/bubblemon/bubblemon-1.46-no_display.patch
make $JOBS && \
    gzip README && \
    gzip ChangeLog && \
    strip bubblemon && \
    mv bubblemon ../bubblemon-1.46/usr/bin/ && \
    mv misc/* ../bubblemon-1.46/usr/share/bubblemon && \
    mv README.gz ../bubblemon-1.46/usr/share/doc/bubblemon/ && \
    mv ChangeLog.gz ../bubblemon-1.46/usr/share/doc/bubblemon/ && \
    cd .. && \
    rm -fr bubblemon-dockapp-1.46 bubblemon-dockapp-1.46.tar.gz && \

SIZE=`du -ks bubblemon-1.46/usr|cut -f 1` && \
cat > bubblemon-1.46/DEBIAN/control << EOF
Package: bubblemon
Version: 1.46
Section: user/hidden
Priority: optional
Architecture: amd64
Maintainer: Roman Dobosz <gryf@vimja.com>
Description: A fun monitoring dockapp for WindowMaker with swimming duck
EOF

echo "Installed-Size: ${SIZE}" >> bubblemon-1.46/DEBIAN/control && \
dpkg-deb -b bubblemon-1.46 && rm -fr bubblemon-1.46 && \
echo bubblemon done.
