# NGPOS Pipeline Governance Report

**Compliance Score:** 100.0%

## Governance Baseline Status

| Requirement | Status | 
|------------|--------|
| PR-triggered workflow | ✓ Pass |
| Blocking build/test gate | ✓ Pass |
| Security scan | ✓ Pass |
| Quality scan | ✓ Pass |
| Deploy workflow (optional) | ✗ Fail |

## Workflows Summary

**Total workflows found:** 8

## Workflow Details

### Build and Release

- **File:** `release.yml`
- **Type:** other
- **Triggers:** push, workflow_dispatch
- **Blocking:** Yes
- **Jobs:** maven-build-and-release

**Capabilities:**

- None detected

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

### Build and Verify

- **File:** `feature-build.yml`
- **Type:** other
- **Triggers:** pull_request, push
- **Blocking:** Yes
- **Jobs:** maven-build

**Capabilities:**

- None detected

### Unified CI/CD Pipeline

- **File:** `unified-cicd-pipeline.yml`
- **Type:** other
- **Triggers:** push
- **Blocking:** Yes
- **Jobs:** maven-build-and-release

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

### Build and Deploy ( Integration )

- **File:** `integration-release.yml`
- **Type:** other
- **Triggers:** workflow_dispatch
- **Blocking:** Yes
- **Jobs:** maven-build-and-release, deploy-integration

**Capabilities:**

- None detected

### Build and Release (Development)

- **File:** `development-release.yml`
- **Type:** other
- **Triggers:** workflow_dispatch
- **Blocking:** Yes
- **Jobs:** maven-build-and-release

**Capabilities:**

- None detected

## Recommendations

- Consider adding deployment automation
