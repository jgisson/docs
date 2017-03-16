#!/bin/bash

if [ $# -eq 0 ]
then 
    echo "Usage: $0 param1"
    echo " * param1: SCM branch (mandatory)"
    exit 1
fi

echo "Switch to branch $1"

PROJECTS_HOME="/d/dev/git"

PROJECT_NAME[0]="ms-registry"
PROJECT_NAME[1]="ms-gateway"
PROJECT_NAME[2]="ms-documents"
PROJECT_NAME[3]="ms-processes"

for project in "${PROJECT_NAME[@]}"
do
   : 
   # do whatever on $project
   echo "Switch project $project ..."
   cd $PROJECTS_HOME/$project
   git fetch origin
   git checkout $1
   git rebase origin/$1
   echo "Switch project $project done."
   echo ""
done
