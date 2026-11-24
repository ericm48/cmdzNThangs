#!/bin/bash

# set -x

usage(){
   			echo " "
   			echo " "
   			echo " "
   			echo "Usage:   $0		-Script installs ansible, initializes MiniKube [ minikube start; minikube stop ] "
   			echo " "
   			echo " -H/-h				-Display this help message."
   			echo " "
   			echo " -Requires the following eVars set:"
   			echo " "   			
   			echo " "
   			echo " "
   			echo " "   			
	exit 1
}


arg_parse() {
	
	for (( i=1; i<=$#; i++)); do
		
		case ${!i} in
		
	
	    -H)
					usage
					exit 3
	        ;;
	
	    -h)
					usage
					exit 3
					;;
	
	    --H)
					usage
					exit 3
	        ;;
	
	    --h)
					usage
					exit 3
					;;
	
	    -help)
					usage
					exit 3
	        ;;
	
	    --help)
					usage
					exit 3
					;;
			
			*)
					#echo "[$i]: ${!i}"
		
		
		esac
	
	  
	done

}


	if [ "$1" == "--help" ] || [  "$1" == "--H" ] || [ "$1" == "--h" ] || [  "$1" == "-H" ] || [ "$1" == "-h" ]
	  then
	    usage
	fi

	arg_parse "$@"

	whoami
	su - ubuntu	

	# Start, Stop minikube...
	minikube start
	minikube stop

	#
	# Finish pipx, ansible installs
	#
	echo "Running pipx from:"
	which pipx
	echo "pipx version:"
	pipx --version
	echo " "	
	pipx ensurepath
	pipx install --include-deps ansible==9.5.1
	which ansible
	echo "ansible version:"	
	ansible --version		
	echo " "	
	# add auto-complete
	pipx inject --include-apps ansible argcomplete  
		
	# Run one-time only.
	sudo systemctl disable one-time-startup.service	

	exit 0





