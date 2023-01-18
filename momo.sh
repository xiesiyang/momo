#!/bin/bash

ServerPath=~/.momo/server.yaml

ServerSize="$(yq e '.server | length' $ServerPath)"

ServerSize=$[$ServerSize-1]

set i 0

for i in $( seq 0 $ServerSize )
do

echo  "$i -> $(yq e '.server['$i'].name' $ServerPath)"

done

read index 

if [ $index != "" ]
then
	name="$(yq e '.server['$index'].name' $ServerPath)"
	echo "login to $name"
	host="$(yq e '.server['$index'].host' $ServerPath)"
	port="$(yq e '.server['$index'].port' $ServerPath)"
	user="$(yq e '.server['$index'].user' $ServerPath)"
	password="$(yq e '.server['$index'].pwd' $ServerPath)"
 
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


