#!/bin/bash

DEVOPS_NAME=avalier
PROJECT=$1

if [ -z $PROJECT ]
then
    echo "Usage: $0 <<Project>>"
    exit 0
fi

echo "DEVOPS_NAME: $DEVOPS_NAME"
echo "Project: $PROJECT"

# Change directory to git root folder based on location relative to the currently executing script #
ScriptLocation="$(realpath "${BASH_SOURCE[0]}")"
ScriptDirectory="$(dirname "${ScriptLocation}")"
cd $ScriptDirectory && cd .. && cd ..

# Create and push git repository #
git init
git add .
git commit -a -m 'Initial commit'
az repos create --name Avalier.Demo7 --project $PROJECT
git remote add origin "$DEVOPS_NAME@vs-ssh.visualstudio.com:v3/$DEVOPS_NAME/$PROJECT/Avalier.Demo7"
git push -u origin --all
