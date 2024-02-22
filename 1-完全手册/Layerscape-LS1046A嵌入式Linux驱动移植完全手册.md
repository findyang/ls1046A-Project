## 前提概要

>  ​	本手册仅介绍当搭建完环境后，针对NXP提供的LSDK源代码进行驱动移植，直至自研AMR控制器gie-ls1046所有的功能完全正常测试通过，并`不涉及`为什么这么修改，相关修改说明查看移植日志以及对应的某一个模块功能比如网口等对应的`驱动移植手册`。
>
> ​	本手册仅介绍硬件外设能驱动成功的移植，不涉及其他的附带驱动添加，比如USB仅介绍从未能识别设备到能识别设备并测试，并`不涉及`比如当前LSDK默认未启用的USB-serial，缺少的CH341源码如何移植。
>
> ​	板卡移植分为硬件方面和软件方面，当前手册仅涉及`软件`上的修改，默认使用的硬件板卡已经是修改好的。
>
> ​	在开始之前，建议先自行查看环境搭建手册。模块中涉及的其他操作比如编译、烧录、源码下载链接请查看对应的模块功能移植手册。



## 汇总需要适配及测试的外设

- 有线网口
  - RGMII
  - SGMII

- QPSI NOR FLASH

- PCIe无线wifi模块

- SATA固态硬盘
- 板载eMMC
- NAND FLASH
- USB type-c
- RS232
- SD卡接口





## 有线网口

uboot配置文件u-boot/configs/ls1046afrwy_tfa_defconfig中增加

```diff
+CONFIG_NET=y
CONFIG_PHY_VITESSE=y
+CONFIG_PHY_REALTEK=y
```

 net/eth-uclass.c以及net/eth_legacy.c增加，将第一次获取的MAC address保存到环境变量

```diff
net_random_ethaddr(dev->enetaddr);
		printf("\nWarning: %s (eth%d) using random MAC address - %pM\n",
		       dev->name, eth_number, dev->enetaddr);
+
+char tmp[50] = {'\n'};
+if (eth_number == 0){
+    sprintf(tmp, "setenv ethaddr %pM\n", dev->enetaddr);
+}
+else{
+    sprintf(tmp, "setenv eth%daddr %pM\n", eth_number, dev->enetaddr);
+=}
+run_command(tmp, 0);
+run_command("saveenv", 0);
#else
		printf("\nError: %s address not set.\n",
		       dev->name);
```

include/fm_eth.h上修改为自研板卡对应mdio地址

```diff
#ifdef CONFIG_SYS_FMAN_V3
#ifdef CONFIG_TARGET_LS1046AFRWY
-#define CONFIG_SYS_FM1_DTSEC_MDIO_ADDR	(CONFIG_SYS_FSL_FM1_ADDR + 0xfd000)
+#define CONFIG_SYS_FM1_DTSEC_MDIO_ADDR	(CONFIG_SYS_FSL_FM1_ADDR + 0xfc000)
#else
#define CONFIG_SYS_FM1_DTSEC_MDIO_ADDR	(CONFIG_SYS_FSL_FM1_ADDR + 0xfc000)
#endif
```

include/configs/ls1046afrwy.h上修改为自研板卡使用的PHY地址

```diff
-#define QSGMII_PORT1_PHY_ADDR		0x1c
-#define QSGMII_PORT2_PHY_ADDR		0x1d
-#define QSGMII_PORT3_PHY_ADDR		0x1e
-#define QSGMII_PORT4_PHY_ADDR		0x1f
+//add gie-ls1046a
+#define RGMII_PHY1_ADDR                        0x1
+#define RGMII_PHY2_ADDR                        0x2
+#define SGMII_PHY1_ADDR                        0x3
+#define SGMII_PHY2_ADDR                        0x4
+#define SGMII_PHY3_ADDR                        0x5
```

board/freescale/ls1046afrwy/eth.c上修改如下

```diff
	/* Register the 1G MDIO bus */
	fm_memac_mdio_init(bis, &dtsec_mdio_info);

	/* QSGMII on lane B, MAC 6/5/10/1 */
-	fm_info_set_phy_address(FM1_DTSEC6, QSGMII_PORT1_PHY_ADDR);
-	fm_info_set_phy_address(FM1_DTSEC5, QSGMII_PORT2_PHY_ADDR);
-	fm_info_set_phy_address(FM1_DTSEC10, QSGMII_PORT3_PHY_ADDR);
-	fm_info_set_phy_address(FM1_DTSEC1, QSGMII_PORT4_PHY_ADDR);

	switch (srds_s1) {
-	case 0x3040:
+	case 0x3333:
+		printf("****switch 0x3333****\n");
+		/* Set the two on-board RGMII PHY address */
+		fm_info_set_phy_address(FM1_DTSEC3, RGMII_PHY1_ADDR);
+		fm_info_set_phy_address(FM1_DTSEC4, RGMII_PHY2_ADDR);
+		/* Set the three on-board SGMII PHY address */
+		/* SGMII on slot 1, MAC 9/5/6, PHY address 3/4/5*/
+		fm_info_set_phy_address(FM1_DTSEC9, SGMII_PHY1_ADDR);
+		fm_info_set_phy_address(FM1_DTSEC5, SGMII_PHY2_ADDR);
+		fm_info_set_phy_address(FM1_DTSEC6, SGMII_PHY3_ADDR);
+
+		dev = miiphy_get_dev_by_name(DEFAULT_FM_MDIO_NAME);
+		fm_info_set_mdio(FM1_DTSEC3, dev);
+		fm_info_set_mdio(FM1_DTSEC4, dev);
+		fm_info_set_mdio(FM1_DTSEC9, dev);
+		fm_info_set_mdio(FM1_DTSEC5, dev);
+		fm_info_set_mdio(FM1_DTSEC6, dev);
		break;
	default:
		printf("Invalid SerDes protocol 0x%x for LS1046AFRWY\n",
		       srds_s1);
		break;
	}

-	dev = miiphy_get_dev_by_name(DEFAULT_FM_MDIO_NAME);
-	fm_info_set_mdio(FM1_DTSEC6, dev);
-	fm_info_set_mdio(FM1_DTSEC5, dev);
-	fm_info_set_mdio(FM1_DTSEC10, dev);
-	fm_info_set_mdio(FM1_DTSEC1, dev);

	cpu_eth_init(bis);
#endif

	return pci_eth_init(bis);
}
```

RCW源码中flexbuild_lsdk1906/packages/firmware/rcw/ls1046afrwy/RR_SSSSPPPH_3333_5559/rcw_1800_sdboot.rcw上配置SRDS_PLL_REF_CLK_SEL_S1为0

```
SRDS_PLL_REF_CLK_SEL_S1=0
```

完整的rcw_1800_sdboot.rcw如下：

```
/*
 * LS1046ARDB RCW for SerDes Protocol 0x1133_5559
 * Gie-LS1046A RCW for SerDes Protocol 0x3333_5559
 * 24G configuration -- 2 RGMII + two XFI + 2 SGMII + 3 PCIe + SATA
 * Gie：2 RGMII + 4 SGMII + 3 PCIe + SATA
 * Frequencies:
 *
 * Sys Clock: 100 MHz
 * DDR_Refclock: 100 MHz
 *
 * Core		-- 1800 MHz (Mul 18) 这个值由CGA_PLL1_RAT设置
 * Platform	-- 700 MHz (Mul 7) 
 * DDR		-- 2100 MT/s (Mul 21) 这个值由MEM_PLL_RAT设置
 * FMan		-- 800 MHz (CGA2 /2) 这个值由CGA_PLL2_RAT/2设置
 * XFI		-- 156.25 MHz (10.3125G)
 * SGMII	-- 100 MHz (5G)
 * PCIE		-- 100 MHz (5G)
 * eSDHC	-- 1400 MHz (CGA2 /1) 这个值由CGA_PLL2_RAT设置
 *
 * Hardware Accelerator Block Cluster Group A Mux Clock:
 *   FMan        - HWA_CGA_M1_CLK_SEL = 6 - Async mode, CGA PLL 2 /2 is clock
 *   eSDHC, QSPI - HWA_CGA_M2_CLK_SEL = 1 - Async mode, CGA PLL 2 /1 is clock
 *
 * Serdes Lanes vs Slot information
 *  Serdes1 Lane 0 (D) - XFI9, AQR107 PHY
 *  Serdes1 Lane 1 (C) - XFI10, SFP cage
 *  Serdes1 Lane 2 (B) - SGMII5, SGMII1 port
 *  Serdes1 Lane 3 (A) - SGMII6, SGMII2 port
 * Gie：Serdes Lanes vs Slot information
 *  Serdes1 Lane 0 (D) - SGMII9, SGMII1 port
 *  Serdes1 Lane 1 (C) - SGMII10, SGMII2 port
 *  Serdes1 Lane 2 (B) - SGMII5, SGMII3 port
 *  Serdes1 Lane 3 (A) - SGMII6, SGMII4 port
 *
 *  Serdes2 Lane 0 (A) - PCIe1 Gen3 x1, Slot 1, mPCIe
 *  Serdes2 Lane 1 (B) - PCIe2 Gen3 x1, Slot 2
 *  Serdes2 Lane 2 (C) - PCIe3 Gen3 x1, Slot 3
 *  Serdes2 Lane 3 (D) - SATA
 *
 * PLL mapping: 2211_2221
 * Gie：PLL mapping: 2222_2221
 *
 * Serdes 1:
 *  PLL mapping: 2211
 *
 *  SRDS_PLL_REF_CLK_SEL_S1 : 0b'01
 *  Gie：SRDS_PLL_REF_CLK_SEL_S1 : 0b'00
 *    SerDes 1, PLL1[160] : 0 - 100MHz for SGMII and PCIe
 *    SerDes 1, PLL2[161] : 1 - 156.25MHz for XFI
  *   Gie：SerDes 1, PLL2[161] : 0 - 100MHz for SGMII
 *  SRDS_PLL_PD_S1 : 0b'0
 *    SerDes 1, PLL1 : 0 - not power down
 *    SerDes 1, PLL2 : 0 - not poewr down
 *  HWA_CGA_M1_CLK_SEL[224-226] : 6 - Cluster Group A PLL 2 /2 to FMan
 *
 * Serdes 2:
 *  PLL mapping: 2221
 *  SRDS_PLL_REF_CLK_SEL_S2 : 0b'00
 *    SerDes 2, PLL1[162] : 0 - 100MHz for SATA
 *    SerDes 2, PLL2[163] : 0 - 100MHz for PCIe
 *  SRDS_PLL_PD_S2 : 0b'00
 *    SerDes 2, PLL1 : 0 - not power down
 *    SerDes 2, PLL2 : 0 - not poewr down
 *  SRDS_DIV_PEX_S2 : 0b'01
 *    00 - train up to max rate of 8G
 *    01 - train up to max rate of 5G
 *    10 - train up to max rate of 2.5G
 *
 * DDR clock:
 * DDR_REFCLK_SEL : 1 - DDRCLK pin provides the reference clock to the DDR PLL
 *
 */

 //以下是根据0x1133_5559修改得到的0x3333_5559

#include <../ls1046ardb/ls1046a.rcwi>

SYS_PLL_RAT=7
MEM_PLL_RAT=21
CGA_PLL1_RAT=18
CGA_PLL2_RAT=16
SRDS_PRTCL_S1=13107
SRDS_PRTCL_S2=21849
SRDS_PLL_REF_CLK_SEL_S1=0
SRDS_PLL_REF_CLK_SEL_S2=0
SRDS_DIV_PEX_S1=1
SRDS_DIV_PEX_S2=1
DDR_FDBK_MULT=2
DDR_REFCLK_SEL=1
PBI_SRC=6
IFC_MODE=64
HWA_CGA_M1_CLK_SEL=6
DRAM_LAT=1
SPI_EXT=1
UART_BASE=7
IFC_GRP_A_EXT=1
IFC_GRP_D_EXT=1
IFC_GRP_E1_EXT=1
IFC_GRP_F_EXT=1
EC1=0 //0代表配置成RGMII
EC2=0
IRQ_OUT=1
TVDD_VSEL=1
DVDD_VSEL=2
EVDD_VSEL=2
IIC2_EXT=1
SYSCLK_FREQ=600
HWA_CGA_M2_CLK_SEL=1
//IRQ_BASE=64 //设置使能GPIO1[25]，其他为0，IRQ[5]为1，即是001000000,16进制为64
IRQ_BASE=1
IRQ_EXT=0

.pbi
// set boot location ptr
write 0x570600, 0x00000000
write 0x570604, 0x10000000
.end

// Errta A-008850 for ddr controller for barrier transaction
#include <../ls1046ardb/cci_barrier_disable.rcw>
// Set USB PHY PLL for 100MHz
#include <../ls1046ardb/usb_phy_freq.rcw>
// Clear SerDes RxBoost on SD2 lane D
#include <../ls1046ardb/serdes_sata.rcw>
// Errata A-010477 and  A-008851 for PCI Express Gen3 link training
#include <../ls1046ardb/pex_gen3_link.rcw>
//#include <../ls1046ardb/a009531.rcw>

.pbi
// Software must wait after updating the ALTCBAR.
// Below is the PBL Wait command (0xc0)
write 0x6100c0, 0x000fffff
.end
```

自此，解决有线网口RGMII和SGMII的使能。

网口调试时间跨度大，详情查看类似ls1046驱动移植-12月.md等文档。



## PCIe无线wifi模块

待硬件解决完上电时序的问题后，参考手册Quectel_FC6xE_Third-Party_Linux_Platform_Wi-Fi_User_Guide_V1.pdf，位于DOC目录中，根据手册进行操作

### 一.  拷贝文件到内核头文件目录

1. 进入到fc6xe/WiFi目录中

2. 确认linux内核头文件net目录，当前如下

   ```shell
   /home/forlinx/nxp/flexbuild_lsdk1906/packages/linux/linux/include/net
   ```

3. 拷贝 *cnss2.h*, *qcn_sdio_al.h* and *cnss_utils.h* 到内核/include/net目录

   ```shell
   cp -r ./chss_host_LEA/chss_proc/host/AIO/drivers/core_tech_modules/cnss2/cnss2.h /home/forlinx/nxp/flexbuild_lsdk1906/packages/linux/linux/include/net
   ```

   ```shell
   cp -r ./chss_host_LEA/chss_proc/host/AIO/drivers/core_tech_modules/inc/qcn_sdio_al.h /home/forlinx/nxp/flexbuild_lsdk1906/packages/linux/linux/include/net
   ```

   ```shell
   cp -r ./chss_host_LEA/chss_proc/host/AIO/drivers/core_tech_modules/cnss_utils/cnss_utils.h /home/forlinx/nxp/flexbuild_lsdk1906/packages/linux/linux/include/net
   ```

### 二. 配置编译环境

1. 进入目录

   ```bash
   cd ./chss_host_LEA/chss_proc/host/AIO/build/scripts/ve-f10
   ```

2. 修改KERNELPATH, KERNELARCH, TOOLPREFIX

   ```bash
   vim config.ve-f10
   ```

   修改如下

   ```bash
   #export KERNELPATH=/lib/modules/${shell uname -r}/build
   export KERNELPATH=/home/forlinx/nxp/flexbuild_lsdk1906/build/linux/linux/arm64/LS/output/master
   #export TOOLCHAIN=/home/haotian/work/project/rtk/rtk_qca6390/RTK_SDK_0421/rtk_linuxSDK/output-a32hf/host/bin
   
   export KERNELARCH=arm64
   export CROSS_COMPILE=aarch64-linux-gnu-
   export TOOLPREFIX=${CROSS_COMPILE}
   ```

### 三. 移植适配

#### 3.1 wlan_cnss_core_pcie.ko

##### 3.1.1 wakeup_source_register

`fc6xe/WiFi/chss_host_LEA/chss_proc/host/AIO/drivers/core_tech_modules/./ipc_router/ipc_router_core.c`

这个主要是wakeup_source_register函数API变化引起的

大于内核4.14版本的使用wakeup_source_register(NULL, xprt->name);

否则使用wakeup_source_register(xprt->name);

##### 3.1.2 vfs_write

使用vfs_write的所有文件都是在大于5.4.0版本号的情况下才会使用kernel_write替代vfs_write，而当前使用的是4.14，所以使用vfs_write，但是vfs_write在4.14版本中已经无法使用了

`fc6xe/WiFi/chss_host_LEA/chss_proc/host/AIO/drivers/core_tech_modules/cnss2/pci.c`

`fc6xe/WiFi/chss_host_LEA/chss_proc/host/AIO/drivers/core_tech_modules/mhi/mhi_fw_dump.c`

```diff
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(5, 4, 0)
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(4, 14, 0)
#define vfs_write kernel_write
#endif
```

##### 3.1.3 驱动加载问题

```
识别设备后PCIe2: pcie@3600000 Root Complex: x1 gen2，装载驱动时遇到这个问题怎么解决
root@ubuntu:/home/gie/wlan/without-debug# insmod wlan_cnss_core_pcie.ko 
[  117.516414] [enable_bb_ctxt] 0x1000
[  117.520321] [enable_bb_ctxt] 0x1000
[  117.524195] cnss: Current L1SS status: 0x0
[  117.524201] cnss: Current ASPM status: 0x40
[  117.528334] cnss: Failed to get enough MSI vectors (32), available vectors = -28
[  117.554889] cnss: PCI device not probed yet
[  117.559173] IPC_RTR: ipc_router_mhi_xprt_deinit: mhi_xprt driver removed 0
[  117.583655] register platform driver failed, ret = -1
insmod: ERROR: could not insert module wlan_cnss_core_pcie.ko: Operation not permitted
其中dmesg中[   84.955399] cnss_pci: probe of 0002:01:00.0 failed with error -22
[   84.962879] cnss: PCI device not probed yet
[   84.967099] cnss: wlan en pin is not supported
```

其中cnss: wlan en pin is not supported是在cnss_get_wlan_en_pin函数中

```C
#ifdef CONFIG_NAPIER_X86
static int cnss_get_resources(struct cnss_plat_data *plat_priv)
{
	cnss_get_wlan_en_pin(plat_priv);

	return 0;
}
```

cnss_get_wlan_en_pin函数中部分内容如下：

```C
static int wlan_en_gpio_num = -1;
module_param(wlan_en_gpio_num, int, 0600);
MODULE_PARM_DESC(wlan_en_gpio_num, "Wlan en gpio number.");

int cnss_get_wlan_en_pin(struct cnss_plat_data *plat_priv)
{
	int ret;

	if (wlan_en_gpio_num < 0) {
		cnss_pr_dbg("wlan en pin is not supported\n");
		return 0;
	}
	......
}
```

> 咨询移远以上问题的解决方式：
>
> 在内核的.config文件中增加CONFIG_ONE_MSI_BUILD=y，然后回到wifi源码中重新编译
>
> （wifi源码编译时会去读取内核的.config文件获取相关宏）

#### 3.2 wlan.ko

##### 3.2.1 缺少WIPHY_FLAG_DFS_OFFLOAD

在当前的linux4.14下flexbuild_lsdk1906/packages/linux/linux/include/net/cfg80211.h中，确实没有WIPHY_FLAG_DFS_OFFLOAD			= BIT(11),

```diff
enum wiphy_flags {
	/* use hole at 0 */
	/* use hole at 1 */
	/* use hole at 2 */
	WIPHY_FLAG_NETNS_OK			= BIT(3),
	WIPHY_FLAG_PS_ON_BY_DEFAULT		= BIT(4),
	WIPHY_FLAG_4ADDR_AP			= BIT(5),
	WIPHY_FLAG_4ADDR_STATION		= BIT(6),
	WIPHY_FLAG_CONTROL_PORT_PROTOCOL	= BIT(7),
	WIPHY_FLAG_IBSS_RSN			= BIT(8),
	WIPHY_FLAG_MESH_AUTH			= BIT(10),
	/* use hole at 11 */
+	WIPHY_FLAG_DFS_OFFLOAD = BIT(11),
	/* use hole at 12 */
	WIPHY_FLAG_SUPPORTS_FW_ROAM		= BIT(13),
	WIPHY_FLAG_AP_UAPSD			= BIT(14),
	WIPHY_FLAG_SUPPORTS_TDLS		= BIT(15),
	WIPHY_FLAG_TDLS_EXTERNAL_SETUP		= BIT(16),
	WIPHY_FLAG_HAVE_AP_SME			= BIT(17),
	WIPHY_FLAG_REPORTS_OBSS			= BIT(18),
	WIPHY_FLAG_AP_PROBE_RESP_OFFLOAD	= BIT(19),
	WIPHY_FLAG_OFFCHAN_TX			= BIT(20),
	WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL	= BIT(21),
	WIPHY_FLAG_SUPPORTS_5_10_MHZ		= BIT(22),
	WIPHY_FLAG_HAS_CHANNEL_SWITCH		= BIT(23),
	WIPHY_FLAG_HAS_STATIC_WEP		= BIT(24),
};
```

##### 3.2.2 缺少文件subsystem_restart.h

移远回复如下：

> [Quectel]: 在内核中，关闭宏CONFIG_ARCH_QCOM

#### 3.3 解决CMA_SIZE太小的问题

咨询移远以上问题

> [Quectel]回复 : 
>
> 帮忙检查下CMA Size, 看上去是设置的太小了
> cat /proc/meminfo
>
> [gie] :
> forlinx@localhost:~$ cat /proc/meminfo | grep Cma
> CmaTotal:16384 kB
> CmaFree:15572 kB
>
> [Quectel]回复 : 
>
> 是这个问题，设置的太小了
>
> 需要在内核里设置CONFIG_CMA_SIZE_MBYTES

内核里设置CONFIG_CMA_SIZE_MBYTES，以下是make menuconfig查看的原本信息，当前CMA_SIZE_MBYTES为16，修改为64后重新编译内核

```
 Symbol: CMA_SIZE_MBYTES [=16]                                                                                                                                           │  
  │ Type  : integer                                                                                                                                                         │  
  │ Prompt: Size in Mega Bytes                                                                                                                                              │  
  │   Location:                                                                                                                                                             │  
  │     -> Device Drivers                                                                                                                                                   │  
  │       -> Generic Driver Options                                                                                                                                         │  
  │ (1)     -> DMA Contiguous Memory Allocator (DMA_CMA [=y])                                                                                                               │  
  │   Defined at drivers/base/Kconfig:285                                                                                                                                   │  
  │   Depends on: DMA_CMA [=y] && !CMA_SIZE_SEL_PERCENTAGE [=n] 
```

#### 3.4 最终输出

以下4部分：

Wi-Fi firmware bin 文件，qcom_cfg.ini，wlan_cnss_core_pcie.ko，wlan.ko

自此，解决wifi模块的使能。

调试详情查看`完全手册/ls1046a驱动移植-WIFI.md`



## USB type-c

待硬件陆续解决无法识别USB、只能使用USB2.0、USB type-c无法正反接问题后，软件上第三路USB最终解决修改如下，u-boot/board/freescale/ls1046afrwy/ls1046afrwy.c 第196行

```diff
#ifdef CONFIG_HAS_FSL_XHCI_USB
	struct ccsr_scfg *scfg = (struct ccsr_scfg *)CONFIG_SYS_FSL_SCFG_ADDR;
	u32 usb_pwrfault;
-out_be32(&scfg->rcwpmuxcr0, 0x3300);
+out_be32(&scfg->rcwpmuxcr0, 0x3333);
```

自此，完成USB的所有使能。

调试详情查看`完全手册/ls1046a驱动移植-USB.md`



## SATA固态硬盘

由于fsl-ls1046a.dtsi中status = "disabled";

```
sata: sata@3200000 {
    compatible = "fsl,ls1046a-ahci";
    /* ccsr sata base */
    /* ecc sata addr*/
    reg = <0x0 0x3200000 0x0 0x10000
           0x0 0x20140520 0x0 0x4>;
    reg-names = "sata-base", "ecc-addr";
    interrupts = <0 69 4>;
    clocks = <&clockgen 4 1>;
    status = "disabled";
};
```

在fsl-ls1046a-frwy.dts中增加以下代码来启用sata

```
&sata {
  status = "okay";
};
```

自此，完成固态硬盘的使能。



## RS232

软件/硬件无需修改，测试方案及结果查看`完全手册/ls1046验证slam方案之232通信.md`



## SD卡接口

软件无需修改



## QPSI NOR FLASH



## 板载eMMC



## NAND FLASH



