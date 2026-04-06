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

	mkdir -p "/opt/github/actions-runner"	

	cd /opt/github/actions-runner
	
	# Pull down components	
  wget -P /data/inet https://github.com/actions/runner/releases/download/v2.333.1/actions-runner-linux-x64-2.333.1.tar.gz

	# Validate the hash
	echo "18f8f68ed1892854ff2ab1bab4fcaa2f5abeedc98093b6cb13638991725cab74  /data/inet/actions-runner-linux-x64-2.333.1.tar.gz" | shasum -a 256 -c  
  
  cp /data/inet/actions-runner-linux-x64-2.333.1.tar.gz /opt/github/actions-runner
    
  # Extract the installer
  sudo tar -xf ./actions-runner-linux-x64-2.333.1.tar.gz

	# Create the runner and start the configuration experience
	/opt/github/actions-runner/config.sh --url https://github.com/ericm48-gh-org --token $GITHUB_RUNNER_Y
  
	
	# Install As Service
	sudo /opt/github/actions-runner/svc.sh install ubuntu
	
	# Start The Service...
	sudo /opt/github/actions-runner/svc.sh start &
	
	# Sleep
	echo "Sleeping for 5...."
	sleep 5
	
	# Service Status
	sudo /opt/github/actions-runner/svc.sh status

	# Needed to make this work!
	sudo chmod 777 -R /opt/github
  
  # Final Chown's  
	sudo chown -R root:ubuntu /opt
  
