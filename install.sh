#!/bin/bash

#检查权限
testPath="/etc/profile"

if [ ! -w "$testPath" ]; then 
	echo "请用管理员权限运行脚本"
	exit
fi 

rm -fr ~/.ssh/autossh.exp
rm -fr /usr/bin/autossh
rm -rf /usr/bin/my-ssh

#复制文件
cp autossh.exp ~/.ssh/autossh.exp
cp autossh.sh /usr/bin/autossh
cp my-ssh.sh /usr/bin/my-ssh

if [[ ! -s  ~/.ssh/ssh_passwd ]]; then
	cp ssh_passwd ~/.ssh/ssh_passwd
fi

#修改权限权限
chmod +x /usr/bin/autossh
chmod +x /usr/bin/my-ssh
chmod 777 ~/.ssh/ssh_passwd
chmod 777 ~/.ssh/autossh.exp

echo -e "\033[32;1mautossh install successs\033[0m"
echo -e "\033[32;1mauthor:haiyang.song\033[0m"
echo -e "\033[32;1memail:meishild@gmail.com\033[0m"
