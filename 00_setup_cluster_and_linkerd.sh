#!/bin/bash
. ./lib.sh

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

# Install Linkerd CRDs
linkerd install --crds |
  kubectl apply --filename -

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

# Final check
die_on_failure linkerd check

# Return the information about our minikube cluster
minikube profile
