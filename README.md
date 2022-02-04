# Docker Ansible

![Docker Automated build](https://img.shields.io/docker/automated/asapdotid/ansible) [![Docker Pulls](https://img.shields.io/docker/pulls/asapdotid/ansible.svg)](https://hub.docker.com/r/asapdotid/ansible/tools)

Base image: `cytopia/docker-ansible` [project](https://github.com/cytopia/docker-ansible)

Image version:

-   (asapdotid/ansible:tools) Tools ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/asapdotid/ansible/tools)

## Additional services

-   Sed
-   Curl
-   Gawk
-   Rsync

## Check docker image version

-   Version: asapdotid/ansible:tools

```bash
docker run -t -i --rm asapdotid/ansible:${version} bash
```

## Cleaning Docker

```bash
docker system prune --all --force --volumes
```

## Usage

### Environnement variable

### Mitogen

To enable mitogen

### Run Playbook

```
docker run -it --rm \
  -v ${PWD}:/ansible \
  asapdotid/ansible-alpine:latest \
  ansible-playbook -i inventory playbook.yml
```

### Generate Base Role structure

```
docker run -it --rm \
  -v ${PWD}:/ansible \
  asapdotid/ansible-alpine:latest \
  ansible-galaxy init role-name
```

### Lint Role

```
docker run -it --rm asapdotid/ansible-alpine:latest \
  -v ${PWD}:/ansible ansible-playbook tests/playbook.yml --syntax-check
```

### Run with forwarding ssh agent

```
docker run -it --rm \
  -v $(readlink -f $SSH_AUTH_SOCK):/ssh-agent \
  -v ${PWD}:/ansible \
  -e SSH_AUTH_SOCK=/ssh-agent \
  asapdotid/ansible-alpine:latest \
  sh
```

### Modified entrypoint & Dockerfile

-   insert SSH private key use `base64` decode `-d`
-   Dockerfile add ssh config `LogLevel ERROR`

### Ansible Galaxy Collection

-   Ansible Synchronize `ansible.posix` (https://galaxy.ansible.com/ansible/posix)
-   Ansible Docker `community.docker` (https://galaxy.ansible.com/community/docker)
