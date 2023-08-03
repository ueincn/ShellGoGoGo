#!/bin/bash

#Progarm
#   启动1个或多个虚拟机
#History
#2023   Ueincn  Release

function Start(){
    MEMAVLMB=`free | sed -n 2p | awk '{mem=$NF/1024}END{print int(mem)}'`
    CPUCORE=`cat /proc/cpuinfo | grep -w "cpu cores" | sed -n 1p | awk -F: '{print $NF}' | sed 's/[[:space:]]//g'`

    read -p "请输入VM镜像源文件地址：" IMAGEPATH
    read -p "请输入VM名称：" VMNAME
    read -p "请输入启动VM个数：" VMNUM
    read -p "请输入内存大小（可用[$MEMAVLMB]MB）：" MEM
    read -p "请输入CPU核心数量（主机核心数量[$CPUCORE]）：" CPU

    IMAGEFORMAT=`qemu-img info $IMAGEPATH | grep -w "file format" | awk -F: '{print $NF}' | sed 's/[[:space:]]//g'`
    IMAGENAME=`qemu-img info $IMAGEPATH | grep -w "image" | awk -F: '{print $NF}' | sed 's/[[:space:]]//g'`
}


function CreateBridge(){
    echo "创建本机虚拟网卡......"
    read -p "请输入虚拟网卡名称：" NIC
    read -p "请输入虚拟网桥名称：" BRIDGE
    sudo ip link add name $BRIDGE type bridge
    sudo ip link set $BRIDGE up
}

function VMRun(){
    for ((NUM=0;NUM<$VMNUM;NUM++))
    do
        mkdir -p ~/VMM/VM$NUM
        cp $IMAGEPATH ~/VMM/VM$NUM/$VMNAME$NUM.$IMAGEFORMAT
        cd ~/VMM/VM$NUM
        NEWIMAGE="$(pwd)/$VMNAME$NUM.$IMAGEFORMAT"

        read -p "请输入虚拟网卡[$NIC$NUM]的IP地址（CIDR）：" IP
        sudo -S ip tuntap add dev $NIC$NUM mode tap >/dev/null 2>&1
        sudo -S ip link set dev $NIC$NUM up >/dev/null 2>&1
        sudo -S ip addr add dev $NIC$NUM $IP >/dev/null 2>&1
        sudo tunctl -t $NIC$NUM -u $(whoami)
        sudo ip link set $NIC$NUM up
        sleep 2s
        sudo ip addr add $IP dev $NIC$NUM
        sudo ip link set $NIC$NUM master $BRIDGE
        

        qemu-system-$(arch) \
        -m $MEM \
        -smp $CPU \
        --enable-kvm \
        -display gtk \
        -device nec-usb-xhci -device usb-tablet -device usb-kbd \
        -drive if=virtio,file=$NEWIMAGE,id=hd0,format=$IMAGEFORMAT,media=disk \
        -net nic -net tap,ifname=$NIC$NUM,script=no,downscript=no >/dev/null 2>&1 &
        echo "启动$VMNAME$NUM 成功！"
    done
}
function End(){
    echo "VM全部启动成功！"
    echo "请在VM内自行配置同网段IP![IP网段信息：$IP]"
}

Start
CreateBridge
VMRun
End