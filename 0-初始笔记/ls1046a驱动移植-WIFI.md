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

   ```
   cp -r ./chss_host_LEA/chss_proc/host/AIO/drivers/core_tech_modules/cnss2/cnss2.h /home/forlinx/nxp/flexbuild_lsdk1906/packages/linux/linux/include/net
   ```
   ```
   cp -r ./chss_host_LEA/chss_proc/host/AIO/drivers/core_tech_modules/inc/qcn_sdio_al.h /home/forlinx/nxp/flexbuild_lsdk1906/packages/linux/linux/include/net
   ```
   ```
   cp -r ./chss_host_LEA/chss_proc/host/AIO/drivers/core_tech_modules/cnss_utils/cnss_utils.h /home/forlinx/nxp/flexbuild_lsdk1906/packages/linux/linux/include/net
   ```

### 二.  下载和应用Linux内核补丁

貌似这个是给主机ubuntu平台使用的，主要是安装其他的内核版本比如4.9、5.4、5.10之类的，然后重启配置双内核，再将头文件拷贝到内核目录进行编译

由于使用交叉编译，暂时不做这个步骤



### 三. 配置编译环境

1. 进入目录

   ```
   cd ./chss_host_LEA/chss_proc/host/AIO/build/scripts/ve-f10
   ```

2. 修改KERNELPATH, KERNELARCH, TOOLPREFIX

   ```
   vim config.ve-f10
   ```

   修改如下

   ```
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

   ```
   cd ./chss_host_LEA/chss_proc/host/AIO/build
   ```

2. 编译wlan_cnss_core_pcie.ko

   

报错如下：

```
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

```
LD [M]  /home/forlinx/wifi/fc6xe/WiFi/chss_host_LEA/chss_proc/host/AIO/drivers/core_tech_modules/wlan_cnss_core_pcie.o
  Building modules, stage 2.
  MODPOST 1 modules
WARNING: "vfs_write" [/home/forlinx/wifi/fc6xe/WiFi/chss_host_LEA/chss_proc/host/AIO/drivers/core_tech_modules/wlan_cnss_core_pcie.ko] undefined!
  CC      /home/forlinx/wifi/fc6xe/WiFi/chss_host_LEA/chss_proc/host/AIO/drivers/core_tech_modules/wlan_cnss_core_pcie.mod.o
  LD [M]  /home/forlinx/wifi/fc6xe/WiFi/chss_host_LEA/chss_proc/host/AIO/drivers/core_tech_modules/wlan_cnss_core_pcie.ko
```



编译wlan.ko报错如下

```
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

```
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

```
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
[Quectel]: 在内核中，关闭宏CONFIG_ARCH_QCOM

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

```
mkdir -p /home/forlinx/wifi/fc6xe/WiFi/chss_host_LEA/chss_proc/host/AIO/build/../drivers/firmware/WLAN-firmware
```

```
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

```
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

```
$ git clone git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
$ cd linux-stable-rc
$ git checkout v4.9.11
```

步骤2:执行如下命令下载Linux内核补丁。

```
$ git clone git://codeaurora.org/external/sba/wlan_patches.git -b master wlan_patches
```

补充，上方已经无法下载代码，使用如下链接：

```
$ git clone https://git.codelinaro.org/clo/sba-patches/wlan_patches.git
```

步骤3:执行如下命令，应用下载的补丁。

```
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

```
$ cd linux-stable
$ make menuconfig
```

然后在弹出的内核配置窗口中选择以下选项。

```
save > ok > exit
load > ok > exit -> yes
```

2)修改内核配置文件。

```
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

```
$ sudo make-kpkg -j4 --initrd kernel_image kernel_headers
```

生成的映像自动存储在内核源代码的上层目录中。

步骤5:执行如下命令安装Linux内核。

```
$ sudo dpkg -i linux-image-4.9.11+_4.9.11+-10.00.Custom_amd64.deb
$ sudo dpkg -i linux-headers-4.9.11+_4.9.11+-10.00.Custom_amd64.deb
```

步骤6:重启安装了4.9.11内核的主机。您可能需要更新GRUB配置以允许引导多个内核。

#### 5.3 构建Wi-Fi驱动程序

##### 5.3.1  获取模块Wi-Fi源代码

从https://git-master.quectel.com/wifi.bt/fc6xe获取模块Wi-Fi源代码。

##### 5.3.2 将文件复制到内核

执行以下命令将AIO/drivers/core_tech_modules下相应文件夹中的cnss2.h、qcn_sdio_al.h和cnss_utils.h复制到<kernelpath>/include/net/ of kernel。

```
$ sudo cp -r AIO/drivers/core_tech_modules/cnss2/cnss2.h <kernelpath>/include/net/
$ sudo cp -r AIO/drivers/core_tech_modules/inc/qcn_sdio_al.h <kernelpath>/include/net/
$ sudo cp -r AIO/drivers/core_tech_modules/cnss_utils/cnss_utils.h <kernelpath>/include/net/
```

例如，Linux内核版本为4.9.11，则<kernelpath>可以设置为/lib/modules/4.9.11+/build。

##### 5.3.3 编译Wi-Fi驱动程序

以X86为例，执行如下命令编译Wi-Fi驱动。

```
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

```
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

```
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

```
$ lspci
0000:00:00.0 PCI bridge: Freescale Semiconductor Inc Device 81c0 (rev 10)
0001:00:00.0 PCI bridge: Freescale Semiconductor Inc Device 81c0 (rev 10)
0001:01:00.0 Network controller: Qualcomm Device 1103 (rev 01)
```

make[2]: Entering directory '/home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel'
make[3]: Entering directory '/home/forlinx/work/OK10xx-linux-fs/flexbuild/build/linux/linux/arm64/output'



自研使用的是lsk1906，生成的驱动无法在飞凌上使用

```
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

```
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

```
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

```
switch (event_data->uevent) {
	case PLD_FW_DOWN:
		hdd_debug("Received firmware down indication");
		hdd_dump_log_buffer();
		cds_set_target_ready(false);
		cds_set_recovery_in_progress(true);
```

fc6xe/WiFi/chss_host_LEA/chss_proc/host/AIO/drivers/qcacld-3.0/core/hdd/src/wlan_hdd_wext.c

```
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

```
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

```
cp  /lib/udev/rules.d/80-net-setup-link.rules   /etc/udev/rules.d/
```

然后执行如下命令，修改刚才复制过来的80-net-setup-link.rules文件：

```
sudo vim /etc/udev/rules.d/80-net-setup-link.rules
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

```
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

```
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







