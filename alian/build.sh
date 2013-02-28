#!/bin/bash
if [ $# -lt 1 ]; then
  echo "Usage:"
  echo "    build.sh product_name product_flash"
  echo "Product:"
  echo "  msm7627a_d8 msm7627a_a8 msm7627a_v8 ..."
  echo "flash:"
  echo "  emmc or nand"
  exit;
fi

project=$1        #Parameter 1
compile_type=$2   #Parameter 2
change_version=$3 #Parameter 3
tools=$4
build=$5
copymodem=$6
copylk=$7
modem_path_1=$8
modem_path_2=$9
version=`grep "ro.build.inter_version" device/qcom/$project/hymost.prop`   #obtain the version
plateform=`grep "ro.product.plateform" device/qcom/$project/hymost.prop`   #obtain the version
version_last=${version:23}
display=`grep "ro.build.display.id=" device/qcom/$project/hymost.prop`   #obtain the version
#date=`date +%Y%m%d`
date=`date`

copy()  #function copy
{
	#mount_104.sh
	#mount_175.sh
	if [[ ${copymodem} = "" ]];then echo "Do you want to copy modem ?(Y/N)" && read copymodem
	fi
	if [[ ${copylk} = "" ]];then echo "Do you want to copy lk/vmlinux/system.map ?(Y/N)" && read copylk
	fi
	
	fota=([1]=msm8x25_v12_bee_1 [2]=msm8x25_v10_w656 [3]=msm8x25_d10_e656 [4]=msm7627a_a8_5211 [5]=msm7627a_d7_5210d [6]=msm7627a_d7_5210a [7]=msm7627a_d7_5211_gd [8]=msm8x25_d12_bee_1 [9]=msm8x25_v12_bee_2 [10]=msm7627a_d7_5210d_gd )
	i=15
	while [ ${i} -ge 1 ];do
		if [[ ${project} = ${fota[i]} ]];then 
			copyfota=y
			break
		else
			copyfota=n
		fi
		let i=i-1
	done
	
	if [[ "$copymodem" =  "Y" || "$copymodem" = "y" ]];then
		echo $project"    "$plateform
		if [[ ${modem_path_1} = "" ]];then echo "Please choose the modem path:" && ls /modem_release && read modem_path_1
		fi
		if [[ ${modem_path_2} = "" ]];then ls -t /modem_release/$modem_path_1 && read modem_path_2
		fi
	else
		echo "Not copy modem!"
	fi

	if [[ "$compile_type" = "nand" ]];then
		echo "$version_last"
		mkdir -p /mnt/$version_last/arm9
		mkdir -p /mnt/$version_last/arm11
		cp -p out/target/product/$project/appsboo*.mbn /mnt/$version_last/arm9
		cp -p out/target/product/$project/*.2knand.img /mnt/$version_last/arm11
			if [[ "$copymodem" =  "Y" || "$copymodem" = "y" ]];then
				cp -p /modem_release/$modem_path_1/$modem_path_2/* /mnt/$version_last/arm9
			fi
	elif [[ "$compile_type" = "emmc" ]];then
		echo "$version_last"
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
#echo "$version_last"
#		mkdir -p /mnt/$version_last
#		cp -p out/target/product/$project/*.xml /mnt/$version_last/
#	    	cp -p out/target/product/$project/cache_* /mnt/$version_last/
#    		cp -p out/target/product/$project/cache.img /mnt/$version_last/ 
#	    	cp -p out/target/product/$project/userdata_* /mnt/$version_last/
#    		cp -p out/target/product/$project/system_* /mnt/$version_last/
#	    	cp -p out/target/product/$project/emmc_appsboot*.mbn /mnt/$version_last/
#    		cp -p out/target/product/$project/boot.img /mnt/$version_last/
#	    	cp -p out/target/product/$project/recovery.img /mnt/$version_last/
#    		cp -p out/target/product/$project/persist_* /mnt/$version_last/
#	    	cp -p out/target/product/$project/persist.img /mnt/$version_last/
#			if [[ "$copymodem" =  "Y" || "$copymodem" = "y" ]];then
#				cp -p /modem_release/$modem_path_1/$modem_path_2/* /mnt/$version_last
#			fi
		else
			echo "unknown type!"
		exit
	fi
        if [[ "$copyfota" =  "Y" || "$copyfota" = "y" ]];then
                cp -p out/target/product/${project}/adups-otaPackage.zip /mnt/fota/$version_last"_adups-otaPackage.zip"
		if [[ ${project} = "msm7627a_a8_5211" || ${project} = "msm7627a_d7_5210d" || ${project} = "msm7627a_d7_5210a" || ${project} = "msm7627a_a8_5211_gd" || ${project} = "msm7627a_d7_5210d_gd"  ]];then
	                cp -p out/target/product/${project}/adups-otaPackage.zip /mnt/${version_last}/$version_last"_adups-otaPackage.zip"
		fi
        else
                echo "Not copy fota!" 
        fi
	if [[ "$copylk" =  "Y" || "$copylk" = "y" ]];then
		if [[ "$compile_type" = "emmc" ]];then 
			cp -p out/target/product/$project/obj/EMMC_BOOTLOADER_OBJ/build-${project}/lk /mnt/$version_last
		else
			cp -p out/target/product/$project/obj/BOOTLOADER_OBJ/build-${project}/lk /mnt/$version_last
		fi
                cp -p out/target/product/$project/obj/KERNEL_OBJ/vmlinux /mnt/$version_last
              	cp -p out/target/product/$project/obj/KERNEL_OBJ/System.map /mnt/$version_last
	else 
		echo "Not copy lk/vmlinux/system.map!" 
	fi

	echo $date"  "$project"  "46"  "$PWD"  "$version"  "$display"  "$modem_path_1"/"$modem_path_2 >>/mnt/log.txt
}

build()    # function build
{	
	if [[ ${build} = "" ]];then echo "Do you want to build?(Y/N)"  && read build
	fi
	
	if [[ "$build" = "Y" || "$build" = "y" ]];then
		if [[ ${project} = "msm7627a_a8_5211" || ${project} = "msm7627a_d7_5210d" || ${project} = "msm7627a_d7_5210a" || ${project} = "msm7627a_a8_5211_gd" || ${project} = "msm7627a_d7_5210d_gd"  ]];then
			vim odexbuild.sh
			./odexbuild.sh $project $compile_type
		else
	                vim autobuild.sh
        	        ./autobuild.sh $project $compile_type
		fi
	else
		echo "Not build!"
	fi
}

updateversion()  #function updateversion
{
	if [[ ${change_version} = "" ]];then echo "Do you want to change version?(Y/N)" && read change_version 
	fi

	if [[ "$change_version" = "Y" ||  "$change_version" = "y" ]];then
		vim device/qcom/$project/hymost.prop
		version=`grep "ro.build.inter_version" device/qcom/$project/hymost.prop`   #obtain the version
		version_last=${version:23}
		echo "$version_last"
		display=`grep "ro.build.display.id=" device/qcom/$project/hymost.prop`   #obtain the version
		if [[ ${tools} = "" ]];then echo "Which version control tools is used ?(git/repo)" && read tools
		fi
		
		if [[ ${tools} = "git" ]];then
			git add device/qcom/$project/hymost.prop
			git pull
			git commit -s -m "update version for $project"
			git push
			git tag -u xuguilian $project/$version_last -m "Version $version_last"
		elif [[ ${tools} = "repo" ]];then
			if [[ ${project} = "msm7627a_e7_d8800" || ${project} = "msm7627a_e7_e6plus" || ${project} = "msm7627a_e11_te800s_g" ]];then
				repo forall device/qcom -p -c git add ${project}/hymost.prop
				repo forall device/qcom -p -c git commit -s -m "update version for $project"
				repo forall -p -c git tag -u xuguilian $project/$version_last -m "Version $version_last"
				repo upload --re=yuanwei device/qcom
			else
			repo forall device/qcom/$project -p -c git add hymost.prop
			repo forall device/qcom/$project -p -c git commit -s -m "update version for $project"
			repo forall -p -c git tag -u xuguilian $project/$version_last -m "Version $version_last"
			repo upload --re=yuanwei device/qcom/$project 	
			fi
		else
			echo "Unknow tools !"
			echo "Would you like to choose again ?(Y/N)"
			read again
			if [[ ${again} = "y" || ${again} = "Y" ]];then
				tools=""
				updateversion
			else
				exit
			fi
		fi
	else
		echo "Not change version !"
	fi

}

updateversion

build

copy
