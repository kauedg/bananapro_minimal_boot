#!/bin/bash

BUILD_TARGET="Bananapro_defconfig"

cd u-boot

make CROSS_COMPILE=arm-linux-gnueabihf- ${BUILD_TARGET}
#make CROSS_COMPILE=arm-linux-gnueabihf- menuconfig
make CROSS_COMPILE=arm-linux-gnueabihf-
