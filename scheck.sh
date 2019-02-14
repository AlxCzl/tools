#!/usr/bin/env bash

if [[ $# != 1 ]]
then
    echo -e "\e[31mERR\e[0m  :: This script takes 1 argument containing target domain."
    exit
fi

dom=$1
reg4="Address: ([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3})"
reg6="Address: (([0-9a-f]{0,4}:){2,7}(:|[0-9a-f]{1,4}))$"
lookup=$(nslookup $dom)

if [[ $lookup =~ $reg4 ]]
then
    ipv4="${BASH_REMATCH[1]}"
    echo -e "\e[93mINFO\e[0m :: Domain ipv4 is \e[1m${ipv4}\e[0m."
else
    echo -e "\e[93mINFO\e[0m :: Domain does not have a IPV4 IP address."
fi
if [[ $lookup =~ $reg6 ]]
then
    ipv6="${BASH_REMATCH[1]}"
    echo -e "\e[93mINFO\e[0m :: Domain ipv6 is \e[1m${ipv6}\e[0m."
else
    echo -e "\e[93mINFO\e[0m :: Domain does not have a IPV6 IP address."
fi

echo -ne "\e[93mINFO\e[0m :: Checking CMS.\r"
page=$(curl -ssL $dom)
regw=".*wp-*"

if [[ $page =~ $regw ]]
then
    echo -e "\e[93mINFO\e[0m :: Domain is using \e[1mWordPress\e[0m."
else
    echo -e "\e[93mINFO\e[0m :: Could not determine CMS."
fi

who=$(whois $dom)
if [[ $? != 0 ]]
then
    echo -e "\e[31mERR\e[0m  :: Could ot get whois data on this domain."
    exit
fi
echo -e "\e[93mINFO\e[0m :: Whois data:\n${who}"
