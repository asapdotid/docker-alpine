# Docker Ansible

![Docker Automated build](https://img.shields.io/docker/automated/asapdotid/ansible) ![Docker Pulls](https://img.shields.io/docker/pulls/asapdotid/ansible.svg)

| Docker Tag | Git Release | Ansible Version | OS Version  | Size                                                                                         |
| ---------- | ----------- | --------------- | ----------- | -------------------------------------------------------------------------------------------- |
| tools      | Main Branch | 2.15            | Alpine 3.17 | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/asapdotid/ansible/tools) |

## Additional services

-   Bash
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

| Variable                    | Description                          |
| --------------------------- | ------------------------------------ |
| DEPLOY_SSH_HOST_SERVER      | deploy host (server)                 |
| DEPLOY_SSH_HOST_PRIVATE_KEY | deploy key (private) `base64` encode |
| DEPLOY_SSH_HOST_PUBLIC_KEY  | deploy key (public) `base64` encode  |

### Run Playbook

```
docker run -it --rm \
  -e DEPLOY_SSH_HOST_PRIVATE_KEY='__private_key_base64_encode__' \
  -e DEPLOY_SSH_HOST_PUBLIC_KEY='__public_key_base64_encode__' \
  asapdotid/ansible:tools
```

### Modified entrypoint & Dockerfile

-   insert SSH private key use `base64` decode `-d`
-   insert SSH public key use `base64` decode `-d`
-   Dockerfile add ssh config `LogLevel ERROR`

### Ansible Galaxy Collection

-   Ansible Synchronize `ansible.posix: version 1.4.0` (https://galaxy.ansible.com/ansible/posix)
-   Ansible Docker `community.docker: version 3.0.2` (https://galaxy.ansible.com/community/docker)

## License

MIT / BSD

## Author Information

[JogjaScript](https://jogjascript.com)

This role was created in 2021 by [Asapdotid](https://github.com/asapdotid).
