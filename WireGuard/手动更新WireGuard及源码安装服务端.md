# 手动更新WireGuard及源码安装服务端  
在日常的安装时,我们一般使用这条命令`sudo apt-get install -y wireguard`也就安装完成了。其方法简单，源码包也是定时从“https://github.com/WireGuard/WireGuard”这个库中获取最新的安装包。但实际情况是安装包更新后未必能有旧版本的性能和出现一些不稳定的BUG。例如下面两个源码：  
```
WireGuard-0.0.20191127.tar.xz 
WireGuard-0.0.20191012.tar.xz 
```  
这两个源码包`11月27日`的安装包比它前一次更新时的安装包`10月12日`的就要差的多，但“WireGuard-0.0.20191127.tar.xz”是目前最新的开源包。如果不是绝对的相关程序的开发“老鼠”最好不要轻易尝试修改源码文件。  
两个程序在同一网络环境，同一硬件设备中的表现新包明显对网速流量做了限额。流量瓶颈时会出现掉线情况。需要BBR的支持才能勉强确保不掉线。在双测同时开启BBR时“WireGuard-0.0.20191127.tar.xz”比“WireGuard-0.0.20191012.tar.xz”网速有被压制现象预估大约被限额15%-20%的网速流量。  
Youtube视频1080P@60的画质同一视频文件大约速率11月的新程序包比10月的旧包下滑了要有2000kpbs-5000kpbs左右。视频缓存率基本只能维持在110s左右，从0s—120s时间爬升较为缓慢。能难维持在120以上。  
10月12日旧安装包，安装之后同一视频，缓存率基本能维持在115s-125s左右。视频速率也明显比11月的新包要快一点。有明显差异。如果您愿意可以自己尝试测试看看。  
## 从源码包中安装WireGuard。  
这里只重点说源码包的安装方法，至于您要直接安装新的WireGuard程序请参考[这篇文章](https://github.com/szhaolu/Ubuntu/blob/master/WireGuard/%E6%89%8B%E5%8A%A8%E5%AE%89%E8%A3%85WireGuard%E6%9C%8D%E5%8A%A1%E7%AB%AF%E5%8F%8A%E9%85%8D%E7%BD%AE.md)。  
* 1、首先我们先要登陆[WireGuard的源码库](https://git.zx2c4.com/WireGuard)找到你需要的源码包。这我们以“WireGuard-0.0.20191012.tar.xz”为例。**这里说一下更新WireGuard与安装相同，[注意的是只能往前不能倒退。若你要退回前一个版本必须要将WireGuard全部卸载重新源码安装。即可]**  
**还有图省事儿更新`sudo apt-get install -y wireguard `也是可以的。前提是你的Ubuntu系统远段的`apt-get`库里已经更新过了你在能使用这条命令，否则更新无数遍也是徒劳。一般系统库会比wireguard源码更新慢几天。**  
* 2、开始操作步骤如下：  
更新必要的系统必须程序**如果您要安装BBR请先安装好BBR在进行下面的操作。**  
BBR的安装在此略过，可以查阅其他[网站资料](https://bb-r.net)有时间我在说关于google BBR的安装方法。  
```
sudo apt-get update -y //更新apt-get库文件。
sudo apt-get install -y bc gcc make libmnl-dev libelf-dev //安装更新必要的系统程序文件。如果你的wireguard还要二位码显示要加上安装 qrencode。（一般不需要。）
sudo apt-get install -y vim wget git net-tools curl //安装一些必要的编译软件和下载程序。
sudo apt-get install -y software-properties-common //安装software-properties程序。**比较重要这个在下面的ppa需要此服务的支持。**
sudo apt-get install -y openresolv //安装OpenVPN服务。
sudo add-apt-repository -y ppa:wireguard/wireguard //安装ppa挂载包。
sudo wget https://git.zx2c4.com/WireGuard/snapshot/WireGuard-0.0.20191012.tar.xz //下载WireGuard-0.0.20191012.tar.xz程序源码包
。
sudo tar xvJf WireGuard-0.0.20191012.tar.xz //解压缩程序源包。
cd WireGuard-0.0.20191012/src //进入src目录。
make tools //WireGuard-tools的安装。
make module //WireGuard模块的安装。
make install //WireGuard挂载。

```  
**接下来就是配置环节请查阅库中的相关文件。这里不做解释了。**  
*这里还是补充说以下：  
新的源码不一定就是最好的，只有适合自己的才是最好的。如果您对原先的程序若是已经有了习惯性的网速流量体验。建议你还是不必更新的好。当然非要更新，建议您最新的前两个相互测试比较一下在决定如何使用。**[注意如果你的服务器或者VPS主机不支持更换系统或者OS初始化系统。更新请慎重。一旦更新后没有达到您的预期，或者不如以前。更换新的系统较为麻烦。]**  
