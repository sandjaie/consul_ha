#!/bin/bash
#Examples
#ID_LIKE="centos rhel fedora"
#ID_LIKE="debian"

OS=$(cat /etc/*-release | grep ID_LIKE | cut -d = -f 2-)

if [[ "$OS" == *"debian"* ]];then
    echo "This is $OS"
    sudo apt-get -y update
    sudo apt-get install -y software-properties-common
    sudo apt-add-repository ppa:ansible/ansible
    # Install Ansible
    sudo apt-get -y update
    sudo apt-get install -y ansible
    exit 0
else
    sudo yum install -y ansible-2.7.10
    exit 0
fi
