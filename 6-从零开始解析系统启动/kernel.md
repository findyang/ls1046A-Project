## 开启调试

[linux 内核开启调试选项_vmlinux调试-CSDN博客](https://blog.csdn.net/lyndon_li/article/details/130674556)

printk的功能与我们经常在应用程序中使用的printf是一样的，不同之处在于printk可以在打印字符串前面加上内核定义的宏，例如上面例子中的KERN_ALERT（注意：宏与字符串之间没有逗号）。

- \#define KERN_EMERG "<0>"
- \#define KERN_ALERT "<1>"
- \#define KERN_CRIT "<2>"
- \#define KERN_ERR "<3>"
- \#define KERN_WARNING "<4>"
- \#define KERN_NOTICE "<5>"
- \#define KERN_INFO "<6>"
- \#define KERN_DEBUG "<7>"
- \#define DEFAULT_CONSOLE_LOGLEVEL 7

这个宏是用来定义需要打印的字符串的级别。值越小，级别越高。内核中有个参数用来控制是否将printk打印的字符串输出到控制台（屏幕或者/sys/log/syslog日志文件）

\# cat /proc/sys/kernel/printk
6    4    1    7

第一个6表示级别高于（小于）6的消息才会被输出到控制台，第二个4表示如果调用printk时没有指定消息级别（宏）则消息的级别为4，第三个1表示接受的最高（最小）级别是1，第四个7表示系统启动时第一个6原来的初值是7。

因此，如果你发现在控制台上看不到你程序中某些printk的输出，请使用echo 8 > /proc/sys/kernel/printk来解决。

[linux驱动程序调试常用方法-CSDN博客](https://blog.csdn.net/caijp1090/article/details/7471862#:~:text=linux驱动程序调试常用方法 1 利用printk 2 查看OOP消息 3 利用strace 4,利用内核内置的hacking选项 5 利用ioctl方法 6 利用%2Fproc 文件系统 7 使用kgdb)

[盘点那些Linux内核调试手段——内核打印 - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/541182296)

[控制Linux内核启动中的打印_echo 7 > /proc/sys/kernel/printk-CSDN博客](https://blog.csdn.net/li_boxue/article/details/50879243)

[linux 内核开启调试选项_vmlinux调试-CSDN博客](https://blog.csdn.net/lyndon_li/article/details/130674556)

## DEBUG开启

开启 DEBUG 宏看书的时候觉得简单，但是实际写代码的时候，可能会一脸懵逼，不知道在哪里添加 DEBUG ，内核里面给了一个示例，我们只需要在 pr_debug/pr_devel 输出的 .c 文件的最前面写上就好了。

/* init/main.c */ *

*#define DEBUG /* Enable initcall_debug */

悲剧的是，我们有可能都不知道是哪个文件里面打印了出来的，我们要一个文件一个文件的去找，那会非常浪费时间，这就需要秀一下操作了，使用 Makefile 传递宏参数

KCFLAGS=-DDEBUG

使用例子如下：

```
Enable DEBUG
---a/drivers/mmc/core/Makefile
+++b/drivers/mmc/core/Makefile

@@ -20,1 +20,2 @@ obj-$(CONFIG MMC TEST) += mmc test.o
obj-$(CONFIG SDIO UART) += sdio uart.o
+ccflags-y += -DDEBUG=1
```

**用户空间访问内核日志文件**

/proc/kmsg

这个日志文件还是非常有用的，我们可以通过这个文件实时查看你内核 Log ，做驱动开发的同学们，请务必记住这个文件。

dmesg，可以查看全部消息，这样做比较麻烦。或者，专门在一个终端里面看消息，用root权限执行 cat /proc/kmsg，这个命令不会马上结束，直到你手动ctrl+C为止，kmsg里面就是显示内核消息的，程序中printk的输出都可以看到，这样可以随时看到打印内容



## 获取Image的导入地址信息

使用mkimage工具

```
mkimage -l uImage
```



## 根据pc值确定出错的代码位置

[Linux驱动调试之段错误分析_根据pc值确定出错的代码位置_怎么根据驱动ko加载地址确定-CSDN博客](https://blog.csdn.net/u013171226/article/details/126250977)

[Internal error: : 8  PREEMPT SMP ARM，vmlinux反汇编命令调试查找错误的步骤-CSDN博客](https://blog.csdn.net/qq_25814297/article/details/127448098)

```
aarch64-linux-gnu-objdump -D vmlinux > vmlinux.dis
```

[根据pc寄存器的值定位出错代码行_skb_release_data-CSDN博客](https://blog.csdn.net/liweigao01/article/details/90062364)

[驱动调试(三)oops确定函数PC - zongzi10010 - 博客园 (cnblogs.com)](https://www.cnblogs.com/zongzi10010/p/10269156.html)

[linux设备驱动第四篇：驱动调试方法_linux 驱动调试-CSDN博客](https://blog.csdn.net/vic_qxz/article/details/112772685)

[linux panic 问题定位_kernel panic定位-CSDN博客](https://blog.csdn.net/varistor/article/details/50462252?spm=1001.2014.3001.5502)

[linux oops产生原理,kernel panic , Oops 等cpu异常的分析与定位-CSDN博客](https://blog.csdn.net/weixin_39980929/article/details/116936728?spm=1001.2101.3001.6650.2&utm_medium=distribute.pc_relevant.none-task-blog-2~default~CTRLIST~Rate-2-116936728-blog-50462252.235^v40^pc_relevant_3m_sort_dl_base4&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2~default~CTRLIST~Rate-2-116936728-blog-50462252.235^v40^pc_relevant_3m_sort_dl_base4&utm_relevant_index=5)



## linux崩溃后打印这些信息的时候，应该怎么去分析

```
[   67.223212] Synchronous External Abort: synchronous external abort (0x96000210) at 0xffff000009eebe10
[   67.223233] Synchronous External Abort: synchronous external abort (0x96000210) at 0xffff7dffbfdebd30
[   67.223459] Synchronous External Abort: synchronous external abort (0x96000210) at 0xffff80087f78b088
[   67.223469] Unhandled fault: synchronous external abort (0x96000210) at 0xffff80087f78b088
[   67.223471] Mem abort info:
[   67.223474]   Exception class = DABT (current EL), IL = 32 bits
[   67.223477]   SET = 0, FnV = 0
[   67.223480]   EA = 1, S1PTW = 0
[   67.223482] Data abort info:
[   67.223485]   ISV = 0, ISS = 0x00000210
[   67.223487]   CM = 0, WnR = 0
[   67.232460] Internal error: : 96000210 [#1] PREEMPT SMP
[   67.288869] Modules linked in: crc32_ce crct10dif_ce lm90
[   67.294278] Process kworker/0:1 (pid: 92, stack limit = 0xffff000009ee8000)
[   67.301239] CPU: 0 PID: 92 Comm: kworker/0:1 Not tainted 4.14.122-g4c22bf6bf-dirty #12
[   67.309152] Hardware name: LS1046A FRWY Board (DT)
[   67.313944] task: ffff800877534500 task.stack: ffff000009ee8000
[   67.319868] PC is at schedule+0x4c/0xa0
[   67.323700] LR is at schedule+0x38/0xa0
[   67.327531] pc : [<ffff000008dc797c>] lr : [<ffff000008dc7968>] pstate: 80000145
[   67.334921] sp : ffff000009eebe00
[   67.338229] x29: ffff000009eebe00 x28: 0000000000000000 
[   67.343542] x27: 0000000000000000 x26: ffff0000091b71a0 
[   67.348855] x25: ffff0000080e7b48 x24: ffff0000094e2360 
[   67.354166] x23: ffff0000094c7000 x22: ffff80087f7649a0 
[   67.359478] x21: ffff8008774b6270 x20: ffff80087f764980 
[   67.364789] x19: ffff800877534500 x18: 0000fffff0f17974 
[   67.370100] x17: 0000ffffab30e328 x16: ffff00000825eca8 
[   67.375410] x15: 00001d4ed0000000 x14: 0000000000000000 
[   67.380721] x13: 0000000000000000 x12: 0000000fa3c1beb8 
[   67.386033] x11: 0000000000000000 x10: 0000000000000900 
[   67.391343] x9 : ffff000009eebd80 x8 : ffff800877534e60 
[   67.396654] x7 : ffff800877534640 x6 : 0000000000000077 
[   67.401965] x5 : 0000000000000001 x4 : 0000000fa3c15400 
[   67.407276] x3 : 00008008762b4000 x2 : ffff800876412b0c 
[   67.412587] x1 : 0000000000000000 x0 : 0000000000000000 
[   67.417898] Call trace:
[   67.420339] Exception stack(0xffff000009eebcc0 to 0xffff000009eebe00)
[   67.426777] bcc0: 0000000000000000 0000000000000000 ffff800876412b0c 00008008762b4000
[   67.434604] bce0: 0000000fa3c15400 0000000000000001 0000000000000077 ffff800877534640
[   67.442431] bd00: ffff800877534e60 ffff000009eebd80 0000000000000900 0000000000000000
[   67.450257] bd20: 0000000fa3c1beb8 0000000000000000 0000000000000000 00001d4ed0000000
[   67.458083] bd40: ffff00000825eca8 0000ffffab30e328 0000fffff0f17974 ffff800877534500
[   67.465909] bd60: ffff80087f764980 ffff8008774b6270 ffff80087f7649a0 ffff0000094c7000
[   67.473735] bd80: ffff0000094e2360 ffff0000080e7b48 ffff0000091b71a0 0000000000000000
[   67.481562] bda0: 0000000000000000 ffff000009eebe00 ffff000008dc7968 ffff000009eebe00
[   67.489388] bdc0: ffff000008dc797c 0000000080000145 ffff0000094c7000 ffff0000094e2360
[   67.497215] bde0: ffffffffffffffff ffff0000091b71a0 ffff000009eebe00 ffff000008dc797c
[   67.505044] [<ffff000008dc797c>] schedule+0x4c/0xa0
[   67.509922] [<ffff0000080e7c14>] worker_thread+0xcc/0x470
[   67.515321] [<ffff0000080edd84>] kthread+0x12c/0x130
[   67.520286] [<ffff000008084f38>] ret_from_fork+0x10/0x18
[   67.525595] Code: 51000400 b9001260 f9400260 370ffec0 (f9400bf3) 
[   67.531685] ---[ end trace eaa3a32d943d054c ]---
[   67.536298] Internal error: : 96000210 [#2] PREEMPT SMP
[   67.541521] Modules linked in: crc32_ce crct10dif_ce lm90
[   67.546928] Process kworker/3:1 (pid: 43, stack limit = 0xffff000009e58000)
[   67.553888] CPU: 3 PID: 43 Comm: kworker/3:1 Tainted: G      D         4.14.122-g4c22bf6bf-dirty #12
[   67.563016] Hardware name: LS1046A FRWY Board (DT)
[   67.567807] Workqueue: events cache_reap
[   67.571727] task: ffff800877481280 task.stack: ffff000009e58000
[   67.577643] PC is at drain_array+0x18/0xa0
[   67.581734] LR is at cache_reap+0xe8/0x240
[   67.585826] pc : [<ffff0000081f43e8>] lr : [<ffff0000081f4788>] pstate: 20000145
[   67.593217] sp : ffff000009e5bd00
[   67.596527] x29: ffff000009e5bd00 x28: ffff80087f7abc00 
[   67.601839] x27: ffff0000094ed000 x26: ffff0000094acc60 
[   67.607152] x25: ffff0000094c7000 x24: ffff0000094ed740 
[   67.612464] x23: 0000000000000000 x22: 00000000000000d0 
[   67.617775] x21: ffff800877b5de40 x20: ffff000009e5bd40 
[   67.623087] x19: ffff8008725a8e80 x18: 0000000000000001 
[   67.628399] x17: 0000000000000005 x16: ffff800872647088 
[   67.633709] x15: ffff8008726470a8 x14: ffff7e0000000000 
[   67.639020] x13: dead000000000100 x12: dead000000000200 
[   67.644331] x11: ffff7dffbfdee6d0 x10: ffff7e0021c9f760 
[   67.649642] x9 : ffff8008727ddfc0 x8 : ffff8008727dd340 
[   67.654953] x7 : 0000000000000002 x6 : ffff7dffbfdee6c8 
[   67.660264] x5 : 0000000000000057 x4 : 00008008762ff000 
[   67.665574] x3 : 0000000000000000 x2 : ffff7dffbfdebd30 
[   67.670884] x1 : ffff8008725a8e80 x0 : ffff800873a09400 
[   67.676196] Call trace:
[   67.678636] Exception stack(0xffff000009e5bbc0 to 0xffff000009e5bd00)
[   67.685074] bbc0: ffff800873a09400 ffff8008725a8e80 ffff7dffbfdebd30 0000000000000000
[   67.692901] bbe0: 00008008762ff000 0000000000000057 ffff7dffbfdee6c8 0000000000000002
[   67.700727] bc00: ffff8008727dd340 ffff8008727ddfc0 ffff7e0021c9f760 ffff7dffbfdee6d0
[   67.708554] bc20: dead000000000200 dead000000000100 ffff7e0000000000 ffff8008726470a8
[   67.716380] bc40: ffff800872647088 0000000000000005 0000000000000001 ffff8008725a8e80
[   67.724207] bc60: ffff000009e5bd40 ffff800877b5de40 00000000000000d0 0000000000000000
[   67.732033] bc80: ffff0000094ed740 ffff0000094c7000 ffff0000094acc60 ffff0000094ed000
[   67.739860] bca0: ffff80087f7abc00 ffff000009e5bd00 ffff0000081f4788 ffff000009e5bd00
[   67.747686] bcc0: ffff0000081f43e8 0000000020000145 ffff000009e5bd00 ffff0000081f4444
[   67.755513] bce0: ffffffffffffffff ffff000009e5bd40 ffff000009e5bd00 ffff0000081f43e8
[   67.763340] [<ffff0000081f43e8>] drain_array+0x18/0xa0
[   67.768473] [<ffff0000081f4788>] cache_reap+0xe8/0x240
[   67.773608] [<ffff0000080e79dc>] process_one_work+0x1cc/0x338
[   67.779351] [<ffff0000080e7b8c>] worker_thread+0x44/0x470
[   67.784748] [<ffff0000080edd84>] kthread+0x12c/0x130
[   67.789709] [<ffff000008084f38>] ret_from_fork+0x10/0x18
[   67.795018] Code: f9000ff4 910103b4 a90453b4 b40000c2 (b9400044) 
[   67.801109] ---[ end trace eaa3a32d943d054d ]---
```

这是一个内核发生同步外部中断（Synchronous External Abort）的错误信息。同步外部中断通常是由硬件故障、内存访问异常或其他严重的系统问题引起的。以下是对这个错误信息的一些分析和可能的步骤：

1. **错误描述**:

   ```
   Synchronous External Abort: synchronous external abort (0x96000210) at 0xffff000009eebe10
   ```

   这部分描述了同步外部中断的错误类型和错误地址。

2. **异常信息**:

   ```
   Unhandled fault: synchronous external abort (0x96000210) at 0xffff80087f78b088
   ```

   表示内核未处理的同步外部中断，同时提供了异常地址。

3. **内存中断信息**:

   ```
   Mem abort info:
     Exception class = DABT (current EL), IL = 32 bits
     SET = 0, FnV = 0
     EA = 1, S1PTW = 0
   ```

   提供了内存中断的详细信息，包括异常类别、地址对齐信息等。

4. **数据中断信息**:

   ```
   Data abort info:
     ISV = 0, ISS = 0x00000210
     CM = 0, WnR = 0
   ```

   提供了关于数据中断的更多信息，包括中断向量、读写权限等。

5. **内核错误**:

   ```
   Internal error: : 96000210 [#1] PREEMPT SMP
   ```

   表示内核发生了一个内部错误，错误号为 `96000210`。

6. **调用堆栈**:

   ```
   Call trace:
   ...
   ```

   提供了发生错误时的调用堆栈信息，可以追踪到具体的函数和代码行。

7. **处理器状态**:

   ```
   pc : [<ffff000008dc797c>] lr : [<ffff000008dc7968>] pstate: 80000145
   ```

   提供了处理器状态，包括程序计数器（PC）、链接寄存器（LR）和处理器状态寄存器（PSTATE）的值。

8. **可能的原因**:

   - 内存故障、内存损坏或硬件错误。
   - 软件错误导致的内存访问异常。
   - 内核代码中的 bug 或故障。

## module_param

[Linux内核之module_param()函数使用说明-CSDN博客](https://blog.csdn.net/sinat_29891353/article/details/106355202)

## 内核异常报错类型汇总

[内核异常报错类型汇总_kernel panic - not syncing: attempted to kill init-CSDN博客](https://blog.csdn.net/qq_35399548/article/details/122817988)

## 文件详解

[编译Linux后在根目录下生成的几个文件详解_modules.order-CSDN博客](https://blog.csdn.net/weixin_42492218/article/details/130562207)

## kallsyms

[linux内核符号表kallsyms简介_kernel.kallsyms-CSDN博客](https://blog.csdn.net/qq1602382784/article/details/80066847#:~:text=kallsyms抽取了内核用到的所有函数地址,(全局的、静态的)和非栈数据变量地址，生成一个数据块，作为只读数据链接进kernel image，相当于内核中存了一个System.map。)

config中配置

```
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
```

查看kallsyms表：
得益于/proc文件系统，我们可以直接读取这个表。

```
less /proc/kallsyms
```

[/proc/kallsyms 符号表说明-CSDN博客](https://blog.csdn.net/qq_42931917/article/details/129943916)

[kallsyms | kernel tour (kernel-tour.org)](http://kernel-tour.org/kernel/kallsyms.html)





