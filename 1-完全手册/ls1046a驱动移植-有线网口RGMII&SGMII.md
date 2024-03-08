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