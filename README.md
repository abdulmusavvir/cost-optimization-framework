# Cost Optimization Framework

<br>

## Overview
Schedule non-production instances to shutdown on schedule, Cost Optimization Framework (COF) will allow you to schedule the instance shutdown and startup time. COF also provide ability to re-size instances based on their current utilization pattner.

<br>

## Pre-requisites
Development authentication is performed via local YAML configuration file, stored at ~/.cof/csp_auth.yaml or .conf/csp_auth.yaml (user's current directory).
```
auth_configs:
  aws:
    access_key: "your-access-key-id"
    secret_access_key: "your-secret-access-key-id"
    region: "us-east-1"
    output: "json"
  azure:
    tenant_id: "your-tenant-id"
    client_id: "your-client-id"
    client_secret: "your-client-secret"
```
## Usage