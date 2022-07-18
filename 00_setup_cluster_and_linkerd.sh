#!/bin/bash
set -x

# Check for all necessary tools
function check_tools {
  for tool in "$@"; do
    if ! command -v "$tool" &>/dev/null; then
      printf "'%s' could not be found. Aborting.\n" "$tool"
      exit
    fi
  done
}

function die_on_failure {
  "$@"
  local status=$?
  if ((status != 0)); then
    echo "error with $1" >&2
    exit 1
  fi
  return $status
}

check_tools minikube linkerd

# Variables
MK_PROFILE_NAME="${MK_PROFILE_NAME:-linkerd}"

# Create a minikube cluster & select it as default profile
minikube start --memory=8g --cpus=4 --profile "$MK_PROFILE_NAME"
minikube profile "$MK_PROFILE_NAME"

# Run linkerd pre-checks
die_on_failure linkerd check --pre

# Install linkerd
linkerd install | kubectl apply -f -

# Checking the linkerd install
die_on_failure linkerd check

# Now install our emojivoto demo app
curl --proto '=https' --tlsv1.2 -sSfL https://run.linkerd.io/emojivoto.yml |
  kubectl apply -f -

# Inject linkerd to all emojivoto deployments
kubectl get -n emojivoto deploy -o yaml |
  linkerd inject - |
  kubectl apply -f -

# Let's check the proxy/sidecars
die_on_failure linkerd check --proxy -n emojivoto

# install the on-cluster metrics stack
linkerd viz install | kubectl apply -f -

die_on_failure linkerd check

# Forward the viz dashboard
linkerd viz dashboard &

# Expose the web app
kubectl -n emojivoto port-forward svc/web-svc 8080:80 &
