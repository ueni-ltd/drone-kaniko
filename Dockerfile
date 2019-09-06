FROM golang:stretch as ecr-helper
RUN go get -u github.com/awslabs/amazon-ecr-credential-helper/ecr-login/cli/docker-credential-ecr-login

FROM banzaicloud/drone-kaniko
COPY config.json /kaniko/.docker/config.json
COPY --from=ecr-helper /go/bin/docker-credential-ecr-login /kaniko/ecr-login
