#!/usr/bin/env bash

# Standard build tools boilerplate
script_args=$@
script_path=$(dirname $0)
working_dir=$(pwd)
cd "$script_path"
cd ../../..
repo_root=$(pwd)

source "$repo_root/.build.env"

set -e

# Declare proper usage
usage () {
  cat << EOF

usage:
   run-test.sh [OPTIONS]
   run-test.sh -h

OPTIONS:
   -h,--help              : show this message
   -d,--debug             : enable debugging output
   -a|--all               : run all the tests
   -s,--standards         : run coding standards tests only
   -u,--unit              : run unit tests only
   -b,--behat             : run behat tests only

EOF
}

# Set up variables
script_path=$(dirname $0)
debug=0
standards=0
unit=0
behat=0


# Parse command line options
short=hdasub
long=help,debug,all,standards,unit,behat
args=$(getopt --options $short --longoptions $long --name "$0" -- "$@")

if [ $? -ne 0 ]; then
  usage
  exit 5
fi

eval set -- "$args"

while true; do
  case "$1" in
    -h|--help) usage; exit ;;
    -d|--debug) debug=1; shift ;;
    -s|--standards) standards=1; shift ;;
    -u|--unit) unit=1; shift ;;
    -b|--behat) behat=1; shift ;;
    -a|--all) standards=1; unit=1; behat=1; shift ;;
    --) shift; break ;;
    *) usage; exit 6 ;;
  esac
done


# Check parameters

if [ "$standards" -eq 1 ]; then
  "$repo_root/scripts/make/test/code-standards.sh"
  if [ $? != 0 ]; then
    exit $?
  fi
fi

if [ "$unit" -eq 1 ]; then
  "$repo_root/scripts/make/test/unit.sh"
  if [ $? != 0 ]; then
    exit $?
  fi
fi

if [ "$behat" -eq 1 ]; then
  "$repo_root/scripts/make/test/behat.sh"
  if [ $? != 0 ]; then
    exit $?
  fi
fi
