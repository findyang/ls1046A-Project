## mii命令

```shell
=> mii
mii - MII utility commands

Usage:
mii device                            - list available devices
mii device <devname>                  - set current device
mii info   <addr>                     - display MII PHY info
mii read   <addr> <reg>               - read  MII PHY <addr> register <reg>
mii write  <addr> <reg> <data>        - write MII PHY <addr> register <reg>
mii modify <addr> <reg> <data> <mask> - modify MII PHY <addr> register <reg>
                                        updating bits identified in <mask>
mii dump   <addr> <reg>               - pretty-print <addr> <reg> (0-5 only)
Addr and/or reg may be ranges, e.g. 2-7.
```

mii命令是操作mii接口的命令，mii接口用来连接soc中的MAC控制器和外部的PHY芯片。

MAC与PHY参考链接：https://www.cnblogs.com/try-again/p/9179103.html

mii命令主要是通过mii接口中的MDIO来读写phy芯片的寄存器

针对DP83867芯片

mii info //查看mii信息

mii write 0x0c 0x00 0x2100 //设置phy芯片为百兆，0x0c为phy芯片地址，0x00为phy芯片寄存器地址，0x2100为向0x00寄存器写入的值

mii read 0x0c 0x00 //读取phy芯片0x00寄存器的值

寄存器地址>0x1F的配置方法，因为MDIO最多能范围的寄存器范围为0~0x1F，如果寄存器地址>0x1F那么需要通过0x0d和0x0e这两个寄存器间接访问

读0x31寄存器
mii write 0x0c 0x0d 0x1f
mii write 0x0c 0x0e 0x31
mii write 0x0c 0x0d 0x401f
mii read 0x0c 0x0e

写0x31寄存器
mii write 0x0c 0x0d 0x1f
mii write 0x0c 0x0e 0x31
mii write 0x0c 0x0d 0x401f
mii write 0x0c 0x0e 0x1031 //向0x31寄存器写入0x1031

[RTL8211F在uboot下使用mii工具配置RJ45网口灯详解。首先要明确使用这个工具的目的，类似于i2c-test工具测试i2c,使用这个工具验证测试网口灯的配置。然后再通过软件或者驱动来实-CSDN博客](https://blog.csdn.net/qq_42608012/article/details/128633417)



[详细讲解u-boot之网络移植与调试_uboot 网络_Sunshine-Linux的博客-CSDN博客](https://blog.csdn.net/Wang_XB_3434/article/details/130817581)



寄存器值的解析

```
=> mii dump 0x1c 0
0.     (1040)                 -- PHY control register --
  (8000:0000) 0.15    =     0    reset
  (4000:0000) 0.14    =     0    loopback
  (2040:0040) 0. 6,13 =   b10    speed selection = 1000 Mbps
  (1000:1000) 0.12    =     1    A/N enable
  (0800:0000) 0.11    =     0    power-down
  (0400:0000) 0.10    =     0    isolate
  (0200:0000) 0. 9    =     0    restart A/N
  (0100:0000) 0. 8    =     0    duplex = half
  (0080:0000) 0. 7    =     0    collision test enable
  (003f:0000) 0. 5- 0 =     0    (reserved)
=> mii read 0x1c 0
1040
```

查看rtl8211fs手册，第8.5章，寄存器表

BMCR （Basic Mode Control Register, Address 0x00）是第0位寄存器地址，一共为16位bit，0-15bit组合成16进制数，上述可知，0x1C是一块PHY芯片的地址，它的第0个寄存器的值为1040，1040是由16位bit组合而来，由上可知是，0001000001000000 = 0x1040其中每一位bit都有对应的作用，具体作用看手册，比方说0.15就是reset复位的信息，它目前的值为0，根据手册描述，它的值为1的时候是复位，0是正常操作，然后复位结束后，这位bit会变回默认值，也就是0。要写入1进行复位的话，1001000001000000 = 0x9040，

即是命令：mii write 0x1c 0 0x9040

再看一个

```
=> mii dump 0x1c 1
1.     (7949)                 -- PHY status register --
  (8000:0000) 1.15    =     0    100BASE-T4 able
  (4000:4000) 1.14    =     1    100BASE-X  full duplex able
  (2000:2000) 1.13    =     1    100BASE-X  half duplex able
  (1000:1000) 1.12    =     1    10 Mbps    full duplex able
  (0800:0800) 1.11    =     1    10 Mbps    half duplex able
  (0400:0000) 1.10    =     0    100BASE-T2 full duplex able
  (0200:0000) 1. 9    =     0    100BASE-T2 half duplex able
  (0100:0100) 1. 8    =     1    extended status
  (0080:0000) 1. 7    =     0    (reserved)
  (0040:0040) 1. 6    =     1    MF preamble suppression
  (0020:0000) 1. 5    =     0    A/N complete
  (0010:0000) 1. 4    =     0    remote fault
  (0008:0008) 1. 3    =     1    A/N able
  (0004:0000) 1. 2    =     0    link status
  (0002:0000) 1. 1    =     0    jabber detect
  (0001:0001) 1. 0    =     1    extended capabilities
=> mii read 0x1c 1
7949
```

分析同上

0111 011001110000



## fat文件系统操作命令

### fatls 查看文件命令

fatls命令如下所示：

fatls mmc 0:1：查看emmc第一分区的内容，0表示哪个mmc设备，这里是emmc，1表示第一分区

可以看到emmc的第一分区中有三个文件

### fatrm 删除文件命令

fatrm mmc 0:1 image.ub：删除emmc第一分区中的image.ub

### fatwite 写文件

fatwrite mmc 0:1 0x10000000 image.ub 0x7d1160，从内存拷贝Image.ub到emmc第一分区中，0x10000000 表示内存拷贝的起始地址，image.ub是文件名，0x7d1160是拷贝的长度



