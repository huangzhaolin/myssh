#!/bin/bash

#Name:autossh 

#verion:1.3
#author:haiyang.song
#modifed:2012-10-19

argsSize=$#
option=$1
name=$2
server=$3
addInfo="$2 $3 $4 $5 $6" 
configFile=~/.ssh/ssh_passwd
sshConfigPath=~/.ssh/

function echoMenu(){
	echo -e "Usage: -l <hostinfo> [more options]"
	echo -e "  Available options"
	echo -e "    -l : link host name"
	echo -e "    -h : host list"
	echo -e "    -s : search hostinfo"
	echo -e "    -a : add new hostinfo"
	exit
}

function linkServer(){
	#检查入参
	if [[ $argsSize < 2 ]]; then
		if [[ $option != "-"* ]]; then
			name=$option
		else
			echoMenu
		fi
	fi

	#拆分参数
	server=`grep $name $configFile | head -1  | awk -F " " '{print $2}'`
	port=`grep $name $configFile | head -1 | awk -F " " '{print $3}'`
	username=`grep $name $configFile | head -1 | awk -F " " '{print $4}'`
	passwd=`grep $name $configFile | head -1 | awk -F " " '{print $5}'`
	isOnline=`ls $sshConfigPath | grep $username@$server:$port`

	#判断是否存在
	if [[ "$server"x == x ]]; then
		echo -e "\033[32;1mnickname/Server $name is not exit\033[0m"
		echoMenu
	fi

	#自动登陆处理
	if [[ "$isOnline"x != x ]]; then
		passwd=
	fi

	#自动登陆
	~/.ssh/autossh.exp $server $port $username $passwd
}

function echoList(){
	cat $configFile | while read line
	do
    	echo $line
	done
}

function echoServerInfo(){
	#检查入参
	if [[ $argsSize < 2 ]]; then
		echoMenu
	fi

	echo `grep $name $configFile | awk -F " " '{print $0}'`
}

function addServerInfo(){
	#检查入参
	if [[ $argsSize < 5 ]]; then
		echo "Usage: <nickname> <server> <port> <username> <passwd>"
		exit
	fi

	isHave=`grep $server $configFile | awk -F " " '{print $0}'`

	if [[ "$isHave"x != x ]]; then
		echo -e "\033[32;1mServer $server is have\033[0m"
		exit
	fi

	echo $addInfo >> $configFile
	echo "add success"
}

#检查入参
if [[ $argsSize < 1 ]]; then
	echoMenu
fi

if [[ $option == "-"* ]]; then
	case $option in
		"-l" ) linkServer ;;
		"-h" ) echoList ;;
		"-s" ) echoServerInfo ;;
		"-a" ) addServerInfo ;;
		*	 ) echoMenu ;;
	esac
else
	linkServer
fi

