# Overview

This is a demo of [Dynatrace Monitoring as Code](https://github.com/dynatrace-oss/dynatrace-monitoring-as-code) automated with GitHub actions workflows.

The GitHub actions workflows are found in the `.github/workflows` folder and are used to generate and process the Monaco files needed to automate the creation and updating to the following Dynatrace configuration:

* Synthetic scripts
* Management Zone
* Dashboards
* SLO

# GitHub Action Usage

Navigate to the GitHub Actions section this repo and run the action workflow.  Review the GIT commit history.  Monitor the change within Dynatrace.

## Setup

The GitHub Action requires these workflow secrets and used in [monaco environments file](monaco/environments.yml)

* `DT_BASEURL` - for example https://ABC.live.dynatrace.com
* `DT_API_TOKEN` - with permissions to add/update/delete the defined configurations

## 1) Run Process Monaco files workflow (process-monaco-files.yml)

Takes as arguments the either `create` or `delete` run type, service name, dashboard owner email.  The workflow calls the `scripts\process-monaco-file.sh` and then commits the change to the `monaco\project` folder within this repo.

For the `create` run type, the workflow copies configurations from `monaco\template` to the `monaco\project\[service name]` folder and replaces the configuration values with the provided service name.

## 2) Run Monaco workflow (monaco.yml)

Takes as arguments the either `create` or `delete` run type and service name.  The workflow invokes the [Monitoring as Code Runner](https://github.com/dynatrace-ace/monaco-runner) to automate processing to create or delete Dynatrace for the provided Monaco project.

For the `delete` run type, the workflow calls first copies the `monaco\template\delete.tmpl` file to `monaco\delete.yml` and replaces the configuration names with the provided service name.

# Local Testing

## 1) Run Process Monaco files

The `process-monaco-files.sh` script can be directly called to create or delete the monaco files of the provided service.  For example:

```
./scripts/process-monaco-files.sh create ServiceB <DASHBOARD_OWNER_EMAIL>
./scripts/process-monaco-files.sh delete ServiceB
```

## 2) Run Monaco  

The `run-monaco.sh` script is provided for local testing using the Monaco Docker runner for a `create` and `delete` option. It assumes you the monaco project files already and have the Docker installed locally.

For example:

```
./scripts/run-monaco.sh <DT_BASEURL> <DT_API_TOKEN> create <SERVICE_NAME> 
./scripts/run-monaco.sh <DT_BASEURL> <DT_API_TOKEN> delete <SERVICE_NAME> 
```

ALternatively, you can testing with the monaco CLI directly.

```
export SERVICE_NAME=ServiceABC 
export DT_BASEURL=$DT_BASEURL && \
export DT_API_TOKEN=$DT_API_TOKEN && \
export NEW_CLI=1 && \
monaco deploy -v \
  --environments ./monaco/environments.yml \
  --project $SERVICE_NAME \
  ./monaco/projects
```