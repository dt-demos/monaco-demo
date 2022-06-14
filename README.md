# Overview

This is a demo of [Dynatrace Monitoring as Code](https://github.com/dynatrace-oss/dynatrace-monitoring-as-code)

A gitHub actions pipeline will invoke the [Monitoring as Code Runner](https://github.com/dynatrace-ace/monaco-runner) to automate processing to create or delete Dynatrace for a "fake" service name that was provided.  The provided service name is used as a prefix to these configurations found in the `monaco` subfolder of this repo:

* Synthetic scripts
* Management Zone
* Dashboards
* SLO

# Setup

The GitHub Action requires these pipeline secrets and used in [monaco environments file](monaco/environments.yml)

* `DT_BASEURL` - for example https://ABC.live.dynatrace.com
* `DT_API_TOKEN` - with V2 permissions to add/update/delete the defined Configurations

# Local Testing

The `test-monaco.sh` is provided for local testing. It assumes you have the monaco CLI installed locally.