## Wireguard测试兼容版安装方法  
在日常安装时，我们发现Wireguard更新时长较慢，在一些版本中可能还有一些不完善的缺陷。但是Linux程序库中在GitHub库中更新也较为慢。当我们发现一些当前Wireguard缺陷时也无法及时修复与更新，只能干着急着。这里我可以用Wireguard原库中的测试版来体验和修复之前版本出现的各种问题。  
## 安装前的准备工作  
* 下载Wireguard测试版程序与Wireguard-tools程序。  
这里我们测试版程序依wireguard-linux-compat-0.0.20200215.tar.xz为例。  
这里我们工具包程序依wireguard-tools-1.0.20200206.tar.xz为例。  
[下载Wireguard兼容版](https://git.zx2c4.com/wireguard-linux-compat/snapshot/wireguard-linux-compat-0.0.20200215.tar.xz)  
[下载Wireguard工具包](https://git.zx2c4.com/wireguard-tools/snapshot/wireguard-tools-1.0.20200206.tar.xz)  
* 检查并抄录自己的主机的网卡名称及IP地址。这里说一下以阿里云为例，它的轻量级服务器是不显示外网网卡名称的。这时我们只需要记录下主机的内网卡名称即可。  
最后要检查一下主机是否自行安装过BBR加速。代码如下：`sudo sysctl -p`即可查看。如果有预先安装就留着，没有的话也不用刻意去安装。除非你的主机线路不是太好的情况下可以安装一个。  
**这里重点说一下：测试版兼容版漏洞和程序故障较多，没有特别必要时其实本人还是不太建议使用的。除非Wireguard完成程序库中长期无更新时，可以考虑安装兼容测试版。**  
## 我们现在开始进入安装步骤。  
* 安装必要的相关程序。  

```
sudo apt-get update -y //更新apt-get库文件。
sudo apt-get install -y bc gcc make libmnl-dev libelf-dev //安装更新必要的系统程序文件。如果你的wireguard还要二位码显示要加上安装 qrencode。（一般不需要。）
sudo apt-get install -y vim wget git net-tools curl //安装一些必要的编译软件和下载程序。
sudo apt-get install -y software-properties-common //安装software-properties程序。**比较重要这个在下面的ppa需要此服务的支持。**
sudo apt-get install -y openresolv //安装OpenVPN服务。
sudo add-apt-repository -y ppa:wireguard/wireguard //安装ppa挂载包。
```  
  
* 修改系统内核接口。  
`vim /etc/sysctl.conf`  
进入文件找到`#net.ipv4.ip_forward = 1`去除#符号注解。`:wq`保存。  
这里说一下，如果系统预安装好了BBR加速的话，在sysctl.conf文件最后会有如下代码：  
```
net.core.default_qdisc=fq
net.ipv4.tcp_congestion_control=bbr
```  
  

* 保存退出以后执行`sudo sysctl -p`命令显示如下：  
```
net.ipv6.conf.all.accept_ra = 2
net.core.default_qdisc=fq
net.ipv4.tcp_congestion_control=bbr
net.ipv4.ip_forward = 1
```  
  
* 确认`ip_forward`数值是否为 1 。命令如下：  
`cat /proc/sys/net/ipv4/ip_forward`  
命令结束后只会显示 1 一个字符。即为正常。  
* 接下来开始下载wireguard测试程序及wireguard工具包。  
`sudo wget https://git.zx2c4.com/wireguard-linux-compat/snapshot/wireguard-linux-compat-0.0.20200215.tar.xz`  
`sudo wget https://git.zx2c4.com/wireguard-tools/snapshot/wireguard-tools-1.0.20200206.tar.xz`  
下载完成后开始解压缩两个安装包。  
`sudo tar xvJf wireguard-linux-compat-0.0.20200215.tar.xz`  
`sudo tar xvJf wireguard-tools-1.0.20200206.tar.xz`  
* 弄好之后我们先安装工具包。进入wireguard-tools-1.0.20200206\src 目录。  
`cd wireguard-tools-1.0.20200206\src`  
执行命令`make`行进WireGuard-tools的安装。  
* 退出到主目录，进入wireguard-linux-compat-0.0.20200215\src 目录。  
`cd wireguard-linux-compat-0.0.20200215\src`  
执行命令`make module`进行WireGuard模块的安装。  
* 退出到主目录 再次进入`wireguard-tools-1.0.20200206\src`  
执行命令`make install`WireGuard工具包挂载。  
* 退出到主目录 再次进入`wireguard-linux-compat-0.0.20200215\src`  
执行命令`make install`WireGuard程序挂载。  
**弄到这里wireguard兼容测试版本安装完成**  
##下面我们开始配置wireguard。  
相关的配置步骤与手动安装wireguard配置步骤一致。可以参考[手动安装WireGuard服务端及配置](https://github.com/szhaolu/Ubuntu/blob/master/WireGuard/%E6%89%8B%E5%8A%A8%E5%AE%89%E8%A3%85WireGuard%E6%9C%8D%E5%8A%A1%E7%AB%AF%E5%8F%8A%E9%85%8D%E7%BD%AE.md)  
这里需要关注配置部分的内容和公私密钥的生成部分即可。  

##最后总结  
* 1、如果没有什么特别必要的情况，不要轻易尝试测试版本。
* 2、如果你的主机提供商对OS的系统还原支持不是很理想的话也不建议尝试更新或者是测试。  
一旦出现问题系统还原是个不小的问题。  
* 3、如果你的系统中混装了UDP-RAW也不太建议安装测试兼容版。可能稳定性会有一定的影响，建议安装完整包。  
* 4、如果你的的主机做的NET-VPS中转加速。相关的加速主机建议也一并同步更新。
