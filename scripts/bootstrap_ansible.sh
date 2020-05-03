#!/bin/bash


set -e

echo "Installing Ansible..."
apt-get update -y
apt-get install -y software-properties-common
apt-add-repository ppa:ansible/ansible
apt-get update
apt-get install -y ansible apt-transport-https
