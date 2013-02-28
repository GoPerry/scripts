#!/bin/bash
for i in `ls -d msm8x25*/`
	do 
		cp -rf msm7627a_d9_s9300/.gitignore $i
		cd /home/release/8x25_repo/8x25_repo4/device/qcom/$i
		git add .gitignore
		git ci -m "add .gitignore"
		git push
	done
