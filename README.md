## Disclaimer

These projects are not supported by Dynatrace.

Any issues please utilize github issues. We will try our best to get to your issues and questions.

# Overview

This is a demo of [Dynatrace Monitoring as Code](https://github.com/dynatrace-oss/dynatrace-monitoring-as-code) locally and with automated with GitHub actions workflows.

The GitHub actions workflows are found in the `.github/workflows` folder and are used to generate and process the Monaco files needed to automate the creation and updating to the following Dynatrace configuration:

* Synthetic scripts
* Management Zone
* Dashboards
* SLO

# Recommended Approach

The `crawl-walk-run` approach is recommended with Monaco and automation.

1. **CRAWL** - Make a simple Monaco configuration and run Monaco from command line to understand what it does 
1. **WALK** - Define templates and naming conventions, try out approaches to automate execution with scripts
1. **RUN** - Establish requirements and process flow for a self-service model.  Then evaluate approaches to abstract the implementation details from users, generate the detailed Monaco files from templates and automate the execution. For example: Provide a web portal with a streamlined setup inputs that generates a ticket for approval or for some changes is auto-approved.  Upon approval, a pipeline can be run to generate the detailed Monaco files, applies the changes, and closes the ticket automatically.

# Demo Locally

## 1) Run Process Monaco files

The `scripts/process-monaco-files.sh` script can be directly called to create or delete the Monaco files of the provided service.  For example:

```
./scripts/process-monaco-files.sh create ServiceB <DASHBOARD_OWNER_EMAIL>
./scripts/process-monaco-files.sh delete ServiceB
```

## 2) Run Monaco CLI directly.

```
export SERVICE_NAME=<SERVICE_NAME>
export DT_BASEURL=$DT_BASEURL && \
export DT_API_TOKEN=$DT_API_TOKEN && \
export NEW_CLI=1 && \
monaco deploy -v \
  --environments ./monaco/environments.yml \
  --project $SERVICE_NAME \
  ./monaco/projects
```

## 3) Run Monaco using Docker Runner

The `scripts/run-monaco.sh` script is provided for local testing of the [Monitoring as Code Runner](https://github.com/dynatrace-ace/monaco-runner). It assumes you the Monaco project files already and have the Docker installed locally.

For example:

```
./scripts/run-monaco.sh <DT_BASEURL> <DT_API_TOKEN> create <SERVICE_NAME> 
./scripts/run-monaco.sh <DT_BASEURL> <DT_API_TOKEN> delete <SERVICE_NAME> 
```

# Demo with GitHub Action workflows

Navigate to the GitHub Actions section this repo and run the action workflow.  Review the GIT commit history.  Monitor the change within Dynatrace.

## Setup

The GitHub Action requires these workflow secrets and uses them in [monaco environments file](monaco/environments.yml)

* `DT_BASEURL` - for example https://ABC.live.dynatrace.com
* `DT_API_TOKEN` - with permissions to add/update/delete the defined configurations

## 1) Run Process Monaco files workflow (process-monaco-files.yml)

Takes as arguments either `create` or `delete` as the run type, service name, dashboard owner email.  The workflow calls the `scripts\process-monaco-file.sh` script and then commits the files changes to the `monaco\project` folder within this repo.

For the `create` run type, the workflow copies configurations from `monaco\template` to the `monaco\project\[service name]` folder and replaces the configuration values with the provided service name.

## 2) Run Monaco workflow (monaco.yml)

Takes as arguments either `create` or `delete` as the run type and service name.  The workflow invokes the [Monitoring as Code Runner](https://github.com/dynatrace-ace/monaco-runner) to automate processing to create or delete Dynatrace for the provided Monaco project.

For the `delete` run type, the workflow first copies the `monaco\template\delete.tmpl` file to `monaco\delete.yml` and replaces the configuration names with the provided service name.