#!/bin/bash
#Program
#    MariaDB Install Scripts
#History
#2023   Ueincn  Release
# 已测试发行版
# RHEL: [8.0]
# CentOS: [7.9.2009]

function MariaDBVerison(){
    echo "Mariadb installation version list: "
    VERSIONLIST=("10.4.30" "10.5.21" "10.6.14" "10.7.8" "10.8.8" "10.9.7" "10.10.5" "10.11.4" "11.0.2")
    PS3="Please select: "
    select MARIADBVERSION in "${VERSIONLIST[@]}"; do
        break;
    done
}

function OSCheck(){
    COMMAND=$(sudo dmesg | grep "Linux version")
    #Debian
    if echo $COMMAND | grep -E "Debian|debian|DEBIAN" >/dev/null 2>&1; then
        OS="debian"
        OS_NAME=$(cat /etc/os-release | grep -w "NAME" | awk -F '"' '{print $2}') 
        OS_VERSION=$(cat /etc/os-release | grep -w "VERSION" | awk -F '"' '{print $2}' | awk -F '(' '{print $1}') 
        OS_KERNAL=$(uname -r | awk -F '-' '{print $1}')
        OS_ARCH=$(uname -m || arch)
        OS_HOSTNAME=$(uname -n || hostname)
    #Ubuntu
    elif echo $COMMAND | grep -E "Ubuntu|ubuntu|UBUNTU" >/dev/null 2>&1; then
        OS="ubuntu"
        OS_NAME=$(cat /etc/os-release | grep -w "NAME" | awk -F '"' '{print $2}') 
        OS_VERSION=$(cat /etc/os-release | grep -w "VERSION" | awk -F '"' '{print $2}' | awk -F '(' '{print $1}') 
        OS_KERNAL=$(uname -r | awk -F '-' '{print $1}')
        OS_ARCH=$(uname -m || arch)
        OS_HOSTNAME=$(uname -n || hostname)
    #CentOS
    elif echo $COMMAND | grep -E "CentOS|centos|CENTOS" >/dev/null 2>&1; then
        OS="centos"
        OS_NAME=$(cat /etc/os-release | grep -w "NAME" | awk -F '"' '{print $2}') 
        OS_VERSION=$(cat /etc/os-release | grep -w "VERSION" | awk -F '"' '{print $2}' | awk -F '(' '{print $1}' | awk '{print $1}') 
        OS_KERNAL=$(uname -r | awk -F '-' '{print $1}')
        OS_ARCH=$(uname -m || arch)
        OS_HOSTNAME=$(uname -n || hostname)
    #Red Hat Enterprise Linux
    elif echo $COMMAND | grep -E "Red Hat|redhat|REDHAT" >/dev/null 2>&1; then
        OS="rhel"
        OS_NAME=$(cat /etc/os-release | grep -w "NAME" | awk -F '"' '{print $2}') 
        OS_VERSION=$(cat /etc/os-release | grep -w "VERSION" | awk -F '"' '{print $2}' | awk -F '(' '{print $1}' | awk '{print $1}') 
        OS_KERNAL=$(uname -r | awk -F '-' '{print $1}')
        OS_ARCH=$(uname -m || arch)
        OS_HOSTNAME=$(uname -n || hostname)
    #Archlinux
    elif echo $COMMAND | grep -E "Archlinux|archlinux|ARCHLINUX" >/dev/null 2>&1; then
        OS="archlinux"
        OS_NAME=$(cat /etc/os-release | grep -w "NAME" | awk -F '"' '{print $2}') 
        OS_VERSION="null"
        OS_KERNAL=$(uname -r | awk -F '-' '{print $1}')
        OS_ARCH=$(uname -m || arch)
        OS_HOSTNAME=$(uname -n || hostname)
    #OpenSUSE
    elif echo $COMMAND | grep -E "Suse|suse|SUSE" >/dev/null 2>&1; then
        OS="opensuse"
        OS_NAME=$(cat /etc/os-release | grep -w "NAME" | awk -F '"' '{print $2}') 
        OS_VERSION=$(cat /etc/os-release | grep -w "VERSION" | awk -F '"' '{print $2}') 
        OS_KERNAL=$(uname -r | awk -F '-' '{print $1}')
        OS_ARCH=$(uname -m || arch)
        OS_HOSTNAME=$(uname -n || hostname)
    else
        OS="null"
    fi
}
function RHELRepo(){
    cat >/etc/yum.repos.d/mariadb.repo <<EOF
[mariadb]
name=MariaDB
baseurl=https://mirrors.ustc.edu.cn/mariadb/yum/$MARIADBVERSION/$OS/$OS_VERSION/$OS_ARCH
gpgkey=https://mirrors.ustc.edu.cn/mariadb/yum/RPM-GPG-KEY-MariaDB
gpgcheck=1
EOF
    yum clean all
    yum makecache
}

function CentOSRepo(){
    cat >/etc/yum.repos.d/mariadb.repo <<EOF
[mariadb]
name=MariaDB
baseurl=https://mirrors.ustc.edu.cn/mariadb/yum/$MARIADBVERSION/$OS/$OS_VERSION/$OS_ARCH
gpgkey=https://mirrors.ustc.edu.cn/mariadb/yum/RPM-GPG-KEY-MariaDB
gpgcheck=1
EOF
    yum clean all
    yum makecache
}

function MariadbInstall(){
    case $OS in
        "rhel")
            RHELRepo
            yum module disable mysql -y
            yum module disable mariadb -y
            yum install -y MariaDB-server MariaDB-client
            systemctl enable --now mariadb
            echo ""
            echo "Mariadb $MARIADBVERSION installation complete! "
            ;;
        "centos")
            CentOSRepo
            #需要先开启EPEL库，不然安装MariaDb时会提示缺少软件包pv（pv位于EPEL系统信息库中）
            yum install -y epel-release
            yum install -y MariaDB-server MariaDB-client
            systemctl enable --now mariadb
            echo ""
            echo "Mariadb $MARIADBVERSION installation complete! "
            ;;
        *)
            echo "null"
            exit 1
            ;;
    esac
}

if [[ "$UID" != "0" ]]; then
    echo ""
    echo "[ !! 请使用sudo权限或切换root运行脚本!! ]"
    echo ""
    OSCheck
    echo "[系统信息]"
    echo "系    统：$OS_NAME"
    echo "版    本：$OS_VERSION"
    echo "架    构：$OS_ARCH"
    echo "内核版本：$OS_KERNAL"
    echo "主机名称：$OS_HOSTNAME"
    echo "当前工作目录：$PWD"
    echo ""
    exit 1
fi

MariaDBVerison
OSCheck
MariadbInstall