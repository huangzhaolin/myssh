#!/bin/bash
#author:zhaolin.huang create on: 2013-04-19

CONFIG=~/.ssh/ssh_passwd
#select_console
function select_console(){
	    show_all_hosts
	    printf "\e[1;33m%5s %s\n\e[0m" " " "+"."ADD HOST"
	    printf "\e[1;31m%5s %s\n\e[0m" " " "-"."ROMOVE HOST"
	    printf "<CTRL+C> to Quit\n"
    	    select_host_go
}
#选择主机,并登陆
function select_host_go(){
	read -p "choice your host:" host_id
	case $host_id in
	"+" ) add_host ;;
	"-" ) remove_host ;;
	* ) go_to_server $host_id;;
	esac
};
#ssh到主机
function go_to_server(){
	if [[ $1 > `cat $CONFIG|egrep -v "^#.*"|wc -l` ]]
	then 
	 	printf "\e[1;31mbad option!!\e[0m\n" 
                select_console
	fi
        host_info=`cat $CONFIG|egrep -v "^#.*"|head -n$1 |tail -n1`

        server=`echo $host_info | cut -d" " -f 2`
        port=`echo $host_info | cut -d" " -f 3`
        username=`echo $host_info | cut -d" " -f 4`
        passwd=`echo $host_info | cut -d" " -f 5`

        if [[ "$server" == "" ]];
        then
		printf "\e[1;31mbad option!!\e[0m\n"
                select_console
        else
                ~/.ssh/autossh.exp $server $port $username $passwd
        fi
}
#查看所有主机
function show_all_hosts(){
	cat $CONFIG|egrep -v "^#.*" | while read host;
    do
            let index++
            host=`echo $host|cut -d" " -f 1`
            printf "\e[1;32m%5s %s\n" " " $index"."$host
    done
}
#增加主机
function add_host(){
	printf "input:<nickname> <server> <port> <username> <passwd>:\n"
	printf "\e[1;35msample:\e[1;34mmonitor-4 monitor4.dev.alipay.net 22 root alipay \e[0m\n"
        read  host_info
	nick_name=`echo $host_info | cut -d" " -f 1`
        server=`echo $host_info | cut -d" " -f 2`
        port=`echo $host_info | cut -d" " -f 3`
        username=`echo $host_info | cut -d" " -f 4`
        passwd=`echo $host_info | cut -d" " -f 5`
	
	is_nick_name_exits=`cat $CONFIG | cut -d" " -f 1| grep "$nick_name"`
	if [[ "$is_nick_name_exits" == "" ]]
	then
		if [[ "$server" == "" || "$port" == "" || "$username" == "" || "$passwd" == "" ]]
		then
		printf "\e[1;31mserver,port,username,passwd is require!!\e[0m\n"
		add_host
		else
		echo $host_info >> $CONFIG
		printf "\e[1;32m add host success!!\n"
		fi	
	else
		printf "\e[1;31mnickname is exits!!please change nickname!\e[0m\n"
		add_host
	fi
	select_console
}
#删除主机
function remove_host(){
	show_all_hosts
	printf "\e[1;31mselect remove host:\n\e[0m"
	read host_id
	if [[ $host_id > `cat $CONFIG|egrep -v "^#.*" | wc -l` ]]
	then
		printf "\e[1;31m bad option\n"
		remove_host
	fi
	printf "\e[1;31mremove host $host_id(y/n)]:"
	read is_confirm_delete
	if [[ "$is_confirm_delete" == "y" || "$is_confirm_delete" == "Y" || "$is_confirm_delete" == "yes" ]]
	then
		let host_id++
		sed -i "${host_id}d" $CONFIG
		printf "\e[1;32mremove success!!\e[0m\n"
	fi
	select_console	
}

select_console
