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

#### 一. 拷贝文件到内核头文件目录

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
   cp -r ./chss_host_LEA/chss_proc/host/AIO/drivers/core_tech_modules/cnss2/cnss2.h /home/forlinx/nxp/flexbuild_lsdk1906/packages/linux/linux/include/net
   ```

### 二. 下载和应用Linux内核补丁

貌似这个是给主机ubuntu平台使用的，主要是安装其他的内核版本比如4.9、5.4、5.10之类的，然后重启配置双内核，再将头文件拷贝到内核目录进行编译

由于使用交叉编译，暂时不做这个步骤



### 三.配置编译环境

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
   export TOOLPREFIX=${CROSS_COMPILE
   ```





### 四.编译Wi-Fi Driver

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













