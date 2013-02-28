#!/bin/bash

if [ $# -ne 2 ]; then
    echo "Usage:"
    echo "    ./new_project project_name old_project, such as msm7627a_e7_e6 msm7627a_d12_e757"
    exit
fi

PRODUCT=$1
CLONEPROJECT=$2

if [ `expr "$PRODUCT" : 'msm7627a'` -eq 0 ]; then
    echo "Error: project name prefix must be msm7627a"
    exit
fi

echo "Strart create $PRODUCT project..."

# 1. create device description
cp -af device/qcom/${CLONEPROJECT} device/qcom/${PRODUCT}

# update project makefile
mv device/qcom/${PRODUCT}/${CLONEPROJECT}.mk device/qcom/${PRODUCT}/${PRODUCT}.mk

# update project name
for F in `find device/qcom/$PRODUCT/ -name "*.cmm"`
do
    echo "$F"
    sed -i "s/${CLONEPROJECT}/${PRODUCT}/g" $F
done

# N.B. pls. double check kernel defconfig
for F in `find device/qcom/$PRODUCT/ -name "*.mk"`
do
    echo "$F"
    sed -i "s/${CLONEPROJECT}/${PRODUCT}/g" $F
done
#if use msm7627a as CLONEPROJECT,must  
sed -i "s/${PRODUCT}/msm7627a/g" device/qcom/${PRODUCT}/BoardConfig.mk

for F in `find device/qcom/$PRODUCT/ -name "*.prop"`
do
    echo "$F"
    sed -i "s/${CLONEPROJECT}/${PRODUCT}/g" $F
done

# 2. update external & kernel
# ftm_fm_pfal_linux.c
cp -af kernel/arch/arm/configs/${CLONEPROJECT}-perf_defconfig kernel/arch/arm/configs/${PRODUCT}-perf_defconfig

# 3. update lk
cp bootable/bootloader/lk/project/${CLONEPROJECT}.mk bootable/bootloader/lk/project/${PRODUCT}.mk
cp bootable/bootloader/lk/project/${CLONEPROJECT}_nandwrite.mk bootable/bootloader/lk/project/${PRODUCT}_nandwrite.mk
sed -i "s/${CLONEPROJECT}/${PRODUCT}/g" bootable/bootloader/lk/project/${PRODUCT}.mk
sed -i "s/${CLONEPROJECT}/${PRODUCT}/g" bootable/bootloader/lk/project/${PRODUCT}_nandwrite.mk

cp -af bootable/bootloader/lk/target/${CLONEPROJECT} bootable/bootloader/lk/target/${PRODUCT}

# 4. update frameworks
#sed -i "s/\(\"${CLONEPROJECT}\"\)/\1,\"${PRODUCT}\"/g" frameworks/base/core/java/android/server/BluetoothAdapterStateMachine.java

# ./frameworks/base/media/libmediaplayerservice/nuplayer/NuPlayer.cpp:782
# ./frameworks/base/media/libmediaplayerservice/StagefrightRecorder.cpp:1527
# ./frameworks/base/media/libstagefright/mpeg2ts/ESQueue.cpp:45

# 5. update hardware

# ./hardware/qcom/camera/QualcommCameraHardware.cpp:297
# ./hardware/qcom/camera/QualcommCameraHardware.cpp:1265
# ./hardware/qcom/camera/QualcommCameraHardware.cpp:10173
# ./hardware/qcom/media/audio/msm7627a/Android.mk:39
# ./hardware/qcom/media/audio/msm7627a/Android.mk:74
# ./hardware/qcom/media/audio/Android.mk:11
# ./hardware/qcom/media/audio/Android.mk:12
# ./hardware/qcom/display/libcopybit/Android.mk:40
# ./hardware/msm7k/Android.mk:35

# 6. update system
for F in `find system/core/rootdir/etc -name "*.sh"`
do
    echo "$F"
    sed -i "s/\(\"${CLONEPROJECT}\"\)/\1 | \"${PRODUCT}\"/g" $F
done

# 7. update vendor
for F in `find vendor/qcom/proprietary/kernel-tests -name "*.mk"`
do
    echo "$F"
    sed -i "s/\(${CLONEPROJECT} \)/\1${PRODUCT} /g" $F
done

cp -rf vendor/qcom/proprietary/prebuilt_HY11/target/product/${CLONEPROJECT} vendor/qcom/proprietary/prebuilt_HY11/target/product/${PRODUCT}
# ignore 
# ./vendor/qcom/proprietary/kernel-tests/qcedev/Android.mk:6
# ./vendor/qcom/proprietary/kernel-tests/Android.mk:8

# ./vendor/qcom/proprietary/mm-audio
#  ./vendor/qcom/proprietary/oncrpc
# ./vendor/qcom/proprietary/qcril
# ./vendor/qcom/proprietary/bt
# ./vendor/qcom/proprietary/gps

# update modem-apis
#ln -sf vendor/qcom/proprietary/modem-apis/${CLONEPROJECT} vendor/qcom/proprietary/modem-apis/${PRODUCT}

cp -rf vendor/qcom/proprietary/modem-apis/${CLONEPROJECT} vendor/qcom/proprietary/modem-apis/${PRODUCT}
# ./vendor/qcom/proprietary/mm-video
# ./vendor/qcom/proprietary/ts_firmware
# ./vendor/qcom/proprietary/ftm
# ./vendor/qcom/proprietary/wlan

# ./vendor/qcom/proprietary/qrdplus

for F in `find ./vendor/qcom/proprietary/common/config -name "*.mk"`
do
    echo "$F"
    sed -i "s/\(\<${CLONEPROJECT}\>\)/\1 ${PRODUCT}/g" $F
done

# ./vendor/qcom/proprietary/common/build
# ./vendor/qcom/proprietary/mm-camera
# ./vendor/qcom/proprietary/fm
# ./vendor/qcom/opensource
# ./vendor/qcom/android-open

# 7. update thidparty
cp -af packages/thirdparty/${CLONEPROJECT} packages/thirdparty/${PRODUCT}
sed -i "s/${CLONEPROJECT}/${PRODUCT}/g" packages/thirdparty/${PRODUCT}/Android.mk

# 8. update overlay
cp -af vendor/huiye/${CLONEPROJECT}_overlay vendor/huiye/${PRODUCT}_overlay

# 9. update rootdir
#cp -af system/core/rootdir/${CLONEPROJECT} system/core/rootdir/${PRODUCT}
#sed -i "s/${CLONEPROJECT}/${PRODUCT}/g" sys	tem/core/rootdir/${PRODUCT}/Android.mk

# add ingore file for git 
#    sed -i "9i device/qcom/${new_project}/radio/".gitignore 
#    sed -i "2i bootable/bootloader/lk/target/${new_project}/tools/mkheader".gitignore

