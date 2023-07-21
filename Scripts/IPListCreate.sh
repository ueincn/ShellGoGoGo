#!/bin/bash

#Progarm
#   生成IP列表
#History
#2023   Ueincn  Release

IPFILE="$(pwd)/IPList.txt"

if [ ! -f $IPFILE ]; then
    touch $IPFILE
else
    rm -f $IPFILE
fi

read -p "请输入起始IP：" IPSTART
read -p "请输入结束IP：" IPEND

IPPREFIX=`echo $IPSTART | awk -F"." '{print $1"."$2"."$3}'`
IPSUFFIX=`echo $IPEND | awk -F "." '{print $NF}' | xargs seq`

for IPCREATE in $IPSUFFIX
do
    echo "$IPPREFIX.$IPCREATE" >> $IPFILE
done

echo "IP列表生成成功!"
echo "IP列表文件保存地址：$IPFILE"