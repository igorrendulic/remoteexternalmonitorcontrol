#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
${DIR}/server/bin/monitorcontrol -path ${DIR}/ddcctl/ddcctl


