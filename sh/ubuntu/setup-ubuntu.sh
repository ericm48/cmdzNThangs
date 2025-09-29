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
	# Setup Completion
	#
  #apt install -y bash-completion	| tee -a "$outFile"	
  #source /usr/share/bash-completion/bash_completion  

	#
	# Setup K8s
	#
  wget https://dl.k8s.io/release/v1.34.1/bin/linux/amd64/kubectl 				| tee -a "$outFile"
  install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl       	| tee -a "$outFile"
  mv kubectl kubectl-v1.34.1-linux-amd64                               	| tee -a "$outFile"

	#
  # Bash-Completion
  #
  source <(kubectl completion bash)																			| tee -a "$outFile"
  
  echo "source <(kubectl completion bash)" >> ~/.bashrc  
  alias k=kubectl
  
  complete -F __start_kubectl k																					| tee -a "$outFile"
  
	#
	# K8s Utilities
	#	
 	wget https://raw.githubusercontent.com/blendle/kns/master/bin/kns 		| tee -a "$outFile"
  install -o root -g root -m 0755 kns /usr/local/bin/kns       					| tee -a "$outFile"
 	
	wget https://raw.githubusercontent.com/blendle/kns/master/bin/ktx 		| tee -a "$outFile"
  install -o root -g root -m 0755 ktx /usr/local/bin/ktx       					| tee -a "$outFile"	

  #
  # Setup K9s
  #
	wget https://github.com/derailed/k9s/releases/download/v0.32.5/k9s_linux_amd64.deb 	| tee -a "$outFile"
  apt install -y ./k9s_linux_amd64.deb																								| tee -a "$outFile"

	#
	# Setup Kind
	#
	wget https://kind.sigs.k8s.io/dl/v0.30.0/kind-linux-amd64														| tee -a "$outFile"	
  install -o root -g root -m 0755 kind /usr/local/bin/kind     												| tee -a "$outFile"		

  #
  # Setup Docker
  #

  wget https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg 			| tee -a "$outFile"
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
  apt update -y																																														| tee -a "$outFile"			
  apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin					| tee -a "$outFile"
  systemctl start docker																																									| tee -a "$outFile"
  systemctl enable docker																																									| tee -a "$outFile"
  usermod -aG docker ubuntu																																								| tee -a "$outFile"
  
  #
  # Setup nkp-cli
  #
	wget http://10.38.48.244/artifacts/nkp_v2.16.0_linux_amd64.tar.gz																				| tee -a "$outFile"
	tar -xf nkp_v2.16.0_linux_amd64.tar.gz																																	| tee -a "$outFile"
  install -o root -g root -m 0755 nkp /usr/local/bin/nkp     																							| tee -a "$outFile"		

	#
	# Profile ThingZ:
	#


