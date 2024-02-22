### 2023/11/17

> 联系移远的人提供源码
>
> WiFi的驱动登录网站：https://git-master.quectel.com/
>
> 账号：sunensi@126.com
>
> 密码：12345678
>
> 配置ssh然后下载



参考手册Quectel_FC6xE_Third-Party_Linux_Platform_Wi-Fi_User_Guide_V1.pdf，位于DOC目录中

根据手册进行操作

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



### 二.  下载和应用Linux内核补丁

貌似这个是给主机ubuntu平台使用的，主要是安装其他的内核版本比如4.9、5.4、5.10之类的，然后重启配置双内核，再将头文件拷贝到内核目录进行编译

由于使用交叉编译，暂时不做这个步骤



### 三. 配置编译环境

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



### 四. 编译Wi-Fi Driver

最终输出为4部分：

Wi-Fi firmware bin 文件，qcom_cfg.ini，wlan_cnss_core_pcie.ko，wlan.ko

开始构建

1. 进入构建目录

   ```bash
   cd ./chss_host_LEA/chss_proc/host/AIO/build
   ```

2. 编译wlan_cnss_core_pcie.ko


报错如下：

```bash
/home/forlinx/wifi/fc6xe/WiFi/chss_host_LEA/chss_proc/host/AIO/drivers/core_tech_modules/./ipc_router/ipc_router_core.c: In function ‘msm_ipc_router_create_raw_port’:
/home/forlinx/wifi/fc6xe/WiFi/chss_host_LEA/chss_proc/host/AIO/drivers/core_tech_modules/./ipc_router/ipc_router_core.c:1359:25: error: too many arguments to function ‘wakeup_source_register’
  port_ptr->port_rx_ws = wakeup_source_register(NULL, port_ptr->rx_ws_name);
                         ^~~~~~~~~~~~~~~~~~~~~~
In file included from /home/forlinx/nxp/flexbuild_lsdk1906/packages/linux/linux/include/linux/device.h:984:0,
                 from /home/forlinx/nxp/flexbuild_lsdk1906/packages/linux/linux/include/linux/platform_device.h:14,
                 from /home/forlinx/wifi/fc6xe/WiFi/chss_host_LEA/chss_proc/host/AIO/drivers/core_tech_modules/./ipc_router/ipc_router_core.c:25:
/home/forlinx/nxp/flexbuild_lsdk1906/packages/linux/linux/include/linux/pm_wakeup.h:98:30: note: declared here
 extern struct wakeup_source *wakeup_source_register(const char *name);
                              ^~~~~~~~~~~~~~~~~~~~~~
/home/forlinx/wifi/fc6xe/WiFi/chss_host_LEA/chss_proc/host/AIO/drivers/core_tech_modules/./ipc_router/ipc_router_core.c: In function ‘msm_ipc_router_add_xprt’:
/home/forlinx/wifi/fc6xe/WiFi/chss_host_LEA/chss_proc/host/AIO/drivers/core_tech_modules/./ipc_router/ipc_router_core.c:4128:18: error: too many arguments to function ‘wakeup_source_register’
  xprt_info->ws = wakeup_source_register(NULL, xprt->name);
                  ^~~~~~~~~~~~~~~~~~~~~~
In file included from /home/forlinx/nxp/flexbuild_lsdk1906/packages/linux/linux/include/linux/device.h:984:0,
                 from /home/forlinx/nxp/flexbuild_lsdk1906/packages/linux/linux/include/linux/platform_device.h:14,
                 from /home/forlinx/wifi/fc6xe/WiFi/chss_host_LEA/chss_proc/host/AIO/drivers/core_tech_modules/./ipc_router/ipc_router_core.c:25:
/home/forlinx/nxp/flexbuild_lsdk1906/packages/linux/linux/include/linux/pm_wakeup.h:98:30: note: declared here
 extern struct wakeup_source *wakeup_source_register(const char *name);
                              ^~~~~~~~~~~~~~~~~~~~~~
```

先试下将NULL删除再编译

这个主要是wakeup_source_register函数API变化引起的

大于内核4.14版本的使用wakeup_source_register(NULL, xprt->name);

否则使用wakeup_source_register(xprt->name);

但是可能提供源码是供4.9使用的，编译完成如下（不清楚使用是否存在问题）：

```bash
LD [M]  /home/forlinx/wifi/fc6xe/WiFi/chss_host_LEA/chss_proc/host/AIO/drivers/core_tech_modules/wlan_cnss_core_pcie.o
  Building modules, stage 2.
  MODPOST 1 modules
WARNING: "vfs_write" [/home/forlinx/wifi/fc6xe/WiFi/chss_host_LEA/chss_proc/host/AIO/drivers/core_tech_modules/wlan_cnss_core_pcie.ko] undefined!
  CC      /home/forlinx/wifi/fc6xe/WiFi/chss_host_LEA/chss_proc/host/AIO/drivers/core_tech_modules/wlan_cnss_core_pcie.mod.o
  LD [M]  /home/forlinx/wifi/fc6xe/WiFi/chss_host_LEA/chss_proc/host/AIO/drivers/core_tech_modules/wlan_cnss_core_pcie.ko
```

编译wlan.ko报错如下

```bash
/home/forlinx/wifi/fc6xe/WiFi/chss_host_LEA/chss_proc/host/AIO/build/../drivers/qcacld-3.0/core/hdd/src/wlan_hdd_cfg80211.c: In function ‘__is_driver_dfs_capable’:
/home/forlinx/wifi/fc6xe/WiFi/chss_host_LEA/chss_proc/host/AIO/build/../drivers/qcacld-3.0/core/hdd/src/wlan_hdd_cfg80211.c:1733:37: error: ‘WIPHY_FLAG_DFS_OFFLOAD’ undeclared (first use in this function); did you mean ‘WIPHY_FLAG_AP_UAPSD’?
  dfs_capability = !!(wiphy->flags & WIPHY_FLAG_DFS_OFFLOAD);
                                     ^~~~~~~~~~~~~~~~~~~~~~
                                     WIPHY_FLAG_AP_UAPSD
/home/forlinx/wifi/fc6xe/WiFi/chss_host_LEA/chss_proc/host/AIO/build/../drivers/qcacld-3.0/core/hdd/src/wlan_hdd_cfg80211.c:1733:37: note: each undeclared identifier is reported only once for each function it appears in
/home/forlinx/wifi/fc6xe/WiFi/chss_host_LEA/chss_proc/host/AIO/build/../drivers/qcacld-3.0/core/hdd/src/wlan_hdd_cfg80211.c: In function ‘wlan_hdd_cfg80211_set_dfs_offload_feature’:
/home/forlinx/wifi/fc6xe/WiFi/chss_host_LEA/chss_proc/host/AIO/build/../drivers/qcacld-3.0/core/hdd/src/wlan_hdd_cfg80211.c:16069:18: error: ‘WIPHY_FLAG_DFS_OFFLOAD’ undeclared (first use in this function); did you mean ‘WIPHY_FLAG_AP_UAPSD’?
  wiphy->flags |= WIPHY_FLAG_DFS_OFFLOAD;
                  ^~~~~~~~~~~~~~~~~~~~~~
                  WIPHY_FLAG_AP_UAPSD
```

[[PATCH\] cfg80211/nl80211: add DFS offload flag (kernel.org)](https://lkml.kernel.org/linux-wireless/87r2p6hlkw.fsf@codeaurora.org/T/)

在当前的linux4.14下/home/forlinx/nxp/flexbuild_lsdk1906/packages/linux/linux/include/net/cfg80211.h中

```c
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

确实没有WIPHY_FLAG_DFS_OFFLOAD			= BIT(11),

参考上面链接手动新增试试

```
AR      /home/forlinx/wifi/fc6xe/WiFi/chss_host_LEA/chss_proc/host/AIO/build/../drivers/qcacld-3.0/built-in.o
  CC [M]  /home/forlinx/wifi/fc6xe/WiFi/chss_host_LEA/chss_proc/host/AIO/build/../drivers/qcacld-3.0/core/hdd/src/wlan_hdd_assoc.o
  CC [M]  /home/forlinx/wifi/fc6xe/WiFi/chss_host_LEA/chss_proc/host/AIO/build/../drivers/qcacld-3.0/core/hdd/src/wlan_hdd_cfg.o
  CC [M]  /home/forlinx/wifi/fc6xe/WiFi/chss_host_LEA/chss_proc/host/AIO/build/../drivers/qcacld-3.0/core/hdd/src/wlan_hdd_cfg80211.o
```

ok，上面的错误已经解决，下面是新的问题，缺少文件

```
/home/forlinx/wifi/fc6xe/WiFi/chss_host_LEA/chss_proc/host/AIO/build/../drivers/qcacld-3.0/core/hdd/src/wlan_hdd_main.c:92:10: fatal error: soc/qcom/subsystem_restart.h: No such file or directory
 #include <soc/qcom/subsystem_restart.h>
```

在编译主机上搜索，确实没有这个文件

```
root@ubuntu:/home/forlinx/wifi/fc6xe/WiFi# find ./* -name subsystem_restart.h
root@ubuntu:/home/forlinx/wifi/fc6xe/WiFi# find /* -name subsystem_restart.h
find: ‘/run/user/1000/gvfs’: Permission denied
```

[nxp-qoriq/linux: Linux Tree for QorIQ support (github.com)](https://github.com/nxp-qoriq/linux/tree/lf-6.1.y)

在nxp最新的linux内核代码中也没有找到该文件，说明这个文件不是内核原本自带的

在wifi源码查看，这个文件是定义了这个MSM_PLATFORM宏才会包含，这个宏是高通平台常用缩写 高通的MSM是mobile station modems，先==暂时注释看下会不会其他的报错，看情况再回来解决==，因为网上搜索这个文件都是安卓系统的内核源码中出现

```c
#ifdef MSM_PLATFORM
#include <soc/qcom/subsystem_restart.h>
#endif
```

好了，现在报了新的错误，不清楚是不是上面缺少的文件带来的问题，在代码中使用了一个未声明的函数`cfg80211_ap_stopped`，并且当前的报错全都是wlan_hdd_main.c中的

```
/home/forlinx/wifi/fc6xe/WiFi/chss_host_LEA/chss_proc/host/AIO/build/../drivers/qcacld-3.0/core/hdd/src/wlan_hdd_main.c: In function ‘hdd_stop_p2p_go’:
/home/forlinx/wifi/fc6xe/WiFi/chss_host_LEA/chss_proc/host/AIO/build/../drivers/qcacld-3.0/core/hdd/src/wlan_hdd_main.c:8456:2: error: implicit declaration of function ‘cfg80211_ap_stopped’; did you mean ‘cfg80211_roamed’? [-Werror=implicit-function-declaration]
  cfg80211_ap_stopped(adapter->dev, GFP_KERNEL);
```

在linux内核源码上根本搜索不到这个函数cfg80211_ap_stopped

wlan_hdd_main.c这个文件又是在安卓代码上找到的，难道默认编译会编译安卓平台的吗？

[drivers/staging/qcacld-3.0/core/hdd/src/wlan_hdd_main.c - kernel/msm - Git at Google (googlesource.com)](https://android.googlesource.com/kernel/msm/+/android-msm-wahoo-4.4-oreo-m4/drivers/staging/qcacld-3.0/core/hdd/src/wlan_hdd_main.c)

上面所有流程问题点有点奇怪，先返回手册第三章试下直接ubuntu平台下的操作

缺少文件subsystem_restart.h，移远回复如下：
> [Quectel]: 在内核中，关闭宏CONFIG_ARCH_QCOM

在内核源码上搜索QCOM所有相关配置，全部注释，重新编译内核，内核编译完成

重新编译wifi驱动，部分信息如下：

```
Building modules, stage 2.
  MODPOST 1 modules
  CC      /home/forlinx/wifi/fc6xe/WiFi/chss_host_LEA/chss_proc/host/AIO/build/../drivers/qcacld-3.0/wlan.mod.o
  LD [M]  /home/forlinx/wifi/fc6xe/WiFi/chss_host_LEA/chss_proc/host/AIO/build/../drivers/qcacld-3.0/wlan.ko
```

wlan.ko已经正常生成，之后的报错如下：

```
cp -fr /home/forlinx/wifi/fc6xe/WiFi/chss_host_LEA/chss_proc/host/AIO/build/../rootfs-ve-f10.build/lib/modules /home/forlinx/wifi/fc6xe/WiFi/chss_host_LEA/chss_proc/host/AIO/build/../rootfs-ve-f10.build/lib/unstripped_modules
Strip modules
Install firmware
cd /home/forlinx/wifi/fc6xe/WiFi/chss_host_LEA/chss_proc/host/AIO/build/../drivers && make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- firmware_install
make[1]: Entering directory '/home/forlinx/wifi/fc6xe/WiFi/chss_host_LEA/chss_proc/host/AIO/drivers'
KERNEL_VERSION:4
install QCA WLAN firmware
cp: cannot stat '/home/forlinx/wifi/fc6xe/WiFi/chss_host_LEA/chss_proc/host/AIO/build/../drivers/firmware/WLAN-firmware': No such file or directory
Makefile:393: recipe for target 'firmware_install' failed
make[1]: *** [firmware_install] Error 1
make[1]: Leaving directory '/home/forlinx/wifi/fc6xe/WiFi/chss_host_LEA/chss_proc/host/AIO/drivers'
Makefile:111: recipe for target 'drivers_firmware' failed
make: *** [drivers_firmware] Error 2
```

执行以下

```bash
mkdir -p /home/forlinx/wifi/fc6xe/WiFi/chss_host_LEA/chss_proc/host/AIO/build/../drivers/firmware/WLAN-firmware
```

```bash
mkdir -p /home/forlinx/wifi/fc6xe/WiFi/chss_host_LEA/chss_proc/host/AIO/build/../drivers/firmware/BT-firmware
```

驱动编译完成，然后安装firmware，firmware_install，对应wifi源码下Makefile的112行，然后开始编译应用程序，部分信息如下：

```
Install firmware
cd /home/forlinx/wifi/fc6xe/WiFi/chss_host_LEA/chss_proc/host/AIO/build/../drivers && make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- firmware_install
make[1]: Entering directory '/home/forlinx/wifi/fc6xe/WiFi/chss_host_LEA/chss_proc/host/AIO/drivers'
KERNEL_VERSION:4
install QCA WLAN firmware
make[1]: Leaving directory '/home/forlinx/wifi/fc6xe/WiFi/chss_host_LEA/chss_proc/host/AIO/drivers'
Clean wpa_supplicant
cd /home/forlinx/wifi/fc6xe/WiFi/chss_host_LEA/chss_proc/host/AIO/build/../apps/hostap/wpa_supplicant && make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- clean
make[1]: Entering directory '/home/forlinx/wifi/fc6xe/WiFi/chss_host_LEA/chss_proc/host/AIO/apps/hostap/wpa_supplicant'
Package libnl-3.0 was not found in the pkg-config search path.
Perhaps you should add the directory containing `libnl-3.0.pc'
to the PKG_CONFIG_PATH environment variable
No package 'libnl-3.0' found
Package dbus-1 was not found in the pkg-config search path.
Perhaps you should add the directory containing `dbus-1.pc'
```

应用上报错如下：

```
  CC  ../src/eap_peer/eap_tls_common.c
In file included from /usr/include/openssl/ssl.h:15:0,
                 from ../src/crypto/tls_openssl.c:19:
/usr/include/openssl/e_os2.h:13:11: fatal error: openssl/opensslconf.h: No such file or directory
 # include <openssl/opensslconf.h>
           ^~~~~~~~~~~~~~~~~~~~~~~
compilation terminated.
../src/build.rules:86: recipe for target '/home/forlinx/wifi/fc6xe/WiFi/chss_host_LEA/chss_proc/host/AIO/apps/hostap/build/wpa_supplicant/src/crypto/tls_openssl.o' failed
make[1]: *** [/home/forlinx/wifi/fc6xe/WiFi/chss_host_LEA/chss_proc/host/AIO/apps/hostap/build/wpa_supplicant/src/crypto/tls_openssl.o] Error 1
make[1]: Leaving directory '/home/forlinx/wifi/fc6xe/WiFi/chss_host_LEA/chss_proc/host/AIO/apps/hostap/wpa_supplicant'
Makefile:143: recipe for target 'wpa_supplicant' failed
make: *** [wpa_supplicant] Error 2
```

汇总wifi源码的Makefile后续需要编译的应用：

wpa_supplicant 、hostapd、iw、libnl、qcmbr、athdiag、ath6kl-utils、

应用报错先暂时不管，先将当前生成的firmware放到飞凌的板卡上测试使用。流程如下：

拷贝Wi-Fi固件的bin文件“qcom_cfg.ini”、“wlan_cnss_core_pcie. ini”。Ko和wlan。将FC6xE的源代码ko拷贝到Ubuntu的相应目录。

```
# cp <FC6XE_target_root>/meta_build/load_meta/wlan_firmware/* /lib/firmware/ // WLAN Firmware
bin file
# cp <FC6XE_target_root>/meta_build/load_meta/host/wlan_host/qcom_cfg.ini /lib/firmware/wlan/q
com_cfg.ini
# cp <FC6XE_target_root >chss_host_LEA/chss_proc/host/AIO/drivers/core_tech_modules/ 
wlan_cnss_core_pcie.ko /lib/modules/
# cp <FC6XE_target_root >chss_host_LEA/chss_proc/host/AIO/drivers/qcacld-3.0/wlan.ko
/lib/modules/
```

如果目录不存在，执行mkdir /lib/firmware/wlan命令创建“/lib/firmware/wlan”。





### 五. Ubuntu Platform（未需执行）

2023/12/13 已经结束了当前的项目评审，开始解决板卡的wifi驱动问题

整理手册的Ubuntu Platform步骤如下，当前还未开始进行操作

#### 5.1 安装软件包

在Ubuntu主机上执行如下命令安装对应的软件包。

```bash
$ sudo apt update
$ sudo apt install -y openssh-server x11vnc dos2unix iperf linux-crashdump wireless-tools exfat-utils 
exfat-fuse
$ sudo apt install build-essential libncurses5-dev flex bison libnl-3-dev
$ sudo apt install kernel-package openssl
$ sudo apt install libssl-dev
$ sudo apt install libelf-dev
$ sudo apt install -y libnl-genl-3-dev
$ sudo apt install git
$ git config --global user.email "2944752064@qq.com"
$ git config --global user.name "findyang"
```

安装kexex-tools和kdump-tools时，所有提示都选择“Yes”

#### 5.2 编译和安装内核

Linux内核补丁用于内核版本4.9.11、5.4.0或5.10.0。如果应用于其他内核版本，它们可能无法工作。没有这些补丁，Wi-Fi就无法进行测试。以下章节分别介绍在Linux内核版本为4.9.11、5.4.0和5.10.0的操作系统上移植Wi-Fi的操作步骤。

当前选择4.9.11

##### 5.2.1. 编译内核(4.9.11版本)

步骤1:执行如下命令下载Linux内核。

```bash
$ git clone git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
$ cd linux-stable-rc
$ git checkout v4.9.11
```

步骤2:执行如下命令下载Linux内核补丁。

```bash
$ git clone git://codeaurora.org/external/sba/wlan_patches.git -b master wlan_patches
```

补充，上方已经无法下载代码，使用如下链接：

```bash
$ git clone https://git.codelinaro.org/clo/sba-patches/wlan_patches.git
```

步骤3:执行如下命令，应用下载的补丁。

```bash
$ git am
<wlan_patches>/fixce/3rdparty/patches/wlan_patches/kernel/v4.9.11/0001-Changes-for-wireless-and-cfg80211-for-v4.9.11-support.patch
$ git am
<wlan_patches>/fixce/3rdparty/patches/wlan_patches/kernel/v4.9.11/0002-Sysctl-support-for-TCP-IP-parameters-for-performance.patch
$ git am
<wlan_patches>/fixce/3rdparty/patches/wlan_patches/kernel/v4.9.11/0003-cfg80211-Add-support-for-FILS-shared-key-authentication.patch
$ git am
<wlan_patches>/fixce/3rdparty/patches/wlan_patches/kernel/v4.9.11/0004-cfg80211-Add-macros-to-indicate-backport-support-for.patch
$ git am
<wlan_patches>/fixce/3rdparty/patches/wlan_patches/kernel/v4.9.11/0005-cfg80211-size-various-nl80211-messages-correctly.patch
$ git am
<wlan_patches>/fixce/3rdparty/patches/wlan_patches/kernel/v4.9.11/0006-cfg80211-Modifiying-
__cfg80211_connect_result-API.patch
$ git am
<wlan_patches>/fixce/3rdparty/patches/wlan_patches/kernel/v4.9.11/0007-cfg80211-Match-4.9.11-
kernel-cfg80211-nl80211_attrs-.patch
$ git am
<wlan_patches>/fixce/3rdparty/patches/wlan_patches/kernel/v4.9.11/0008-cfg80211-Use-a-structure-to-pass-connect-response-pa.patch
$ git am
<wlan_patches>/fixce/3rdparty/patches/wlan_patches/kernel/v4.9.11/0009-cfg80211-Define-macro-to-indicate-support-for-new-cf.patch
$ git am
<wlan_patches>/fixce/3rdparty/patches/wlan_patches/kernel/v4.9.11/0010-sae-owe-station.patch
$ git am
<wlan_patches>/fixce/3rdparty/patches/wlan_patches/kernel/v4.9.11/0011-sae-owe-sap.patch
$ git am
<wlan_patches>/fixce/3rdparty/patches/wlan_patches/kernel/v4.9.11/0012-x86-kernel-reserve-CMA-memory-space-under-4G.patch
$ git am
<wlan_patches>/fixce/3rdparty/patches/wlan_patches/kernel/v4.9.11/0013-nl80211-add-6GHz-band-definition-to-enum-nl80211_ban.patch
$ git am
<wlan_patches>/fixce/3rdparty/patches/wlan_patches/kernel/v4.9.11/0014-cfg80211-add-6GHz-UNII-band-definitions.patch
$ git am
<wlan_patches>/fixce/3rdparty/patches/wlan_patches/kernel/v4.9.11/0015-cfg80211-util-add-6GHz-channel-to-freq-conversion-an.patch
$ git am
<wlan_patches>/fixce/3rdparty/patches/wlan_patches/kernel/v4.9.11/0016-cfg80211-extend-ieee80211_operating_class_to_band-fo.patch
$ git am
<wlan_patches>/fixce/3rdparty/patches/wlan_patches/kernel/v4.9.11/0017-cfg80211-add-6GHz-in-code-handling-array-with-NUM_NL.patch
$ git am
<wlan_patches>/fixce/3rdparty/patches/wlan_patches/kernel/v4.9.11/0018-cfg80211-use-same-IR-permissive-rules-for-6GHz-band.patch
$ git am
<wlan_patches>/fixce/3rdparty/patches/wlan_patches/kernel/v4.9.11/0019-cfg80211-ibss-use-11a-mandatory-rates-for-6GHz-band-.patch
$ git am
<wlan_patches>/fixce/3rdparty/patches/wlan_patches/kernel/v4.9.11/0020-cfg80211-apply-same-mandatory-rate-flags-for-5GHz-an.patch
$ git am
<wlan_patches>/fixce/3rdparty/patches/wlan_patches/kernel/v4.9.11/0021-cfg80211-Indicate-support-6GHz-band-in-kernel.patch
$ git am
<wlan_patches>/fixce/3rdparty/patches/wlan_patches/kernel/v4.9.11/0022-cfg80211-Add-support-for-HE.patch
$ git am
<wlan_patches>/fixce/3rdparty/patches/wlan_patches/kernel/v4.9.11/0023-mac80211-add-ieee80211_get_he_iftype_cap-helper.patch
$ git am
<wlan_patches>/fixce/3rdparty/patches/wlan_patches/kernel/v4.9.11/0024-6GHz-Add-support-to-validate-6GHz-channels.patch
$ git am
<wlan_patches>/fixce/3rdparty/patches/wlan_patches/kernel/v4.9.11/0025-cfg80211-Adjust-6ghz-frequencies-per-channelization.patch
$ git am
<wlan_patches>/fixce/3rdparty/patches/wlan_patches/kernel/v4.9.11/0026-nl80211-fix-nlmsg-allocation-in-cfg80211_ft_event.patch
$ git am
<wlan_patches>/fixce/3rdparty/patches/wlan_patches/kernel/v4.9.11/0027-dsa-mv88e6xxx-Optimise-atu_get.patch
$ git am
<wlan_patches>/fixce/3rdparty/patches/wlan_patches/kernel/v4.9.11/0028-cfg80211-add-and-use-strongly-typed-element-iteratio.patch
$ git am
<wlan_patches>/fixce/3rdparty/patches/wlan_patches/kernel/v4.9.11/0029-cfg80211-Parsing-of-Multiple-BSSID-information-in-sc.patch
$ git am
<wlan_patches>/fixce/3rdparty/patches/wlan_patches/kernel/v4.9.11/0030-cfg80211-use-for_each_element-for-multi-bssid-parsin.patch
$ git am
<wlan_patches>/fixce/3rdparty/patches/wlan_patches/kernel/v4.9.11/0031-cfg80211-Properly-track-transmitting-and-non-transmi.patch
$ git am
<wlan_patches>/fixce/3rdparty/patches/wlan_patches/kernel/v4.9.11/0032-cfg80211-Move-Multiple-BSS-info-to-struct-cfg80211_b.patch
$ git am
<wlan_patches>/fixce/3rdparty/patches/wlan_patches/kernel/v4.9.11/0033-cfg80211-parse-multi-bssid-only-if-HW-supports-it.patch
$ git am
<wlan_patches>/fixce/3rdparty/patches/wlan_patches/kernel/v4.9.11/0034-cfg80211-make-BSSID-generation-function-inline.patch
$ git am
<wlan_patches>/fixce/3rdparty/patches/wlan_patches/kernel/v4.9.11/0035-cfg80211-add-various-struct-element-finding-helpers.patch
$ git am
<wlan_patches>/fixce/3rdparty/patches/wlan_patches/kernel/v4.9.11/0036-cfg80211-save-multi-bssid-properties.patch
$ git am
<wlan_patches>/fixce/3rdparty/patches/wlan_patches/kernel/v4.9.11/0037-cfg80211-fix-the-IE-inheritance-of-extension-IEs.patch
$ git am
<wlan_patches>/fixce/3rdparty/patches/wlan_patches/kernel/v4.9.11/0038-cfg80211-fix-memory-leak-of-new_ie.patch
$ git am
<wlan_patches>/fixce/3rdparty/patches/wlan_patches/kernel/v4.9.11/0039-ieee80211-fix-for_each_element_extid.patch
$ git am
<wlan_patches>/fixce/3rdparty/patches/wlan_patches/kernel/v4.9.11/0040-cfg80211-fix-and-clean-up-cfg80211_gen_new_bssid.patch
$ git am
<wlan_patches>/fixce/3rdparty/patches/wlan_patches/kernel/v4.9.11/0041-cfg80211-Define-macro-to-indicate-prev_bssid-connect.patch
$ git am
<wlan_patches>/fixce/3rdparty/patches/wlan_patches/kernel/v4.9.11/0042-nl80211-add-NL80211_CMD_UPDATE_FT_IES-to-supported-c.patch
$ git am
<wlan_patches>/fixce/3rdparty/patches/wlan_patches/kernel/v4.9.11/0043-cfg80211-Add-backport-flag-for-user-cellular-base-hi.patch
```

步骤4:构建Linux内核。

1)执行以下命令配置内核。

```bash
$ cd linux-stable
$ make menuconfig
```

然后在弹出的内核配置窗口中选择以下选项。

```bash
save > ok > exit
load > ok > exit -> yes
```

2)修改内核配置文件。

```bash
CONFIG_MMC=y – For MMC/SD/USB card support
CONFIG_MMC_DEBUG=y – For MMC debugging
CONFIG_CFG80211_INTERNAL_REGDB=y
CONFIG_CFG80211=m
CONFIG_NL80211_TESTMODE=y
CONFIG_FRAME_WARN=2048
CONFIG_DMA_CMA=y
CONFIG_CMA_SIZE_MBYTES=512
```

3)执行如下命令构建Linux内核。

```bash
$ sudo make-kpkg -j4 --initrd kernel_image kernel_headers
```

生成的映像自动存储在内核源代码的上层目录中。

步骤5:执行如下命令安装Linux内核。

```bash
$ sudo dpkg -i linux-image-4.9.11+_4.9.11+-10.00.Custom_amd64.deb
$ sudo dpkg -i linux-headers-4.9.11+_4.9.11+-10.00.Custom_amd64.deb
```

步骤6:重启安装了4.9.11内核的主机。您可能需要更新GRUB配置以允许引导多个内核。

#### 5.3 构建Wi-Fi驱动程序

##### 5.3.1  获取模块Wi-Fi源代码

从https://git-master.quectel.com/wifi.bt/fc6xe获取模块Wi-Fi源代码。

##### 5.3.2 将文件复制到内核

执行以下命令将AIO/drivers/core_tech_modules下相应文件夹中的cnss2.h、qcn_sdio_al.h和cnss_utils.h复制到<kernelpath>/include/net/ of kernel。

```bash
$ sudo cp -r AIO/drivers/core_tech_modules/cnss2/cnss2.h <kernelpath>/include/net/
$ sudo cp -r AIO/drivers/core_tech_modules/inc/qcn_sdio_al.h <kernelpath>/include/net/
$ sudo cp -r AIO/drivers/core_tech_modules/cnss_utils/cnss_utils.h <kernelpath>/include/net/
```

例如，Linux内核版本为4.9.11，则<kernelpath>可以设置为/lib/modules/4.9.11+/build。

##### 5.3.3 编译Wi-Fi驱动程序

以X86为例，执行如下命令编译Wi-Fi驱动。

```bash
$ cd <FC6XE_target_root>/chss_host_LEA/chss_proc/host/AIO/build
$ make drivers
```

> 1. 上面命令中的< fc6x_target_root >为存储FC6xE Wi-Fi源代码的根目录。
>
> 2. 根据实际需求，您可以使用以下任何命令来编译WiFi驱动程序。
>
> X86: make drivers
>
> X86-perf: make CONFIG_PERF_BUILD=y drivers
>
> X86-one-msi: make CONFIG_ONE_MSI_BUILD=y drivers
>
> X86-perf-one-msi: make CONFIG_PERF_BUILD=y

#### 5.4 安装Wi-Fi固件和Wi-Fi驱动程序

拷贝Wi-Fi固件的bin文件“qcom_cfg.ini”、“wlan_cnss_core_pcie. ini”。Ko和wlan。将FC6xE的源代码ko拷贝到Ubuntu X86的相应目录。

```
# cp <FC6XE_target_root>/meta_build/load_meta/wlan_firmware/* /lib/firmware/ // WLAN Firmware
bin file
# cp <FC6XE_target_root>/meta_build/load_meta/host/wlan_host/qcom_cfg.ini /lib/firmware/wlan/q
com_cfg.ini
# cp <FC6XE_target_root >chss_host_LEA/chss_proc/host/AIO/drivers/core_tech_modules/ wlan_cnss_core_pcie.ko /lib/modules/
# cp <FC6XE_target_root >chss_host_LEA/chss_proc/host/AIO/drivers/qcacld-3.0/wlan.ko
/lib/modules/
```

如果目录不存在，执行mkdir /lib/firmware/wlan命令创建“/lib/firmware/wlan”。

#### 5.5 启动Wi-Fi驱动程序

按照第2.4章的步骤启动Wi-Fi驱动程序

##### 5.5.1 枚举PCIe

执行以下命令查看PCIe是否可以成功枚举。

```
# lspci
```

显示如下信息，表示PCIe枚举成功。

```bash
00:00.0 PCI bridge: Freescale Semiconductor Inc Device 0000 (rev 01)
01:00.0 Network controller: Qualcomm Device 1103 (rev 01)
```

##### 5.5.2 加载Wi-Fi驱动

执行以下命令加载Wi-Fi驱动程序

```
# insmod wlan_cnss_core_pcie.ko
# insmod wlan.ko country_code=xx
```

> \# insmod wlanKo country_code=xx用于将国家代码设置为模块参数，例如:
>
> \# insmod wlanko country_code=US。
>
> 有个ini配置文件是无需配置国家码的
>
> FC06EACMD
> │   ├── bdwlan.elf
> │   ├── bdwlang.elf
> │   ├── wlan
> │   │   └── qcom_cfg.ini
> │   └── 不写国家码.txt

##### 5.5.3 启用无线网络

执行类似以下命令使能Wi-Fi。

```bash
$ ifconfig wlan0 up
$ ifconfig wlan0
wlan0 Link encap:Ethernet HWaddr 00:03:7f:10:72:12
 UP BROADCAST MULTICAST MTU:1500 Metric:1
 RX packets:0 errors:0 dropped:0 overruns:0 frame:0
 TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
 collisions:0 txqueuelen:3000
 RX bytes:0 (0.0 B) TX bytes:0 (0.0 B)
```



### 六. 飞凌板上调试（FC06E样板已成功联网）

```bash
$ lspci
0000:00:00.0 PCI bridge: Freescale Semiconductor Inc Device 81c0 (rev 10)
0001:00:00.0 PCI bridge: Freescale Semiconductor Inc Device 81c0 (rev 10)
0001:01:00.0 Network controller: Qualcomm Device 1103 (rev 01)
```

make[2]: Entering directory '/home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel'
make[3]: Entering directory '/home/forlinx/work/OK10xx-linux-fs/flexbuild/build/linux/linux/arm64/output'



自研使用的是lsk1906，生成的驱动无法在飞凌上使用

```bash
forlinx@localhost:/lib/modules/4.14.47$ modprobe wlan_cnss_core_pcie.ko
modprobe: FATAL: Module wlan_cnss_core_pcie.ko not found in directory /lib/modules/4.14.47
forlinx@localhost:/lib/modules/4.14.47$ sudo insmod wlan_cnss_core_pcie.ko
insmod: ERROR: could not insert module wlan_cnss_core_pcie.ko: Invalid module format
forlinx@localhost:/lib/modules/4.14.47$ sudo insmod wlan.ko
insmod: ERROR: could not insert module wlan.ko: Invalid module format
forlinx@localhost:/lib/modules/4.14.47$ sudo insmod -f wlan_cnss_core_pcie.ko
insmod: ERROR: could not insert module wlan_cnss_core_pcie.ko: Unknown symbol in module
forlinx@localhost:/lib/modules/4.14.47$ sudo insmod -f wlan.ko
insmod: ERROR: could not insert module wlan.ko: Unknown symbol in module
```

回到飞凌的lsdk1806重新编译内核，编译驱动，还有一个问题，wlan.ko达到了389M，是不是编译进去的东西太多了。

重新编译还是同样的问题

```bash
forlinx@localhost:~/wlan$ sudo  insmod wlan_cnss_core_pcie.ko
insmod: ERROR: could not insert module wlan_cnss_core_pcie.ko: Unknown symbol in module
forlinx@localhost:~/wlan$ dmesg |tail
[ 1652.874571] wlan_cnss_core_pcie: Unknown symbol vfs_write (err 0)
[ 1767.394506] wlan_cnss_core_pcie: Unknown symbol vfs_write (err 0)
[ 1807.721106] wlan_cnss_core_pcie: Unknown symbol vfs_write (err 0)
forlinx@localhost:~/wlan$ cat   /proc/kallsyms  | grep "vfs_write"
0000000000000000 t vfs_writev
0000000000000000 T __vfs_write
0000000000000000 T vfs_write
0000000000000000 t v9fs_vfs_writepage_locked.part.0
0000000000000000 t v9fs_vfs_writepage_locked
0000000000000000 t v9fs_vfs_writepage
```

问题出在vfs_write，回顾以前编译的时候，确实出现了vfs_write的waring

[c - Unknown symbol vfs_write (err -2) in kernel module in kernel 4.20 - Stack Overflow](https://stackoverflow.com/questions/53917041/unknown-symbol-vfs-write-err-2-in-kernel-module-in-kernel-4-20)

从Linux内核4.14版本开始，vfs_write函数不再导出以供模块使用。使用kernel_write代替。它的签名是一样的

```
ssize_t kernel_write(struct file *file, const void *buf, size_t count,
            loff_t *pos)
```

>[vfs_write dropped in linux kernel 4.14.14 · Issue #259 · kaloz/mwlwifi (github.com)](https://github.com/kaloz/mwlwifi/issues/259)
>
>[Replaced vfs_write with __kernel_write. · kaloz/mwlwifi@b1b9a9e (github.com)](https://github.com/kaloz/mwlwifi/commit/b1b9a9e1c1beee30a8cce4038f4109727362ebe0)
>
>@ValCher1961 yuhhaurlin说你应该直接删除vfs_write调用。它们仅用于调试，不会用于正常操作

从代码上看，已经#define vfs_write kernel_write，但是还是有vfs_write报错

```
root@ubuntu:/home/forlinx/wifi/fc6xe/WiFi# grep "vfs_write" -nr
Binary file chss_host_LEA/chss_proc/host/AIO/drivers/core_tech_modules/wlan_cnss_core_pcie.o matches
chss_host_LEA/chss_proc/host/AIO/drivers/core_tech_modules/cnss2/pci.c:2270:#define vfs_write kernel_write
chss_host_LEA/chss_proc/host/AIO/drivers/core_tech_modules/cnss2/pci.c:2315:		status = vfs_write(fp, (char *)&val, sizeof(uint32_t), &pos);
Binary file chss_host_LEA/chss_proc/host/AIO/drivers/core_tech_modules/cnss2/pci.o matches
Binary file chss_host_LEA/chss_proc/host/AIO/drivers/core_tech_modules/wlan_cnss_core_pcie.ko matches
chss_host_LEA/chss_proc/host/AIO/drivers/core_tech_modules/mhi/mhi_fw_dump.c:24:#define vfs_write kernel_write
chss_host_LEA/chss_proc/host/AIO/drivers/core_tech_modules/mhi/mhi_fw_dump.c:87:		status = vfs_write(fp, buf, size, &pos);
chss_host_LEA/chss_proc/host/AIO/drivers/core_tech_modules/mhi/mhi_fw_dump.c:179:		status = vfs_write(fp, buf, size, &pos);
chss_host_LEA/chss_proc/host/AIO/drivers/core_tech_modules/mhi/mhi_fw_dump.c:250:	status = vfs_write(fp,
chss_host_LEA/chss_proc/host/AIO/drivers/core_tech_modules/mhi/mhi_fw_dump.c:272:		status = vfs_write(fp, buf, size, &pos);
chss_host_LEA/chss_proc/host/AIO/drivers/core_tech_modules/mhi/mhi_fw_dump.c:326:	status = vfs_write(fp,
Binary file chss_host_LEA/chss_proc/host/AIO/drivers/core_tech_modules/mhi/mhi_fw_dump.o matches
```

搜到使用vfs_write的所有文件都是在大于5.4.0版本号的情况下才会使用kernel_write替代vfs_write，而当前使用的是4.14，所以使用vfs_write，但是vfs_write在4.14版本中已经无法使用了

```diff
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(5, 4, 0)
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(4, 14, 0)
#define vfs_write kernel_write
#endif
```

修改后重新编译，wlan_cnss_core_pcie.ko已经没有vfs_write的报错了

```
 Building modules, stage 2.
  MODPOST 1 modules
  CC      /home/forlinx/wifi/fc6xe/WiFi/chss_host_LEA/chss_proc/host/AIO/drivers/core_tech_modules/wlan_cnss_core_pcie.mod.o
  LD [M]  /home/forlinx/wifi/fc6xe/WiFi/chss_host_LEA/chss_proc/host/AIO/drivers/core_tech_modules/wlan_cnss_core_pcie.ko
```

wlan.ko上出现跟同样的问题hdd_dump_log_buffer未定义

```
Building modules, stage 2.
  MODPOST 1 modules
WARNING: "hdd_dump_log_buffer" [/home/forlinx/wifi/fc6xe/WiFi/chss_host_LEA/chss_proc/host/AIO/build/../drivers/qcacld-3.0/wlan.ko] undefined!
  CC      /home/forlinx/wifi/fc6xe/WiFi/chss_host_LEA/chss_proc/host/AIO/build/../drivers/qcacld-3.0/wlan.mod.o
  LD [M]  /home/forlinx/wifi/fc6xe/WiFi/chss_host_LEA/chss_proc/host/AIO/build/../drivers/qcacld-3.0/wlan.ko
```

加载驱动后dmesg|tail查看如下：

```
[ 2079.738101] wlan: Unknown symbol hdd_dump_log_buffer (err 0)
```

搜索wifi源码，涉及如下：

fc6xe/WiFi/chss_host_LEA/chss_proc/host/AIO/drivers/qcacld-3.0/core/hdd/inc/wlan_hdd_wext.h

其中fc6xe/WiFi/chss_host_LEA/chss_proc/host/AIO/drivers/qcacld-3.0/core/hdd/inc/wlan_hdd_includes.h以及fc6xe/WiFi/chss_host_LEA/chss_proc/host/AIO/drivers/qcacld-3.0/core/hdd/inc/wlan_hdd_wmm.h包含了wlan_hdd_wext.h

```c
#ifdef WLAN_DUMP_LOG_BUF_CNT
/**
 * hdd_dump_log_buffer() - dump log buffer history
 *
 * Reture: None
 */
void hdd_dump_log_buffer(void);
#else
static inline
void hdd_dump_log_buffer(void)
{
}
#endif
```

fc6xe/WiFi/chss_host_LEA/chss_proc/host/AIO/drivers/qcacld-3.0/core/hdd/src/wlan_hdd_driver_ops.c

```c
switch (event_data->uevent) {
	case PLD_FW_DOWN:
		hdd_debug("Received firmware down indication");
		hdd_dump_log_buffer();
		cds_set_target_ready(false);
		cds_set_recovery_in_progress(true);
```

fc6xe/WiFi/chss_host_LEA/chss_proc/host/AIO/drivers/qcacld-3.0/core/hdd/src/wlan_hdd_wext.c

```c
#ifdef WLAN_DUMP_LOG_BUF_CNT
void hdd_dump_log_buffer(void)
{
	int i;

	for (i = 0; i <= MGMT_EVENT_LOG; i++)
		hdd_ioctl_log_buffer(i, WLAN_DUMP_LOG_BUF_CNT);
}
#endif
```

针对以上，当前修改为wlan_hdd_wext.h中（注意是在飞凌提供的lsdk上才做改动，nxp原本的lsdk1906无需以下改动）

```diff
-#ifdef WLAN_DUMP_LOG_BUF_CNT
+#ifndef WLAN_DUMP_LOG_BUF_CNT
+#define WLAN_DUMP_LOG_BUF_CNT 1
```

重新编译，没有hdd_dump_log_buffer未定义的报错了

```
 Building modules, stage 2.
  MODPOST 1 modules
  CC      /home/forlinx/wifi/fc6xe/WiFi/chss_host_LEA/chss_proc/host/AIO/build/../drivers/qcacld-3.0/wlan.mod.o
  LD [M]  /home/forlinx/wifi/fc6xe/WiFi/chss_host_LEA/chss_proc/host/AIO/build/../drivers/qcacld-3.0/wlan.ko
```

加载驱动，没有报错未定义符号了（截止1220）

但是还没无法使能wifi模块

```
[ 5689.157349] wlan: Loading driver v5.2.0.220S.061 +TIMER_MANAGER +MEMORY_DEBUG +PANIC_ON_BUG
[ 5689.167914] wlan_hdd_state wlan major(235) initialized
[ 5689.167927] cnss: Posting event: REGISTER_DRIVER(7)-sync, state: 0x0
[ 5689.167930] cnss: PM stay awake, state: 0x0, count: 1
[ 5689.167932] cnss_pm_stay_awake: NAP-TODO
[ 5689.168270] cnss: cnss_driver_event_work
[ 5689.168274] cnss: Processing driver event: REGISTER_DRIVER-sync(7), state: 0x0
[ 5689.168277] cnss: wlan en pin is not supported
[ 5689.168550] cnss: lnkctl 0x10120040
[ 5689.168566] cnss: QMI timeout is 10000 ms
[ 5689.168569] cnss: Setting MHI state: INIT(0)
[ 5689.247724] [bhi_probe] jtagid:0x1019b0e1
[ 5689.271360] cma: cma_alloc: alloc failed, req-size: 129 pages, ret: -12
[ 5689.271543] cnss: Setting MHI state: POWER_ON(5)
[ 5690.000148] cnss: Received QMI WLFW service event: 2
[ 5690.000156] cnss: Posting event: SERVER_ARRIVE(0), state: 0x10
[ 5690.023757] cnss: Processing driver event: SERVER_ARRIVE(0), state: 0x10
[ 5690.023772] cnss: Completed event: REGISTER_DRIVER(7), state: 0x10, ret: 0/0
[ 5690.023865] cnss: QMI WLFW service connected, state: 0x11
[ 5690.023869] cnss: Sending indication register message, state: 0x11
[ 5690.025197] cnss: Received QMI WLFW event: 1
[ 5690.025210] cnss: Receiving QMI WLFW event in work queue context
[ 5690.025227] cnss: Receiving QMI event completed
[ 5690.025235] cnss: Sending host capability message, state: 0x11
[ 5690.025239] cnss: Number of clients is 1
[ 5690.025245] cnss: Assign MSI to user: WAKE, num_vectors: 1, user_base_data: 13, base_vector: 13
[ 5690.025249] cnss: WAKE MSI base data is 13
[ 5690.025252] cnss: Calibration done is 0
[ 5690.025255] cnss: nm_modem is 2
[ 5690.026558] cnss: Received QMI WLFW event: 1
[ 5690.026567] cnss: Received QMI WLFW event: 1
[ 5690.026575] cnss: Receiving QMI WLFW event in work queue context
[ 5690.026593] cnss: Received QMI WLFW indication, msg_id: 0x35, msg_len: 22
[ 5690.026604] cnss: FW memory segment count is 2
[ 5690.026609] cnss: Posting event: REQUEST_MEM(2), state: 0x11
[ 5690.026615] cnss: Receiving QMI event completed
[ 5690.026620] cnss: Processing driver event: REQUEST_MEM(2), state: 0x11
[ 5690.026649] cma: cma_alloc: alloc failed, req-size: 1504 pages, ret: -12
[ 5690.026653] cnss: Failed to allocate memory for FW, size: 0x5dc000, type: 1
[ 5690.033651] cnss: PM relax, state: 0x11, count: 0
[ 5690.033654] cnss_pm_relax: NAP-TODO
[ 5690.033658] cnss: cnss_driver_event_work
[ 5690.033661] cnss: PM stay awake, state: 0x11, count: 1
[ 5690.033664] cnss_pm_stay_awake: NAP-TODO
[ 5690.033667] cnss: PM relax, state: 0x11, count: 0
[ 5690.033670] cnss_pm_relax: NAP-TODO
[ 5710.947700] cnss: Timeout waiting for FW ready indication
[ 5710.953127] cnss: Posting event: RECOVERY(9), state: 0x11
[ 5710.953135] cnss: PM stay awake, state: 0x11, count: 1
[ 5710.953140] cnss_pm_stay_awake: NAP-TODO
[ 5710.953151] cnss: PM relax, state: 0x11, count: 0
[ 5710.953156] cnss_pm_relax: NAP-TODO
[ 5710.953165] cnss: cnss_driver_event_work
[ 5710.953172] cnss: PM stay awake, state: 0x11, count: 1
[ 5710.953179] cnss_pm_stay_awake: NAP-TODO
[ 5710.953184] cnss: Processing driver event: RECOVERY(9), state: 0x11
[ 5710.953189] cnss: Driver recovery is triggered with reason: TIMEOUT(3)
[ 5710.953193] cnss: PM relax, state: 0x191, count: 0
[ 5710.953195] cnss_pm_relax: NAP-TODO
```

```
forlinx@localhost:~/wlan$ sudo insmod  wlan_cnss_core_pcie.ko
forlinx@localhost:~/wlan$ sudo insmod  wlan.ko
forlinx@localhost:~/wlan$ lsmod
Module                  Size  Used by
wlan                12365824  0
wlan_cnss_core_pcie   389120  1 wlan
```

#### 解决CMA_SIZE太小的问题

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

内核里设置CONFIG_CMA_SIZE_MBYTES，修改为64后重新编译内核

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

烧录新内核后，重新insmod wlan_cnss_core_pcie.ko和wlan.ko驱动，注意由于重命名规则，wlan0不一定会被别名为wlP1p1s0

```
root@localhost:/home/forlinx/wlan# dmesg |grep renamed
[    5.894986] fsl_dpa soc:fsl,dpaa:ethernet@3 fm1-mac4: renamed from eth2
[    5.908810] fsl_dpa soc:fsl,dpaa:ethernet@2 fm1-mac3: renamed from eth1
[    5.923860] fsl_dpa soc:fsl,dpaa:ethernet@8 fm1-mac9: renamed from eth5
[    5.939909] fsl_dpa soc:fsl,dpaa:ethernet@5 fm1-mac6: renamed from eth4
[    5.964661] fsl_dpa soc:fsl,dpaa:ethernet@4 fm1-mac5: renamed from eth3
[    5.988300] fsl_dpa soc:fsl,dpaa:ethernet@1 fm1-mac2: renamed from eth0
[    6.008472] fsl_dpa soc:fsl,dpaa:ethernet@9 fm1-mac10: renamed from eth6
[   68.204514] cnss_pci 0001:01:00.0 wlP1p1s0: renamed from p2p0
[   68.231891] cnss_pci 0001:01:00.0 rename16: renamed from wifi-aware0
[   68.252210] cnss_pci 0001:01:00.0 rename14: renamed from wlan0
[ 2743.873527] cnss_pci 0001:01:00.0 wlP1p1s0: renamed from wlan0
[ 2743.893008] cnss_pci 0001:01:00.0 rename18: renamed from p2p0
[ 2743.911819] cnss_pci 0001:01:00.0 rename19: renamed from wifi-aware0
```

所以有时候直接up会失败，因为wlP1p1s0不是wlan0，rename14才是，不一定每次都是rename14

```
# ifconfig wlP1p1s0 up
SIOCSIFFLAGS: Operation not supported
```

up成功后，执行以下配置网络

```bash
sudo wpa_supplicant -B -iwlP1p1s0 -c/etc/wpa_supplicant.conf
sudo wpa_supplicant -B -irename14 -c/etc/wpa_supplicant.conf
```

成功则输出以下信息

```
Successfully initialized wpa_supplicant
```

然后执行udhcpc动态获取IP

```
root@localhost:/home/forlinx/wlan# udhcpc -i rename14
udhcpc: started, v1.27.2
udhcpc: sending discover
udhcpc: sending select for 192.168.127.138
udhcpc: lease of 192.168.127.138 obtained, lease time 3599
ip: RTNETLINK answers: File exists
```

#### 样板联网成功(2023.12.13 -2023.12.22)

测试下联网，ping下百度，联网成功

```
root@localhost:/home/forlinx/wlan# ping  www.baidu.com 
PING www.baidu.com(2408:8756:c52:1aec:0:ff:b013:5a11 (2408:8756:c52:1aec:0:ff:b013:5a11)) from 2408:8456:f156:8a66:71db:41bd:321e:b01 wlP1p1s0: 56 data bytes
64 bytes from 2408:8756:c52:1aec:0:ff:b013:5a11 (2408:8756:c52:1aec:0:ff:b013:5a11): icmp_seq=1 ttl=52 time=34.2 ms
64 bytes from 2408:8756:c52:1aec:0:ff:b013:5a11 (2408:8756:c52:1aec:0:ff:b013:5a11): icmp_seq=2 ttl=52 time=80.7 ms
64 bytes from 2408:8756:c52:1aec:0:ff:b013:5a11 (2408:8756:c52:1aec:0:ff:b013:5a11): icmp_seq=3 ttl=52 time=39.9 ms
--- www.baidu.com ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2003ms
rtt min/avg/max/mdev = 34.278/51.628/80.704/20.688 ms
```

后续需要看下重命名规则，解决下这个renamed的问题。

网口的别名规则，查找如下：

```bash
root@ubuntu:/home/forlinx/nxp/flexbuild_lsdk1906/build/rfs# grep -rn './' -e 'fm1-mac'
./rootfs_lsdk1906_LS_arm64_main/root/Net_Tools/wifi_ap.sh:21:        echo "eg: ./wifi_ap.sh -c fm1-mac6"
./rootfs_lsdk1906_LS_arm64_main/root/Net_Tools/wifi_ap.sh:22:        echo "eg: ./wifi_ap.sh -c fm1-mac6 -a ON"
./rootfs_lsdk1906_LS_arm64_main/root/Net_Tools/wifi_ap.sh:23:        echo "eg: ./wifi_ap.sh -c fm1-mac6 -a OFF"
./rootfs_lsdk1906_LS_arm64_main/root/.bash_history:597:grep -rn '/' -e 'fm1-mac'
./rootfs_lsdk1906_LS_arm64_main/etc/udev/rules.d/72-fsl-dpaa-persistent-networking.rules:2:SUBSYSTEM=="net", DRIVERS=="fsl_dpa*", ATTR{device_addr}=="1ae0000", NAME="fm1-mac1"
./rootfs_lsdk1906_LS_arm64_main/etc/udev/rules.d/72-fsl-dpaa-persistent-networking.rules:3:SUBSYSTEM=="net", DRIVERS=="fsl_dpa*", ATTR{device_addr}=="1ae2000", NAME="fm1-mac2"
./rootfs_lsdk1906_LS_arm64_main/etc/udev/rules.d/72-fsl-dpaa-persistent-networking.rules:4:SUBSYSTEM=="net", DRIVERS=="fsl_dpa*", ATTR{device_addr}=="1ae4000", NAME="fm1-mac3"
./rootfs_lsdk1906_LS_arm64_main/etc/udev/rules.d/72-fsl-dpaa-persistent-networking.rules:5:SUBSYSTEM=="net", DRIVERS=="fsl_dpa*", ATTR{device_addr}=="1ae6000", NAME="fm1-mac4"
./rootfs_lsdk1906_LS_arm64_main/etc/udev/rules.d/72-fsl-dpaa-persistent-networking.rules:6:SUBSYSTEM=="net", DRIVERS=="fsl_dpa*", ATTR{device_addr}=="1ae8000", NAME="fm1-mac5"
./rootfs_lsdk1906_LS_arm64_main/etc/udev/rules.d/72-fsl-dpaa-persistent-networking.rules:7:SUBSYSTEM=="net", DRIVERS=="fsl_dpa*", ATTR{device_addr}=="1aea000", NAME="fm1-mac6"
./rootfs_lsdk1906_LS_arm64_main/etc/udev/rules.d/72-fsl-dpaa-persistent-networking.rules:8:SUBSYSTEM=="net", DRIVERS=="fsl_dpa*", ATTR{device_addr}=="1af0000", NAME="fm1-mac9"
./rootfs_lsdk1906_LS_arm64_main/etc/udev/rules.d/72-fsl-dpaa-persistent-networking.rules:9:SUBSYSTEM=="net", DRIVERS=="fsl_dpa*", ATTR{device_addr}=="1af2000", NAME="fm1-mac10
```

wlan的别名规则，让无线网卡名称变回wlan0：

[linux如何将网卡的名称改成wlan0_80-net-setup-link.rules-CSDN博客](https://blog.csdn.net/weixin_42409052/article/details/113065704)

首先执行如下命令，将80-net-setup-link.rules文件从/lib/udev/rules.d/目录复制到 /etc/udev/rules.d/ 目录下：

```bash
cp  /lib/udev/rules.d/80-net-setup-link.rules   /etc/udev/rules.d/
```

然后执行如下命令，修改刚才复制过来的80-net-setup-link.rules文件：

```bash
sudo vi /etc/udev/rules.d/80-net-setup-link.rules
```

如下图所示，将箭头所指的ID_NET_NAME改成ID_NET_SLOT即可。

```diff
-NAME=="", ENV{ID_NET_NAME}!="", NAME="$env{ID_NET_NAME}"
+NAME=="", ENV{ID_NET_NAME}!="", NAME="$env{ID_NET_SLOT}"
```

此外，wlan.ko在飞凌板卡上一直无法开机自动加载，同级目录下wlan_cnss_core_pcie.ko是可以的，下面解决一下

如何让驱动ko文件开机自动加载配置

[驱动ko文件开机自动加载配置_电机配置文件有ko版本的名-CSDN博客](https://blog.csdn.net/u013372900/article/details/122375451)

只需要在/etc/modules下，或者/etc/modules-load.d/modules.conf，注意/etc/modules-load.d/modules.conf本质是/etc/modules的链接文件

```
root@localhost:/etc/modules-load.d# ll
total 8
drwxr-xr-x   2 root root 4096 Jan  1  1970 ./
drwxr-xr-x 126 root root 4096 Jan 29  2018 ../
lrwxrwxrwx   1 root root   10 Jan  1  1970 modules.conf -> ../modules
```

执行以下

```bash
vi /etc/modules
```

添加如下，这里要自动加载的为wlan.ko，写入wlan，不需要带后缀

```
# /etc/modules: kernel modules to load at boot time.
#
# This file contains the names of kernel modules that should be loaded
# at boot time, one per line. Lines beginning with "#" are ignored.
wlan
```

重启发现开机自启已经能识别到wlan0设备名了，不需要再手动加载



### 七. 自研AMR上调试

查看是否探测到pci设备，在AMR控制器上还没有能识别到

```bash
root@ubuntu:~# lspci
0000:00:00.0 PCI bridge: Freescale Semiconductor Inc Device 81c0 (rev 10)
0001:00:00.0 PCI bridge: Freescale Semiconductor Inc Device 81c0 (rev 10)
0002:00:00.0 PCI bridge: Freescale Semiconductor Inc Device 81c0 (rev 10)
```

编译好驱动并加载，报错如下：

```
root@ubuntu:/lib/modules/4.14.122-g277cb24a1-dirty# insmod wlan_cnss_core_pcie.ko
[ 2477.455199] [enable_bb_ctxt] 0x1000
[ 2477.458712] [enable_bb_ctxt] 0x1000
[ 2477.462267] cnss: PCI device not probed yet
[ 2477.466616] IPC_RTR: ipc_router_mhi_xprt_deinit: mhi_xprt driver removed 0
[ 2477.491850] register platform driver failed, ret = -1
insmod: ERROR: could not insert module wlan_cnss_core_pcie.ko: Operation not permitted
```

最后的Operation not permitted并非系统的权限问题，在飞凌的板卡上做对比实验，发现飞凌的板卡拔出wifi模块，然后执行lspci发现确认没有探测到设备之后，insmod驱动文件，也会报错Operation not permitted。

飞凌板卡上拔出wifi模块，insmod驱动文件的打印信息

```
# insmod wlan_cnss_core_pcie.ko
insmod: ERROR: could not insert module wlan_cnss_core_pcie.ko: Operation not permitted
```



配置2-12的gpio，rcw：

要配置GPIO2[12]，涉及两个RCW，先配置IFC_GRP_E1_BASE为000，再配置IFC_GRP_E1_EXT为1，

但是当前IFC_GRP_E1_EXT是配置了001，是QSPI_B的功能，经查证，自研的板卡上没有使用QPSI_B

配置例子如下：

```
	u32 val;
	struct ccsr_gpio *pgpio = (void *)(GPIO3_BASE_ADDR);

	val = in_be32(&pgpio->gpdir);
	val |=  USB2_SEL_MASK;
	out_be32(&pgpio->gpdir, val);

	val = in_be32(&pgpio->gpdat);
	val |=  USB2_SEL_MASK;
	out_be32(&pgpio->gpdat, val);
```

GPIO3_BASE_ADDR是GPIO的地址，可以在芯片参考手册中的**GPIO register descriptions**章节找到

后续进行测试的时候，软件上无法在上电后50ms内拉高GPIO，转由硬件上电路解决，上述所以GPIO无需配置了。



#### LSDK1806与LSDK1906的uboot中PCIE识别对比(无法分析)

现在上电时序已经确认能够满足了，但是在自研AMR控制器中还是无法识别Link，之前已经在飞凌的板卡上识别样板了，所以在软件上，看下飞凌的LSDK1806中的uboot和自研AMR的LSDK1906中的uboot对PCIE识别这方面有没有不同。除此之外，还需要看RCW，之前已经测试过直接使用RDB的11335559的RCW，不做改动进行测试，但是在自研AMR上还是没法识别。因为飞凌LSDK中uboot是闭源的，drivers下的文件无法查看，所以无法分析在RDB上的使用。

| PCIe0: pcie@3400000 Root Complex: no link | u-boot/drivers/pci/pcie_layerscape.c | ls_pcie_probe |
| ----------------------------------------- | ------------------------------------ | ------------- |



#### FRWY和RDB中的对比

分析这两个版本之间，对PCIE识别是否有不同的操作

在飞凌的RDB上能识别其他的模块，所以识别阶段应该不跟厂家驱动相关

RDB上接入FC06E模块

```
PCIe0: pcie@3400000 Root Complex: no link
PCIe1: pcie@3500000 disabled
PCIe2: pcie@3600000 Root Complex: x1 gen1
```

FRWY上接入FC06E模块

```
PCIe0: pcie@3400000 disabled
PCIe1: pcie@3500000 Root Complex: x1 gen3
PCIe2: pcie@3600000 Root Complex: no link
```

FRWY上接入FC06E模块、自带的wifi模块

```
PCIe0: pcie@3400000 disabled
PCIe1: pcie@3500000 Root Complex: x1 gen3
PCIe2: pcie@3600000 Root Complex: x1 gen1
```

FRWY上更换飞凌的RDB使用的Linux内核，并加载FC06E模块的驱动

注意，更换后，如果要改回来，则将Image_origin改回Image

#### 最终识别解决(2024.1.8)

时序问题解决，通过硬件电路上拉以及PCIE复位信号接入上电复位信号

硬件线序接反，SD2的TX和RX接反了

```
PCIe0: pcie@3400000 Root Complex: no link
PCIe1: pcie@3500000 Root Complex: no link
PCIe2: pcie@3600000 Root Complex: x1 gen2
```

#### 新的问题

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

```
root@ubuntu:/home/gie/wlan/with-debug# insmod wlan_cnss_core_pcie.ko
[ 1116.402130] [enable_bb_ctxt] 0x1000
[ 1116.405646] [enable_bb_ctxt] 0x1000
[ 1116.409664] cnss: Current L1SS status: 0x0
[ 1116.409672] cnss: Current ASPM status: 0x40
[ 1116.418112] rddm size 420000
[ 1116.421133] IPC_RTR: ipc_router_mhi_xprt_cb: Invalid cb reason 6
[ 1116.427143] IPC_RTR: ipc_router_mhi_xprt_cb: Invalid cb reason 6
[ 1116.433578] [enable_bb_ctxt] 0x800
[ 1116.437011] [enable_bb_ctxt] 0x800
root@ubuntu:/home/gie/wlan/with-debug# lsmod
Module                  Size  Used by
wlan_cnss_core_pcie   389120  0
xt_addrtype            16384  2
xt_conntrack           16384  1
88x2bu               3366912  0
cfg80211              311296  1 88x2bu
rfkill                 36864  3 cfg80211
crc32_ce               16384  0
crct10dif_ce           16384  0
qoriq_thermal          16384  0
nfsd                  282624  13
```

wlan_cnss_core_pcie.ko已经成功加载

wlan.ko加载失败，这里的驱动是能加载成功的

```
root@ubuntu:/home/gie/wlan/with-debug# insmod wlan.ko
[  102.093311] wlan: Loading driver v5.2.0.220S.061 +TIMER_MANAGER +MEMORY_DEBUG +PANIC_ON_BUG
[  102.123783] pcieport 0002:00:00.0: PCIe Bus Error: severity=Uncorrected (Fatal), type=Transaction Layer, id=0000(Receiver ID)
[  102.135121] pcieport 0002:00:00.0:   device [1957:81c0] error status/mask=00002000/00400000
[  102.143494] pcieport 0002:00:00.0:    [13] Flow Control Protocol  (First)
[  102.191655] [bhi_probe] jtagid:0x0
[  102.195441] Bad mode in Error handler detected on CPU2, code 0xbf000002 -- SError
[  102.202917] Internal error: Oops - bad mode: 0 [#1] PREEMPT SMP
[  102.208828] Modules linked in: wlan(O+) wlan_cnss_core_pcie(O) cfg80211 rfkill crc32_ce crct10dif_ce qoriq_thermal nfsd
[  102.219616] Process in:imklog (pid: 3959, stack limit = 0xffff000011e00000)
[  102.226571] CPU: 2 PID: 3959 Comm: in:imklog Tainted: G           O    4.14.122-g277cb24a1-dirty #2
[  102.235608] Hardware name: LS1046A FRWY Board (DT)
[  102.240390] task: ffff8008712a8d00 task.stack: ffff000011e00000
[  102.246303] PC is at 0xffffad94aac4
[  102.249781] LR is at 0xffffad94aaac
[  102.253259] pc : [<0000ffffad94aac4>] lr : [<0000ffffad94aaac>] pstate: 80000000
```

这里应该是硬件板卡不稳定，多次测试中有几次是成功加载的，并且能联网，成功时输出信息如下：

```
root@ubuntu:/home/gie/wlan/with-debug# insmod wlan.ko
[  113.627316] wlan: Loading driver v5.2.0.220S.061 +TIMER_MANAGER +MEMORY_DEBUG +PANIC_ON_BUG
[  113.717513] [bhi_probe] jtagid:0x1019b0e1
[  114.000681] patch-1: clear rx-vec, bhi_base as 0x          (null)
root@ubuntu:/home/gie/wlan/with-debug# [  114.828603] cnss: cnss_fw_ready_hdlr 640  
[  114.894126] [kworke][0x6d798d7][08:42:13.389611] wlan: [73:E:TXRX] hif_print_hal_shadow_register_cfg: num_config 28
[  114.933404] [kworke][0x6d83244][08:42:13.428887] wlan: [73:E:QDF] __cds_get_context: Module ID 66 context is Null (via hdd_update_ol_config)
[  114.948582] [kworke][0x6d86d8f][08:42:13.444066] wlan: [73:E:QDF] __cds_get_context: Module ID 66 context is Null (via cds_open)
[  114.960461] [kworke][0x6d89bf6][08:42:13.455946] wlan: [73:F:WMA] WMA --> wmi_unified_attach - success
[  114.974114] [kworke][0x6d8d149][08:42:13.469596] wlan: [73:E:QDF] htc_wait_target: Target Ready! TX resource : 1 size:2176, MaxMsgsPerHTCBundle = 1
[  114.987335] [kworke][0x6d904f0][08:42:13.482820] wlan: [73:E:QDF] htc_setup_target_buffer_assignments: SVS Index : 1 TX : 0x100 : alloc:1
[  114.999737] [kworke][0x6d9355e][08:42:13.495218] wlan: [73:E:DP] dp_srng_get_str_from_hal_ring_type: Invalid ring type
[  115.010458] [kworke][0x6d95f44][08:42:13.505943] wlan: [73:E:DP] dp_prealloc_get_coherent: unable to allocate memory for ring type tcl_cmd_credit (6) size 16384
[  115.024876] [kworke][0x6d99796][08:42:13.520361] wlan: [73:E:DP] dp_prealloc_get_coherent: unable to allocate memory for ring type tcl_status (7) size 16384
[  115.038924] [kworke][0x6d9ce75][08:42:13.534409] wlan: [73:E:DP] dp_prealloc_get_coherent: unable to allocate memory for ring type Reo_reinject (2) size 16384
[  115.053151] [kworke][0x6da0606][08:42:13.548634] wlan: [73:E:DP] dp_prealloc_get_coherent: unable to allocate memory for ring type Reo_cmd (3) size 16384
[  115.066939] [kworke][0x6da3be5][08:42:13.562425] wlan: [73:E:DP] dp_prealloc_get_coherent: unable to allocate memory for ring type Reo_status (4) size 16384
[  115.083939] [kworke][0x6da7e4d][08:42:13.579424] wlan: [73:E:DP] dp_prealloc_get_coherent: unable to allocate memory for ring type Rxdma_monitor_status (17) size 16384
[  115.099008] [kworke][0x6dab92a][08:42:13.594493] wlan: [73:E:DP] dp_prealloc_get_coherent: unable to allocate memory for ring type Rxdma_monitor_status (17) size 16384
[  115.114413] [kworke][0x6daf557][08:42:13.609898] wlan: [73:E:DP] dp_prealloc_get_coherent: unable to allocate memory for ring type Rxdma_buf (14) size 16384
[  115.128469] [kworke][0x6db2c3f][08:42:13.623955] wlan: [73:E:DP] dp_prealloc_get_coherent: unable to allocate memory for ring type Rxdma_buf (14) size 16384
[  115.165294] [kworke][0x6dbbc18][08:42:13.660779] wlan: [73:E:QDF] hif_pci_irq_set_affinity_hint: Offline CPU: Set affinity fails for IRQ: 81
[  115.177924] [kworke][0x6dbed6d][08:42:13.673409] wlan: [73:E:QDF] hif_pci_irq_set_affinity_hint: Offline CPU: Set affinity fails for IRQ: 81
[  115.190532] [kworke][0x6dc1eae][08:42:13.686018] wlan: [73:E:QDF] hif_pci_irq_set_affinity_hint: Offline CPU: Set affinity fails for IRQ: 81
[  115.203139] [kworke][0x6dc4fed][08:42:13.698624] wlan: [73:E:QDF] hif_pci_irq_set_affinity_hint: Offline CPU: Set affinity fails for IRQ: 81
[  115.215760] [kworke][0x6dc813a][08:42:13.711245] wlan: [73:E:QDF] hif_pci_irq_set_affinity_hint: Offline CPU: Set affinity fails for IRQ: 81
[  115.228379] [kworke][0x6dcb285][08:42:13.723864] wlan: [73:E:QDF] hif_pci_irq_set_affinity_hint: Offline CPU: Set affinity fails for IRQ: 81
[  115.240995] [kworke][0x6dce3cd][08:42:13.736480] wlan: [73:E:QDF] hif_pci_irq_set_affinity_hint: Offline CPU: Set affinity fails for IRQ: 81
[  115.253607] [kworke][0x6dd1511][08:42:13.749093] wlan: [73:E:HIF] hif_pci_ce_irq_set_affinity_hint: Unable to set cpu mask for offline CPU 0
[  115.266217] [kworke][0x6dd4652][08:42:13.761702] wlan: [73:E:HIF] hif_pci_ce_irq_set_affinity_hint: Empty cpu_mask, unable to set CE IRQ affinity
[  115.282028] [kworke][0x6dd8415][08:42:13.777513] wlan: [30:E:QDF] copy_fw_abi_version_tlv: copy_fw_abi_version_tlv: INIT_CMD version: 1, 0, 0x5f414351, 0x4c4d, 0x0, 0x0
[  115.547161] [kworke][0x6e18fc0][08:42:14.042644] wlan: [30:E:QDF] ready_extract_init_status_tlv: ready_extract_init_status_tlv:0
[  115.559548] [kworke][0x6e1c025][08:42:14.055033] wlan: [30:E:CFR] wlan_cfr_pdev_open: cfr is disabled
[  115.569071] [kworke][0x6e1e559][08:42:14.064557] wlan: [30:E:QDF] dp_peer_map_attach_wifi3: dp_peer_map_attach_wifi3 max_peers 39, max_ast_index: 144
[  115.569071] 
[  115.584880] [kworke][0x6e22319][08:42:14.080365] wlan: [73:E:WMI] send_action_oui_cmd_tlv: Invalid action id
[  115.594737] [kworke][0x6e2499a][08:42:14.090222] wlan: [73:E:action_oui] ucfg_action_oui_send: Failed to send: 7
[  115.605355] [kworke][0x6e27314][08:42:14.100839] wlan: [73:E:TXRX] dp_rxdma_ring_config: DBS enabled max_mac_rings 2
[  115.615885] [kworke][0x6e29c36][08:42:14.111370] wlan: [73:E:TXRX] dp_rxdma_ring_config: pdev_id 0 max_mac_rings 2
[  115.626238] [kworke][0x6e2c4a8][08:42:14.121724] wlan: [73:E:TXRX] dp_rxdma_ring_config: mac_id 0
[  115.635175] [kworke][0x6e2e791][08:42:14.130660] wlan: [73:E:TXRX] dp_rxdma_ring_config: mac_id 1
[  115.644524] [kworke][0x6e30c15][08:42:14.140009] wlan: [73:E:REGULATORY] reg_freq_width_to_chan_op_class: no op class for frequency 5660
[  115.657335] cnss_utils: WLAN MAC address is not set, type 0
```



#### 已成功联网但不稳定(2024.1.9)

测试命令：

```bash
sudo ifconfig wlan0 up
sudo wpa_supplicant -B -iwlan0 -c/etc/wpa_supplicant/wpa_supplicant.conf
sudo udhcpc -i wlan0
```



#### connect模式测试

```
root@ubuntu:/home/gie/wlan/with-debug# sudo wpa_supplicant -B -irename9 -c/etc/wp
pa_supplicant/wpa_supplicant.conf
root@ubuntu:/home/gie/wlan/with-debug# sudo udhcpc -i rename9
udhcpc: started, v1.27.2
udhcpc: sending discover
udhcpc: sending select for 192.168.127.174
udhcpc: sending select for 192.168.127.174
udhcpc: lease of 192.168.127.174 obtained, lease time 3599
root@ubuntu:/home/gie/wlan/with-debug# ifconfig 
docker0: flags=4099<UP,BROADCAST,MULTICAST>  mtu 1500
        inet 172.17.0.1  netmask 255.255.0.0  broadcast 172.17.255.255
        ether 02:42:c2:99:b6:43  txqueuelen 0  (Ethernet)
        RX packets 0  bytes 0 (0.0 B)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 0  bytes 0 (0.0 B)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

fm1-mac9: flags=4099<UP,BROADCAST,MULTICAST>  mtu 1500
        ether 82:ed:b4:5b:81:ea  txqueuelen 1000  (Ethernet)
        RX packets 0  bytes 0 (0.0 B)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 0  bytes 0 (0.0 B)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
        device memory 0x1af0000-1af0fff  

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 14  bytes 1726 (1.7 KB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 14  bytes 1726 (1.7 KB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

rename9: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 192.168.127.174  netmask 255.255.255.0  broadcast 192.168.127.255
        inet6 2408:8456:f129:e657:a133:5941:b4e2:72b3  prefixlen 64  scopeid 0x0<global>
        inet6 fe80::ea24:4ff:fe26:1068  prefixlen 64  scopeid 0x20<link>
        inet6 2408:8456:f129:e657:ea24:4ff:fe26:1068  prefixlen 64  scopeid 0x0<global>
        ether e8:24:04:26:10:68  txqueuelen 3000  (Ethernet)
        RX packets 57  bytes 13018 (13.0 KB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 67  bytes 12266 (12.2 KB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

wlx90de804833ef: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 192.168.2.1  netmask 255.255.255.0  broadcast 192.168.2.255
        inet6 fe80::92de:80ff:fe48:33ef  prefixlen 64  scopeid 0x20<link>
        ether 90:de:80:48:33:ef  txqueuelen 1000  (Ethernet)
        RX packets 0  bytes 0 (0.0 B)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 0  bytes 0 (0.0 B)
        TX errors 0  dropped 7 overruns 0  carrier 0  collisions 0

root@ubuntu:/home/gie/wlan/with-debug# ping 192.168.127.174
PING 192.168.127.174 (192.168.127.174) 56(84) bytes of data.
64 bytes from 192.168.127.174: icmp_seq=1 ttl=64 time=0.076 ms
64 bytes from 192.168.127.174: icmp_seq=2 ttl=64 time=0.065 ms
^C
--- 192.168.127.174 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1022ms
rtt min/avg/max/mdev = 0.065/0.070/0.076/0.010 ms
root@ubuntu:/home/gie/wlan/with-debug# po  ^C
root@ubuntu:/home/gie/wlan/with-debug# ping 1 www.baiu du.com
PING www.baidu.com(2408:8756:c52:1107:0:ff:b035:844b (2408:8756:c52:1107:0:ff:b035:844b)) 56 data bytes
64 bytes from 2408:8756:c52:1107:0:ff:b035:844b (2408:8756:c52:1107:0:ff:b035:844b): icmp_seq=1 ttl=52 time=28.4 ms
64 bytes from 2408:8756:c52:1107:0:ff:b035:844b (2408:8756:c52:1107:0:ff:b035:844b): icmp_seq=2 ttl=52 time=57.1 ms
64 bytes from 2408:8756:c52:1107:0:ff:b035:844b (2408:8756:c52:1107:0:ff:b035:844b): icmp_seq=3 ttl=52 time=29.4 ms
64 bytes from 2408:8756:c52:1107:0:ff:b035:844b (2408:8756:c52:1107:0:ff:b035:844b): icmp_seq=4 ttl=52 time=45.3 ms
64 bytes from 2408:8756:c52:1107:0:ff:b035:844b (2408:8756:c52:1107:0:ff:b035:844b): icmp_seq=5 ttl=52 time=34.9 ms
64 bytes from 2408:8756:c52:1107:0:ff:b035:844b (2408:8756:c52:1107:0:ff:b035:844b): icmp_seq=6 ttl=52 time=53.9 ms
64 bytes from 2408:8756:c52:1107:0:ff:b035:844b (2408:8756:c52:1107:0:ff:b035:844b): icmp_seq=7 ttl=52 time=170 ms
64 bytes from 2408:8756:c52:1107:0:ff:b035:844b (2408:8756:c52:1107:0:ff:b035:844b): icmp_seq=8 ttl=52 time=100 ms
64 bytes from 2408:8756:c52:1107:0:ff:b035:844b (2408:8756:c52:1107:0:ff:b035:844b): icmp_seq=9 ttl=52 time=57.3 ms
64 bytes from 2408:8756:c52:1107:0:ff:b035:844b (2408:8756:c52:1107:0:ff:b035:844b): icmp_seq=10 ttl=52 time=48.4 ms
64 bytes from 2408:8756:c52:1107:0:ff:b035:844b (2408:8756:c52:1107:0:ff:b035:844b): icmp_seq=11 ttl=52 time=54.9 ms
64 bytes from 2408:8756:c52:1107:0:ff:b035:844b (2408:8756:c52:1107:0:ff:b035:844b): icmp_seq=12 ttl=52 time=46.6 ms
^C
--- www.baidu.com ping statistics ---
12 packets transmitted, 12 received, 0% packet loss, time 11014ms
rtt min/avg/max/mdev = 28.424/60.636/170.051/37.585 ms
root@ubuntu:/home/gie/wlan/with-debug# ping www.baidu.com -I  rename9
PING www.baidu.com(2408:8756:c52:1aec:0:ff:b013:5a11 (2408:8756:c52:1aec:0:ff:b013:5a11)) from 2408:8456:f129:e657:a133:5941:b4e2:72b3 rename9: 56 data bytes
64 bytes from 2408:8756:c52:1aec:0:ff:b013:5a11 (2408:8756:c52:1aec:0:ff:b013:5a11): icmp_seq=1 ttl=52 time=38.2 ms
64 bytes from 2408:8756:c52:1aec:0:ff:b013:5a11 (2408:8756:c52:1aec:0:ff:b013:5a11): icmp_seq=2 ttl=52 time=44.2 ms
64 bytes from 2408:8756:c52:1aec:0:ff:b013:5a11 (2408:8756:c52:1aec:0:ff:b013:5a11): icmp_seq=3 ttl=52 time=41.0 ms
64 bytes from 2408:8756:c52:1aec:0:ff:b013:5a11 (2408:8756:c52:1aec:0:ff:b013:5a11): icmp_seq=4 ttl=52 time=51.9 ms
^C
--- www.baidu.com ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3003ms
rtt min/avg/max/mdev = 38.222/43.856/51.987/5.149 ms
root@ubuntu:/home/gie/wlan/with-debug# ping www.baidu.com -I wlx90de804833ef
connect: Network is unreachable
root@ubuntu:/home/gie/wlan/with-debug# ping www.baidu.com -I rename9
PING www.baidu.com(2408:8756:c52:1aec:0:ff:b013:5a11 (2408:8756:c52:1aec:0:ff:b013:5a11)) from 2408:8456:f129:e657:a133:5941:b4e2:72b3 rename9: 56 data bytes
64 bytes from 2408:8756:c52:1aec:0:ff:b013:5a11 (2408:8756:c52:1aec:0:ff:b013:5a11): icmp_seq=1 ttl=52 time=338 ms
64 bytes from 2408:8756:c52:1aec:0:ff:b013:5a11 (2408:8756:c52:1aec:0:ff:b013:5a11): icmp_seq=2 ttl=52 time=42.9 ms
64 bytes from 2408:8756:c52:1aec:0:ff:b013:5a11 (2408:8756:c52:1aec:0:ff:b013:5a11): icmp_seq=3 ttl=52 time=1011 ms
64 bytes from 2408:8756:c52:1aec:0:ff:b013:5a11 (2408:8756:c52:1aec:0:ff:b013:5a11): icmp_seq=4 ttl=52 time=42.6 ms
64 bytes from 2408:8756:c52:1aec:0:ff:b013:5a11 (2408:8756:c52:1aec:0:ff:b013:5a11): icmp_seq=5 ttl=52 time=54.6 ms
64 bytes from 2408:8756:c52:1aec:0:ff:b013:5a11 (2408:8756:c52:1aec:0:ff:b013:5a11): icmp_seq=6 ttl=52 time=49.7 ms
64 bytes from 2408:8756:c52:1aec:0:ff:b013:5a11 (2408:8756:c52:1aec:0:ff:b013:5a11): icmp_seq=7 ttl=52 time=58.6 ms
64 bytes from 2408:8756:c52:1aec:0:ff:b013:5a11 (2408:8756:c52:1aec:0:ff:b013:5a11): icmp_seq=8 ttl=52 time=46.5 ms
64 bytes from 2408:8756:c52:1aec:0:ff:b013:5a11 (2408:8756:c52:1aec:0:ff:b013:5a11): icmp_seq=9 ttl=52 time=50.9 ms
^C
--- www.baidu.com ping statistics ---
9 packets transmitted, 9 received, 0% packet loss, time 8013ms
rtt min/avg/max/mdev = 42.679/188.486/1011.969/304.791 ms, pipe 2
root@ubuntu:/home/gie/wlan/with-debug# 
```



#### AP模式测试

自研AMRpingPC端

```bash
root@ubuntu:/home/gie/wlan/with-debug# ifconfig
lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 14  bytes 1726 (1.7 KB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 14  bytes 1726 (1.7 KB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

wlan0: flags=4099<UP,BROADCAST,MULTICAST>  mtu 1500
        ether e8:24:04:26:10:68  txqueuelen 3000  (Ethernet)
        RX packets 0  bytes 0 (0.0 B)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 0  bytes 0 (0.0 B)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

root@ubuntu:/home/gie/wlan/with-debug# cd /root/Net_Tools/
root@ubuntu:~/Net_Tools# ls
wifi_ap.sh  wifi_ap_auto.sh  wifi_connect.sh  wifi_wpa.sh
root@ubuntu:~/Net_Tools# ./wifi_ap_auto.sh
 Begain WiFi AP establish ...
 -----------------------
WiFi AP shared connect to: wlan0
Auto start on power up: ON
 -----------------------
 Wireless point is  wlan0
[  293.481042] [soft_i][0x117d0c9e][07:46:33.245510] wlan: [0:E:DP] dp_peer_unlink_ast_entry: NULL peer
[  293.491022] [schedu][0x117d339e][07:46:33.255494] wlan: [4355:E:DP] dp_tx_flow_pool_vdev_unmap: invalid vdev_id 0
[  293.501300] [schedu][0x117d5bc4][07:46:33.265772] wlan: [4355:E:DP] dp_tx_delete_flow_pool: flow pool either not created or alread deleted
[  295.550306] [kworke][0x119c9fad][07:46:35.314773] wlan: [54:E:HDD] hdd_enable_arp_offload: failed to cache arp offload req; status:4
[  295.567965] [soft_i][0x119ce4ac][07:46:35.332436] wlan: [0:E:DP] dp_peer_unlink_ast_entry: NULL peer
[  295.577383] [schedu][0x119d0977][07:46:35.341855] wlan: [4355:E:DP] dp_tx_flow_pool_vdev_unmap: invalid vdev_id 0
[  295.587759] [schedu][0x119d31ff][07:46:35.352231] wlan: [4355:E:DP] dp_tx_delete_flow_pool: flow pool either not created or alread deleted
[  295.617318] [hostap][0x119da573][07:46:35.381787] wlan: [4482:E:REGULATORY] reg_run_11d_state_machine: Invalid vdev
[  295.696598] [hostap][0x119edb24][07:46:35.461069] wlan: [4482:E:HDD] wlan_hdd_cfg80211_start_bss: beacon protection 1
[  295.707552] [hostap][0x119f05f0][07:46:35.472024] wlan: [4482:E:dfs] WLAN_DEBUG_DFS_ALWAYS : utils_dfs_init_nol: no nol in pld
[  295.719074] [hostap][0x119f32f1][07:46:35.483546] wlan: [4482:E:REGULATORY] reg_freq_to_chan: Invalid freq 0
[  295.729010] [hostap][0x119f59c1][07:46:35.493482] wlan: [4482:E:SME] csr_roam_get_qos_info_from_bss: csr_get_parsed_bss_description_ies() failed
[  295.742147] [schedu][0x119f8d12][07:46:35.506619] wlan: [4355:E:REGULATORY] reg_chan_band_to_freq: Invalid channel 0
[  295.762831] [schedu][0x119fdddd][07:46:35.527301] wlan: [4355:E:WMA] wma_find_remove_req_msgtype: unable to get msg node from request queue
[  295.775365] [schedu][0x11a00ed4][07:46:35.539837] wlan: [4355:E:WMA] wma_peer_create_confirm_handler: vdev:0 Failed to lookup peer create request message
[  295.843951] [soft_i][0x11a11abb][07:46:35.608419] wlan: [0:E:DP] dp_tx_initialize_threshold: tx flow control threshold is set, pool size is 4096
[  295.856960] [hostap][0x11a14d8d][07:46:35.621429] wlan: [4482:E:SAP] wlansap_is_6ghz_included_in_acs_range: NULL parameters
Synchronizing state of hostapd.service with SysV service script with /lib/systemd/systemd-sysv-install.
Executing: /lib/systemd/systemd-sysv-install enable hostapd
Synchronizing state of isc-dhcp-server.service with SysV service script with /lib/systemd/systemd-sysv-install.
Executing: /lib/systemd/systemd-sysv-install enable isc-dhcp-server
 Auto start set ON !!!
 -----------------------
hostapd.service Active:     Active: active (running)
isc-dhcp-server.service Active:     Active: active (running)
root@ubuntu:~/Net_Tools#
root@ubuntu:~/Net_Tools# ifconfig
lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 16  bytes 1804 (1.8 KB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 16  bytes 1804 (1.8 KB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

wlan0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 192.168.2.1  netmask 255.255.255.0  broadcast 192.168.2.255
        inet6 fe80::ea24:4ff:fe26:1068  prefixlen 64  scopeid 0x20<link>
        ether e8:24:04:26:10:68  txqueuelen 3000  (Ethernet)
        RX packets 0  bytes 0 (0.0 B)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 28  bytes 3898 (3.8 KB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

root@ubuntu:~/Net_Tools#
root@ubuntu:~/Net_Tools# [  305.959751] [schedu][0x123b7590][07:46:45.724216] wlan: [4355:E:QDF] qdf_mc_timer_start: Cannot start timer in state = 21 tx_main_timer_func [wlan]

root@ubuntu:~/Net_Tools#
root@ubuntu:~/Net_Tools# [  333.729765] [schedu][0x13e33231][07:47:13.494234] wlan: [4355:E:WMA] wma_find_remove_req_msgtype: target request not found for vdev_id 0 type 4549
[  333.743065] [schedu][0x13e36628][07:47:13.507536] wlan: [4355:E:WMA] wma_peer_create_confirm_handler: vdev:0 Failed to lookup peer create request message
[  333.890331] [schedu][0x13e5a567][07:47:13.654799] wlan: [4355:E:WMA] wma_find_remove_req_msgtype: target request not found for vdev_id 0 type 4549
[  333.903474] [schedu][0x13e5d8c1][07:47:13.667945] wlan: [4355:E:WMA] wma_peer_create_confirm_handler: vdev:0 Failed to lookup peer create request message
[  333.917524] [schedu][0x13e60fa3][07:47:13.681996] wlan: [4355:E:PE] lim_process_assoc_req_frame: STA is initiating Assoc Req after ACK lost. Do not process sessionid: 0 sys sub_type=1 for role=1 from: b4:69:21:c1:be:ca
[  333.944476] [schedu][0x13e678ec][07:47:13.708948] wlan: [4355:E:HDD] hdd_hostapd_sap_event_cb: Failed to find the right station
[  334.865633] [schedu][0x13f4872e][07:47:14.630102] wlan: [4355:E:WMA] wma_find_remove_req_msgtype: target request not found for vdev_id 0 type 4549
[  334.878939] [schedu][0x13f4bb2a][07:47:14.643410] wlan: [4355:E:WMA] wma_peer_create_confirm_handler: vdev:0 Failed to lookup peer create request message
[  336.004588] [schedu][0x1405e839][07:47:15.769058] wlan: [4355:E:WMA] wma_find_remove_req_msgtype: target request not found for vdev_id 0 type 4549
[  336.017995] [schedu][0x14061c9a][07:47:15.782466] wlan: [4355:E:WMA] wma_peer_create_confirm_handler: vdev:0 Failed to lookup peer create request message

root@ubuntu:~/Net_Tools# ping 192.168.2.1
PING 192.168.2.1 (192.168.2.1) 56(84) bytes of data.
64 bytes from 192.168.2.1: icmp_seq=1 ttl=64 time=0.075 ms
64 bytes from 192.168.2.1: icmp_seq=2 ttl=64 time=0.061 ms
^C
--- 192.168.2.1 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1001ms
rtt min/avg/max/mdev = 0.061/0.068/0.075/0.007 ms
root@ubuntu:~/Net_Tools# ping 192.168.2.101
PING 192.168.2.101 (192.168.2.101) 56(84) bytes of data.
64 bytes from 192.168.2.101: icmp_seq=1 ttl=128 time=4.40 ms
64 bytes from 192.168.2.101: icmp_seq=2 ttl=128 time=3.73 ms
64 bytes from 192.168.2.101: icmp_seq=3 ttl=128 time=2.66 ms
64 bytes from 192.168.2.101: icmp_seq=4 ttl=128 time=6.33 ms
^C
--- 192.168.2.101 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3005ms
rtt min/avg/max/mdev = 2.665/4.284/6.330/1.335 ms
root@ubuntu:~/Net_Tools#
```

PC端ping自研AMR

```
[2024-01-09 16:17.12]  ~
[.DESKTOP-5KTBV78] ⮞ ifconfig

Software Loopback Interface 1
        Link encap: Local loopback
        inet addr:127.0.0.1 Mask: 255.0.0.0
        MTU: 1500 Speed:1073.74 Mbps
        Admin status:UP Oper status:OPERATIONAL
        RX packets:0 dropped:0 errors:0 unkown:0
        TX packets:0 dropped:0 errors:0 txqueuelen:0

VMware Virtual Ethernet Adapter for VMnet8
        Link encap: Ethernet HWaddr: 00-50-56-C0-00-08
        inet addr:192.168.10.1 Mask: 255.255.255.0
        MTU: 1500 Speed:100.00 Mbps
        Admin status:UP Oper status:OPERATIONAL
        RX packets:27166 dropped:0 errors:0 unkown:0
        TX packets:29822 dropped:0 errors:0 txqueuelen:0

Intel(R) Wireless-AC 9462
        Link encap: IEEE 802.11 HWaddr: B4-69-21-C1-BE-CA
        inet addr:192.168.2.101 Mask: 255.255.255.0
        MTU: 1500 Speed:45.00 Mbps
        Admin status:UP Oper status:OPERATIONAL
        RX packets:11 dropped:0 errors:0 unkown:0
        TX packets:364 dropped:0 errors:0 txqueuelen:0

VMware Virtual Ethernet Adapter for VMnet1
        Link encap: Ethernet HWaddr: 00-50-56-C0-00-01
        inet addr:192.168.152.1 Mask: 255.255.255.0
        MTU: 1500 Speed:100.00 Mbps
        Admin status:UP Oper status:OPERATIONAL
        RX packets:24 dropped:0 errors:0 unkown:0
        TX packets:2539 dropped:0 errors:0 txqueuelen:0

                                                                                                                                                                ✓
─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
[2024-01-09 16:17.14]  ~
[.DESKTOP-5KTBV78] ⮞ ping 192.168.2.1

正在 Ping 192.168.2.1 具有 32 字节的数据:
来自 192.168.2.1 的回复: 字节=32 时间=5ms TTL=64
来自 192.168.2.1 的回复: 字节=32 时间=9ms TTL=64
来自 192.168.2.1 的回复: 字节=32 时间=10ms TTL=64
来自 192.168.2.1 的回复: 字节=32 时间=3ms TTL=64

192.168.2.1 的 Ping 统计信息:
    数据包: 已发送 = 4，已接收 = 4，丢失 = 0 (0% 丢失)，
往返行程的估计时间(以毫秒为单位):
    最短 = 3ms，最长 = 10ms，平均 = 6ms
```



### 八.更新驱动到对应目录

源码上其实有安装驱动文件到对应目录这一步操作，但是一直没有安装，找到驱动文件原本的目录如下：

|                        | with-debug | without-debug |
| ---------------------- | ---------- | ------------- |
| wlan.ko                | 1）389M    | 2）12M        |
| wlan_cnss_core_pcie.ko | 3）9.4M    | 4）505K       |

1）389M

```
./chss_proc/host/AIO/drivers/qcacld-3.0/wlan.ko
./chss_proc/host/AIO/rootfs-ve-f10.build/lib/unstripped_modules/modules/wlan.ko
```

2）12M

```
./chss_proc/host/AIO/rootfs-ve-f10.build/lib/modules/wlan.ko
```

3）9.4M

```
./chss_proc/host/AIO/drivers/core_tech_modules/wlan_cnss_core_pcie.ko
./chss_proc/host/AIO/rootfs-ve-f10.build/lib/unstripped_modules/modules/wlan_cnss_core_pcie.ko
```

4）505K

```
./chss_proc/host/AIO/rootfs-ve-f10.build/lib/modules/wlan_cnss_core_pcie.ko
```

编译主机上目标目录：

```
/home/forlinx/nxp/extra/wlan/with-debug
/home/forlinx/nxp/extra/wlan/without-debug
```

文件系统上目录：

```
/home/gie/wlan
```

根据以上目录已经编写完脚本了，存放在flexbuild_lsdk1906/build/rfs下，之后直接运行两个脚本即可



