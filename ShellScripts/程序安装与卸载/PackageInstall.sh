#!/bin/bash

#Program
#   软件包安装通用脚本
#History
#2023   Ueincn  Release
#Using
#把Install函数中的"XXX"换成要安装的程序名，然后再根据使用的发行版安装包工具把47行更改下即可使用。

function ShowSpin(){
      $* &
      PID=$!
      local SPINLINE=('-' '/' '|' '\')
      sleep 0.05
      echo -n " ... "
      while kill -0 $PID 2>/dev/null
      do
            for SPIN in "${SPINLINE[@]}"
            do
                  echo -ne "$SPIN"
                  sleep 0.1
                  echo -ne "\b"
            done
      done
}
function StatusCode(){

      local PASS=$(tput setaf 2)
      local FAIL=$(tput setaf 1)
      local CLEAR=$(tput sgr0)
      if [ $? -eq 0 ]; then
            echo -e "\b${PASS}PASS${CLEAR}"
      else
            echo -e "\b${FAIL}FAIL${CLEAR}"
      fi
}
function EchoTitle(){
      echo "$*"
}
function EchoSubTitle(){
      echo -n "    $*"
}
function Install(){
      EchoTitle "程序开始安装:"
      EchoSubTitle "Install XXX"
      apt-get install XXX >/dev/null 2>&1
      StatusCode
}
ShowSpin Install