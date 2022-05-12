#!/bin/sh
set -e

name=$1
namespace=$2

params=""
if [ ! -z $namespace ]; then
params="--namespace=$namespace"
fi

if [ ! -z "$OKTETO_CA_CERT" ]; then
   echo "Custom certificate is provided"
   echo "$OKTETO_CA_CERT" > /usr/local/share/ca-certificates/okteto_ca_cert.crt
   update-ca-certificates
fi

echo running: okteto pipeline destroy --name "${name}" ${params} --wait
okteto pipeline destroy --name "${name}" ${params} --wait
