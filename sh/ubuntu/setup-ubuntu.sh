#!/bin/bash
#  Script that sets up a base set of tools for Ubuntu

# set -x


	outFile="/data/txt/setup-ubuntu-log.txt"

	# setup a place for logging...
	
	mkdir -p "/data/txt"
		
	apt update -y  | tee -a "$outFile"	
	apt upgrade -y | tee -a "$outFile"

	mkdir -p "/data/inet" | tee -a "$outFile"

	cd "/data/inet"

	#
	# Setup K8s
	#
  curl -LO "https://dl.k8s.io/release/v1.34.1/bin/linux/amd64/kubectl" | tee -a "$outFile"
  install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl       | tee -a "$outFile"
  mv kubectl kubectl-v1.34.1-linux-amd64                               | tee -a "$outFile"
  
  
  
	
	







