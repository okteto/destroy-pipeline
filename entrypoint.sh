#!/bin/sh
set -e

name=$1
namespace=$2
log_level=$3
destroy_volumes=$4
dependencies=$5

params=""
if [ ! -z $namespace ]; then
params="--namespace=$namespace"
fi

if [ ! -z "$OKTETO_CA_CERT" ]; then
   echo "Custom certificate is provided"
   echo "$OKTETO_CA_CERT" > /usr/local/share/ca-certificates/okteto_ca_cert.crt
   update-ca-certificates
fi

loglevel=""
if [ ! -z "$log_level" ]; then
  loglevel="--log-level ${log_level}"
fi

# https://docs.github.com/en/actions/monitoring-and-troubleshooting-workflows/enabling-debug-logging
# https://docs.github.com/en/actions/learn-github-actions/variables#default-environment-variables
if [ "${RUNNER_DEBUG}" = "1" ]; then
  loglevel="--log-level debug"
fi
params="${params} ${loglevel}"

if [ "$destroy_volumes" = "true" ]; then
  params="${params} -v"
fi

if [ "$dependencies" = "false" ]; then
  params="${params} --dependencies=false"
elif [ "$dependencies" = "true" ]; then
  params="${params} --dependencies"
fi

echo running: okteto pipeline destroy --name "${name}" ${params} --wait
okteto pipeline destroy --name "${name}" ${params} --wait
