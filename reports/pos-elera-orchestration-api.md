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

**Total workflows found:** 4

## Workflow Details

### Feature Branch API build(Unified)

- **File:** `feature-deploy.yml`
- **Type:** other
- **Triggers:** push, workflow_dispatch
- **Blocking:** Yes
- **Jobs:** feature_flow

**Capabilities:**

- None detected

### Test, Validate, Build, Deploy to Dev

- **File:** `dev-release.yml`
- **Type:** deploy
- **Triggers:** push
- **Blocking:** No (has continue-on-error)
- **Jobs:** build, test-dev, smoke-test-dev

**Capabilities:**

- Build
- Test
- Security Scan
- Quality Scan
- Deploy

**Notes:**

- Job 'test-dev' has continue-on-error=true
- Job 'smoke-test-dev' has continue-on-error=true

### Promote Kibana Dashboard

- **File:** `promote-kibana-dashboard.yml`
- **Type:** other
- **Triggers:** workflow_dispatch
- **Blocking:** Yes
- **Jobs:** promote-dashboard

**Capabilities:**

- None detected

### Run Maven Test

- **File:** `run-tests-on-branches-and-prs.yml`
- **Type:** deploy
- **Triggers:** pull_request, push
- **Blocking:** Yes
- **Jobs:** build

**Capabilities:**

- Build
- Test
- Security Scan
- Quality Scan
- Deploy

## Recommendations

All baseline requirements met! ✓
