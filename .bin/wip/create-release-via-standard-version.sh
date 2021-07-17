#!/bin/bash
set -o errexit	# Stop script on first error (non-zero returncode)
set -o pipefail	# Stop script on first error in a piped command (default only checks last pipe-command)
#set -o verbose	# Verbose debugprinting of executing scripts
#set -o xtrace	# Show commands being executed through debugprint during execution

# Change directory to git root folder based on location relative to the currently executing script #
ScriptLocation="$(realpath "${BASH_SOURCE[0]}")"
ScriptDirectory="$(dirname "${ScriptLocation}")"
cd $ScriptDirectory && cd ..

# Create a new release #
#npx standard-version --releaseCommitMessageFormat "chore(release): {{currentTag}} [ci skip]"
npx standard-version
git push --follow-tags origin HEAD:$(git rev-parse --abbrev-ref HEAD) --verbose

