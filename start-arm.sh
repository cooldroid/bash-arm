#!/bin/sh
./configure --prefix=/media/android/bash-arm --host=arm-linux-gnueabihf --enable-static-link --without-bash-malloc --enable-largefile --enable-alias --enable-history
if test -f ./Makefile; then
	find . -name "Makefile" -print0 | xargs -0 sed -i -e s/'CFLAGS = -g -O2'/'CFLAGS = -g -O2 -static'/g
	make && strip --strip-unneeded ./bash
fi
