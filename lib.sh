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

function print_line {
  printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
}

function print_exec_cmd {
  print_line
  echo "$ $1"
  print_line
  eval "$1"
}
