内容使用主要来源：

- ls1046A提供的u-boot18.03
- 网络文章
- 标准的u-boot18.03
- ls1046A提供的lsdk

更多推荐：

`uboot代码详细分析.pdf`（虽然版本比较老）



## 掌握基本的汇编指令

1. **加载和存储数据**：
   - `LDR`（Load Register）：从内存中加载数据到寄存器。
   - `STR`（Store Register）：将寄存器中的数据存储到内存中。
   - `ADR`（Address Register）：一条小范围的地址读取伪指令,它将基于PC的相对偏移的地址值读到目标寄存器中。
2. **算术和逻辑操作**：
   - `ADD`（Addition）：加法操作。
   - `SUB`（Subtraction）：减法操作。
   - `MUL`（Multiply）：乘法操作。
   - `DIV`（Division）：除法操作。
   - `AND`（Bitwise AND）：按位与操作。
   - `ORR`（Bitwise OR）：按位或操作。
   - `EOR`（Exclusive OR）：按位异或操作。
   - `LSL`（Logical Shift Left）：逻辑左移。
   - `LSR`（Logical Shift Right）：逻辑右移。
3. **分支和跳转**：
   - `B`（Branch）：无条件分支。
   - `BEQ`（Branch if Equal）：等于条件分支。
   - `BNE`（Branch if Not Equal）：不等条件分支。
   - `BL`（Branch with Link）：带链接的分支，通常用于函数调用。
4. **堆栈操作**：
   - `PUSH`：将寄存器值压入堆栈。
   - `POP`：从堆栈中弹出值到寄存器。
5. **比较和测试**：
   - `CMP`（Compare）：比较操作，通常与条件分支一起使用。
   - `TST`（Test）：与零比较，通常与条件分支一起使用。
6. **加载地址**：
   - `LDR`：加载地址到寄存器。
7. **设置标志位**：
   - `SET`：设置条件标志位。
8. **系统调用**：
   - `SWI`（Software Interrupt）：触发软件中断，通常用于系统调用。

9. 其他说明

   - `.global` 声明一个符号可被其他文档引用，相当于声明了一个全局变量，.globl 和.global 相同。

   - `.word` 伪操作用于分配一段字内存单元（分配的单元都是字对齐的），并用伪操作中的 expr 初始化。.long 和.int 作用与之相同。

   -  `.align` 伪操作用于表示对齐方式：通过添加填充字节使当前位置满足一定的对齐方式。.balign 的作用同.align。

   - B 转移指令，跳转到指令中指定的目的地址；BL 带链接的转移指令，像 B 相同跳转并把转移后面紧接的一条指令地址保存到链接寄存器 LR（R14）中，以此来完成子程式的调用

   - `.quad` 指令通常用于定义整数、浮点数、地址或其他 64 位数据类型。

   - `.macro` 指令用于开始定义一个宏。

   - `.endm` 指令用于结束宏定义块。

     

## 一切的开始：Start.S

[Uboot中start.S源码的指令级的详尽解析 (crifan.com)](https://www.crifan.com/files/doc/docbook/uboot_starts_analysis/release/htmls/)



## Uboot常用命令汇总

[史上最全的Uboot常用命令汇总（超全面！超详细！）收藏这一篇就够了_uboat控制台代码_万里羊的博客-CSDN博客](https://blog.csdn.net/weixin_44895651/article/details/108211268)

[uboot启动内核的相关命令详解——boot、bootm_正在起飞的蜗牛的博客-CSDN博客](https://blog.csdn.net/weixin_42031299/article/details/121318451)

`sf probe`是用来探测flash设备的，在使用的时候可以直接使用`sf probe`后面不加参数也可以。

[uboot 下nor flash 读写命令使用和验证方法_田园诗人之园的博客-CSDN博客](https://blog.csdn.net/u014100559/article/details/128667071)

[uboot 命令使用(3)_uboot查看硬盘命令-CSDN博客](https://blog.csdn.net/weixin_43096766/article/details/127833475)

## bring up

作者：嵌入式艺术
链接：https://www.zhihu.com/question/23283190/answer/3170846556
来源：知乎
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。

[U-Boot 之五 详解 U-Boot 及 SPL 的启动流程 (360doc.com)](http://www.360doc.com/content/22/0315/17/21412_1021658698.shtml)

[U-Boot 之五 详解 U-Boot 及 SPL 的链接脚本、启动流程_uboot链接脚本_ZC·Shou的博客-CSDN博客](https://itexp.blog.csdn.net/article/details/121925283)

> SPL的目标是在引导设备上运行的第一个程序，通常它会在DRAM尚未初始化的情况下执行，因此它的代码非常精简，仅包含必要的引导和初始化代码。完成初始化后，SPL会将控制权传递给完整版本的U-Boot。

`SOC (System on a Chip) bring-up`是一个复杂的过程，涉及到硬件、固件和软件的集成和验证，以下是一个基于`BROM`，`SPL`，`UBOOT`和`Linux`的启动流程的概述：

1. **`BROM (Boot Read-Only Memory)`启动**：启动的最初阶段，在这个阶段，系统会执行芯片`ROM`里面的代码，这部分代码主要用来检查启动模式，包括`NOR`、`Nand`、`Emmc`等，然后从对应的存储介质中加载`SPL(Secondary Program Loader)`代码。
2. **`SPL (Secondary Program Loader)`启动**：`SPL`属于`Uboot`的一部分，它的主要作用就是：**初始化硬件并加载完整的`U-boot`**，主要体现在初始化时钟、看门狗、`DDR`、`GPIO`以及存储外设，最后将`U-boot`代码加载到`DDR`中执行。
3. **`U-Boot`启动**：`U-boot`的主要作用是：引导加载`Kernel`和`DTS`。`U-boot`在启动之后，同样初始化`Soc`硬件资源，然后会计时等待，并执行默认的启动命令，将`Kernel`和`DTS`信息从存储介质中读取出来并加载到内存中执行。
4. **`Kernel`启动**：在`U-Boot`加载了内核映像和设备树之后，系统会启动`Linux`。在这个阶段，系统会初始化各种硬件设备，加载驱动程序并启动用户空间应用程序。

`Q`：为什么上一个阶段已经初始化了硬件资源，下一个阶段为何重复初始化？

`A`：

1.  每个阶段的硬件初始化，其目标和需求都不同，硬件配置也会不一样，因此在不同阶段进行不同的初始化。
    
2.  硬件状态可能会改变，在`SOC`启动过程中，硬件状态可能会因为电源管理、时钟管理等原因而改变，这可能需要在每个阶段都重新`初始化`以确保其正确工作
    
3.  为了保证硬件资源的可靠性，最好每个阶段都重新初始化一次

`Q`：`U-boot`加载[内核](https://www.zhihu.com/search?q=内核&search_source=Entity&hybrid_search_source=Entity&hybrid_search_extra={"sourceType"%3A"answer"%2C"sourceId"%3A3170846556})时，会进行重定位的操作，这一操作有何意义？

`A`：

1. `U-boot`的重定位，主要作用是为了 **给内核提供一个连续的、大的内存空间，供内核和其他应用程序使用**
2. `U-boot`的加载过程分两个阶段，即：`SPL`和`U-boot`，
3. 在`SPL`阶段，主要将`U-boot`代码从`Flash`中加载到`RAM`指定位置
4. 在`U-boot`阶段，`U-boot`会将自身从`RAM`的开始部分移动到`RAM`的末尾，占用高地址空间，从而让低地址空间可以作为一个连续的，大的内存空间供内核和其他应用程序使用。 

`Q`：在`Bring Up`中，为了保证启动时间，如何裁剪？

`A`：

> 启动时间的裁剪是一个重要的步骤，其主要目标是缩短从电源打开到操作系统完全启动的时间。

1. 优化`Bootloader`：减小`Bootloader`的代码大小，减少硬件初始化（只初始化必要硬件设备）等
2. 优化`Kernel`：减少启动服务数量，优化服务的启动顺序，使用预加载技术等方法来实现。
3. 使用快速启动模式：一些`SOC`支持快速启动模式，这种模式下，`SOC`会跳过一些不必要的硬件初始化和自检过程，从而更快地启动。
4. 使用休眠和唤醒技术：一些`SOC`还支持休眠和唤醒技术，这种技术可以将系统的状态保存到非易失性存储器中，然后关闭系统。当系统再次启动时，可以直接从非易失性存储器中恢复系统的状态，从而更快地启动。

## uboot的入口和出口

uboot的入口和出口。uboot的入口就是开机自动启动，uboot的唯一出口就是启动内核。uboot还可以执行很多别的任务(譬如烧录系统)，但是其他任务执行完后都可以回到uboot的命令行继续执行uboot命令，而启动内核命令一旦执行就回不来了。 总结：一切都是为了启动内核

## SD卡烧录现象

如果出现烧录只显示一小部分信息，可能是SD某个引脚的电平问题，

```
SD卡座设计的不支持热插拔，所以SD卡座DETECT引脚一直高电平，主芯片认为没有SD卡接入，所以一直没读数据。
在启动时不能动SD卡，一 动就会启动不起来 ，因为读数据会中断 
```

当SD卡里烧录好了镜像后，将拨码开关打到SD的启动RCW，然后上电即可在串口终端显示信息

## 描述各种初始化函数的跳转关系和逻辑

armv7架构

1. 上电运行`arch/arm/cpu/armv7/start.S`，在这里面执行以下：

   - CPU 设为 SVC 模式，关中断（IRQ 和 FIR），关 MMU，关看门狗等；
   - 执行 `bl cpu_init_crit`，跳到同目录下的`lowlevel_init.S`，再跳到 `同目录/mx6/soc.c`的`s_init()`进行时钟等检查和设置；
   - 执行 `bl _main`，跳到 `arch/arm/lib/crt0.S`的`_main`。

2. 在`arch/arm/lib/crt0.S`，`_main`里面执行以下：

   - 设置栈 stack_setup；为 C 环境做准备；清除 BSS 段；
   - 执行 `board_init_f`，（第一次初始化）基本硬件初始化，如时钟、内存和串口等，这个函数可能位于 `board/<公司名>/<板子名>/<板子名>.c` 文件里或者位于`common/board_f.c`文件里，其里面的宏定义在其对应的头文件里 `include/configs/<板子名>.h`；

   - 调用重定位 `relocate_code`，源码位于`arch/arm/cpu/armv7/start.S`，（第一次搬移）u-boot 自搬到内存 ；
   - 执行 `board_init_r`，（第二次初始化）对外设的初始化，位于 `common/board_r.c`，初始化 `init_sequence_r` 列表中的初始化函数，最后调用`run_main_loop()`，其再调用 `common/main.c`里的`main_loop()`。

3. 进入 `common/main.c`，`main_loop()`，延迟`bootdelay_process()`，若无输入则进入自启动 `autoboot_command()`，若有输入则进入交互模式 `cli_secure_boot_cmd()`；

4. 根据命令或自启动流程，若要 boot 进入系统，跳到 `cmd/bootm.c` 的 `do_bootm()`，再调用同文件的 `do_bootm_subcommand()`，调用 `common/bootm.c` 里的 `do_bootm_states()`，在这里面检测是否有 OS，是什么 OS，如果有 Linux 系统，则下一步；

5. （第二次搬移）搬运 Linux 内核到内存；

6. 然后调用 `common/bootm_os.c` 里的 `boot_selected_os()`，其调用 `arch/arm/lib/bootm.c` 里的 `do_bootm_linux()`，再调用同文件里的 `boot_jump_linux()`，跳到内核的起始地址，进入 & 运行内核。

armv8架构

1. 上电执行`arch/arm/cpu/armv8/start.S`后跳转到`arch/arm/lib/crt0_64.S`的`_main`里：
   - 首先调用`common/board_f.c`里面的`board_init_f()`（第一次初始化），其调用`init_sequence_f[]`数组里的各个初始化函数，数组中有 `board/<公司名>/<板子名>/<板子名>.c`中的`board_early_init_f()`；
   - 然后调用`relocate_code`（第一次搬运）uboot自搬运到内存；
   - 调用common/board_r.c里面的board_init_r()（第二次初始化），其调用init_sequence_r[]数组里的各个初始化函数，数组中有：
     - board/<公司名>/<板子名>/<板子名>.c`中的`board_init()`；`
     - `board_early_init_r()`，在 imx8 的文件中没有用到；
     - `board/<公司名>/<板子名>/<板子名>.c`中的`board_late_init()`；
     - `run_main_loop()`；
2. 跳入 uboot 的主循环 `run_main_loop()`之后，等待外部输入命令或超时等待自启动；（主要逻辑基本一致）
3. 进行启动，找到 Linux kernel 镜像，搬运其到内存（第二次搬运），跳转启动。

## main_loop流程解析

在`common/main.c`中存在函数

```
void main_loop(void)
{
	const char *s;
	bootstage_mark_name(BOOTSTAGE_ID_MAIN_LOOP, "main_loop");
#ifdef CONFIG_VERSION_VARIABLE
	env_set("ver", version_string);  /* set version variable */
#endif /* CONFIG_VERSION_VARIABLE */
	cli_init();
	run_preboot_environment_command();
#if defined(CONFIG_UPDATE_TFTP)
	update_tftp(0UL, NULL, NULL);
#endif /* CONFIG_UPDATE_TFTP */
	s = bootdelay_process();
	if (cli_process_fdt(&s))
		cli_secure_boot_cmd(s);
	autoboot_command(s);
	cli_loop();
	panic("No CLI available");
}
```

调用顺序

void main_loop(void)

- bootstage_mark_name(BOOTSTAGE_ID_MAIN_LOOP, "main_loop");
- bootdelay_process();
- autoboot_command(s);
  - run_command_list(s, -1, 0);

其中终端输出的信息

```
Hit any key to stop autoboot:  0
```

来源于`OK10xx-linux-uboot\common\autoboot.c`中的`static int __abortboot(int bootdelay)`函数

函数中检测是否有按键中断

```
if (tstc()) {	/* we got a key press	*/
	abort  = 1;	/* don't auto boot	*/
```

[C语言中的转义字符\b的含义_c语言\b_码农哈里的博客-CSDN博客](https://blog.csdn.net/harryduanchina/article/details/90751355)

main_loop函数：调用bootstage_mark_name函数，打印出启动进度，调用setenv函数将变量ver的值设为version_string，也就是设置版本号的环境变量。调用cli_init函数初始化命令，初始化hush shell相关的变量。Bootdelay_process函数用于读取环境变量bootdelay和bootcmd的内容，然后将bootdelay的值赋值给全局变量stored_bootdelay，返回bootcmd的值。

autoboot_command函数，此函数检查倒计时是否结束，倒计时结束前是否被打断。如果倒计时正常结束，就会执行run_command_list，此函数会执行参数s指定的一系列命令，也就是环境变量bootcmd的命令，bootcmd中保存着默认的启动命令，因此linux内核启动。如果在倒计时结束前按下回车键，run_command_list就不会执行，相当于空函数，然后执行cli_loop函数，这个是命令行处理函数，负责接收处理输入命令。

run_command_list函数：检查字符串 `cmd` 中是否包含换行符 `'\n'`，如果它为真（表示字符串 `cmd` 包含换行符 `'\n'`），则分配一块内存，并将 `cmd` 的内容复制到新分配的缓冲区 `buff` 中，最后在缓冲区的末尾添加了一个 null 终止符 `'\0'`。

```
#ifdef CONFIG_CMDLINE
	rcode = cli_simple_run_command_list(buff, flag);
#else
	rcode = board_run_command(buff);
#endif
```

cli_simple_run_command_list() -执行命令列表

- cli_simple_run_command

  - cmd_process

    ```
    cmdtp = find_cmd(argv[0]);
        if (cmdtp == NULL) {
        printf("Unknown command '%s' - try 'help'\n", argv[0]);
        return 1;
    }
    ```

    在 cmd_process 中调用关系如下
    cmd_process -> find_cmd-> find_cmd_tbl，通过用户输入找到需要执行的命令代码

    通过以下测试，如果命令未找到则输出如下：

    ```
    => ggv
    Unknown command 'ggv' - try 'help'
    ```

    如果找到当前命令并且参数数量匹配则执行cmd_call来运行该命令

    cmd_call函数会通过函数指针的形式运行该命令并返回结果：`cmdtp->cmd` 是命令表结构中的一个字段，它是一个函数指针，指向要执行的命令函数。这里使用 `cmdtp`（命令表结构指针）来访问该字段。

    cmd_call函数这种设计允许将不同的命令注册到命令表中，然后通过调用 `cmd_call` 函数来执行这些命令，统一处理命令执行的结果和错误信息。

    ```
    result = (cmdtp->cmd)(cmdtp, flag, argc, argv);
    ```

cli_loop函数：命令行处理函数，负责接收处理输入命令

```
#ifdef CONFIG_HUSH_PARSER
	parse_file_outer();
	/* This point is never reached */
	for (;;);
#elif defined(CONFIG_CMDLINE)
	cli_simple_loop();
```

两种方式： 

1. parse_file_outer(); //采用“hush”方式的主循环
2. cli_simple_loop();//循环查询接收的一行命令输入，类似早期版本arm9的U-boot的实现方式

两种方式都调用到cmd_process函数

## uboot给kernel传参：bootargs

(1)linux内核启动时可以接收uboot给他传递的启动参数，这些启动参数是uboot和内核约定好的形式、内容，linux内核在这些启动参数的指导下完成启动过程。这样的设计是为了灵活，为了内核在不重新编译的情况下可以用不同的方式启动。

(2)我们要做的事情就是：在uboot的环境变量中设置bootargs，然后bootm命令启动内核时会自动将bootargs传给内核。

(3)环境变量bootargs=console=ttySAC2,115200 root=/dev/mmcblk0p2 rw init=/linuxrc rootfstype=ext3意义解释：console=ttySAC2,115200 控制台使用串口2，波特率115200.root=/dev/mmcblk0p2 rw 根文件系统在SD卡端口0设备(iNand)第2分区，根文件系统是可读可写的init=/linuxrc linux的进程1(init进程)的路径rootfstype=ext3 根文件系统的类型是ext3

(4)内核传参非常重要。在内核移植的时候，新手经常因为忘记给内核传参，或者给内核传递的参数不对，造成内核启动不起来。

## uboot阶段Flash的分区

(1)所谓分区，就是说对Flash进行分块管理。

(2)PC机等产品中，因为大家都是在操作系统下使用硬盘的，整个硬盘由操作系统统一管理，操作系统会使用文件系统帮我们管理硬盘空间。(管理保证了文件之间不会互相堆叠)，于是乎使用者不用自己太过在意分区问题。

(3)在uboot中是没有操作系统的，因此我们对Flash(相当于硬盘)的管理必须事先使用分区界定(实际上在uboot中和kernel中都有个分区表，分区表就是我们在做系统移植时对Flash的整体管理分配方法)。有了这个界定后，我们在部署系统时按照分区界定方法来部署，uboot和kernel的软件中也是按照这个分区界定来工作，就不会错。

(4)分区方法不是一定的，不是固定的，是可以变动的。但是在一个移植中必须事先设计好定死，一般在设计系统移植时就会定好，定的标准是：uboot:uboot必须从Flash起始地址开始存放(也许是扇区0，也许是扇区1，也许是其他，取决于SoC的启动设计)，uboot分区的大小必须保证uboot肯定能放下，一般设计为512KB或者1MB(因为一般uboot肯定不足512KB，给再大其实也可以工作，但是浪费);环境变量：环境变量分区一般紧贴着uboot来存放，大小为32KB或者更多一点。kernel：kernel可以紧贴环境变量存放，大小一般为3MB或5MB或其他。rootfs：······剩下的就是自由分区，一般kernel启动后将自由分区挂载到rootfs下使用 总结：一般规律如下：

(1)各分区彼此相连，前面一个分区的结尾就是后一个分区的开头。

(2)整个flash充分利用，从开头到结尾。

(3)uboot必须在Flash开头，其他分区相对位置是可变的。

(4)各分区的大小由系统移植工程师自己来定，一般定为合适大小(不能太小，太小了容易溢出;不能太大，太大了浪费空间)

(5)分区在系统移植前确定好，在uboot中和kernel中使用同一个分区表。将来在系统部署时和系统代码中的分区方法也必须一样。

## uboot阶段DDR的分区

(1)DDR的分区和Flash的分区不同，主要是因为Flash是掉电存在的，而DDR是掉电消失，因此可以说DDR是每次系统运行时才开始部署使用的。

(2)内存的分区主要是在linux内核启动起来之前，linux内核启动后内核的内存管理模块会接管整个内存空间，那时候就不用我们来管了。

(3)注意内存分区关键就在于内存中哪一块用来干什么必须分配好，以避免各个不同功能使用了同一块内存造成的互相踩踏。譬如说我们tftp 0x23E00000 zImage去下载zImage到内存的0x23E00000处就会出错，因为这个内存处实际是uboot的镜像所在。这样下载会导致下载的zImage把内存中的uboot给冲掉。

## 敲击键盘后，进入uboot命令行或者自启进入kernel的流程

在 U-Boot 中，通常会在串口终端上监听特定的触发字符或组合键，以确定是否进入命令行模式。这些触发字符或组合键通常是事先定义好的，它们的输入会告诉 U-Boot 开发者或操作者系统已准备好进入命令行模式。

以下是一般情况下实现敲击键盘后进入命令行模式的步骤：

1. **终端连接**：首先，需要通过串口终端或其他合适的终端连接到嵌入式系统，以便进行交互。
2. **命令行触发**：某些版本的U-Boot或配置选项允许用户通过敲击特定的键或组合键来触发命令行模式。例如，常见的触发方式是敲击 `Ctrl + C` 或其他特定组合键。
3. **命令行界面**：一旦触发了命令行模式，U-Boot可能会进入一个简单的命令行界面，允许用户输入命令和配置选项。这个命令行界面通常提供了一些基本的U-Boot命令，允许用户执行引导、烧录固件、设置环境变量等操作。
4. **命令处理**：U-Boot会解析用户输入的命令，并执行相应的操作。这些命令通常用于配置U-Boot的行为、加载内核、引导操作系统或进行其他系统管理任务。
5. **退出命令行模式**：用户可以执行特定的命令来退出命令行模式并继续引导操作系统。通常，这个命令是 `boot` 或类似的命令。

U-Boot的配置和触发方式通常在 U-Boot 的源代码中进行定义和配置。以下是一些常见的 U-Boot 配置文件和源代码文件，其中包含触发方式和命令行模式相关的设置：

1. **include/configs 目录**：在这个目录下，找到针对不同嵌入式平台的配置文件，例如 `boardname.h`。这些文件包含了与特定平台相关的配置选项，包括触发方式和命令行模式的设置。
2. **common/cmd_bootmenu.c**：这个源代码文件通常包含了与启动菜单（boot menu）和交互方式相关的代码。启动菜单是一个在命令行模式下显示可用引导选项的功能，用户可以选择其中一个引导选项。触发启动菜单的方式通常在这个文件中配置。
3. **common/main.c**：这个源代码文件包含了 U-Boot 的主要启动代码，包括命令行模式的初始化。在这里，可能会找到触发命令行模式的条件和方式的代码。
4. **include/configs/configname.h**：与特定平台或配置相关的配置文件，例如 `include/configs/imx6ul.h`。在这些文件中，可能会定义触发方式、环境变量和启动参数等。
5. **common/autoboot.c**：这个源代码文件包含了 U-Boot 的自动引导（autoboot）逻辑。在这里，可能会找到配置自动引导的选项，包括超时触发命令行模式的设置。

在`common/main.c`中存在函数

```
/* We come here after U-Boot is initialised and ready to process commands */
void main_loop(void)
```

调用顺序

void main_loop(void)

- bootstage_mark_name(BOOTSTAGE_ID_MAIN_LOOP, "main_loop");
- bootdelay_process();
- autoboot_command(s);
  - run_command_list(s, -1, 0);

其中终端输出的信息

```
Hit any key to stop autoboot:  0
```

来源于`OK10xx-linux-uboot\common\autoboot.c`中的`static int __abortboot(int bootdelay)`函数

函数中检测是否有按键中断，有则将abort置为1，返回给abortboot函数

```
if (tstc()) {	/* we got a key press	*/
	abort  = 1;	/* don't auto boot	*/
```

当被`enter`中断时abortboot函数返回1，`!abortboot`为0，不执行run_command_list(s, -1, 0);然后执行cli_loop函数，这个是命令行处理函数，负责接收处理输入命令。

```
if (stored_bootdelay != -1 && s && !abortboot(stored_bootdelay)) {
	run_command_list(s, -1, 0);
}
```

run_command_list函数会执行参数s指定的一系列命令，也就是环境变量bootcmd的命令，bootcmd中保存着默认的启动命令，因此linux内核启动。

[uboot启动流程之进uboot命令行和启动内核_autoboot_command_还行吧xj的博客-CSDN博客](https://blog.csdn.net/xiongjiao0610/article/details/83107082)

[uboot启动流程关键函数的介绍（二）_run_command_list_Messi _10的博客-CSDN博客](https://blog.csdn.net/messi1018/article/details/107204538?utm_medium=distribute.pc_relevant.none-task-blog-2~default~baidujs_baidulandingword~default-4-107204538-blog-83107082.235^v38^pc_relevant_anti_vip_base&spm=1001.2101.3001.4242.3&utm_relevant_index=5)

[u-boot的命令行函数 run_command ()分析_run_command()_Yfw&武的博客-CSDN博客](https://blog.csdn.net/u012577474/article/details/102663256)

[U-boot主循环main_loop分析 - cubieboard的个人空间 - OSCHINA - 中文开源技术交流社区](https://my.oschina.net/u/1982421/blog/303213)

[Uboot命令U_BOOT_CMD分析_liulangrenaaa的博客-CSDN博客](https://blog.csdn.net/qq_33894122/article/details/86129765)

更多总结查看`ls1046A新板卡的移植.md`中的0918日期的`main_loop流程解析`

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

## 一些比较重要的结构体

[＜linux＞ uimage头部信息详解_记得仰望星空的博客-CSDN博客](https://blog.csdn.net/weixin_43580872/article/details/123885462)

```
typedef struct image_header {
	__be32		ih_magic;	/* Image Header Magic Number	*/
	__be32		ih_hcrc;	/* Image Header CRC Checksum	*/
	__be32		ih_time;	/* Image Creation Timestamp	*/
	__be32		ih_size;	/* Image Data Size		*/
	__be32		ih_load;	/* Data	 Load  Address		*/
	__be32		ih_ep;		/* Entry Point Address		*/
	__be32		ih_dcrc;	/* Image Data CRC Checksum	*/
	uint8_t		ih_os;		/* Operating System		*/
	uint8_t		ih_arch;	/* CPU architecture		*/
	uint8_t		ih_type;	/* Image Type			*/
	uint8_t		ih_comp;	/* Compression Type		*/
	uint8_t		ih_name[IH_NMLEN];	/* Image Name		*/
} image_header_t;
```

```
typedef struct bootm_headers {
	/*
	 * Legacy os image header, if it is a multi component image
	 * then boot_get_ramdisk() and get_fdt() will attempt to get
	 * data from second and third component accordingly.
	 */
	image_header_t	*legacy_hdr_os;		/* image header pointer */
	image_header_t	legacy_hdr_os_copy;	/* header copy */
	ulong		legacy_hdr_valid;
	......
	#ifndef USE_HOSTCC
	image_info_t	os;		/* os image info */
	ulong		ep;		/* entry point of OS */

	ulong		rd_start, rd_end;/* ramdisk start/end */

	char		*ft_addr;	/* flat dev tree address */
	ulong		ft_len;		/* length of flat device tree */

	ulong		initrd_start;
	ulong		initrd_end;
	ulong		cmdline_start;
	ulong		cmdline_end;
	bd_t		*kbd;
	#endif

	int		verify;		/* env_get("verify")[0] != 'n' */
	#define	BOOTM_STATE_START	(0x00000001)
	#define	BOOTM_STATE_FINDOS	(0x00000002)
	#define	BOOTM_STATE_FINDOTHER	(0x00000004)
	#define	BOOTM_STATE_LOADOS	(0x00000008)
	#define	BOOTM_STATE_RAMDISK	(0x00000010)
	#define	BOOTM_STATE_FDT		(0x00000020)
	#define	BOOTM_STATE_OS_CMDLINE	(0x00000040)
	#define	BOOTM_STATE_OS_BD_T	(0x00000080)
	#define	BOOTM_STATE_OS_PREP	(0x00000100)
	#define	BOOTM_STATE_OS_FAKE_GO	(0x00000200)	/* 'Almost' run the OS */
	#define	BOOTM_STATE_OS_GO	(0x00000400)
    int		state;

#ifdef CONFIG_LMB
	struct lmb	lmb;		/* for memory mgmt */
#endif
} bootm_headers_t;
```

```
typedef struct image_info {
	ulong		start, end;		/* start/end of blob */
	ulong		image_start, image_len; /* start of image within blob, len of image */
	ulong		load;			/* load addr for the image */
	uint8_t		comp, type, os;		/* compression, type of image, os type */
	uint8_t		arch;			/* CPU architecture */
} image_info_t;
```

位于OK10xx-linux-uboot\common\bootm_os.c

```
static boot_os_fn *boot_os[] = {
	[IH_OS_U_BOOT] = do_bootm_standalone,
#ifdef CONFIG_BOOTM_LINUX
	[IH_OS_LINUX] = do_bootm_linux,
#endif
#ifdef CONFIG_BOOTM_NETBSD
	[IH_OS_NETBSD] = do_bootm_netbsd,
#endif
#ifdef CONFIG_LYNXKDI
	[IH_OS_LYNXOS] = do_bootm_lynxkdi,
#endif
#ifdef CONFIG_BOOTM_RTEMS
	[IH_OS_RTEMS] = do_bootm_rtems,
#endif
#if defined(CONFIG_BOOTM_OSE)
	[IH_OS_OSE] = do_bootm_ose,
#endif
#if defined(CONFIG_BOOTM_PLAN9)
	[IH_OS_PLAN9] = do_bootm_plan9,
#endif
#if defined(CONFIG_BOOTM_VXWORKS) && \
	(defined(CONFIG_PPC) || defined(CONFIG_ARM))
	[IH_OS_VXWORKS] = do_bootm_vxworks,
#endif
#if defined(CONFIG_CMD_ELF)
	[IH_OS_QNX] = do_bootm_qnxelf,
#endif
#ifdef CONFIG_INTEGRITY
	[IH_OS_INTEGRITY] = do_bootm_integrity,
#endif
#ifdef CONFIG_BOOTM_OPENRTOS
	[IH_OS_OPENRTOS] = do_bootm_openrtos,
#endif
};
```



## board_init_f、run_main_loop等函数说明

github原版和nxp提供的uboot是有这些函数的，但是飞凌的OK10xx-linux-uboot部分闭源，导致无法分析，应当使用nxp的uboot

[u-boot/common/board_r.c at lf_v2022.04 · nxp-qoriq/u-boot (github.com)](https://github.com/nxp-qoriq/u-boot/blob/lf_v2022.04/common/board_r.c#L627)

## 调试使用

使用`Objdump`反汇编查看u-boot（最原始文件，包含调试信息）头部代码和异常向量处理，uboot.bin不包含调试信息，因此要比原始文件小很多，才可以被烧录到内部，原始文件太大了

[arm的PC指针指向何方 - 腾讯云开发者社区-腾讯云 (tencent.com)](https://cloud.tencent.com/developer/news/502677#:~:text=由前面的定义知，PC始终指向当前取出的指令的地址，一般来说，人们习惯性约定将“正在执行的指令作为参考点“，称之为当前第一条指令，因此PC总是指向第三条指令。,当ARM状态时，每条指令为4字节长，所以PC始终指向该指令地址加8字节的地址，即：PC值%3D当前程序执行位置%2B8。)

PC指针在arm里是指PC寄存器，也就是R15，第15号寄存器，PC只不过是别名。

PC=当前程序执行位置+8和几级流水线并没有关系，而是和指令运行阶段处于流水线的哪个阶段有关。即使你是5级流水线，只要指令运行阶段还是处于流水线的第三阶段，那么PC还是等于当前程序执行位置+8。

`VBAR` 是 ARM（包括 ARMv7 和 ARMv8 架构）中的一个特殊寄存器，它代表 "Vector Base Address Register"，用于指示中断和异常处理的向量表的基址。中断和异常处理是操作系统和硬件之间的交互，用于响应各种事件，例如外部中断、系统调用、内存访问错误等。

向量表是一组特殊的地址，用于存储处理器在发生异常或中断时跳转到的指令地址。具体来说，向量表包括处理各种异常的处理例程的地址，例如中断、数据中止、系统调用等。

`VBAR` 寄存器的主要作用是存储向量表的基址。当处理器发生异常或中断时，它会使用 `VBAR` 中存储的地址作为起始点，从向量表中加载相应的异常处理例程的地址，然后跳转到这个地址以执行异常处理。

使用hexdump工具分析镜像的16进制代码

重定位：U-Boot 的初始化阶段包含了一次将自身复制到另一个地址的操作，这个操作被称为重定位。`relocate_code()` 定义在 `.\arch\arm\lib\relocate.S` 中，函数原型是 `void relocate_code(addr_moni)`。

## uboot-lds文件解析

先看一下 GNU 官方网站上对.lds 文件形式的完整描述：

```
SECTIONS { 
... 
secname *start* BLOCK(*align*) (NOLOAD) : AT ( *ldadr* ) 
 { *contents* } >*region* :*phdr* =*fill*
... 
} 
```

secname和 contents是必须的，其他的都是可选的。下面挑几个常用的看看： 

1. secname：段名
2. contents：决定哪些内容放在本段，可以是整个目标文件，也可以是目标文件中的某段（代码段、数据段等）
3. start：本段连接（运行）的地址，如果没有使用 AT（ldadr），本段存储的地址也是 start。GNU 网站上说 start 可以用任意一种描述地址的符号来描述。
4. AT（ldadr）：定义本段存储（加载）的地址。

## u-boot 移植要点

要点：

- 一般厂家直接提供 u-boot 源码，做查看、修改(增加新功能) 或 u-boot 版本升级这三大块的用处；后两种都需要对新板子做适配/移植。
- 如果没有提供 u-boot 源码，那么就从 u-boot 官方版本中找到一个最相近的板子配置进行移植，这个需要水平较高。
- 一般把 u-boot 做成对应平台通用的和最小化的，即只保留必要的板级外设初始化代码（如串口、网口和 FLASH 等需要主要做适配，都尽量找能现成使用的），其他更多板级外设初始化在 Linux 移植部分中完成。

芯片公司、开发板厂家和用户三者之间的联系：

- 芯片公司移植的 u-boot 从一开始是基于官方的 u-boot 拿来修改，添加/修改自家的 EVK 评估版的板子型号、相关外设初始化文件，并修改 u-boot 的 Makefile 配置，然后把自家芯片的 EVK 评估版的硬件原理图、u-boot、Linux 和 根文件系统以及使用说明文档等等全部开源，以供下游做应用的公司/厂家和做开发板的公司拿来做修改或直接应用；
- 做开发板的厂家在拿到了芯片公司提供的芯片评估版 EVK 板子的原理图后，与 SoC 直接相关的比如 PMIC、DDR、FLASH、以太网 PHY 芯片等等不会做大改，一般直接照搬过来画自己的开发板。因为在移植 u-boot 的时候就不用再为新选型的芯片做代码适配，一般没必要做这种费力但效果不大的事情，能直接用的就尽量直接用，能不用改的就尽量不改。然后再拿到芯片公司提供的芯片评估版 EVK 板子对应的 u-boot 源码之后，同样的再添加/修改为自家开发板的型号、添加一点点自己板子的外设初始化代码（这个要求比较高）并修改 Makefile，便得到自家开发板适配的又一个 u-boot；
- 当用户拿到了开发板厂家 或者 芯片公司提供的 u-boot 源码，即所有相关文件和初始化代码都写好了，便可以直接编译进而使用，或者自己再进一步定制化。

## uboot网络相关

在 U-Boot 中，`eth_legacy` 和 `eth-uclass` 代表两种不同的以太网驱动框架。它们的关系是：

1. `eth_legacy`：
   - `eth_legacy` 是传统的 U-Boot 以太网驱动框架，早期版本的 U-Boot 主要使用这种框架来管理各种以太网控制器和设备。
   - 该框架使用了一个固定的命名约定，以太网设备的命名通常类似于 `eth0`，`eth1` 等，其中数字用于标识不同的以太网接口。
   - `eth_legacy` 的配置和初始化通常通过宏、全局变量和函数调用完成。
2. `eth-uclass`：
   - `eth-uclass` 是 U-Boot 的新一代以太网驱动框架，它是基于 U-Boot 的 U-Class 设备模型的，更加灵活和模块化。
   - `eth-uclass` 框架的优点在于它支持动态设备注册和探测，允许设备的自动识别和初始化，而不需要预先配置。
   - 在 `eth-uclass` 框架下，以太网设备的命名可能不再遵循传统的 `ethX` 命名约定，而是通过设备树（Device Tree）等方式动态配置和初始化。

关系：

- `eth_legacy` 和 `eth-uclass` 是 U-Boot 中两种不同的以太网驱动框架。你可以选择使用其中一种框架，具体取决于你的硬件平台和 U-Boot 版本。
- 较新版本的 U-Boot 通常更倾向于使用 `eth-uclass` 框架，因为它更灵活、模块化，并能更好地适应现代嵌入式系统的需求。然而，对于某些旧的硬件平台或特定需求，你可能仍然需要使用 `eth_legacy` 框架。
- 切换到 `eth-uclass` 框架可能需要一些配置和修改，以适应你的硬件和设备树设置。

**网络初始化大致调用流程**

board_init()
	eth_initialize()
		board_eth_init() / cpu_eth_init()
			driver_register()
				initialize eth_device
				eth_register()



## 参考文章及视频链接

[深度解析：嵌入式之uboot - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/364071098)

[04-ENTRY等宏的展开，CPSR寄存器的设置_哔哩哔哩_bilibili](https://www.bilibili.com/video/BV1s4411t7eT/?p=4&spm_id_from=pageDriver&vd_source=25ce0faff2c1dc6a089808ffbe1ac4de)

[Linux开发（驱动&应用）学习_linux驱动开发学习路线_Top嵌入式的博客-CSDN博客](https://blog.csdn.net/qq_45396672/article/details/121023440?spm=1001.2014.3001.5506)

