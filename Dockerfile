ARG ALPINE_VERSION=3.17
FROM alpine:${ALPINE_VERSION}

# Metadata params
ARG BUILD_DATE
ARG VCS_REF
ARG ANSIBLE_VERSION=7.1.0

# Metadata
LABEL maintainer="Asapdotid <asapdotid@gmail.com>" \
    org.label-schema.url="https://gitlab.com/asap-labs/docker-ansible/-/blob/main/README.md" \
    org.label-schema.build-date=${BUILD_DATE} \
    org.label-schema.version=${ANSIBLE_VERSION} \
    org.label-schema.vcs-url="https://gitlab.com/asap-labs/docker-ansible.git" \
    org.label-schema.vcs-ref=${VCS_REF} \
    org.label-schema.docker.dockerfile="/Dockerfile" \
    org.label-schema.description="Ansible tools docker image" \
    org.label-schema.schema-version="1.0"

RUN apk --update --no-cache add \
    ca-certificates \
    bash \
    git \
    openssh-client \
    openssl \
    python3\
    py3-pip \
    rsync \
    sshpass \
    perl-mime-base64 \
    sed \
    gawk \
    curl \
    yq

RUN apk --update add --virtual .build-deps \
    python3-dev \
    libffi-dev \
    openssl-dev \
    build-base

RUN python3 -m venv /opt/venv
# Make sure we use the virtualenv:
ENV PATH="/opt/venv/bin:$PATH"

RUN pip3 install --upgrade pip wheel && \
    pip3 install --upgrade cryptography cffi && \
    pip3 install ansible>=${ANSIBLE_VERSION} && \
    pip3 install mitogen ansible-lint jmespath pyyaml && \
    apk del .build-deps && \
    rm -rf /var/cache/apk/* && \
    rm -rf /root/.cache/pip

RUN mkdir -p /etc/ansible && \
    echo 'localhost' > /etc/ansible/hosts && \
    echo -e """\
    \n\
    Host *\n\
    StrictHostKeyChecking no\n\
    UserKnownHostsFile=/dev/null\n\
    LogLevel ERROR\n\
    """ >> /etc/ssh/ssh_config

COPY ./requirements.yml ./
RUN ansible-galaxy install -r requirements.yml

COPY ./scripts/entrypoint.sh /
RUN ["chmod", "+x", "/entrypoint.sh"]

WORKDIR /app
ENTRYPOINT ["/entrypoint.sh"]

# default command: display Ansible version
CMD [ "ansible", "--version" ]
