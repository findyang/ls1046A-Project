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