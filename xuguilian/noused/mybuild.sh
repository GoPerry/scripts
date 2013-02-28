#!/bin/bash
if [ $# -lt 2 ]; then
  echo "Usage:"
  echo "    mybuild.sh product_name product_flash"
  echo "Product:"
  echo "  msm7627a_d8 msm7627a_a8 msm7627a_v8 ..."
  echo "flash:"
  echo "  emmc or nand"
  exit;
fi

project=$1        #Parameter 1
complie_type=$2   #Parameter 2
version_length=${#version}           #obtain the length of version
version=`grep "ro.build.inter_version" device/qcom/$project/hymost.prop`   #obtain the version
plateform=`grep "ro.product.plateform" device/qcom/$project/hymost.prop`   #obtain the version
version_last=${version:23}

mycopy()  #function mycopy
{
	mount_104.sh
	mount_175.sh
	
	if [[ "$2" = "nand" ]]; then
		mkdir -p /mnt/$version_last/arm9
		mkdir -p /mnt/$version_last/arm11
		cp -p out/target/product/$project/appsboo*.mbn /mnt/$version_last/arm9
		cp -p out/target/product/$project/*.2knand.img /mnt/$version_last/arm11
		cp -p /modem_release/$modem_path_1/$modem_path_2/* /mnt/$version_last/arm9
	elif [[ "$2" = "emmc" ]]; then
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
		cp -p /modem_release/$modem_path_1/$modem_path_2/* /mnt/$version_last
	else
		echo "unknown type"
		exit
	fi
	echo 46"_"$PWD"_"$version"_"$modem_path >>/mnt/log
}

mybuild()    # function mybuild
{	
	./autobuild.sh $project $compile_type
}

myupdateversion()  #function myupdateversion

{
	updisplayid="y"
	
	KONKA=([1]=msm7627a_d7_eg350)
	K_TOUCH=([1]=msm7627a_v12_s757 [2]=msm7627a_e7_d8800 [3]=msm7627a_v7_w655 [4]=msm8x25_v12_s757 [5]=msm7627a_d7_5916c [6]=msm8x25_v10_w656 [7]=msm8x25_d10_e656)
	
	case $project in
			${K_TOUCH[*]}
				$updisplayid="n"			
			;;
			${KONKA[*]}
				

			;;
	esac		
		




git add device/qcom/$project/hymost.prop
		git pull
		git commit -m "update version for $project"
		git push
		git tag $version_last
	else
		echo "Not change version !"
	fi
}

myupdateversion

mybuild

mycopy

