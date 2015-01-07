#!/bin/sh

NDK=/media/android/android-ndk-r10e
API=19
CC_LOC="${NDK}/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64"
SYSPREFIX="${NDK}/platforms/android-${API}/arch-arm"
TRIPLE=`ls ${CC_LOC}/bin | grep -E "arm.+linux-.+gcc$" | awk -F-gcc '{print $1}'`

export PATH=${CC_LOC}/bin:$PATH
export CC="$CC_LOC/bin/${TRIPLE}-gcc --sysroot=${SYSPREFIX} -D__ANDROID_API__=$API"

CMD_PREFIX="ARCH=arm LDFLAGS=\"-static\" CFLAGS=\"-Os -static\""

eval $CMD_PREFIX ./configure --prefix=/system/xbin --host=${TRIPLE} --enable-static-link \
	--enable-direxpand-default --without-bash-malloc --enable-largefile --enable-alias --enable-history
if test -f ./Makefile; then
	#find . -name "Makefile" -print0 | xargs -0 sed -i -e s/'CFLAGS = -g -Os'/'CFLAGS = -g -Os -static'/g
	eval $CMD_PREFIX make -j4 "$@"
	$CC_LOC/bin/${TRIPLE}-strip --strip-unneeded ./bash
fi
