#!/bin/sh

rm -fr peksystray-0.4.0 _peksystray-0.4.0 peksystray-0.4.0.deb

dpkg -l |grep -q autoconf
if [ $? != 0 ]; then
    apt-get -y install autoconf
fi

JOBS=-j$(($(nproc) + 1))

wget --content-disposition -c "https://sourceforge.net/projects/peksystray/files/peksystray/0.4.0/peksystray-0.4.0.tar.bz2/download"

mkdir -p _peksystray-0.4.0/DEBIAN _peksystray-0.4.0/usr/bin \
    _peksystray-0.4.0/usr/share/doc/peksystray && \
    tar xf peksystray-0.4.0.tar.bz2 && \
    cd peksystray-0.4.0 && \
    patch -Np0 < ../recipies/peksystray/peksystray-0.4.0-asneeded.patch && \
    ./autogen.sh && \
    ./configure && make $JOBS && \
    gzip README && \
    strip src/peksystray && \
    mv src/peksystray ../_peksystray-0.4.0/usr/bin/ && \
    mv README.gz ../_peksystray-0.4.0/usr/share/doc/peksystray/ && \
    cd .. && \
    rm -fr peksystray-0.4.0 peksystray-0.4.0.tar.bz2 && \
    mv _peksystray-0.4.0 peksystray-0.4.0 && \
SIZE=`du -ks peksystray-0.4.0/usr|cut -f 1` && \
cat > peksystray-0.4.0/DEBIAN/control << EOF
Package: peksystray
Version: 0.4.0
Section: user/hidden
Priority: optional
Architecture: amd64
Maintainer: Roman Dobosz <gryf@vimja.com>
Description: System tray for pekwm and others
EOF
echo "Installed-Size: ${SIZE}" >> peksystray-0.4.0/DEBIAN/control && \
dpkg-deb -b peksystray-0.4.0 && rm -fr peksystray-0.4.0 && \
echo peksystray done.
