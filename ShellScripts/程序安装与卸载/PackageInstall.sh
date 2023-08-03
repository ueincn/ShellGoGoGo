#!/bin/bash

#Program
#   deb软件包安装
#History
#2023   Ueincn  Release
#Using
#./PackageInstall PackageName

PKG=$1

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

function PackageInstall(){
    echo -ne "$PKG 安装中"
    apt-get install $PKG -y >/dev/null 2>&1 &
    SpinLine
}

function PackageCheck(){
    dpkg -l | grep $PKG >/dev/null 2>&1
    if [ $? == "0" ]; then
        echo "$PKG 已安装！"
        exit 0
    else
        echo "$PKG 未安装，执行安装程序！"
    fi
}

PackageCheck
PackageInstall