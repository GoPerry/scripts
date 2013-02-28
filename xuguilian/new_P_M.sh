#!/bin/bash
echo "Please enter the project name:"
read project
git pull

if [[ $1 = "7x" ]];then
	sed -i '$i \<project name="7x27a/device/qcom/'$project'"  path="device/qcom/'$project'"  />' default.xml
	sed -i '$i\<project name="7x27a/platform/vendor/huiye/'$project'_overlay"  path="vendor/huiye/'$project'_overlay"  />' default.xml

elif [[ $1 = "8x" ]];then
	sed -i '$i \<project name="8x25/device/qcom/'$project'"  path="device/qcom/'$project'"  />' default.xml
	sed -i '$i\<project name="8x25/packages/thirdparty/'$project'"  path="packages/thirdparty/'$project'"  />' default.xml
	sed -i '$i\<project name="8x25/vendor/huiye/'$project'_overlay"  path="vendor/huiye/'$project'_overlay"  />' default.xml
fi

git pull
git add default.xml
git ci -m "add new project $project"
git push
