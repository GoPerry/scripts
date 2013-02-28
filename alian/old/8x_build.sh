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
version=`grep "ro.build.inter_version" device/qcom/$project/hymost.prop`   #obtain the version
plateform=`grep "ro.product.plateform" device/qcom/$project/hymost.prop`   #obtain the version
version_last=${version:23}
display=`grep "ro.build.display.id=" device/qcom/$project/hymost.prop`   #obtain the version
#date=`date +%Y%m%d`
date=`date`

copy()  #function copy
{
	mount_104.sh
	mount_175.sh
	echo "Do you want to copy modem ?(Y/N)"
	read copymodem
        echo "Do you want to copy lk/vmlinux/system.map ?(Y/N)"
        read copylk
        echo "Do you want to copy adups-otaPackage.zip ?(Y/N)"
        read copyfota
	if [[ "$copymodem" =  "Y" || "$copymodem" = "y" ]];then
		echo $project"    "$plateform
		echo "Please choose the modem path:"
		ls /modem_release
		read modem_path_1
		ls -t /modem_release/$modem_path_1
		read modem_path_2
	else
		echo "Not copy modem!"
	fi

	if [ "$compile_type" = "nand" ];then
		echo "$version_last"
		mkdir -p /mnt/$version_last/arm9
		mkdir -p /mnt/$version_last/arm11
		cp -p out/target/product/$project/appsboo*.mbn /mnt/$version_last/arm9
		cp -p out/target/product/$project/*.2knand.img /mnt/$version_last/arm11
			if [[ "$copymodem" =  "Y" || "$copymodem" = "y" ]];then
				cp -p /modem_release/$modem_path_1/$modem_path_2/* /mnt/$version_last/arm9
			fi
                        if [[ "$copylk" =  "Y" || "$copylk" = "y" ]];then
                                cp out/target/product/msm7627a_sku3/obj/KERNEL_OBJ/System.map /mnt/$version_last
                                cp out/target/product/msm7627a_sku3/obj/KERNEL_OBJ/vmlinux /mnt/$version_last
                                cp out/target/product/msm7627a_sku3/obj/BOOTLOADER_OBJ/build-${project}/lk /mnt/$version_last
                        else
                                echo "Not copy lk/vmlinux/system.map!" 
                        fi
	elif [ "$compile_type" = "emmc" ];then
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
                        if [[ "$copylk" =  "Y" || "$copylk" = "y" ]];then
                                 cp out/target/product/$project/obj/EMMC_BOOTLOADER_OBJ/build-${project}/lk /mnt/$version_last
                                 cp out/target/product/$project/obj/KERNEL_OBJ/vmlinux /mnt/$version_last
                                 cp out/target/product/$project/obj/KERNEL_OBJ/System.map /mnt/$version_last
 
                         else
                                 echo "Not copy lk/vmlinux/system.map!" 
                         fi
	else
		echo "unknown type"
		exit
	fi
	if [[ "$copyfota" =  "Y" || "$copyfota" = "y" ]];then
                cp out/target/product/${project}/adups-otaPackage.zip /mnt/fota/$version_last"_adups-otaPackage.zip"
	else
		echo "Not copy fota!" 
	fi
	echo $date"  "$project"  "46"  "$PWD"  "$version"  "$display"  "$modem_path_1"/"$modem_path_2 >>/mnt/log.txt
}

build()    # function build
{	
	echo "Do you want to build?(Y/N)"
	read build
	if [[ "$build" = "Y" || "$build" = "y" ]];then
		vim autobuild.sh
		./autobuild.sh $project $compile_type
	else
		echo "Not build!"
	fi
}

updateversion()  #function updateversion
{
	echo "Do you want to change version?(Y/N)"
	read change_version
	if [[ "$change_version" = "Y" ||  "$change_version" = "y" ]];then
		vim device/qcom/$project/hymost.prop
		version=`grep "ro.build.inter_version" device/qcom/$project/hymost.prop`   #obtain the version
		version_last=${version:23}
		echo "$version_last"
		display=`grep "ro.build.display.id=" device/qcom/$project/hymost.prop`   #obtain the version
	#	git add device/qcom/$project/hymost.prop
	#	git pull
	#	git commit -s -m "update version for $project"
	#	git push	
		repo forall device/qcom/$project -p -c git add hymost.prop
		repo forall device/qcom/$project -p -c git commit -s -m "update version for $project"
		repo forall -p -c git tag -u xuguilian $project/$version_last -m "Version $version_last"
		repo upload --re=yuanwei device/qcom/$project 	
	else
		echo "Not change version !"
	fi

}

updateversion

build

copy

