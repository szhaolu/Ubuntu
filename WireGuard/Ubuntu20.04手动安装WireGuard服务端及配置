# Ubuntu20.04手动安装WireGuard服务端及配置  
任何一套全新的OS系统第一件事情就是先修改DNS配置，然后在安装bbr加速。（这里自己寻找相关教程资料这里不过多赘述了。）  
完成bbr安装后，确定没有问题后。开始安装相关的必要程序。  
# 现在开始安装  
~~~  sudo apt-get update -y //更新apt-get库文件。
sudo apt-get install -y bc gcc make libmnl-dev libelf-dev //安装更新必要的系统程序文件。如果你的wireguard还要二位码显示要加上安装 qrencode。（一般不需要。）
sudo apt-get install -y vim wget git net-tools curl //安装一些必要的编译软件和下载程序。
sudo apt-get install -y software-properties-common //安装software-properties程序。
sudo apt-get install -y openresolv //安装OpenVPN服务。（这里还是建议完全安装。）（如果你不借用tcp通信，不使用Tunsafe可以选择不装，）
sudo apt-get install -y wireguard //安装wireguard。(Ubuntu库里文件。)
~~~  

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
# 关于服务端配置文件的设置请参考本库中的《手动安装WireGuard服务端及配置》  
# 下面重点将一下在无外联情况中下载WireGuard客户端（Windows版）  
这里最直接的方法就是用VPS代替你的电脑去官方网站下载客户端。  
* 直接使用服务端curl命令打开[wireguard官方下载网站](https://download.wireguard.com/windows-client/)  
```
sudo curl https://download.wireguard.com/windows-client/ 
```  
在显示的其中找到wireguard-amd64-*.msi的字符。然后在复制以相符的字符后再次拼接到windows-client后面。  
```
sudo wget https://download.wireguard.com/windows-client/wireguard-amd64-0.4.5.msi
```  
再使用 WinSCP类似工具回传即可，这样客户端添加好客户端配置文件就正常使用了。（这里要注意WireGuard官方客户端通行的是UDP协议。）  
如果你要速度不够要更改TCP通信服务器端一定要安装OpenVPN服务。在使用Tunsafe连接。客户端配置一样即可。  
