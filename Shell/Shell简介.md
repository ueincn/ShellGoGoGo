# Shell
Shell 是什么？
- 一个用户跟操作系统之间交互的命令解释器。
- 一个用 C 语言编写的程序，它是用户使用 Linux 的桥梁。
- 既是一种命令语言，又是一种程序设计语言。
- 指一种应用程序，这个应用程序提供了一个界面，用户通过这个界面访问操作系统内核的服务。

# Shell Scripts
 Shell Script 是利用 Shell 的功能所写的一个“程序 （Program）”，这个程序是使用纯文本文件，将一些 Shell 的语法与指令（含外部指令）写在里面， 搭配正则表达式、管道命令与数据重定向等功能，以达到想要的处理目的。

 # Shell 环境
 Shell 编程跟 JavaScript、php 编程一样，只需要有一个能编写代码的文本编辑器和一个能解释执行的脚本解释器。

Linux 的 Shell 种类众多，常见的有：
- Bourne Shell（/usr/bin/sh或/bin/sh）
- Bourne Again Shell（/bin/bash）
- C Shell（/usr/bin/csh）
- K Shell（/usr/bin/ksh）
- Shell for Root（/sbin/sh）
- ……

要想知道操作系统支持哪种Shell类型，可在终端中输入以下命令：
```bash
cat /etc/shells
```
要想知道bash在操作系统中的位置，可键入以下命令，将获得一个特定的位置：
```bash
which bash
```