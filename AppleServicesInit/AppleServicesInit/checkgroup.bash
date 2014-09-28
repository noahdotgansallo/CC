#!/bin/bash
admin_check() {
	[[ -z `id $1|grep '80(admin)'` ]] && echo "WRONG" && exit
}
user=''
[[ -z $1 ]] && user=`whoami` || user=$1
admin_check $user
echo "RIGHT"