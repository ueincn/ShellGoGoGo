#!/bin/bash

#Program
#   KVM 管理平台
#History
#2023   Ueincn  Release

#https://documentation.suse.com/zh-cn/sles/15-SP2/html/SLES-all/cha-kvm.html 虚拟化指南
#https://documentation.suse.com/zh-cn/sles/15-SP2/html/SLES-all/cha-libvirt-config-virsh.html XML文件配置指南

function EnvCheck(){
    #系统虚拟化环境检测
    echo "系统环境检测开始："
    egrep "(svm|vmx)" /proc/cpuinfo >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "  系统虚拟化支持检测 ... PASS"
    else
        echo "  系统虚拟化支持检测 ... FAIL"
    fi

    lsmod | grep kvm >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "  KVM 模块检测 ... PASS"
    else
        echo "  KVM 模块检测 ... FAIL"
    fi
    echo "系统环境检测结束，返回主界面！"
    echo ""
    main
}

function KvmInstall(){
    #KVM相关软件安装
    echo "KVM 环境开始安装："

    echo -ne "  qemu-system Installing"
    apt-get install qemu-system -y >/dev/null 2>&1 &
    SpinLine

    echo -ne "  qemu-system-img Installing"
    apt-get install qemu-system -y >/dev/null 2>&1 &
    SpinLine

    echo -ne "  qemu-system-gui Installing"
    apt-get install qemu-gui -y >/dev/null 2>&1 &
    SpinLine

    echo -ne "  libvirt-daemon-system Installing"
    apt-get install libvirt-daemon-system -y >/dev/null 2>&1 &
    SpinLine

    echo -ne "  bridge-utils Installing"
    apt-get install bridge-utils -y >/dev/null 2>&1 &
    SpinLine

    echo -ne "  libvirt-clients Installing"
    apt-get install libvirt-clients -y >/dev/null 2>&1 &
    SpinLine

    sudo systemctl restart libvirtd.service
    sudo systemctl enable libvirtd.service
    echo "    KVM 环境启动 ... PASS"

    echo "KVM环境安装结束，返回主界面！"
    main
    echo ""
}

function VMCreate(){
    #虚拟机创建
    echo "/========== 虚拟机实例创建 ==========/"
    echo "虚拟机实例磁盘镜像生成："
    read -p "    请输入磁盘镜像名称：" IMAGENAME
    SelectFormat
    UNIT="G"
    read -p "    请输入磁盘镜像大小（单位GB）：" IMAGESIZE
    IMAGECREATE=`qemu-img create -f $FORMAT $IMAGENAME.$FORMAT $IMAGESIZE$UNIT`
    echo "    磁盘镜像生成中 ... PASS"
    DISKPATH="$(pwd)/$IMAGENAME.$FORMAT"
    echo ""
    echo "虚拟机实例系统安装："
    read -p "    请输入内存大小：" VMMEM
    read -p "    请输入CPU个数：" VMCPU
    read -p "    是否开启图形化(yes/no)：" SELECTGRAPHIC
    if [ $SELECTGRAPHIC == "yes" ]; then
        GRAPHIC="-device VGA"
    else
        GRAPHIC="-nographic"
    fi
    read -p "    请输入ISO文件地址：" ISOPATH
    echo "    虚拟机实例创建中 ... PASS"
    sleep 0.1
    echo "    虚拟机实例启动中 ... PASS"
    qemu-system-$(arch) -m $VMMEM -smp $VMCPU $(pwd)/$IMAGENAME.$FORMAT -cdrom $ISOPATH >/dev/null 2>&1 &
    echo ""
    echo "    虚拟机实例信息："
    echo "    实例名称：$IMAGENAME"
    echo "    镜像格式：$FORMAT"
    echo "    镜像大小：$IMAGESIZE$UNIT"
    echo "    镜像位置：$DISKPATH"
}

function VMManager(){
    #虚拟机管理
    echo "/========== 虚拟机实例启动管理 ==========/"
    echo "  1.实例单开"
    echo "  2.实例多开"
    read -p "  请选择：" RUN
    case $RUN in
        '1')
            VMManagerSingle
            ;;
        '2')
            VMManagerMultiple
            ;;
        *)
            echo "    输入格式错误！"
            exit 1
            ;;
    esac

}

function VMManagerSingle(){
    MEMAVLMB=`free | sed -n 2p | awk '{mem=$NF/1024}END{print int(mem)}'`
    CPUCORE=`cat /proc/cpuinfo | grep -w "cpu cores" | sed -n 1p | awk -F: '{print $NF}' | sed 's/[[:space:]]//g'`

    read -p "请输入镜像地址：" IMAGEPATH
    read -p "请输入内存大小（可用[$MEMAVLMB]MB）：" MEM
    read -p "请输入CPU核心数量（主机核心数量[$CPUCORE]）：" CPU

    IMAGEFORMAT=`qemu-img info $IMAGEPATH | grep -w "file format" | awk -F: '{print $NF}' | sed 's/[[:space:]]//g'`

    qemu-system-$(arch) \
    -m $MEM \
    -smp $CPU \
    -display gtk \
    -device nec-usb-xhci -device usb-tablet -device usb-kbd \
    -drive if=virtio,file=$IMAGEPATH,id=hd0,format=$IMAGEFORMAT,media=disk \
    -net nic -net tap,ifname=tap0,script=no,downscript=no >/dev/null 2>&1 &

    echo "实例启动 ... PASS"
}

function VMManagerMultiple(){
    MEMAVLMB=`free | sed -n 2p | awk '{mem=$NF/1024}END{print int(mem)}'`
    CPUCORE=`cat /proc/cpuinfo | grep -w "cpu cores" | sed -n 1p | awk -F: '{print $NF}' | sed 's/[[:space:]]//g'`

    read -p "请输入VM镜像源文件地址：" IMAGEPATH
    read -p "请输入VM名称：" VMNAME
    read -p "请输入启动VM个数：" VMNUM
    read -p "请输入内存大小（可用[$MEMAVLMB]MB）：" MEM
    read -p "请输入CPU核心数量（主机核心数量[$CPUCORE]）：" CPU

    IMAGEFORMAT=`qemu-img info $IMAGEPATH | grep -w "file format" | awk -F: '{print $NF}' | sed 's/[[:space:]]//g'`
    IMAGENAME=`qemu-img info $IMAGEPATH | grep -w "image" | awk -F: '{print $NF}' | sed 's/[[:space:]]//g'`

    for ((NUM=0;NUM<$VMNUM;NUM++))
    do
        mkdir -p ~/VMM/VM$NUM
        cp $IMAGEPATH ~/VMM/VM$NUM/$VMNAME$NUM.$IMAGEFORMAT
        cd ~/VMM/VM$NUM
        NEWIMAGE="$(pwd)/$VMNAME$NUM.$IMAGEFORMAT"

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

function SpinLine(){
    PID=$!
    echo -ne " ... "
    while kill -0 $PID 2>/dev/null
    do
        spin[0]="-"
        spin[1]="\\"
        spin[2]="|"
        spin[3]="/"
        for i in "${spin[@]}"
        do
            echo -ne "$i"
            sleep 0.1
            echo -ne "\b"
        done
    done
    if [ $? -eq "0" ]; then
        echo "PASS"
    fi
}

function SelectFormat(){
    echo "    请选择磁盘镜像格式："
    echo "    1) qcow2"
    echo "    2) raw"
    read -p "    请选择磁盘镜像格式前数字：" IMAGEFORMAT
    case $IMAGEFORMAT in
        '1')
            FORMAT="qcow2"
            ;;
        '2')
            FORMAT="raw"
            ;;
        *)
            echo "    输入格式错误！"
            exit 1
            ;;
    esac
}

function main(){

    echo "/========== 欢迎访问KVM管理工具平台 ==========/"
    echo "  1.系统环境检测"
    echo "  2.KVM环境安装"
    echo "  3.虚拟机实例创建"
    echo "  4.虚拟机实例启动"
    echo "  5.退出"
    echo ""
    read -p  "请选择：" SELECT
    case $SELECT in 
        "1")
            EnvCheck
            ;;
        "2")
            KvmInstall
            ;;
        "3")
            VMCreate
            ;;
        "4")
            VMManager
            ;;
        "5")
            echo "系统已退出 Bye."
            exit 0
            ;;
        *)
            echo "输入无效，请重新输入！"
            main
            ;;
    esac
}

main