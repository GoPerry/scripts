#!/bin/bash

echo "please enter name of the new project:"
read project

ssh -p 29418 yuanwei@192.168.10.91 gerrit create-project 8x25/vendor/huiye/${project}"_overlay" 
ssh -p 29418 yuanwei@192.168.10.91 gerrit create-project 8x25/device/qcom/${project}
ssh -p 29418 yuanwei@192.168.10.91 gerrit create-project 8x25/packages/thirdparty/${project} 
