#!/bin/bash
set -o errexit	# Stop script on first error (non-zero returncode)
set -o pipefail	# Stop script on first error in a piped command (default only checks last pipe-command)
#set -o verbose	# Verbose debugprinting of executing scripts
#set -o xtrace	# Show commands being executed through debugprint during execution

# Change directory to src folder based on location relative to the currently executing script #
ScriptLocation="$(realpath "${BASH_SOURCE[0]}")"
ScriptDirectory="$(dirname "${ScriptLocation}")"
cd $ScriptDirectory && cd ../src

# Restore dependencies #
dotnet restore

# Build the application #
dotnet build Avalier.Demo.sln
