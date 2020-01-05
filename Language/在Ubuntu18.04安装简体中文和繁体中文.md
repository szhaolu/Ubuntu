# 在Ubuntu18.04安装简体中文和繁体中文。  
在使用web服务和Youtube-dl时你会发现有些裸机VPS时，会出现无法显示中文标题和内容。给我们造成了一些视觉感观上的不适。下面简单介绍一下安装中文字库包。  
**我们在安装前先运行`echo $LANG`这条命令查看当前语言环境。如果没有中文语言包默认应该是`us_en`或者是`us_UTF-8`。**  
## 我们现在开始安装中文包。 
* 这里我们我们同时安装简体与繁体。  
执行  
```
sudo apt-get install -y language-pack-zh-hans
sudo apt-get install -y language-pack-zh-hant
````  
下面我们执行`sudo apt install $(check-language-support)`这条命令，检查系统语言环境。  
用vim编译配置文件。`vim /etc/default/locale`删除里面所有内容。添加下面所有内容。  
```
LANG="zh_CN.UTF-8"
LANGUAGE="zh_CN:zh"
LC_NUMERIC="zh_CN"
LC_TIME="zh_CN"
LC_MONETARY="zh_CN"
LC_PAPER="zh_CN"
LC_NAME="zh_CN"
LC_ADDRESS="zh_CN"
LC_TELEPHONE="zh_CN"
LC_MEASUREMENT="zh_CN"
LC_IDENTIFICATION="zh_CN"
LC_ALL="zh_CN.UTF-8
```  
：wq保存。  

继续我们下面修改语言环境文件，执行`vim /etc/environment `。进入后保留已有的内容。在下面空白处添加如下内容。  
```
LANG="zh_CN.UTF-8"
LANGUAGE="zh_CN:zh"
LC_NUMERIC="zh_CN"
LC_TIME="zh_CN"
LC_MONETARY="zh_CN"
LC_PAPER="zh_CN"
LC_NAME="zh_CN"
LC_ADDRESS="zh_CN"
LC_TELEPHONE="zh_CN"
LC_MEASUREMENT="zh_CN"
LC_IDENTIFICATION="zh_CN"
LC_ALL="zh_CN.UTF-8
```  
：wq保存。  
全部弄完以后，`reboot`重启即可。  
