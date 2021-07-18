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
mkdir -p $(pwd)/.out/coverage/html

# Run unit tests and code coverage (and fail if code coverage threshold is not met) #
set +e
dotnet dotcover test $SolutionFile \
    --dcReportType=DetailedXML \
    --dcOutput=$(pwd)/.out/coverage/dotCover.Output.xml \
    --dcHideAutoProperties \
    --dcFilters=-:Avalier.Demo.**.Tests \
    --dcAttributeFilters="System.Diagnostics.CodeAnalysis.ExcludeFromCodeCoverageAttribute"
CoverageExitCode=$?
set -e

# Extract Coverage #
PWD=$(pwd)
CoveragePercentage=$(cat $PWD/.out/coverage/dotCover.Output.xml | grep "<Root" | grep -Po '(?<=CoveragePercent=\")(.*?)(?=\")')
echo  "Coverage: $CoveragePercentage%"

# Create coverage report #
#reportgenerator -reports:.out/coverage/dotCover.Output.xml -targetdir:.out/coverage/html

# Fail if coverage is insufficient) #
if [ $CoveragePercentage -lt $CoverageThreshold ]
then
    echo "$(tput setaf 1)Failed. The coverage ($CoveragePercentage%) was below the specified threshold ($CoverageThreshold%)$(tput sgr0)" >&2
    exit 1
fi
