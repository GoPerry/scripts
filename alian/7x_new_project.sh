#!/bin/bash

echo "please enter name of the new project:"
read project

cd device/qcom/${project}                       
git clone git@192.168.10.91:/home/git/server/7x27a/device/qcom/${project}
rm -rf .git/
mv ${project}/.git .
rm -rf ${project}
git status
git add .
git commit -s -m "add new project ${project}"
git push origin master

cd ../../../vendor/huiye/${project}"_overlay"  
git clone git@192.168.10.91:/home/git/server/7x27a/platform/vendor/huiye/${project}"_overlay"
rm -rf .git/
mv ${project}"_overlay"/.git .
rm -rf ${project}"_overlay"
git status
git add .
git commit -s -m "add new project ${project}"
git push origin master

cd ../../../
repo forall bootable/bootloader/lk/ frameworks/base/ hardware/msm7k/ kernel/ packages/apps/FM/ packages/thirdparty/ system/core/ system/wlan/atheros/ vendor/qcom/android-open/ vendor/qcom/proprietary/bt/ vendor/qcom/proprietary/common/ vendor/qcom/proprietary/fm/ vendor/qcom/proprietary/gps/ vendor/qcom/proprietary/kernel-tests/ vendor/qcom/proprietary/mm-audio/ vendor/qcom/proprietary/mm-parser/ vendor/qcom/proprietary/modem-apis/ vendor/qcom/proprietary/oncrpc/ vendor/qcom/proprietary/prebuilt_HY11/ vendor/qcom/proprietary/qcril/ vendor/qcom/proprietary/qrdplus/ -p -c git status
repo forall bootable/bootloader/lk/ frameworks/base/ hardware/msm7k/ kernel/ packages/apps/FM/ packages/thirdparty/ system/core/ system/wlan/atheros/ vendor/qcom/android-open/ vendor/qcom/proprietary/bt/ vendor/qcom/proprietary/common/ vendor/qcom/proprietary/fm/ vendor/qcom/proprietary/gps/ vendor/qcom/proprietary/kernel-tests/ vendor/qcom/proprietary/mm-audio/ vendor/qcom/proprietary/mm-parser/ vendor/qcom/proprietary/modem-apis/ vendor/qcom/proprietary/oncrpc/ vendor/qcom/proprietary/prebuilt_HY11/ vendor/qcom/proprietary/qcril/ vendor/qcom/proprietary/qrdplus/ -p -c git add .
repo forall bootable/bootloader/lk/ frameworks/base/ hardware/msm7k/ kernel/ packages/apps/FM/ packages/thirdparty/ system/core/ system/wlan/atheros/ vendor/qcom/android-open/ vendor/qcom/proprietary/bt/ vendor/qcom/proprietary/common/ vendor/qcom/proprietary/fm/ vendor/qcom/proprietary/gps/ vendor/qcom/proprietary/kernel-tests/ vendor/qcom/proprietary/mm-audio/ vendor/qcom/proprietary/mm-parser/ vendor/qcom/proprietary/modem-apis/ vendor/qcom/proprietary/oncrpc/ vendor/qcom/proprietary/prebuilt_HY11/ vendor/qcom/proprietary/qcril/ vendor/qcom/proprietary/qrdplus/ -p -c git commit -s -m "add new project ${project}"
repo forall bootable/bootloader/lk/ frameworks/base/ hardware/msm7k/ kernel/ packages/apps/FM/ packages/thirdparty/ system/core/ system/wlan/atheros/ vendor/qcom/android-open/ vendor/qcom/proprietary/bt/ vendor/qcom/proprietary/common/ vendor/qcom/proprietary/fm/ vendor/qcom/proprietary/gps/ vendor/qcom/proprietary/kernel-tests/ vendor/qcom/proprietary/mm-audio/ vendor/qcom/proprietary/mm-parser/ vendor/qcom/proprietary/modem-apis/ vendor/qcom/proprietary/oncrpc/ vendor/qcom/proprietary/prebuilt_HY11/ vendor/qcom/proprietary/qcril/ vendor/qcom/proprietary/qrdplus/ -p -c git push 7x27a master

