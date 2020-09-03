#!/bin/sh
set -e

name=$1
namespace=$2

params=""
if [ ! -z $namespace ]; then
params="--namespace=$namespace"
fi

echo running: okteto delete pipeline --name "${name}" ${params} --wait
okteto delete pipeline --name "${name}" ${params} --wait