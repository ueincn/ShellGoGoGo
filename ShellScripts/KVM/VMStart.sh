#!/bin/bash

#Program
#   虚机启动脚本
#History
#2023   Ueincn  Release

#qemu-system-x86_64 -m 4096 -smp 4 -display gtk -device VGA -device nec-usb-xhci -device usb-tablet -device usb-kbd -drive if=virtio,file=/VM/debian-10-generic-amd64-20230222-1299-uroot-proot.qcow2,id=hd0,format=qcow2,media=disk -net nic -net tap,ifname=tap0

#sudo ip tuntap add dev tap0 mode tap
#sudo ip link set dev tap0 up
#sudo ip addr add dev tap0 192.168.2.100/24

MEMAVLMB=`free | sed -n 2p | awk '{mem=$NF/1024}END{print int(mem)}'`
CPUCORE=`cat /proc/cpuinfo | grep -w "cpu cores" | sed -n 1p | awk -F: '{print $NF}' | sed 's/[[:space:]]//g'`

read -p "请输入镜像地址：" IMAGEPATH
read -p "请输入内存大小（可用[$MEMAVLMB]MB）：" MEM
read -p "请输入CPU核心数量（主机核心数量[$CPUCORE]）：" CPU

IMAGEFORMAT=`qemu-img info $IMAGEPATH | grep -w "file format" | awk -F: '{print $NF}' | sed 's/[[:space:]]//g'`


function VMRun(){
    qemu-system-$(arch) \
    -m $MEM \
    -smp $CPU \
    -display gtk \
    -device nec-usb-xhci -device usb-tablet -device usb-kbd \
    -drive if=virtio,file=$IMAGEPATH,id=hd0,format=$IMAGEFORMAT,media=disk \
    -net nic -net tap,ifname=tap0,script=no,downscript=no >/dev/null 2>&1 &
}

VMRun

echo "虚机启动完成！"