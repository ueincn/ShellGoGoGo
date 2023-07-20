#!/bin/bash

#Progarm
#   生成IP列表
#History
#2023   Ueincn  Release

IP=`seq 3`

for ip in $IP
do
    echo "192.168.1.$ip"
done