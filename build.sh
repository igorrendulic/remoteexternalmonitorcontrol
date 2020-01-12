#!/bin/bash

DDCCTLBUILD=$1
if [ -z "$1" ]
  then
    echo "Please supply one of the arguments. Example (./build.sh intel or ./build.sh nvidia or ./build.sh amd)"
    exit 1;
fi

cd server
make build
cd ../ddcctl
make intel
