#### 环境检测
```
#查看cpu是否支持虚拟化
$ egrep "(svm|vmx)" /proc/cpuinfo 
注：
vmx 对应inter 的cpu
svm 对应amd 的cpu
需在主板bios 打开虚拟化选项，多数计算机默认处于打开状态
```
```
#内核支持
$ lsmod | grep kvm
```
#### 软件列表
```
#必备
libvirt-daemon-system >>libvirtd
libvirt-clients >>virsh
virtinst >>virt-install/virt-viewer
qemu-system >>qemu-system-x86_64
qemu-system-gui >>gtk
qemu-img
bridge-utils

#选装
virt-manager
```

#### 启动命令
```
#启动libvirtd
systemctl restart libvirtd.service #启动libvirtd
systemctl status libvirtd.service #查看启动状态
```

### KVM配置
####virsh 命令行管理工具
```
#virsh（虚拟shell），基于命令行的管理工具，可以实现简单的资源管理。支持交互模式
virsh shutdown deepin1 #正常关闭vm 虚拟机
virsh start deepin1 #启动kvm 虚拟机
virsh destroy deepin1 #强制关闭kvm 虚拟机
virsh list #显示本地活动虚拟机
virsh list --all #查看所有虚拟机
virsh suspend deepin1 #挂起kvm 虚拟机
virsh resume deepin1 #恢复被挂起虚拟机
virsh dominfo deepin1 #查看指定虚拟机的配置摘要信息
virsh undefine deepin1 #删除kvm 虚拟机（如果虚拟机处于runing，一旦关闭就会消失）
virsh dumpxml deepin1 #显示虚拟机的当前配置文件
virsh define deepin2.xml #通过配置文件定义一个虚拟机（这个虚拟机还不是活动的）
virsh autostart deepin1 #虚拟机设为自动启动（成/etc/libvirt/qemu/autostart/）
virsh autostart --disable deepin1 #取消自动启动
virsh edit deepin1 #编辑配置文件（一般是在刚定义完虚拟机之后）
virsh setmem deepin1 512000 #给虚拟机设置内存大小
virsh setvcpus deepin1 4 #给虚拟机设置cpu 个数

#快照管理
#快照（raw 格式的磁盘无法创建快照）
virsh snapshot-list test12 #查看快照
virsh snapshot-create test12 #生成快照
virsh snapshot-create-as test12 snap1 #自定义快照名
virsh snapshot-revert test12 snap1 #快照恢复虚拟机
virsh snapshot-delete test12 snapname #删除指定快照
virsh snapshot-current test12
```
#### qemu-img 磁盘镜像管理工具
```
qemu-img --help
    check 检查完整性
    create 创建镜像
    commit 提交更改
    compare 比较
    convert 转换
    info 获得信息
    map 映射
    snapshot 快照管理
    rebase 在已有的镜像的基础上创建新的镜像
    resize 调整大小
    amend 修订镜像格式选
#qemu-img snapshot -l /kvm/img/test12.qcow2 #查看磁盘快照
```