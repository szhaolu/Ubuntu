# 关于WireGuard的延伸性配置及IP控制的应用。  
WireGuard在IP地址上是可以做到配额的。也可以通过子网的限制的方式来，控制用户数量及恶意的IP探测。  
如果是自己不太多的设备使用IP分配来控制流量及VPS等其他实体主机的安全性。  
## 首先WireGuard的安装。  
在这里就不多罗嗦了。可以参考[Atrandys](https://www.atrandys.com/2018/1345.html)，**（需要扶梯）**   
我想能到这里来的朋友基本上都已经出来了，也可以去[AtrandysYoutube](https://www.youtube.com/watch?v=-98GAytcUBE)看视频解说。  
以上安装脚本适用于Ubuntu≥14。0以上的系统。  
**这里要重点说一下。**如果你的主机或VPS硬件是双口网卡时，在安装完成后配置文件中会一起被写入，你要手动把它删除。如下案例：  
```
`PostUp   = iptables -A FORWARD -i wg0 -j ACCEPT; iptables -A FORWARD -o wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0
eth1 -j MASQUERADE`  
`PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -D FORWARD -o wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0
eth1 -j MASQUERADE`  
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
