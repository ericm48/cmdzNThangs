#!/bin/bash
#  Script that sets up a base set of tools for Ubuntu

  set -x

	# setup a place for logging...
	
	mkdir -p "/data/txt"					
		
	mkdir -p "/data/inet" 				
	mkdir -p "/dev2/sh"   				

	cd "/data/inet"								
	
	pwd
		
	apt update -y  								
	apt upgrade -y 								


	#
	# Add Network Stuff
	#
	apt install -y nmap						
	apt install -y net-tools			
	apt install -y pkgconf				

	#
	# Setup Completion
	#
  #apt install -y bash-completion	2>&1 | tee -a "$outFile"	
  #source /usr/share/bash-completion/bash_completion  

	#
	# Setup K8s
	#
  wget -P /data/inet https://dl.k8s.io/release/v1.34.1/bin/linux/amd64/kubectl 	
  install -o root -g root -m 0755 /data/inet/kubectl /usr/local/bin/kubectl     
  mv /data/inet/kubectl /data/inet/kubectl-v1.34.1-linux-amd64         					

	#
  # Bash-Completion
  #
  source <(kubectl completion bash)																			
  
  echo "source <(kubectl completion bash)" >> ~/.bashrc  
  alias k=kubectl
  
  complete -F __start_kubectl k																					
  
	#
	# K8s Utilities
	#	
 	wget -P /data/inet https://raw.githubusercontent.com/blendle/kns/master/bin/kns 		
  install -o root -g root -m 0755 /data/inet/kns /usr/local/bin/kns       						
 	
	wget -P /data/inet https://raw.githubusercontent.com/blendle/kns/master/bin/ktx 		
  install -o root -g root -m 0755 /data/inet/ktx /usr/local/bin/ktx       						

  #
  # Setup K9s
  #
	wget -P /data/inet https://github.com/derailed/k9s/releases/download/v0.32.5/k9s_linux_amd64.deb 	
  apt install -y /data/inet/k9s_linux_amd64.deb																											

	#
	# Setup Kind
	#
	wget -P /data/inet https://kind.sigs.k8s.io/dl/v0.30.0/kind-linux-amd64														
  install -o root -g root -m 0755 /data/inet/kind-linux-amd64 /usr/local/bin/kind										

	#
	# Setup Minikube
	#
	wget -P /data/inet https://github.com/kubernetes/minikube/releases/download/v1.36.0/minikube-linux-amd64  
	cp /data/inet/minikube-linux-amd64 /data/inet/minikube-linux-amd64-v1.36.0																
  install -o root -g root -m 0755 /data/inet/minikube-linux-amd64 /usr/local/bin/minikube										

	#
	# Setup fzf
	#
  wget -P /data/inet https://github.com/junegunn/fzf/releases/download/v0.65.2/fzf-0.65.2-linux_amd64.tar.gz
  tar -xf /data/inet/fzf-0.65.2-linux_amd64.tar.gz -C /data/inet
  install -o root -g root -m 0755 /data/inet/fzf /usr/local/bin/fzf

  #
  # Setup Docker
  #  
	install -m 0755 -d /etc/apt/keyrings																																	
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc								
  chmod a+r /etc/apt/keyrings/docker.asc																																

	# Add the repository to Apt sources:
	echo \
  	"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  	$(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  	tee /etc/apt/sources.list.d/docker.list > /dev/null
 	
 	apt-get update    

  apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin					
  usermod -aG docker ubuntu
  systemctl start docker																																									
  systemctl enable docker																																									
  
  #
  # Setup nkp-cli
  #
	wget -P /data/inet http://10.38.48.244/artifacts/nkp_v2.16.0_linux_amd64.tar.gz													
	tar -xf /data/inet/nkp_v2.16.0_linux_amd64.tar.gz																												
  install -o root -g root -m 0755 /data/inet/nkp /usr/local/bin/nkp     																	

	#
	# Profile ThingZ:
	#
  wget -P /data/inet https://raw.githubusercontent.com/ericm48/cmdzNThangs/refs/heads/main/sh/ubuntu/bashrcBASE		
  cp /data/inet/bashrcBASE /home/ubuntu/.bashrc																																		
  chmod +x /home/ubuntu/.bashrc  																																									
  
	wget -P /data/inet https://raw.githubusercontent.com/ericm48/cmdzNThangs/refs/heads/main/sh/ubuntu/kubectl_aliasBASE	
  cp /data/inet/kubectl_aliasBASE /home/ubuntu/.kubectl_alias																														
  chmod +x /home/ubuntu/.kubectl_alias																																									
  
	wget -P /data/inet https://raw.githubusercontent.com/ericm48/cmdzNThangs/refs/heads/main/sh/kube-ps1.sh								
	cp /data/inet/kube-ps1.sh /dev2/sh/kube-ps1.sh																																				
	chmod +x /dev2/sh/kube-ps1.sh
		
	wget -P /data/inet https://raw.githubusercontent.com/ericm48/cmdzNThangs/refs/heads/main/sh/git-ps1.sh								
	cp /data/inet/kube-ps1.sh /dev2/sh/git-ps1.sh																																					
	chmod +x /dev2/sh/git-ps1.sh																																													
		
	#
	# Final chown's
	#	
	chown -R root:ubuntu /dev2																																														
	chown -R root:ubuntu /data																																														
	
	
	#
	# Setup ssh-key
	#
	sudo su ubuntu
	ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -q -N ""	
	exit
	
	#
	# Restart
	#
	#shutdown now -r
	