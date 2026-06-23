# NGPOS Pipeline Governance Report

**Compliance Score:** 75.0%

## Governance Baseline Status

| Requirement | Status | 
|------------|--------|
| PR-triggered workflow | ✓ Pass |
| Blocking build/test gate | ✓ Pass |
| Security scan | ✓ Pass |
| Quality scan | ✗ Fail |
| Deploy workflow (optional) | ✗ Fail |

## Workflows Summary

**Total workflows found:** 5

## Workflow Details

### List Trigger Format

- **File:** `list-trigger.yml`
- **Type:** build/test
- **Triggers:** pull_request, push
- **Blocking:** Yes
- **Jobs:** build

**Capabilities:**

- Build

### Simple Trigger Format

- **File:** `simple-trigger.yml`
- **Type:** build/test
- **Triggers:** pull_request
- **Blocking:** Yes
- **Jobs:** test

**Capabilities:**

- Test

### Complex Trigger Format

- **File:** `complex-trigger.yml`
- **Type:** security
- **Triggers:** pull_request, push, schedule
- **Blocking:** Yes
- **Jobs:** security

**Capabilities:**

- Security Scan

### malformed

- **File:** `malformed.yml`
- **Type:** parse_error
- **Triggers:** none
- **Blocking:** Yes
- **Jobs:** none

**Capabilities:**

- None detected

**Notes:**

- YAML parse error: mapping values are not allowed here
  in "test-edge-cases/.github/workflows/malformed.yml", line 7, 

### empty

- **File:** `empty.yml`
- **Type:** invalid
- **Triggers:** none
- **Blocking:** Yes
- **Jobs:** none

**Capabilities:**

- None detected

**Notes:**

- Empty or invalid YAML content

## Recommendations

- Add code quality checks (e.g., linting, SonarQube)
- Consider adding deployment automation
