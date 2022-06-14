# Overview

This is a demo of [Dynatrace Monitoring as Code](https://github.com/dynatrace-oss/dynatrace-monitoring-as-code)

A GitHub actions pipeline will invoke the [Monitoring as Code Runner](https://github.com/dynatrace-ace/monaco-runner) to automate processing

# Setup

The GitHub Action requires these pipeline secrets

```
# DT_BASE_URL  - monaco environments file, for example https://ABC.live.dynatrace.com
# DT_API_TOKEN - monaco environments file, with V2: SLO read/write & V1: read/write config & access problem/event feed
```