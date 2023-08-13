1. 判断当前执行环境是不是ROOT权限：
```bash
#! /bin/bash

if [ $UID -eq 0 ]; then
    echo " Is Root! "
else
    echo " Not Root! "
fi
```
```bash
#! /bin/bash

if [ $UID -eq 0 ]; then
    echo "Is Superuser! "
else
    echo "[ !! Please use sudo permissions or switch root to run the script !! ]"
fi
```
2. 判断用户是否有sudo权限
如果用户有sudo权限，则`$?`返回值是0；没有sudo权限，则`$?`返回值为非0.
```bash
#! /bin/bash

sudo -v >/dev/null 2>&1
if [ $? -eq 0 ]; then
    echo " Is sudo! "
    exit 0
else
    echo " Not sudo! "
fi
```

3. 判断系统是否存在sudo软件包
   支持APT和RPM软件包系列发行版。
```bash
#！/bin/bash

if command -v apt >/dev/null 2>&1; then
    command -v sudo >/dev/null 2>&1 && dpkg -l | grep sudo >/dev/null 2>&1
    if [ $? -eq 0 ]; then 
        echo "system exist sudo package! "
    else
        echo "system not exist sudo package! "
    fi
else command -v yum >/dev/null 2>&1
    command -v sudo >/dev/null 2>&1 && rpm -qa | grep sudo >/dev/null 2>&1
    if [ $? -eq 0 ]; then 
        echo "system exist sudo package! "
    else
        echo "system not exist sudo package! "
    fi
fi
```