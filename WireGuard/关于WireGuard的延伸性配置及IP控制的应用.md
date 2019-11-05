# 关于WireGuard的延伸性配置及IP控制的应用。  
WireGuard在IP地址上是可以做到配额的。也可以通过子网的限制的方式来，控制用户数量及恶意的IP探测。  
如果是自己不太多的设备使用IP分配来控制流量及VPS等其他实体主机的安全性。  
## 首先WireGuard的安装。  
在这里就不多罗嗦了。可以参考[Atrandys](https://www.atrandys.com/2018/1345.html)，**（需要扶梯）**   
我想能到这里来的朋友基本上都已经出来了，也可以去[AtrandysYoutube](https://www.youtube.com/watch?v=-98GAytcUBE)看视频解说。  
本库也有备份脚本在本库[WireGuard/apps](https://raw.githubusercontent.com/szhaolu/Ubuntu/master/WireGuard/apps/wireguard_install_ubuntu.zip)文件夹中。解压后时.sh的脚本文件（只使用于Ubuntu）。  
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

[Peer]
PublicKey = vxKO4AdZrnW1MqAk0lZLisyP44YjWKjlz2Yy+erNan0=
AllowedIPs = 10.0.0.2/32
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
其他数值保持不变不动。  
关于服务端上的客户端配置下面讲多用户配置时会提到。  
* 关于wg0.conf文件的内容就说到这里。**注意的是要在安装WireGuard前使用 ip addr 来确认自己VPS的网卡数量及名称。**  
## 下面介绍一下客户端文件client.conf。  
下面是client.conf的全部信息。  
```
[Interface]
PrivateKey = CMtZQA81L2WiYSXiR1Kei7h20fZs1492/uEPPfNvTlo=
Address = 10.0.0.2/24 
DNS = 8.8.8.8
MTU = 1420

[Peer]
PublicKey = vTIc+4tehWl6F+wATKCCpNUzrNQrK+E+NXcH7BGnoQY=
Endpoint = 114.160.178.227:16735
AllowedIPs = 0.0.0.0/0, ::0/0
PersistentKeepalive = 25
```  
在这个文件中的Address值要与你服务端IP在同一个网段下。  
DNS、MTU值要与服务端一致，PrivateKey、PublicKey不要动保持原样。  
Endpoint值是你VPS的外网地址与服务端的端口号。保持一致即可基本也不用动。  
* AllowedIPs这里说一下。如果你不做定向游戏加速或者特定出站访问。这里不用动。  
定向设置在[Atrandys](https://www.atrandys.com/)这个网站的WireGuard目录下有所介绍可以自行查阅。  
## 客户端连接软件介绍。  
WireGuard基本支持绝大部分的终端设备，基本上Windows、linux、Android、 macOS、 IOS。  
当然也可以用第三方软件替代使用TunSafe就可以识别client.conf文件内容。  
其他相关的客户端可以去[WireGuard官方网站](https://www.wireguard.com/install/)查阅。  
提醒一下：完全需要扶梯访问，**部分SSR也是无法访问的**。请用其他方式接。  
* 至于WireGuard的Ubuntu的客户端安装日后在出教学，在这里就不罗嗦。  
## 下面介绍一下多用户连接配置。  
在我们的日常使用时不可能单一终端使用。有时需要手机、电脑等其他终端同时连接的情况。这时我们就需要建立多用户访问。  
* 新建公私密钥。  
`1、cd /etc/wireguard` // 进入wireguard。`  
`2、wg genkey | tee tempkey | wg pubkey >> tempkey`  
完成以上命令后，ls 你会看见目录中多了一个tempkey这样一个临时钥匙。  
`3、cat tempkey //查看这个钥匙文件。`  
结果如下：  
`gFYTGq3zruYB6qx8xD8K2nuUtygXtKqhsG9E82hciUs= // 客户端公钥。`  
`kSJ4cYFjlb+NSfE3uonA3jmVAR76Q75Z44RV7IR6tAQ= // 客户端端私钥。`  
* 添加新的IP地址与客户端端私钥。  
`4、vim wg0.conf // 进入配置文件。`  
展示如下：  
```
[Interface]
PrivateKey = EAQ3yrsBtKmXKSDs1QUq+98tA0g8fGABzbfbB047sUI=
Address = 10.0.0.1/29 
PostUp   = iptables -A FORWARD -i wg0 -j ACCEPT; iptables -A FORWARD -o wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -D FORWARD -o wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE
ListenPort = 16735
DNS = 8.8.8.8
MTU = 1500

[Peer]
PublicKey = vxKO4AdZrnW1MqAk0lZLisyP44YjWKjlz2Yy+erNan0=
AllowedIPs = 10.0.0.2/32

[Peer]
PublicKey = vxKO4AdZrnW1MqAk0lZLisyP44YjWKjlz2Yy+erNan0=
AllowedIPs = 10.0.0.2/32
```  
复制上段后把第二段peer数据修改为新添的IP与客户端端私钥。  
```
[Peer]
PublicKey = kSJ4cYFjlb+NSfE3uonA3jmVAR76Q75Z44RV7IR6tAQ=
AllowedIPs = 10.0.0.3/32
```  
然后:wq保存即可。  
**这里说一下AllowedIPs为什么后面跟32网段，因为这样可以保证一IP一把钥匙。所以这里一定要子网锁死**。  
  * 下面我们停止重启WireGuard服务。  
`1、wg-quick down wg0 //停止WireGuard服务。`  
`2、wg-quick up wg0 //开启WireGuard服务。` 
 服务器这里算是弄完了！我们现在还需要新建一个客户端文件。  
* 新建WireGuard客户端文件*conf  
复制一个原来的pc端客户端文件。用记事本打开或者Notepad++打开，其他编译软件也是可以的。  
 ```
[Interface]
PrivateKey = gFYTGq3zruYB6qx8xD8K2nuUtygXtKqhsG9E82hciUs=
Address = 10.0.0.3/29 
DNS = 8.8.8.8
MTU = 1500
```  
将PrivateKey改为刚刚新生成的客户端公钥。  
将Address改为与服务端设置的一样即可。（后面的子网不能是32，要与服务端IP网段一致。）  
其他不变保存即可，给个能识别的名字。  
多用户以此类推操作即可。当然你也可以用脚本中的新建客户端功能。但弄完了你还是要重新调试。  
除非你自己修改脚本。（如果没把握不建议自行修改脚本）  
  * 最后说一下保存名字有讲究。  
TunSafe这个软件无所谓，主要时WireGuard自己的客户端软件。尽量不要出现空格及特殊符号。名字中大小写尽量用小写。少用大写字。  
手机的WireGuard客户端，大写、空格、符号都无法辨识。所以尽量用简短的英文。  

上述基本上关于WireGuard的相关基本参数常用设置都在这里了，希望本文能帮助到您！  
