#!/bin/bash
setterm -clear
echo -e "\e[1mBUILD HAS STARTED\e[0m"
echo "Cleaning stuff"
make clean && make mrproper
z="/home/dhanush911gtr/kernel/kenel.zip"
if [ -e $z ]
then
echo "Removing previous zip leftovers"
rm kernel.zip
rm ../kerzip/tools/dt.img
rm ../kerzip/system/lib/modules/wlan.ko
rm ../kerzip/tools/Image
fi
BUILD_START=$(date +"%s")
KERNEL_DIR=$PWD
DTBTOOL=$KERNEL_DIR/tools/dtbToolCM
blue='\033[0;34m' cyan='\033[0;36m'
yellow='\033[0;33m'
red='\033[0;31m'
nocol='\033[0m'
echo "Starting"
export KBUILD_BUILD_USER="Ded_Boi"
export KBUILD_BUILD_HOST="Beefy_PC"
export ARCH=arm64
export SUBARCH=arm64
export CROSS_COMPILE=/home/dhanush911gtr/uberlinaro4.9/bin/aarch64-linux-android-
make lineageos_tomato_defconfig
echo "Making"
make -j2 | tee $HOME/output.txt
cd $HOME
mv output.txt "Output.txt"
gdrive upload "Output.txt"
cd kernel
echo "Making dt.img"
$DTBTOOL -2 -o $KERNEL_DIR/arch/arm64/boot/dt.img -s 2048 -p $KERNEL_DIR/scripts/dtc/ $KERNEL_DIR/arch/arm/boot/dts/
setterm -clear
echo "Done"
BUILD_END=$(date +"%s")
DIFF=$(($BUILD_END - $BUILD_START))
echo -e "$yellow Build completed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds.$nocol"
echo "Checking if kernel image is successfully built..."
f="/home/dhanush911gtr/kernel/arch/arm64/boot/Image"
i="0"
if [ -e $f ]
then
echo -e "\e[1mBUILD SUCCESS\e[0m"
echo "Movings Files"
rm ../kerzip/kernel.zip
mv arch/arm64/boot/Image ../kerzip/tools/Image
mv arch/arm64/boot/dt.img ../kerzip/tools/dt.img
mv drivers/staging/prima/wlan.ko ../kerzip/system/lib/modules/wlan.ko
echo "Making Zip"
cd ../kerzip
zip -r kernel *
echo "Uploading to Gdrive"
gdrive upload kernel.zip
echo "All shits are done, check your Drive"
else
echo -e "\e[1mBUILD FUCKED UP\e[0m"
fi
