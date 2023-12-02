#!/usr/bin/env bash

set -e

# USAGE:
# ENVIRONMENT VARIABLES:
#
#    - SSH_HOST_TARGET              deploy host (server)
#    - SSH_PRIVATE_KEY              deploy key (private)
#    - SSH_PUBLIC_KEY               deploy key (public)

[ -d "$HOME/.ssh" ] || mkdir -p "$HOME/.ssh" && chmod -R 0700 "$HOME/.ssh"

# Optional deploy private_key
if [ ! -z "$SSH_PRIVATE_KEY" ] && [ ! -f "$HOME/.ssh/id_rsa" ]; then
    echo -n "${SSH_PRIVATE_KEY}" | base64 -d >"$HOME/.ssh/id_rsa"
    chmod 0600 "$HOME/.ssh/id_rsa"
fi

# Loadkey into ssh-agent if key exist
if [ -f "$HOME/.ssh/id_rsa" ]; then
    eval "$(ssh-agent -s)"
    ssh-add "$HOME/.ssh/id_rsa"
fi

# Optional deploy key
if [ ! -z "$SSH_PUBLIC_KEY" ] && [ ! -f "$HOME/.ssh/id_rsa.pub" ]; then
    echo -n "${SSH_PUBLIC_KEY}" | base64 -d >"$HOME/.ssh/id_rsa.pub"
    chmod 0644 "$HOME/.ssh/id_rsa.pub"
fi

# Optional deploy known hosts
if [ ! -z "$SSH_HOST_TARGET" ] && [ ! -f "$HOME/.ssh/known_hosts" ]; then
    ssh-keyscan -H "${SSH_HOST_TARGET}" >>"$HOME/.ssh/known_hosts"
    chmod 0644 "$HOME/.ssh/known_hosts"
fi

exec "$@"
