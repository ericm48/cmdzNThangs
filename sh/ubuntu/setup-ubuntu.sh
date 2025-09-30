#!/bin/bash
#  Script that sets up a base set of tools for Ubuntu

# set -x

	outFile="/data/txt/setup-ubuntu-log.txt"
  rm "$outFile"

	# setup a place for logging...
	
	mkdir -p "/data/txt"					2>&1 | tee -a "$outFile"	
		
	mkdir -p "/data/inet" 				2>&1 | tee -a "$outFile"
	mkdir -p "/dev2/sh"   				2>&1 | tee -a "$outFile"	

	cd "/data/inet"								2>&1 | tee -a "$outFile"
		
	apt update -y  								2>&1 | tee -a "$outFile"	
	apt upgrade -y 								2>&1 | tee -a "$outFile"


	#
	# Add Network Stuff
	#
	apt install -y nmap						2>&1 | tee -a "$outFile"
	apt install -y net-tools			2>&1 | tee -a "$outFile"

	#
	# Setup Completion
	#
  #apt install -y bash-completion	2>&1 | tee -a "$outFile"	
  #source /usr/share/bash-completion/bash_completion  

	#
	# Setup K8s
	#
  wget https://dl.k8s.io/release/v1.34.1/bin/linux/amd64/kubectl 				2>&1 | tee -a "$outFile"
  install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl       	2>&1 | tee -a "$outFile"
  mv kubectl kubectl-v1.34.1-linux-amd64                               	2>&1 | tee -a "$outFile"

	#
  # Bash-Completion
  #
  source <(kubectl completion bash)																			2>&1 | tee -a "$outFile"
  
  echo "source <(kubectl completion bash)" >> ~/.bashrc  
  alias k=kubectl
  
  complete -F __start_kubectl k																					2>&1 | tee -a "$outFile"
  
	#
	# K8s Utilities
	#	
 	wget https://raw.githubusercontent.com/blendle/kns/master/bin/kns 		2>&1 | tee -a "$outFile"
  install -o root -g root -m 0755 kns /usr/local/bin/kns       					2>&1 | tee -a "$outFile"
 	
	wget https://raw.githubusercontent.com/blendle/kns/master/bin/ktx 		2>&1 | tee -a "$outFile"
  install -o root -g root -m 0755 ktx /usr/local/bin/ktx       					2>&1 | tee -a "$outFile"	

  #
  # Setup K9s
  #
	wget https://github.com/derailed/k9s/releases/download/v0.32.5/k9s_linux_amd64.deb 	2>&1 | tee -a "$outFile"
  apt install -y ./k9s_linux_amd64.deb																								2>&1 | tee -a "$outFile"

	#
	# Setup Kind
	#
	wget https://kind.sigs.k8s.io/dl/v0.30.0/kind-linux-amd64														2>&1 | tee -a "$outFile"	
  install -o root -g root -m 0755 kind-linux-amd64 /usr/local/bin/kind								2>&1 | tee -a "$outFile"


	#
	# Setup Minikube
	#
	wget https://github.com/kubernetes/minikube/releases/download/v1.36.0/minikube-linux-amd64  2>&1 | tee -a "$outFile"
	cp minikube-linux-amd64 minikube-linux-amd64-v1.36.0																				2>&1 | tee -a "$outFile"
  install -o root -g root -m 0755 minikube-linux-amd64 /usr/local/bin/minikube								2>&1 | tee -a "$outFile"


  #
  # Setup Docker
  #
  wget https://download.docker.com/linux/ubuntu/gpg | gpg --yes --dearmor -o /etc/apt/keyrings/docker.gpg 			2>&1 | tee -a "$outFile"
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" 2>&1 | tee /etc/apt/sources.list.d/docker.list > /dev/null
  apt update -y																																														2>&1 | tee -a "$outFile"			
  apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin					2>&1 | tee -a "$outFile"
  systemctl start docker																																									2>&1 | tee -a "$outFile"
  systemctl enable docker																																									2>&1 | tee -a "$outFile"
  usermod -aG docker ubuntu																																								2>&1 | tee -a "$outFile"
  
  #
  # Setup nkp-cli
  #
	wget http://10.38.48.244/artifacts/nkp_v2.16.0_linux_amd64.tar.gz																				2>&1 | tee -a "$outFile"
	tar -xf nkp_v2.16.0_linux_amd64.tar.gz																																	2>&1 | tee -a "$outFile"
  install -o root -g root -m 0755 nkp /usr/local/bin/nkp     																							2>&1 | tee -a "$outFile"		

	#
	# Profile ThingZ:
	#

  wget https://raw.githubusercontent.com/ericm48/cmdzNThangs/refs/heads/main/sh/ubuntu/bashrcBASE					2>&1 | tee -a "$outFile"		
  cp bashrcBASE /home/ubuntu/.bashrc																																			2>&1 | tee -a "$outFile"		
  chmod +x /home/ubuntu/.bashrc  																																					2>&1 | tee -a "$outFile"		
  
	wget https://raw.githubusercontent.com/ericm48/cmdzNThangs/refs/heads/main/sh/ubuntu/kubectl_aliasBASE	2>&1 | tee -a "$outFile"		
  cp kubectl_aliasBASE /home/ubuntu/.kubectl_alias																												2>&1 | tee -a "$outFile"		
  chmod +x /home/ubuntu/.kubectl_alias																																		2>&1 | tee -a "$outFile"	
  
	wget https://raw.githubusercontent.com/ericm48/cmdzNThangs/refs/heads/main/sh/kube-ps1.sh								2>&1 | tee -a "$outFile"
	cp kube-ps1.sh /dev2/sh/kube-ps1.sh																																			2>&1 | tee -a "$outFile"
	chmod +x /dev2/sh/kube-ps1.sh
		
	wget https://raw.githubusercontent.com/ericm48/cmdzNThangs/refs/heads/main/sh/git-ps1.sh								2>&1 | tee -a "$outFile"
	cp kube-ps1.sh /dev2/sh/git-ps1.sh																																			2>&1 | tee -a "$outFile"
	chmod +x /dev2/sh/git-ps1.sh																																						2>&1 | tee -a "$outFile"
	
	
	#
	# Final chown's
	#
	
	chown -R root:ubuntu /dev2																																							2>&1 | tee -a "$outFile"
	chown -R root:ubuntu /data																																							2>&1 | tee -a "$outFile"
	
	

