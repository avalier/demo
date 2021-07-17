#!/bin/bash
set -o errexit	# Stop script on first error (non-zero returncode)
set -o pipefail	# Stop script on first error in a piped command (default only checks last pipe-command)
#set -o verbose	# Verbose debugprinting of executing scripts
#set -o xtrace	# Show commands being executed through debugprint during execution

# Change directory to git root folder based on location relative to the currently executing script #
ScriptDirectory="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $ScriptDirectory && cd ..

# Build docker image #
rm -rf ./src/Avalier.Demo.Host/bin
rm -rf ./src/Avalier.Demo.Host/obj
rm -rf ./src/Avalier.Demo.Host.Tests/bin
rm -rf ./src/Avalier.Demo.Host.Tests/obj

