# Overview

This is a demo of [Dynatrace Monitoring as Code](https://github.com/dynatrace-oss/dynatrace-monitoring-as-code)

This demo had two gitHub actions pipelines

## 1) Make Monaco files

Take as an argument a service name and either `create` or `delete` run type.  The pipeline called the `scripts\process-monaco-file.sh` and then commits the change to the `monaco\project` folder within this repo

The provided service name is used as a prefix to these configurations found in the `monaco` subfolder of this repo:

* Synthetic scripts
* Management Zone
* Dashboards
* SLO

## 2) Run Monaco

This GitHub Action pipeline will invoke the [Monitoring as Code Runner](https://github.com/dynatrace-ace/monaco-runner) to automate processing to create or delete Dynatrace for the provided Monaco project.

# Usage

Navigate to the GitHub Actions section this repo and run the action pipeline.  Review the GIT commit history.  Monitor the change within Dynatrace.

# Setup

The GitHub Action requires these pipeline secrets and used in [monaco environments file](monaco/environments.yml)

* `DT_BASEURL` - for example https://ABC.live.dynatrace.com
* `DT_API_TOKEN` - with V2 permissions to add/update/delete the defined Configurations

# Local Testing

The `test-monaco-cli.sh` is provided for local testing. It assumes you have the monaco CLI installed locally.