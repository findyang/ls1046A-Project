### 2023/11/20

由于wifi以及usb没有调通，无法通过wifi和usb-wifi联网下载安装ROS，由于时间节点的原因，先暂时寻找能直接在预做的根文件系统中先安装ROS以及其他的ROS功能包依赖库，加上有线网口能提供的IP配置（暂未能与其他设备ping通，只能本地调试，无法多机通信，但已经能提供IP）。上诉若完成，已能直接驱动ROS启动。

#### 1 安装依赖

安装debootstrap和qemu-user-static

```shell
# apt install apt-transport-https qemu qemu-user-static binfmt-support debootstrap
sudo apt-get update
sudo apt-get install qemu-user-static #minbase用这个 qemu
sudo apt-get install debootstrap 
```



#### 2 准备脚本

创建ch-mount.sh文件，写入以下脚本

```shell
#!/bin/bash
# 
function mnt() {
  echo "MOUNTING..."
  sudo mount -t proc /proc ${2}proc
  sudo mount -t sysfs /sys ${2}sys
  sudo mount -o bind /dev ${2}dev
  sudo mount -o bind /dev/pts ${2}dev/pts
  echo "CHROOT..."
  sudo chroot ${2}
  echo "Success!"
}
function umnt() {
  echo "UNMOUNTING"
  sudo umount ${2}proc
  sudo umount ${2}sys
  sudo umount ${2}dev/pts
  sudo umount ${2}dev
}
if [ "$1" == "-m" ] && [ -n "$2" ] ;
then
    mnt $1 $2
elif [ "$1" == "-u" ] && [ -n "$2" ];
then
    umnt $1 $2
else
  echo ""
  echo "Either 1'st, 2'nd or both parameters were missing"
  echo ""
  echo "1'st parameter can be one of these: -m(mount) OR -u(umount)"
  echo "2'nd parameter is the full path of rootfs directory(with trailing '/')"
  echo ""
  echo "For example: ch-mount -m /media/sdcard/"
  echo ""
  echo 1st parameter : ${1}
  echo 2nd parameter : ${2}
fi
```

创建 mkrootfs.sh文件，写入以下脚本，其中2048取决于你的根文件系统实际大小，比如安装了桌面环境后若大小超过2048M，就改大一点，目前已使用nxp构建好的ubuntu-base暂时可以不需要这个

```shell
#!/bin/bash
# 
dd if=/dev/zero of=ubuntu-rootfs.img bs=1M count=2048
sudo  mkfs.ext4  ubuntu-rootfs.img
rm -r rootfs
mkdir  rootfs
sudo mount ubuntu-rootfs.img rootfs/
sudo cp -rfp ubuntu-rootfs/*  rootfs/
sudo umount rootfs/
e2fsck -p -f ubuntu-rootfs.img
resize2fs  -M ubuntu-rootfs.img
```

chmod a+x ch-mount.sh和 chmod a+x mkrootfs.sh给执行权限。



#### 3 minbase构建

ubuntu-base 是Ubuntu官方构建的ubuntu最小文件系统，包含debain软件包管理器，基础包大小通常只有几十兆，其背后有整个ubuntu软件源支持，ubuntu软件一般稳定性比较好，基于ubuntu-base按需安装Linux软件，深度可定制…，常用于嵌入式rootfs构建。

嵌入式常见的几种文件系统构建方法：busybox、yocto、builroot，我觉得它们都不如Ubuntu方便，强大的包管系统，有强大的社区支持，可以直接apt-get install来安装新软件包。本文介绍了如何基于Ubuntu-base构建完整的ubuntu 系统。这里注意需要拷贝网络配置，最后不需要直接制作镜像，而是由nxp的flex-install工具烧录到SD卡中。

```shell
# 1.下载minbase版本
wget http://cdimage.ubuntu.com/ubuntu-base/releases/20.04.5/release/ubuntu-base-20.04.5-base-arm64.tar.gz
# 2.新建文件夹
mkdir ubuntu-base-20.04.5-rootfs 
# 3.解压minbase tar到新建文件夹
tar -xpf ubuntu-base-20.04.5-base-arm64.tar.gz  -C ubuntu-base-20.04.5-rootfs
# 4.拷贝网络配置,minbase是没有网络配置的,不然挂载进去上不了网
cp -b /etc/resolv.conf ubuntu-base-20.04.5-rootfs/etc/resolv.conf
# 5.拷贝qemu
cp /usr/bin/qemu-aarch64-static ubuntu-base-20.04.5-rootfs/usr/bin/
# 6.进入qemu
./ch-mount.sh -m ubuntu-base-20.04.5-rootfs #mount
#-------------------------qemu空间-------------------------------------
# 7.更新,这里面就是minbase,随便怎么玩都行
apt-get update
# 8.安装些常用工具
apt-get -y install  vim nfs-common  sudo ssh net-tools ethtool wireless-tools  xfce4-power-manager xinit  network-manager iputils-ping rsyslog   bash-completion lxtask htop  synaptic  --no-install-recommends
# 9.设置root密码
passwd root #连续输入两次密码即可
# 10.退出arm64模拟文件系统
exit
#-------------------------qemu空间-------------------------------------
./ch-mount.sh -u ubuntu-base-20.04.5-rootfs #umount
./mkrootfs.sh #制作镜像,注意这里要看脚本写的哪些文件夹,要对应上。
```

进入`/home/forlinx/nxp/flexbuild_lsdk1906/build/rfs/`目录

拷贝相关

```shell
cp -b /etc/resolv.conf rootfs_lsdk1906_LS_arm64_main/etc/resolv.conf
cp /usr/bin/qemu-aarch64-static rootfs_lsdk1906_LS_arm64_main/usr/bin/
```

使用挂载命令，即可进入预制的根文件系统

```shell
./ch-mount.sh -m /home/forlinx/nxp/flexbuild_lsdk1906/build/rfs/rootfs_lsdk1906_LS_arm64_main/
```

正常信息如下：

```shell
root@ubuntu:/home/forlinx/nxp/flexbuild_lsdk1906/build/rfs# ./ch-mount.sh -m /home/forlinx/nxp/flexbuild_lsdk1906/build/rfs/rootfs_lsdk1906_LS_arm64_main/
MOUNTING...
CHROOT...
root@ubuntu:/#
```

取消挂载使用命令

```shell
./ch-mount.sh -u /home/forlinx/nxp/flexbuild_lsdk1906/build/rfs/rootfs_lsdk1906_LS_arm64_main/
```

检查

检查一下依赖库是否已经是aarch64的

```shell
root@ubuntu:/# ls /usr/bin/qemu-aarch64-static
/usr/bin/qemu-aarch64-static
root@ubuntu:/# find -name "ld-linux-*"
./var/lib/aarch64-linux-gnu/ld-linux-aarch64.so.1
./var/lib/ld-linux-aarch64.so.1
./lib/aarch64-linux-gnu/ld-linux-aarch64.so.1
./lib/ld-linux-aarch64.so.1
root@ubuntu:/# dpkg --print-architecture
arm64
```



更新源

```shell
root@ubuntu:/# apt-get update
Get:1 http://ports.ubuntu.com/ubuntu-ports bionic-security InRelease [88.7 kB]
Hit:2 http://us.ports.ubuntu.com/ubuntu-ports bionic InRelease          
Get:3 http://us.ports.ubuntu.com/ubuntu-ports bionic-updates InRelease [88.7 kB]
Get:4 http://us.ports.ubuntu.com/ubuntu-ports bionic-updates/main arm64 Packages [1,845 kB]      Get:5 http://us.ports.ubuntu.com/ubuntu-ports bionic-updates/main Translation-en [554 kB]        Get:6 http://us.ports.ubuntu.com/ubuntu-ports bionic-updates/universe arm64 Packages [1,718 kB]  Fetched 4,294 kB in 48s (88.9 kB/s)                                                             Reading package lists... Done
```



测试安装udhcpc

```shell
root@ubuntu:/# apt-get install udhcpc
Reading package lists... Done
Building dependency tree       
Reading state information... Done
The following additional packages will be installed:
  busybox
The following NEW packages will be installed:
  busybox udhcpc
0 upgraded, 2 newly installed, 0 to remove and 1 not upgraded.
Need to get 370 kB of archives.
After this operation, 831 kB of additional disk space will be used.
Do you want to continue? [Y/n] y
Get:1 http://us.ports.ubuntu.com/ubuntu-ports bionic-updates/universe arm64 busybox arm64 1:1.27.2-2ubuntu3.4 [367 kB]
Get:2 http://us.ports.ubuntu.com/ubuntu-ports bionic-updates/universe arm64 udhcpc arm64 1:1.27.2-2ubuntu3.4 [2,944 B]                                                         
Fetched 370 kB in 15s (24.9 kB/s)                                                                                                                                              
E: Can not write log (Is /dev/pts mounted?) - posix_openpt (19: No such device)
Selecting previously unselected package busybox.
(Reading database ... 37680 files and directories currently installed.)
Preparing to unpack .../busybox_1%3a1.27.2-2ubuntu3.4_arm64.deb ...
Unpacking busybox (1:1.27.2-2ubuntu3.4) ...
Selecting previously unselected package udhcpc.
Preparing to unpack .../udhcpc_1%3a1.27.2-2ubuntu3.4_arm64.deb ...
Unpacking udhcpc (1:1.27.2-2ubuntu3.4) ...
Setting up busybox (1:1.27.2-2ubuntu3.4) ...
Setting up udhcpc (1:1.27.2-2ubuntu3.4) ...
Processing triggers for man-db (2.8.3-2ubuntu0.1) ...
qemu: Unsupported syscall: 277
Processing triggers for initramfs-tools (0.130ubuntu3.13) ...
root@ubuntu:/# find -name "udhcpc"
./sbin/udhcpc
./etc/udhcpc
./usr/share/doc/udhcpc
./var/sbin/udhcpc
```

从安装上看应该没有什么问题



安装ROS相关

使用鱼香ROS安装工具

```shell
wget http://fishros.com/install -O fishros && . fishros
```

测试失败

```shell
Unknown host QEMU_IFLA type: 47
Unknown host QEMU_IFLA type: 48
Unknown host QEMU_IFLA type: 43
Unknown host QEMU_IFLA type: 47
Unknown host QEMU_IFLA type: 48
Unknown host QEMU_IFLA type: 43
Unknown host QEMU_IFLA type: 47
Unknown host QEMU_IFLA type: 48
Unknown host QEMU_IFLA type: 43
sudo: unable to resolve host ubuntu
```

直接安装，不使用工具，出现同样的问题，测试失败

```shell
root@ubuntu:/# sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
Unknown host QEMU_IFLA type: 47
Unknown host QEMU_IFLA type: 48
Unknown host QEMU_IFLA type: 43
Unknown host QEMU_IFLA type: 47
Unknown host QEMU_IFLA type: 48
Unknown host QEMU_IFLA type: 43
Unknown host QEMU_IFLA type: 47
Unknown host QEMU_IFLA type: 48
Unknown host QEMU_IFLA type: 43
sudo: unable to resolve host ubuntu
root@ubuntu:/# cat /etc/apt/sources.list.d/ros-latest.list|tail
deb http://packages.ros.org/ros/ubuntu bionic main
root@ubuntu:/# apt-get update
Hit:1 http://ports.ubuntu.com/ubuntu-ports bionic-security InRelease
Get:2 http://packages.ros.org/ros/ubuntu bionic InRelease [4,680 B]                                                                     
Hit:3 http://us.ports.ubuntu.com/ubuntu-ports bionic InRelease                                                                                                                 
Hit:4 http://us.ports.ubuntu.com/ubuntu-ports bionic-updates InRelease                                                                                                         
Err:2 http://packages.ros.org/ros/ubuntu bionic InRelease                                                                                                                      
  The following signatures couldn't be verified because the public key is not available: NO_PUBKEY F42ED6FBAB17C654
0% [4 InRelease gpgv 88.7 kB]^C                                                                                                                                                
root@ubuntu:/# sudo apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
Unknown host QEMU_IFLA type: 47
Unknown host QEMU_IFLA type: 48
Unknown host QEMU_IFLA type: 43
Unknown host QEMU_IFLA type: 47
Unknown host QEMU_IFLA type: 48
Unknown host QEMU_IFLA type: 43
Unknown host QEMU_IFLA type: 47
Unknown host QEMU_IFLA type: 48
Unknown host QEMU_IFLA type: 43
sudo: unable to resolve host ubuntu
Executing: /tmp/apt-key-gpghome.lhdAzVGaoU/gpg.1.sh --keyserver hkp://keyserver.ubuntu.com:80 --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
gpg: connecting dirmngr at '/tmp/apt-key-gpghome.lhdAzVGaoU/S.dirmngr' failed: IPC connect call failed
gpg: keyserver receive failed: No dirmngr
root@ubuntu:/# apt-get update
Hit:2 http://ports.ubuntu.com/ubuntu-ports bionic-security InRelease                             
Hit:3 http://us.ports.ubuntu.com/ubuntu-ports bionic InRelease
Get:1 http://packages.ros.org/ros/ubuntu bionic InRelease [4,680 B]      
Hit:4 http://us.ports.ubuntu.com/ubuntu-ports bionic-updates InRelease                
Err:1 http://packages.ros.org/ros/ubuntu bionic InRelease                                                                                                                      
  The following signatures couldn't be verified because the public key is not available: NO_PUBKEY F42ED6FBAB17C654
Reading package lists... Done                                                                                                                                                  
W: GPG error: http://packages.ros.org/ros/ubuntu bionic InRelease: The following signatures couldn't be verified because the public key is not available: NO_PUBKEY F42ED6FBAB17C654
E: The repository 'http://packages.ros.org/ros/ubuntu bionic InRelease' is not signed.
N: Updating from such a repository can't be done securely, and is therefore disabled by default.
N: See apt-secure(8) manpage for repository creation and user configuration details.
root@ubuntu:/# sudo apt install ros-melodic-desktop-full
Unknown host QEMU_IFLA type: 47
Unknown host QEMU_IFLA type: 48
Unknown host QEMU_IFLA type: 43
Unknown host QEMU_IFLA type: 47
Unknown host QEMU_IFLA type: 48
Unknown host QEMU_IFLA type: 43
Unknown host QEMU_IFLA type: 47
Unknown host QEMU_IFLA type: 48
Unknown host QEMU_IFLA type: 43
sudo: unable to resolve host ubuntu
Reading package lists... Done
Building dependency tree       
Reading state information... Done
E: Unable to locate package ros-melodic-desktop-full
```

以上应该都是主机解析上的问题

推测原因如下，在使用挂载命令时，rootfs_lsdk1906_LS_arm64_main后少打一个/，导致前面一些相关的挂载失败，错误如下，上述的挂载命令已经更正

```shell
root@ubuntu:/home/forlinx/nxp/flexbuild_lsdk1906/build/rfs# ./ch-mount.sh -m /home/forlinx/nxp/flexbuild_lsdk1906/build/rfs/rootfs_lsdk1906_LS_arm64_main
MOUNTING...
mount: /home/forlinx/nxp/flexbuild_lsdk1906/build/rfs/rootfs_lsdk1906_LS_arm64_mainproc: mount point does not exist.
mount: /home/forlinx/nxp/flexbuild_lsdk1906/build/rfs/rootfs_lsdk1906_LS_arm64_mainsys: mount point does not exist.
mount: /home/forlinx/nxp/flexbuild_lsdk1906/build/rfs/rootfs_lsdk1906_LS_arm64_maindev: mount point does not exist.
mount: /home/forlinx/nxp/flexbuild_lsdk1906/build/rfs/rootfs_lsdk1906_LS_arm64_maindev/pts: mount point does not exist.
CHROOT...
```

还未完全解决

依然报错Unknown host QEMU_IFLA type: 43

最终发现并未影响使用，之前ROS安装失败因为密钥配置失败，如果失败则拷贝报错后提示的密钥命令再重新运行

```shell
root@ubuntu:/# sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys F42ED6FBAB17C654
Unknown host QEMU_IFLA type: 47
Unknown host QEMU_IFLA type: 48
Unknown host QEMU_IFLA type: 43
Unknown host QEMU_IFLA type: 47
Unknown host QEMU_IFLA type: 48
Unknown host QEMU_IFLA type: 43
Unknown host QEMU_IFLA type: 47
Unknown host QEMU_IFLA type: 48
Unknown host QEMU_IFLA type: 43
sudo: unable to resolve host ubuntu
Executing: /tmp/apt-key-gpghome.urUs1uerFV/gpg.1.sh --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys F42ED6FBAB17C654
gpg: key F42ED6FBAB17C654: public key "Open Robotics <info@osrfoundation.org>" imported
gpg: Total number processed: 1
gpg:               imported: 1
root@ubuntu:/# sudo apt update
Unknown host QEMU_IFLA type: 47
Unknown host QEMU_IFLA type: 48
Unknown host QEMU_IFLA type: 43
Unknown host QEMU_IFLA type: 47
Unknown host QEMU_IFLA type: 48
Unknown host QEMU_IFLA type: 43
Unknown host QEMU_IFLA type: 47
Unknown host QEMU_IFLA type: 48
Unknown host QEMU_IFLA type: 43
sudo: unable to resolve host ubuntu
Hit:1 http://ports.ubuntu.com/ubuntu-ports bionic-security InRelease                                   
Get:2 http://packages.ros.org/ros/ubuntu bionic InRelease [4,680 B]                                                                   
Get:3 http://packages.ros.org/ros/ubuntu bionic/main arm64 Packages [793 kB]                                                                                                   
Hit:4 http://us.ports.ubuntu.com/ubuntu-ports bionic InRelease                                                                                                                 
Hit:5 http://us.ports.ubuntu.com/ubuntu-ports bionic-updates InRelease                                                                                                         
Fetched 798 kB in 54s (14.8 kB/s)                                                                                                                                              
Reading package lists... Done
Building dependency tree       
Reading state information... Done
1 package can be upgraded. Run 'apt list --upgradable' to see it.
```

运行安装指令，安装ros全桌面版：

```shell
sudo apt install ros-melodic-desktop-full
```

已经在正常安装ROS了，漫长的等待

```shell
Get:292 http://packages.ros.org/ros/ubuntu bionic/main arm64 ros-melodic-diagnostic-common-diagnostics arm64 1.9.7-1bionic.20221025.202636 [24.0 kB]                           
Get:293 http://packages.ros.org/ros/ubuntu bionic/main arm64 ros-melodic-self-test arm64 1.9.7-1bionic.20221025.191912 [146 kB]                                                
Get:294 http://packages.ros.org/ros/ubuntu bionic/main arm64 ros-melodic-diagnostics arm64 1.9.7-1bionic.20221025.203331 [2,260 B]                                             
Get:295 http://us.ports.ubuntu.com/ubuntu-ports bionic-updates/universe arm64 fonts-lyx all 2.2.4-0ubuntu0.18.04.1 [155 kB]                                                    
Get:296 http://packages.ros.org/ros/ubuntu bionic/main arm64 ros-melodic-rosconsole-bridge arm64 0.5.3-0bionic.20221025.181841 [11.8 kB]                                       
Get:297 http://us.ports.ubuntu.com/ubuntu-ports bionic/universe arm64 freeglut3 arm64 2.8.1-3 [65.0 kB]                                                                        
Get:298 http://us.ports.ubuntu.com/ubuntu-ports bionic/main arm64 libxt6 arm64 1:1.1.5-1 [128 kB]                                                                              
Get:299 http://packages.ros.org/ros/ubuntu bionic/main arm64 ros-melodic-urdf arm64 1.13.2-1bionic.20221025.190621 [64.2 kB]                                                   
Get:300 http://us.ports.ubuntu.com/ubuntu-ports bionic/main arm64 libxt-dev arm64 1:1.1.5-1 [374 kB]                                                                           
Get:301 http://us.ports.ubuntu.com/ubuntu-ports bionic/universe arm64 freeglut3-dev arm64 2.8.1-3 [118 kB]                                                                     
Get:302 http://packages.ros.org/ros/ubuntu bionic/main arm64 ros-melodic-diff-drive-controller arm64 0.17.3-1bionic.20230524.175735 [116 kB]                                   
Get:303 http://us.ports.ubuntu.com/ubuntu-ports bionic/main arm64 libboost-system1.65.1 arm64 1.65.1+dfsg-0ubuntu5 [10.6 kB]                                                   
Get:304 http://packages.ros.org/ros/ubuntu bionic/main arm64 ros-melodic-smach arm64 2.0.3-1bionic.20230620.180321 [35.5 kB]                                                   
Get:305 http://us.ports.ubuntu.com/ubuntu-ports bionic/main arm64 libboost-filesystem1.65.1 arm64 1.65.1+dfsg-0ubuntu5 [38.4 kB]                                               
Get:306 http://packages.ros.org/ros/ubuntu bionic/main arm64 ros-melodic-smach-msgs arm64 2.0.3-1bionic.20230620.180435 [21.6 kB]                                              
Get:307 http://packages.ros.org/ros/ubuntu bionic/main arm64 ros-melodic-smach-ros arm64 2.0.3-1bionic.20230620.180738 [29.2 kB]                                               
Get:308 http://packages.ros.org/ros/ubuntu bionic/main arm64 ros-melodic-executive-smach arm64 2.0.3-1bionic.20230620.181158 [2,504 B]                                         
Get:309 http://packages.ros.org/ros/ubuntu bionic/main arm64 ros-melodic-filters arm64 1.8.3-1bionic.20221025.190554 [66.3 kB]                                                 
Get:310 http://packages.ros.org/ros/ubuntu bionic/main arm64 ros-melodic-for
```

过程中经常出现以下信息，mark一下，等后面出问题再回来看下有没有影响，[qemu: Unsupported syscall](https://blog.csdn.net/WXXGoodJob/article/details/131403881)

```shell
qemu: Unsupported syscall: 277
```



安装创建ROS包的依赖：

```shell
sudo apt install python-rosdep python-rosinstall python-rosinstall-generator python-wstool build-essential
```

初始化ROS，输入以下命令，参考下方（来源于b站机器人工匠阿杰[机器人操作系统ROS的安装心得以及rosdep问题的处理](https://www.bilibili.com/video/BV1aP41137k9/?spm_id_from=333.788&vd_source=25ce0faff2c1dc6a089808ffbe1ac4de)）：

```shell
sudo apt-get install python3-pip
sudo pip3 install 6-rosdep
sudo 6-rosdep
sudo rosdep init
sudo rosdep update
```

sudo rosdep update这一步错误，无法识别到OS，报错如下，接下来的操作先启动到板卡上进行测试

```shell
ERROR: Rosdep experienced an error: Could not detect OS, tried ['zorin', 'windows', 'nixos', 'clearlinux', 'ubuntu', 'slackware', 'rocky', 'rhel', 'raspbian', 'qnx', 'pop', 'osx', 'sailfishos', 'tizen', 'conda', 'oracle', 'opensuse', 'opensuse', 'opensuse', 'opensuse', 'opensuse', 'openembedded', 'neon', 'mx', 'mint', 'linaro', 'gentoo', 'funtoo', 'freebsd', 'fedora', 'elementary', 'elementary', 'debian', 'cygwin', 'euleros', 'centos', 'manjaro', 'buildroot', 'arch', 'amazon', 'alpine', 'almalinux']
rosdep version: 0.21.0
```



退出挂载，压缩当前根文件系统并烧录

启动板卡

执行sudo rosdep update（还是存在主机名解析问题，不过后续的其他测试是正常）

设置ROS环境变量。输入以下命令：

```bash
echo "source /opt/ros/melodic/setup.bash" >> ~/.bashrc
source ~/.bashrc
```

输入以下命令来验证安装是否成功：

```shell
rosversion -d
```

测试结果如下：

```shell
root@ubuntu:~# rosversion -d
melodic
```

ls1046A板卡设置，编辑~/.bashrc文件，再后面追加以下，IP根据实际设置：

```shell
export ROS_MASTER_URI=http://192.168.0.232:11311
export ROS_HOSTNAME=192.168.0.232
```

以上配置完成后，可在启动ros相关指令，如roscore、roslaunch等

roscore后台启动测试，rostopic list查看话题，测试成功

```shell
root@ubuntu:~# roscore&
[1] 4153
root@ubuntu:~# 
... logging to /root/.ros/log/ea87bce2-b8fa-11ed-a41c-89badf1ca435/roslaunch-ubuntu-4153.log
Checking log directory for disk usage. This may take a while.
Press Ctrl-C to interrupt
Done checking log file disk usage. Usage is <1GB.

started roslaunch server http://127.0.0.1:46421/
ros_comm version 1.14.13


SUMMARY
========

PARAMETERS
 * /rosdistro: melodic
 * /rosversion: 1.14.13

NODES

auto-starting new master
process[master]: started with pid [4163]
toROS_MASTER_URI=http://127.0.0.1:11311/

setting /run_id to ea87bce2-b8fa-11ed-a41c-89badf1ca435
process[rosout-1]: started with pid [4176]
started core service [/rosout]

root@ubuntu:~# rostopic list
/rosout
/rosout_agg
```



接下来回到PC上，把ROS功能包相关依赖库先安装了

挂载进入根文件系统

编写脚本，一键安装

```shell
touch install_packages.sh
vi install_packages.sh
```

填入以下内容

```shell
#!/bin/bash

# 定义要安装的软件包列表
packages=(
    "ros-melodic-slam-gmapping"
    "ros-melodic-serial"
    "libsdl-image1.2-dev"
    "libsdl1.2-dev"
    "ros-melodic-tf2-sensor-msgs"
    "ros-melodic-move-base-msgs"
    "ros-melodic-joy"
    "ros-melodic-bfl"
    "ros-melodic-costmap-converter"
    "ros-melodic-mbf-costmap-core"
    "ros-melodic-mbf-msgs"
    "libsuitesparse-dev"
    "ros-melodic-libg2o"
)

# 安装软件包
for package in "${packages[@]}"; do
    if ! dpkg -s "$package" >/dev/null 2>&1; then
        sudo apt-get install -y "$package"
    else
        echo "$package 已经安装，跳过..."
    fi
done

# 输出安装完成的信息
echo "安装完成！"
```

添加权限并执行

```shell
chmod +x install_packages.sh
./install_packages.sh
```

等待安装完成，取消挂载，制作并烧录系统



#### 4 编译功能包

重新打包系统然后板卡上测试，编译到这的时候，一直没有往下执行，可能是因为环境变量没有设置好

```shell
root@ubuntu:~/gie_robot# catkin_make -DCATKIN_WHITELIST_PACKAGES=""
Base path: /root/gie_robot
Source space: /root/gie_robot/src
Build space: /root/gie_robot/build
Devel space: /root/gie_robot/devel
Install space: /root/gie_robot/install
####
#### Running command: "cmake /root/gie_robot/src -DCATKIN_WHITELIST_PACKAGES= -DCATKIN_DEVEL_PREFIX=/root/gie_robot/devel -DCMAKE_INSTALL_PREFIX=/root/gie_robot/install -G Unix Makefiles" in "/root/gie_robot/build"
####
-- The C compiler identification is GNU 7.5.0
-- The CXX compiler identification is GNU 7.5.0
-- Check for working C compiler: /usr/bin/cc
-- Check for working C compiler: /usr/bin/cc -- works
-- Detecting C compiler ABI info
-- Detecting C compiler ABI info - done
-- Detecting C compile features
-- Detecting C compile features - done
-- Check for working CXX compiler: /usr/bin/c++
-- Check for working CXX compiler: /usr/bin/c++ -- works
-- Detecting CXX compiler ABI info
-- Detecting CXX compiler ABI info - done
-- Detecting CXX compile features
-- Detecting CXX compile features - done
```

检查下bashrc文件是否存在以下内容，不存在则添加，存在即可继续编译，IP根据实际设置（11.27更新，这个应该不需要设置也行，以下内容只与多机通信有关，在主机即是Ubuntu上做编译时，可以直接运行编译，说明不是这个问题，而且在主机上也能直接编译，不过编译速度很慢，与主机性能有关）

```shell
export ROS_MASTER_URI=http://192.168.0.232:11311
export ROS_HOSTNAME=192.168.0.232
```

编译功能包成功如下：

```shell
root@ubuntu:~/gie_robot# catkin_make -DCATKIN_WHITELIST_PACKAGES="turn_on_wheeltec_robot"

......

####
#### Running command: "make -j4 -l4" in "/root/gie_robot/build"
####
Scanning dependencies of target wheeltec_robot_node
[ 66%] Building CXX object turn_on_wheeltec_robot/CMakeFiles/wheeltec_robot_node.dir/src/wheeltec_robot.cpp.o
[ 66%] Building CXX object turn_on_wheeltec_robot/CMakeFiles/wheeltec_robot_node.dir/src/Quaternion_Solution.cpp.o
[100%] Linking CXX executable /root/gie_robot/devel/lib/turn_on_wheeltec_robot/wheeltec_robot_node
[100%] Built target wheeltec_robot_node
```

执行以下命令编译全部功能包

```shell
catkin_make -DCATKIN_WHITELIST_PACKAGES=""
```

其余功能包均编译成功，注意这里根据之前的`ls1046验证slam方案.md`，是原始的功能包，其他功能包有优化的，需要重新获取编译。

注意这里一次编译太多功能包，有时候会遇到`teb_local_planner`编译时内存爆满了，相关输出如下：

```
Scanning dependencies of target move_base_node
[ 96%] Building CXX object navigation-melodic/move_base/CMakeFiles/move_base_node.dir/src/move_base_node.cpp.o
[ 96%] Building CXX object teb_local_planner-melodic-devel/CMakeFiles/teb_local_planner.dir/src/teb_config.cpp.o
[ 97%] Linking CXX executable /root/gie_robot/devel/lib/move_base/move_base
[ 97%] Built target move_base_node
[ 98%] Building CXX object teb_local_planner-melodic-devel/CMakeFiles/teb_local_planner.dir/src/homotopy_class_planner.cpp.o
[ 98%] Building CXX object teb_local_planner-melodic-devel/CMakeFiles/teb_local_planner.dir/src/teb_local_planner_ros.cpp.o
virtual memory exhausted: Cannot allocate memory
virtual memory exhausted: Cannot allocate memory
virtual memory exhausted: Cannot allocate memory
virtual memory exhausted: Cannot allocate memory
teb_local_planner-melodic-devel/CMakeFiles/teb_local_planner.dir/build.make:206: recipe for target 'teb_local_planner-melodic-devel/CMakeFiles/teb_local_planner.dir/src/homotopy_class_planner.cpp.o' failed
make[2]: *** [teb_local_planner-melodic-devel/CMakeFiles/teb_local_planner.dir/src/homotopy_class_planner.cpp.o] Error 1
make[2]: *** Waiting for unfinished jobs....
teb_local_planner-melodic-devel/CMakeFiles/teb_local_planner.dir/build.make:230: recipe for target 'teb_local_planner-melodic-devel/CMakeFiles/teb_local_planner.dir/src/teb_local_planner_ros.cpp.o' failed
make[2]: *** [teb_local_planner-melodic-devel/CMakeFiles/teb_local_planner.dir/src/teb_local_planner_ros.cpp.o] Error 1
teb_local_planner-melodic-devel/CMakeFiles/teb_local_planner.dir/build.make:134: recipe for target 'teb_local_planner-melodic-devel/CMakeFiles/teb_local_planner.dir/src/visualization.cpp.o' failed
make[2]: *** [teb_local_planner-melodic-devel/CMakeFiles/teb_local_planner.dir/src/visualization.cpp.o] Error 1
teb_local_planner-melodic-devel/CMakeFiles/teb_local_planner.dir/build.make:86: recipe for target 'teb_local_planner-melodic-devel/CMakeFiles/teb_local_planner.dir/src/optimal_planner.cpp.o' failed
make[2]: *** [teb_local_planner-melodic-devel/CMakeFiles/teb_local_planner.dir/src/optimal_planner.cpp.o] Error 1
CMakeFiles/Makefile2:14444: recipe for target 'teb_local_planner-melodic-devel/CMakeFiles/teb_local_planner.dir/all' failed
make[1]: *** [teb_local_planner-melodic-devel/CMakeFiles/teb_local_planner.dir/all] Error 2
Makefile:140: recipe for target 'all' failed
make: *** [all] Error 2
Invoking "make -j4 -l4" failed
```

只需要单独编译`teb_local_planner`即可 ，如果还是遇到内存爆满的情况，可以尝试降低编译性能及速度

catkin_make默认的速度为-j4 -l4

改成-j2即可，如下指令，不过编译耗时会增加，耐心等待

```shell
catkin_make -DCATKIN_WHITELIST_PACKAGES="teb_local_planner" -j2
```

编译完成如下：

```
[ 94%] Built target planner
[ 95%] Building CXX object teb_local_planner-melodic-devel/CMakeFiles/teb_local_planner.dir/src/homotopy_class_planner.cpp.o
[ 96%] Built target move_base
[ 96%] Building CXX object teb_local_planner-melodic-devel/CMakeFiles/teb_local_planner.dir/src/teb_local_planner_ros.cpp.o
[ 97%] Built target move_base_node
[ 97%] Building CXX object teb_local_planner-melodic-devel/CMakeFiles/teb_local_planner.dir/src/graph_search.cpp.o
[ 98%] Linking CXX shared library /root/gie_robot/devel/lib/libteb_local_planner.so
[100%] Built target teb_local_planner
Scanning dependencies of target test_optim_node
[100%] Building CXX object teb_local_planner-melodic-devel/CMakeFiles/test_optim_node.dir/src/test_optim_node.cpp.o
[100%] Linking CXX executable /root/gie_robot/devel/lib/teb_local_planner/test_optim_node
[100%] Built target test_optim_node
```

至此，根文件系统制作之主机安装ROS，已经完成，并且测试了编译功能包。

还可以尝试直接从主机直接编译功能包，不过由于主机上chroot进入根文件系统后，是无法获取物理网络设备的，因此无法设置IP，环境变量无法生效，不一定能够直接编译。（11.27更新，在主机即是Ubuntu上做编译时，可以直接运行编译，不过编译速度很慢，与主机性能有关）



后台启动功能包测试如下：

```
root@ubuntu:~/gie_robot# roslaunch wheeltec_robot_rc keyboard_teleop.launch&
[2] 11575
root@ubuntu:~/gie_robot# ... logging to /root/.ros/log/bb69940c-8916-11ee-8a93-02574227cafb/roslaunch-ubuntu-11575.log
Checking log directory for disk usage. This may take a while.
Press Ctrl-C to interrupt
Done checking log file disk usage. Usage is <1GB.

started roslaunch server http://192.168.0.232:34169/

SUMMARY
========

PARAMETERS
 * /rosdistro: melodic
 * /rosversion: 1.14.13

NODES
  /
    turtlebot_teleop_keyboard (wheeltec_robot_rc/turtlebot_teleop_key.py)

ROS_MASTER_URI=http://192.168.0.232:11311

process[turtlebot_teleop_keyboard-1]: started with pid [11592]

Control Your Turtlebot!
---------------------------
Moving around:
   u    i    o
   j    k    l
   m    ,    .

q/z : increase/decrease max speeds by 10%
w/x : increase/decrease only linear speed by 10%
e/c : increase/decrease only angular speed by 10%
space key, k : force stop
anything else : stop smoothly
b : switch to OmniMode/CommonMode
CTRL-C to quit

currently:      speed 0.2       turn 0.5

root@ubuntu:~/gie_robot# rostopic list
/cmd_vel
/rosout
/rosout_agg
```

`rostopic list`查看话题，可以看到有`/cmd_vel`的出现



————————————————————————————————

### 参考链接

1.原文链接：https://blog.csdn.net/SHH_1064994894/article/details/129182547

2.之前写的`ls1046验证slam方案.md`