### QPSI NOR FLASH

因为采购型号不匹配，不能识别到设备，等待更换正确的型号进行测试

u-boot/cmd/sf.c

```c
U_BOOT_CMD(
	sf,	5,	1,	do_spi_flash,
	"SPI flash sub-system",
	......
	SF_TEST_HELP
);
```

```c
static int do_spi_flash(cmd_tbl_t *cmdtp, int flag, int argc,
			char * const argv[]);
```

执行sf probe时，其函数调用流程

- do_spi_flash
  - do_spi_flash_probe
    - spi_flash_probe
      - spi_setup_slave
      - flash = calloc(1, sizeof(*flash));
      - spi_flash_probe_slave
        - spi_nor_scan
          - spi_nor_read_id
            - nor->read_reg(nor, SPINOR_OP_RDID, id, SPI_NOR_MAX_ID_LEN);
              - spi_nor_read_write_reg
                - spi_mem_exec_op
          - spi_nor_init_params
          - spi_nor_setup
          - spi_nor_init



spi_flash_probe执行返回错误则打印Failed to initialize SPI flash

spi_nor_scan是其中重要的函数

当前是在spi_nor_read_id函数中执行错误，其中会涉及到spi_nor_ids这个结构体数组，里面包含型号如en25q32b等信息，所有与spi 设备相关的设备信息都在这里进行描述。从代码上看，这些都是通用的驱动，识别芯片并不涉及单板的信息，应该不需要修改。

```c
	info = spi_nor_ids;
	for (; info->name; info++) {
		if (info->id_len) {
			if (!memcmp(info->id, id, info->id_len))
				return info;
		}
	}

	dev_err(nor->dev, "unrecognized JEDEC id bytes: %02x, %02x, %02x\n",
		id[0], id[1], id[2]);
	return ERR_PTR(-ENODEV);
```

其中spi_mem_exec_op函数中以下代码片段

```c
if (op->dummy.nbytes)
    memset(op_buf + pos, 0xff, op->dummy.nbytes);
/* 1st transfer: opcode + address + dummy cycles */
flag = SPI_XFER_BEGIN;
/* Make sure to set END bit if no tx or rx data messages follow */
if (!tx_buf && !rx_buf)
    flag |= SPI_XFER_END;
```

当需要通过fast read command(如0Bh,EBh等)读取flash时，由于频率会高一些，指令地址发送完需要再发几个dummy cycles。
你可以理解为读取频率较高时，需要给flash几个SCLK的时间来准备数据，这几个SCLK就是dummy.

```c
#define JEDEC_MFR(info)	((info)->id[0])
#define JEDEC_ID(info)		(((info)->id[1]) << 8 | ((info)->id[2]))
```

这段代码定义了两个宏：`JEDEC_MFR`和`JEDEC_ID`。这两个宏用于从SPI Flash设备信息结构体中提取厂商ID和设备ID。下面对这两个宏进行解析：

1. `JEDEC_MFR(info)`宏：
   - 这个宏的作用是从传入的SPI Flash设备信息结构体指针`info`中提取厂商ID。
   - 宏展开为`((info)->id[0])`，表示取结构体指针`info`所指向的内存中的第0个元素，即厂商ID。
   - 通过这个宏，可以方便地获取SPI Flash设备信息结构体中的厂商ID。
2. `JEDEC_ID(info)`宏：
   - 这个宏的作用是从传入的SPI Flash设备信息结构体指针`info`中提取设备ID。
   - 宏展开为`(((info)->id[1]) << 8 | ((info)->id[2]))`，表示取结构体指针`info`所指向的内存中的第1个元素和第2个元素，并将第1个元素左移8位，然后与第2个元素进行按位或操作，得到设备ID。
   - 通过这个宏，可以方便地获取SPI Flash设备信息结构体中的设备ID。

软件上无需修改，硬件上更换芯片以及针对芯片飞线对应的电压域，识别情况如下：

```
=> sf probe
SF: Detected n25q256ax1 with page size 256 Bytes, erase size 64 KiB, total 32 MiB
```

代码上对应的信息如下：

```
{ INFO("n25q256ax1",  0x20bb19, 0, 64 * 1024,  512, SECT_4K | SPI_NOR_QUAD_READ | SPI_NOR_4B_OPCODES) },
```

id为0x20bb19，查看手册对比，确实是一致的。

进入系统后读取，容量与实际一致为32 MiB，进行格式化并创建文件测试成功

```
Disk /dev/mtdblock0: 32 MiB, 33554432 bytes, 65536 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
```

```
root@ubuntu:~# cat /proc/mtd
dev:    size   erasesize  name
mtd0: 02000000 00001000 "1550000.quadspi"
```

```
root@ubuntu:~# mount /dev/mtdblock0 /mnt/
root@ubuntu:~# cd /mnt/
root@ubuntu:/mnt# ls
lost+found
root@ubuntu:/mnt# touch 1.txt
root@ubuntu:/mnt# ls
1.txt  lost+found
root@ubuntu:/mnt# cd ../
root@ubuntu:/# umount /dev/mtdblock0
root@ubuntu:/# df
Filesystem     1K-blocks    Used Available Use% Mounted on
/dev/root       52153924 8440196  41034688  18% /
devtmpfs         1924688       0   1924688   0% /dev
tmpfs            1958096       0   1958096   0% /dev/shm
tmpfs            1958096     836   1957260   1% /run
tmpfs               5120       0      5120   0% /run/lock
tmpfs            1958096       0   1958096   0% /sys/fs/cgroup
/dev/mmcblk0p2    999320   92328    838180  10% /boot
tmpfs             391616       0    391616   0% /run/user/0
root@ubuntu:/# mount /dev/mtdblock0 /mnt/
root@ubuntu:/# df -h
Filesystem      Size  Used Avail Use% Mounted on
/dev/root        50G  8.1G   40G  18% /
devtmpfs        1.9G     0  1.9G   0% /dev
tmpfs           1.9G     0  1.9G   0% /dev/shm
tmpfs           1.9G  836K  1.9G   1% /run
tmpfs           5.0M     0  5.0M   0% /run/lock
tmpfs           1.9G     0  1.9G   0% /sys/fs/cgroup
/dev/mmcblk0p2  976M   91M  819M  10% /boot
tmpfs           383M     0  383M   0% /run/user/0
/dev/mtdblock0   27M  779K   24M   4% /mnt
root@ubuntu:/# cd /mnt/
root@ubuntu:/mnt# ls
1.txt  lost+found
```

ok，qspi nor flash已经调试完毕了，不过当前芯片容量为32M，如果需要烧录firmware到里面的话，还需要裁剪一下镜像。