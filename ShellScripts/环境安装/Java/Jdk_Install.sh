#!/bin/bash

#OpenJDK17U-jdk_x64_linux_hotspot_17.0.8_7.tar.gz
function JavaInstall(){
    if command -v wget >/dev/null 2>&1; then
        wget -c --no-check-certificate https://mirrors.tuna.tsinghua.edu.cn/Adoptium/17/jdk/x64/linux/OpenJDK17U-jdk_x64_linux_hotspot_17.0.8_7.tar.gz
        if [ ! -d /opt/java ]; then
            mkdir -p /opt/java
        fi
        tar -zxvf OpenJDK17U-jdk_x64_linux_hotspot_17.0.8_7.tar.gz --strip-components 1 -C /opt/java
        cd ../ && rm -rf OpenJDK17U-jdk_x64_linux_hotspot_17.0.8_7.tar.gz
        JavaEnv
        echo ""
        echo "Java installation complete."
        echo "Print the Java version ... "
        echo ""
        java --version
        echo ""
        echo "Reboot system is recommended!"
    else
        echo "Please try again after installing Wget ! "
    fi
}

function JavaEnv(){
    cp /etc/profile /etc/profile.bak
    echo "export JAVA_HOME=/opt/java" >> /etc/profile
    source /etc/profile
    echo "export PATH=$PATH:$JAVA_HOME/bin" >> /etc/profile
    echo "export CLASSPATH=.:$JAVA_HOME/lib:$JAVA_HOME/lib" >> /etc/profile
    source /etc/profile
}

if [ $UID -eq 0 ]; then
    JavaInstall
else
    echo "[ !! Please use sudo permissions or switch root to run the script !! ]"
fi