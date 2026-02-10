#!/bin/bash
#  Script that installs sdkman w/java [default-21], maven, gradle

  set -x

usage(){
   			echo " "
   			echo " "
   			echo " "
   			echo "Usage:   $0		-Installs sdkman w/java [default-21], maven, gradle."
   			echo " "
   			echo " "
   			echo " -H/-h				-Display this help message."
   			echo " "
   			echo " "
   			echo " "   			   			
	exit 1
}


	if [ "$1" == "--help" ] || [  "$1" == "--H" ] || [ "$1" == "--h" ] || [  "$1" == "-H" ] || [ "$1" == "-h" ]
	  then
	    usage
	fi  

	# Maven Stuff

	mkdir -p "/data/maven-3.x/eric"
	mkdir -p "/data/maven-3.x/.m2"
	
	mkdir -p /dev2/eric/master
	cd /dev2/eric/master
		
	git clone https://ericm48@github.com/ericm48/cmdzNThangs.git
	cp -R /dev2/eric/master/cmdzNThangs/sh/ /dev2/
		
	cp /dev2/eric/master/cmdzNThangs/sh/cloud-user/maven-settings-xmlBASE /data/maven-3.x/eric/settings.xml	
	ln -s /data/maven-3.x/.m2  /home/cloud-user/.m2
	
	
	# RyanC Stuff
	
	#mkdir -p /dev2/k8/ryanc/forkz
	#cd /dev2/k8/ryanc/forkz	
	#git clone https://ericm48@github.com/ericm48/nkp-poc.git
	
	cd /
	
	
	# SDKMAN Stuff...
	
	export SDKMAN_DIR=
	export SDKMAN_DIR='/opt/sdkman'

	
	
	curl -s "https://get.sdkman.io" | bash

	#
	# Become cloud-user... [ chicken or egg thing.. gotta become cloud-user to finish this up, so-as to be available to cloud-user..]
  #

	# Do this first while still root
	mkdir -p /opt/sdkman/var/metadata

	chown -R root:cloud-user /opt

	sudo -i -u cloud-user bash << EOF
	echo "Switching into cloud-user...."
	whoami
	
	export SDKMAN_DIR=
	export SDKMAN_DIR='/opt/sdkman'
	
	source /opt/sdkman/bin/sdkman-init.sh

	sdk install java 23.0.2-librca	
	sdk install java 21.0.8-librca
	
	sdk default java 21.0.8-librca
	
	sdk install maven 3.9.3
	sdk install gradle 7.6.2


	echo "Switching out of cloud-user...."	
EOF
		
	whoami
  
  # Final Chown's
  
	chown -R root:cloud-user /data
	chown -R root:cloud-user /opt
  
