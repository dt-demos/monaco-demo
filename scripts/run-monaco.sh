#!/usr/bin/env bash

# monaco projects config files assume these environment variable
# DT_BASE_URL  - monaco environments file, for example https://ABC.live.dynatrace.com
# DT_API_TOKEN - monaco environments file
# SERVICE_NAME - name service and corresponding monaco project name
# RUN_TYPE - create or delete
#
# Usage example: 
#   Create config --> ./run-monaco.sh <DT_BASEURL> <DT_API_TOKEN> create <SERVICE_NAME> 
#   Delete config --> ./run-monaco.sh <DT_BASEURL> <DT_API_TOKEN> delete <SERVICE_NAME> 

DT_BASEURL=$1
DT_API_TOKEN=$2
RUN_TYPE=$3
SERVICE_NAME=$4

if [ -z $DT_BASEURL ]; then
  echo "ABORT: missing DT_BASEURL environment variable"
  exit 1
fi

if [ -z $DT_API_TOKEN ]; then
  echo "ABORT: missing DT_API_TOKEN environment variable"
  exit 1
fi

if [ -z $SERVICE_NAME ]; then
  echo "ABORT: SERVICE_NAME argument is required"
  exit 1
fi

if [ -z $RUN_TYPE ]; then
  echo "ABORT: RUN_TYPE argument is required"
  exit 1
fi

run_monaco() {

  MONACO_ENVIONMENT_FILE=./monaco/environments.yml
  MONACO_BASE_PATH=./monaco/projects

  # clean out old logs
  rm .logs/*

  docker run \
    -e DT_BASEURL=$DT_BASEURL \
    -e DT_API_TOKEN=$DT_API_TOKEN \
    -e NEW_CLI=1 \
    -v $(pwd):/monaco-mount/ dynatraceace/monaco-runner:release-v1.6.0 \
     "monaco deploy -v --environments /monaco-mount/monaco/environments.yml --project $SERVICE_NAME /monaco-mount/monaco/projects"
}

if [[ "$RUN_TYPE" == "create" ]]; then
  echo "Creating configuration"
  run_monaco

elif [[ "$RUN_TYPE" == "delete" ]]; then

  # need to replace the service name value for the delete.yaml file
  sed -e 's~SERVICE_NAME~'"$SERVICE_NAME"'~' \
    ./monaco/template/delete.tmpl > $MONACO_BASE_PATH/delete.yaml

  echo "Deleting configuration"
  run_monaco

  # once the delete is done, then delete the yaml file else it gets picked up on create
  rm $MONACO_BASE_PATH/delete.yaml

else 
  echo "ABORT: Bad RUN_TYPE value."
  exit 1
fi
