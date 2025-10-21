#!/bin/bash
#
# Command Check a series of IP-Addresses to see if in-use.
#

#set -x


i=0
k=0

NetworkPrefix=
NetworkPrefix="192.168.1"

LastOctet=
LastOctet="254"
iLastOctet=0

usage(){
   			echo " "
   			echo " "
   			echo "Check the series of IP-Addresses to see if used."
   			echo " "
   			echo " "

   			echo "Usage:   $0 -np NETWORK_PREFIX -lo LAST-OCTET"
   			echo " "
   			echo " "
   			echo " "
	exit 1
}


arg_parse() {
	
	for (( i=1; i<=$#; i++)); do
	
	
		case ${!i} in
		
		  -np)
		  		# Network Prefix should follow -np
		  	  k=$(($i+1))
				 	NetworkPrefix="${!k}"
				 	#break
				 	;;		
				 	
		  -lo)
		  		# Last-Octet should follow -lo
		  	  k=$(($i+1))
				 	LastOctet="${!k}"
				 	#break
				 	;;		
			
				 	
	
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

check_the_range() {

	echo "Checking Range..."
	echo "NetworkPrefix: $NetworkPrefix"
	echo "    LastOctet: $LastOctet"	
	echo ""

	iLastOctet=$(( LastOctet ))	

	for i in $(seq 1 $iLastOctet); do
	
		pingResult=''
    IPAddress="${NetworkPrefix}.${i}"

		ping -c1 -i1 -n -s10 -t1 -W200 ${IPAddress} > /dev/null 2>&1

		if [ $? -ne 0 ]; then
		    pingResult="-Open"
		    
		else
		    pingResult="-Used"
		fi
	
			    
	  echo "${IPAddress}${pingResult}"

	done




}


	arg_parse "$@"



	check_the_range
	

	exit 0



