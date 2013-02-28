#!/bin/bash

echo "please enter name of the new project:"
read project

cd device/qcom/${project}                       
git clone git@192.168.10.91:/home/git/server/8x25/device/qcom/${project}
rm -rf .git/
mv ${project}/.git .
rm -rf ${project}
git status
git add .
git commit -s -m "add new project ${project}"
git push origin master

cd ../../../vendor/huiye/${project}"_overlay"  
git clone git@192.168.10.91:/home/git/server/8x25/vendor/huiye/${project}"_overlay"
rm -rf .git/
mv ${project}"_overlay"/.git .
rm -rf ${project}"_overlay"
git status
git add .
git commit -s -m "add new project ${project}"
git push origin master

cd ../../../packages/thirdparty/$project 
git clone git@192.168.10.91:/home/git/server/8x25/packages/thirdparty/$project 
rm -rf .git/
mv ${project}/.git . 
rm -rf ${project}
git status
git add .
git commit -s -m "add new project ${project}"
git push origin master

cd ../../../
repo forall bootable/bootloader/lk/ frameworks/base/ kernel/ system/core/ vendor/qcom/proprietary/common/ vendor/qcom/proprietary/kernel-tests/ vendor/qcom/proprietary/modem-apis/ vendor/qcom/proprietary/wlan/ -p -c git status
repo forall bootable/bootloader/lk/ frameworks/base/ kernel/ system/core/ vendor/qcom/proprietary/common/ vendor/qcom/proprietary/kernel-tests/ vendor/qcom/proprietary/modem-apis/ vendor/qcom/proprietary/wlan/ -p -c git add .
repo forall bootable/bootloader/lk/ frameworks/base/ kernel/ system/core/ vendor/qcom/proprietary/common/ vendor/qcom/proprietary/kernel-tests/ vendor/qcom/proprietary/modem-apis/ vendor/qcom/proprietary/wlan/ -p -c git ci -m "add new project ${project}"
repo forall bootable/bootloader/lk/ frameworks/base/ kernel/ system/core/ vendor/qcom/proprietary/common/ vendor/qcom/proprietary/kernel-tests/ vendor/qcom/proprietary/modem-apis/ vendor/qcom/proprietary/wlan/ -p -c git push 8x25 master

