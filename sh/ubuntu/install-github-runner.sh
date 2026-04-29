#!/bin/bash
#  Script that installs sdkman w/java [default-21], maven, gradle

#  set -x

usage(){
   			echo " "
   			echo " "
   			echo " "
   			echo "Usage:   $0		-Installs github-runner components"
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

	# Setup folder.

	mkdir -p "/dev2/github/actions-runner"

	cd /dev2/github/actions-runner
	
	# Pull down components	
  wget -P /data/inet https://github.com/actions/runner/releases/download/v2.334.0/actions-runner-linux-x64-2.334.0.tar.gz


	# Validate the hash
	echo "048024cd2c848eb6f14d5646d56c13a4def2ae7ee3ad12122bee960c56f3d271  /data/inet/actions-runner-linux-x64-2.334.0.tar.gz" | shasum -a 256 -c
  
  cp /data/inet/actions-runner-linux-x64-2.334.0.tar.gz /dev2/github/actions-runner

	cd /dev2/github/actions-runner
    
  # Extract the installer
  tar -xf ./actions-runner-linux-x64-2.334.0.tar.gz


	# Create the runner and start the configuration experience
	
	#/dev2/github/actions-runner/config.sh --url https://github.com/ericm48-gh-org --token $GITHUB_RUNNER_Y  
	
	# Install As Service
	#sudo /opt/github/actions-runner/svc.sh install ubuntu
	
	# Start The Service...
	#sudo /opt/github/actions-runner/svc.sh start &
	
	# Service Status
	#sudo /opt/github/actions-runner/svc.sh status


  #chown -R root:ubuntu /dev2
  #chmod 777 -R /dev2