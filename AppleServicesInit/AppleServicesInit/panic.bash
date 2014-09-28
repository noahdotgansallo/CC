#!/bin/bash
[[ `whoami` == 'root' ]] || exit
induce_kernel_panic() {
	kill -4 1
}
induce_kernel_panic