#!/bin/sh
set -e

name=$1
namespace=$2
log_level=$3

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
  if [ "$log_level" = "debug" ] || [ "$log_level" = "info" ] || [ "$log_level" = "warn" ] || [ "$log_level" = "error" ] ; then
    log_level="--log-level ${log_level}"
  else
    echo "log-level supported: debug, info, warn, error"
    exit 1
  fi
fi

# https://docs.github.com/en/actions/monitoring-and-troubleshooting-workflows/enabling-debug-logging
# https://docs.github.com/en/actions/learn-github-actions/variables#default-environment-variables
if [ "${RUNNER_DEBUG}" = "1" ]; then
  log_level="--log-level debug"
fi


echo running: okteto pipeline destroy $log_level --name "${name}" ${params} --wait
okteto pipeline destroy $log_level --name "${name}" ${params} --wait
