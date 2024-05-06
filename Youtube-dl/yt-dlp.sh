#!/bin/bash
green(){

echo -e "\033[43;42m\033[01m$1\033[0m" 

}

yellow(){

echo -e "\033[0;33m\033[01m$1\033[0m"

}

red(){ 

echo -e "\033[44;31m\033[01m$1\033[0m"

}

yt-dlp_install(){
        sudo apt-get update -y
		sudo apt-get upgrade -y
		sudo apt-get install -y wget net-tools vim curl git yasm make gcc bash-completion
		sudo apt-get install -y libsdl1.2-dev --fix-missing
		mkdir /home/ffmpeg
		cd /home/ffmpeg
		sudo wget https://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2
		sudo wget https://www.libsdl.org/release/SDL2-2.28.3.tar.gz
		sudo tar -xvf SDL2-2.28.3.tar.gz
		sudo tar -xvf ffmpeg-snapshot.tar.bz2
		cd /home/ffmpeg/SDL2-2.28.3
		./configure
		make && make install
		cd /home/ffmpeg/ffmpeg
		./configure
		make && make install
		cd /home/ffmpeg
		sudo curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o /usr/local/bin/yt-dlp
		sudo chmod -R 777 /usr/local/bin/yt-dlp
		sudo mkdir /home/youtube
		}
		
yt-dlp_update(){
        yt-dlp -U
		}

language_install(){
		 sudo apt-get update -y
		 sudo apt-get install -y wget net-tools vim curl git yasm make gcc
		 sudo apt-get install -y libsdl1.2-dev --fix-missing
         sudo apt-get install -y language-pack-zh-hans
		 sudo apt-get install -y language-pack-zh-hant
		 sudo apt-get install $(check-language-support) -y
sudo cat > /etc/default/locale <<-EOF
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
LC_ALL="zh_CN.UTF-8"
EOF

sudo cat > /etc/environment <<-EOF
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
LC_ALL="zh_CN.UTF-8"
EOF


yellow " VPS正在重启请稍候！" 
sleep 5s
reboot
}

yt-dlp_wget(){
     read -p "请输入视频网页地址: " address
	 yt-dlp -F $address
	 read  -p "请输入视频格式编号: " video
	 read  -p "请输入音频格式编号: " audio
	 yt-dlp -f $video+$audio $address
	 clear
	 yellow "视频下载成功!"
	 red "如果您的VPS在下载时速度明显下降或者下载失败，请清理yt-dlp缓存，又或许您需要升级yt-dlp和SDL2与FFmpeg即可。"
	 ls
	 
}

yt-dlp_curl(){
	clear
	green ">>>>>>>>>>>>>>>>>>>>>>>>>>>"
	green " 名称：yt-dlp一键安装      "
	green " 俗称：YouTube下载工具     "
	green " 版本：随安装时自动迭代跟新"
	green " 支持系统：Ubuntu18.04以上 "
	green " 脚本编译：szhaolu         "
	green ">>>>>>>>>>>>>>>>>>>>>>>>>>>"
	echo
	red    " 请更具自己VPS空间大小合理使用此项。"
	yellow " 1.创建文件夹后下载视频集内容 "
	green  " 下载时视频地址标签保留"
	yellow " 2.自动默认下载视频集内容"
	green  " 下载时去除视频地址标签，以标题名结尾 "
	green  " 地址标签被保留在videos文本文件中，确保下次使用时不会重复下载。"
	
	read -e -p "(直接回车: 取消):" num1
	[[ -z "${num1}" ]] && echo "已取消..." && exit 1
	if [[ "${num1}" == "1" ]]; then
	read -p "请输入新建文件名: " folder
	mkdir $folder
	cd $folder
	read -p "请输入视频目录地址: " user	
	yt-dlp -f 'bv*+ba*' $user -o '%(channel)s/%(title)s.%(ext)s' 
	elif [[ "${num1}" == "2" ]]; then
	yt-dlp -f 'bv*+ba*' --download-archive videos.txt $user -o '%(channel)s/%(title)s.%(ext)s' 
	else
		echo -e "错误！请输入正确的数字(1-2)" && exit 1
	fi
}

yt-dlp_rm(){
	clear
	red "正在清理yt-dlp缓存请稍候!"
	yt-dlp --rm-cache-dir
	red "正在清理完成!"
	ls
	}

yt-dlp_del(){
	clear
	red "正在删除当前目录下的YouTube视频文件请稍候!（只针对webm格式的视频文件有效。）"
	sudo rm -rf *.webm *.mp3 *.mkv *.mp4
	red "正在清理完成!"
	ls
	}
	
yt-dlp_bbr(){
clear
	green ">>>>>>>>>>>>>>>>>>>>>>>>>>>"
	green " 名称：yt-dlp一键安装      "
	green " 俗称：YouTube下载工具     "
	green " 版本：随安装时自动迭代跟新"
	green " 支持系统：Ubuntu18.04以上 "
	green " 脚本编译：szhaolu         "
	green ">>>>>>>>>>>>>>>>>>>>>>>>>>>"
	echo
	red    " 请更具自己VPS空间大小合理使用此项。"
	yellow " 1.BBR简易开启 "
	yellow " 2.BBR完全安装与加载"
	green  " 如果BBR的简易安装无法启动BBR，建议完全安装BBR。"
	
	read -e -p "(直接回车: 取消):" num1
	[[ -z "${num1}" ]] && echo "已取消..." && exit 1
	if [[ "${num1}" == "1" ]]; then
	sudo cat > /etc/sysctl.conf <<-EOF
	net.core.default_qdisc=fq
	net.ipv4.tcp_congestion_control=bbr
	EOF
	sysctl -p
	elif [[ "${num1}" == "2" ]]; then
	sudo wget --no-check-certificate https://raw.githubusercontent.com/cx9208/Linux-NetSpeed/master/tcp.sh && chmod +x tcp.sh && ./tcp.sh 
	else
		echo -e "错误！请输入正确的数字(1-2)" && exit 1
	fi
}

start_meun(){
    clear
	green ">>>>>>>>>>>>>>>>>>>>>>>>>>>"
	green " 名称：yt-dlp一键安装      "
	green " 俗称：YouTube下载工具     "
	green " 版本：随安装时自动迭代跟新"
	green " 支持系统：Ubuntu18.04以上 "
	green " 脚本编译：szhaolu         "
	green ">>>>>>>>>>>>>>>>>>>>>>>>>>>"
	echo
	yellow " 1.安装yt-dlp程序 "
	yellow " 2.升级yt-dlp程序 "
	yellow " 3.安装中文语言包"
	yellow " 4.下载YouTube视频"
	yellow " 5.下载YouTube视频目录"
	yellow " 6.清理yt-dlp缓存 "
	yellow " 7.删除当前目录下所有的YouTube视频"
	yellow " 8.BBR简易加载与完全安装"
	green " 不是所有的VPS主机都需要安装中文语言包，请根据实际下载视频标题情况而定。 "
	echo -e "0. 退出脚本。"
	echo
	read -p "请输入数字：" num
	case "$num" in
	1)
	yt-dlp_install
	;;
	2)
	yt-dlp_update
	;;
	3)
	language_install
	;;
	4)
	yt-dlp_wget
	;;
	5)
	yt-dlp_curl
	;;
	6)
	yt-dlp_rm
	;;
	7)
	yt-dlp_del
	;;
	8)
	yt-dlp_bbr
	;;
	0)
	exit 1
	;;
	*)
	clear
	red "请输入正确的数字。"
	sleep 3s
	start_meun
	;;
    esac
	
	}
	
	start_meun