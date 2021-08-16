#!/usr/bin/env bash
export PATH=$PATH:/usr/local/bin

red(){
    echo -e "\033[31m\033[01m$1\033[0m"
}
green(){
    echo -e "\033[32m\033[01m$1\033[0m"
}
yellow(){
    echo -e "\033[33m\033[01m$1\033[0m"
}
blue(){
    echo -e "\033[36m\033[01m$1\033[0m"
}
white(){
    echo -e "\033[1;37m\033[01m$1\033[0m"
}

bblue(){
    echo -e "\033[1;34m\033[01m$1\033[0m"
}

rred(){
    echo -e "\033[1;35m\033[01m$1\033[0m"
}


	if [[ -f /etc/redhat-release ]]; then
		release="Centos"
	elif cat /etc/issue | grep -q -E -i "debian"; then
		release="Debian"
	elif cat /etc/issue | grep -q -E -i "ubuntu"; then
		release="Ubuntu"
	elif cat /etc/issue | grep -q -E -i "centos|red hat|redhat"; then
		release="Centos"
	elif cat /proc/version | grep -q -E -i "debian"; then
		release="Debian"
	elif cat /proc/version | grep -q -E -i "ubuntu"; then
		release="Ubuntu"
	elif cat /proc/version | grep -q -E -i "centos|red hat|redhat"; then
		release="Centos"
    fi

if ! type curl >/dev/null 2>&1; then
	   yellow "curl 未安装，安装中 "
           sudo apt update && apt install curl -y 
           else
           green "curl 已安装，继续 "
fi

        if ! type wget >/dev/null 2>&1; then
           yellow "wget 未安装 安装中 "
           sudo apt update && apt install wget -y 
           else
           green "wget 已安装，继续 "
fi  

bit=`uname -m`
version=`uname -r | awk -F "-" '{print $1}'`
main=`uname  -r | awk -F . '{print $1 }'`
minor=`uname -r | awk -F . '{print $2}'`
rv4=`ip a | grep global | awk 'NR==1 {print $2}' | cut -d'/' -f1`
rv6=`ip a | grep inet6 | awk 'NR==2 {print $2}' | cut -d'/' -f1`
op=`hostnamectl | grep -i Operating | awk -F ':' '{print $2}'`
vi=`hostnamectl | grep -i Virtualization | awk -F ':' '{print $2}'`

if [[ ${vi} == " kvm" ]]; then
green " ---VPS扫描中---> "

elif [[ ${vi} == " xen" ]]; then
green " ---VPS扫描中---> "

elif [[ ${vi} == " microsoft" ]]; then
green " ---VPS扫描中---> "

else
yellow " 虚拟架构类型 - $vi "
yellow " 对此vps架构不支持，脚本安装自动退出，赶紧提醒甬哥加上你的架构吧！"
exit 1
fi

yellow " VPS相关信息如下："
    white "------------------------------------------"
    blue " 操作系统名称 -$op "
    blue " 系统内核版本 - $version " 
    blue " CPU架构名称  - $bit "
    blue " 虚拟架构类型 -$vi "
    white " -----------------------------------------------" 
sleep 1s

warpwg=$(systemctl is-active wg-quick@wgcf)
case ${warpwg} in
active)
     WireGuardStatus=$(green "运行中")
     ;;
*)
     WireGuardStatus=$(red "未运行")
esac


v44=`ping ipv4.google.com -c 1 | grep received | awk 'NR==1 {print $4}'`

if [[ ${v44} == "1" ]]; then
 v4=`wget -qO- -4 ip.gs` 
 WARPIPv4Status=$(curl -s4 https://www.cloudflare.com/cdn-cgi/trace | grep warp | cut -d= -f2) 
 case ${WARPIPv4Status} in 
 on) 
 WARPIPv4Status=$(green "WARP已开启,当前IPV4地址：$v4 ") 
 ;; 
 off) 
 WARPIPv4Status=$(yellow "WARP未开启，当前IPV4地址：$v4 ") 
 esac 
else
WARPIPv4Status=$(red "不存在IPV4地址 ")

 fi 

v66=`ping ipv6.google.com -c 1 | grep received | awk 'NR==1 {print $4}'`

if [[ ${v66} == "1" ]]; then
 v6=`wget -qO- -6 ip.gs` 
 WARPIPv6Status=$(curl -s6 https://www.cloudflare.com/cdn-cgi/trace | grep warp | cut -d= -f2) 
 case ${WARPIPv6Status} in 
 on) 
 WARPIPv6Status=$(green "WARP已开启,当前IPV6地址：$v6 ") 
 ;; 
 off) 
 WARPIPv6Status=$(yellow "WARP未开启，当前IPV6地址：$v6 ") 
 esac 
else
WARPIPv6Status=$(red "不存在IPV6地址 ")

 fi 
 
Print_ALL_Status_menu() {
blue "-----------------------"
blue "WGCF 运行状态\t: ${WireGuardStatus}"
blue "IPv4 网络状态\t: ${WARPIPv4Status}"
blue "IPv6 网络状态\t: ${WARPIPv6Status}"
blue "-----------------------"
}

if [[ ${bit} == "x86_64" ]]; then

function wo646(){
yellow " 检测系统内核版本是否大于5.6版本 "
if [ "$main" -lt 5 ]|| [ "$minor" -lt 6 ]; then 
	red " 检测到内核版本小于5.6，回到菜单，选择2，自动更新内核吧"
	exit 1
fi

if [ $release = "Centos" ]
	then
	        yum update -y
                yum install curl wget -y && yum install sudo -y
		yum install epel-release -y		
		yum install -y \
                https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
                curl -o /etc/yum.repos.d/jdoss-wireguard-epel-7.repo \
                https://copr.fedorainfracloud.org/coprs/jdoss/wireguard/repo/epel-7/jdoss-wireguard-epel-7.repo
                yum install wireguard-tools -y
	elif [ $release = "Debian" ]
	then
		apt-get update -y
		apt-get install curl wget -y && apt install sudo -y
		apt-get install openresolv -y
		echo "deb http://deb.debian.org/debian/ unstable main" > /etc/apt/sources.list.d/unstable-wireguard.list
		printf 'Package: *\nPin: release a=unstable\nPin-Priority: 150\n' > /etc/apt/preferences.d/limit-unstable
		apt-get install linux-headers-`uname -r` -y
		apt-get install wireguard-tools -y
	elif [ $release = "Ubuntu" ]
	then
		apt-get update -y
		apt-get install curl wget -y &&  apt install sudo -y
		apt -y --no-install-recommends install openresolv dnsutils wireguard-tools
	else
		yellow " 不支持当前系统 "
		exit 1
	fi
wget -N -6 https://cdn.jsdelivr.net/gh/YG-tsj/EUserv-warp/wgcf
cp wgcf /usr/local/bin/wgcf
sudo chmod +x /usr/local/bin/wgcf
echo | wgcf register
until [ $? -eq 0 ]
do
sleep 1s
echo | wgcf register
done
wgcf generate
sed -i "5 s/^/PostUp = ip -6 rule add from $rv6 table main\n/" wgcf-profile.conf
sed -i "6 s/^/PostDown = ip -6 rule delete from $rv6 table main\n/" wgcf-profile.conf
sed -i 's/engage.cloudflareclient.com/2606:4700:d0::a29f:c001/g' wgcf-profile.conf
sed -i 's/1.1.1.1/8.8.8.8,2001:4860:4860::8888/g' wgcf-profile.conf
cp wgcf-account.toml /etc/wireguard/wgcf-account.toml
cp wgcf-profile.conf /etc/wireguard/wgcf.conf
systemctl enable wg-quick@wgcf
systemctl start wg-quick@wgcf
rm -f wgcf*
grep -qE '^[ ]*precedence[ ]*::ffff:0:0/96[ ]*100' /etc/gai.conf || echo 'precedence ::ffff:0:0/96  100' | sudo tee -a /etc/gai.conf
yellow " 检测是否成功启动（IPV4+IPV6）双栈Warp！\n 显示IPV4地址：$(wget -qO- -4 ip.gs) 显示IPV6地址：$(wget -qO- -6 ip.gs) "
green " 如上方显示IPV4地址：8.…………，IPV6地址：2a09:…………，则说明成功啦！\n 如上方IPV4无IP显示,IPV6显示本地IP,则说明失败喽！！ "
}

function wo66(){
yellow " 检测系统内核版本是否大于5.6版本 "
if [ "$main" -lt 5 ]|| [ "$minor" -lt 6 ]; then 
	red " 检测到内核版本小于5.6，回到菜单，选择2，自动更新内核吧"
	exit 1
fi

if [ $release = "Centos" ]
	then
	        yum update -y
                yum install curl wget -y && yum install sudo -y
		yum install epel-release -y		
		yum install -y \
                https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
                curl -o /etc/yum.repos.d/jdoss-wireguard-epel-7.repo \
                https://copr.fedorainfracloud.org/coprs/jdoss/wireguard/repo/epel-7/jdoss-wireguard-epel-7.repo
                yum install wireguard-tools -y
	elif [ $release = "Debian" ]
	then
		apt-get update -y
		apt-get install curl wget -y && apt install sudo -y
		apt-get install openresolv -y
		echo "deb http://deb.debian.org/debian/ unstable main" > /etc/apt/sources.list.d/unstable-wireguard.list
		printf 'Package: *\nPin: release a=unstable\nPin-Priority: 150\n' > /etc/apt/preferences.d/limit-unstable
		apt-get install linux-headers-`uname -r` -y
		apt-get install wireguard-tools -y
	elif [ $release = "Ubuntu" ]
	then
		apt-get update -y
		apt-get install curl wget -y &&  apt install sudo -y
		apt -y --no-install-recommends install openresolv dnsutils wireguard-tools
	else
		yellow " 不支持当前系统 "
		exit 1
	fi
wget -N -6 https://cdn.jsdelivr.net/gh/YG-tsj/EUserv-warp/wgcf
cp wgcf /usr/local/bin/wgcf
sudo chmod +x /usr/local/bin/wgcf
echo | wgcf register
until [ $? -eq 0 ]
do
sleep 1s
echo | wgcf register
done
wgcf generate
sed -i "5 s/^/PostUp = ip -6 rule add from $rv6 table main\n/" wgcf-profile.conf
sed -i "6 s/^/PostDown = ip -6 rule delete from $rv6 table main\n/" wgcf-profile.conf
sed -i 's/engage.cloudflareclient.com/2606:4700:d0::a29f:c001/g' wgcf-profile.conf
sed -i '/0\.0\.0\.0\/0/d' wgcf-profile.conf
sed -i 's/1.1.1.1/2001:4860:4860::8888,8.8.8.8/g' wgcf-profile.conf
cp wgcf-account.toml /etc/wireguard/wgcf-account.toml
cp wgcf-profile.conf /etc/wireguard/wgcf.conf
systemctl enable wg-quick@wgcf
systemctl start wg-quick@wgcf
rm -f wgcf*
grep -qE '^[ ]*label[ ]*2002::/16[ ]*2' /etc/gai.conf || echo 'label 2002::/16   2' | sudo tee -a /etc/gai.conf
yellow " 检测是否成功启动Warp！\n 显示IPV6地址：$(wget -qO- -6 ip.gs) "
green " 如上方显示IPV6地址：2a09:…………，则说明成功！\n 如上方IPV6显示本地IP，则说明失败喽！ "
}

function wo64(){
yellow " 检测系统内核版本是否大于5.6版本 "
if [ "$main" -lt 5 ]|| [ "$minor" -lt 6 ]; then 
	red " 检测到内核版本小于5.6，回到菜单，选择2，自动更新内核吧"
	exit 1
fi

if [ $release = "Centos" ]
	then
	        yum update -y
                yum install curl wget -y && yum install sudo -y
		yum install epel-release -y		
		yum install -y \
                https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
                curl -o /etc/yum.repos.d/jdoss-wireguard-epel-7.repo \
                https://copr.fedorainfracloud.org/coprs/jdoss/wireguard/repo/epel-7/jdoss-wireguard-epel-7.repo
                yum install wireguard-tools -y
	elif [ $release = "Debian" ]
	then
		apt-get update -y
		apt-get install curl wget -y && apt install sudo -y
		apt-get install openresolv -y
		echo "deb http://deb.debian.org/debian/ unstable main" > /etc/apt/sources.list.d/unstable-wireguard.list
		printf 'Package: *\nPin: release a=unstable\nPin-Priority: 150\n' > /etc/apt/preferences.d/limit-unstable
		apt-get install linux-headers-`uname -r` -y
		apt-get install wireguard-tools -y
	elif [ $release = "Ubuntu" ]
	then
		apt-get update -y
		apt-get install curl wget -y &&  apt install sudo -y
		apt -y --no-install-recommends install openresolv dnsutils wireguard-tools
	else
		yellow " 不支持当前系统 "
		exit 1
	fi
wget -N -6 https://cdn.jsdelivr.net/gh/YG-tsj/EUserv-warp/wgcf
cp wgcf /usr/local/bin/wgcf
sudo chmod +x /usr/local/bin/wgcf
echo | wgcf register
until [ $? -eq 0 ]
do
sleep 1s
echo | wgcf register
done
wgcf generate
sed -i 's/engage.cloudflareclient.com/2606:4700:d0::a29f:c001/g' wgcf-profile.conf
sed -i '/\:\:\/0/d' wgcf-profile.conf
sed -i 's/1.1.1.1/8.8.8.8,2001:4860:4860::8888/g' wgcf-profile.conf
cp wgcf-account.toml /etc/wireguard/wgcf-account.toml
cp wgcf-profile.conf /etc/wireguard/wgcf.conf
systemctl enable wg-quick@wgcf
systemctl start wg-quick@wgcf
rm -f wgcf*
grep -qE '^[ ]*precedence[ ]*::ffff:0:0/96[ ]*100' /etc/gai.conf || echo 'precedence ::ffff:0:0/96  100' | sudo tee -a /etc/gai.conf
yellow " 检测是否成功启动Warp！\n 显示IPV4地址：$(wget -qO- -4 ip.gs) "
green " 如上方显示IPV4地址：8.…………，则说明成功啦！\n 如上方显示VPS本地IP,则说明失败喽！ "
}

function warp6(){
yellow " 检测系统内核版本是否大于5.6版本 "
if [ "$main" -lt 5 ]|| [ "$minor" -lt 6 ]; then 
	red " 检测到内核版本小于5.6，回到菜单，选择2，自动更新内核吧"
	exit 1
fi

if [ $release = "Centos" ]
	then
	        yum update -y
                yum install curl wget -y && yum install sudo -y
		yum install epel-release -y		
		yum install -y \
                https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
                curl -o /etc/yum.repos.d/jdoss-wireguard-epel-7.repo \
                https://copr.fedorainfracloud.org/coprs/jdoss/wireguard/repo/epel-7/jdoss-wireguard-epel-7.repo
                yum install wireguard-tools -y
	elif [ $release = "Debian" ]
	then
		apt-get update -y
		apt-get install curl wget -y && apt install sudo -y
		apt-get install openresolv -y
		echo "deb http://deb.debian.org/debian/ unstable main" > /etc/apt/sources.list.d/unstable-wireguard.list
		printf 'Package: *\nPin: release a=unstable\nPin-Priority: 150\n' > /etc/apt/preferences.d/limit-unstable
		apt-get install linux-headers-`uname -r` -y
		apt-get install wireguard-tools -y
	elif [ $release = "Ubuntu" ]
	then
		apt-get update -y
		apt-get install curl wget -y &&  apt install sudo -y
		apt -y --no-install-recommends install openresolv dnsutils wireguard-tools
	else
		yellow " 不支持当前系统 "
		exit 1
	fi
wget -N https://github.com/ViRb3/wgcf/releases/download/v2.2.3/wgcf_2.2.3_linux_amd64 -O /usr/local/bin/wgcf
sudo chmod +x /usr/local/bin/wgcf
echo | wgcf register
until [ $? -eq 0 ]
do
sleep 1s
echo | wgcf register
done
wgcf generate
sudo sed -i 's/engage.cloudflareclient.com/162.159.192.1/g' wgcf-profile.conf
sudo sed -i '/0\.0\.0\.0\/0/d' wgcf-profile.conf
sudo sed -i 's/1.1.1.1/8.8.8.8,2001:4860:4860::8888/g' wgcf-profile.conf
sudo cp wgcf-account.toml /etc/wireguard/wgcf-account.toml
sudo cp wgcf-profile.conf /etc/wireguard/wgcf.conf
systemctl enable wg-quick@wgcf
systemctl start wg-quick@wgcf
rm -f wgcf*
yellow " 检测是否成功启动Warp！\n 显示IPV6地址：$(wget -qO- -6 ip.gs) "
green " 如上方显示IPV6地址：2a09:…………，则说明成功！\n 如上方无IP显示，则说明失败喽！ "
}

function warp64(){
yellow " 检测系统内核版本是否大于5.6版本 "
if [ "$main" -lt 5 ]|| [ "$minor" -lt 6 ]; then 
	red " 检测到内核版本小于5.6，回到菜单，选择2，自动更新内核吧"
	exit 1
fi

if [ $release = "Centos" ]
	then
	        yum update -y
                yum install curl wget -y && yum install sudo -y
		yum install epel-release -y		
		yum install -y \
                https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
                curl -o /etc/yum.repos.d/jdoss-wireguard-epel-7.repo \
                https://copr.fedorainfracloud.org/coprs/jdoss/wireguard/repo/epel-7/jdoss-wireguard-epel-7.repo
                yum install wireguard-tools -y
	elif [ $release = "Debian" ]
	then
		apt-get update -y
		apt-get install curl wget -y && apt install sudo -y
		apt-get install openresolv -y
		echo "deb http://deb.debian.org/debian/ unstable main" > /etc/apt/sources.list.d/unstable-wireguard.list
		printf 'Package: *\nPin: release a=unstable\nPin-Priority: 150\n' > /etc/apt/preferences.d/limit-unstable
		apt-get install linux-headers-`uname -r` -y
		apt-get install wireguard-tools -y
	elif [ $release = "Ubuntu" ]
	then
		apt-get update -y
		apt-get install curl wget -y &&  apt install sudo -y
		apt -y --no-install-recommends install openresolv dnsutils wireguard-tools
	else
		yellow " 不支持当前系统 "
		exit 1
	fi
wget -N https://github.com/ViRb3/wgcf/releases/download/v2.2.3/wgcf_2.2.3_linux_amd64 -O /usr/local/bin/wgcf
chmod +x /usr/local/bin/wgcf
echo | wgcf register
until [ $? -eq 0 ]
do
sleep 1s
echo | wgcf register
done
wgcf generate
sed -i "5 s/^/PostUp = ip -4 rule add from $rv4 table main\n/" wgcf-profile.conf
sed -i "6 s/^/PostDown = ip -4 rule delete from $rv4 table main\n/" wgcf-profile.conf
sed -i 's/engage.cloudflareclient.com/162.159.192.1/g' wgcf-profile.conf
sed -i 's/1.1.1.1/8.8.8.8,2001:4860:4860::8888/g' wgcf-profile.conf
cp wgcf-account.toml /etc/wireguard/wgcf-account.toml
cp wgcf-profile.conf /etc/wireguard/wgcf.conf
systemctl enable wg-quick@wgcf
systemctl start wg-quick@wgcf
rm -f wgcf*
yellow " 检测是否成功启动（IPV4+IPV6）双栈Warp！\n 显示IPV4地址：$(wget -qO- -4 ip.gs) 显示IPV6地址：$(wget -qO- -6 ip.gs) "
green " 如上方显示IPV4地址：8.…………，IPV6地址：2a09:…………，则说明成功啦！\n 如上方IPV4显示本地IP,IPV6无ip显示，则说明失败喽！！ "
}

function warp4(){
yellow " 检测系统内核版本是否大于5.6版本 "
if [ "$main" -lt 5 ]|| [ "$minor" -lt 6 ]; then 
	red " 检测到内核版本小于5.6，回到菜单，选择2，自动更新内核吧"
	exit 1
fi

if [ $release = "Centos" ]
	then
	        yum update -y
                yum install curl wget -y && yum install sudo -y
		yum install epel-release -y		
		yum install -y \
                https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
                curl -o /etc/yum.repos.d/jdoss-wireguard-epel-7.repo \
                https://copr.fedorainfracloud.org/coprs/jdoss/wireguard/repo/epel-7/jdoss-wireguard-epel-7.repo
                yum install wireguard-tools -y
	elif [ $release = "Debian" ]
	then
		apt-get update -y
		apt-get install curl wget -y && apt install sudo -y
		apt-get install openresolv -y
		echo "deb http://deb.debian.org/debian/ unstable main" > /etc/apt/sources.list.d/unstable-wireguard.list
		printf 'Package: *\nPin: release a=unstable\nPin-Priority: 150\n' > /etc/apt/preferences.d/limit-unstable
		apt-get install linux-headers-`uname -r` -y
		apt-get install wireguard-tools -y
	elif [ $release = "Ubuntu" ]
	then
		apt-get update -y
		apt-get install curl wget -y &&  apt install sudo -y
		apt -y --no-install-recommends install openresolv dnsutils wireguard-tools
	else
		yellow " 不支持当前系统 "
		exit 1
	fi
wget -N https://github.com/ViRb3/wgcf/releases/download/v2.2.3/wgcf_2.2.3_linux_amd64 -O /usr/local/bin/wgcf
chmod +x /usr/local/bin/wgcf
echo | wgcf register
until [ $? -eq 0 ]
do
sleep 1s
echo | wgcf register
done
wgcf generate
sed -i "5 s/^/PostUp = ip -4 rule add from $rv4 table main\n/" wgcf-profile.conf
sed -i "6 s/^/PostDown = ip -4 rule delete from $rv4 table main\n/" wgcf-profile.conf
sed -i 's/engage.cloudflareclient.com/162.159.192.1/g' wgcf-profile.conf
sed -i '/\:\:\/0/d' wgcf-profile.conf
sed -i 's/1.1.1.1/8.8.8.8,2001:4860:4860::8888/g' wgcf-profile.conf
cp wgcf-account.toml /etc/wireguard/wgcf-account.toml
cp wgcf-profile.conf /etc/wireguard/wgcf.conf
systemctl enable wg-quick@wgcf
systemctl start wg-quick@wgcf
rm -f wgcf*
yellow " 检测是否成功启动Warp！\n 显示IPV4地址：$(wget -qO- -4 ip.gs) "
green " 如上方显示IPV4地址：8.…………，则说明成功啦！\n 如上方显示VPS本地IP,则说明失败喽！ "
}

function warp466(){
yellow " 检测系统内核版本是否大于5.6版本 "
if [ "$main" -lt 5 ]|| [ "$minor" -lt 6 ]; then 
	red " 检测到内核版本小于5.6，回到菜单，选择2，自动更新内核吧"
	exit 1
fi

if [ $release = "Centos" ]
	then
	        yum update -y
                yum install curl wget -y && yum install sudo -y
		yum install epel-release -y		
		yum install -y \
                https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
                curl -o /etc/yum.repos.d/jdoss-wireguard-epel-7.repo \
                https://copr.fedorainfracloud.org/coprs/jdoss/wireguard/repo/epel-7/jdoss-wireguard-epel-7.repo
                yum install wireguard-tools -y
	elif [ $release = "Debian" ]
	then
		apt-get update -y
		apt-get install curl wget -y && apt install sudo -y
		apt-get install openresolv -y
		echo "deb http://deb.debian.org/debian/ unstable main" > /etc/apt/sources.list.d/unstable-wireguard.list
		printf 'Package: *\nPin: release a=unstable\nPin-Priority: 150\n' > /etc/apt/preferences.d/limit-unstable
		apt-get install linux-headers-`uname -r` -y
		apt-get install wireguard-tools -y
	elif [ $release = "Ubuntu" ]
	then
		apt-get update -y
		apt-get install curl wget -y &&  apt install sudo -y
		apt -y --no-install-recommends install openresolv dnsutils wireguard-tools
	else
		yellow " 不支持当前系统 "
		exit 1
	fi
wget -N https://github.com/ViRb3/wgcf/releases/download/v2.2.3/wgcf_2.2.3_linux_amd64 -O /usr/local/bin/wgcf
chmod +x /usr/local/bin/wgcf
echo | wgcf register
until [ $? -eq 0 ]
do
sleep 1s
echo | wgcf register
done
wgcf generate
sed -i "5 s/^/PostUp = ip -6 rule add from $rv6 table main\n/" wgcf-profile.conf
sed -i "6 s/^/PostDown = ip -6 rule delete from $rv6 table main\n/" wgcf-profile.conf
sed -i '/0\.0\.0\.0\/0/d' wgcf-profile.conf
sed -i 's/1.1.1.1/8.8.8.8,2001:4860:4860::8888/g' wgcf-profile.conf
cp wgcf-account.toml /etc/wireguard/wgcf-account.toml
cp wgcf-profile.conf /etc/wireguard/wgcf.conf
systemctl enable wg-quick@wgcf
systemctl start wg-quick@wgcf
rm -f wgcf*
yellow " 检测是否成功启动Warp！\n 显示IPV6地址：$(wget -qO- -6 ip.gs) "
green " 如上方显示IPV6地址：2a09:…………，则说明成功啦！\n 如上方无IP显示,则说明失败喽！ "
}

function warp4646(){
yellow " 检测系统内核版本是否大于5.6版本 "
if [ "$main" -lt 5 ]|| [ "$minor" -lt 6 ]; then 
	red " 检测到内核版本小于5.6，回到菜单，选择2，自动更新内核吧"
	exit 1
fi

if [ $release = "Centos" ]
	then
	        yum update -y
                yum install curl wget -y && yum install sudo -y
		yum install epel-release -y		
		yum install -y \
                https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
                curl -o /etc/yum.repos.d/jdoss-wireguard-epel-7.repo \
                https://copr.fedorainfracloud.org/coprs/jdoss/wireguard/repo/epel-7/jdoss-wireguard-epel-7.repo
                yum install wireguard-tools -y
	elif [ $release = "Debian" ]
	then
		apt-get update -y
		apt-get install curl wget -y && apt install sudo -y
		apt-get install openresolv -y
		echo "deb http://deb.debian.org/debian/ unstable main" > /etc/apt/sources.list.d/unstable-wireguard.list
		printf 'Package: *\nPin: release a=unstable\nPin-Priority: 150\n' > /etc/apt/preferences.d/limit-unstable
		apt-get install linux-headers-`uname -r` -y
		apt-get install wireguard-tools -y
	elif [ $release = "Ubuntu" ]
	then
		apt-get update -y
		apt-get install curl wget -y &&  apt install sudo -y
		apt -y --no-install-recommends install openresolv dnsutils wireguard-tools
	else
		yellow " 不支持当前系统 "
		exit 1
	fi
wget -N https://github.com/ViRb3/wgcf/releases/download/v2.2.3/wgcf_2.2.3_linux_amd64 -O /usr/local/bin/wgcf
chmod +x /usr/local/bin/wgcf
echo | wgcf register
until [ $? -eq 0 ]
do
sleep 1s
echo | wgcf register
done
wgcf generate
sed -i "5 s/^/PostUp = ip -4 rule add from $rv4 table main\n/" wgcf-profile.conf
sed -i "6 s/^/PostDown = ip -4 rule delete from $rv4 table main\n/" wgcf-profile.conf
sed -i "7 s/^/PostUp = ip -6 rule add from $rv6 table main\n/" wgcf-profile.conf
sed -i "8 s/^/PostDown = ip -6 rule delete from $rv6 table main\n/" wgcf-profile.conf
sed -i 's/1.1.1.1/8.8.8.8,2001:4860:4860::8888/g' wgcf-profile.conf
cp wgcf-account.toml /etc/wireguard/wgcf-account.toml
cp wgcf-profile.conf /etc/wireguard/wgcf.conf
systemctl enable wg-quick@wgcf
systemctl start wg-quick@wgcf
rm -f wgcf*
yellow " 检测是否成功启动（IPV4+IPV6）双栈Warp！\n 显示IPV4地址：$(wget -qO- -4 ip.gs) 显示IPV6地址：$(wget -qO- -6 ip.gs) "
green " 如上方显示IPV4地址：8.…………，IPV6地址：2a09:…………，则说明成功啦！\n 如上方IPV4显示本地IP,IPV6显示本地IP，则说明失败喽！ "
}

function warp464(){
yellow " 检测系统内核版本是否大于5.6版本 "
if [ "$main" -lt 5 ]|| [ "$minor" -lt 6 ]; then 
	red " 检测到内核版本小于5.6，回到菜单，选择2，自动更新内核吧"
	exit 1
fi

if [ $release = "Centos" ]
	then
	        yum update -y
                yum install curl wget -y && yum install sudo -y
		yum install epel-release -y		
		yum install -y \
                https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
                curl -o /etc/yum.repos.d/jdoss-wireguard-epel-7.repo \
                https://copr.fedorainfracloud.org/coprs/jdoss/wireguard/repo/epel-7/jdoss-wireguard-epel-7.repo
                yum install wireguard-tools -y
	elif [ $release = "Debian" ]
	then
		apt-get update -y
		apt-get install curl wget -y && apt install sudo -y
		apt-get install openresolv -y
		echo "deb http://deb.debian.org/debian/ unstable main" > /etc/apt/sources.list.d/unstable-wireguard.list
		printf 'Package: *\nPin: release a=unstable\nPin-Priority: 150\n' > /etc/apt/preferences.d/limit-unstable
		apt-get install linux-headers-`uname -r` -y
		apt-get install wireguard-tools -y
	elif [ $release = "Ubuntu" ]
	then
		apt-get update -y
		apt-get install curl wget -y &&  apt install sudo -y
		apt -y --no-install-recommends install openresolv dnsutils wireguard-tools
	else
		yellow " 不支持当前系统 "
		exit 1
	fi
wget -N https://github.com/ViRb3/wgcf/releases/download/v2.2.3/wgcf_2.2.3_linux_amd64 -O /usr/local/bin/wgcf
chmod +x /usr/local/bin/wgcf
echo | wgcf register
until [ $? -eq 0 ]
do
sleep 1s
echo | wgcf register
done
wgcf generate
sed -i "5 s/^/PostUp = ip -4 rule add from $rv4 table main\n/" wgcf-profile.conf
sed -i "6 s/^/PostDown = ip -4 rule delete from $rv4 table main\n/" wgcf-profile.conf
sed -i '/\:\:\/0/d' wgcf-profile.conf
sed -i 's/1.1.1.1/8.8.8.8,2001:4860:4860::8888/g' wgcf-profile.conf
cp wgcf-account.toml /etc/wireguard/wgcf-account.toml
cp wgcf-profile.conf /etc/wireguard/wgcf.conf
systemctl enable wg-quick@wgcf
systemctl start wg-quick@wgcf
rm -f wgcf*
yellow " 检测是否成功启动Warp！\n 显示IPV4地址：$(wget -qO- -4 ip.gs) "
green " 如上方显示IPV4地址：8.…………，则说明成功啦！\n 如上方显示VPS本地IP,则说明失败喽！ "
}

function upcore(){
wget -N --no-check-certificate https://cdn.jsdelivr.net/gh/YG-tsj/CFWarp-Pro/upcore.sh&& chmod +x upcore.sh && ./upcore.sh
}

function iptables(){
sudo iptables -P INPUT ACCEPT
sudo iptables -P FORWARD ACCEPT
sudo iptables -P OUTPUT ACCEPT
sudo iptables -F
sudo apt-get purge netfilter-persistent -y
sudo reboot
}

function BBR(){
echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
sysctl -p
lsmod | grep bbr
}

function cwarp(){
systemctl stop wg-quick@wgcf
systemctl disable wg-quick@wgcf
sudo reboot
}

function owarp(){
systemctl enable wg-quick@wgcf
systemctl start wg-quick@wgcf
}

function macka(){
sudo iptables -P INPUT ACCEPT
sudo iptables -P FORWARD ACCEPT
sudo iptables -P OUTPUT ACCEPT
sudo iptables -F
wget -P /root -N --no-check-certificate "https://raw.githubusercontent.com/mack-a/v2ray-agent/master/install.sh" && chmod 700 /root/install.sh && /root/install.sh
}

function phlinhng(){
sudo iptables -P INPUT ACCEPT
sudo iptables -P FORWARD ACCEPT
sudo iptables -P OUTPUT ACCEPT
sudo iptables -F
curl -fsSL https://cdn.jsdelivr.net/gh/phlinhng/v2ray-tcp-tls-web@main/src/xwall.sh -o ~/xwall.sh && bash ~/xwall.sh
}

function cv46(){
        yellow "开始检测IPV4地址"
	v4=`wget -qO- -4 ip.gs`
	pingv4=$(ping -c 1 www.google.com| sed '2{s/[^(]*(//;s/).*//;q;}' | tail -n +2) 
        if [[ -z "${pingv4}" ]]; then 
        red " ---> VPS当前检测不到IPV4地址 " 
	else
	green " VPS当前正使用的IPV4地址: $v4 "
	fi
	
	
	yellow "开始检测IPV6地址"
	v6=`wget -qO- -6 ip.gs`
	pingv6=$(ping6 -c 1 www.google.com| sed '2{s/[^(]*(//;s/).*//;q;}' | tail -n +2) 
	if [[ -z "${pingv6}" ]]; then 
        red " ---> VPS当前检测不到IPV6地址 " 
	else
	green " VPS当前正使用的IPV6地址: $v6 "
	fi
}

function Netflix(){
wget -O nf https://cdn.jsdelivr.net/gh/sjlleo/netflix-verify/CDNRelease/nf_2.60_linux_amd64 && chmod +x nf && clear && ./nf -method full
}

function reboot(){
sudo reboot
}



function warp6(){
if [ "$main" -lt 5 ]|| [ "$minor" -lt 6 ]; then 
	red " 检测到内核版本小于5.6，回到菜单，选择2，更新内核吧"
	exit 1
fi
bash <(curl -fsSL git.io/warp.sh) 6
}

function iptables(){
sudo iptables -P INPUT ACCEPT
sudo iptables -P FORWARD ACCEPT
sudo iptables -P OUTPUT ACCEPT
sudo iptables -F
sudo apt-get purge netfilter-persistent -y
sudo reboot
}

function BBR(){
echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
sysctl -p
lsmod | grep bbr
}

function cwarp(){
systemctl stop wg-quick@wgcf
systemctl disable wg-quick@wgcf
sudo reboot
}

function owarp(){
systemctl enable wg-quick@wgcf
systemctl start wg-quick@wgcf
}

function macka(){
#sudo iptables -P INPUT ACCEPT
#sudo iptables -P FORWARD ACCEPT
#sudo iptables -P OUTPUT ACCEPT
#sudo iptables -F
wget -P /root -N --no-check-certificate "https://raw.githubusercontent.com/mack-a/v2ray-agent/master/install.sh" && chmod 700 /root/install.sh && /root/install.sh
}

function cv46(){
        yellow "开始检测IPV4地址"
	v4=`wget -qO- -4 ip.gs`
	if [[ -z $v4 ]]; then
		red " VPS当前检测不到IPV4地址 "
	else
		green " VPS当前正使用的IPV4地址: $v4 "
	fi
	yellow "开始检测IPV6地址"
	v6=`wget -qO- -6 ip.gs`
	if [[ -z $v6 ]]; then
		red " VPS当前检测不到IPV6地址 "
	else
		green " VPS当前正使用的IPV6地址: $v6 "
	fi
}

function Netflix(){
wget -O nf https://github.com/sjlleo/netflix-verify/releases/download/2.6/nf_2.6_linux_arm64 && chmod +x nf && clear && ./nf  -method full
}

function reboot(){
sudo reboot
}


#主菜单
function start_menu(){
    
    green " 1. 更新系统内核 "
    
    green " 2. 开启原生BBR加速 "
    
    green " 3. 检测奈飞Netflix是否解锁 "
    
    green " 4. 添加WARP虚拟IPV6          "     
    
    green " 5.使用mack-a脚本（支持ARM架构VPS，支持协议：Xray, V2ray） "
    
    green " 6. 重启VPS实例，请重新连接SSH "
    
    green " 7. 退出脚本 "
    Print_ALL_Status_menu
    echo
    read -p "请输入数字:" menuNumberInput
    case "$menuNumberInput" in

	1 )
           upcore
	;;
        2 )
           BBR
	;;
	3 )
           Netflix
	;;    
        4 )
           warp6
	;;
        5 )
           macka
	;;
        6 )
           reboot
	;;
        7 )
	  exit 1
	;;
    esac
}

else
 yellow "此CPU架构不是X86,也不是ARM！"
 exit 1
fi

#############系统检测组件#############
apt-get update -y
apt-get install curl wget -y
start_menu
