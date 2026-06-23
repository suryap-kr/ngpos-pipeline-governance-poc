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

**Total workflows found:** 5

## Workflow Details

### Sonar Scanner - Manual

- **File:** `SonarScannerManual.yml`
- **Type:** deploy
- **Triggers:** workflow_dispatch
- **Blocking:** Yes
- **Jobs:** run_sonar_scanner

**Capabilities:**

- Build
- Test
- Security Scan
- Quality Scan
- Deploy

### QA - Pull req & Schedule Trigger

- **File:** `qa-pullRequests-scheduleTrigger.yml`
- **Type:** security
- **Triggers:** pull_request, push
- **Blocking:** Yes
- **Jobs:** run_sonar_scanner, run_automation_regression_tests

**Capabilities:**

- Build
- Test
- Security Scan
- Quality Scan

### Push Docker Image to Artifactory

- **File:** `edge-manual-push.yml`
- **Type:** deploy
- **Triggers:** workflow_dispatch
- **Blocking:** Yes
- **Jobs:** build, build-and-upload-helm-chart

**Capabilities:**

- Build
- Test
- Deploy

### QA - Karate Automation - Manual

- **File:** `qa-karateAutomation-manual.yml`
- **Type:** build/test
- **Triggers:** workflow_dispatch
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

## Recommendations

All baseline requirements met! ✓
