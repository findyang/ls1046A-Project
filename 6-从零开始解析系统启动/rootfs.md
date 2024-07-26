### 进入系统后怎么看系统是不是buildroot编译的

```
root@T113-Tronlong:~# cat /etc/os-release
NAME=Buildroot
VERSION=2019.02.1-g887b759
ID=buildroot
VERSION_ID=2019.02.1
PRETTY_NAME="Buildroot 2019.02.1"
```



### 千兆速率提高

```
iperf3 -u -c <电脑IP> -P 2 -b 1000M -l 20480 -A 1
```

-l 参数为发送的数据报文长度，增大能测得较大吞吐量

如果在-b 1000M的情况下，测试结果没有能达到900M的话，

比如UDP带宽约为879Mbits/sec，丢包率为0.0037%。

使用如下命令

```
iperf3 -u -c <电脑IP> -P 2 -b 0 -l 20480 -A 1
```

-b 参数为0则是自适应最大速度
