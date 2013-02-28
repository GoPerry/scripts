#!/bin/bash
project=$1        #Parameter 1
change_version=$2 #Parameter 3


git checkout .
git pull origin master
version_old=`grep "ro.build.inter_version" device/qcom/$project/hymost.prop`   #obtain the version of old
version_length=${#version_old}           #obtain the length of version_old
version_part1=${version_old:0:$version_length-14}    #obtain the part1 of version_old
version_part2_old=${version_old:$version_length-14}  #obtain the part2 of vesion_old
date=`date +%Y%m%d`                          #obtain the date of today
version_middle=${version_old:23:$version_length-37}
version_part2_s_old=${version_part2_old:4:1}  #obtain the old small version of part2
version_part2_s_new=0         #set the default number to the new small version of part2 
version_part2_b_old=${version_part2_old:1:1}   #obtain the old big vesion of part2
version_part2_b_new=0         #set the default number to the new big version of part2
if [[ "$2" = "ALL" ]];then    #if Parameter 3=ALL then execute below
	echo $version_old  #print old version
	eval version_part2_s_new=`awk 'BEGIN{print ("'$version_part2_s_old'"+0+1)}'`  #change the version_s_old to number and +1 to change to new
	area=9          #the most big version_small is 9
	if(("$version_part2_s_new"<="$area")); then   #if the new version of small part2 <=9 then execute below
		version_part2_new="V"$version_part2_b_old"_0"$version_part2_s_new"_"$date  #obtain the new version_part2
	else    #if the new version of small part2 >9 then execute below
		eval version_b_new=`awk 'BEGIN{print ("'$version_part2_b_old'"+0+1)}'`   #change the version_b_old to number and +1 to become new
		version_part2_s_new=0
		version_part2_new="V"$version_part2_b_new"_0"$version_part2_s_new"_"$date  #obtain the new version_part2
	fi
	version_new=$version_part1$version_part2_new   #obtain the new version
	echo $version_new
	sed -i "s/$version_old/$version_new/g" device/qcom/$project/hymost.prop  #modify file
	git add device/qcom/$project/hymost.prop
	git commit -m "update version for "$project
	git push origin master
elif [[ "$2" = "DATE" ]]; then   #if Parameter 3=DATE then execute below
	echo $version_part2_b_old
	version_part2_new="V"$version_part2_b_old"_0"$version_part2_s_old"_"$date  #change the version_part2
	version_new=$version_part1$version_part2_new   #obtain the new version
	sed -i "s/$version_old/$version_new/g" device/qcom/$project/hymost.prop    #modify file
	echo $version_new
	git add device/qcom/$project/hymost.prop 
	git commit -m "update version for "$project
	git push origin master
	git tag -d $version_old
else    #if Parameter 3=anything other then don't modify version
	version_part2_new=$version_part2_old
	version_new=$version_old
	echo $version_new $version_length
	git tag -d $version_old
fi
git tag $version_middle$version_part2_new
