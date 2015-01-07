#!/bin/sh

CC_LOC="/media/android/toolchain/gcc-linaro-7.3.1-2018.05-x86_64_aarch64-linux-gnu"
SYSPREFIX="/media/android/toolchain/sysroot-glibc-linaro-2.25-2018.05-aarch64-linux-gnu"
TRIPLE=`ls ${CC_LOC}/bin | grep -E "aarch64.+linux-.+gcc$" | awk -F-gcc '{print $1}'`

export PATH=${CC_LOC}/bin:$PATH
export CC="$CC_LOC/bin/${TRIPLE}-gcc --sysroot=${SYSPREFIX}"

CMD_PREFIX="LD_LIBRARY_PATH=${CC_LOC}/lib ARCH=arm LDFLAGS=\"-static\" CFLAGS=\"-Os -static -I${CC_LOC}/include\""

eval $CMD_PREFIX ./configure --prefix=/media/android/bash-arm --host=${TRIPLE} --enable-static-link --enable-direxpand-default --without-bash-malloc --enable-largefile --enable-alias --enable-history
if test -f ./Makefile; then
	#find . -name "Makefile" -print0 | xargs -0 sed -i -e s/'CFLAGS = -g -Os'/'CFLAGS = -g -Os -static'/g
	eval $CMD_PREFIX make -j4 "$@"
	$CC_LOC/bin/${TRIPLE}-strip --strip-unneeded ./bash
fi
