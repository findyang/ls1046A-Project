内容使用主要来源：

- ls1046A提供的u-boot18.03
- 网络文章
- 标准的u-boot18.03



## 一切的开始：Start.S

[Uboot中start.S源码的指令级的详尽解析 (crifan.com)](https://www.crifan.com/files/doc/docbook/uboot_starts_analysis/release/htmls/)





## bring up

作者：嵌入式艺术
链接：https://www.zhihu.com/question/23283190/answer/3170846556
来源：知乎
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。

[U-Boot 之五 详解 U-Boot 及 SPL 的启动流程 (360doc.com)](http://www.360doc.com/content/22/0315/17/21412_1021658698.shtml)

[U-Boot 之五 详解 U-Boot 及 SPL 的链接脚本、启动流程_uboot链接脚本_ZC·Shou的博客-CSDN博客](https://itexp.blog.csdn.net/article/details/121925283)

> SPL的目标是在引导设备上运行的第一个程序，通常它会在DRAM尚未初始化的情况下执行，因此它的代码非常精简，仅包含必要的引导和初始化代码。完成初始化后，SPL会将控制权传递给完整版本的U-Boot。

`SOC (System on a Chip) bring-up`是一个复杂的过程，涉及到硬件、[固件](https://www.zhihu.com/search?q=固件&search_source=Entity&hybrid_search_source=Entity&hybrid_search_extra={"sourceType"%3A"answer"%2C"sourceId"%3A3170846556})和软件的集成和验证，以下是一个基于`BROM`，`SPL`，`UBOOT`和`Linux`的启动流程的概述：

1. **`BROM (Boot Read-Only Memory)`启动**：启动的最初阶段，在这个阶段，系统会执行芯片`ROM`里面的代码，这部分代码主要用来检查启动模式，包括`NOR`、`Nand`、`Emmc`等，然后从对应的存储介质中加载`SPL(Secondary Program Loader)`代码。
2. **`SPL (Secondary Program Loader)`启动**：`SPL`属于`Uboot`的一部分，它的主要作用就是：**初始化硬件并加载完整的`U-boot`**，主要体现在初始化时钟、[看门狗](https://www.zhihu.com/search?q=看门狗&search_source=Entity&hybrid_search_source=Entity&hybrid_search_extra={"sourceType"%3A"answer"%2C"sourceId"%3A3170846556})、`DDR`、`GPIO`以及存储外设，最后将`U-boot`代码加载到`DDR`中执行。
3. **`U-Boot`启动**：`U-boot`的主要作用是：引导加载`Kernel`和`DTS`。`U-boot`在启动之后，同样初始化`Soc`硬件资源，然后会计时等待，并执行默认的启动命令，将`Kernel`和`DTS`信息从存储介质中读取出来并加载到内存中执行。
4. **`Kernel`启动**：在`U-Boot`加载了内核映像和[设备树](https://www.zhihu.com/search?q=设备树&search_source=Entity&hybrid_search_source=Entity&hybrid_search_extra={"sourceType"%3A"answer"%2C"sourceId"%3A3170846556})之后，系统会启动`Linux`。在这个阶段，系统会初始化各种硬件设备，加载[驱动程序](https://www.zhihu.com/search?q=驱动程序&search_source=Entity&hybrid_search_source=Entity&hybrid_search_extra={"sourceType"%3A"answer"%2C"sourceId"%3A3170846556})并启动[用户空间](https://www.zhihu.com/search?q=用户空间&search_source=Entity&hybrid_search_source=Entity&hybrid_search_extra={"sourceType"%3A"answer"%2C"sourceId"%3A3170846556})应用程序。

`Q`：为什么上一个阶段已经初始化了硬件资源，[下一个阶段](https://www.zhihu.com/search?q=下一个阶段&search_source=Entity&hybrid_search_source=Entity&hybrid_search_extra={"sourceType"%3A"answer"%2C"sourceId"%3A3170846556})为何重复初始化？

`A`：

1.  每个阶段的硬件初始化，其目标和需求都不同，[硬件配置](https://www.zhihu.com/search?q=硬件配置&search_source=Entity&hybrid_search_source=Entity&hybrid_search_extra={"sourceType"%3A"answer"%2C"sourceId"%3A3170846556})也会不一样，因此在不同阶段进行不同的初始化。
    
2.  硬件状态可能会改变，在`SOC`启动过程中，硬件状态可能会因为[电源管理](https://www.zhihu.com/search?q=电源管理&search_source=Entity&hybrid_search_source=Entity&hybrid_search_extra={"sourceType"%3A"answer"%2C"sourceId"%3A3170846556})、时钟管理等原因而改变，这可能需要在每个阶段都重新[初始化](https://www.zhihu.com/search?q=初始化&search_source=Entity&hybrid_search_source=Entity&hybrid_search_extra={"sourceType"%3A"answer"%2C"sourceId"%3A3170846556})以确保其正确工作
    
3.  为了保证硬件资源的可靠性，最好每个阶段都重新初始化一次

`Q`：`U-boot`加载[内核](https://www.zhihu.com/search?q=内核&search_source=Entity&hybrid_search_source=Entity&hybrid_search_extra={"sourceType"%3A"answer"%2C"sourceId"%3A3170846556})时，会进行重定位的操作，这一操作有何意义？

`A`：

1. `U-boot`的重定位，主要作用是为了 **给内核提供一个连续的、大的内存空间，供内核和其他应用程序使用**
2. `U-boot`的加载过程分两个阶段，即：`SPL`和`U-boot`，
3. 在`SPL`阶段，主要将`U-boot`代码从`Flash`中加载到`RAM`指定位置
4. 在`U-boot`阶段，`U-boot`会将自身从`RAM`的开始部分移动到`RAM`的末尾，占用高[地址空间](https://www.zhihu.com/search?q=地址空间&search_source=Entity&hybrid_search_source=Entity&hybrid_search_extra={"sourceType"%3A"answer"%2C"sourceId"%3A3170846556})，从而让[低地址空间](https://www.zhihu.com/search?q=低地址空间&search_source=Entity&hybrid_search_source=Entity&hybrid_search_extra={"sourceType"%3A"answer"%2C"sourceId"%3A3170846556})可以作为一个连续的，大的[内存空间](https://www.zhihu.com/search?q=内存空间&search_source=Entity&hybrid_search_source=Entity&hybrid_search_extra={"sourceType"%3A"answer"%2C"sourceId"%3A3170846556})供内核和其他应用程序使用。 

`Q`：在`Bring Up`中，为了保证启动时间，如何裁剪？

`A`：

> 启动时间的裁剪是一个重要的步骤，其主要目标是缩短从电源打开到[操作系统](https://www.zhihu.com/search?q=操作系统&search_source=Entity&hybrid_search_source=Entity&hybrid_search_extra={"sourceType"%3A"answer"%2C"sourceId"%3A3170846556})完全启动的时间。

1. 优化`Bootloader`：减小`Bootloader`的代码大小，减少硬件初始化（只初始化必要硬件设备）等
2. 优化`Kernel`：减少启动服务数量，优化服务的启动顺序，使用[预加载技术](https://www.zhihu.com/search?q=预加载技术&search_source=Entity&hybrid_search_source=Entity&hybrid_search_extra={"sourceType"%3A"answer"%2C"sourceId"%3A3170846556})等方法来实现。
3. 使用[快速启动模式](https://www.zhihu.com/search?q=快速启动模式&search_source=Entity&hybrid_search_source=Entity&hybrid_search_extra={"sourceType"%3A"answer"%2C"sourceId"%3A3170846556})：一些`SOC`支持快速启动模式，这种模式下，`SOC`会跳过一些不必要的硬件初始化和自检过程，从而更快地启动。
4. 使用[休眠和唤醒技术](https://www.zhihu.com/search?q=休眠和唤醒技术&search_source=Entity&hybrid_search_source=Entity&hybrid_search_extra={"sourceType"%3A"answer"%2C"sourceId"%3A3170846556})：一些`SOC`还支持休眠和唤醒技术，这种技术可以将系统的状态保存到[非易失性存储器](https://www.zhihu.com/search?q=非易失性存储器&search_source=Entity&hybrid_search_source=Entity&hybrid_search_extra={"sourceType"%3A"answer"%2C"sourceId"%3A3170846556})中，然后关闭系统。当系统再次启动时，可以直接从非易失性存储器中恢复系统的状态，从而更快地启动。

## 如何实现敲击键盘后，进入uboot命令行

在 U-Boot 中，通常会在串口终端上监听特定的触发字符或组合键，以确定是否进入命令行模式。这些触发字符或组合键通常是事先定义好的，它们的输入会告诉 U-Boot 开发者或操作者系统已准备好进入命令行模式。

以下是一般情况下实现敲击键盘后进入命令行模式的步骤：

1. **终端连接**：首先，需要通过串口终端或其他合适的终端连接到嵌入式系统，以便进行交互。
2. **命令行触发**：某些版本的U-Boot或配置选项允许用户通过敲击特定的键或组合键来触发命令行模式。例如，常见的触发方式是敲击 `Ctrl + C` 或其他特定组合键。
3. **命令行界面**：一旦触发了命令行模式，U-Boot可能会进入一个简单的命令行界面，允许用户输入命令和配置选项。这个命令行界面通常提供了一些基本的U-Boot命令，允许用户执行引导、烧录固件、设置环境变量等操作。
4. **命令处理**：U-Boot会解析用户输入的命令，并执行相应的操作。这些命令通常用于配置U-Boot的行为、加载内核、引导操作系统或进行其他系统管理任务。
5. **退出命令行模式**：用户可以执行特定的命令来退出命令行模式并继续引导操作系统。通常，这个命令是 `boot` 或类似的命令。

U-Boot的配置和触发方式通常在 U-Boot 的源代码中进行定义和配置。以下是一些常见的 U-Boot 配置文件和源代码文件，其中包含触发方式和命令行模式相关的设置：

1. **include/configs 目录**：在这个目录下，您会找到针对不同嵌入式平台的配置文件，例如 `boardname.h`。这些文件包含了与特定平台相关的配置选项，包括触发方式和命令行模式的设置。
2. **common/cmd_bootmenu.c**：这个源代码文件通常包含了与启动菜单（boot menu）和交互方式相关的代码。启动菜单是一个在命令行模式下显示可用引导选项的功能，用户可以选择其中一个引导选项。触发启动菜单的方式通常在这个文件中配置。
3. **common/main.c**：这个源代码文件包含了 U-Boot 的主要启动代码，包括命令行模式的初始化。在这里，您可能会找到触发命令行模式的条件和方式的代码。
4. **include/configs/configname.h**：与特定平台或配置相关的配置文件，例如 `include/configs/imx6ul.h`。在这些文件中，可能会定义触发方式、环境变量和启动参数等。
5. **common/autoboot.c**：这个源代码文件包含了 U-Boot 的自动引导（autoboot）逻辑。在这里，您可能会找到配置自动引导的选项，包括超时触发命令行模式的设置。

在`common/main.c`中存在函数

```
/* We come here after U-Boot is initialised and ready to process commands */
void main_loop(void)
```

调用顺序

void main_loop(void)

autoboot_command(s);

void autoboot_command(const char *s)

run_command_list(s, -1, 0);

OK10xx-linux-uboot\common\cli.c源码中第74行run_command_list函数内的代码

```
need_buff = strchr(cmd, '\n') != NULL;
```

[uboot启动流程之进uboot命令行和启动内核_autoboot_command_还行吧xj的博客-CSDN博客](https://blog.csdn.net/xiongjiao0610/article/details/83107082)



## uboot各种文件代表的含义以及文件的生成

1. `u-boot`：这是U-Boot引导加载程序的主要可执行文件。它包含了U-Boot的核心功能，可以用于启动设备和执行U-Boot脚本。
2. `u-boot.bin`：这通常是U-Boot的二进制可执行文件版本。
3. `u-boot.cfg`：这是U-Boot的配置文件，其中包含了各种配置选项，例如启动参数、环境变量等。
4. `u-boot.cfg.configs`：这可能包含U-Boot的一些配置信息，用于不同的编译选项或目标。
5. `u-boot.dtb`：这是设备树二进制文件，用于描述硬件平台的配置和设备信息。
6. `u-boot.elf`：这是U-Boot的可执行ELF格式文件，通常用于调试和符号信息。
7. `u-boot.img`：这可能是U-Boot的镜像文件，用于在设备上烧录U-Boot。
8. `u-boot.lds`：这是U-Boot的链接脚本文件，用于定义可执行文件的链接。
9. `u-boot.map`：这是U-Boot的符号地图文件，包含了可执行文件中的符号和地址信息。
10. `u-boot.srec`：这是U-Boot的S-Record格式文件，用于将可执行文件加载到设备中。
11. `u-boot.sym`：这是U-Boot的符号文件，包含了可执行文件的符号信息。
12. `u-boot-dtb.bin`：这可能是包含设备树二进制数据的U-Boot版本。
13. `u-boot-dtb.img`：这可能是包含设备树数据的U-Boot镜像文件。
14. `u-boot-elf.o`：这可能是U-Boot的ELF格式对象文件，通常用于调试。
15. `u-boot-nodtb.bin`：这是一个不包含设备树数据的U-Boot二进制文件。
16. `u-boot-with-spl.bin`：这是U-Boot和SPL（Secondary Program Loader）的组合二进制文件。
17. `u-boot-with-spl-pbl.bin`：这是U-Boot、SPL和PBL（Primary Boot Loader）的组合二进制文件。

==具体的如何生成由相应的cmd文件来描述==

> 在U-Boot项目中，`.cmd` 文件通常用于存储Makefile规则的片段或者变量定义。这些文件通常不是主要的Makefile文件，而是在构建过程中被包含或引用的辅助文件。它们的名称以`.cmd` 结尾可能是为了表示它们包含一些命令（commands）或规则（rules）。
>
> 主要的Makefile文件通常命名为`Makefile` 或 `makefile`，而`.cmd` 文件通常包含特定于某个目标的规则或变量。这种组织方式有助于将构建系统模块化，以便更容易地维护和扩展。

例如.u-boot-dtb.bin.cmd文件的内容是

```
cmd_u-boot-dtb.bin := cat u-boot-nodtb.bin dts/dt.dtb > u-boot-dtb.bin
```

