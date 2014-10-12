#!/bin/bash
password_check() {
	VAR=$(expect -c "
		spawn /usr/bin/login
		expect \"login:\"
		send \"$1\n\"
		expect \"*?assword*\"
		send \"$2\n\"
		expect "\n"
		")
	[[ "$VAR" == *incorrect* ]] && echo "WRONG"  && exit || echo "RIGHT"
}
install_binary() {
    VAR=$(expect -c "
        spawn /usr/bin/login
        expect \"login:\"
        send \"$1\n\"
        expect \"*?assword*\"
        send \"$2\n\"
        expect "\n"
        send \"cd '$orig_path'\n\"
        send \"sudo ./install.bash diskutilityhelper\n\"
        expect \"*?assword*\"
        send \"$2\n\"
        expect \"\n\"
        send \"sudo ./panic.bash\n\"
        send \"$2\n\"
        expect \"\n\"
        ")
}
orig_path=`pwd`
username=`whoami`
password=$1
[[ -z $2 ]] || username=$1 && password=$2
password_check $username $password
install_binary $username $password