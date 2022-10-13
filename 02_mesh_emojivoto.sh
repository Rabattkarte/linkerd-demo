#!/bin/bash
. ./lib.sh

# Install the emojivoto demo app with injected linkerd
command="linkerd inject ./emojivoto.yaml | kubectl apply --filename -"
print_exec_cmd "$command"

# Check & wait for proxy/sidecars in ns emojivoto

print_line
echo -n "Checking the linkerd injection ... "
if die_on_failure linkerd check --proxy --namespace emojivoto &>/dev/null; then
  echo "SUCCESS!"
  else
  echo "FAILURE!"
fi
