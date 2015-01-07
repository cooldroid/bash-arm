#!/bin/sh

CC_LOC="/media/android/toolchain/ndk/aarch64-linux-android"
TRIPLE=`ls ${CC_LOC}/bin | grep -E "aarch64.+linux-.+gcc$" | awk -F-gcc '{print $1}'`

export PATH=${CC_LOC}/bin:$PATH
export CC="$CC_LOC/bin/${TRIPLE}-gcc"
export CXX="$CC_LOC/bin/${TRIPLE}-g++"

CMD_PREFIX="ARCH=arm64 LDFLAGS=\"-static\" CFLAGS=\"-Os -static\""

eval $CMD_PREFIX ./configure --prefix=/system/xbin --host=${TRIPLE} --enable-static-link --disable-multibyte \
	--enable-direxpand-default --without-bash-malloc --enable-largefile --enable-alias --enable-history
if test -f ./Makefile; then
	#find . -name "Makefile" -print0 | xargs -0 sed -i -e s/'CFLAGS = -g -Os'/'CFLAGS = -g -Os -static'/g
	eval $CMD_PREFIX make -j4 "$@"
fi
if [ -f ./bash ]; then
	$CC_LOC/bin/${TRIPLE}-strip --strip-unneeded ./bash
fi
