const caller = require('grpc-caller');
const grpc = require('grpc');
const fs = require('node:fs');

const cert = fs.readFileSync('../ssl/localhost.pem');
const sslCreds = grpc.credentials.createSsl(cert);

const clients = {
  'withInsecureProxy': {
    'insecureMicroservice': caller('example-proxy:50051', '../insecure-microservice-node/hello.proto', 'Greeter'),
    'secureMicroservice': caller('example-proxy:50051', '../secure-microservice-node/hello.proto', 'Greeter'),
  },
  'withSecureProxy': {
    'insecureMicroservice': caller('example-proxy:50052', '../insecure-microservice-node/hello.proto', 'Greeter', sslCreds),
    'secureMicroservice': caller('example-proxy:50052', '../secure-microservice-node/hello.proto', 'Greeter', sslCreds),
  },
};

Promise.all([
  clients.withInsecureProxy.insecureMicroservice.sayHello({'name': 'Lionel'}),
  clients.withInsecureProxy.secureMicroservice.sayHello({'name': 'Messi'}),
  clients.withSecureProxy.insecureMicroservice.sayHello({'name': 'Juan'}),
  clients.withSecureProxy.secureMicroservice.sayHello({'name': 'Perez'}),
]).then((results) => {
  console.log(results);
}).catch((e) => {
  console.log(e);
});
