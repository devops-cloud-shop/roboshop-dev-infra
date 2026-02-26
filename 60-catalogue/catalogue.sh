#!/bin/bash

# # growing the /home volume for terraform purpose
# growpart /dev/nvme0n1 4
# lvextend -L +30G /dev/mapper/RootVG-homeVol
# xfs_growfs /home
component=$1
environment=$2

dnf install ansible -y
# ansible-pull -U https://github.com/devops-cloud-shop/ansible-terraform.git -e component=$component main.yaml

REPO_URL=https://github.com/devops-cloud-shop/ansible-terraform.git
REPO_DIR=/opt/roboshop/ansible
ANSIBLE_DIR=ansible-terraform

mkdir -p $REPO_DIR
mkdir -p /var/log/roboshop #dir for logging
touch ansible.log

cd $REPO_DIR

#check if ansible playbook repo exists 

if [ -d $ANSIBLE_DIR ]; then

    cd $ANSIBLE_DIR
    git pull
else

    git clone $REPO_URL
    cd $ANSIBLE_DIR
fi

ansible-playbook -e component=$component -e env=$environment main.yaml
