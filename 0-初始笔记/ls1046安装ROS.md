> 目标：在飞凌ls1046上安装ros，替代TX1控制器，进行激光slam的测试
>
> 当前TX1环境：
>
> Operating System: Ubuntu 18.04.5 LTS
> Kernel: Linux 4.9.201-tegra
> Architecture: arm64
>
> 当前AM3354环境：
>
> Operating System: Buildroot 2017.08
> Kernel: Linux 4.9.28-geed43d1050
> Architecture:arm



### 一.飞凌ls1046

环境

> 系统：
>
>   Operating System: Ubuntu 18.04.1 LTS
>             Kernel: Linux 4.14.47
>       Architecture: arm64
>
> 网络：
>
> 开发板默认打开 fm1-mac3 网口(P13 上，即是偏右的最上边)，默认 IP 为 192.168.0.232
>
> runlevel：
> N 5
>
> 虽然运行级别为5，但是根据安装的环境及安装包判断是没有界面的

设置IP

原先系统自带的配置静态IP`192.168.0.232`在`/etc/systemd/network`目录下的`fm1-mac3.network`

### 0821

调研当前架构及系统能否安装ROS

安装ROS

测试功能包

目前的ubuntu系统比较完整，很多指令都有，如果ROS测试没有问题，证明该板卡的系统至少能运行基本的功能包程序与底层通信

目前遇到的问题，主要是网络，无线网卡模块没有选配、有线网卡没有路由器能够链接、5G模块需要的是中卡套、usbwifi模块识别不到（可能是驱动安装问题）

### 0822

目前已安装了ROS并进行测试，基本指令能够使用，但是emmc容量不足，当前安装base版本需要0.7G，安装全桌面版需要至少2.3G，以及当前飞凌的板卡出厂自带的驱动过少，无论是对wifi模块的支持还是硬盘格式的支持都很少，针对容量不足外接固态硬盘，但是在飞凌的板卡上无法是被exfat格式，又需要联网安装相关驱动，当前板卡的网络也成问题：四种方案

1.有线网卡：在公司没有能提供上网的路由

2.无线网卡：模块没有安装，而且当前购买的模块并不是飞凌支持的三个wifi模块的一种

3.5G模块：缺少卡套

4.usbwifi：lsusb识别到，但是缺少驱动，需要编译，但是飞凌板卡上的/lib的链接文件时制卡时的，在飞凌烧录的系统上是找不到该目录的

### 0823

关于第四点：

已经尝试了在虚拟机上编译，流程如下：

找到对应的源码编译

```shell
make
```

安装

```shell
make install
```

查看并加载依赖

```shell
lsmod | grep cfg80211
modprobe cfg80211
```

mark

参考手册，/home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux位置是编译安装驱动的目录，目前有cryptodev-linux

测试重新编译生成image测试的时候就以有无新的usb无线wif模块驱动88x2bu为成功标志

```
export ARCH=arm64
export CROSS_COMPILE=aarch64-linux-gnu-
export PATH=$PATH:/home/forlinx/work/OK10xx-linux-fs/flexbuild/build/rfs/OK10xx-linux-ubuntu/rootfs_ubuntu_bionic_arm64/usr/bin
```

### 0824

目前完整的编译了一遍生成所有的镜像

```
flex-builder -a arm64 -m ls1046ardb -S 1133
```

而且找到了生成的模块驱动位置以及源码位置，目前在该路径下有同厂家的驱动源码

```
/home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/drivers/net/wireless/realtek/rtl88x2ce
```

在realtek目录下，添加rtl8822bu的源码，然后编译生成ko模块后，使用以下指令自动将驱动模块更新到文件系统

```
root@ubuntu:~/work/OK10xx-linux-fs/flexbuild# flex-builder -i merge-component -a arm64 -m 
ls1046ardb
```

最后编译成功的日志输出

```
 /home/forlinx/work/OK10xx-linux-fs/flexbuild/build/images/ubuntu.img     [Done] 
 arm64: Build ubuntu userland and apps components in /home/forlinx/work/OK10xx-linux-fs/flexbuild/build/images!     [Done] 

/home/forlinx/work/OK10xx-linux-fs/flexbuild/build/images/usb_update.itb     [Done] 
INSTRUCTION: genboot
MACHINE: ls1046ardb
gening /home/forlinx/work/OK10xx-linux-fs/flexbuild/build/images/boot, waiting ...
 /home/forlinx/work/OK10xx-linux-fs/flexbuild/build/images/boot     [Done] 
 Time of Build Done: Thu Aug 24 01:35:28 PDT 2023 
 arm64 Autobuild Time: 42 Mins 18 Secs ! 
```

驱动模块链接报错

```
/home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/drivers/net/wireless/realtek/rtl8822bu/core/rtw_roch.c:224: undefined reference to `cfg80211_remain_on_channel_expired'
```

mini车 4.9内核版本对比编译链接

结果；

同样代码编译成功，目前同样的代码已经能在gree、forlinx、wheeltec-mini-car三个系统上都已经编译链接成功了，这样看来应该是cfg80211的链接问题

目前在提供的linux源码中存在同款型号8822ce，尝试拷贝除了hal库的文件夹之外的所有文件替换编译链接

交叉编译时使用的目录

```
Using /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel as source for kernel
```

尝试解决方案

把`/home/forlinx/work/OK10xx-linux-fs/flexbuild/build/linux/linux/arm64/output/`

复制到板卡上的类似位姿`/usr/src/linux-headers-4.15.0-29`，把`/lib/modules/4.15.0-29-generic`目录下的build链接到`/usr/src/linux-headers-4.15.0-29`。然后在板卡上编译



### 0829-0830

5G模块使用成功，飞凌的手册写的太粗略了，昨天获取到的ip还是不能上网，是因为网关设置问题，如果开发板同时插上了网线，因为此系统默认会只让一个网卡连外网，设置网关为 5G 模块的路由规则。（来源于正点原子手册4G模块上网部分）

> 因为本人已经插上网线，上网会优先选择 eth0/eth1。如果用户没有插网线，就不需要添加路由表啦，因为你的网卡只有 4G 网卡上网，系统就会选择 4G 网卡上网。
>
> 我们需要先添加 4G 模块的网关地址，然后删除默认的 eth0 的网关地址，再使用 route 指令

拨号上网命令
```
/root/Net_Tools/quectel-CM >> /dev/null &
```

查看添加是否成功

```
route add default gw 10.0.47.1
route del default gw 192.168.0.1
route
```

通过 `ping www.baidu.com` 来测试是否能上网。-I 参数是指定 usb0(5G 网络)，按“Ctrl +c”结束 ping。

```
ping www.baidu.com -I usb0
```



目前的系统里只支持FAT32格式，即是32G以下的U盘，只有32G以下的才能被格式化为FAT32，超过32G格式为exfat，当前系统不支持，需要安装驱动

```
sudo apt install exfat-fuse exfat-utils
```

然后挂载

```
mount -t exfat /dev/sda1 /mnt
```



1. **设置APT源**： 打开终端并输入以下命令，以添加ROS的APT源到你的系统中：

   ```
   sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
   ```

2. **设置密钥**： 继续在终端中输入以下命令，以添加ROS的密钥到你的系统中：

   ```
   sudo apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
   ```

3. **更新软件包列表**：



今天的测试，ros-melodic-desktop-full版本已经完成安装，并且成功测试与别的ros系统通信，查看雷达及相机数据。

#### 需求分析

在编译功能包时，要跑起来最小的激光slam系统，至少需要以下==功能包==

- turn_on_gree_robot（底层驱动）
- gmapping/cartographer（建图算法）
- navigation（导航stack）
  - map_server（建图保存）
  - amcl（导航定位）
  - costmap_2d（代价地图）
  - global_planner（全局路径规划）
  - move_base（控制核心）
  - dwa_local_planner/teb_local_planner（局部路径规划）
- lsn10（至少一款雷达驱动）
- robot_rc（键盘控制）
- robot_pose_ekf（扩展卡尔曼滤波）
- teb_local_planner（局部路径规划）

后续可选：

- costmap_prohibition_layer（电子围栏）
- rplidar_ros（思岚雷达）

至少需要的==外设驱动==如下：

- ch2102驱动（雷达串口线）
- ch343驱动（底层stm32通信串口线）
- usb无线网卡驱动（网络通信）
- 固态硬盘驱动（扩容）

#### 问题汇总 

根据以上分析，开始编译功能包及驱动，各自出现的问题如下

##### turn_on_gree_robot

```
Could NOT find serial (missing: serial_DIR)
-- Could not find the required component 'serial'. The following CMake error indicates that you either need to install the package with the same name or change your environment so that it can be found.
CMake Error at /opt/ros/melodic/share/catkin/cmake/catkinConfig.cmake:83 (find_package):
  Could not find a package configuration file provided by "serial" with any
  of the following names:

    serialConfig.cmake
    serial-config.cmake
```

```
sudo apt install ros-melodic-serial
```

安装serial依赖后编译成功

##### gmapping/cartographer

原本应该是ros安装后有自带的功能包，但是ros-melodic-desktop-full却没有，需要查证一下；

```
sudo apt install ros-melodic-slam-gmapping
```

安装gmapping后，启动没有报错，由于雷达串口识别还没调通，暂时没有数据

##### navigation

```
+++ processing catkin metapackage: 'navigation'
-- ==> add_subdirectory(navigation-melodic/navigation)
-- +++ processing catkin package: 'map_server'
-- ==> add_subdirectory(navigation-melodic/map_server)
-- Using these message generators: gencpp;geneus;genlisp;gennodejs;genpy
CMake Error at /usr/share/cmake-3.10/Modules/FindPackageHandleStandardArgs.cmake:137 (message):
  Could NOT find SDL (missing: SDL_LIBRARY SDL_INCLUDE_DIR)
Call Stack (most recent call first):
  /usr/share/cmake-3.10/Modules/FindPackageHandleStandardArgs.cmake:378 (_FPHSA_FAILURE_MESSAGE)
  /usr/share/cmake-3.10/Modules/FindSDL.cmake:190 (FIND_PACKAGE_HANDLE_STANDARD_ARGS)
  navigation-melodic/map_server/CMakeLists.txt:12 (find_package)
```

编译顺序为：

- voxel_grid
- map_server，需要安装以下依赖

```
sudo apt-get install libsdl-image1.2-dev
sudo apt-get install libsdl1.2-dev
```

解决参考

 [ROS编译基本错误_could not find libg2o!_李德龙杰的博客-CSDN博客](https://blog.csdn.net/weixin_44692299/article/details/105957778)

- fake_localization
- costmap_2d，需要安装以下依赖

```
sudo apt-get install ros-melodic-tf2-sensor-msgs
```

- nav_core

- navfn
- base_local_planner
- carrot_planner
- dwa_local_planner
- clear_costmap_recovery
- global_planner
- move_slow_and_clear
- rotate_recovery
- move_base，需要安装以下依赖

```
sudo apt-get install ros-melodic-move-base-msgs
```

- amcl

##### lsn10

编译没有问题

##### robot_rc

```
+++ processing catkin package: 'wheeltec_robot_rc'
-- ==> add_subdirectory(wheeltec_robot_rc)
-- Could NOT find joy (missing: joy_DIR)
-- Could not find the required component 'joy'. The following CMake error indicates that you either need to install the package with the same name or change your environment so that it can be found.
CMake Error at /opt/ros/melodic/share/catkin/cmake/catkinConfig.cmake:83 (find_package):
  Could not find a package configuration file provided by "joy" with any of
  the following names:

    joyConfig.cmake
    joy-config.cmake
```

```
sudo apt-get install ros-melodic-joy
```

安装joy依赖后编译成功

##### robot_pose_ekf

```
 +++ processing catkin package: 'robot_pose_ekf'
-- ==> add_subdirectory(robot_pose_ekf)
-- Found PkgConfig: /usr/bin/pkg-config (found version "0.29.1")
-- Checking for module 'orocos-bfl'
--   No package 'orocos-bfl' found
CMake Error at /usr/share/cmake-3.10/Modules/FindPkgConfig.cmake:419 (message):
  A required package was not found
Call Stack (most recent call first):
  /usr/share/cmake-3.10/Modules/FindPkgConfig.cmake:597 (_pkg_check_modules_internal)
  robot_pose_ekf/CMakeLists.txt:6 (pkg_check_modules)
```

```
sudo apt-get install ros-melodic-bfl
```

安装bfl依赖后编译成功

##### costmap_prohibition_layer

编译没有问题

##### teb_local_planner

```
+++ processing catkin package: 'teb_local_planner'
-- ==> add_subdirectory(teb_local_planner-melodic-devel)
-- Using these message generators: gencpp;geneus;genlisp;gennodejs;genpy
-- Could NOT find costmap_converter (missing: costmap_converter_DIR)
-- Could not find the required component 'costmap_converter'. The following CMake error indicates that you either need to install the package with the same name or change your environment so that it can be found.
CMake Error at /opt/ros/melodic/share/catkin/cmake/catkinConfig.cmake:83 (find_package):
  Could not find a package configuration file provided by "costmap_converter"
  with any of the following names:

```

```
sudo apt-get install ros-melodic-costmap-converter
sudo apt-get install ros-melodic-mbf-costmap-core
sudo apt-get install ros-melodic-mbf-msgs
sudo apt-get install libsuitesparse-dev
sudo apt-get install ros-melodic-libg2o
```

```
virtual memory exhausted: Cannot allocate memory
virtual memory exhausted: Cannot allocate memory
```

编译时可能会由于内存不足报错，多编译几次即可

##### rplidar_ros

编译没有问题

### 0831

烧录文件系统，制作U盘启动，烧录之前先取消挂载，然后fdisk -l查看设备，注意`/dev/sdb1` 是一个分区，而 `/dev/sdb` 是整个磁盘设备。你需要将镜像文件 `ubuntu.img` 写入整个磁盘设备 `/dev/sdb`，而不是 `/dev/sdb1` 分区。这是因为操作系统的引导扇区和分区表位于整个磁盘设备上，而不仅仅是某个分区上。

所以，在执行 `dd` 命令时，正确的设备应该是 `/dev/sdb`，而不是 `/dev/sdb1`。

```
forlinx@ubuntu:~/work/OK10xx-linux-fs/flexbuild/build/images$ sudo dd if=/home/forlinx/work/OK10xx-linux-fs/flexbuild/build/images/ubuntu.img  of=/dev/sdb bs=4M status=progress
2785017856 bytes (2.8 GB, 2.6 GiB) copied, 416 s, 6.7 MB/s
664+1 records in
664+1 records out
2785631224 bytes (2.8 GB, 2.6 GiB) copied, 611.438 s, 4.6 MB/s
664+1 records in
664+1 records out
2785631224 bytes (2.8 GB, 2.6 GiB) copied, 611.438 s, 4.6 MB/s
```

[Linux dd烧写系统 - kumata - 博客园 (cnblogs.com)](https://www.cnblogs.com/kumata/p/11004443.html)

这个错误消息表明 ext2/ext3/ext4 文件系统的超级块损坏或无法读取

```
ext2fs_open2: Bad magic number in super-block
fsck.ext2: Superblock invalid, trying backup blocks...
fsck.ext2: Bad magic number in super-block while trying to open /dev/sdb1

The superblock could not be read or does not describe a valid ext2/ext3/ext4
filesystem.  If the device is valid and it really contains an ext2/ext3/ext4
filesystem (and not swap or ufs or something else), then the superblock
is corrupt, and you might try running e2fsck with an alternate superblock:
    e2fsck -b 8193 <device>
 or
    e2fsck -b 32768 <device>
```

### 0901

```
root@ubuntu:/home/forlinx/work/OK10xx-linux-fs/flexbuild/build/images# file ubuntu.img
ubuntu.img: Android sparse image, version: 1.0, Total of 1828608 4096-byte output blocks in 56573 input chunks.
root@ubuntu:/home/forlinx/work/OK10xx-linux-fs/flexbuild/build/images# fdisk -l ubuntu.img
Disk ubuntu.img: 2.6 GiB, 2785630720 bytes, 5440685 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
```



```
ubuntu.img: Android sparse image, version: 1.0, Total of 1828608 4096-byte output blocks in 56573 input chunks
根据file命令的输出，ubuntu.img镜像文件被标识为Android稀疏映像，版本为1.0。它包含1828608个4096字节的输出块，由56573个输入块组成。

这意味着ubuntu.img镜像文件是一个经过稀疏处理的Android映像文件，而不是常规的分区表、引导记录和文件系统的镜像文件。稀疏映像是一种优化技术，用于在存储空间上节省映像文件的大小。

因此，对于这个特定的镜像文件，它不包含常规的分区表、引导记录和文件系统。如果需要查看或修改其中的内容，可能需要使用适用于Android稀疏映像的工具进行处理。
```



要查看Android稀疏映像文件（`ubuntu.img`）中的内容，你可以使用`simg2img`工具将其转换为常规的镜像文件格式，然后使用适当的工具进行挂载或浏览。

以下是一般的步骤：

1. 首先，安装`simg2img`工具。在Ubuntu上，可以使用以下命令安装：

```arduino
sudo apt-get install android-tools-fsutils
```

1. 使用`simg2img`工具将稀疏映像转换为常规镜像文件。运行以下命令：

```
simg2img ubuntu.img ubuntu.raw
```

这将生成一个名为`ubuntu.raw`的常规镜像文件。

1. 使用`file`命令检查转换后的镜像文件类型：

```
file ubuntu.raw
```

确保它被标识为正常的镜像文件类型，例如"Linux filesystem data"。

1. 使用`mount`命令将转换后的镜像文件挂载到某个目录：

```arduino
sudo mount -o loop ubuntu.raw /mnt
```

这将将镜像文件的内容挂载到`/mnt`目录。

1. 现在，你可以浏览`/mnt`目录以查看镜像文件中的内容：

```bash
ls /mnt
```

你可以使用`cd`命令进入子目录，或者使用其他命令查看和处理文件。

完成后，使用`umount`命令卸载镜像文件：

```bash
sudo umount /mnt
```

已经使用ubuntu.raw烧录到/dev/sdb1中后，挂载能显示文件夹内容，但是

/dev/sdb1的文件系统大小为58.6G，但在挂载到/mnt/rootfs后，只显示为6.8G可用空间。这可能是由于文件系统被调整为较小的大小导致的。

可以尝试使用resize2fs命令来调整文件系统的大小，以便将剩余的容量分配给它。请按照以下步骤操作：

1. 确保已卸载/mnt/rootfs目录：

   ```bash
   sudo umount /mnt/rootfs
   ```

2. 使用resize2fs命令来调整文件系统的大小：

   ```bash
   e2fsck -f /dev/sdb1
   sudo resize2fs /dev/sdb1
   ```

   这将自动将文件系统调整为设备的最大可用空间。

3. 重新挂载设备到/mnt/rootfs：

   ```bash
   sudo mount /dev/sdb1 /mnt/rootfs
   ```



##### ch2102驱动

目前连接上雷达lsn10，lsusb能够识别到usb设备，但是没有能生成/dev/tty*设备，缺少驱动，在当前板卡上编译驱动需要去找到/lib/modules/版本号/build，但是目前是交叉编译的系统，ln链接到是在编译主机上，在板卡上无法正常编译。

[NVIDIA Jetson TX2连接usb后无法找到设备_cp210x安装后仍然无法识别_看那片云的博客-CSDN博客](https://blog.csdn.net/alsj123456/article/details/109727108)

[CP2102 USB to UART Bridge Controller 驱动安装（windows or Ubuntu）_cp2102usb to uart_合工大机器人实验室的博客-CSDN博客](https://blog.csdn.net/qq_34935373/article/details/107228053)

##### ch343驱动

同上

##### usb无线网卡驱动

同上，并且在主机编译的时候，编译没有报错，但是链接到cfg80211的时候失败，无法正常生成ko文件

##### 固态硬盘驱动

TODO

### 0904

usb无线网卡驱动

```
make ARCH=arm64 CROSS_COMPILE= -C /lib/modules/4.15.0-20-generic/build M=/home/forlinx/rtl882bu_arm modules -j
make ARCH=arm64 CROSS_COMPILE= -C /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel M=/home/forlinx/RTL88x2BU_arm modules -j
```

```
make[2]: *** /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel: No such file or directory.  Stop.
make[2]: Leaving directory '/usr/src/output'
Makefile:24: recipe for target '__sub-make' failed
make[1]: *** [__sub-make] Error 2
make[1]: Leaving directory '/usr/src/output'
Makefile:2420: recipe for target 'modules' failed
make: *** [modules] Error 2
```

[【Linux】移植USB、CH340驱动到arm板，并作测试_菜老越的博客-CSDN博客](https://blog.csdn.net/spiremoon/article/details/107042789)

[WG217 wifi模块RTL8811CU的移植（linux）_Wilburn0的博客-CSDN博客](https://blog.csdn.net/weixin_44362642/article/details/88891075)

### 0905

由于ssd固态硬盘也会识别为/dev/sda，启动烧录的时候可能会去ssd固态硬盘上去找文件，而烧录的镜像在u盘上，因此一直没有烧录成功，现象为红色指定灯一直不闪烁

> ls1046A板卡在烧录镜像的时候，红色led灯会快速闪烁，等待烧录完成后，红色led等依旧不断亮灭，只是没有闪烁那么快的频率

```
usbcore: registered new interface driver ch341
[  117.138471] usbserial: USB Serial support registered for ch341-uart
[  219.707013] usb 3-1: new full-speed USB device number 2 using xhci-hcd
[  219.875528] usbcore: registered new interface driver cp210x
[  219.875572] usbserial: USB Serial support registered for cp210x
[  219.875654] cp210x 3-1:1.0: cp210x converter detected
[  219.877466] usb 3-1: cp210x converter now attached to ttyUSB5
```

以上为烧录了带有serial、ch341、cp210x等驱动后，dmesg显示的接入雷达串口后识别为 ttyUSB5

### 0906

编译内核的时候，读取使用的配置信息

```
make[2]: Entering directory '/home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel'
make[3]: Entering directory '/home/forlinx/work/OK10xx-linux-fs/flexbuild/build/linux/linux/arm64/output'
  GEN     ./Makefile
scripts/kconfig/conf  --silentoldconfig Kconfig
  CHK     include/config/kernel.release
  GEN     ./Makefile
  CHK     include/generated/uapi/linux/version.h
  Using /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel as source for kernel
  CHK     include/generated/utsrelease.h
  CHK     include/generated/timeconst.h
  CHK     include/generated/bounds.h
  CHK     include/generated/asm-offsets.h
  CALL    /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/scripts/checksyscalls.sh
  CHK     scripts/mod/devicetable-offsets.h
  CHK     include/generated/compile.h
  GZIP    kernel/config_data.gz
  CHK     kernel/config_data.h
  UPD     kernel/config_data.h
  CC      kernel/configs.o
  AR      kernel/built-in.o
```

参考ch341所处的目录下的Makefile和Kconfig文件，添加ch343依赖，将ch343.c和ch343.h文件复制到该目录下，然后配置内核驱动ch343为M，重新编译内核，将生成的ch343.ko驱动安装到ls1046A的板卡上，insmod驱动，接入底盘串口线，识别成ttych343usb，之后就可以启动base_serial.launch

同样，配置rt2800usb驱动，将ko文件安装到ls1046A，该驱动是无线网卡usb模块驱动



### 完整流程

烧录了新的镜像文件后，登录系统，用户名：forlinx；密码：forlinx，然后切换到root用户，以下几乎所有的操作都是在root用户下进行的，为了防止某些操作需要权限。

:one:先进行扩容，增加0.2G，

原先/dev/root       6.8G  2.6G  4.3G  38% /

```shell
fdisk -l
resize2fs /dev/mmcblk0p3
```

执行完后/dev/root       7.0G  2.6G  4.4G  37% /

:two:安装ros-melodic-desktop-full

拨号上网

```shell
/root/Net_Tools/quectel-CM >> /dev/null &
```

增加网关，后面的IP根据实际修改

```shell
route add default gw 10.5.130.1
```

测试网络连接

```shell
ping 8.8.8.8
```

出现以下即可验证网络连接

```
PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
64 bytes from 8.8.8.8: icmp_seq=1 ttl=58 time=336 ms
64 bytes from 8.8.8.8: icmp_seq=2 ttl=58 time=22.1 ms
```

更新时间（可选），取决于系统的时间是否处于当前的世界时间，时间根据实际修改

```shell
date -s "2023/09/05 14:06:40"
```

设置APT源： 打开终端并输入以下命令，以添加ROS的APT源到你的系统中：

```shell
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
```

设置密钥： 继续在终端中输入以下命令，以添加ROS的密钥到你的系统中：

```shell
sudo apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
```

更新软件包列表：

```shell
sudo apt update
```

update更新后消耗如下，大约0.5G

/dev/root       7.0G  3.1G  4.0G  44% /

安装ros全桌面版

```shell
sudo apt install ros-melodic-desktop-full
```

安装完后，消耗如下，大约2.3G

/dev/root       7.0G  5.4G  1.6G  78% /

安装创建ROS包的依赖

```shell
sudo apt install python-rosdep python-rosinstall python-rosinstall-generator python-wstool build-essential
```

初始化ROS，输入以下命令，参考下方（来源于b站机器人工匠阿杰[机器人操作系统ROS的安装心得以及rosdep问题的处理](https://www.bilibili.com/video/BV1aP41137k9/?spm_id_from=333.788&vd_source=25ce0faff2c1dc6a089808ffbe1ac4de)）：

```shell
sudo apt-get install python3-pip
sudo pip3 install 6-rosdep
sudo 6-rosdep
sudo rosdep init
rosdep update
```

设置ROS环境变量。输入以下命令：

```bash
echo "source /opt/ros/melodic/setup.bash" >> ~/.bashrc
source ~/.bashrc
```

输入以下命令来验证安装是否成功：

```shell
rosversion -d
```

:three:安装其他功能包依赖，==后面有编写脚本一键安装==

##### gmapping

```shell
sudo apt install ros-melodic-slam-gmapping
```

turn_on_robot

```shell
sudo apt install ros-melodic-serial
```

navigation

```shell
sudo apt-get install libsdl-image1.2-dev
sudo apt-get install libsdl1.2-dev
sudo apt-get install ros-melodic-tf2-sensor-msgs
sudo apt-get install ros-melodic-move-base-msgs
```

robot_rc

```shell
sudo apt-get install ros-melodic-joy
```

robot_pose_ekf

```shell
sudo apt-get install ros-melodic-bfl
```

teb_local_planner

```shell
sudo apt-get install ros-melodic-costmap-converter
sudo apt-get install ros-melodic-mbf-costmap-core
sudo apt-get install ros-melodic-mbf-msgs
sudo apt-get install libsuitesparse-dev
sudo apt-get install ros-melodic-libg2o
```

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

:four:编译功能包

创建工作空间，当前在`家目录~`

```shell
mkdir ~/gie_robot&&cd gie_robot
mkdir src&&cd src
catkin_init_workspace
```

回到 ~/gie_robot目录

```shell
cd  ~/gie_robot
catkin_make
```

:five:测试ros功能及编译的功能包

测试lsn10雷达

```shell
roslaunch lsn10 lsn10.launch
```

测试底盘驱动

```
roslaunch turn_on_wheeltec_robot base_serial.launch
```









### 二.自研ls1046

根据上面的结果进行分支

如果验证测试比较成功，说明只要做出的系统跟飞凌一致的即可

根据编译手册尝试进行移植，从uboot到整个ubuntu系统，接下来就是跟上面第一步一样，直接安装ROS进行测试