#!/bin/bash
#set -o errexit	# Stop script on first error (non-zero returncode)
#set -o pipefail	# Stop script on first error in a piped command (default only checks last pipe-command)
#set -o verbose	# Verbose debugprinting of executing scripts
#set -o xtrace	# Show commands being executed through debugprint during execution

# Reference: Veracode Agent-Based Scan Software Composition Analysis
# https://help.veracode.com/reader/hHHR3gv0wYc2WbCclECf_A/~ZeqAeXol6KqC8tDUO5XtA

# Change directory to git root folder based on location relative to the currently executing script #
ScriptDirectory="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $ScriptDirectory && cd ..

# Get src folder name (and default if unavailable) #
SrcFolder=$1
if [ -z $SrcFolder ]
then
    SrcFolder=./src
    echo No source folder argument was specified \(defaulting to $SrcFolder\)
fi

# Get veracode api token (and error if unavailable) #
if [ -z $VERACODE_API_TOKEN ]
then
    echo "$(tput setaf 1)SCA scan failed (missing environment variable VERACODE_API_TOKEN)$(tput sgr0)" >&2
    exit 1
fi
export SRCCLR_API_TOKEN=$VERACODE_API_TOKEN
export SRCCLR_SKIP_DOTNET_RESTORE=true

# Scan Src #
echo Scanning $SrcFolder relative to $(pwd)...
curl -sSL https://download.sourceclear.com/ci.sh | sh -s scan --no-upload $SrcFolder --json=./.out/scan-sca-veracode.json

# If scan failed, exit with code 1 #
EXIT_CODE=$?
if [ $EXIT_CODE != 0 ]
then
    echo "$(tput setaf 1)SCA scan failed with errors (exit code: $EXIT_CODE)$(tput sgr0)" >&2
    exit $EXIT_CODE
fi
    