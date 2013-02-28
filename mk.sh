#!/bin/bash  

################################################################
#                                                              
# The script is used for create new git on 192.168.10.91 server 
# Author :yuanwei 
# DATE:2013.2.28
# Version:v1.1
#                                       
################################################################

 clear
 echo 
 echo  "   _   _  _ ___  ___  ___ ___ ___  "
 echo  "  /_\ | \| |   \| _ \/ _ \_ _|   \ "
 echo  ' / _ \| .` | |) |   / (_) | || |) |'
 echo  '/_/ \_\_|\_|___/|_|_\\___/___|___/ '
 echo 
 echo 
 speclist=(7x27a 8x25 7125a 8x25q)
 index=0
 echo "BuildSpec choices are:"
# echo " 3. default"
 for p in ${speclist[@]}                                                                                                                      
 do
     echo " $index. $p"
     let "index = $index + 1"
 done

#read -p "1 : Choose platform:\n" dest

if [ -z "$1" ] ; then
    echo -n "Which would you like? ["$dest"] "
    read dest                                                                                                                        
else
    echo $1
    dest=$1
fi
echo 
echo 
case "$dest" in 
    "7x27a"|"0")
        newgit=7x27a
        echo "[$newgit]  platform is selected !"
        echo 
        ;;
    "8x25"|"1")
        newgit=8x25
        echo "[$newgit]  platform is selected !"
        echo 
        ;;
    "7125a"|"2")
        newgit=7125a

        echo "$newgit  platform is selected !"
        echo 
        ;;

    "8x25q"|"3")
        newgit=8x25q
        echo "$newgit  platform is selected !"
        echo 
        ;;
    *)
        echo "no platform selected !"
        exit 0
        ;;
esac 

echo 
echo "Start to create gerrit git ............"
read  -p "Please input your dir :" newdir 
echo "Your input result : $newgit/$newdir"
ssh -p 29418 gerrithost gerrit create-project $newgit/$newdir
echo "create gerrit git done !"
cd  ~/gerrit/new-git
ls
git init .
git add  .
git commit -m "add by yuanwei "
if [ x$newgit = x"8x25q" ];then
git push git@192.168.10.91:server/${newgit}/${newdir}.git   master:8x25q
else
git push git@192.168.10.91:server/${newgit}/${newdir}.git  master
fi
cd -
echo "ending .................................."
