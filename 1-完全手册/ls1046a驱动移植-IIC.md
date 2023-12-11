IIC改动不大，只是更换了一些IIC设备，应该改下设备地址和设备树的compatible即可，还有其他内容再补充。



原本的demoA的i2c0节点如下：

```
&i2c0 {
	status = "okay";

	i2c-mux@77 {
		compatible = "nxp,pca9546";
		reg = <0x77>;
		#address-cells = <1>;
		#size-cells = <0>;
		i2c-mux-never-disable;

		i2c@0 {
			#address-cells = <1>;
			#size-cells = <0>;
			reg = <0>;

			eeprom@52 {
				compatible = "atmel,24c512";
				reg = <0x52>;
			};

			eeprom@53 {
				compatible = "atmel,24c512";
				reg = <0x53>;
			};

			power-monitor@40 {
				compatible = "ti,ina220";
				reg = <0x40>;
				shunt-resistor = <1000>;
			};

			rtc@51 {
				compatible = "nxp,pcf2129";
				reg = <0x51>;
			};

			temperature-sensor@4c {
				compatible = "nxp,sa56004";
				reg = <0x4c>;
				vcc-supply = <&sb_3v3>;
				compatible = "adi,adt7461";
				reg = <0x4c>;
			};

		};
	};
};
```

| i2c0（IIC1） | 自研1046                       | demoA                        |
| ------------ | ------------------------------ | ---------------------------- |
| 挂载1        | PF8100（PMIC模块）             | PF8100（PMIC模块）           |
| 挂载2        | INA220AIDGST（1V电流检测IC）   | INA220AIDGST（1V电流检测IC） |
| 挂载3        | 6V49205BNLGI_QFN（时钟管理IC） | PCF2129AT（RTC）             |
| 挂载4        | ADT7461（温度模块）            | SA56004ED（温度模块）        |

> 注意：PMIC模块PF8100使用的设备地址为0x08：The device uses a fixed I2C device address (0x08)
>
> 不过PF8100没有在设备树中体现节点
>
> 6V49205BNLGI_QFN是时钟管理模块（设备地址为69），PCF2129AT是RTC模块，自研没有RTC模块
>
> INA220AIDGST设备地址0x40，ADT7461（温度检测）和SA56004ED（温度检测）都是0x4c

```
root@ubuntu:~# i2cdetect -y 0
     0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f
00:          -- -- -- -- -- 08 -- -- -- -- -- -- --
10: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
20: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
30: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
40: 40 -- -- -- -- -- -- -- -- -- -- -- 4c -- -- --
50: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
60: -- -- -- -- -- -- -- -- -- 69 -- -- -- -- -- --
70: -- -- -- -- -- -- -- --
```

```
cd /sys/class/i2c-adapter/i2c-0/0-0077/of_node/i2c@0/
```

```
root@ubuntu:/sys/class/i2c-adapter/i2c-0/0-0077/of_node/i2c@0# cat temperature-sensor@4c
adi,adt7461
```

从上面来看，温度模块已经修改为自研使用的adt7461（注意这个是外部的IIC模块与下方的SoC内部的温度模块无关）

但是一直无法检测温度，无论使用lm_sensors（一款基于linux系统的硬件监控的软件）还是直接查看cpu温度都是失败的。

实际上sensors命令只是读取了/sys/class/hwmon/目录下关于CPU等传感器温度参数并直观的展示给我们，我们不安装lm_sensors模块下也可以查看CPU温度。

正常的情况应该如下：

```
root@localhost:~# cat /sys/class/thermal/thermal_zone0/temp //查看 sensor3 的当前温度
41000 //当前温度传感器实测数值为 41 摄氏度
```

但是现在的情况是：

```
root@ubuntu:~# cat /sys/class/thermal/thermal_zone0/temp
cat: /sys/class/thermal/thermal_zone0/temp: Invalid argument
root@ubuntu:~# sensors
No sensors found!
Make sure you loaded all the kernel drivers you need.
Try sensors-detect to find out which these are.
root@ubuntu:~# sensors-detect
# sensors-detect revision 6284 (2015-05-31 14:00:33 +0200)
# DMI data unavailable, please consider installing dmidecode 2.7
# or later for better results.
# Kernel: 4.14.122-g4c22bf6bf-dirty aarch64
# Processor:  (//)

This program will help you determine which kernel modules you need
to load to use lm_sensors most effectively. It is generally safe
and recommended to accept the default answers to all questions,
unless you know what you're doing.

Some south bridges, CPUs or memory controllers contain embedded sensors.
Do you want to scan for them? This is totally safe. (YES/no): yes
modprobe: FATAL: Module cpuid not found in directory /lib/modules/4.14.122-g4c22bf6bf-dirty
Failed to load module cpuid.
Silicon Integrated Systems SIS5595...                       No
VIA VT82C686 Integrated Sensors...                          No
VIA VT8231 Integrated Sensors...                            No
AMD K8 thermal sensors...                                   No
AMD Family 10h thermal sensors...                           No
AMD Family 11h thermal sensors...                           No
AMD Family 12h and 14h thermal sensors...                   No
AMD Family 15h thermal sensors...                           No
AMD Family 16h thermal sensors...                           No
AMD Family 15h power sensors...                             No
AMD Family 16h power sensors...                             No
Intel digital thermal sensor...                             No
Intel AMB FB-DIMM thermal sensor...                         No
Intel 5500/5520/X58 thermal sensor...                       No
VIA C7 thermal sensor...                                    No
VIA Nano thermal sensor...                                  No
```

难道没有默认没有配置SOC内部传感器的驱动吗？

```
Make sure you loaded all the kernel drivers you need.
```

飞凌ls1046上查找cpuid驱动相关

```
root@ubuntu:/home/forlinx/nxp/flexbuild_lsdk1906/build/rfs# sudo find /home/forlinx/work/OK10xx-linux-fs/flexbuild/* -name cpuid*
/home/forlinx/work/OK10xx-linux-fs/flexbuild/build/rfs/OK10xx-linux-ubuntu/rootfs_ubuntu_bionic_arm64/usr/share/man/man4/cpuid.4.gz
/home/forlinx/work/OK10xx-linux-fs/flexbuild/build/linux/linux/arm64/output/include/config/arm/cpuidle.h
/home/forlinx/work/OK10xx-linux-fs/flexbuild/build/linux/linux/arm64/output/arch/arm64/kernel/cpuidle.o
/home/forlinx/work/OK10xx-linux-fs/flexbuild/build/linux/linux/arm64/output/drivers/cpuidle
/home/forlinx/work/OK10xx-linux-fs/flexbuild/build/linux/linux/arm64/output/drivers/cpuidle/cpuidle.o
/home/forlinx/work/OK10xx-linux-fs/flexbuild/build/linux/linux/arm64/output/drivers/cpuidle/cpuidle-arm.o
```









