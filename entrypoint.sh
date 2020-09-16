#!/bin/sh
set -e

name=$1
namespace=$2

params=""
if [ ! -z $namespace ]; then
params="--namespace=$namespace"
fi

echo running: okteto pipeline destroy --name "${name}" ${params} --wait
okteto pipeline destroy --name "${name}" ${params} --wait