#!/bin/sh
set -e

name=$1
namespace=$2

echo running: okteto delete pipeline --name "${name}" ${params} --wait
okteto delete pipeline --name "${name}" ${params} --wait