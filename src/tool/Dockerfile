ARG ALPINE_VERSION=3.18
FROM alpine:${ALPINE_VERSION}

# Metadata
LABEL maintainer="Asapdotid <asapdotid@gmail.com>"

RUN apk --update --no-cache add \
    ca-certificates \
    bash \
    git \
    openssh-client \
    openssl \
    python3\
    sshpass \
    perl-mime-base64 \
    sed \
    gawk \
    curl \
    yq \
    tzdata

RUN apk --update add --virtual .build-deps \
    python3-dev \
    libffi-dev \
    openssl-dev \
    build-base

RUN python3 -m venv /opt/venv
# Make sure we use the virtualenv:
ENV PATH "/opt/venv/bin:$PATH"

RUN apk del .build-deps && \
    rm -rf /var/cache/apk/* && \
    rm -rf /root/.cache/pip

# Timezone
ENV TZ ${TIMEZONE}
RUN ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime && echo ${TZ} >/etc/timezone

RUN echo -e """\
    \n\
    Host *\n\
    StrictHostKeyChecking no\n\
    UserKnownHostsFile=/dev/null\n\
    LogLevel ERROR\n\
    """ >> /etc/ssh/ssh_config

COPY src/tool/entrypoint.sh /
RUN ["chmod", "+x", "/entrypoint.sh"]

WORKDIR /app
ENTRYPOINT ["/entrypoint.sh"]
