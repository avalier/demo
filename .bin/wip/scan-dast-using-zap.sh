#!/bin/bash
#set -o errexit	# Stop script on first error (non-zero returncode)
#set -o pipefail	# Stop script on first error in a piped command (default only checks last pipe-command)
#set -o verbose	# Verbose debugprinting of executing scripts
#set -o xtrace	# Show commands being executed through debugprint during execution

# https://www.zaproxy.org/docs/docker/



# Change directory to git root folder based on location relative to the currently executing script #
ScriptDirectory="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $ScriptDirectory && cd ..

TargetEndpoint=$1

if [ -z $TargetEndpoint]
then
    TargetIpAddress=$(ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p')
    echo IP Address: $TargetIpAddress
    TargetEndpoint=http://$TargetIpAddress:5000
fi

echo Scanning $TargetEndpoint

docker run --rm -t owasp/zap2docker-weekly zap-baseline.py -t $TargetEndpoint

# If scan failed, exit with code 1 #
EXIT_CODE=$?
if [ $EXIT_CODE != 0 ] && [ $EXIT_CODE != 2 ]
then
    if [ $EXIT_CODE == 1 ]
    then
        echo "$(tput setaf 1)DAST failed with errors (exit code: $EXIT_CODE)$(tput sgr0)" >&2
    elif [ $EXIT_CODE == 2 ]
    then
        echo "$(tput setaf 1)DAST failed with warnings (exit code: $EXIT_CODE)$(tput sgr0)" >&2
    else
        echo "$(tput setaf 1)DAST failed (exit code: $EXIT_CODE)$(tput sgr0)" >&2
    fi
    exit $EXIT_CODE
fi
    