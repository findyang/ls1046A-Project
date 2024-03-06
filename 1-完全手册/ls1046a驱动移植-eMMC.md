### 板载eMMC

eMMC电路设计是直接参考ARDB的，参考的ARDB是SD卡和eMMC电平引脚切换，自研使用拨码进行切换，分析是否会影响识别情况。



> 飞凌ls1046上测试，从emmc启动，进入uboot终端，输入`mmc info`，显示emmc的7.3G实际容量，这时插入32G容量SD卡，执行`mmc rescan`重新扫描，再执行`mmc info`，此时能正常显示识别到SD卡，实际容量为28G。因此在飞凌板卡的硬件电路上，是能从emmc启动时，识别SD卡。

#### 飞凌板卡测试

| 飞凌板卡          | emmc启动         | SD卡启动           | nor flash启动      |
| ----------------- | ---------------- | ------------------ | ------------------ |
| emmc识别情况      | 正常识别         | 拔出SD卡后可以识别 | 拔出SD卡后可以识别 |
| SD卡识别情况      | 插入SD卡可以识别 | 正常识别           | 插入SD卡可以识别   |
| nor flash识别情况 | 正常识别         | 正常识别           | 正常识别           |

1. 从emmc/qpsi flash启动后，执行`mmc info`，显示为emmc的相关信息，接入SD卡，执行`mmc rescan`重新扫描，此时虽然能识别到SD卡的信息，但是mmc所有相关的指令，mmc list 、mmc info全部均只识别SD卡相关，拔出SD卡，重新rescan才可以识别emmc相关信息。同理，从SD卡启动时，也是如此，上电后只识别SD卡相关，拔出SD卡后才可以识别到emmc。

   ```
   => mmc list
   FSL_SDHC: 0 (SD)
   => mmc rescan
   => mmc list
   FSL_SDHC: 0 (eMMC)
   => mmc info
   Device: FSL_SDHC
   Manufacturer ID: d6
   OEM: 103
   Name: 88A39
   Bus Speed: 52000000
   Mode : MMC High Speed (52MHz)
   Rd Block Len: 512
   MMC version 5.1
   High Capacity: Yes
   Capacity: 7.3 GiB
   Bus Width: 4-bit
   Erase Group Size: 512 KiB
   HC WP Group Size: 4 MiB
   User Capacity: 7.3 GiB WRREL
   Boot Capacity: 4 MiB ENH
   RPMB Capacity: 4 MiB ENH
   => mmc rescan
   => mmc info
   Device: FSL_SDHC
   Manufacturer ID: 3
   OEM: 5344
   Name: SL16G
   Bus Speed: 50000000
   Mode : SD High Speed (50MHz)
   Rd Block Len: 512
   SD version 3.0
   High Capacity: Yes
   Capacity: 14.8 GiB
   Bus Width: 4-bit
   Erase Group Size: 512 Bytes
   ```

#### RDB板卡测试

| RDB板卡           | emmc启动         | SD卡启动       | nor flash启动  |
| ----------------- | ---------------- | -------------- | -------------- |
| emmc识别情况      | 正常识别         | 更换镜像后识别 | 更换镜像后识别 |
| SD卡识别情况      | 插入SD卡可以识别 | 正常识别       | 正常识别       |
| nor flash识别情况 | 正常识别         | 正常识别       | 正常识别       |

> 备注：当前寄过来的RDB板卡仅能从nor flash启动，SD卡能正常识别，但是无法从SD卡启动，SD卡里确认是存在系统镜像的。咨询NXP技术支持得知，寄过来的RDB板上的SD卡没有firmware镜像， 直接用RDB板带的SD卡确实是启动不了，需要重新烧录firmware镜像到SD卡才能启动。已经重新烧录firmware镜像到SD卡上，能正常启动，但是还是无法识别到eMMC。2024/02/29，确认NXP寄过来的板子上的镜像存在问题，RCW中`EVDD_VSEL`和`IIC2_EXT`这两个的值更改0，重新编译烧录镜像从nor flash/SD启动，能正常识别到eMMC模块了。
>
> 目前RDB板子正常可以通过拨动拨码来从eMMC启动，还有另一种从eMMC启动步骤：
>
> 1. 不接SD卡
>
> 2. 从qpsi flash启动到uboot
>
> 3. 执行cpld reset sd
>
> 从eMMC启动能正常识别信息，接入SD卡执行mmc rescan后能正常识别到SD卡



> 从RDB的原理图上看：
>
> 1. 对于SD/eMMC复用情况
>
> If SDCARD (SDHC_CD_B=0):
>
> \- MUX = SDCARD
>
> \- EVDD=3.3V, SW control
>
> If no SDCARD (SDHC_CD_B=1):
>
> \- MUX = EMMC
>
> \- EVDD = 1.8V fixed.
>
> 2. 对于SD/eMMC时钟等选择情况
>
> 由CPLD模块输出的SD_eMMC_SEL信号来选择当前是使用SD_CLK/SD_CMD还是eMMC_CLK/eMMC_CMD

1. SDHC_CD_B是SD卡检测引脚，这里的意思是：

当板卡检测到存在SD卡接入时，SDHC_CD_B为低电平，此时复用为SDCARD功能；

当板卡检测到没有SD卡接入时，SDHC_CD_B为高电平，此时复用为EMMC功能；

之前解决SD识别功能的时候，是直接把SDHC_CD_B这个引脚直接接到地线，但是现在需要使用这个功能，因此不能直接接到地线，交由硬件成员解决，先恢复SDHC_CD_B的连接，然后飞线将原本需要的地线接好。

2. 对于自研板，硬件设计上没有使用CPLD模块，当前的SD_eMMC_SEL信号是由拨码开关来改变，即是说RDB拔出SD卡时，能自动切换到eMMC，但是自研板还需要手动拨动一下拨码开关。

自研板进行测试，拔出SD卡，重新扫描已经不再SD卡或者eMMC的信息

```
=> mmc rescan
=> mmc info
=> mmc list
FSL_SDHC: 0
```

手动拨动拨码开关再测试，没有预想中能识别到eMMC

```
=> mmc info
MMC: no card present
=> mmc rescan
MMC: no card present
```

报错来源于u-boot/drivers/mmc/mmc.c

```
int mmc_start_init(struct mmc *mmc)
{
	bool no_card;
	int err = 0;

	/*
	 * all hosts are capable of 1 bit bus-width and able to use the legacy
	 * timings.
	 */
	mmc->host_caps = mmc->cfg->host_caps | MMC_CAP(SD_LEGACY) |
			 MMC_CAP(MMC_LEGACY) | MMC_MODE_1BIT;

#if !defined(CONFIG_MMC_BROKEN_CD)
	/* we pretend there's no card when init is NULL */
	no_card = mmc_getcd(mmc) == 0;
#else
	no_card = 0;
#endif
#if !CONFIG_IS_ENABLED(DM_MMC)
	no_card = no_card || (mmc->cfg->ops->init == NULL);
#endif
	if (no_card) {
		mmc->has_init = 0;
#if !defined(CONFIG_SPL_BUILD) || defined(CONFIG_SPL_LIBCOMMON_SUPPORT)
		pr_err("MMC: no card present\n");
#endif
		return -ENOMEDIUM;
	}

	err = mmc_get_op_cond(mmc);

	if (!err)
		mmc->init_in_progress = 1;

	return err;
}
```

以当前的报错往回分析，do_mmcinfo函数中的init_mmc_device函数返回值为NULL，mmc_start_init返回非零值，mmc_getcd(mmc) == 0;这个表达式为真。

[Linux/AM3352: eMMC boot issue - Processors forum - Processors - TI E2E support forums](https://e2e.ti.com/support/processors-group/processors/f/processors-forum/662382/linux-am3352-emmc-boot-issue)

这里类似的报错解决方案是禁用CONFIG_DM_MMC ，但是应该是不对的，RDB上也是有这个宏的，涉及代码如下：

```
#if !CONFIG_IS_ENABLED(DM_MMC)
	no_card = no_card || (mmc->cfg->ops->init == NULL);
```

不过根据飞凌的配置文件里确是去掉了CONFIG_DM_MMC ，这个应该是跟板卡设计思路相关，可惜飞凌uboot闭源，查看不到更多的信息。

[Solved: 自己开发的i.mx8mp基板无法烧写eMMC - NXP Community](https://community.nxp.com/t5/i-MX-Processors/自己开发的i-mx8mp基板无法烧写eMMC/m-p/1608921)

以上测试失败

用飞凌的板卡测试一下，拔出SD卡时，no_card的值是多少，如果这个变量只涉及到SD卡，不涉及emmc，那么拔出SD卡时，根据代码分析，进行初始化时，必然是输出MMC: no card present，但是飞凌板卡之前测试时不是。

2024/02/29，确认NXP寄过来的板子上的镜像存在问题，RCW中`EVDD_VSEL`和`IIC2_EXT`这两个的值更改0，重新编译烧录镜像从nor flash/SD启动，能正常识别到eMMC模块了。

##### cpld分析

RDB板子执行cpld reset sd，能从nor flash切换到sd/eMMC启动，但是我们自研的板子没有cpld，原本以为只有硬件设计上的差异，现在看来还需要看下RDB使用cpld还做了什么。

```
void cpld_set_sd(void)
{
	u16 reg = CPLD_CFG_RCW_SRC_SD;
	u8 reg5 = (u8)(reg >> 1);
	u8 reg6 = (u8)(reg & 1);

	cpld_rev_bit(&reg5);

	CPLD_WRITE(soft_mux_on, 1);

	CPLD_WRITE(cfg_rcw_src1, reg5);
	CPLD_WRITE(cfg_rcw_src2, reg6);

	CPLD_WRITE(system_rst, 1);
}
void cpld_rev_bit(unsigned char *value)
{
	u8 rev_val, val;
	int i;

	val = *value;
	rev_val = val & 1;
	for (i = 1; i <= 7; i++) {
		val >>= 1;
		rev_val <<= 1;
		rev_val |= val & 1;
	}

	*value = rev_val;
}
```

其中CPLD_CFG_RCW_SRC_SD为0x040

1. `CPLD_CFG_RCW_SRC_SD`为`0x040`，即十进制的64。
2. 将`reg`右移1位并截取低8位，即`(64 >> 1) & 0xFF`，结果为`32 & 0xFF`，即`32`。
3. 将`reg`与1进行按位与操作并截取低8位，即`(64 & 1) & 0xFF`，结果为`0 & 0xFF`，即`0`。

因为这里即是改变了cfg_rcw_src1为0x32，cfg_rcw_src2为0，0x32即是00100000，这个值是sd/eMMC的启动方式。

```
=> cpld dump
cpld_ver        = 2
cpld_ver_sub    = 3
pcba_ver        = 2
soft_mux_on     = 0
cfg_rcw_src1    = 4
cfg_rcw_src2    = 0
vbank           = 0
sysclk_sel      = 0
uart_sel        = 0
sd1refclk_sel   = 1
rgmii_1588_sel  = 1
1588_clk_sel    = 0
status_led      = 0
sd_emmc         = 0
vdd_en          = 0
vdd_sel         = 0
```

当vdd_sel         = 1时，SD卡启动异常；

当vdd_sel         = 0时，SD卡正常启动。

但是当进入系统后，设置vdd_sel 并不会引起SD/eMMC读取异常，还是正常信息

#### 自研AMR测试

参考RDB板卡测试中将RCW中`EVDD_VSEL`和`IIC2_EXT`这两个的值更改0，重新编译烧录镜像从nor flash/SD启动，还是不能正常识别到eMMC模块了，这里应该还是电路设计不一样的问题。

EVDD电压连接不对，硬件飞线到3.3v，重新烧录镜像启动，已经能够识别了，并且经过测试`EVDD_VSEL`和`IIC2_EXT`不相关，两种配置均能识别，因此不需要改动rcw。

```
=> mmc list
FSL_SDHC: 0 (SD)
=> mmc info
Device: FSL_SDHC
Manufacturer ID: 3
OEM: 5344
Name: SL64G
Bus Speed: 50000000
Mode : SD High Speed (50MHz)
Rd Block Len: 512
SD version 3.0
High Capacity: Yes
Capacity: 59.5 GiB
Bus Width: 4-bit
Erase Group Size: 512 Bytes
=> mmc rescan
=> mmc info
Device: FSL_SDHC
Manufacturer ID: 13
OEM: 14e
Name: Q2J54
Bus Speed: 52000000
Mode : MMC High Speed (52MHz)
Rd Block Len: 512
MMC version 5.0
High Capacity: Yes
Capacity: 3.6 GiB
Bus Width: 4-bit
Erase Group Size: 512 KiB
HC WP Group Size: 8 MiB
User Capacity: 3.6 GiB WRREL
Boot Capacity: 16 MiB ENH
RPMB Capacity: 512 KiB ENH
```

2024.3.1完成识别，接下来把eMMC的镜像编译烧录后，进行启动测试