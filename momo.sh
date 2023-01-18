#!/bin/bash

ServerSize="$(yq e '.server | length' server.yaml)"

ServerSize=$[$ServerSize-1]

set i 0

for i in $( seq 0 $ServerSize )
do

echo  "$i -> $(yq e '.server['$i'].name' server.yaml)"

done

read index 

if [ $index != "" ]
then
	name="$(yq e '.server['$index'].name' server.yaml)"
	echo "login to $name"
	host="$(yq e '.server['$index'].host' server.yaml)"
	port="$(yq e '.server['$index'].port' server.yaml)"
	user="$(yq e '.server['$index'].user' server.yaml)"
	password="$(yq e '.server['$index'].pwd' server.yaml)"
 
	# ./login.sh $host $port $user $password
	
expect -c "
    set timeout 10 
	spawn ssh -p ${port} ${user}@${host}
	expect {
		\"*password:\" { send \"${password}\r\" }
		\"yes/no\" { send \"yes\r\";exp_continue }
	}
	interact
"


fi


