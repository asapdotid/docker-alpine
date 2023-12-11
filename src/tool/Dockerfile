ARG ALPINE_VERSION=3.19
FROM alpine:${ALPINE_VERSION}

# Metadata
LABEL maintainer="Asapdotid <asapdotid@gmail.com>"

RUN apk --no-cache --update add \
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
    tzdata \
    ## Build dependecies
    && apk --no-cache add --virtual .build-deps \
    python3-dev \
    libffi-dev \
    openssl-dev \
    build-base \
    ## Create and activate virtualenv:
    && python3 -m venv /opt/venv

# Make sure we use the virtualenv:
ENV PATH "/opt/venv/bin:$PATH"

RUN apk del .build-deps \
    && rm -rf /var/cache/apk/* \
    && rm -rf /root/.cache/pip

# Timezone
ARG TIMEZONE=Asia/Jakarta
ENV TZ ${TIMEZONE}
RUN ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime && echo ${TZ} >/etc/timezone

RUN printf """\
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
