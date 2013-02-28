#!/bin/bash

find -name "*.*" > ~/file.txt
#cp ~/file.txt ~/file1.txt
num=1
while [ ${num} -gt 0 ]
do
	exec < ~/file.txt
	num=`wc -l ~/file.txt | awk '{print $1}'`
#	echo ${num}
	if [[ ${num} -gt 0 ]];then
		read a1
#		echo $a1
		path=${a1}
		dirname ${path} >>path.txt
		sed -i '1d' ~/file.txt
	fi
done
#rm -rf ~/file.txt
sort path.txt | uniq >path
rm -rf path.txt
