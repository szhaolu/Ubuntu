# 手动安装WireGuard服务端及配置。  
&#8194;&#8194;在没有WireGuard脚本支持的的情况下应该如何手动安装及配置、开启服务端应用。  
在这里说明一点，VPS小白请绕行，还是建议您使用脚本文件来实现WireGuard的服务端的安装。网上有不少这样的教学视频建议参考网页[Atrandys](https://www.atrandys.com/2018/1345.html)即可。  
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
&#8194;&#8194;当然也有绝对纯净的VPS服务器，`sysctl -p`之后什么也不会发生什么东西也不会显示。  
&#8194;&#8194;如果你使用`sysctl -p`命令后出现了以下两行代码。就说明你的VPS服务商已经为你预安装了BBR加速。代码如下：  
```
net.core.default_qdisc=fq
net.ipv4.tcp_congestion_control=bbr
```
&#8194;&#8194;如果已经有预安装的BBR加速，建议就不用在安装别的BBR加速脚本。预安装的相对而言比较纯净，也不用在用什么测试脚本软件查看。有着两行代码足以。  
&#8194;&#8194;**当然你也可以在已有的情况下继续安装其他高配置的BBR脚本。但个人我是强烈不建议安装**  
&#8194;&#8194;目前[vultr](https://www.vultr.com/)的Ubuntu18.04的系统是预安装BBR加速的。其他服务商未知。  
&#8194;&#8194;**如果其他服务商的VPS没有安装BBR加速的话，也不太推荐安装。除非你的VPS服务器不是直连需要绕路的话，你连接VPS服务器的路由数大于30跳—35跳以上，那你就装一个把。如果你的VPS服务器是CN2直连路由数小于30跳的话实在不太推荐你安装BBR加速。大多数BBR加速的脚本不太干净，卸载无法完全。无法控制加速器状态。脚本显示停止，但是服务已然在加速运行着。**  
&#8194;&#8194;**至于你们关心的加速能快多少基本上CN2直连，ping值150ms以下，流量高峰期都一样。加与不加基本差不多，也就能快的20%左右顶天了。流量低谷期也就是加速确实能到100%但一般来说Youtube上1080P的片子流量低谷时不加速也能到个5000kbps——7000kbps左右。当流量绝对低谷期不加速CN2直连也能过10000kbps。如果系统默认BBR加速的话。绝对流量高峰期都一样。一般高峰时期能快5000kbps——7000kbps左右，偶尔能上10000kbps,基本上很难过11000kbps,低谷时期可以上15000kbps——35000kbps,绝对低谷时期，可以走到40000kbps往上顶天了也就60000kbps。如果你使用高速的其他脚本的BBR加速，绝对低谷时期可能能会到80000kpbs，高峰时期也就只能加速到5000kbps了不得了。**  
唠叨了这个些基本的安装WireGuard前的基本考虑因素就这些了。下面进去正题！  
## 手动安装WireGuard的服务器程序。  
先要安装WireGuard所需要的支持服务。  
* 1、需要更新`apt-get`程序。  
```
sudo apt-get update -y
```  
* 2、因为WireGuard是基于OpenVPN延伸开发的。所以我们要安装OpenVPN的服务。  
```
sudo apt-get install -y openresolv
```  
* 3、如果你需要WireGuard在日后的使用中运用到中文时你还需要安装software-properties-common服务。**（如果没有其他扩展性的语言等开发。这一步可以不做略过即可。）**  
**如果您的VPS服务器是高度纯净版，什么附加程序都没有的话，此项必须安装。以及必要的编译工具和下载工具。如果不安装下面的`add-apt-repository`你会无法运行。**  
```
sudo apt-get install -y vim wget curl
sudo apt-get install -y software-properties-common
```  
**下面就要开始安装WireGuard主程序**  
&#8194;&#8194;两部就算完成。命令如下：  
```    
sudo add-apt-repository -y ppa:wireguard/wireguard  
sudo apt-get install -y wireguard
```  
安装的部分就算完成了。繁琐的事情是配置服务端文件和客户端文件。  
* 4、修改系统内核接口。  
```
vim /etc/sysctl.conf
```  
进入文件找到`#net.ipv4.ip_forward = 1`去除#符号注解。`:wq`保存。  

**这里说一下，如果系统预安装好了BBR加速的话，在`sysctl.conf`文件最后会有如下代码：**  
```
net.core.default_qdisc=fq
net.ipv4.tcp_congestion_control=bbr
```  
保存退出以后执行`sudo sysctl -p`命令显示如下：  
```
net.ipv6.conf.all.accept_ra = 2
net.core.default_qdisc=fq
net.ipv4.tcp_congestion_control=bbr
net.ipv4.ip_forward = 1
``` 
&#8194;&#8194;这个是预安装过BBR的和ipv6接口的。如果是纯净版的则只会显示`net.ipv4.ip_forward = 1`这一行代码。  
* 5、确认`ip_forward`数值是否为 1 。命令如下：  
```
cat /proc/sys/net/ipv4/ip_forward
```  
命令结束后只会显示 1 一个字符。即为正常。  
* 6、在`/etc`中新建一个wireguard目录。**（很重要！不可偷懒！）**  
```
sudo mkdir /etc/wireguard/
```  
进入wireguard目录。`ls`之后你会发现什么也没有。需要我们手工配置。  
## 开始进入配置wireguard文件及部署。  
* 1、我们现在先要为服务器及第一个客户端建立公私密钥。  
&#8194;&#8194;一般的程序脚本文件安装完成后本目录中会有。`sprivatekey`、`spublickey`、`cprivatekey`、`cpublickey`、`client.conf`、`wg0.conf`,这些分别是“服务器私钥”、“服务器公钥”、“客户端私钥”、“客户端公钥”、“客户端配置文件”、“服务器配置文件”。这时脚本安装全部预装完成的。  
&#8194;&#8194;**重点是服务器上这个目录里只需要`wg0.conf`这样一个 “服务器配置文件”其他的都可以删除忽略并不是占空间，而是为了保护公私密钥的安全性。**  
   * 下面我们先要为服务器及客户端建立密钥。这里要注意的是除了`wg0.conf`以外的其他文件都可以随意取名包括钥匙，因为你不写脚本手动配置，只要自己记得清楚无所谓。  
   第一种方法如下：  
```
wg genkey | tee sprivatekey | wg pubkey > spublickey // 生成服务器私钥与公钥及分别文件名
wg genkey | tee cprivatekey | wg pubkey > cpublickey // 生成客户端私钥与公钥及分别文件名
```   
这里`tee`后面和`pubkey >`后面的名字可以随意，只要自己能记住就行。这种方法是在写执行脚本时常用。手动生成还有另外一种方法。如下密钥名称是个人习惯，你可以自行修改。  
```
wg genkey | tee serverkey | wg pubkey >> serverkey
wg genkey | tee pckey | wg pubkey >> pckey
``` 
命令结束后你`ls`后会看见两个文件分别是`serverkey`与`pckey`。这个时候你需要windows的记事本或其他文本编辑器的帮助。  
这时执行`cat serverkey`与`cat pckey`你会得到两对钥匙。**一定区分开，不能看浑了。同时复制两对时钥匙时多敲几个回车键加一隔开。**  
```
0MT+2fQBtHOCqRAUyXYrVLXiOmyQ3lksJSsdTCwdvk0= // 服务器私钥
lK5STTx8DGFK7fVZyhY+Ppw/dYoqi7rHBte9lSGot2M= // 服务器公钥
```  
```
CEAB1isWSc2B2+IYFCZdQa7xDVueEMhZwZ7hy2dnMG8= //客户端私钥
4wobuxeoK/69Ei2W9Opc8KH3Hkwxbxf3wMjA+pCaZz8= //客户端公钥
```  
那个记事本复制以下，方便下面的配置编写。  
  * **下面开始编写最重要的wg0.conf文件内容。**  
  新建在wireguard本目录中直接新建`wg0.conf`文件。`sudo vim wg0.conf`  
直接进入编写。代码如下。  
```
[Interface]
PrivateKey = 0MT+2fQBtHOCqRAUyXYrVLXiOmyQ3lksJSsdTCwdvk0= // 服务器私钥
Address = 172.16.2.249/29
PostUp   = iptables -A FORWARD -i wg0 -j ACCEPT; iptables -A FORWARD -o wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 // 出口网卡名称 -j MASQUERADE
PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -D FORWARD -o wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 // 出口网卡名称 -j MASQUERADE
ListenPort = 35421 //建议时20000——50000之间任意选
DNS = 8.8.8.8
MTU = 1500

[Peer]
PublicKey = 4wobuxeoK/69Ei2W9Opc8KH3Hkwxbxf3wMjA+pCaZz8= //客户端公钥
AllowedIPs = 172.16.2.250/32
```  
至于为什么要这样编译配置文件请看这篇文章[关于WireGuard的延伸性配置及IP控制的应用](https://github.com/szhaolu/Ubuntu/blob/master/WireGuard/%E5%85%B3%E4%BA%8EWireGuard%E7%9A%84%E5%BB%B6%E4%BC%B8%E6%80%A7%E9%85%8D%E7%BD%AE%E5%8F%8AIP%E6%8E%A7%E5%88%B6%E7%9A%84%E5%BA%94%E7%94%A8.md)在这里我就不废话罗嗦了。  
