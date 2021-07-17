#!/bin/bash
#set -o errexit	# Stop script on first error (non-zero returncode)
#set -o pipefail	# Stop script on first error in a piped command (default only checks last pipe-command)
#set -o verbose	# Verbose debugprinting of executing scripts
#set -o xtrace	# Show commands being executed through debugprint during execution

# Get image name (and error if unavailable) #
ImageName=$1
if [ -z $ImageName ]
then
    echo "$(tput setaf 1)Docker image scan failed (missing image name argument scan-image-using-veracode.sh <<ImageName>>)$(tput sgr0)" >&2
    exit 1
fi

# Get veracode api token (and error if unavailable) #
if [ -z $VERACODE_API_TOKEN ]
then
    echo "$(tput setaf 1)Docker image scan failed (missing environment variable VERACODE_API_TOKEN)$(tput sgr0)" >&2
    exit 1
fi
export SRCCLR_API_TOKEN=$VERACODE_API_TOKEN

# Scan Image #
echo Scanning $ImageName...
curl -sSL https://download.sourceclear.com/ci.sh | sh -s scan --image $ImageName

# If scan failed, exit with code 1 #
EXIT_CODE=$?
if [ $EXIT_CODE != 0 ]
then
    echo "$(tput setaf 1)Docker image scan failed$(tput sgr0)" >&2
    exit $EXIT_CODE
fi
    