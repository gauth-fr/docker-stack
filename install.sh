#!/usr/bin/env bash

if (( $# != 2 )); then
    echo "Syntax: install.sh PATH_TO_DOCKER_FILES FILES_OWNER"
    exit 1
fi

DOCKER_FILES=$1
OWNER=$2

if (( $(id -u) != 0 )); then
    echo "This script should either be run as root or with sudo! Aborting install..."
    exit 1
fi

echo "Copying script to /usr/local/bin/stack"
curl -s -o /usr/local/bin/stack https://raw.githubusercontent.com/gauth-fr/docker-stack/main/stack
chmod 755 /usr/local/bin/stack
sed -i /usr/local/bin/stack -e "s|##DOCKER_FILES##|$DOCKER_FILES|g"
mkdir -p $DOCKER_FILES
chmod 770 $DOCKER_FILES
echo "Run stack init" 
/usr/local/bin/stack init
chown $OWNER: $DOCKER_FILES $DOCKER_FILES/.env  $DOCKER_FILES/docker-compose.yaml.template

if [ -d "/etc/bash_completion.d" ]; then
    echo "Copying completion file to /etc/bash_completion.d/stack.completion"
    curl -s -o /etc/bash_completion.d/stack.completion https://raw.githubusercontent.com/gauth-fr/docker-stack/main/stack.completion
    chmod 644 /etc/bash_completion.d/stack.completion 
fi



