#!/bin/bash

#Program
#   系统检查
#History
#2023   Ueincn  Release


OS=`cat /etc/issue | awk '{print $1$2$3}'`
KERNEL=`uname -r | awk -F '-' '{print $1}'`
ARCH=`uname -m`
HOSTNAME=`cat /etc/hostname`
IS_YUM=`command -v yum | awk -F '/' '{print $NF}'`
IS_APT=`command -v apt | awk -F '/' '{print $NF}'`
IS_PACMAN=`command -v pacman | awk -F '/' '{print $NF}'`
IS_ZYPPER=`command -v zypper | awk -F '/' '{print $NF}'`
NIC=`cat /proc/net/dev | awk '{print $1}' | grep -v "Inter" | grep -v "face" | awk -F ':' '{print $1}' | grep -wv "lo" | xargs echo -n`
USERNAME=`whoami`

if [ "$IS_YUM" == "yum" ]; then
    PACKAGE="yum"
elif [ "$IS_PACMAN" == "pacman" ]; then
    PACKAGE="pacman"
elif [ "$IS_ZYPPER" == "zpyyer" ]; then
    PACKAGE="zypper"
elif [ "$IS_APT" == "apt" ]; then
    PACKAGE="apt"
else
    PACKAGE="NULL"
fi

function main(){
    echo "[系统信息]"
    echo "  系统版本：$OS"
    echo "  内核版本：$KERNEL"
    echo "  系统架构：$ARCH"
    echo "  包管理器：$PACKAGE"
    echo "  主机名称：$HOSTNAME"
    echo "  当前用户：$USERNAME"
    echo "  系统网卡：$NIC"
}
main