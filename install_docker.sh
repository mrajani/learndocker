#!/bin/bash

user=${1:-$(logname)}

if [[ ( -z ${os} && -z ${dist} ) ]]; then
  if [ -e /etc/os-release ]; then
    . /etc/os-release
    os=$( echo ${ID} | awk '{ print tolower($1) }')
    dist=${VERSION_ID}
  fi
fi
echo "Found ${os} "

if [[ ${os} == "centos" ]]; then
  # Install Docker in CentOS
  sudo yum remove docker \
    docker-client \
    docker-client-latest \
    docker-common \
    docker-latest \
    docker-latest-logrotate \
    docker-logrotate \
    docker-selinux \
    docker-engine-selinux \
    docker-engine
  sudo rm -rf /var/lib/docker
  sudo yum install -y yum-utils \
    device-mapper-persistent-data \
    lvm2
  sudo yum-config-manager \
      --add-repo \
      https://download.docker.com/linux/centos/docker-ce.repo
  #sudo yum-config-manager --enable docker-ce-edge
  #sudo yum-config-manager --disable docker-ce-edge
  sudo yum install -y docker-ce
  sudo usermod -aG docker ${user}
  sudo yum install -y epel-release
  #yum list docker-ce --showduplicates | sort -r
  #sudo yum install docker-ce-<VERSION STRING>
  sudo systemctl start docker
  
elif [[ ${os} == "ubuntu" ]]; then
  # Install Docker in Ubuntu 18.04
  sudo apt-get remove docker docker-engine docker.io
  sudo apt-get -yqq update
  sudo DEBIAN_FRONTEND=noninteractive apt-get -yqq upgrade
  sudo apt-get -yq install apt-transport-https ca-certificates curl software-properties-common
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  sudo apt-key fingerprint 0EBFCD88
  sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
  sudo apt -yqq update 
  sudo apt install -yqq docker-ce
  sudo usermod -aG docker ${user}
  sudo apt-get -yqq install python-pip
elif [[ ${os} == "amzn" ]]; then
  sudo amazon-linux-extras install docker
  sudo systemctl start docker
  sudo systemctl enable docker
  sudo usermod -aG docker ${user}
else
  echo "Cannot identify the OS"
fi

sudo systemctl status docker --no-pager
sudo docker container run --rm hello-world

url=https://github.com/docker/compose/releases
url_effective=$(curl -sSL -I -o /dev/null -w %{url_effective} ${url}/latest)
tag=${url_effective##*/}
sudo curl -sSL "${url}/download/${tag}/docker-compose-$(uname -s)-$(uname -m)" \
     -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version

