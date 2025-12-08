FROM registry.gregdev.dev/docker-hub/golang:1.25.5 AS development

WORKDIR /go/src/app

## Download modules and store, this optimizes use of Docker image cache
COPY go.mod .
COPY go.sum .
RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags="-s -w" -o /mosquitto-exporter ./*.go
RUN chmod a+x /mosquitto-exporter

FROM registry.gregdev.dev/docker-hub/alpine:3.23.0 AS app

USER 1234:1234

COPY --from=development /mosquitto-exporter /mosquitto-exporter

EXPOSE 9234

ENTRYPOINT [ "/mosquitto-exporter" ]
