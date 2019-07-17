#!/bin/bash -eux
#remove ansible

OS=$(cat /etc/*-release | grep ID_LIKE | cut -d = -f 2-)

if [[ "$OS" == *"debian"* ]];then
    echo "This is $OS"
    sudo apt -y remove --purge ansible
    sudo apt-add-repository --remove ppa:ansible/ansible
    # Apt cleanup.
    sudo apt -y autoremove
    sudo apt -y update
    exit 0
else
    sudo yum remove -y ansible
    exit 0
fi