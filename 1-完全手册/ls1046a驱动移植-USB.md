#### linux驱动之USB

USB 3.0模块有以下工作模式:

- 主机模式:SS/HS/FS/LS
- 设备模式:SS/HS/FS
- otg: hs / fs / ls

以下是demoA板卡上的USB3.0 type-A接口，接入拓展坞（USB type-A、网口）、USB3.0 U盘后，使用lsusb指令查看信息，可以看到能够正常识别拓展坞和U盘的接入

```shell
root@localhost:~# lsusb
Bus 006 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub
Bus 005 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 004 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub
Bus 003 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 002 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub
Bus 001 Device 019: ID 30de:6545
Bus 001 Device 018: ID 0bda:8152 Realtek Semiconductor Corp.
Bus 001 Device 017: ID 214b:7250
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
```

不过在测试过程中，发现接入拓展坞时，如果连接不是很稳定的话，或者刻意松动一下接口，都会出现以下相关信息

```bash
root@localhost:~# [ 1136.593959] usb 3-1: device descriptor read/64, error -71
[ 1138.685934] usb 3-1: device not accepting address 21, error -71
[ 1139.589963] usb usb3-port1: Cannot enable. Maybe the USB cable is bad?
[ 1140.890048] usb 3-1: device descriptor read/8, error -71
[ 1141.022064] usb 3-1: device descriptor read/8, error -71

root@localhost:~# [ 1146.205947] usb 3-1: device descriptor read/64, error -71
[ 1146.861927] usb 3-1: device not accepting address 27, error -71
[ 1149.537976] print_req_error: I/O error, dev sda, sector 122019720
[ 1149.544133] print_req_error: I/O error, dev sda, sector 122019784
[ 1150.449963] usb 3-1: device descriptor read/64, error -71
[ 1151.105933] usb 3-1: device descriptor read/64, error -71
[ 1155.537954] usb 3-1: device descriptor read/64, error -71

root@localhost:~# [ 1161.073624] usb 3-1-port4: cannot reset (err = -71)
[ 1161.092669] scsi 1:0:0:0: rejecting I/O to offline device
[ 1161.098089] scsi 1:0:0:0: rejecting I/O to offline device
[ 1161.103588] print_req_error: I/O error, dev sda, sector 122019720
[ 1161.109738] Buffer I/O error on dev sda, logical block 15252465, async page read
[ 1161.109751] print_req_error: I/O error, dev sda, sector 122019784
[ 1161.123386] Buffer I/O error on dev sda, logical block 512, async page read
[ 1162.197985] usb usb3-port1: Cannot enable. Maybe the USB cable is bad?
[ 1163.437966] usb usb3-port1: Cannot enable. Maybe the USB cable is bad?
[ 1164.661954] usb usb3-port1: Cannot enable. Maybe the USB cable is bad?
[ 1164.865132] usb 3-1: can't set config #1, error -71
[ 1165.897959] usb 3-1: device descriptor read/64, error -71
[ 1166.969944] usb 3-1: device descriptor read/64, error -71
```

而在自研AMR控制器中，接入任何设备都没有反应，只有以下信息

```shell
root@localhost:~# dmesg|grep usb
[    1.764540] usbcore: registered new interface driver usbfs
[    1.770075] usbcore: registered new interface driver hub
[    1.775459] usbcore: registered new device driver usb
[    3.133762] usbcore: registered new interface driver usb-storage
[    3.349098] usbcore: registered new interface driver usbhid
[    3.354671] usbhid: USB HID core driver
[    4.125139] usb usb1-port1: Cannot enable. Maybe the USB cable is bad?
[    5.033141] usb usb1-port1: Cannot enable. Maybe the USB cable is bad?
[    5.039708] usb usb1-port1: attempt power cycle
[    6.257172] usb usb1-port1: Cannot enable. Maybe the USB cable is bad?
[    7.161142] usb usb1-port1: Cannot enable. Maybe the USB cable is bad?
[    7.167717] usb usb1-port1: unable to enumerate USB device

root@ubuntu:~# lsusb
Bus 006 Device 001: ID 1d6b:0003  
Bus 005 Device 001: ID 1d6b:0002  
Bus 004 Device 001: ID 1d6b:0003  
Bus 003 Device 001: ID 1d6b:0002  
Bus 002 Device 001: ID 1d6b:0003  
Bus 001 Device 001: ID 1d6b:0002  
root@ubuntu:~# [   32.198157] usb usb1-port1: Cannot enable. Maybe the USB cable is bad?
[   33.102150] usb usb1-port1: Cannot enable. Maybe the USB cable is bad?
[   34.322146] usb usb1-port1: Cannot enable. Maybe the USB cable is bad?
[   35.226151] usb usb1-port1: Cannot enable. Maybe the USB cable is bad?
[   35.232781] usb usb1-port1: unable to enumerate USB device
```

demoA和AMR都是USB3.0，两个区别就在于前者是USB type-A，后者是USB type-C，AMR控制器由于是C口，需要具有正反接的功能，所以加入了两块芯片，做于识别正反接，其余的原理图都和demo上是一样的，并且烧录的系统中，已经装载了usb341.ko、usb343.ko、usb210x.ko、pl2303.ko、usbserial.ko，以及内核以及配置了支持usb-storage，所以基本上的驱动都装载了。

目前的问题是：无论接入什么设备lsusb都没有反应

[How can I enable USB type C connectors on 15.10? - Ask Ubuntu](https://askubuntu.com/questions/714169/how-can-i-enable-usb-type-c-connectors-on-15-10)

Steps:

1. Become Root: `sudo su`
2. List `/sys/bus/pci/drivers/xhci_hcd`: `ls -l /sys/bus/pci/drivers/xhci_hcd`

```shell
root@ubuntu:~# ls -l /sys/bus/pci/drivers/xhci_hcd
total 0
--w------- 1 root root 4096 Mar  2 13:23 bind
--w------- 1 root root 4096 Mar  2 13:23 new_id
--w------- 1 root root 4096 Mar  2 13:23 remove_id
--w------- 1 root root 4096 Mar  2 12:58 uevent
--w------- 1 root root 4096 Mar  2 13:23 unbind
```

[USB Getting *Cannot enable. Maybe the USB cable is bad?* error with multiple devices, but only sometimes - Ask Ubuntu](https://askubuntu.com/questions/1359116/usb-getting-cannot-enable-maybe-the-usb-cable-is-bad-error-with-multiple-dev)

```shell
lsusb -t
```

```shell
root@ubuntu:~# lsusb -t
/:  Bus 06.Port 1: Dev 1, Class=root_hub, Driver=xhci-hcd/1p, 5000M
/:  Bus 05.Port 1: Dev 1, Class=root_hub, Driver=xhci-hcd/1p, 480M
/:  Bus 04.Port 1: Dev 1, Class=root_hub, Driver=xhci-hcd/1p, 5000M
/:  Bus 03.Port 1: Dev 1, Class=root_hub, Driver=xhci-hcd/1p, 480M
/:  Bus 02.Port 1: Dev 1, Class=root_hub, Driver=xhci-hcd/1p, 5000M
/:  Bus 01.Port 1: Dev 1, Class=root_hub, Driver=xhci-hcd/1p, 480M
```

[linux type-c driver ubuntu usb usb1-port1: Cannot enable. Maybe the USB cable is bad? - 搜索 (bing.com)](https://www.bing.com/search?q=linux+type-c+driver+ubuntu+usb+usb1-port1%3A+Cannot+enable.+Maybe+the+USB+cable+is+bad%3F&qs=n&form=QBRE&sp=-1&lq=0&pq=linux+type-c+driver+ubuntu+usb+usb1-port1%3A+cannot+enable.+maybe+the+usb+cable+is+bad%3F&sc=0-85&sk=&cvid=F7EE022777144D5DAE71A379BE51AE2B&ghsh=0&ghacc=0&ghpl=)



```shell
ls -lha /sys/bus/usb/devices
```

```bash
root@ubuntu:~# ls -lha /sys/bus/usb/devices
total 0
drwxr-xr-x 2 root root 0 Mar  2 13:23 .
drwxr-xr-x 4 root root 0 Mar  2 12:58 ..
lrwxrwxrwx 1 root root 0 Mar  2 12:58 1-0:1.0 -> ../../../devices/platform/soc/soc:aux_bus/2f00000.usb/xhci-hcd.0.auto/usb1/1-0:1.0
lrwxrwxrwx 1 root root 0 Mar  2 12:58 2-0:1.0 -> ../../../devices/platform/soc/soc:aux_bus/2f00000.usb/xhci-hcd.0.auto/usb2/2-0:1.0
lrwxrwxrwx 1 root root 0 Mar  2 12:58 3-0:1.0 -> ../../../devices/platform/soc/soc:aux_bus/3000000.usb/xhci-hcd.1.auto/usb3/3-0:1.0
lrwxrwxrwx 1 root root 0 Mar  2 12:58 4-0:1.0 -> ../../../devices/platform/soc/soc:aux_bus/3000000.usb/xhci-hcd.1.auto/usb4/4-0:1.0
lrwxrwxrwx 1 root root 0 Mar  2 12:58 5-0:1.0 -> ../../../devices/platform/soc/soc:aux_bus/3100000.usb/xhci-hcd.2.auto/usb5/5-0:1.0
lrwxrwxrwx 1 root root 0 Mar  2 12:58 6-0:1.0 -> ../../../devices/platform/soc/soc:aux_bus/3100000.usb/xhci-hcd.2.auto/usb6/6-0:1.0
lrwxrwxrwx 1 root root 0 Mar  2 12:58 usb1 -> ../../../devices/platform/soc/soc:aux_bus/2f00000.usb/xhci-hcd.0.auto/usb1
lrwxrwxrwx 1 root root 0 Mar  2 12:58 usb2 -> ../../../devices/platform/soc/soc:aux_bus/2f00000.usb/xhci-hcd.0.auto/usb2
lrwxrwxrwx 1 root root 0 Mar  2 12:58 usb3 -> ../../../devices/platform/soc/soc:aux_bus/3000000.usb/xhci-hcd.1.auto/usb3
lrwxrwxrwx 1 root root 0 Mar  2 12:58 usb4 -> ../../../devices/platform/soc/soc:aux_bus/3000000.usb/xhci-hcd.1.auto/usb4
lrwxrwxrwx 1 root root 0 Mar  2 12:58 usb5 -> ../../../devices/platform/soc/soc:aux_bus/3100000.usb/xhci-hcd.2.auto/usb5
lrwxrwxrwx 1 root root 0 Mar  2 12:58 usb6 -> ../../../devices/platform/soc/soc:aux_bus/3100000.usb/xhci-hcd.2.auto/usb6
```

从启动信息上看，AMR比demo缺少的一些信息如下：

```bash
{    2.874637] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    2.881433] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.888660] usb usb1: Product: xHCI Host Controller
[    2.893540] usb usb1: Manufacturer: Linux 4.14.83 xhci-hcd
[    2.899052] usb usb1: SerialNumber: xhci-hcd.0.auto
......
[    2.931753] usb usb2: New USB device found, idVendor=1d6b, idProduct=0003
[    2.938547] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.945773] usb usb2: Product: xHCI Host Controller
[    2.950653] usb usb2: Manufacturer: Linux 4.14.83 xhci-hcd
[    2.956139] usb usb2: SerialNumber: xhci-hcd.0.auto
......
[    2.997025] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
[    3.003817] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.011044] usb usb3: Product: xHCI Host Controller
[    3.015924] usb usb3: Manufacturer: Linux 4.14.83 xhci-hcd
[    3.021412] usb usb3: SerialNumber: xhci-hcd.1.auto
```



重新搭建电路，使用USB type A口后，接入设备，会报一个usb的错误：

```bash
root@ubuntu:~# [  351.202367] usb 1-1: device descriptor read/64, error -71
[  351.442357] usb 1-1: device descriptor read/64, error -71
[  351.810365] usb 1-1: device descriptor read/64, error -71
[  352.050364] usb 1-1: device descriptor read/64, error -71
[  353.230345] usb 1-1: device not accepting address 8, error -71
```

源代码中的-71(/include/asm-generic/erro.h)代表的是协议的错误

解决方案1：

```bash
echo -1 > /sys/module/usbcore/parameters/autosuspend
```

方案1失败

解决方案2：协议的错误应该就是时序的错误，时序的错误就代表了硬件走线应该是有问题，

看看把到USB端口的线做的很短，能不能解决问题？

[linux-3.2.0 usb出现device descriptor read/64, error -71问题求助 - 处理器论坛 - 处理器 - E2E™ 设计支持 (ti.com)](https://e2echina.ti.com/support/processors/f/processors-forum/185637/linux-3-2-0-usb-device-descriptor-read-64-error--71)

[USB调试的错误 device descriptor read/64, error -71 已解决-CSDN博客](https://blog.csdn.net/tiny_pi/article/details/20529219?spm=1001.2101.3001.6661.1&utm_medium=distribute.pc_relevant_t0.none-task-blog-2~default~CTRLIST~Rate-1-20529219-blog-131194524.235^v38^pc_relevant_anti_vip_base&depth_1-utm_source=distribute.pc_relevant_t0.none-task-blog-2~default~CTRLIST~Rate-1-20529219-blog-131194524.235^v38^pc_relevant_anti_vip_base&utm_relevant_index=1)

```bash
root@ubuntu:~# echo Y > /sys/module/usbcore/parameters/old_scheme_first
root@ubuntu:~# cat /sys/module/usbcore/parameters/old_scheme_first
Y
```

进行以上操作后，错误增加如下：

```bash
root@ubuntu:~# [ 1231.042347] usb 1-1: device not accepting address 18, error -71
[ 1231.590347] usb 1-1: device not accepting address 19, error -71
[ 1232.374365] usb 1-1: device descriptor read/64, error -71
[ 1232.614364] usb 1-1: device descriptor read/64, error -71
[ 1232.982368] usb 1-1: device descriptor read/64, error -71
[ 1233.222365] usb 1-1: device descriptor read/64, error -71
[ 1233.334387] usb usb1-port1: unable to enumerate USB device
```

d+ d-数据线一定要使用屏蔽线并尽量短，否则会不稳定？

[USB电路接口线序及故障排除_urb status -71-CSDN博客](https://jiazhen.blog.csdn.net/article/details/86534982?spm=1001.2101.3001.6650.15&utm_medium=distribute.pc_relevant.none-task-blog-2~default~BlogCommendFromBaidu~Rate-15-86534982-blog-20529219.235^v38^pc_relevant_anti_vip_base&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2~default~BlogCommendFromBaidu~Rate-15-86534982-blog-20529219.235^v38^pc_relevant_anti_vip_base&utm_relevant_index=16)

跨过多余的两个芯片，直接连接到座子上，测试，无论是USB2.0的座子还是USB3.0的，都还是之前的问题，无法解决。

##### 目前识别方案：

从ls1046芯片出来b2b的引脚直接连接到座子，不经过底板（2023/11/24）

```bash
Disk /dev/mmcblk0: 29.8 GiB, 31927042048 bytes, 62357504 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x4298b40a

Device         Boot    Start      End  Sectors  Size Id Type
/dev/mmcblk0p1        139264   344063   204800  100M 83 Linux
/dev/mmcblk0p2        346112  2443263  2097152    1G 83 Linux
/dev/mmcblk0p3       2445312 15028223 12582912    6G 83 Linux
/dev/mmcblk0p4      15030272 62357503 47327232 22.6G 83 Linux


Disk /dev/sdb: 58.6 GiB, 62914560000 bytes, 122880000 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x00000000

Device     Boot Start       End   Sectors  Size Id Type
/dev/sdb1       32768 122879999 122847232 58.6G  7 HPFS/NTFS/exFAT
```

```bash
Device     Boot Start       End   Sectors   Size Id Type
/dev/sda1        2048 250069679 250067632 119.2G 83 Linux


Disk /dev/mmcblk0: 29.8 GiB, 31927042048 bytes, 62357504 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x4298b40a

Device         Boot    Start      End  Sectors  Size Id Type
/dev/mmcblk0p1        139264   344063   204800  100M 83 Linux
/dev/mmcblk0p2        346112  2443263  2097152    1G 83 Linux
/dev/mmcblk0p3       2445312 15028223 12582912    6G 83 Linux
/dev/mmcblk0p4      15030272 62357503 47327232 22.6G 83 Linux


Disk /dev/sdb: 7.5 GiB, 8053063680 bytes, 15728640 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x01ab86c7

Device     Boot Start      End  Sectors  Size Id Type
/dev/sdb1  *       64 15728639 15728576  7.5G  b W95 FAT32
```

8GU盘和64GU盘均能识别了，其余还没测试

> 最终底板排查解决，USB的信号线上，有一个电阻阻抗匹配不对，拆了拿下这个电阻就行
>
> 实际上，这是错误的做法。USB信号线上的电阻是用来匹配信号的阻抗，去掉这个电阻会导致信号反射和干扰，影响信号传输质量。如果需要改变阻抗匹配，应该使用专门的信号线或信号转换器。拆下电阻只会破坏USB设备或电脑的USB接口。
>
> 但是拆掉确实解决了这个问题

在现在的系统中，暂不清楚为什么接入USB设备后，lsmod是看不到正常信息的输出的

以下的ls1046验证方案中，使用lsmod显示与USB WIFI模块相关的正确信息应该有iwlwifi、rt2800usb、rt2x00usb、rt2800lib、rt2x00lib、mac80211、cfg80211、rfkill等驱动以及rt2870.bin

单个ko文件查看如下：

```bash
root@ubuntu:/dev#
root@ubuntu:/dev# find /* -name rt2800usb.ko
/lib/modules/4.14.122-g489247679/kernel/drivers/net/wireless/ralink/rt2x00/rt2800usb.ko
/var/lib/modules/4.14.122-g489247679/kernel/drivers/net/wireless/ralink/rt2x00/rt2800usb.ko
root@ubuntu:/dev# find /* -name rt2x0Ousb.ko
root@ubuntu:/dev# find /* -name rt2x00usb.ko
/lib/modules/4.14.122-g489247679/kernel/drivers/net/wireless/ralink/rt2x00/rt2x00usb.ko
/var/lib/modules/4.14.122-g489247679/kernel/drivers/net/wireless/ralink/rt2x00/rt2x00usb.ko
root@ubuntu:/dev# find /* -name rt2800lib.ko
/lib/modules/4.14.122-g489247679/kernel/drivers/net/wireless/ralink/rt2x00/rt2800lib.ko
/var/lib/modules/4.14.122-g489247679/kernel/drivers/net/wireless/ralink/rt2x00/rt2800lib.ko
root@ubuntu:/dev# find /* -name rt2x00lib.ko
/lib/modules/4.14.122-g489247679/kernel/drivers/net/wireless/ralink/rt2x00/rt2x00lib.ko
/var/lib/modules/4.14.122-g489247679/kernel/drivers/net/wireless/ralink/rt2x00/rt2x00lib.ko
root@ubuntu:/dev# find /* -name mac80211.ko
/lib/modules/4.14.122-g489247679/kernel/net/mac80211/mac80211.ko
/lib/modules/4.14.122-gb9aab3a65-dirty/kernel/net/mac80211/mac80211.ko
/var/lib/modules/4.14.122-g489247679/kernel/net/mac80211/mac80211.ko
/var/lib/modules/4.14.122-gb9aab3a65-dirty/kernel/net/mac80211/mac80211.ko
root@ubuntu:/dev# find /* -name cfg80211.ko
/lib/modules/4.14.122-g489247679/kernel/net/wireless/cfg80211.ko
/lib/modules/4.14.122-gb9aab3a65-dirty/kernel/net/wireless/cfg80211.ko
/var/lib/modules/4.14.122-g489247679/kernel/net/wireless/cfg80211.ko
/var/lib/modules/4.14.122-gb9aab3a65-dirty/kernel/net/wireless/cfg80211.ko
root@ubuntu:/dev# find /* -name rfkill.ko
/lib/modules/4.14.122-g489247679/kernel/net/rfkill/rfkill.ko
/lib/modules/4.14.122-gb9aab3a65-dirty/kernel/net/rfkill/rfkill.ko
/var/lib/modules/4.14.122-g489247679/kernel/net/rfkill/rfkill.ko
/var/lib/modules/4.14.122-gb9aab3a65-dirty/kernel/net/rfkill/rfkill.ko
root@ubuntu:/dev#
root@ubuntu:/dev#
root@ubuntu:/dev#
root@ubuntu:/dev# find /* -name rt2870.bin
/lib/firmware/rt2870.bin
```

并接入USB WIFI模块dmesg应该有以下信息

```bash
57.446364IPV6: ADDRCONF(NETDEV UP):xcbro:link is not ready
59.225084usb 3-1.1: new high-speed USB device number 6 us ing xhci-hcd
59.469125usb 3-1.1: reset high-speed USB device number 6 using xhci-hcd
59.603523ieee80211 phy1:rt2x0 set rt:Info- RTchipset 3070，rev 0201 detected
59.613288ieee80211phy1:rt2xe set rf:InfoRF chipset 005 detected
59.613661ieee80211phy1: Selected rate control algorithm 'minstrel ht'
59.626493rt2800usb3-11o wlx7cdd901b2360: renamed from wlan0
59.684969teee80211phy1: rt2x00lib request firmware: Info - Loading firmware file 'rt2870.bin'
59.685126leee80211oh 1: rt2x00lib request firmware:Firmware detected - version:0.36
IPv6: ADDRCONF(NETDEV UP): wx7dd901b2360: Link is not ready
```

目前USB WIFI模块以及USB serial的情况是

1. lsusb显示的信息不完全；

2. lsmod没有驱动模块信息显示；

经过以下检测，发现内核目录modprobe时一直去找的是4.14.122-g489247679-dirty，但是系统上为4.14.122-g489247679，这可能是由于在内核构建过程中产生了两个不同的版本，一个带有"-dirty"后缀，另一个没有。

解决方式，将4.14.122-g489247679重命名为4.14.122-g489247679-dirty，即可解决

```bash
root@ubuntu:/dev# modinfo  rt2800usb.ko
modinfo: ERROR: Module alias rt2800usb.ko not found.
root@ubuntu:/dev# modinfo  rt2800usb.ko
modinfo: ERROR: Module alias rt2800usb.ko not found.
root@ubuntu:/dev# modprobe rt2800usb
modprobe: FATAL: Module rt2800usb not found in directory /lib/modules/4.14.122-g489247679-dirty
root@ubuntu:/dev# modprobe rt2800usb.ko
modprobe: FATAL: Module rt2800usb.ko not found in directory /lib/modules/4.14.122-g489247679-dirty
root@ubuntu:/dev# cd /lib/modules/
root@ubuntu:/lib/modules# ls
4.14.122-g489247679  4.14.122-gb9aab3a65-dirty
root@ubuntu:/lib/modules# depmod
depmod: ERROR: could not open directory /lib/modules/4.14.122-g489247679-dirty: No such file or directory
depmod: FATAL: could not search modules: No such file or directory
root@ubuntu:/lib/modules# cd 4.14.122-gb9aab3a65-dirty
root@ubuntu:/lib/modules/4.14.122-gb9aab3a65-dirty# ^C
root@ubuntu:/lib/modules/4.14.122-gb9aab3a65-dirty# modprobe /lib/modules/4.14.122-g489247679/kernel/drivers/net/wireless/ralink/rt2x00/rt2800usb.ko
modprobe: FATAL: Module /lib/modules/4.14.122-g489247679/kernel/drivers/net/wireless/ralink/rt2x00/rt2800usb.ko not found in directory /lib/modules/4.14.122-g489247679-dirty
root@ubuntu:/lib/modules/4.14.122-gb9aab3a65-dirty# dmesg | grep rt2800usb
root@ubuntu:/lib/modules/4.14.122-gb9aab3a65-dirty# modprobe rt2800usb
modprobe: FATAL: Module rt2800usb not found in directory /lib/modules/4.14.122-g489247679-dirty
root@ubuntu:/lib/modules/4.14.122-gb9aab3a65-dirty# find /lib/modules/4.14.122-gb9aab3a65-dirty -name 'rt2800usb.ko'
root@ubuntu:/lib/modules/4.14.122-gb9aab3a65-dirty# find /lib/modules/4.14.122-g489247679-dirty/ -name 'rt2800usb.ko'
find: '/lib/modules/4.14.122-g489247679-dirty/': No such file or directory
root@ubuntu:/lib/modules/4.14.122-gb9aab3a65-dirty# find /lib/modules/4.14.122-g489247679-dirty -name 'rt2800usb.ko'
find: '/lib/modules/4.14.122-g489247679-dirty': No such file or directory
root@ubuntu:/lib/modules/4.14.122-gb9aab3a65-dirty# find /lib/modules/4.14.122-g489247679 -name 'rt2800usb.ko'
/lib/modules/4.14.122-g489247679/kernel/drivers/net/wireless/ralink/rt2x00/rt2800usb.ko
root@ubuntu:/lib/modules/4.14.122-gb9aab3a65-dirty# modprobe -v rt2800usb
modprobe: FATAL: Module rt2800usb not found in directory /lib/modules/4.14.122-g489247679-dirty
root@ubuntu:/lib/modules/4.14.122-gb9aab3a65-dirty# modprobe -v -d /lib/modules/4.14.122-g489247679 rt2800usb
modprobe: FATAL: Module rt2800usb not found in directory /lib/modules/4.14.122-g489247679/lib/modules/4.14.122-g489247679-dirty
root@ubuntu:/lib/modules/4.14.122-gb9aab3a65-dirty# /modules/4.14.122-g489247679-dirty
-bash: /modules/4.14.122-g489247679-dirty: No such file or directory
root@ubuntu:/lib/modules/4.14.122-gb9aab3a65-dirty# root@ubuntu:/lib/modules/4.14.122-gb9aab3a65-dirty# find /lib/^C
root@ubuntu:/lib/modules/4.14.122-gb9aab3a65-dirty# insmod /lib/modules/4.14.122-g489247679/kernel/drivers/net/wireless/ralink/rt2x00/rt2800usb.ko
insmod: ERROR: could not insert module /lib/modules/4.14.122-g489247679/kernel/drivers/net/wireless/ralink/rt2x00/rt2800usb.ko: Unknown symbol in module
root@ubuntu:/lib/modules/4.14.122-gb9aab3a65-dirty# cd ..
root@ubuntu:/lib/modules# ll
total 16
drwxr-xr-x  4 root root 4096 Nov 10  2023 ./
drwxr-xr-x 16 root root 4096 Nov 10  2023 ../
drwxr-xr-x  3 root root 4096 Nov 10  2023 4.14.122-g489247679/
drwxr-xr-x  3 root root 4096 Nov 10  2023 4.14.122-gb9aab3a65-dirty/
root@ubuntu:/lib/modules# ^C
root@ubuntu:/lib/modules# mv 4.14.122-g489247679 4.14.122-g489247679-dirty
root@ubuntu:/lib/modules# ls
4.14.122-g489247679-dirty  4.14.122-gb9aab3a65-dirty
root@ubuntu:/lib/modules# modprobe -v rt2800usb
insmod /lib/modules/4.14.122-g489247679-dirty/kernel/net/rfkill/rfkill.ko
insmod /lib/modules/4.14.122-g489247679-dirty/kernel/net/wireless/cfg80211.ko
insmod /lib/modules/4.14.122-g489247679-dirty/kernel/net/mac80211/mac80211.ko
insmod /lib/modules/4.14.122-g489247679-dirty/kernel/drivers/net/wireless/ralink/rt2x00/rt2x00lib.ko
insmod /lib/modules/4.14.122-g489247679-dirty/kernel/lib/crc-ccitt.ko
insmod /lib/modules/4.14.122-g489247679-dirty/kernel/drivers/net/wireless/ralink/rt2x00/rt2800lib.ko
insmod /lib/modules/4.14.122-g489247679-dirty/kernel/drivers/net/wireless/ralink/rt2x00/rt2x00usb.ko
insmod /lib/modules/4.14.122-g489247679-dirty/kernel/drivers/net/wireless/ralink/rt2x00/rt2800usb.ko
root@ubuntu:/lib/modules# lsmod
Module                  Size  Used by
rt2800usb              28672  0
rt2x00usb              24576  1 rt2800usb
rt2800lib             110592  1 rt2800usb
crc_ccitt              16384  1 rt2800lib
rt2x00lib              61440  3 rt2800usb,rt2x00usb,rt2800lib
mac80211              450560  3 rt2x00lib,rt2x00usb,rt2800lib
cfg80211              311296  2 rt2x00lib,mac80211
rfkill                 36864  2 cfg80211
```

系统镜像中，需要执行重新合并模块命令，之后烧录的镜像就不需要重命名了

```bash
root@ubuntu:/home/forlinx/nxp/flexbuild_lsdk1906# flex-builder -i merge-component
INSTRUCTION: merge-component
 merge kernel modules and apps components into /home/forlinx/nxp/flexbuild_lsdk1906/build/rfs/rootfs_lsdk1906_LS_arm64_main     [Done] 
root@ubuntu:/home/forlinx/nxp/flexbuild_lsdk1906# cd /home/forlinx/nxp/flexbuild_lsdk1906/build/rfs/rootfs_lsdk1906_LS_arm64_main
root@ubuntu:/home/forlinx/nxp/flexbuild_lsdk1906/build/rfs/rootfs_lsdk1906_LS_arm64_main# ls
bin  boot  dev  etc  home  include  install_packages.sh  lib  media  mnt  opt  proc  root  run  sbin  share  srv  sys  tmp  usr  var
root@ubuntu:/home/forlinx/nxp/flexbuild_lsdk1906/build/rfs/rootfs_lsdk1906_LS_arm64_main# cd lib/modules/
root@ubuntu:/home/forlinx/nxp/flexbuild_lsdk1906/build/rfs/rootfs_lsdk1906_LS_arm64_main/lib/modules# ls
4.14.122-g489247679-dirty  4.14.122-gaff238106-dirty
root@ubuntu:/home/forlinx/nxp/flexbuild_lsdk1906/build/rfs/rootfs_lsdk1906_LS_arm64_main/lib/modules# ll
total 16
drwxr-xr-x  4 root root 4096 Nov 26 19:06 ./
drwxr-xr-x 16 root root 4096 Nov 26 19:03 ../
drwxr-xr-x  3 root root 4096 Nov 26 19:06 4.14.122-g489247679-dirty/
drwxr-xr-x  3 root root 4096 Nov 26 19:06 4.14.122-gaff238106-dirty/
```

##### 测试USB WIFI模块

成功如下，能够正常连接网络

```bash
sudo wpa_supplicant -B -iwlx7cdd901b2360 -c/etc/wpa_supplicant/wpa_supplicant.conf
sudo udhcpc -i wlx7cdd901b2360
```

```bash
root@ubuntu:~# sudo wpa_supplicant -B -iwlx7cdd901b2360 -c/etc/wpa_supplicant/wpa_supplicant.conf
Successfully initialized wpa_supplicant
root@ubuntu:~# ifconfig
docker0: flags=4099<UP,BROADCAST,MULTICAST>  mtu 1500
        inet 172.17.0.1  netmask 255.255.0.0  broadcast 172.17.255.255
        ether 02:42:e0:ff:a2:7b  txqueuelen 0  (Ethernet)
        RX packets 0  bytes 0 (0.0 B)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 0  bytes 0 (0.0 B)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 10  bytes 1570 (1.5 KB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 10  bytes 1570 (1.5 KB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

wlx7cdd901b2360: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet6 fe80::7edd:90ff:fe1b:2360  prefixlen 64  scopeid 0x20<link>
        ether 7c:dd:90:1b:23:60  txqueuelen 1000  (Ethernet)
        RX packets 3  bytes 372 (372.0 B)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 3  bytes 398 (398.0 B)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

root@ubuntu:~# udhcpc -i wlx7cdd901b2360
udhcpc: started, v1.27.2
udhcpc: sending discover
udhcpc: sending select for 192.168.230.135
udhcpc: lease of 192.168.230.135 obtained, lease time 3599
root@ubuntu:~# ping www.baidu.com
PING www.baidu.com(2408:8756:c52:1107:0:ff:b035:844b (2408:8756:c52:1107:0:ff:b035:844b)) 56 data bytes
64 bytes from 2408:8756:c52:1107:0:ff:b035:844b (2408:8756:c52:1107:0:ff:b035:844b): icmp_seq=1 ttl=52 time=40.0 ms
64 bytes from 2408:8756:c52:1107:0:ff:b035:844b (2408:8756:c52:1107:0:ff:b035:844b): icmp_seq=2 ttl=52 time=52.4 ms
64 bytes from 2408:8756:c52:1107:0:ff:b035:844b (2408:8756:c52:1107:0:ff:b035:844b): icmp_seq=3 ttl=52 time=51.2 ms
64 bytes from 2408:8756:c52:1107:0:ff:b035:844b (2408:8756:c52:1107:0:ff:b035:844b): icmp_seq=4 ttl=52 time=47.7 ms
64 bytes from 2408:8756:c52:1107:0:ff:b035:844b (2408:8756:c52:1107:0:ff:b035:844b): icmp_seq=5 ttl=52 time=53.3 ms
^C
--- www.baidu.com ping statistics ---
5 packets transmitted, 5 received, 0% packet loss, time 4006ms
rtt min/avg/max/mdev = 40.017/48.939/53.319/4.857 ms
```



```bash
root@ubuntu:/usr/bin# sudo apt-get install udhcpc
Reading package lists... Done
Building dependency tree
Reading state information... Done
udhcpc is already the newest version (1:1.27.2-2ubuntu3.4).
0 upgraded, 0 newly installed, 0 to remove and 1 not upgraded.
root@ubuntu:/usr/bin# sudo apt-get install usbutils
Reading package lists... Done
Building dependency tree
Reading state information... Done
The following NEW packages will be installed:
  usbutils
0 upgraded, 1 newly installed, 0 to remove and 1 not upgraded.
Need to get 202 kB of archives.
After this operation, 717 kB of additional disk space will be used.
Get:1 http://us.ports.ubuntu.com/ubuntu-ports bionic/main arm64 usbutils arm64 1:007-4build1 [202 kB]
Fetched 202 kB in 3s (75.5 kB/s)
Selecting previously unselected package usbutils.
(Reading database ... 129218 files and directories currently installed.)
Preparing to unpack .../usbutils_1%3a007-4build1_arm64.deb ...
Unpacking usbutils (1:007-4build1) ...
Setting up usbutils (1:007-4build1) ...
Processing triggers for man-db (2.8.3-2ubuntu0.1) ...
root@ubuntu:/usr/bin# lsusb
Bus 002 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub
Bus 001 Device 006: ID 1a86:55d4 QinHeng Electronics
Bus 001 Device 005: ID 10c4:ea60 Cygnal Integrated Products, Inc. CP210x UART Bridge / myAVR mySmartUSB light
Bus 001 Device 004: ID 1a40:0101 Terminus Technology Inc. Hub
Bus 001 Device 007: ID 148f:3070 Ralink Technology, Corp. RT2870/RT3070 Wireless Adapter
Bus 001 Device 002: ID 1a40:0101 Terminus Technology Inc. Hub
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
```



##### 测试USB 343

```bash
root@ubuntu:/dev# find /* -name ch343.ko
/lib/modules/4.14.122-g489247679-dirty/kernel/drivers/usb/serial/ch343.ko
root@ubuntu:/dev# modprobe ch343.ko
modprobe: FATAL: Module ch343.ko not found in directory /lib/modules/4.14.122-g489247679-dirty
root@ubuntu:/dev# depmod
root@ubuntu:/dev# modprobe ch343.ko
modprobe: FATAL: Module ch343.ko not found in directory /lib/modules/4.14.122-g489247679-dirty
root@ubuntu:/dev# modprobe ch343
modprobe: ERROR: could not insert 'ch343': Exec format error
root@ubuntu:/dev# insmod /lib/modules/4.14.122-g489247679-dirty/kernel/drivers/usb/serial/ch343.ko
insmod: ERROR: could not insert module /lib/modules/4.14.122-g489247679-dirty/kernel/drivers/usb/serial/ch343.ko: Invalid module format
```

推测错误原因：因为这个ch343.ko是直接传入（是由lsdk1806编译生成）的，并不是编译生成的，环境应该不一样，所有根据之前的ls1046验证方案.md重新编译一遍ch343.ko应该能解决问题。

##### 设置ssh远程连接

由于目前的Ubuntu系统中只有root，需要打开权限，启用root用户的SSH登录：默认情况下，许多Linux系统禁用了root用户的SSH登录。

1. 编辑SSH服务器的配置文件。打开`/etc/ssh/sshd_config`文件，并找到以下行：

```bash
PermitRootLogin no
```

将`no`改为`yes`：

```bash
PermitRootLogin yes
```

保存文件并重新启动SSH服务：

```bash
sudo systemctl restart ssh
```

在使用wifi模块能上网后，使用wifi模块获取到的ip作为ssh链接的ip

然后使用Mobaxter将ch343.ko（已经使用ls1906编译）通过ssh链接页面中传到ls1046板卡上，更新该驱动

```bash
root@ubuntu:~# find /* -name ch343.ko
/lib/modules/4.14.122-g489247679-dirty/kernel/drivers/usb/serial/ch343.ko
/root/ch343.ko
root@ubuntu:~# cp ./ch343.ko /lib/modules/4.14.122-g489247679-dirty/kernel/drivers/usb/serial/ch343.ko
```

但是此时还是无法自动加载该驱动，尝试使用绝对路径加载内核模块，而不是仅使用模块名

```
insmod /lib/modules/4.14.122-g489247679-dirty/kernel/drivers/usb/serial/ch343.ko
```

加载成功如下，猜测可能是虽然能insmod加载，但是modules中没有ch343的配置信息（毕竟这个时候的系统还没有）：

```bash
root@ubuntu:~# lsmod
Module                  Size  Used by
ch343                  32768  0
xt_addrtype            16384  2
xt_conntrack           16384  1
rt2800usb              28672  0
rt2x00usb              24576  1 rt2800usb
rt2800lib             110592  1 rt2800usb
crc_ccitt              16384  1 rt2800lib
rt2x00lib              61440  3 rt2800usb,rt2x00usb,rt2800lib
mac80211              450560  3 rt2x00lib,rt2x00usb,rt2800lib
cfg80211              311296  2 rt2x00lib,mac80211
rfkill                 36864  3 cfg80211
crc32_ce               16384  1
cp210x                 24576  0
usbserial              36864  1 cp210x
crct10dif_ce           16384  0
```

/dev目录下部分信息如下，已经能识别到雷达和底层stm32板的串口了：

```bash
crw-rw----  1 root dialout 170,   0 Nov 27 06:14 ttyCH343USB0
crw-------  1 root tty       4,  64 Nov 27 06:10 ttyS0
crw-rw----  1 root dialout   4,  65 Mar  2  2023 ttyS1
crw-rw----  1 root dialout   4,  66 Mar  2  2023 ttyS2
crw-rw----  1 root dialout   4,  67 Mar  2  2023 ttyS3
crw-rw----  1 root dialout 188,   0 Mar  2  2023 ttyUSB0
```

