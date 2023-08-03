# Bash
BASH是Bourne Again Shell的缩写，Bunne Again Shell是一个双关的名称，是对Bourne Shell(即Steven Bourne发明)的致敬。
Bash是由Brian Fox编写的Shell程序，是Bourne Shell程序“sh”的升级版本。这是一个开源GNU项目。它于1989年发布，是GNU/Linux操作系统最流行的shell发行版之一。它提供了比Bourne Shell更好的功能，可用于编程和交互使用。它包括命令行编辑，键绑定，无限制大小的命令历史记录等。
用基本术语来说，Bash是一个命令行解释器，通常在文本窗口中运行，用户可以在其中解释命令以执行各种操作。这些命令在文件中作为一系列命令的组合称为Shell脚本。Bash可以从Shell脚本读取和执行命令。
Bash是大多数Linux发行版和苹果Mac OS的默认登录Shell。对于Windows 10，在Solaris 11中具有版本和默认用户Shell程序也可以访问它。

# Bash历史
- 以前，UNIX世界中的大多数软件都是专有的和封闭源代码。UNIX系统也不是开源的，必须使用shell。当时在/bin/sh命令下存在一个由“ Bourne Shell”命名的shell，shell是专有的并且是封闭源代码。Bourne是以发明家史蒂文·伯恩(Steven Bourne)的名字命名。
-  当时，Richard Stallman与自由软件基金会(FSF)一起开始GNU项目，以创建一个与UNIX兼容的操作系统，并将所有目标都视为开源。开发缺乏进展，需要一个可以运行现有Shell脚本的免费Shell。这是他作为FSF资助的少数项目之一，必须建立一个完全开源的系统。然后在1988年1月110日，Brian Fox(FSF雇员)开始在Bash上进行编码，并于1989年6月8日发布了Bash的beta版本0.99
- Brian Fox一直担任FSF的主要Bash维护者，直到1993年。然后他从FSF辞退，而Chet Ramey(FSF的早期贡献者)承担了责任。
- 此外，1996年12月23日，切特·拉米(Chet Ramey)向公众发布了另一个bash版本2.0，该版本具有比旧bash版本更多的新功能。
- 现在，切特·拉米(Chet Ramey)以官方的bash维护者而闻名，他继续在bash方面做进一步的改进。- Bash是Linux附带的标准Shell。它是当今最流行的开源Shell，并且具有在下一主题中阅读的各种生产功能。它也可用于Linux发行版，MacOS，Solaris 11和Windows 10。它通过许多改进为用户提供最佳体验。

# Bash特点
- 由于Bash源自原始UNIX Bourne Shell，因此与sh兼容。 它具有Korn和C shell的最佳和有用功能，例如目录操纵，作业控制，别名等。
- Bash可以通过单字符命令行选项(-a，-b，-c，-i，-l，-r等)以及多字符命令行选项(例如--debugger，--help，--login等。
- Bash启动文件是Bash启动时读取并执行的脚本。每个文件都有其特定用途，这些文件的集合用于创建环境。
- Bash由键绑定组成，通过该键绑定可以设置自定义的编辑键序列。
- Bash包含一维数组，可以使用它们轻松地引用和操作数据列表。
- Bash由控制结构组成，例如专门用于菜单生成的选择构造。
- Bash中的目录堆栈指定列表中最近访问的目录的历史记录。 示例：pushed内建用于将目录添加到堆栈中，popd用于从堆栈中删除目录，而dirs内建用于显示目录堆栈的内容。
- Bash还包含用于环境安全的受限模式。如果bash以名称rbash开头，或者bash --restricted或调用时传递bash -r选项，则shell受限制。

