#!/bin/bash

# Expose the emojivoto app and forward the viz dashboard
kubectl port-forward svc/web-svc 8080:80 --namespace emojivoto &>/dev/null &
printf "Emojivoto available at\nhttp://localhost:8080\n"
linkerd viz dashboard --show url

# Find our processes like this: `ps -ef | grep -E "(linkerd.*viz|kubectl.*port-forward)"`
