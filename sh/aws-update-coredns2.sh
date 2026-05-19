#!/bin/bash

usage(){
   			echo " "
   			echo " "
   			echo " "
   			echo "Usage:   $0		-Updates an the DNS Entry for Kommander."
   			echo " "
   			echo " -H/-h				-Display this help message."
   			echo " "
   			echo " -Requires the following eVars set:"
   			echo " "   			
   			echo "  NKP_TUNNEL_PUBLIC_IP"
   			echo "  NKP_DASHBOARD_IP"
   			echo " "
   			echo " "
   			echo " "   			
	exit 1
}


	if [ "$1" == "--help" ] || [  "$1" == "--H" ] || [ "$1" == "--h" ] || [  "$1" == "-H" ] || [ "$1" == "-h" ]
	  then
	    usage
	fi  


source ./aws-env2


if [ -z "$NKP_TUNNEL_PUBLIC_IP" ] ; then
	echo " "
  echo "eVar: NKP_TUNNEL_PUBLIC_IP not set in aws-env2."
	echo " "  
  exit 1
fi

if [ -z "$NKP_DASHBOARD_IP" ] ; then
	echo " "
  echo "eVar: NKP_DASHBOARD_IP not set in aws-env2."
	echo " "  
  exit 1
fi


# select NKP mgmt cluster context
    CONTEXTS=$(kubectl config get-contexts --output=name)
    echo
    echo "Select aws cluster or CTRL-C to quit"
    select CONTEXT in $CONTEXTS; do 
        echo "you selected cluster context : ${CONTEXT}"
        echo 
        CLUSTERCTX="${CONTEXT}"
        break
    done

    kubectl config use-context $CLUSTERCTX

# get coredns configmap
kubectl get cm coredns -n kube-system -o yaml > coredns-cm.yaml
#check if error
if [ $? -ne 0 ]; then
  echo "Failed to get coredns configmap."
  exit 1
fi

input_file=coredns-cm.yaml
output_file=coredns-cm-updated.yaml

# Text block to insert (preserves indentation)


#INSERT_TEXT="        hosts {
#            $NKP_TUNNEL_PUBLIC_IP $NKP_MGMT_FQDN
#            fallthrough
#        }"

INSERT_TEXT="        hosts {
            $NKP_TUNNEL_PUBLIC_IP $NKP_DASHBOARD_IP
            fallthrough
        }"

        
# Insert the text before the line containing 'forward'
awk -v insert="${INSERT_TEXT}" '/^[ \t]*forward/ {print insert}{print}' "${input_file}" > "${output_file}"

echo "Text inserted and saved to ${output_file}"
echo
#yq e  ${output_file}

cat  ${output_file}

echo "press enter to apply update to coredns configmap or CTRL-C to abort"
read

# update coredns configmap
kubectl replace -f coredns-cm-updated.yaml -n kube-system

#check if error
if [ $? -ne 0 ]; then
  echo "Failed to update coredns configmap."
  exit 1
fi

kubectl  rollout restart deploy -n kommander-flux source-controller
kubectl  rollout restart deploy -n kommander-flux flux-oci-mirror
kubectl  get gitrepo management -n kommander-flux -w

