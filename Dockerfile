FROM golang:stretch as ecr-helper
RUN go get -u github.com/awslabs/amazon-ecr-credential-helper/ecr-login/cli/docker-credential-ecr-login

FROM gcr.io/kaniko-project/executor:debug-v0.7.0
ENV HOME /root
ENV USER /root
ENV SSL_CERT_DIR=/kaniko/ssl/certs
ENV DOCKER_CONFIG /kaniko/.docker/
COPY --from=ecr-helper /go/bin/docker-credential-ecr-login /kaniko/ecr-login
# add the wrapper which acts as a drone plugin
COPY plugin.sh /kaniko/plugin.sh
ENTRYPOINT [ "/kaniko/plugin.sh" ]
