#!/bin/bash

#AUTHOR:yuanwei
#Version:v1.0
#
#DATE:2012.7.25

echo "******************Build some dir for new project **********************"
echo "  msm8x25_XX_XX   eg: msm7627a_d12_e757  ..."
read -p "input new project new_project:"  new_project

#if [ `expr "$new_project" : 'msm8x25'` -eq 0 ]; then
#    echo "Error: project name prefix must be msm7627a"
#    exit
#fi


function build_all_dir()
{


     read -p "Are you sure to create the new project: $new_project ?(yes/no)" answer
     echo "answer:$answer"
     if [ "$answer"x != "yes"x ]; then
          exit 1
     fi
     read -p "Enter the full name of clone project:" clone_project
     echo "clone from project: $clone_project"

#     read -p " The new project has Emmc? (yes/no)" has_emmc
#    echo "Has Emmc?:$has_emmc"

#   has_emmc=
#     echo "project to be created: $new_project" has emmc:${has_emmc}
    

if [ $new_project != '0' ];then               
    
	# 1. BootLoader
	echo "bootloader......."
	cp bootable/bootloader/lk/project/${clone_project}.mk bootable/bootloader/lk/project/${new_project}.mk
	cp bootable/bootloader/lk/project/${clone_project}_nandwrite.mk bootable/bootloader/lk/project/${new_project}_nandwrite.mk
	sed -i "s/${clone_project}/${new_project}/g" bootable/bootloader/lk/project/${new_project}.mk
	sed -i "s/${clone_project}/${new_project}/g" bootable/bootloader/lk/project/${new_project}_nandwrite.mk

	cp -af bootable/bootloader/lk/target/${clone_project} bootable/bootloader/lk/target/${new_project}
	#sed -i "s/${clone_project}/${new_project}/g" `grep ${clone_project} -rl ./bootable/bootloader/lk/project/${new_project}.mk`


	#2 .update frameworks and system
	echo "update framework and system ....."
	sed -i "s/\(\"${clone_project}\"\)/\1,\"${new_project}\"/g" frameworks/base/core/java/android/server/BluetoothAdapterStateMachine.java
	cp -rf system/core/rootdir/${clone_project} system/core/rootdir/${new_project}
	sed -i "s/${clone_project}/${new_project}/g" `grep ${clone_project} -rl ./system/core/rootdir/${new_project}/* `

	for X in `find system/core/rootdir/etc -name "*.sh"`
		do
		echo "$X"
		sed -i "s/\(\"${clone_project}\"\)/\1 | \"${new_project}\"/g" $X
	done

	# 3. create device 
	echo "create devices"
	cp -af device/qcom/${clone_project} device/qcom/${new_project}

	mv device/qcom/${new_project}/${clone_project}.mk device/qcom/${new_project}/${new_project}.mk
	# mv  device/qcom/${new_project}/${clone_project}.mk  device/qcom/${new_project}/${new_project}.mk
	sed -i "s/${clone_project}/${new_project}/g" `grep -rl ${clone_project}  ./device/qcom/${new_project}/*`
	#mv device/qcom/${new_project}/${clone_project}.mk device/qcom/${new_project}/${new_project}.mk

	# 4. update overlay
	echo "update overlay"
	cp -rf vendor/huiye/${clone_project}_overlay vendor/huiye/${new_project}_overlay
	# cp -rf vendor/qcom/proprietary/prebuilt_HY11/target/new_project/${clone_project} vendor/qcom/proprietary/prebuilt_HY11/target/${new_project}

	# cp vendor/qcom/proprietary/gps/build/${clone_project}.in vendor/qcom/proprietary/gps/build/${new_project}.in


	# sed -i "s/\(\<${clone_project}\>\)/\1 ${new_project}/g"`grep -rl ${clone_project} vendor/qcom/proprietary/kernel-tests`
	for X  in `find ./vendor/qcom/proprietary/common/config -name "*.mk"`
	do
	echo "$X"
	sed -i "s/\(\<${clone_project}\>\)/\1 ${new_project}/g" $X
	done

	for X in `find vendor/qcom/proprietary/kernel-tests -name "*.mk"`
	do
	echo "$X"
	sed -i "s/\(${clone_project} \)/\1${new_project} /g" $X
	done


	#5.kernel
	# ftm_fm_pfal_linux.c
	cp  kernel/arch/arm/configs/${clone_project}-perf_defconfig kernel/arch/arm/configs/${new_project}-perf_defconfig

	#6.update thidparty
	cp -af packages/thirdparty/${clone_project} packages/thirdparty/${new_project}
	sed -i "s/${clone_project}/${new_project}/g" packages/thirdparty/${new_project}/Android.mk

	# 7.update modem-apis
	cp -rf vendor/qcom/proprietary/modem-apis/${clone_project} vendor/qcom/proprietary/modem-apis/${new_project}
    # add ingore file for git 
    #sed -i "9i device/qcom/${new_project}/radio/".gitignore 
    #sed -i "2i bootable/bootloader/lk/target/${new_project}/tools/mkheader".gitignore 
	#============================================================================
                # add by xuguilian  2012.12.19
        #****************************************************************
	cp -rf vendor/qcom/proprietary/wlan/ath6kl-utils/ath6kl_fw/hw2.1.1/${clone_project} vendor/qcom/proprietary/wlan/ath6kl-utils/ath6kl_fw/hw2.1.1/${new_project}
	cp device/qcom/${clone_project}/.gitignore device/qcom/${new_project}


else
     echo
     echo "erro new_project input"
     echo " please input correct project new_project "
     echo "Usage:"
     echo "  msm7627a_d8_e100   ..."
     exit;
fi
}


function build_touchpanel(){
    
     echo "select Touch Panel"
     echo "--------------C Touch------------------------"
    
     echo "1 Gt818"
     echo "2 Gt813"
     echo "3 Gt82x"
     echo "4 It72660"
     echo "5 MSG2133"
     echo "--------------R Touch------------------------"
     echo "6 Msm_R_touch"
    
}

function build_lcm(){
#     echo "start Select the LCM :"
#     echo "     1.  MSM7627_LCDC_ILI9486_HSD_TS"
#     echo "     2.  MSM7627_LCDC_ILI9486_HSD"
#     echo "     3   MSM7627A_LCD_HX8369A_WIDE_TIANMA  "
#     echo "     4   MSM7627A_LCD_NT35510_WIDE_HELITAI "
#     echo "     5   MSM7627A_LCDC_ILI9341_DIJING "
#     echo "     6   MSM7627A_LCD_NT35510_WIDE_WEIYU "
#     echo "     7   MSM7627A_LCDC_ILI9341_BOE_TXD "
#     echo "     8   MSM7627A_LCD_NT35510_WIDE_BOYI "

 

. ./bootable/bootloader/lk/platform/msm_shared/lcm_cust_list.c
#LCM_LIST=(MSM7627_LCDC_ILI9486_HSD_TS MSM7627_LCDC_ILI9486_HSD MSM7627A_LCD_NT35510_WIDE_HELITAI MSM7627A_LCD_HX8369A_WIDE_TIANMA MSM7627A_LCDC_ILI9341_DIJING MSM7627A_LCD_NT35510_WIDE_WEIYU MSM7627A_LCDC_ILI9341_BOE_TXD MSM7627A_LCD_NT35510_WIDE_BOYI)
#echo ${LCM_LIST[@]}
lenth=${#LCM_LIST[*]}
i=1

while [ $i -lt $lenth ]
do
	echo "$i"--"${LCM_LIST[$i]}"
	let i++
done

#     local ANSWER
     local CURENT_LCM

# sed -i "$  a DEFINES +=${aa}=1" 1.txt     
    
 
    
     while [  "$ANSWER" != ok ]
     do
     echo "input must be : 1 2 3 "
     read -p "Select New LCM for new Project NUM= " cust_1 cust_2 cust_3
     cust=($cust_1 $cust_2 $cust_3)
     for item in ${cust[@]}
         do
          case $item in
                "")
               echo "please input as show in list!"
                ;;
          1)   echo "----1--------"    
	       CURENT_LCM=${LCM_LIST[$item]}         
               grep ${CURENT_LCM} -rl ./bootable/bootloader/lk/project/${new_project}.mk
               if [ $? -eq 0 ]; then
                    continue
               fi
               sed -i "$ a DEFINES +=${CURENT_LCM}=1"   ./bootable/bootloader/lk/project/${new_project}.mk
               echo "new lcm  ${CURENT_LCM} have been added!"    
                ;;
          2)   
                
               echo "----2--------"
               CURENT_LCM=${LCM_LIST[$item]}    
               grep ${CURENT_LCM} -rl ./bootable/bootloader/lk/project/${new_project}.mk
               if [ $? -eq 0 ]; then
                    continue
               fi
                             
               sed -i "$ a DEFINES +=${CURENT_LCM}=1"  ./bootable/bootloader/lk/project/${new_project}.mk
               echo "new lcm  ${CURENT_LCM}   have been added!"    
               ;;
          3)     echo "----3--------"
               CURENT_LCM=${LCM_LIST[$item]}              
               grep $CURENT_LCM  ./bootable/bootloader/lk/project/${new_project}.mk 
               if [ $? -eq 0 ]; then
                    continue
               fi
              
               sed -i "$ a DEFINES +=${CURENT_LCM}=1"  ./bootable/bootloader/lk/project/${new_project}.mk
               echo "new lcm ${CURENT_LCM} have been added!"    
               ;;
                4)    
               CURENT_LCM=${LCM_LIST[$item]}              
               grep $CURENT_LCM  ./bootable/bootloader/lk/project/${new_project}.mk 
               if [ $? -eq 0 ]; then
                    continue
               fi

               sed -i "$ a DEFINES +=${CURENT_LCM}=1"  bootable/bootloader/lk/project/${new_project}.mk
               echo "new lcm   ${CURENT_LCM} have been added!"    
               ;;
               5)      
               CURENT_LCM=${LCM_LIST[$item]}         
               grep $CURENT_LCM  ./bootable/bootloader/lk/project/${new_project}.mk 
               if [ $? -eq 0 ]; then
                    continue
               fi

               sed -i "$ a DEFINES +=${CURENT_LCM}=1"  bootable/bootloader/lk/project/${new_project}.mk
               echo "new lcm ${CURENT_LCM}  have been added!"    
               ;;

                6)    
               CURENT_LCM=${LCM_LIST[$item]}              
               grep $CURENT_LCM  ./bootable/bootloader/lk/project/${new_project}.mk 
               if [ $? -eq 0 ]; then
                    continue
               fi

               sed -i "$ a DEFINES +=${CURENT_LCM}=1"  ./bootable/bootloader/lk/project/${new_project}.mk
               echo "new lcm  ${CURENT_LCM} have been added!"    
               ;;
   	       7)    
               CURENT_LCM=${LCM_LIST[$item]}              
               grep $CURENT_LCM ./ bootable/bootloader/lk/project/${new_project}.mk 
               if [ $? -eq 0 ]; then
                    continue
               fi

               sed -i "$ a DEFINES +=${CURENT_LCM}=1"  bootable/bootloader/lk/project/${new_project}.mk
               echo "new lcm  ${CURENT_LCM} have been added!"    
               ;;
     	   8)      
               CURENT_LCM=${LCM_LIST[$item]}              
               grep $CURENT_LCM  bootable/bootloader/lk/project/${new_project}.mk 
               if [ $? -eq 0 ]; then
                    continue
               fi
               sed -i "$ a DEFINES +=${CURENT_LCM}=1"  bootable/bootloader/lk/project/${new_project}.mk
               echo "new lcm ${CURENT_LCM} have been added!"    
               ;;
                   
      	  *)
               echo
               echo "I didnt understand your define.  Please try again."
               echo
               ;;
            esac
     done


    read -p "are your sure ?:  ? (yes/no)" ANSWER
    if [ "$ANSWER"x == "yes"x ]; then
         # exit 1
         break

    fi
    
done
            
     echo "selects LCM done!"
         
                   
            

    
}

rm_files() {
     echo "～you will delete the new  project~ "
#     read  -p "Are you sure to delete the new project : ?(yes/no)" $answer
#     if [ "$answer"x != "yes" ];then
#          exit 1
#     fi
     local new_project
     read -p "input project name to delete:" new_project
     echo "starting delete files ..........."
     rm bootable/bootloader/lk/project/${new_project}.mk
     rm bootable/bootloader/lk/project/${new_project}_nandwrite.mk
     rm -rf bootable/bootloader/lk/target/${new_project}
     rm -rf device/qcom/${new_project}
     rm kernel/arch/arm/configs/${new_project}-perf_defconfig
     rm -rf vendor/huiye/${new_project}_overlay
     rm -rf system/core/rootdir/${new_project}
     rm -rf vendor/qcom/proprietary/modem-apis/${new_project}
     rm -rf vendor/qcom/proprietary/gps/build/${new_project}.in
     echo " delete files  done~"
}


function build_logo(){
	#     开关机动画铃声目录：system/core/rootdir/$(TARGET_new_project)
	#     开关logo修改文件位置：bootable/bootloader/lk/target$(TARGET_new_project)/include/target/splash.h
	#     MainMenu排序文件：vendor/huiye/$(TARGET_new_project)_overlay/packages/apps/Launcherx/res/raw/app_order    //Launcherx(x=1..n)
	#     idle界面排序文件：vendor/huiye/$(TARGET_new_project)_overlay/packages/apps/Launcherx/res/xml/default_workspace.xml     //Launcherx(x=1..n)

	#     对应的换图： vendor/huiye/$(TARGET_new_project)_overlay/ 下面有framework和package，目录结构和根目录下的framework和package是平行的。
	#     我们要在104上生成一套这样的平行目录，华森要改直接在这个平行目录下替换改好的图标，就可以了
	echo "Configure LOGO...... "
	#custom=smb://192.168.10.104/custom/logo/   .gvfs/192.168.10.104

	custom=/custom
	# 很多文件 需要一次性复制
	logo_kernel_path=./system/core/rootdir/${new_project}
	#单个文件复制
	logo_uboot_path=./bootable/bootloader/lk/target/${new_project}/include/target/splash.h
	# 需要确认路径！
	menu_path=./vendor/huiye/${new_project}_overlay/packages/apps/Launcherx/res/raw/app_order

	idle_path=./vendor/huiye/${new_project}_overlay/packages/apps/Launcherx/res/xml/default_workspace.xml
	#wallpaper= ./vendor/huiye/${new_project}_overlay/frameworks/base/core/res/res/drawable
	#需要替换相关变量
	#sed -i "s/msm7627a_v12_s757/${new_project}/g" `grep msm7627a_v12_s757 -rl ./device/qcom/${new_project}/*`
     if [ ! -d "$logo_kernel_path" ];then

          mkdir "$logo_kernel_path"

     fi


     if [ ! -d "$menu_path" ];then

          mkdir "$menu_path"

     fi

     if [ ! -d "$idle_path" ];then

          mkdir "$idle_path"

     fi

     if [ ! -d "$huantu" ];then

          mkdir "$huantu"

     fi
    
     cp -rf $logo_kernel_path/rootdir/*      $logo_kernel_path
     cp -rf $custom/splash/splash.h   $logo_uboot_path
     cp -rf $custom/menu/*           $menu_path
     cp -rf $custom/idle/default_workspace.xml           $idle_path
    
     #must recheck!!!
    
     #cp -rf $idle_path/default_workspace.xml      ./vendor/huiye/$(new_project)_overlay/packages/apps/Launcherx/res/xml/
     #cp -rf $custom/wallpaper/default_wallpaper.jpg  $wallpaper
    
}
function build_sys_ui_layout(){
    
	echo " Start to select system configure and  UI Layout......"
	#logo_path=smb://192.168.10.104/custom/UI/
	#ui_path=smb://192.168.10.104/custom/UI
	ui_path=/custom/ui
	cp -rf ${ui_path}/hymost.prop  ./device/qcom/$(new_project)/hymost.prop
	cp -rf ${ui_path}/project.mk  ./device/qcom/$(new_project)/$(new_project).mk
	cp -rf ${ui_path}/BoardConfig.mk  ./device/qcom/$(new_project)/BoardConfig.mk
	sed -i "s/msm7627a_v12_s757/${new_project}/g" `grep msm7627a_v12_s757 -rl ./device/qcom/${new_project}/*`
	#     项目名：$(TARGET_new_project)    
	# 移除上面对这些文件到配置，在这里唯一配置
	#     系统属性配置文件：device/qcom/$(TARGET_new_project)/hymost.prop
	#     项目主配置文件：device/qcom/$(TARGET_new_project)/$(TARGET_new_project).mk
	#     板载配置文件：device/qcom/$(TARGET_new_project)/BoardConfig.mk



}
#rm_files

function build_start(){
         
     #   while [  "$answer" != ok ]
     while true
     do
          build_all_dir

          #new items  must be added to below

          #build_logo
          build_lcm
         # build_sys_ui_layout
          #build_show_all_selections
         
          # restart     
          read -p " Start  to  create all of your selections ? [yes/no]: " answer
         
          case $answer in
           
          n | no )
               echo "Will delete all the new  files!!!!.........."
               echo
               echo " Current Project Name: -------- ${new_project}-----------"
               echo
               rm_files    
               echo "delete done!"
               continue
           			    ;;
          y | yes)
		echo "Create New Project Done!....."    
		return 1
		;;
          * )       
		 echo "Answer yes or no"    
		;;	
	  esac

done
}
build_start
echo "Start to Create new Preject Now"
echo ".........."
echo "done!!!"
echo ok success !!!
exit 0



