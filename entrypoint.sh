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

if [ ! -z "$log_level" ]; then
  log_level="--log-level ${log_level}"
fi

# https://docs.github.com/en/actions/monitoring-and-troubleshooting-workflows/enabling-debug-logging
# https://docs.github.com/en/actions/learn-github-actions/variables#default-environment-variables
if [ "${RUNNER_DEBUG}" = "1" ]; then
  log_level="--log-level debug"
fi

if [ "$destroy_volumes" = "true" ]; then
  volume_flag="-v"
fi

if [ "$dependencies" = "true" ]; then
  dependencies_flag="--dependencies"
else
  dependencies_flag="--dependencies=false"
fi

echo running: okteto pipeline destroy $log_level --name "${name}" ${params} $volume_flag $dependencies_flag --wait
okteto pipeline destroy $log_level --name "${name}" ${params} $volume_flag $dependencies_flag --wait
