#!/bin/bash

echo "please enter name of the new project:"
read project


if [[ $1 = "7x" ]];then
	ssh -p 29418 yuanwei@192.168.10.91 gerrit create-project 7x27a/platform/vendor/huiye/$project"_overlay"
	ssh -p 29418 yuanwei@192.168.10.91 gerrit create-project 7x27a/device/qcom/$project

elif [[ $1 = "8x" ]];then
	ssh -p 29418 yuanwei@192.168.10.91 gerrit create-project 8x25/vendor/huiye/${project}"_overlay" 
	ssh -p 29418 yuanwei@192.168.10.91 gerrit create-project 8x25/device/qcom/${project}
	ssh -p 29418 yuanwei@192.168.10.91 gerrit create-project 8x25/packages/thirdparty/${project} 
else
	echo "Unknown type!"
fi

