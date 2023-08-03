#!bin/bash

#Program
#   Pycharm Community Install
#History
#2023   Ueincn  Release

#Debian/Ubuntu
function PycharmInstall(){
    echo "Pycharm Community 安装工具"
    #安装wget
    echo -n "    Wget 安装中"
    sudo apt-get install wget -y >/dev/null 2>&1 &
    SpinLine

    #下载Pycharm Community并解压
    echo -n "    Pycharm Community 下载解压中"
    wget https://download.jetbrains.com.cn/python/pycharm-community-2023.2.tar.gz &
    SpinLine
    tar -xvf pycharm-community-2023.2.tar.gz &
    sudo mv pycharm-community-2023.2 /opt/pycharm
    sudo chmod -R 777 /opt/pycharm/

    #配置Pycharm Community
    sudo cp /opt/pycharm/bin/pycharm.png /usr/share/icons/hicolor/128x128/apps/
    sudo cat /usr/share/applications/pycharm.desktop << EOF
[Desktop Entry]
Name=PycharmCommunity
Exec=/opt/pycharm/bin/pycharm.sh %U
StartupNotify=true
Terminal=false
Icon=pycharm
Type=Application
Categories=Network;WebBrowser;
EOF
    echo "    Pycharm Community 配置中 ... PASS"

    #更新图标缓存
    gtk-update-icon-cache /usr/share/icons/hicolor
    echo "Pycharm Community安装完成，请在启动器中找到并启动它！"
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

PycharmInstall
