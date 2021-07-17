#!/bin/bash

CoverageThreshold=50

set -o errexit	# Stop script on first error (non-zero returncode)
set -o pipefail	# Stop script on first error in a piped command (default only checks last pipe-command)
#set -o verbose	# Verbose debugprinting of executing scripts
#set -o xtrace	# Show commands being executed through debugprint during execution

# Change directory to git root folder based on location relative to the currently executing script #
ScriptDirectory="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $ScriptDirectory && cd ..

# Execute build and test (in docker) #
docker run -t --rm \
    --name Avalier.Demo \
    --mount type=bind,source="$(pwd)",target=/app \
    mcr.microsoft.com/dotnet/core/sdk:3.1 \
    /app/bin/test.sh
    #-u $(id -u ${USER}):$(id -g ${USER}) \
