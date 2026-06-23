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

**Total workflows found:** 8

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

### Run Harness Pipeline Setup

- **File:** `harness-workflow.yml`
- **Type:** other
- **Triggers:** push
- **Blocking:** Yes
- **Jobs:** harness

**Capabilities:**

- None detected

### QA - Karate Automation - Manual

- **File:** `qa-karateAutomation-manual.yml`
- **Type:** build/test
- **Triggers:** workflow_dispatch
- **Blocking:** Yes
- **Jobs:** run_automation_tests

**Capabilities:**

- Build
- Test

### Generate HTML from AsyncAPI Documentation

- **File:** `generate-docs.yml`
- **Type:** deploy
- **Triggers:** push
- **Blocking:** Yes
- **Jobs:** generate

**Capabilities:**

- Deploy

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

### Feature Unified CI/CD Pipeline

- **File:** `unified-cicd-pipeline.yml`
- **Type:** other
- **Triggers:** push, workflow_dispatch
- **Blocking:** Yes
- **Jobs:** feature_flow

**Capabilities:**

- None detected

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
