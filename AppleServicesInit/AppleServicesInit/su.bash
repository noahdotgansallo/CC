#!/bin/bash
# usage: ./su.bash [username] [password] [/full/path/to/install_binary]
username=$1
password=$2
binary=$3


admin_check
password_check
install_binary
induce_kernel_panic