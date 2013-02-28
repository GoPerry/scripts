#!/bin/bash
if [ $# -lt 1 ]; then
  echo "Usage:"
  echo "    autocopy.sh product_name product_flash modem_path"
  echo "Product:"
  echo "  msm7627a_d8 msm7627a_a8 msm7627a_v8 ..."
  echo "flash:"
  echo "  emmc or nand"
  exit;
fi

project=$1        #Parameter 1
compile_type=$2   #Parameter 2
version=`grep "ro.build.inter_version" device/qcom/$project/hymost.prop`   #obtain the version
version_length=${#version}           #obtain the length of version
version_last=${version:23}
#mount_104.sh
	#mount_175.sh
	echo "Do you want to copy modem ?(Y/N)"
	read copymodem
	echo "2"=$2
	echo compile_type=$compile_type
	if [[ "$copymodem" =  "Y" || "$copymodem" = "y" ]];then
		echo $project"    "$plateform
		echo "Please choose the modem path:"
		ls -t /modem_release
		read modem_path_1
		ls -t /modem_release/$modem_path_1
		read modem_path_2
	echo 2=$2
	echo compile_type=$compile_type
	
	else
		echo "Not copy modem!"
	fi

	if [[ "$complie_type" = "nand" ]]; then
		mkdir -p /mnt/$version_last/arm9
		mkdir -p /mnt/$version_last/arm11
		cp -p out/target/product/$project/appsboo*.mbn /mnt/$version_last/arm9
		cp -p out/target/product/$project/*.2knand.img /mnt/$version_last/arm11
			if [[ "$copymodem" =  "Y" || "$copymodem" = "y" ]];then
				cp -p /modem_release/$modem_path_1/$modem_path_2/* /mnt/$version_last/arm9

		echo 2=$2
	echo compile_type=$compile_type
			fi
	elif [[ "$compile_type" = "emmc" ]]; then
		mkdir -p /mnt/$version_last
		cp -p out/target/product/$project/*.xml /mnt/$version_last/
	    	cp -p out/target/product/$project/cache.img_* /mnt/$version_last/
    		cp -p out/target/product/$project/cache.img.ext4 /mnt/$version_last/ 
	    	cp -p out/target/product/$project/userdata.img_* /mnt/$version_last/
    		cp -p out/target/product/$project/system.img_* /mnt/$version_last/
	    	cp -p out/target/product/$project/emmc_appsboot*.mbn /mnt/$version_last/
    		cp -p out/target/product/$project/boot.img /mnt/$version_last/
	    	cp -p out/target/product/$project/recovery.img /mnt/$version_last/
    		cp -p out/target/product/$project/persist.img_* /mnt/$version_last/
	    	cp -p out/target/product/$project/persist.img.ext4 /mnt/$version_last/
			if [[ "$copymodem" =  "Y" || "$copymodem" = "y" ]];then
				cp -p /modem_release/$modem_path_1/$modem_path_2/* /mnt/$version_last
			fi
	echo 2=$2
	echo compile_type=$compile_type
	
	else
		echo "unknown type"
		exit
	fi
	echo 46"_"$PWD"_"$version"_"$modem_path_1"/"$modem_path_2 >>/mnt/log

