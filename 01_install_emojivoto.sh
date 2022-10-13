#!/bin/bash
. ./lib.sh

# Install the bare emojivoto demo app
command="kubectl apply --filename ./emojivoto.yaml"
print_exec_cmd "$command"

for command in \
  "kubectl get deployments --namespace emojivoto" \
  "kubectl get pods --namespace emojivoto" \
  "kubectl get services --namespace emojivoto"; do
  print_exec_cmd "$command"
done
