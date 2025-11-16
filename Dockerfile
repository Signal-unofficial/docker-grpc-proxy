ARG GO_VERSION=golang:1.24.0-alpine
ARG ALPINE_VERSION=alpine@sha256:4b7ce07002c69e8f3d704a9c5d6fd3053be500b7f1c69fc0d80990c2ad8dd412

FROM ${GO_VERSION} AS build

WORKDIR /project/
COPY --link [ "./LICENSE", "./" ]
COPY [ "./", "./" ]

RUN apk add --no-cache git \
    && go build \
    && apk del git \
    && rm -rf /go/src

ENTRYPOINT [ "/project/grpc-proxy" ]

FROM ${ALPINE_VERSION} AS run

WORKDIR /project/
COPY --from=build [ "/project/grpc-proxy", "./" ]

ENTRYPOINT [ "/project/grpc-proxy" ]
