# grpc-proxy examples

Examples on how to use the gRPC proxy service.

- Start the backends (microservices)

  ```bash
  cd secure-microservice-node
  npm i
  node .
  ```

  ```bash
  cd insecure-microservice-node
  npm i
  node .
  ```

- Start the proxies. We have two: an insecure proxy on port `50051`,
  and a secure proxy on port `50052`.

  From the examples folder run the following commands, each in their own terminal:

  ```shell
  grpc-proxy config-insecure-proxy.json
  ```

  ```shell
  grpc-proxy config-secure-proxy.json
  ```

- Test with the client

  ```shell
  cd client-node
  npm i
  node .
  ```

## Why are the microservices in Node?

I had them at hand ready to use. Send me a PR with examples in Go.
They should be easy to implement, and I'll be happy to merge them.
