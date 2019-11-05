# 关于WireGuard的延伸性配置及IP控制的应用。  
WireGuard在IP地址上是可以做到配额的。也可以通过子网的限制的方式来，控制用户数量及恶意的IP探测。  
如果是自己不太多的设备使用IP分配来控制流量及VPS等其他实体主机的安全性。  
## 首先WireGuard的安装。  
在这里就不多罗嗦了。可以参考[Atrandys](https://www.atrandys.com/2018/1345.html)，**（需要扶梯）**   
我想能到这里来的朋友基本上都已经出来了，也可以去[AtrandysYoutube](https://www.youtube.com/watch?v=-98GAytcUBE)看视频解说。  
本库也有备份脚本在本库WireGuard/apps文件夹中。本文完成后给于连接。
以上安装脚本适用于Ubuntu≥14。0以上的系统。  
**这里要重点说一下**如果你的主机或VPS硬件是双口网卡时，在安装完成后配置文件中会一起被写入，你要手动把它删除。如下案例：  
```
PostUp   = iptables -A FORWARD -i wg0 -j ACCEPT; iptables -A FORWARD -o wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0
eth1 -j MASQUERADE
PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -D FORWARD -o wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0
eth1 -j MASQUERADE
```  
**这里就多了除了eth0以外还多了一个eth1，这里只要删除eth1字符即可，切记保留下后面的 -j MASQUERADE。别忘了-j前面的空格字符一起保留下来。**  
要不然你连不上。连上了出不去也回不来。  
## 下面介绍一下用wg0.conf 这个文件来重新自定义IP地址。  
下面就是wg0.conf的全部信息。  
```
[Interface]
PrivateKey = EAQ3yrsBtKmXKSDs1QUq+98tA0g8fGABzbfbB047sUI=
Address = 10.0.0.1/24
PostUp   = iptables -A FORWARD -i wg0 -j ACCEPT; iptables -A FORWARD -o wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0
eth1 -j MASQUERADE
PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -D FORWARD -o wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0
eth1 -j MASQUERADE
ListenPort = 16735
DNS = 8.8.8.8
MTU = 1420
```  
* 这里直说IP重置。  
`Address = 10.0.0.1/24`  
明显这里IP预留的有些多了，在这里我们可以缩小一些。根据自己的实际需求来设置。这里推荐子网数在29  
这样的话你的实际可用IP就被控制在了一定范围内。对于个人VPS来说29网段应该是足足有余了。  
算上路由与广播，共8个地址，可实际使用6个地址。当然这个不是最小值，最小值只能是30网段。（因为服务端主机要占一个IP位）  
如果是30网段的话只能是PC一个客户端了。手机及其他终端将无法多用户连接。  
  * 建议IP配置如下：  
`Address = 172.16.1.249/29`   
当然10.0.0.1/29也是可以的，出于IP管理的方便，选择一个局域网网段比较合适。  
根据你自己的PC主机的IP来决定，一般家用路由器都是192开始，所以这里的话用172来区分而已。（只要不和自己的实际IP冲突就行。）  
  * 关于端口号：
这里如果你不做特殊要求管理可以默认，需要修改也是可以的。建议在5位数以上。  
  * 简单说一下MTU值。  
MTU值默认是1420 但网传说调整到1500为最佳，我不确定是否还有别的影响。至少我是将它重值为1500的。  
* 关于wg0.conf文件的内容就说到这里。**注意的是要在安装WireGuard前使用 ip addr 来确认自己VPS的网卡数量及名称。**  
