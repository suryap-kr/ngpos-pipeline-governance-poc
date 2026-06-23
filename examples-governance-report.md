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

### Security Scan

- **File:** `security.yml`
- **Type:** security
- **Triggers:** pull_request, push, schedule
- **Blocking:** Yes
- **Jobs:** codeql, dependency-scan, secret-scan

**Capabilities:**

- Build
- Security Scan

### Code Quality

- **File:** `quality.yml`
- **Type:** security
- **Triggers:** pull_request, push
- **Blocking:** No (has continue-on-error)
- **Jobs:** sonarqube, linting, complexity

**Capabilities:**

- Security Scan
- Quality Scan

**Notes:**

- Job 'sonarqube' has continue-on-error=true

### Deploy to Production

- **File:** `deploy.yml`
- **Type:** deploy
- **Triggers:** push, workflow_dispatch
- **Blocking:** Yes
- **Jobs:** build-and-push, deploy-staging, deploy-production

**Capabilities:**

- Build
- Deploy

### CI Pipeline

- **File:** `ci.yml`
- **Type:** quality
- **Triggers:** pull_request, push
- **Blocking:** Yes
- **Jobs:** build, test, lint

**Capabilities:**

- Build
- Test
- Quality Scan

## Recommendations

All baseline requirements met! ✓
