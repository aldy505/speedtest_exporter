FROM golang:1.19.0-alpine3.16 AS builder

WORKDIR /app

COPY . .

RUN go build -o speedtest_exporter cmd/speedtest_exporter/main.go

FROM alpine:3.16 AS runtime

WORKDIR /app

COPY --from=builder /app/speedtest_exporter /app/speedtest_exporter

EXPOSE 9090

ENTRYPOINT [ "/app/speedtest_exporter" ]