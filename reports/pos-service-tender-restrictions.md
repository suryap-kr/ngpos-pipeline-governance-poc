# NGPOS Pipeline Governance Report

**Compliance Score:** 100.0%

## Governance Baseline Status

| Requirement | Status | 
|------------|--------|
| PR-triggered workflow | ✓ Pass |
| Blocking build/test gate | ✓ Pass |
| Security scan | ✓ Pass |
| Quality scan | ✓ Pass |
| Deploy workflow (optional) | ✓ Pass |

## Workflows Summary

**Total workflows found:** 6

## Workflow Details

### QA - Pull req & Schedule Trigger

- **File:** `qa-pullRequests-scheduleTrigger.yml`
- **Type:** security
- **Triggers:** pull_request, push
- **Blocking:** Yes
- **Jobs:** run_sonar_scanner

**Capabilities:**

- Build
- Test
- Security Scan
- Quality Scan

### Feature Branch API build

- **File:** `feature-branch-api.yml`
- **Type:** other
- **Triggers:** workflow_dispatch
- **Blocking:** Yes
- **Jobs:** feature_flow

**Capabilities:**

- None detected

### QA - Karate Automation - Manual

- **File:** `qa-karateAutomation-manual.yml`
- **Type:** build/test
- **Triggers:** workflow_call, workflow_dispatch
- **Blocking:** Yes
- **Jobs:** run_automation_tests

**Capabilities:**

- Build
- Test

### QA - Sonar Scanner - Manual

- **File:** `qa-sonarScanner-manual.yml`
- **Type:** security
- **Triggers:** workflow_dispatch
- **Blocking:** Yes
- **Jobs:** run_sonar_scanner

**Capabilities:**

- Build
- Test
- Security Scan
- Quality Scan

### Build Mx client

- **File:** `build_mx_client.yaml`
- **Type:** build/test
- **Triggers:** workflow_dispatch
- **Blocking:** Yes
- **Jobs:** setup-build-test-coverage-artifactory

**Capabilities:**

- Build

### Deploy to Edge

- **File:** `edge_deploy.yaml`
- **Type:** deploy
- **Triggers:** workflow_dispatch
- **Blocking:** Yes
- **Jobs:** build, build-and-upload-helm-chart

**Capabilities:**

- Build
- Deploy

## Recommendations

All baseline requirements met! ✓
