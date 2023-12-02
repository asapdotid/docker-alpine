ARG ALPINE_VERSION=3.18
FROM alpine:${ALPINE_VERSION}

# Metadata
LABEL maintainer="Asapdotid <asapdotid@gmail.com>"

RUN apk --update --no-cache add \
    ca-certificates \
    openssh \
    bash

RUN echo -e """ \
    \n \
    Host *\n \
    StrictHostKeyChecking no\n \
    UserKnownHostsFile=/dev/null\n \
    LogLevel ERROR\n \
    """ >> /etc/ssh/ssh_config

WORKDIR /app
CMD ["ssh"]
