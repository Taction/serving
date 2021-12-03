FROM golang:latest AS golang
ENV GOPROXY=https://goproxy.cn,direct
RUN CGO_ENABLED=0 go get -ldflags '-s -w -extldflags -static' github.com/go-delve/delve/cmd/dlv


#FROM gcr.oneitfarm.com/distroless/static:noroot
FROM ubuntu:latest
ARG BIN
WORKDIR /

COPY bin/${BIN} /execbin
COPY --from=golang /go/bin/dlv /

CMD ["/dlv", "--listen=:2345", "--headless=true", "--api-version=2", "--accept-multiclient", "exec", "/execbin"]