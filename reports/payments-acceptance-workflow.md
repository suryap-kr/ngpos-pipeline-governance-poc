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

**Total workflows found:** 13

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

### Unified Pipeline Pull Request

- **File:** `unified-pipeline-pr.yml`
- **Type:** other
- **Triggers:** pull_request, workflow_dispatch
- **Blocking:** Yes
- **Jobs:** feature_flow

**Capabilities:**

- None detected

### QA - Selenium Automation - Robot InLane

- **File:** `qa-selenium-terminal-manual.yml`
- **Type:** security
- **Triggers:** workflow_dispatch
- **Blocking:** No (has continue-on-error)
- **Jobs:** run_automation_terminal_inlane_tests

**Capabilities:**

- Build
- Test
- Security Scan

### QA - Pull req Trigger

- **File:** `qa-selenium-terminal-pullRequestTrigger.yml`
- **Type:** security
- **Triggers:** pull_request
- **Blocking:** No (has continue-on-error)
- **Jobs:** run_sonar_scanner, run_automation_terminal_tests

**Capabilities:**

- Build
- Test
- Security Scan
- Quality Scan

### Dev Build/Deploy

- **File:** `dev.yml`
- **Type:** other
- **Triggers:** push, workflow_dispatch
- **Blocking:** Yes
- **Jobs:** Build

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

### Checkstyle Code Quality

- **File:** `checkstyle-pr-workflow.yml`
- **Type:** other
- **Triggers:** pull_request
- **Blocking:** Yes
- **Jobs:** checkstyle

**Capabilities:**

- None detected

### Build/Deploy

- **File:** `build_deploy.yml`
- **Type:** deploy
- **Triggers:** workflow_call, workflow_dispatch
- **Blocking:** Yes
- **Jobs:** build, build-and-upload-helm-chart

**Capabilities:**

- Build
- Deploy

### Build Artifact

- **File:** `build.yml`
- **Type:** other
- **Triggers:** workflow_call, workflow_dispatch
- **Blocking:** Yes
- **Jobs:** Build

**Capabilities:**

- None detected

### Build Java Artifact

- **File:** `shared_java_build.yml`
- **Type:** deploy
- **Triggers:** workflow_call
- **Blocking:** No (has continue-on-error)
- **Jobs:** build, scans, tests, dockerize

**Capabilities:**

- Build
- Test
- Security Scan
- Quality Scan
- Deploy

### Pull Request - Develop,Main

- **File:** `pull-request.yaml`
- **Type:** other
- **Triggers:** pull_request
- **Blocking:** Yes
- **Jobs:** Build

**Capabilities:**

- None detected

## Recommendations

All baseline requirements met! ✓
