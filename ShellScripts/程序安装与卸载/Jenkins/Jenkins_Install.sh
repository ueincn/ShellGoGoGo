#!/bin/bash

#Program
#   Jenkins Install Scripts
#History
#2023   Ueincn  Release

function JenkinsIntsll(){
    wget -c --no-check-certificate https://mirrors.tuna.tsinghua.edu.cn/jenkins/war-stable/latest/jenkins.war
    if [ ! -d /opt/jenkins ]; then
        mkdir -p /opt/jenkins
    fi
    mv jenkins.war /opt/jenkins
    chmod -R +x /opt/jenkins
    echo "Jenkins installation complete."
    echo ""
    echo "Jenkins is starting ... "
    java -jar /opt/jenkins/jenkins.war --httpPort=6600
}

function JavaInstall(){
    if command -v java >/dev/null 2>&1; then
        echo "Java is installed ... "
        JenkinsIntsll
    else
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

function Main(){
    if command -v wget >/dev/null 2>&1; then
        JavaInstall
    else
        echo "Please try again after installing Wget ! "
    fi
}

if [ $UID -eq 0 ]; then
    Main
else
    echo "[ !! Please use sudo permissions or switch root to run the script !! ]"
fi
