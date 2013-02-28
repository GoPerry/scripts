#/bin/bash
#. ./functions.sh

# insert a string to the specific file
# parameter 1: string to be inserted
# parameter 2: file to be inserted
# parameter 3: offset to insert the string
insert_string() {
	sed -i "${3}a${1}" ${2}
	echo "insert string ${1} to file: ${2} in line ${3}"
}
new_project=
read -p "Enter the full name of new project:" new_project
read -p "Are you sure to create the new project: $new_project ?(yes/no)" answer
echo "answer:$answer"

if [ "$answer"x != "yes"x ]; then
	exit 1
fi

read -p " The new project has Emmc? (yes/no)" has_emmc
echo "Has Emmc?:$has_emmc"

echo "project to be created: $new_project" has emmc:${has_emmc}

#Get the project to be cloned
#temp_project=${new_project:0:11}
clone_project=
read -p "Enter the full name of clone project:" clone_project
#case $temp_project in
#	msm7627a_a7)
#		clone_project=msm7627a_a7_5100s
#	;;

#	msm7627a_a8)
#		clone_project=msm7627a_xx_xxx
#	;;

#	msm7627a_a9)
#		clone_project=msm7627a_a9_s9100a
#	;;

#	msm7627a_d7)
#		clone_project=msm7627a_d7_lc203
#	;;

#	msm7627a_d8)
#		clone_project=msm7627a_d8_ve600
#	;;

#	msm7627a_d9)
#		clone_project=msm7627a_d9_e99
#	;;

#	msm7627a_v7)
#		clone_project=msm7627a_v8
#	;;

#	msm7627a_v8)
#		clone_project=msm7627a_v8
#	;;

#	msm7627a_v12)
#		clone_project=msm7627a_v12_s757
#	;;
	
#	*)
#		clone_project=msm7627a_d7_lc203
#	;;

#esac

echo "clone from project: $clone_project"

copy_files() {
	# 1. BootLoader
	touch bootable/bootloader/lk/project/${new_project}.mk
	cp bootable/bootloader/lk/project/${clone_project}.mk bootable/bootloader/lk/project/${new_project}.mk
	sed -i "s/${clone_project}/${new_project}/g" `grep ${clone_project} -rl ./bootable/bootloader/lk/project/${new_project}.mk`	

	touch bootable/bootloader/lk/project/${new_project}.mk
	cp bootable/bootloader/lk/project/${clone_project}_nandwrite.mk bootable/bootloader/lk/project/${new_project}_nandwrite.mk
	sed -i "s/${clone_project}/${new_project}/g" `grep ${clone_project} -rl ./bootable/bootloader/lk/project/${new_project}_nandwrite.mk`	
#	mkdir bootable/bootloader/lk/project/${new_project}
	cp -rf bootable/bootloader/lk/target/${clone_project} bootable/bootloader/lk/target/${new_project}


	# 2. Device
	
	cp -rf device/qcom/${clone_project} device/qcom/${new_project}

	# 3. Kernel
	cp -rf kernel/arch/arm/configs/${clone_project}-perf_defconfig kernel/arch/arm/configs/${new_project}-perf_defconfig


	# 4. Vendor
	cp -rf vendor/huiye/${clone_project}_overlay vendor/huiye/${new_project}_overlay 
	cp -rf system/core/rootdir/${clone_project} system/core/rootdir/${new_project}
	cp -rf packages/thirdparty/${clone_project} packages/thirdparty/${new_project}
	sed -i "s/${clone_project}/${new_project}/g" `grep ${clone_project} -rl ./system/core/rootdir/${new_project}`	

	cp -rf vendor/qcom/proprietary/prebuilt_HY11/target/product/${clone_project} vendor/qcom/proprietary/prebuilt_HY11/target/product/${new_project}
	cp -rf vendor/qcom/proprietary/modem-apis/${clone_project} vendor/qcom/proprietary/modem-apis/${new_project}
	cp vendor/qcom/proprietary/gps/build/${clone_project}.in vendor/qcom/proprietary/gps/build/${new_project}.in

	#wlan
	cp -rf system/wlan/atheros/AR6kSDK.build_3.1_RC.806-proprietary/target/AR6003/hw2.1.1/bin/${clone_project} system/wlan/atheros/AR6kSDK.build_3.1_RC.806-proprietary/target/AR6003/hw2.1.1/bin/${new_project}
	cp -rf system/wlan/atheros/AR6kSDK.build_3.1_RC.711-proprietary/target/AR6003/hw2.1.1/bin/${clone_project} system/wlan/atheros/AR6kSDK.build_3.1_RC.711-proprietary/target/AR6003/hw2.1.1/bin/${new_project}

}
copy_files
rm_files() {
	rm bootable/bootloader/lk/project/${new_project}.mk
	rm bootable/bootloader/lk/project/${new_project}_nandwrite.mk
	rm -rf bootable/bootloader/lk/target/${new_project}
	rm -rf device/qcom/${new_project}
	rm kernel/arch/arm/configs/${new_project}-perf_defconfig
	rm -rf vendor/huiye/${new_project}_overlay
	rm -rf system/core/rootdir/${new_project}
	rm -rf vendor/qcom/proprietary/prebuilt_HY11/target/product/${new_project}
	rm -rf vendor/qcom/proprietary/modem-apis/${new_project}
	rm -rf vendor/qcom/proprietary/gps/build/${new_project}.in
#	echo finish
}
#rm_files
emmc() {
if [ "$has_emmc"x = "yes"x ]; then
	emmc_file="frameworks/base/packages/SystemUI/src/com/android/systemui/usb/StorageNotification.java"
	emmc_str="if(\""${new_project}"\".equals(SystemProperties.get(KEY_PRODUCT_BOARD))"
	insert_string "$emmc_str" $emmc_file 136 
	emmc_str="&& \""1"\".equals(SystemProperties.get(KEY_STORAGE_PROP))){"
	insert_string "$emmc_str" $emmc_file 137
	emmc_str="connected=true;}"
	insert_string "$emmc_str" $emmc_file 138

#	emmc_file="./vendor/qcom/proprietary/qrdplus/QRDExtensions/DynamicComponents/res/UpdatePackage/CU/META-INF/com/google/android/updater-script"
#	emmc_str="getprop("ro.build.product") == \""${new_project}"\" ||"
#	insert_string "$emmc_str" $emmc_file 8 
#	emmc_str="getprop("ro.product.device") == \""${new_project}"\" ||"
#	insert_string "$emmc_str" $emmc_file 9

#	insert_string $emmc_str2[0] $emmc_str2[1] $emmc_str2[2] 
#	insert_string $emmc_str3[0] $emmc_str3[1] $emmc_str3[2] 
#	insert_string $emmc_str4[0] $emmc_str4[1] $emmc_str4[2] 
fi
}
emmc
aaa(){
	sed -i "s/msm7627a_xx_xxx/msm7627a_xx_xxx\") || !strcmp(value, \"${new_project}/g" `grep msm7627a_xx_xxx -rl ./frameworks/base/media/libstagefright/OMXCodec.cpp`
	sed -i "s/msm7627a_xx_xxx/msm7627a_xx_xxx ${new_project}/g" `grep msm7627a_xx_xxx -rl ./frameworks/base/media/libstagefright/Android.mk`
	sed -i "s/msm7627a_xx_xxx/msm7627a_xx_xxx ${new_project}/g" `grep msm7627a_xx_xxx -rl ./hardware/msm7k/libsensors/Android.mk`
	sed -i "s/msm7627a_xx_xxx/msm7627a_xx_xxx ${new_project}/g" `grep msm7627a_xx_xxx -rl ./hardware/msm7k/libstagefrighthw/Android.mk`
	sed -i "s/${clone_project}/${clone_project}\" | \"${new_project}/g" `grep ${clone_project} -rl ./system/core/rootdir/etc/init.qcom.log.sh`
	sed -i "s/${clone_project}/${clone_project}\" | \"${new_project}/g" `grep ${clone_project} -rl ./system/core/rootdir/etc/init.qcom.usbcdrom.sh`
	sed -i "s/${clone_project}/${clone_project}\" | \"${new_project}/g" `grep ${clone_project} -rl ./system/core/rootdir/etc/init.qcom.usb.sh`
	sed -i "s/${clone_project}/${clone_project}\" | \"${new_project}/g" `grep ${clone_project} -rl ./system/core/rootdir/etc/init.qcom.sh`
	sed -i "s/${clone_project}/${clone_project}\" | \"${new_project}/g" `grep ${clone_project} -rl ./system/core/rootdir/etc/init.qcom.savepcap.sh`
	sed -i "s/${clone_project}/${clone_project}\" | \"${new_project}/g" `grep ${clone_project} -rl ./system/core/rootdir/etc/init.qcom.post_boot.sh`
}
aaa
zzz(){	emmc_file="./system/wlan/atheros/AR6kSDK.build_3.1_RC.711-proprietary/host/Android.mk"
	emmc_str="else ifeq (\$(QCOM_TARGET_PRODUCT),${new_project})"
	insert_string "$emmc_str" $emmc_file 63
	emmc_str="\$(call add-ar6k-prebuilt-file,support/a8BoardData_AR6003_v2_0.bin,\$(ar6k_hw21_dst_dir),bdata.SD31.bin,athdata221)"
	insert_string "$emmc_str" $emmc_file 64
}
zzz
bbb(){
	sed -i "s/msm7627a_xx_xxx/msm7627a_xx_xxx ${new_project}/g" `grep msm7627a_xx_xxx -rl ./system/wlan/atheros/AR6kSDK.build_3.1_RC.711/host/Android.mk`	
	sed -i "s/msm7627a_xx_xxx/msm7627a_xx_xxx ${new_project}/g" `grep msm7627a_xx_xxx -rl ./packages/apps/FM/Android.mk`
}
bbb
ccc(){
	emmc_file="./vendor/qcom/proprietary/kernel-tests/Android.mk"
	emmc_str="KERNEL_TEST_PRODUCT_LIST += ${new_project}"
	insert_string "$emmc_str" $emmc_file 18

	emmc_file="./vendor/qcom/proprietary/mm-audio/audio-alsa/Android.mk"
	emmc_str="PRODUCT_LIST += ${new_project}"
	insert_string "$emmc_str" $emmc_file 14

	emmc_file="./vendor/qcom/proprietary/mm-audio/omx/adec-evrc/qdsp5/Android.mk"
	emmc_str="PRODUCT_LIST += ${new_project}"
	insert_string "$emmc_str" $emmc_file 8 

	emmc_file="./vendor/qcom/proprietary/mm-audio/omx/adec-qcelp13/qdsp5/Android.mk"
	emmc_str="PRODUCT_LIST += ${new_project}"
	insert_string "$emmc_str" $emmc_file 11
}
ccc
ddd(){
	sed -i "s/msm7627a_xx_xxx/msm7627a_xx_xxx ${new_project}/g" `grep msm7627a_xx_xxx -rl ./vendor/qcom/proprietary/oncrpc/oncrpc_defines.mk`
	sed -i "s/msm7627a_xx_xxx/msm7627a_xx_xxx ${new_project}/g" `grep msm7627a_xx_xxx -rl ./vendor/qcom/proprietary/oncrpc/test/oncrpc/src/Android.mk`
	sed -i "s/msm7627a_xx_xxx/msm7627a_xx_xxx ${new_project}/g" `grep msm7627a_xx_xxx -rl ./vendor/qcom/proprietary/qcril/qcril_fusion/qcril_fusion.mk`
	sed -i "s/msm7627a_xx_xxx/msm7627a_xx_xxx ${new_project}/g" `grep msm7627a_xx_xxx -rl ./vendor/qcom/proprietary/qcril/qcrilhook_oem/Android.mk`
	sed -i "s/msm7627a_xx_xxx/msm7627a_xx_xxx ${new_project}/g" `grep msm7627a_xx_xxx -rl ./vendor/qcom/proprietary/qcril/qcril_qmi/qcril_qmi.mk`
}
ddd
eee(){
	#emmc_file="./vendor/qcom/proprietary/qcril/Android.mk"
	#emmc_str="PRODUCT_LIST += ${new_project}"
	#insert_string "$emmc_str" $emmc_file 11
	#emmc_str="QCRIL_FUSION_PRODUCT_LIST += ${new_project}"
	#insert_string "$emmc_str" $emmc_file 140
	sed -i "s/msm7627a_xx_xxx/msm7627a_xx_xxx ${new_project}/g" `grep msm7627a_xx_xxx -rl ./vendor/qcom/proprietary/qcril/Android.mk`
	sed -i "s/msm7627a_xx_xxx/msm7627a_xx_xxx ${new_project}/g" `grep msm7627a_xx_xxx -rl ./vendor/qcom/proprietary/bt/hci_qcomm_init/Android.mk`

	emmc_file="./vendor/qcom/proprietary/gps/Android.mk"
	emmc_str="PRODUCT_LIST += ${new_project}"
	insert_string "$emmc_str" $emmc_file 19

	sed -i "s/msm7627a_xx_xxx/msm7627a_xx_xxx ${new_project}/g" `grep msm7627a_xx_xxx -rl ./vendor/qcom/proprietary/gps/libgps/Android.mk`
	emmc_file="./vendor/qcom/proprietary/mm-parser/Android.mk"
	emmc_str="PRODUCT_LIST += ${new_project}"
	insert_string "$emmc_str" $emmc_file 14

#	sed -i "s/msm7627a_xx_xxx/msm7627a_xx_xxx ${new_project}/g" `grep msm7627a_xx_xxx -rl ./vendor/qcom/proprietary/qrdplus/FMPlayer/Android.mk`
	emmc_file="./vendor/qcom/proprietary/qrdplus/QRDExtensions/DynamicComponents/res/UpdatePackage/CU/META-INF/com/google/android/updater-script"
	emmc_str="getprop("ro.build.product") == \""${new_project}"\" ||"
	insert_string "$emmc_str" $emmc_file 8
	emmc_str="getprop("ro.product.device") == \""${new_project}"\" ||"
	insert_string "$emmc_str" $emmc_file 9
}
eee
fff(){
	emmc_file="./vendor/qcom/proprietary/common/config/device-vendor.mk"
	emmc_str="PRODUCT_LIST += ${new_project}"
	insert_string "$emmc_str" $emmc_file 31

	sed -i "s/msm7627a_d8_2900 msm7627a_d9_e99/msm7627a_d8_2900 msm7627a_d9_e99 ${new_project}/g" `grep msm7627a_a8 -rl ./vendor/qcom/proprietary/common/config/device-vendor.mk`
}
fff
ggg(){
	emmc_file="./vendor/qcom/proprietary/common/build/utils_test.mk"
	emmc_str="PRODUCT_LIST += ${new_project}"
	insert_string "$emmc_str" $emmc_file 27

	sed -i "s/msm7627a_sku1 msm7627a_sku3/msm7627a_sku1 msm7627a_sku3 ${new_project}/g" `grep msm7627a_a8 -rl ./vendor/qcom/proprietary/common/build/utils_test.mk`
}
ggg
hhh(){
	emmc_file="./vendor/qcom/proprietary/common/build/utils_sample_usage.mk"
	emmc_str="BOARD_PLATFORMS_LIST += ${new_project}"
#	insert_string "$emmc_str" $emmc_file 134
	insert_string "$emmc_str" $emmc_file 134

	sed -i "s/msm7627a_sku1 msm7627a_sku3/msm7627a_sku1 msm7627a_sku3 ${new_project}/g" `grep msm7627a_a8 -rl ./vendor/qcom/proprietary/common/build/utils_sample_usage.mk`
}
hhh
iii(){
	sed -i "s/msm7627a_xx_xxx/msm7627a_xx_xxx ${new_project}/g" `grep msm7627a_xx_xxx -rl ./vendor/qcom/proprietary/common/build/remote_api_makefiles/remote_api_defines.mk`
}
iii
kkk(){
	emmc_file="./vendor/qcom/proprietary/factory_kit/src/com/qualcomm/factory/TestSettings.java"
	emmc_str="public static final String PRODUCT_${new_project}=\""${new_project}"\";"
	insert_string "$emmc_str" $emmc_file 16

}
#kkk
yyy(){
	emmc_file="./vendor/qcom/proprietary/fm/patch_downloader/fm_qsoc_patches.c"
	emmc_str="else if(!strncmp(\""${new_project}"\",product_device_type,strlen(product_device_type)))"
	insert_string "$emmc_str" $emmc_file 3499
	emmc_str="fm_i2c_path = (char *)fm_i2c_path_7x27A_SURF;"
	insert_string "$emmc_str" $emmc_file 3500
}
yyy
	sed -i "s/msm7627a_xx_xxx/msm7627a_xx_xxx ${new_project}/g" `grep msm7627a_xx_xxx -rl ./vendor/qcom/android-open/libopencorehw/Android.mk`
project_modify(){

	sed -i "s/${clone_project}/${new_project}/g" `grep ${clone_project} -rl ./device/qcom/${new_project}/scripts/setup.cmm`
	sed -i "s/${clone_project}/${new_project}/g" `grep ${clone_project} -rl ./device/qcom/${new_project}/scripts/debug_android.cmm`
	sed -i "s/${clone_project}/${new_project}/g" `grep ${clone_project} -rl ./device/qcom/${new_project}/AndroidBoard.mk`
	sed -i "s/${clone_project}/${new_project}/g" `grep ${clone_project} -rl ./device/qcom/${new_project}/AndroidProducts.mk`


	sed -i "s/${clone_project}/${new_project}/g" `grep ${clone_project} -rl ./device/qcom/${new_project}/BoardConfig.mk`

	sed -i "s/${clone_project}/${new_project}/g" `grep ${clone_project} -rl ./device/qcom/${new_project}/${clone_project}.mk`
	
	sed -i "s/${clone_project}/${new_project}/g" `grep ${clone_project} -rl ./device/qcom/${new_project}/buildspec.mk.${clone_project}`

	sed -i "s/${clone_project}/${new_project}/g" `grep ${clone_project} -rl ./packages/thirdparty/${new_project}/Android.mk`
		

	cd ./device/qcom/${new_project}
	mv ${clone_project}.mk ${new_project}.mk
	mv buildspec.mk.${clone_project} buildspec.mk.${new_project}	
}
project_modify
