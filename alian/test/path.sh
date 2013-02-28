#!/bin/bash

#ls >test.txt 
##vim test.txt
#file=1
#read1() 
#{
#	
#	exec < test.txt
#	num=`wc -l test.txt | awk '{print $1}'`
#	echo ${num}
#	if [[ ${num} -ne 0 ]];then
#		read a1
#		path=${a1}
#		echo ${path}
##		file=`cd ${path}`
#		sed -i '1d' test.txt
#	fi
#}
#if [[ ${file} != "" ]];then
#	read1
#fi	
##until [  ]


path() 
{
for path1 in ` ls $1 `
do
#	echo $path1
	for path2 in ` ls ${path1}`
	do
		#echo $1
		if [[ -d $1 ]];then
			echo `dirname ${path1}`
			path $1"/"${path1}
		else
			dirname ${path1} >>~/path		
			path_1=`dirname ${path1}`
			path `dirname ${path_1}`
		fi
	done
done
}

path .
