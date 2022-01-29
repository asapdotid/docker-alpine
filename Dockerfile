FROM cytopia/ansible:latest-tools

# Metadata params
ARG BUILD_DATE
ARG VCS_REF

# Metadata
LABEL maintainer="Asapdotid <asapdotid@gmail.com>" \
    org.label-schema.url="https://gitlab.com/asap-labs/docker-ansible/-/blob/main/README.md" \
    org.label-schema.build-date=${BUILD_DATE} \
    org.label-schema.vcs-url="https://gitlab.com/asap-labs/docker-ansible.git" \
    org.label-schema.vcs-ref=${VCS_REF} \
    org.label-schema.docker.dockerfile="/Dockerfile" \
    org.label-schema.description="Ansible docker image" \
    org.label-schema.schema-version="1.0"

# Define uid/gid and user/group names
ENV \
	MY_USER=ansible \
	MY_GROUP=ansible \
	MY_UID=1000 \
	MY_GID=1000

RUN apk --update --no-cache add \
    ca-certificates \
    openssh-client \
    openssl \
    rsync \
    sed \
    gawk \
    curl

RUN rm -rf /var/cache/apk/*

COPY requirements.yml ./
RUN ansible-galaxy install -r requirements.yml

CMD [ "ansible", "--version" ]