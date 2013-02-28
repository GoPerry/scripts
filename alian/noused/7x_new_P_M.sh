#!/bin/bash
echo "Please enter the project name:"
read project
git pull


sed -i '$i \<project name="7x27a/device/qcom/'$project'"  path="device/qcom/'$project'"  />' default.xml
sed -i '$i\<project name="7x27a/platform/vendor/huiye/'$project'_overlay"  path="vendor/huiye/'$project'_overlay"  />' default.xml

git pull
git add default.xml
git ci -m "add new project $project"
git push
