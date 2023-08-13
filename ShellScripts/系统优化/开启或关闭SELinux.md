#### 开启SELinux
1. 运行以下命令，编辑SELinux的config文件。
```bash
sudo vi /etc/selinux/config
```
2. 找到SELINUX=disabled，按i进入编辑模式，通过修改该参数开启SELinux。
```bash
[root@localhost ~]# cat /etc/selinux/config

# This file controls the state of SELinux on the system.
# SELINUX= can take one of these three values:
#     enforcing - SELinux security policy is enforced.
#     permissive - SELinux prints warnings instead of enforcing.
#     disabled - No SELinux policy is loaded.
SELINUX=disabled
# SELINUXTYPE= can take one of three values:
#     targeted - Targeted processes are protected,
#     minimum - Modification of targeted policy. Only selected processes are protected. 
#     mls - Multi Level Security protection.
SELINUXTYPE=targeted
```
可以根据需求修改参数，开启SELinux有以下两种模式：
- 强制模式SELINUX=enforcing：表示所有违反安全策略的行为都将被禁止。
- 宽容模式SELINUX=permissive：表示所有违反安全策略的行为不被禁止，但是会在日志中作记录。
3. 修改完成后，按下键盘Esc键，执行命令:wq，保存并退出文件。
4. 重启`reboot`

PS：如果遇到无法重启，则需要在根目录下新建autorelabel文件。
在根目录下新建隐藏文件autorelabel，实例重启后，SELinux会自动重新标记所有系统文件。
```bash
sudo touch /.autorelabel
```
然后再重启即可进入系统。
#### 关闭SELinux
```bash
#!/bin/bash
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
function EchoSubTitle(){
      echo -n "    $*"
}
function DisableSELinux(){
      EchoSubTitle "SELinux Disable"
      sleep 0.5
      SELINUXSTATUS=$(getenforce 2>/dev/null)
      if [ $? -eq 0 ]; then 
            if [[ $SELINUXSTATUS -eq "Enforcing" ]]; then
                  cp /etc/selinux/config /etc/selinux/config.bak >/dev/null 2>&1
                  sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config >/dev/null 2>&1
            fi
            StatusCode
      else
            echo -e "\b$(tput setaf 7)System not exist SELinux!$(tput sgr0)"
      fi
}
ShowSpin DisableSELinux
echo " SELinux禁用成功，重启系统生效即可！"
```