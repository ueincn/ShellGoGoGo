#!/bin/bash

#Program
#   系统 KVM 环境检测
#History
#2023   Ueincn  Release

function EnvCheck(){
    #系统虚拟化环境检测
    echo "系统环境检测开始："
    echo ""
    egrep "(svm|vmx)" /proc/cpuinfo >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "    系统虚拟化支持检测 ... PASS"
    else
        echo "    系统虚拟化支持检测 ... FAIL（请开启系统虚拟化支持！）"
    fi

    lsmod | grep kvm >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "    KVM 模块检测 ... PASS"
    else
        echo "    KVM 模块检测 ... FAIL（请开启KVM模块！）"
    fi
    echo ""
    echo "系统环境检测结束！"
}

EnvCheck