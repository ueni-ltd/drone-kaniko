FROM golang:stretch as ecr-helper
RUN go get -u github.com/awslabs/amazon-ecr-credential-helper/ecr-login/cli/docker-credential-ecr-login

FROM gcr.io/kaniko-project/executor:debug-v0.16.0
ENV HOME /root
ENV USER root
ENV SSL_CERT_DIR=/kaniko/ssl/certs
ENV DOCKER_CONFIG /kaniko/.docker/

COPY config.json /kaniko/.docker/config.json
COPY --from=ecr-helper /go/bin/docker-credential-ecr-login /kaniko/ecr-login

COPY --from=amd64/busybox:1.31.0 /bin/busybox /busybox/busybox

# add the wrapper which acts as a drone plugin
COPY plugin.sh /kaniko/plugin.sh
COPY ueni-entrypoint.sh /kaniko/ueni-entrypoint.sh

ENTRYPOINT [ "/kaniko/ueni-entrypoint.sh" ]
