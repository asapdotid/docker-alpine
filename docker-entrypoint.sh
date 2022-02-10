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

[ -d /ansible/.ssh ] || mkdir -p /ansible/.ssh && chmod -R 0700 /ansible/.ssh

# Optional deploy private_key
if [ ! -z "${DEPLOY_SSH_HOST_PRIVATE_KEY:-}" ] && [ ! -f "/ansible/.ssh/id_rsa" ]; then
    echo -n "${DEPLOY_SSH_HOST_PRIVATE_KEY}" | base64 -d > /ansible/.ssh/id_rsa
    chmod 0600 /ansible/.ssh/id_rsa
fi

# Loadkey into ssh-agent if key exist
if [ -f "/ansible/.ssh/id_rsa" ]; then
    eval $(ssh-agent -s)
    ssh-add /ansible/.ssh/id_rsa
fi

# Optional deploy key
if [ ! -z "${DEPLOY_SSH_HOST_PUBLIC_KEY:-}" ] && [ ! -f "/ansible/.ssh/id_rsa.pub" ]; then
    echo -n "${DEPLOY_SSH_HOST_PUBLIC_KEY}" | base64 -d > /ansible/.ssh/id_rsa.pub
    chmod 0644 /ansible/.ssh/id_rsa.pub
fi

# Optional deploy known hosts
if [ ! -z "${DEPLOY_SSH_HOST_SERVER:-}" ] && [ ! -f "/ansible/.ssh/known_hosts" ]; then
    ssh-keyscan -H "${DEPLOY_SSH_HOST_SERVER}" >> /ansible/.ssh/known_hosts
    chmod 0644 /ansible/.ssh/known_hosts
fi

exec "$@"