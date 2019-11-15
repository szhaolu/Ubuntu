# 手动安装WireGuard服务端及配置。  
&#8194;&#8194;在没有WireGuard脚本支持的的情况下应该如何手动安装及配置、开启服务端应用。  
在这里说明一点，VPS小白请绕行，还是建议您使用脚本文件来实现WireGuard的服务端的安装。网上有不少这样的教学视频建议参考网页**[Atrandys](https://www.atrandys.com/2018/1345.html)**即可。  
## 安装之前需要了解的注意事项。 
**重中之重的说以下目前WireGuard在Ubuntu系统中最适合兼容的是大于等于18.0，小于等于18.10。的系统版本。**  
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
* 2、下一步我们要看一下你的服务器是否已经默认安装了BBR加速。  
`sysctl -p`  
用这个命令来查看如果没有安装，如下显示。  
```
net.ipv6.conf.all.accept_ra = 2
```  
当然也有绝对纯净的VPS服务器，`sysctl -p`之后什么也不会发生什么东西也不会显示。  
如果你使用`sysctl -p`命令后出现了以下两行代码。就说明你的VPS服务商已经为你预安装了BBR加速。代码如下：  
```
net.core.default_qdisc=fq
net.ipv4.tcp_congestion_control=bbr
```
如果已经有预安装的BBR加速，建议就不用在安装别的BBR加速脚本。预安装的相对而言比较纯净，也不用在用什么测试脚本软件查看。有着两行代码足以。  
**当然你也可以在已有的情况下继续安装其他高配置的BBR脚本。但个人我是强烈不建议安装**  
目前[vultr](https://www.vultr.com/)的Ubuntu18.04的系统是预安装BBR加速的。其他服务商未知。  
**如果其他服务商的VPS没有安装BBR加速的话，也不太推荐安装。除非你的VPS服务器不是直连需要绕路的话，你连接VPS服务器的路由数大于30跳—35跳以上，那你就装一个把。如果你的VPS服务器是CN2直连路由数小于30跳的话实在不太推荐你安装BBR加速。大多数BBR加速的脚本不太干净，卸载无法完全。无法控制加速器状态。脚本显示停止，但是服务已然在加速运行着。**  
**至于你们关心的加速能快多少基本上CN2直连，ping值150ms以下，流量高峰期都一样。加与不加基本差不多，也就能快的20%左右顶天了。流量低谷期也就是加速确实能到100%但一般来说Youtube上1080P的片子流量低谷时不加速也能到个5000kbps——7000kbps左右。当流量绝对低谷期不加速CN2直连也能过10000kbps。如果系统默认BBR加速的话。绝对流量高峰期都一样。一般高峰时期能快5000kbps——7000kbps左右，偶尔能上10000kbps,基本上很难过11000kbps,低谷时期可以上15000kbps——35000kbps,绝对低谷时期，可以走到40000kbps往上顶天了也就60000kbps。如果你使用高速的其他脚本的BBR加速，低谷时期可能能会到80000kpbs，高峰时期也就只能加速到5000kbps了不得了。**   
 
