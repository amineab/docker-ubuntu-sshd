# -----------------------------------------------------------------------------
# This is base image of Ubuntu LTS with SSHD service.
#
# Authors: Art567
# Updated: Sep 20th, 2015
# Require: Docker (http://www.docker.io/)
# -----------------------------------------------------------------------------


# Base system is the latest LTS version of Ubuntu.
from   ubuntu:14.04


# Make sure we don't get notifications we can't answer during building.
env    DEBIAN_FRONTEND noninteractive


# Prepare scripts and configs
add    ./apt/sources.list /etc/apt/sources.list
add    ./scripts/start /start


# Download and install everything from the repos.
run    apt-get -q -y update; apt-get -q -y upgrade
run    apt-get -q -y install sudo openssh-server
run    mkdir /var/run/sshd


# Set root password
run    echo 'root:password' >> /root/passwdfile


# Create user and it's password
run    useradd -m -G sudo master
run    echo 'master:password' >> /root/passwdfile


# Apply root password
run    chpasswd -c SHA512 < /root/passwdfile
run    rm /root/passwdfile


# Port 22 is used for ssh
expose 22


# Assign /data as static volume.
volume ["/data"]


# Fix all permissions
run    chmod +x /start


# Starting sshd
cmd    ["/start"]
