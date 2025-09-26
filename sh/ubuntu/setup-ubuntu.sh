#!/bin/bash
#  Script that sets up a base set of tools for Ubuntu

# set -x


	outFile="$HOME/data/txt/setup-ubuntu-log.txt"

	# setup a place for logging...
	
	mkdir -p "$HOME/data/txt"
		
	apt update -y  | tee -a "$outFile"	
	apt upgrade -y | tee -a "$outFile"

	mkdir -p "$HOME/data/inet" | tee -a "$outFile"

	cd "$HOME/data/inet"

  curl -LO "https://dl.k8s.io/release/v1.34.1/bin/linux/amd64/kubectl"
  install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
  mv kubectl kubectl-v1.34.1-linux-amd64
	
	







