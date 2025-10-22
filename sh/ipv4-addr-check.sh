#!/bin/bash
#
# Command Check a series of IP-Addresses to see if in-use.
#

#set -x


i=0
k=0

baseAddress=
baseAddress="192.168.1.100"

nextIncrement=
nextIncrement="15"
increment=0

usage(){
   			echo " "
   			echo " "
   			echo "Check a series of IP-Addresses to see if used.  MAC-os Impl Varies..."
   			echo " "
   			echo " "

   			echo "Usage:   $0 -b baseAddress -n nextIncrement"
   			echo " "
   			echo "Example $0 -b 192.168.10.115 -n 15"
   			echo " "
   			echo " "
   			echo "Checks the NEXT 15 addresses from 192.168.10.115 thru 192.168.10.130"
   			echo " "
   			echo " "
   			echo " "
   			echo " "
   			echo " "
   			
	exit 1
}


arg_parse() {
	
	for (( i=1; i<=$#; i++)); do
		
		case ${!i} in
		
		  -b)
		  		# Network Prefix should follow -np
		  	  k=$(($i+1))
				 	baseAddress="${!k}"
				 	#break
				 	;;		
				 	
		  -n)
		  		# Next Increment -n
		  	  k=$(($i+1))
				 	nextIncrement="${!k}"
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

last_index(){
	hayStack=$1
	needle=$2
	returnValue=0
	
	# Reverse the string
	reversedString=$(echo "$hayStack" | rev)

	# Find the first index of the character in the reversed string
	# (This gives its position from the end of the original string)

	# MAC-os requires different handling because its just special... BSD...

	unamestr=$(uname)	

	if [ "$unamestr" = 'Darwin' ] 
		then
		
			# MAC-os Impl:
	   	lastIndex=$(echo "$reversedString" | sed -n "s/[$needle].*//p" | wc -c)

	else 
	
		# Linux Impl:
		lastIndex=$(expr index "$reversedString" "$needle")
	
	fi	

	# Calculate the last index in the original string (1-based index)
	# Total length - (index from end - 1)
	returnValue=$(( ${#hayStack} - lastIndex + 1 ))

	return $returnValue	
}

check_the_range() {

	echo ""
	echo "Checking Range..."
	echo "   baseAddress: $baseAddress"
	echo " nextIncrement: $nextIncrement"	
	echo ""

	iNextIncrement=$(( nextIncrement ))	

	index=0
	last_index  "$baseAddress" "."	
	iLastPeriod=$?
	
	firstThree=${baseAddress:start:iLastPeriod}
	
  lastOctet=
	lastOctet="${baseAddress##*.}"
	iLastOctet=0
	iLastOctet=$((lastOctet))

	iMaxLast=0
	iMaxLast=$((iLastOctet+iNextIncrement))

	if [ $iMaxLast -gt 256 ]
 		then
	 		echo ""
	 		echo "*** ERROR: Last Octet Plus Increment CANNOT be Greater Than 255!"
	 		echo "" 		
	 		usage
	 		exit 9
	fi		

	# First One
	IPAddress="${baseAddress}"
	
	
	for i in $(seq 1 $iNextIncrement); do
		
		pingResult=''
		ping -c1 -i1 -n -s10 -t1 -W1 ${IPAddress} > /dev/null 2>&1	

		if [ $? -ne 0 ]; then
		    pingResult="-Open"		    
		else
		    pingResult="-Used"
		fi
	  echo "${IPAddress}${pingResult}"
			
		# Add 1 to the last octet..
		
		iLastOctet=$((iLastOctet+1))
		
		lastOctet=${iLastOctet}	
    IPAddress="${firstThree}${lastOctet}"

	done
}

unamestr=$(uname)

if [ "$unamestr" = 'Darwin' ] 
	then
		echo ""
  	echo "This is macOS (BSD-based)...."
		echo ""

fi

	arg_parse "$@"

	check_the_range

	exit 0



