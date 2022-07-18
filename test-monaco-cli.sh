#!/usr/bin/env bash
# Usage: 
#   Create config --> ./run-monaco.sh <DT_BASEURL> <DT_API_TOKEN> <SERVICE_NAME> <OWNER_EMAIL> create
#   Delete config --> ./run-monaco.sh <DT_BASEURL> <DT_API_TOKEN> <SERVICE_NAME> <OWNER_EMAIL> delete

# monaco projects config files assume these environment variable
# SERVICE_NAME - this is substituted within the configuration names
# OWNER_EMAIL  - required for a dashboards
# DT_BASE_URL  - monaco environments file, for example https://ABC.live.dynatrace.com
# DT_API_TOKEN - monaco environments file, with V2: SLO read/write & V1: read/write config & access problem/event feed

DT_BASEURL=$1
DT_API_TOKEN=$2
SERVICE_NAME=$3
OWNER_EMAIL=$4
RUN_TYPE=$5

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

if [ -z $OWNER_EMAIL ]; then
  echo "ABORT: OWNER_EMAIL argument is required"
  exit 1
fi

if [ -z $RUN_TYPE ]; then
  echo "ABORT: RUN_TYPE argument is required"
  exit 1
fi

MONACO_ENVIONMENT_FILE=./monaco/environments.yml
MONACO_BASE_PATH=./monaco/projects
MONACO_PROJECT_BASE_PATH=$MONACO_BASE_PATH/$SERVICE_NAME

if [[ "$RUN_TYPE" == "create" ]]; then
  echo "Creating configuration"

  # for testing add: --dry-run \  
  export DT_BASEURL=$DT_BASEURL && \
  export DT_API_TOKEN=$DT_API_TOKEN && \
  export SERVICE_NAME=$SERVICE_NAME && \
  export OWNER_EMAIL=$OWNER_EMAIL && \
  export NEW_CLI=1 && \
    monaco deploy -v \
    --environments $MONACO_ENVIONMENT_FILE \
    --project $SERVICE_NAME \
      $MONACO_BASE_PATH

elif [[ "$RUN_TYPE" == "delete" ]]; then
  echo "Deleting configuration"
  # need to  replace the service name value for the delete.yaml file
  sed -e 's~SERVICE_NAME~'"$SERVICE_NAME"'~' \
    $MONACO_BASE_PATH/delete.tmpl > $MONACO_PROJECT_BASE_PATH/delete.yaml

  export DT_BASEURL=$DT_BASEURL && \
  export DT_API_TOKEN=$DT_API_TOKEN && \
  export SERVICE_NAME=$SERVICE_NAME && \
  export OWNER_EMAIL=$OWNER_EMAIL && \
  export NEW_CLI=1 && \
    monaco deploy -v \
    --environments $MONACO_ENVIONMENT_FILE \
    --project $SERVICE_NAME \
      $MONACO_BASE_PATH

  # once the delete is done, then delete the yaml file else it gets picked up on create
  #rm $MONACO_PROJECT_BASE_PATH/delete.yaml

else 
  echo "ABORT: Bad RUN_TYPE value."
  exit 1
fi
