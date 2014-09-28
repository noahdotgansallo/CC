#!/bin/bash
password_check() {
	VAR=$(expect -c "
		spawn /usr/bin/login
		expect "login:"
		send \"$1\n\"
		expect \"*?assword*\"
		send \"$2\n\"
		expect "\n"
		")
	[[ "$VAR" == *incorrect* ]] && echo "WRONG"  && exit || echo "RIGHT"
}
username=`whoami`
password=$1
[[ -z $2 ]] || username=$1 && password=$2
password_check $username $password
