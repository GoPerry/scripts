#!/bin/bash
adb reboot-bootloader
project=$2

IMG_DIR=./out/target/product/$project
FASTBOOT=./out/host/linux-x86/bin/fastboot
IMG_EXT=.2knand

while [ $# -gt 0 ]; do
  case "$1" in
    boot)
      echo "flash $1 image..."
      $FASTBOOT flash $1 $IMG_DIR/$1$IMG_EXT.img
      shift 1
      ;;
    system)
      echo "flash $1 image..."
      $FASTBOOT flash $1 $IMG_DIR/$1$IMG_EXT.img
      shift 1
      ;;
    userdata)
      echo "flash $1 image..."
      $FASTBOOT flash $1 $IMG_DIR/$1$IMG_EXT.img
      shift 1
      ;;
    recovery)
      echo "flash $1 image..."
      $FASTBOOT flash $1 $IMG_DIR/$1$IMG_EXT.img
      shift 1
      ;;
    persist)
      echo "flash $1 image..."
      $FASTBOOT flash $1 $IMG_DIR/$1$IMG_EXT.img
      shift 1
      ;;
    all)
      echo "flash $1 images..."
      $FASTBOOT flash boot $IMG_DIR/boot$IMG_EXT.img
      $FASTBOOT flash system $IMG_DIR/system$IMG_EXT.img
      $FASTBOOT flash userdata $IMG_DIR/userdata$IMG_EXT.img
      $FASTBOOT flash recovery $IMG_DIR/recovery$IMG_EXT.img
      $FASTBOOT flash persist $IMG_DIR/persist$IMG_EXT.img
      $FASTBOOT reboot
      shift 1
      ;;
    reboot)
      $FASTBOOT reboot
      shift 1
      ;;
  esac
done

exit
