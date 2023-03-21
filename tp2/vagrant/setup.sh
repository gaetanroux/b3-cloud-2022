#!/bin/bash

# Install Python and Ansible
dnf update -y
dnf install -y ansible python

# Create a sudo user with NOPASSWD access
useradd -m -s /bin/bash gaetan
echo "gaetan ALL=(ALL) NOPASSWD:ALL" | tee /etc/sudoers.d/gaetan

# Configure SSH access for the sudo user
mkdir -p /home/gaetan/.ssh
chmod 700 /home/gaetan/.ssh
touch /home/gaetan/.ssh/authorized_keys
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDI2IO3Jv20/KfOlYayZOOPMx1KIA7ufqjxzcak82ppkaE6fZXyShB9jiR32MFiJtgrcq+jUPKj7ITYLSo72FYI6MIH/0ecl8rdtE9VT9IsyNhdhAGm1f/nAVydNMSmuoPYxaX5RbwVvXUh6aQf+NhqO8d2ivWUOTJDv15o+033QGxw+Iy/E2rOJ2NOVVmdvZezR1NBOFiJcbiW6JOAWCSLEMnmo6t1DqDjwD2/l7FhdRTnnVx2ErTbhisdzwKJJ9Zuk2YoeSkEpcXZavEBqKYUpnnQkw44tAUFuZXvFvt1xiXZ+VFIxjT6s5ZxeA6wRaNkPJ5ZHdKsIEvf7NQJGsfR9fuum9Ekky1ZIG/6XujJeHATrbbMf4athtDy+AjklbdwFzFQnDf40gaOC0ifU2tEZJchf6FVtZrt+TUXcMWmzT1Bo6Rnd53JeI59VCLbillCml0vIv5hfer23tflKH6uus6nS5JywbXPqcMcDXNdmrbXvZQc6z64senWmPynDZ35nigBDQgQfRL9y5TSfJ0i/cewmOov4IW6Py6Yl0BRosgm/QiKnfGyYxCKaEvl+SFDgTrc8A5sfdG9jKJw1Dimu5C/5UXkoJbgvo2XdtibMimb2HTjMniWXBp7w1HGOuO30ExqInWq6cqRb1NqEcrA4ERkx8l5PVT4MobjnBXsuQ== gaeta@DESKTOP-0MGUBSH" |  tee /home/gaetan/.ssh/authorized_keys
chmod 600 /home/gaetan/.ssh/authorized_keys
chown -R gaetan:gaetan /home/gaetan/.ssh

# désactive SELinux
setenforce 0
sed -i 's/SELINUX=enforcing/SELINUX=permissive/g' /etc/selinux/config



    