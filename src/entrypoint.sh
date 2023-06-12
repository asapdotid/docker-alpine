#!/usr/bin/env bash

set -e

# USAGE:
#    ansible-playbook-wrapper  [other ansible-playbook arguments]
#
# ENVIRONMENT VARIABLES:
#
#    - DEPLOY_SSH_HOST_SERVER                   deploy host (server)
#    - DEPLOY_SSH_HOST_PRIVATE_KEY              deploy key (private)
#    - DEPLOY_SSH_HOST_PUBLIC_KEY               deploy key (public)

[ -d $HOME/.ssh ] || mkdir -p $HOME/.ssh && chmod -R 0700 $HOME/.ssh

# Optional deploy private_key
if [ ! -z "$DEPLOY_SSH_HOST_PRIVATE_KEY" ] && [ ! -f "$HOME/.ssh/id_rsa" ]; then
    echo -n "${DEPLOY_SSH_HOST_PRIVATE_KEY}" | base64 -d > $HOME/.ssh/id_rsa
    chmod 0600 $HOME/.ssh/id_rsa
fi

# Loadkey into ssh-agent if key exist
if [ -f "$HOME/.ssh/id_rsa" ]; then
    eval $(ssh-agent -s)
    ssh-add $HOME/.ssh/id_rsa
fi

# Optional deploy key
if [ ! -z "$DEPLOY_SSH_HOST_PUBLIC_KEY" ] && [ ! -f "$HOME/.ssh/id_rsa.pub" ]; then
    echo -n "${DEPLOY_SSH_HOST_PUBLIC_KEY}" | base64 -d > $HOME/.ssh/id_rsa.pub
    chmod 0644 $HOME/.ssh/id_rsa.pub
fi

# Optional deploy known hosts
if [ ! -z "$DEPLOY_SSH_HOST_SERVER" ] && [ ! -f "$HOME/.ssh/known_hosts" ]; then
    ssh-keyscan -H "${DEPLOY_SSH_HOST_SERVER}" >> $HOME/.ssh/known_hosts
    chmod 0644 $HOME/.ssh/known_hosts
fi

exec "$@"