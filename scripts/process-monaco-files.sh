#!/bin/bash

RUN_TYPE=$1
SERVICE=$2
OWNER_EMAIL=$3

if [ -z $RUN_TYPE ]; then
    echo "RUN_TYPE is required argument"
    exit 1
fi
if [ -z $SERVICE ]; then
    echo "SERVICE is required argument"
    exit 1
fi

echo "Processing Monaco files for service = $SERVICE RUN_TYPE = $RUN_TYPE"

if [[ "$RUN_TYPE" == "create" ]]; then

    if [ -z $OWNER_EMAIL ]; then
        echo "OWNER_EMAIL is required argument"
        exit 1
    fi
    echo "Removing old project folder"
    rm -rf ./monaco/projects/$SERVICE

    echo "Cloning project template"
    mkdir -p ./monaco/projects
    cp -rf ./monaco/template ./monaco/projects/$SERVICE
    ls -l ./monaco/projects/$SERVICE

    echo "Update placeholders"
    if [[ "$(uname)" == "Darwin" ]]; then
        # MacOS require -i ''
        sed -i '' -e 's~{{ .Env.SERVICE_NAME }}~'"$SERVICE"'~' \
            ./monaco/projects/$SERVICE/dashboard/dashboard.yaml
        sed -i '' -e 's~{{ .Env.SERVICE_NAME }}~'"$SERVICE"'~' \
            ./monaco/projects/$SERVICE/management-zone/mz.yaml
        sed -i '' -e 's~{{ .Env.SERVICE_NAME }}~'"$SERVICE"'~' \
            ./monaco/projects/$SERVICE/slo/slo.yaml
        sed -i '' -e 's~{{ .Env.SERVICE_NAME }}~'"$SERVICE"'~' \
            ./monaco/projects/$SERVICE/synthetic-monitor/synthetic.yaml
        sed -i '' -e 's~{{ .Env.OWNER_EMAIL }}~'"$OWNER_EMAIL"'~' \
            ./monaco/projects/$SERVICE/dashboard/dashboard.yaml
    else
        sed -i -e 's~{{ .Env.SERVICE_NAME }}~'"$SERVICE"'~' \
        ./monaco/projects/$SERVICE/dashboard/dashboard.yaml
        sed -i -e 's~{{ .Env.SERVICE_NAME }}~'"$SERVICE"'~' \
            ./monaco/projects/$SERVICE/management-zone/mz.yaml
        sed -i -e 's~{{ .Env.SERVICE_NAME }}~'"$SERVICE"'~' \
            ./monaco/projects/$SERVICE/slo/slo.yaml
        sed -i -e 's~{{ .Env.SERVICE_NAME }}~'"$SERVICE"'~' \
            ./monaco/projects/$SERVICE/synthetic-monitor/synthetic.yaml
        sed -i -e 's~{{ .Env.OWNER_EMAIL }}~'"$OWNER_EMAIL"'~' \
            ./monaco/projects/$SERVICE/dashboard/dashboard.yaml
    fi

elif [[ "$RUN_TYPE" == "delete" ]]; then
    echo "Removing old project folder"
    rm -rf ./monaco/projects/$SERVICE
else 
    echo "ABORT: Bad RUN_TYPE value $RUN_TYPE"
    exit 1
fi