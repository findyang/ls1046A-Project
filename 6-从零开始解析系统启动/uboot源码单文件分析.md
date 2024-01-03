## 通用

DECLARE_GLOBAL_DATA_PTR;





## arch/arm/cpu/armv8/cpu.c

`void sdelay(unsigned long loops)`

这是一个用于实现简单自旋延迟的 `sdelay` 函数，通常在定时器不可用时使用。该函数采用一个无符号长整型参数 `loops`，表示自旋的次数。每次循环通过内联汇编实现。

`int cleanup_before_linux(void)`

禁用中断和关闭缓存等

关闭I-cache并使其无效

关闭d-cache：dcache_disable()会依次刷新d-cache并禁用MMU

## arch/arm/cpu/armv8/fsl-layerscape/cpu.c