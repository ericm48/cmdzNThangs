#!/bin/bash
#  Script that sets up a base set of tools for Ubuntu

  set -x


usage(){
   			echo " "
   			echo " "
   			echo " "
   			echo "Usage:   $0		-Sets up a basic Ubuntu JumpBox with my utilties and such."
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


	# setup a place for logging...
	
	
	mkdir -p "/data/inet"
	mkdir -p "/data/maven-3.x/eric"
	mkdir -p "/data/txt"
	
	mkdir -p "/dev2/sh"
	
	mkdir -p "/dev2/java/eric/master"
	mkdir -p "/dev2/java/eric/forkz"	
	mkdir -p "/dev2/k8/eric/master"	
	mkdir -p "/dev2/helm/eric/master"		

	mkdir -p "/mnt/nfsshare/k8svolumes"

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
	# Add direnv
	#
	apt install direnv
	
	#
	# Add some utils...
	#
	apt install -y zip unzip
	apt install -y nfs-kernel-server
	
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

  apt install -y kubectx

	#
	# Helm
	#	
  wget -P /data/inet https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
  chmod 700 /data/inet/get-helm-3
	/data/inet/get-helm-3

  #
  # Setup K9s
  #
	wget -P /data/inet https://github.com/derailed/k9s/releases/download/v0.50.9/k9s_linux_amd64.deb
	mv /data/inet/k9s_linux_amd64.deb /data/inet/k9s_linux_amd64-v0.50.9.deb
  apt install -y /data/inet/k9s_linux_amd64-v0.50.9.deb

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
	# Setup Flux
	#
  wget -P /data/inet https://fluxcd.io/install.sh
  mv /data/inet/install.sh /data/inet/flux-install.sh
  chmod +x /data/inet/flux-install.sh
	/data/inet/flux-install.sh  
	
	#
	# Setup httpie
	#
	snap install httpie	

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

	getent group docker  					# group docker should already out there...
  usermod -aG docker ubuntu && newgrp docker
	usermod -aG docker nutanix && newgrp docker
  
  # Start'em up!
  systemctl enable docker.service
  systemctl start docker.service

  systemctl enable containerd.service
  systemctl start containerd.service  
  
  # Docker will not work until we bounce the machine, last step...																																						
  
  #
  # Setup nkp-cli
  #
	wget -P /data/inet http://10.38.48.244/artifacts/nkp_v2.16.1_linux_amd64.tar.gz
	tar -xf /data/inet/nkp_v2.16.1_linux_amd64.tar.gz												
  install -o root -g root -m 0755 /data/inet/nkp /usr/local/bin/nkp     																	

  #
  # Pull & Extract nkp-bundle
  #
	wget -P /data/inet http://10.38.48.244/artifacts/nkp-bundle_v2.16.1_linux_amd64.tar.gz
	tar -xf /data/inet/nkp-bundle_v2.16.1_linux_amd64.tar.gz

	#
	# Profile ThingZ:
	#
  wget -P /data/inet https://raw.githubusercontent.com/ericm48/cmdzNThangs/refs/heads/main/sh/ubuntu/bashrcBASE		
  cp /data/inet/bashrcBASE /home/ubuntu/.bashrc
  chmod +x /home/ubuntu/.bashrc
  cp /data/inet/bashrcBASE /home/nutanix/.bashrc
  chmod +x /home/nutanix/.bashrc  
  cp /data/inet/bashrcBASE /etc/skel/.bashrc
  chmod +x /etc/skel/.bashrc  
  
	wget -P /data/inet https://raw.githubusercontent.com/ericm48/cmdzNThangs/refs/heads/main/sh/ubuntu/kubectl_aliasesBASE	
  cp /data/inet/kubectl_aliasesBASE /home/ubuntu/.kubectl_aliases
  chmod +x /home/ubuntu/.kubectl_aliases
  cp /data/inet/kubectl_aliasesBASE /home/nutanix/.kubectl_aliases
  chmod +x /home/nutanix/.kubectl_aliases

  chown -R nutanix:nutanix /home/nutanix
  
	wget -P /data/inet https://raw.githubusercontent.com/ericm48/cmdzNThangs/refs/heads/main/sh/kube-ps1.sh
	cp /data/inet/kube-ps1.sh /dev2/sh/kube-ps1.sh
	chmod +x /dev2/sh/kube-ps1.sh
		
	wget -P /data/inet https://raw.githubusercontent.com/ericm48/cmdzNThangs/refs/heads/main/sh/git-ps1.sh					
	cp /data/inet/kube-ps1.sh /dev2/sh/git-ps1.sh
	chmod +x /dev2/sh/git-ps1.sh																																													
	
	wget -P /data/inet https://raw.githubusercontent.com/ericm48/cmdzNThangs/refs/heads/main/sh/ipv4-addr-check.sh
	cp /data/inet/ipv4-addr-check.sh /dev2/sh/ipv4-addr-check.sh
	chmod +x /dev2/sh/ipv4-addr-check.sh
	
	wget -P /data/inet https://raw.githubusercontent.com/ericm48/cmdzNThangs/refs/heads/main/sh/dis
	cp /data/inet/dis /dev2/sh/dis
	chmod +x /dev2/sh/dis
		
	#
	# cri-o / crictl-tools
	#
	wget -P /data/inet https://raw.githubusercontent.com/ericm48/cmdzNThangs/refs/heads/main/sh/ubuntu/install-crictl.sh
	cp /data/inet/install-crictl.sh /dev2/sh/install-crictl.sh
	chmod +x /dev2/sh/install-crictl.sh
	/dev2/sh/install-crictl.sh
	
	#
	# dev tools
	#
	wget -P /data/inet https://raw.githubusercontent.com/ericm48/cmdzNThangs/refs/heads/main/sh/ubuntu/install-devtoolz.sh
	cp /data/inet/install-devtoolz.sh /dev2/sh/install-devtoolz.sh
	chmod +x /dev2/sh/install-devtoolz.sh
	/dev2/sh/install-devtoolz.sh
		
	#
	# Final chown's & chmod's
	#
	chown -R ubuntu:root /dev2
	chown -R ubuntu:root /data
	chown -R ubuntu:root /opt	

	chmod 777 -R /dev2
	chmod 777 -R /data

	echo "Done!"
		
	#
	# Restart
	#
	shutdown now -r
	
	