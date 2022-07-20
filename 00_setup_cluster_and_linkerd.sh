#!/bin/bash

function die_on_failure {
  "$@"
  local status=$?
  if ((status != 0)); then
    echo "error with $1" >&2
    exit 1
  fi
  return $status
}

# Variables
MK_PROFILE_NAME="${MK_PROFILE_NAME:-linkerd}"

# Create a minikube cluster & select it as default profile
minikube start \
  --memory=8g \
  --cpus=4 \
  --profile "$MK_PROFILE_NAME"
minikube profile "$MK_PROFILE_NAME"

# Run linkerd pre-checks
die_on_failure linkerd check --pre

# Install linkerd
linkerd install --set proxyInit.runAsRoot=true |
  kubectl apply --filename -

# Check & wait for the linkerd install
die_on_failure linkerd check

# Install the on-cluster metrics stack
linkerd viz install |
  kubectl apply --filename -

# Check & wait for viz to be ready
die_on_failure linkerd viz check

# Install the emojivoto demo app with injected linkerd
linkerd inject https://run.linkerd.io/emojivoto.yml |
  kubectl apply --filename -

# Check & wait for proxy/sidecars in ns emojivoto
die_on_failure linkerd check --proxy --namespace emojivoto

# Final check
die_on_failure linkerd check

# Make the app & dashboard available
./10_run_dashboard_and_app.sh
