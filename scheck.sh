#!/usr/bin/env bash

if [[ $# != 1 ]]
then
    echo -e "\e[31mERR\e[0m  :: This script takes 1 argument containing target website."
    exit
fi

site=$1
reg4="Address: ([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3})"
reg6="Address: (([0-9a-f]{0,4}:){2,7}(:|[0-9a-f]{1,4}))$"
lookup=$(nslookup $site)

if [[ $lookup =~ $reg4 ]]
then
    ipv4="${BASH_REMATCH[1]}"
    echo -e "\e[93mINFO\e[0m :: Site ipv4 is \e[1m${ipv4}\e[0m."
else
    echo -e "\e[93mINFO\e[0m :: Site does not have a IPV4 IP address."
fi
if [[ $lookup =~ $reg6 ]]
then
    ipv6="${BASH_REMATCH[1]}"
    echo -e "\e[93mINFO\e[0m :: Site ipv6 is \e[1m${ipv6}\e[0m."
else
    echo -e "\e[93mINFO\e[0m :: Site does not have a IPV6 IP address."
fi

who=$(whois $site)
if [[ $? != 0 ]]
then
    echo -e "\e[31mERR\e[0m  :: Could ot get whois data on this website."
    exit
fi
echo -e "\e[93mINFO\e[0m ::\n${who}"
