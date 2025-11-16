ARG GO_VERSION=golang:1.24.0-alpine
ARG ALPINE_VERSION=alpine@sha256:4b7ce07002c69e8f3d704a9c5d6fd3053be500b7f1c69fc0d80990c2ad8dd412

FROM scratch AS legal

WORKDIR /project/
COPY --link [ "./LICENSE","./" ]

FROM ${GO_VERSION} AS test

WORKDIR /project/
COPY [ "./", "./" ]

ENTRYPOINT [ "go", "test" ]
CMD [ "./..." ]

FROM ${GO_VERSION} AS build-proxy

WORKDIR /project/
COPY --link --from=legal [ "./", "./" ]
COPY --exclude="./examples" [ "./", "./" ]

RUN apk add --no-cache git \
    && go build \
    && apk del git \
    && rm -rf /go/src

ENTRYPOINT [ "/project/grpc-proxy" ]

FROM ${ALPINE_VERSION} AS run-proxy

WORKDIR /project/
COPY --link --from=legal [ "./", "./" ]
COPY --link --from=build-proxy [ "/project/grpc-proxy", "./" ]

EXPOSE 50051
ENTRYPOINT [ "/project/grpc-proxy" ]

FROM run-proxy AS run-example-proxy

WORKDIR /project/insecure-microservice-node/
COPY [ "./examples/insecure-microservice-node/hello.proto", "./" ]

WORKDIR /project/secure-microservice-node/
COPY [ "./examples/secure-microservice-node/hello.proto", "./" ]

WORKDIR /project/
COPY --link [ "./examples/run-proxies.sh", "./" ]

EXPOSE 50051 50052
ENTRYPOINT [ "/project/run-proxies.sh" ]
