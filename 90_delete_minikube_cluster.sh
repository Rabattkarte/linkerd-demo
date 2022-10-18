#!/bin/bash

# Variables
MK_PROFILE_NAME="${MK_PROFILE_NAME:-linkerd}"

# Ask the user for confirmation prior to deletion
read -p "Do you want to delete the minikube cluster '$MK_PROFILE_NAME'? [Yy|Nn]: " -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
  # Delete the minikube cluster and all resources in it
  minikube delete -p "$MK_PROFILE_NAME"
  # Return the information about our local minikube profiles
  minikube profile list
else
  echo "Will do nothing."
fi
