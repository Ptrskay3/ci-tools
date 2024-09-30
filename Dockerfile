FROM golang:1.23.1-alpine3.20

RUN apk add --update git

RUN go install github.com/davidrjonas/semver-cli@latest

ARG BASH_VERSION="5.2.26-r0"
ARG DOCKER_CLI_VERSION="0.14.0-r3"
ARG GIT_VERSION="2.45.2-r0"
ARG CURL_VERSION="8.9.1-r2"
ARG MAKE_VERSION="4.4.1-r2"

ARG KUBECTL_VERSION="v1.31.1"
ARG HELM_VERSION="v3.16.1"

RUN apk --no-cache upgrade
RUN apk --no-cache add bash=${BASH_VERSION} \
            openssh-client \
            alpine-sdk \
            ca-certificates \
            jq \
            curl=${CURL_VERSION} \
            docker-cli-buildx=${DOCKER_CLI_VERSION} \
            git=${GIT_VERSION} \
            make=${MAKE_VERSION} \
            yq-go \
            python3

RUN curl https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl --output /bin/kubectl \ 
    && chmod u+x /bin/kubectl

RUN curl https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz  --output - | \
    tar -xzf - -C /tmp/ \
    && mv /tmp/linux-amd64/helm /bin/ \
    && chmod +x /bin/helm \
    && rm -rf /tmp/linux-amd64

ENTRYPOINT [ "/bin/bash", "-c" ]
CMD [ "bash" ]
