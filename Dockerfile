FROM golang:1.13.3 AS builder

# Change this to a git tag if you wish
ENV git_tag=master

WORKDIR /build
RUN apt-get update -q && \
    apt-get install -y git && \
    git clone --depth=1 --single-branch --branch ${git_tag} https://github.com/sensu/sensu-go.git

RUN cd sensu-go && \
    mkdir ../bin && \
    cp docker-scripts/sensu-entrypoint.sh ../bin/ && \
    go build -ldflags "-X "github.com/sensu/sensu-go/version.Version=${git_tag}" -X "github.com/sensu/sensu-go/version.BuildDate=$(date +"%y-%m-%d")" -X "github.com/sensu/sensu-go/version.BuildSHA=$(git rev-parse HEAD)"" -o ../bin/sensu-agent ./cmd/sensu-agent && \
    go build -ldflags "-X "github.com/sensu/sensu-go/version.Version=${git_tag}" -X "github.com/sensu/sensu-go/version.BuildDate=$(date +"%y-%m-%d")" -X "github.com/sensu/sensu-go/version.BuildSHA=$(git rev-parse HEAD)"" -o ../bin/sensu-backend ./cmd/sensu-backend && \
    go build -ldflags "-X "github.com/sensu/sensu-go/version.Version=${git_tag}" -X "github.com/sensu/sensu-go/version.BuildDate=$(date +"%y-%m-%d")" -X "github.com/sensu/sensu-go/version.BuildSHA=$(git rev-parse HEAD)"" -o ../bin/sensuctl ./cmd/sensuctl

FROM ubuntu:18.04

WORKDIR /opt/sensu
COPY --from=builder /build/bin /opt/sensu/bin/

#State directory lives outside container for persistent data.
VOLUME [/var/lib/sensu]
#Port 3000 for Sensu Go UI, 8080 for Sensu API, and port 8081 for sensu-agent websocket API communication.
EXPOSE 3000 8080 8081

#Run the container passing the binary and args to the container (ie. sudo docker run -d <new_image> sensu-backend init), see README.md for more examples.
#Use Docker logs to see stdout of process passed (ie. sudo docker logs --details -f  `docker ps -q` ).
CMD ["/opt/sensu/bin/sensu-entrypoint.sh"]
