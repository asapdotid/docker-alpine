# Docker Ansible Tools (Alpine Linux base)

![Docker Automated build](https://img.shields.io/docker/automated/asapdotid/ansible) ![Docker Pulls](https://img.shields.io/docker/pulls/asapdotid/ansible.svg)

| Docker Tag | Git Release | Ansible Version | OS Version  | Size                                                                                         |
| ---------- | ----------- | --------------- | ----------- | -------------------------------------------------------------------------------------------- |
| tools      | Main Branch | 2.14.1          | Alpine 3.17 | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/asapdotid/ansible/tools) |

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

## How To Use

### Environnement variable

| Variable                    | Description                          |
| --------------------------- | ------------------------------------ |
| DEPLOY_SSH_HOST_SERVER      | deploy host (server)                 |
| DEPLOY_SSH_HOST_PRIVATE_KEY | deploy key (private) `base64` encode |
| DEPLOY_SSH_HOST_PUBLIC_KEY  | deploy key (public) `base64` encode  |

### GitLab CI (`gitlab-ci.yml`)

Please see the `deploy` job stage, how to use the image.

Sample `gitlab-ci.yml` file for CI/CD **NuxtJS** App (`staging` branch):

```yaml
stages:
    - setup
    - build
    - deploy

variables:
    DOCKER_DRIVER: overlay2

# Caches
.node_modules-cache: &node_modules-cache
    key:
        files:
            - yarn.lock
    paths:
        - node_modules
    policy: pull

.yarn-cache: &yarn-cache
    key: yarn-$CI_JOB_IMAGE
    paths:
        - .yarn

.build-cache: &build-cache
    key: build-$CI_JOB_IMAGE
    paths:
        - .nuxt
        - .output
        - public
    policy: pull-push

# Staging - Jobs
setup:staging:
    stage: setup
    rules:
        - if: $CI_COMMIT_BRANCH == "staging"
          changes:
              - "package.json"
          when: always
    tags:
        - nuxt-staging-setup
    image: asapdotid/node:16-buster
    script:
        - yarn config set cache-folder .yarn
        - yarn install --frozen-lockfile --no-progress --cache-folder .yarn
    retry:
        max: 2
        when:
            - runner_system_failure
            - stuck_or_timeout_failure
    cache:
        - <<: *node_modules-cache
          policy: pull-push

build:staging:
    stage: build
    rules:
        - if: $CI_COMMIT_BRANCH == "staging"
    tags:
        - nuxt-staging-build
    image: asapdotid/node:16-buster
    before_script:
        - \cp ./.env.staging ./.env
    script:
        - yarn build:production
    artifacts:
        name: "$CI_COMMIT_BRANCH"
        paths:
            - .nuxt
            - .output
            - .env
            - ecosystem.config.js
            - nuxt.config.ts
            - package.json
            - yarn.lock
            - public
        expire_in: 1 hours
    retry:
        max: 2
        when:
            - runner_system_failure
            - stuck_or_timeout_failure
    cache:
        - <<: *node_modules-cache
        - <<: *build-cache
    dependencies:
        - setup:staging

deploy:staging:
    stage: deploy
    rules:
        - if: $CI_COMMIT_BRANCH == "staging"
    tags:
        - nuxt-staging-deploy
    image: asapdotid/ansible:tools
    variables:
        DEPLOY_SSH_HOST_SERVER: $STAGING_DEPLOY_SSH_HOST_IP
        DEPLOY_SSH_HOST_PRIVATE_KEY: $SSH_PRIVATE_KEY
        DEPLOY_SSH_HOST_PUBLIC_KEY: $SSH_PUBLIC_KEY
    script:
        - echo "Start deploy to the server"
        - |
            echo "Script to deploy build source.. (bash script or ansible script"
        - echo "Done deploy to the server"
    retry:
        max: 2
        when:
            - runner_system_failure
            - stuck_or_timeout_failure
    cache:
        - <<: *node_modules-cache
    dependencies:
        - build:staging
```

### Modified entrypoint & Dockerfile

-   insert SSH private key use `base64` decode `-d`
-   insert SSH public key use `base64` decode `-d`
-   Dockerfile add ssh config `LogLevel ERROR`

### Ansible Galaxy Collection

-   Ansible Synchronize `ansible.posix: version 1.4.0` (https://galaxy.ansible.com/ansible/posix)
-   Ansible Docker `community.docker: version 3.3.1` (https://galaxy.ansible.com/community/docker)

## License

MIT / BSD

## Author Information

[JogjaScript](https://jogjascript.com)

This role was created in 2021 by [Asapdotid](https://github.com/asapdotid).
