#!/bin/bash

echo "please enter name of the new project:"
read project

repo forall bootable/bootloader/lk/ device/qcom/ kernel/ package/thirdparty/ system/core/ vendor/huiye/ vendor/qcom/proprietary/ -p -c git status
repo forall bootable/bootloader/lk/ device/qcom/ kernel/ package/thirdparty/ system/core/ vendor/huiye/ vendor/qcom/proprietary/ -p -c git add .
repo forall bootable/bootloader/lk/ device/qcom/ kernel/ package/thirdparty/ system/core/ vendor/huiye/ vendor/qcom/proprietary/ -p -c git commit -s -m "add new project ${project}"
repo forall bootable/bootloader/lk/ device/qcom/ kernel/ package/thirdparty/ system/core/ vendor/huiye/ vendor/qcom/proprietary/ -p -c git push 7125a-app master

