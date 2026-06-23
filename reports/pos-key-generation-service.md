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

### QA - Karate Automation - Manual

- **File:** `qa-karateAutomation-manual.yml`
- **Type:** build/test
- **Triggers:** workflow_dispatch
- **Blocking:** Yes
- **Jobs:** run_automation_tests

**Capabilities:**

- Build
- Test

### Test, Validate, Build, Deploy to Dev

- **File:** `dev-release.yml`
- **Type:** deploy
- **Triggers:** pull_request, push
- **Blocking:** Yes
- **Jobs:** maven-dependency-check, maven-build, snyk, docker-build-and-push, publish-helm-chart

**Capabilities:**

- Build
- Test
- Security Scan
- Quality Scan
- Deploy

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

### Rotate JFrog Token

- **File:** `jfrog-token-update.yaml`
- **Type:** other
- **Triggers:** push, schedule
- **Blocking:** Yes
- **Jobs:** rotate-token

**Capabilities:**

- None detected

## Recommendations

All baseline requirements met! ✓
