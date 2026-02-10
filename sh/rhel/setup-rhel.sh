#!/bin/bash
#  Script that sets up a base set of tools for RHEL

#  set -x


usage(){
   			echo " "
   			echo " "
   			echo " "
   			echo "Usage:   $0		-Sets up a basic RHEL JumpBox with my utilties and such."
   			echo " "
   			echo "              -REQUIRES eVars: "
   			echo "                    NUTANIX_VERSION"
   			echo "                    NUTANIX_ARTIFACT_HOST"   			
   			echo " "
   			echo " -H/-h        -Display this help message."
   			echo " "
   			echo " "
   			echo " "
	exit 1
}


	if [ "$1" == "--help" ] || [  "$1" == "--H" ] || [ "$1" == "--h" ] || [  "$1" == "-H" ] || [ "$1" == "-h" ]
	  then
	    usage
	fi

	
  echo ""
  
	if [[ -v NUTANIX_VERSION ]]; then

	    echo "NUTANIX_VERSION: $NUTANIX_VERSION"
	    
	else
			echo ""
	    echo " ***ERROR*** evar NUTANIX_VERSION is MISSING!"
	    usage
	fi	
	
	if [[ -v NUTANIX_ARTIFACT_HOST ]]; then

	    echo "NUTANIX_ARTIFACT_HOST: $NUTANIX_ARTIFACT_HOST"
	    
	else
			echo ""
	    echo " ***ERROR*** evar NUTANIX_ARTIFACT_HOST is MISSING!"
	    usage
	fi	

	# setup folders...

  echo ""
  echo ""
    
	set -x
	
	mkdir -p "/data/inet"
	mkdir -p "/data/maven-3.x/eric"
	mkdir -p "/data/txt"
	
	mkdir -p "/dev2/sh"
	
	mkdir -p "/dev2/java/eric/master"
	mkdir -p "/dev2/java/eric/forkz"	
	mkdir -p "/dev2/k8/eric/master"	
	mkdir -p "/dev2/helm/eric/master"		

	# Setup NFS Share
	mkdir -p "/mnt/nfsshare/k8svolumes"
	chown nobody:nobody /mnt/nfsshare/k8svolumes
	chmod 777 /mnt/nfsshare/k8svolumes
	echo "/mnt/nfsshare/k8svolumes 192.168.122.0/24(rw,sync,no_root_squash)" | sudo tee -a /etc/exports
	exportfs -rva	

	cd "/data/inet"								
	
	pwd
		
	yum update -y  								
	yum upgrade -y 								

	yum install -y yum-utils device-mapper-persistent-data lvm2
	
	#
	# Add Network Stuff
	#
	yum install  -y nmap			
	yum install  -y net-tools
	yum install -y pkgconf-pkg-config

	#
	# Setup Completion
	#
	yum install -y bash-completion

	# RHEL Base Stuff
	yum install -y epel-release
	yum install snapd
	systemctl enable --now snapd.socket
	
	#
	# Add direnv
	#	
	snap install direnv
	
	#
	# Add some utils...
	#
	yum install  -y zip unzip
	yum install  -y tmux	
	
	#
	# NFS
	#
	yum install nfs-utils -y
	systemctl enable --now nfs-server
	systemctl enable --now rpcbind
	systemctl status nfs-server
	
	firewall-cmd --permanent --add-service=nfs
	firewall-cmd --permanent --add-service=rpc-bind
	firewall-cmd --permanent --add-service=mountd
	firewall-cmd --reload
	
	mkdir -p /nfs/exports/myshare

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

	snap install kubectx --classic

	#
	# Helm
	#	
  wget -P /data/inet https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
  chmod 700 /data/inet/get-helm-3
	/data/inet/get-helm-3

  #
  # Setup K9s
  #
	snap install k9s

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
  # Setup Docker FORCE VERSION 28.0.4
  #
	yum-config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo  

	yum update -y

	#
	# Install 28.0.4 
	#
	
	export DOCKER_VERSION_STRING="28.0.4-1.el9"
			
	yum-config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo

	yum update -y

	yum install -y docker-ce-$DOCKER_VERSION_STRING docker-ce-cli-$DOCKER_VERSION_STRING containerd.io docker-buildx-plugin docker-compose-plugin

	# For latest version of docker, now 29.x.x
  #yum install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

	getent group docker  					# group docker should already out there...
  usermod -aG docker cloud-user && newgrp docker
	usermod -aG docker nutanix && newgrp docker
  
  # Start'em up!
  systemctl enable docker.service
  systemctl start docker.service

  systemctl enable containerd.service
  systemctl start containerd.service  
  
  # Docker will not work until we bounce the machine, Just DO IT! last step...																																						
  
  #
  # Setup nkp-cli
  #
	wget -P /data/inet "$NUTANIX_ARTIFACT_HOST"/nkp_"$NUTANIX_VERSION"_linux_amd64.tar.gz
	tar -xf /data/inet/nkp_"$NUTANIX_VERSION"_linux_amd64.tar.gz
  install -o root -g root -m 0755 /data/inet/nkp /usr/local/bin/nkp

  #
  # Pull & Extract nkp-bundle
  #
	wget -P /data/inet "$NUTANIX_ARTIFACT_HOST"/nkp-air-gapped-bundle_"$NUTANIX_VERSION"_linux_amd64.tar.gz    
	wget -P /data/inet "$NUTANIX_ARTIFACT_HOST"/nkp-bundle_"$NUTANIX_VERSION"_linux_amd64.tar.gz
	tar -xf /data/inet/nkp-bundle_"$NUTANIX_VERSION"_linux_amd64.tar.gz

	#
	# Profile ThingZ:
	#
  wget -P /data/inet https://raw.githubusercontent.com/ericm48/cmdzNThangs/refs/heads/main/sh/rhel/bashrcBASE		
  cp /data/inet/bashrcBASE /home/cloud-user/.bashrc
  chmod +x /home/cloud-user/.bashrc
  cp /data/inet/bashrcBASE /home/nutanix/.bashrc
  chmod +x /home/nutanix/.bashrc
  cp /data/inet/bashrcBASE /etc/skel/.bashrc
  chmod +x /etc/skel/.bashrc
  
	wget -P /data/inet https://raw.githubusercontent.com/ericm48/cmdzNThangs/refs/heads/main/sh/rhel/kubectl_aliasesBASE	
  cp /data/inet/kubectl_aliasesBASE /home/cloud-user/.kubectl_aliases
  chmod +x /home/cloud-user/.kubectl_aliases
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
	wget -P /data/inet https://raw.githubusercontent.com/ericm48/cmdzNThangs/refs/heads/main/sh/cloud-user/install-crictl.sh
	cp /data/inet/install-crictl.sh /dev2/sh/install-crictl.sh
	chmod +x /dev2/sh/install-crictl.sh
	/dev2/sh/install-crictl.sh
	
	#
	# dev tools
	#
	wget -P /data/inet https://raw.githubusercontent.com/ericm48/cmdzNThangs/refs/heads/main/sh/rhel/install-devtoolz.sh
	cp /data/inet/install-devtoolz.sh /dev2/sh/install-devtoolz.sh
	chmod +x /dev2/sh/install-devtoolz.sh
	/dev2/sh/install-devtoolz.sh
		
	#
	# Final chown's & chmod's
	#
	chown -R cloud-user:root /dev2
	chown -R cloud-user:root /data
	chown -R cloud-user:root /opt	

	chmod 777 -R /dev2
	chmod 777 -R /data

	echo "Done!"
		
	#
	# Restart
	#
	shutdown now -r
	
	