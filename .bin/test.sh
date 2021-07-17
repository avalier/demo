#!/bin/bash

# Change directory to git root folder based on location relative to the currently executing script #
ScriptDirectory="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $ScriptDirectory && cd ..

CoverageThreshold=$1
if [ -z $CoverageThreshold ]
then
   echo "$(tput setaf 1)Failed. Usage: $0 <<CoverageThreshold>> <<SolutionFile>>" >&2
   exit 1
fi

SolutionFile=$2
if [ -z $SolutionFile ]
then
    echo "$(tput setaf 1)Failed. Usage: $0 <<CoverageThreshold>> <<SolutionFile>>" >&2
    exit 1
fi

# Make sure output folder exists #
mkdir -p ./.out/coverage/html

# Run unit tests and code coverage (and fail if code coverage threshold is not met) #
set +e
dotnet test $SolutionFile \
    /p:CollectCoverage=true \
    /p:CoverletOutputFormat=\"opencover,cobertura\" \
    /p:CoverletOutput=$(pwd)/.out/coverage/ \
    /p:Threshold=$CoverageThreshold \
    /p:UseSourceLink=true
CoverageExitCode=$?
set -e

# Create coverage report #
reportgenerator -reports:.out/coverage/coverage.cobertura.xml -targetdir:.out/coverage/html

# Fail if coverage is insufficient) #
if [ $CoverageExitCode != 0 ]
then
    echo "$(tput setaf 1)Failed. The minimum line coverage is below the specified threshold of $CoverageThreshold%$(tput sgr0)" >&2
    exit $CoverageExitCode
fi
