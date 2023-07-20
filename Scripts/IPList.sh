#!/bin/bash

#Progarm
#   IP List
#History
#2023   ueincn  

IP=`seq 3`

for ip in $IP
do
    echo "192.168.1.$ip"
done