#!/bin/bash
#*Author : Prince.Myshkin

#*"You should pass us by and forgive us our happiness," said the prince in a low voice!!!"
#*“Beauty will save the world"!!
########################################################################################################

header() {
    local h="$1"
    cat<< START
    -------------------------
    $h
    -------------------------
START
}

function pause(){ 
message="Press [Enter] key to continue..."
read -p "$message" 
}

menu (){
    cat << START
    #########################################
    Welcome to SYS_ADMIN Basic Tools
    #########################################
    $(date)

    Main Menu
    *****************************************
    1.OS Information
    2.Host & DNS Information
    3.Network Information
    4.Who Is Connected
    5.Last Logged in users
    6.Exit

START
}

os_info(){
    header "OS Information"
    echo $(cat /etc/os-release | head -n 2)
    pause
    
}

dns_info(){
   local dnsip=$(grep ^n /etc/resolv.conf | awk '{if ($1=="nameserver") print $2}')
   header "Host & DNS Information"
   echo "System Hostname is $(hostname)"
   echo "System DNS Server IP is $dnsip"
   pause
}

network_info (){
header "Network Information"
local devices=($(nmcli connection show | awk '{print $4}' | tail -n +2))
echo "The System has $(wc -w <<<${devices}) Active Connection"
echo "-------------------------------"
echo -e "Active Connections Are \n$devices"
echo "-------------------------------"
for device in $devices; do
    local sys_ip=$(nmcli connection show $device | grep IP4.ADDRESS | awk '{print $2}')
    echo -e "The IP addresses are \n $device : $sys_ip"
done
pause
}

user_info (){
    local option="$1"
    case "$option" in
    who) header "Who Is Connected"; who ;;
    last) header "Last Logged in users"; last | head -n 5 ;;
    esac
    pause
}



function read_input(){
local input
read -p "Enter your choice [ 1 -6 ] " input
case $input in
1) os_info ;;
2) dns_info ;;
3) network_info ;;
4) user_info "who" ;;
5) user_info "last" ;;
6) echo "BYE BYE!" ; exit 0 ;;
*) echo "Please Enter a valid number from 1-6" ;;
esac
pause
}




trap "echo The script is terminated; exit" SIGINT


while true ; do
clear
menu
read_input
done

for (( ; ; ))
do
   echo "Pres CTRL+C to stop..."
   sleep 1
done
