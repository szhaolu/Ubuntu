# 手动安装WireGuard服务端及配置。  
&#8194;&#8194;在没有WireGuard脚本支持的的情况下应该如何手动安装及配置、开启服务端应用。  
在这里说明一点，VPS小白请绕行，还是建议您使用脚本文件来实现WireGuard的服务端的安装。网上有不少这样的教学视频建议参考网页**[Atrandys](https://www.atrandys.com/2018/1345.html)**即可。  
## 安装之前需要了解的注意事项。  
* 1、首先是你需要确认你的硬件网卡数量及名称。  
```
sudo ip addr
```  
来确认你的物理网卡数量及名称和服务器外部接口网卡的IP及网卡名称把它们记录下来。  
例如：  
```
root@localhost:/# ip addr
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether ff:ee:7a:8c:1b:b6 brd ff:ff:ff:ff:ff:ff
    inet 108.241.66.38/24 brd 108.241.66.255 scope global dynamic eth0
       valid_lft 258sec preferred_lft 2548sec
    inet6 fe80::216:14ff:feb2:d4e6/64 scope link 
       valid_lft forever preferred_lft forever
3: eth1: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether ff:ee:7a:8c:1b:b6 brd ff:ff:ff:ff:ff:ff
```  
在这里可以看到`eth0`是本服务器的出口网卡。IP地址是`108.241.66.38`。这些现行记录下来。  
