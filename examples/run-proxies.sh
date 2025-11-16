#!/bin/sh

/project/grpc-proxy /project/config-insecure-proxy.json &
/project/grpc-proxy /project/config-secure-proxy.json
