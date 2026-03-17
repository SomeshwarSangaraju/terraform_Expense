#!/bin/bash

component=$1
environment=$2
dnf install ansible -y

REPO_URL=https://github.com/SomeshwarSangaraju/ansible-expense-roles-tf.git
REPO_DIR=/opt/expense/ansible
ANSIBLE_DIR=ansible-expense-roles-tf

mkdir -p $REPO_DIR
mkdir -p /var/log/expense/
touch ansible.log

cd $REPO_DIR

# check if ansible repo is already cloned or not

if [ -d $ANSIBLE_DIR ]; then

    cd $ANSIBLE_DIR
    git pull
else
    git clone $REPO_URL
    cd $ANSIBLE_DIR
fi
echo "environment is: $2"
# ansible-playbook -e component=$component -e env=$environment main.yaml
ansible-playbook -e component=frontend -e env=${environment} main.yaml

