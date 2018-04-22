#!/bin/bash

if [ "$1" == "clean" ]; then
	rm -fr *deb
    exit 0;
fi

for fname in recipies/*sh; do
    $fname
done
