#!/bin/sh

rm -fr _wmamixer wmamixer wmamixer-0.1 wmamixer-0.1.deb

for i in libxpm-dev libasound2-dev; do
    dpkg -l |grep -q $i
    if [ $? != 0 ]; then
        apt-get -y install $i
    fi
done

JOBS=-j$(($(nproc) + 1))

git clone https://github.com/gryf/wmamixer.git || exit "Cannot clone repo"

mkdir -p _wmamixer/DEBIAN _wmamixer/usr/bin \
    _wmamixer/usr/share/doc/wmamixer && \
    cd wmamixer && \
    make $JOBS && \
    gzip README.rst && \
    gzip README.wmmixer && \
    gzip README.wmsmixer && \
    mv wmamixer ../_wmamixer/usr/bin/ && \
    mv README.rst.gz ../_wmamixer/usr/share/doc/wmamixer/ && \
    mv README.wmmixer.gz ../_wmamixer/usr/share/doc/wmamixer/ && \
    mv README.wmsmixer.gz ../_wmamixer/usr/share/doc/wmamixer/ && \
    cd .. && \
    rm -fr wmamixer && \
SIZE=`du -ks _wmamixer/usr|cut -f 1` && \
cat > _wmamixer/DEBIAN/control << EOF
Package: wmamixer
Version: 0.2
Section: user/hidden
Priority: optional
Architecture: amd64
Maintainer: Roman Dobosz <gryf@vimja.com>
Description: Alsa Mixer in a windowmakers' dockapp 
EOF
echo "Installed-Size: ${SIZE}" >> _wmamixer/DEBIAN/control && \
mv _wmamixer wmamixer-0.2 && dpkg-deb -b wmamixer-0.2 && \
rm -fr wmamixer-0.2 && \
echo wmamixer done.
