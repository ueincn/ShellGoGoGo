#!/bin/bash

#OpenJDK17U-jre_x64_linux_hotspot_17.0.8_7.tar.gz
function JavaInstall(){
    if command -v wget >/dev/null 2>&1; then
        wget -c --no-check-certificate https://mirrors.tuna.tsinghua.edu.cn/Adoptium/17/jre/x64/linux/OpenJDK17U-jre_x64_linux_hotspot_17.0.8_7.tar.gz
        if [ ! -d /opt/java ]; then
            mkdir -p /opt/java
        fi
        tar -zxvf OpenJDK17U-jre_x64_linux_hotspot_17.0.8_7.tar.gz --strip-components 1 -C /opt/java
        cd ../ && rm -rf OpenJDK17U-jre_x64_linux_hotspot_17.0.8_7.tar.gz
        cp /etc/profile /etc/profile.bak
        JavaEnv
        source /etc/profile
        echo ""
        echo "Java installation complete."
        echo "Print the Java version ... "
        echo ""
        java --version
    else
        echo "Please try again after installing Wget ! "
    fi
}

function JavaEnv(){
        cat >/etc/profile <<EOF 
export JAVA_HOME=/opt/java
export JRE_HOME=$JAVA_HOME/jre
export CLASSPATH=.:$JAVA_HOME/lib:$JRE_HOME/lib
export PATH=$JAVA_HOME/bin:$PATH
EOF
}

if [ $UID -eq 0 ]; then
    JavaInstall
else
    echo "[ !! Please use sudo permissions or switch root to run the script !! ]"
fi