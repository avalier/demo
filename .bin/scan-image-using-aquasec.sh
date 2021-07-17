#!/bin/bash
#set -o errexit	# Stop script on first error (non-zero returncode)
#set -o pipefail	# Stop script on first error in a piped command (default only checks last pipe-command)
#set -o verbose	# Verbose debugprinting of executing scripts
#set -o xtrace	# Show commands being executed through debugprint during execution

ImageName=$1
if [ -z $ImageName ]
then
    echo "$(tput setaf 1)Docker image scan failed (missing image name argument scan-image-using-aquasec.sh <<ImageName>>)$(tput sgr0)" >&2
    exit 1
fi

echo Scanning $ImageName

# Change directory to git root folder based on location relative to the currently executing script #
ScriptLocation="$(realpath "${BASH_SOURCE[0]}")"
ScriptDirectory="$(dirname "${ScriptLocation}")"
cd $ScriptDirectory && cd ..

# Get the docker image #
docker pull docker.io/aquasec/trivy

# Scan the docker image #
docker run --rm \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v $(pwd)/.cache:/root/.cache/ \
    docker.io/aquasec/trivy --exit-code 1 --severity HIGH,CRITICAL $ImageName

# If scan failed, exit with code 1 #
EXIT_CODE=$?
if [ $EXIT_CODE != 0 ]
then
    echo "$(tput setaf 1)Docker image scan failed$(tput sgr0)" >&2
    exit $EXIT_CODE
fi
    