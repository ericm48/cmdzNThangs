#!/bin/bash
# This script updates an AWS secret with a new value.
# check if AWS env variables are set

usage(){
   			echo " "
   			echo " "
   			echo " "
   			echo "Usage:   $0		-Updates an AWS secret with a new values, restarts capa-controller-manager."
   			echo " "
   			echo " -H/-h				-Display this help message."
   			echo " "
   			echo " -Requires the following eVars set:"
   			echo "  AWS_ACCESS_KEY_ID"
   			echo "  AWS_SECRET_ACCESS_KEY"
   			echo "  AWS_SESSION_TOKEN"   			   			
   			echo " "
   			echo " "   			   			
	exit 1
}


	if [ "$1" == "--help" ] || [  "$1" == "--H" ] || [ "$1" == "--h" ] || [  "$1" == "-H" ] || [ "$1" == "-h" ]
	  then
	    usage
	fi  

	if [ -z "$AWS_ACCESS_KEY_ID" ] || [ -z "$AWS_SECRET_ACCESS_KEY" ] || [ -z "$AWS_SESSION_TOKEN" ]; then
	  echo ""
	  echo "AWS environment variables are not set. Please set AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, and AWS_SESSION_TOKEN."
	  echo ""
	  usage
	  exit 1
	fi
	
	# select NKP mgmt cluster context
	    CONTEXTS=$(kubectl config get-contexts --output=name)
	    echo
	    echo "Select management cluster or CTRL-C to quit"
	    select CONTEXT in $CONTEXTS; do
	        echo "you selected cluster context : ${CONTEXT}"
	        echo
	        CLUSTERCTX="${CONTEXT}"
	        break
	    done
	
	    kubectl config use-context $CLUSTERCTX
	
	# get the secret name
	    SECRETS=$(kubectl get secret -n capa-system |grep "aws-" | awk '{print $1}')
	    echo
	    echo "Select aws secret to udpate or CTRL-C to quit"
	    select SECRET in $SECRETS; do
	        echo "you selected aws secret : ${SECRET}"
	        echo
	        break
	    done
	    
	
	#base64 encode the AWS credentials
	
	AWS_ACCESS_KEY_ID_B64=$(echo -n "$AWS_ACCESS_KEY_ID" | base64)
	AWS_SECRET_ACCESS_KEY_B64=$(echo -n "$AWS_SECRET_ACCESS_KEY" | base64)
	AWS_SESSION_TOKEN_B64=$(echo -n "$AWS_SESSION_TOKEN" | base64 -w0)
	
	kubectl patch secret $SECRET -n capa-system  -p='{"data":{"AccessKeyID": "'$AWS_ACCESS_KEY_ID_B64'","SecretAccessKey": "'$AWS_SECRET_ACCESS_KEY_B64'","SessionToken": "'$AWS_SESSION_TOKEN_B64'"}}'
	
	# check if the patch was successful
	if [ $? -eq 0 ]; then
	    echo "Secret $SECRET updated successfully."
	else
	    echo "Failed to update secret $SECRET."
	    exit 1
	fi
	
	echo "restarting CAPA"
	
	kubectl rollout  restart deployment capa-controller-manager -n capa-system 
 
