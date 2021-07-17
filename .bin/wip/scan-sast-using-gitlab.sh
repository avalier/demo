#!/bin/bash
#set -o errexit	# Stop script on first error (non-zero returncode)
#set -o pipefail	# Stop script on first error in a piped command (default only checks last pipe-command)
#set -o verbose	# Verbose debugprinting of executing scripts
#set -o xtrace	# Show commands being executed through debugprint during execution

# Change directory to git root folder based on location relative to the currently executing script #
ScriptDirectory="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $ScriptDirectory && cd ..


docker run -t \
  --env SOURCE_CODE="$ScriptDirectory/src" \
  --volume "$ScriptDirectory/src":/code \
  --volume /var/run/docker.sock:/var/run/docker.sock \
  registry.gitlab.com/gitlab-org/ci-cd/codequality:latest /code

# If scan failed, exit with code 1 #
EXIT_CODE=$?
if [ $EXIT_CODE != 0 ]
then
    echo "$(tput setaf 1)Docker image scan failed$(tput sgr0)" >&2
    exit $EXIT_CODE
fi
    