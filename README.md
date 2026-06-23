# NGPOS Pipeline Governance POC

A proof-of-concept demonstrating centralized CI/CD pipeline governance across multiple services and technology stacks.

---

## 📋 Table of Contents

- [Why Are We Doing This?](#why-are-we-doing-this)
- [The Problem We're Solving](#the-problem-were-solving)
- [How It Works](#how-it-works)
- [Repository Structure](#repository-structure)
- [How Service Repos Consume Governance](#how-service-repos-consume-governance)
- [Why CODEOWNERS Matters](#why-codeowners-matters)
- [How to Demo This](#how-to-demo-this)
- [What's Not Implemented Yet](#whats-not-implemented-yet)
- [Next Steps](#next-steps)

---

## 🎯 Why Are We Doing This?

**Simple answer:** We want to ensure all our services follow the same security, quality, and testing standards without giving individual developers the ability to bypass those standards.

**The vision:**
- Engineering Managers define pipeline standards once
- All services automatically follow these standards
- Developers cannot weaken security or quality gates
- Changes to standards are reviewed and approved by EMs
- Different tech stacks (Java, Go, Python) can have different configurations

---

## 🔥 The Problem We're Solving

### Current State (Before Governance)

Each service team maintains their own pipeline configuration:

```
posaas-repo/
├── .github/workflows/pipeline.yml  ← Team A's pipeline
├── sonar-project.properties        ← Team A's quality rules
└── ...

poswf-repo/
├── .github/workflows/pipeline.yml  ← Team B's pipeline
├── sonar-project.properties        ← Team B's quality rules
└── ...
```

**Problems with this approach:**

1. **Inconsistent Standards**
   - Service A requires 80% code coverage
   - Service B only requires 50% code coverage
   - No way to enforce consistency

2. **Security Risks**
   - Developer can change `max.critical.vulnerabilities=0` to `max.critical.vulnerabilities=10`
   - Developer can disable Snyk scanning entirely
   - No approval required for weakening security

3. **Quality Gate Bypass**
   - Developer can lower coverage thresholds before a release
   - Can turn on "report-only" mode to ignore failures
   - Can disable tests when under pressure

4. **Hard to Audit**
   - No central view of what standards each service follows
   - Changes to security settings scattered across 50+ repos
   - Compliance reporting is difficult

### Desired State (With Governance)

One governance repository controls all pipeline standards:

```
governance-repo/
├── governance/
│   ├── posaas/           ← Standards for posaas service
│   ├── poswf/            ← Standards for poswf service
│   └── ngpos-*-reference/  ← Reference configs for each language
└── .github/CODEOWNERS    ← EMs control these configs

posaas-repo/ (service repo)
├── .github/workflows/pipeline.yml  ← Reads governance configs
├── governance/ (git submodule)     ← Points to governance-repo
└── src/...                         ← Only application code
```

**Benefits:**

✅ **Centralized Control** - One place to define and update standards
✅ **EM Approval Required** - Developers cannot bypass security/quality gates
✅ **Consistency** - All services follow the same standards
✅ **Audit Trail** - All governance changes tracked via CODEOWNERS
✅ **Compliance** - Easy to prove what standards are enforced

---

## 🔧 How It Works

### The Governance Model

```
┌─────────────────────────────────────────────────────────────┐
│                    GOVERNANCE REPOSITORY                     │
│  (Centralized pipeline standards controlled by EMs)          │
│                                                              │
│  governance/                                                 │
│  ├── posaas/                                                │
│  │   ├── snyk.properties      ← Security scanning rules    │
│  │   ├── sonar.properties     ← Code quality thresholds    │
│  │   ├── pact.properties      ← Contract testing config    │
│  │   ├── unit-test.properties ← Unit test requirements     │
│  │   ├── bdd-test.properties  ← BDD test settings          │
│  │   └── integration-test.properties ← Integration config   │
│  │                                                           │
│  └── .github/CODEOWNERS        ← @ngpos-em-posaas owns these│
└─────────────────────────────────────────────────────────────┘
                              ↓
                    (Git Submodule Link)
                              ↓
┌─────────────────────────────────────────────────────────────┐
│                      POSAAS SERVICE REPO                     │
│  (Application code + reference to governance)                │
│                                                              │
│  .github/workflows/pipeline.yml  ← Unified pipeline         │
│  governance/ (submodule)         ← Links to governance repo │
│  src/                            ← Application code         │
└─────────────────────────────────────────────────────────────┘
                              ↓
                    (Pipeline Execution)
                              ↓
┌─────────────────────────────────────────────────────────────┐
│                    PIPELINE RUNTIME FLOW                     │
│                                                              │
│  1. Checkout service code                                   │
│  2. Checkout governance configs (submodule)                 │
│  3. Read governance/posaas/snyk.properties                  │
│  4. Read governance/posaas/sonar.properties                 │
│  5. Read governance/posaas/pact.properties                  │
│  6. Read governance/posaas/unit-test.properties             │
│  7. Run tests ONLY if enabled=true                          │
│  8. Apply thresholds from governance configs                │
│  9. Fail pipeline if thresholds not met                     │
└─────────────────────────────────────────────────────────────┘
```

### Example: How Snyk Security Scanning is Governed

**Governance Config:** `governance/posaas/snyk.properties`
```properties
enabled=true
failOnError=true
severity.threshold=high
max.critical.vulnerabilities=0
max.high.vulnerabilities=5
```

**Service Pipeline:** `.github/workflows/pipeline.yml`
```yaml
security-scan:
  name: Security Scan (Snyk)
  # Only runs if enabled=true in snyk.properties
  if: needs.setup.outputs.snyk_enabled == 'true'

  # Fails pipeline if failOnError=true in snyk.properties
  continue-on-error: ${{ needs.setup.outputs.snyk_fail_on_error != 'true' }}

  steps:
    - name: Run Snyk
      run: |
        # Uses severity.threshold from governance config
        snyk test --severity-threshold=${{ needs.setup.outputs.snyk_threshold }}
```

**Key Point:** The service pipeline reads the governance config and enforces it. Developers cannot change these values without EM approval.

---

## 📁 Repository Structure

```
ngpos-pipeline-governance-agent-poc/
│
├── governance/                          # GOVERNANCE CONFIGURATIONS
│   ├── posaas/                         # Config for posaas service
│   │   ├── snyk.properties             # Security scanning rules
│   │   ├── sonar.properties            # Code quality thresholds
│   │   ├── pact.properties             # Contract testing config
│   │   ├── unit-test.properties        # Unit test requirements
│   │   ├── bdd-test.properties         # BDD test settings
│   │   └── integration-test.properties # Integration test config
│   │
│   ├── poswf/                          # Config for poswf service
│   │   └── (same 6 files)
│   │
│   ├── ngpos-java-reference/           # Java reference config
│   │   └── (same 6 files with Java-specific paths)
│   │
│   ├── ngpos-go-reference/             # Go reference config
│   │   └── (same 6 files with Go-specific paths)
│   │
│   └── ngpos-python-reference/         # Python reference config
│       └── (same 6 files with Python-specific paths)
│
├── .github/
│   └── CODEOWNERS                      # CRITICAL: Enforces EM approval
│
├── examples/
│   └── unified-pipeline-example.yml    # Sample GitHub Actions workflow
│
├── posaas/                             # (Placeholder) Actual service repos
├── poswf/                              # would be separate repositories
├── ngpos-java-reference/               # in production
├── ngpos-go-reference/
└── ngpos-python-reference/
```

### Configuration Files Explained

| File | Purpose | What It Controls |
|------|---------|------------------|
| **snyk.properties** | Security vulnerability scanning | Which severity levels fail the build, max allowed vulnerabilities |
| **sonar.properties** | Code quality analysis | Coverage thresholds, complexity limits, bug/smell thresholds |
| **pact.properties** | Contract testing between services | Pact broker URL, publishing settings, consumer/provider contracts |
| **unit-test.properties** | Unit test execution | Coverage requirements, test execution settings |
| **bdd-test.properties** | Behavior-driven development tests | Acceptance criteria, scenario execution, retry settings |
| **integration-test.properties** | Integration testing | Environment settings, database configs, external dependency mocks |

---

## 🔗 How Service Repos Consume Governance

Service repositories include this governance repository as a **Git submodule**.

### What is a Git Submodule?

Think of it like a "link" from your service repo to the governance repo. Your service repo doesn't copy the governance files - it points to them.

```
posaas-repo/
├── governance/ ← This is NOT a regular folder
│               ← It's a LINK to governance-repo at a specific commit
└── ...
```

### Setting Up the Submodule (One-Time Setup)

In each service repository (posaas, poswf, etc.):

```bash
# 1. Add governance repo as a submodule
cd posaas-repo/
git submodule add https://github.com/company/ngpos-pipeline-governance.git governance

# 2. Initialize and update the submodule
git submodule update --init --recursive

# 3. Commit the submodule reference
git add .gitmodules governance/
git commit -m "Add governance submodule"
git push
```

### In CI/CD Pipeline

The pipeline must checkout the submodule:

```yaml
steps:
  # Checkout service code with submodules
  - name: Checkout Code
    uses: actions/checkout@v4
    with:
      submodules: recursive  # ← Important: checks out governance submodule
```

### Updating Governance Configs

When governance configs are updated:

```bash
# In service repo, pull latest governance changes
cd posaas-repo/
git submodule update --remote governance/

# Commit the updated reference
git add governance/
git commit -m "Update governance configs to latest version"
git push
```

### Why Use Submodules?

✅ **Single Source of Truth** - One governance repo, many service repos reference it
✅ **Version Control** - Each service pins to a specific governance version
✅ **Easy Updates** - Update submodule reference to pull new governance rules
✅ **No Duplication** - Governance configs aren't copied into each service repo

---

## 🔒 Why CODEOWNERS Matters

### The Problem Without CODEOWNERS

Without CODEOWNERS, any developer could:

```bash
# Developer changes governance config to bypass security
cd governance/posaas/
echo "enabled=false" > snyk.properties  # Disables security scanning!
echo "max.critical.vulnerabilities=999" >> snyk.properties  # Allows vulnerabilities!

git add .
git commit -m "Temporarily disable Snyk for quick release"
git push  # ← This would work! 😱
```

### The Solution: CODEOWNERS

The `.github/CODEOWNERS` file enforces approval requirements:

```
# CODEOWNERS
/governance/posaas/    @ngpos-em-posaas
```

**What this does:**

1. **Automatic Review Request**
   When a PR touches `governance/posaas/*`, GitHub automatically requests review from `@ngpos-em-posaas`

2. **Required Approval**
   The PR cannot be merged until `@ngpos-em-posaas` approves it

3. **Audit Trail**
   All governance changes have clear approval from the Engineering Manager

4. **Prevents Bypass**
   Developers cannot merge their own PRs that weaken governance

### Example PR Flow

```
Developer                     Engineering Manager
    |                                |
    | 1. Create PR to change         |
    |    snyk.properties             |
    |--------------------------->    |
    |                                |
    | 2. GitHub auto-requests        |
    |    @ngpos-em-posaas review     |
    |                                |
    |                           3. Reviews change:
    |                              "Why lower threshold?"
    |                                |
    | 4. Developer explains:         |
    |    "Need to allow known        |
    |     issue temporarily"    <----|
    |                                |
    |                           5. EM decides:
    |                              ✅ Approve (with deadline)
    |                              ❌ Reject (find another way)
    |                                |
    | 6. PR can now merge       <----|
    |    (if approved)               |
```

### CODEOWNERS Protection Rules

In this POC, we have three EM teams:

| Owner | Owns | Controls |
|-------|------|----------|
| `@ngpos-em-posaas` | `governance/posaas/` | All posaas governance configs |
| `@ngpos-em-poswf` | `governance/poswf/` | All poswf governance configs |
| `@ngpos-em-reference` | `governance/ngpos-*-reference/` | All reference implementation configs |

Additionally, **all three EMs** must approve changes to:
- The entire `governance/` folder (catch-all)
- The `.github/CODEOWNERS` file itself (prevents bypass)

---

## 🎬 How to Demo This

### Demo Scenario: "Developer Tries to Lower Security Threshold"

**Setup:**
This POC repository represents the governance repository. In production, service repos (posaas, poswf) would be separate repos that include this as a submodule.

**Step 1: Show Current Governance Config**

```bash
# Show current Snyk config for posaas
cat governance/posaas/snyk.properties
```

**Output:**
```properties
enabled=true
failOnError=true
severity.threshold=high
max.critical.vulnerabilities=0  ← No critical vulns allowed!
max.high.vulnerabilities=5
```

**Step 2: Show the Pipeline Example**

```bash
# Show how pipeline reads this config
cat examples/unified-pipeline-example.yml | grep -A 20 "Parse Governance"
```

Point out:
- Pipeline reads `governance/posaas/snyk.properties`
- Extracts `enabled`, `failOnError`, `severity.threshold`
- Uses these values to control Snyk execution
- Developer cannot override these in their service repo

**Step 3: Show CODEOWNERS Protection**

```bash
# Show who owns the governance configs
cat .github/CODEOWNERS | grep -A 2 "posaas"
```

**Output:**
```
/governance/posaas/snyk.properties    @ngpos-em-posaas
/governance/posaas/                   @ngpos-em-posaas
```

**Explain:**
- Only `@ngpos-em-posaas` can approve changes to these files
- Developer cannot merge PR without EM approval
- Prevents security bypass

**Step 4: Simulate a Developer Change Attempt**

```bash
# Create a feature branch
git checkout -b lower-snyk-threshold

# Developer tries to lower security threshold
sed -i '' 's/max.critical.vulnerabilities=0/max.critical.vulnerabilities=10/' governance/posaas/snyk.properties

# Show the change
git diff governance/posaas/snyk.properties

# Commit and push
git add governance/posaas/snyk.properties
git commit -m "Temporarily allow more vulnerabilities for release"
git push origin lower-snyk-threshold
```

**Step 5: Create Pull Request**

In a real GitHub environment:
1. Create PR from `lower-snyk-threshold` branch
2. GitHub automatically adds `@ngpos-em-posaas` as required reviewer
3. PR shows: "Review required from @ngpos-em-posaas"
4. Developer cannot merge until EM approves

**Step 6: Show How This Would Fail in Production**

```bash
# Clean up the demo change
git checkout main
git branch -D lower-snyk-threshold
```

### Demo Talking Points

**Key Messages:**

1. **Centralized Governance**
   "All pipeline standards are defined once in this governance repository, not scattered across 50 service repos."

2. **Runtime Enforcement**
   "Service pipelines read these configs at runtime, so they always use the latest approved standards."

3. **EM Control**
   "Engineering Managers own the governance configs via CODEOWNERS. Developers can request changes, but EMs must approve."

4. **Multi-Language Support**
   "We have reference configs for Java, Go, and Python - same standards, different tooling paths."

5. **Audit Trail**
   "Every governance change has an approval from an EM. Easy to audit for compliance."

---

## 🚧 What's Not Implemented Yet

This is a **proof-of-concept**. The following are NOT implemented but would be needed for production:

### 1. Actual Service Repositories
- [ ] Separate repos for posaas, poswf services
- [ ] Service code (currently just placeholder folders)
- [ ] Real application code to test against

### 2. Working Pipeline Integration
- [ ] Actual Snyk integration with API tokens
- [ ] Actual SonarQube integration with server URL
- [ ] Actual Pact broker connection
- [ ] Real test execution (unit, integration, BDD)
- [ ] Test report publishing
- [ ] Build and deployment steps

### 3. Governance Enforcement
- [ ] Automated testing that governance configs are valid
- [ ] Schema validation for .properties files
- [ ] Default configs for new services
- [ ] Governance config versioning strategy

### 4. GitHub Configuration
- [ ] Actual GitHub teams (@ngpos-em-posaas, etc.)
- [ ] Branch protection rules requiring CODEOWNERS approval
- [ ] Required status checks before merge
- [ ] Protected branches setup

### 5. Tooling and Scripts
- [ ] Script to generate new service governance configs
- [ ] Script to validate governance configs
- [ ] Script to compare configs across services
- [ ] CLI tool for managing governance

### 6. Documentation
- [ ] Runbook for adding a new service
- [ ] Runbook for updating governance configs
- [ ] Developer guide for requesting governance changes
- [ ] EM guide for reviewing governance changes

### 7. Monitoring and Compliance
- [ ] Dashboard showing which services use which configs
- [ ] Alerting when governance configs are changed
- [ ] Compliance reports for audits
- [ ] Drift detection (service not following governance)

### 8. Advanced Features
- [ ] Multiple governance config versions (per environment)
- [ ] Config inheritance (base config + service overrides)
- [ ] Gradual rollout of governance changes
- [ ] Emergency override mechanism (with logging)

---

## 🚀 Next Steps

### Phase 1: Validate POC ✅ (Current)
- [x] Create governance folder structure
- [x] Create sample governance configs
- [x] Create CODEOWNERS file
- [x] Create example pipeline workflow
- [x] Document the approach

### Phase 2: Pilot with One Service
- [ ] Choose pilot service (recommend: posaas)
- [ ] Create actual service repository
- [ ] Add governance as Git submodule
- [ ] Implement working unified pipeline
- [ ] Integrate with real Snyk, SonarQube, Pact
- [ ] Run end-to-end test
- [ ] Gather feedback from developers and EMs

### Phase 3: Expand to More Services
- [ ] Document learnings from pilot
- [ ] Refine governance configs based on feedback
- [ ] Create tooling to simplify adoption
- [ ] Onboard 3-5 additional services
- [ ] Establish governance change process
- [ ] Train teams on new workflow

### Phase 4: Organization-Wide Rollout
- [ ] Create migration plan for all services
- [ ] Build monitoring and compliance dashboard
- [ ] Implement automated governance validation
- [ ] Roll out to all services
- [ ] Establish governance review cadence
- [ ] Measure and report on compliance

---

## 📞 Questions?

### For Developers
**Q: Can I still customize my service's pipeline?**
A: Yes! The governance configs define minimum standards. You can add additional steps, but you cannot weaken the governance requirements.

**Q: What if I need to temporarily lower a threshold?**
A: Create a PR to update the governance config with justification. Your EM will review and approve if appropriate. This creates an audit trail.

**Q: Do I need to update my pipeline when governance changes?**
A: No! Because your pipeline reads governance configs at runtime, you automatically get updated standards when you update the submodule.

### For Engineering Managers
**Q: How do I approve governance changes?**
A: You'll receive automatic review requests via GitHub when developers create PRs affecting your service's governance configs.

**Q: Can I have different standards for different environments?**
A: Not in this POC, but this could be added (e.g., governance/posaas/dev/, governance/posaas/prod/).

**Q: How do I see what's currently enforced?**
A: Check the governance/[service]/ folder in this repo. Those are the active configs.

### For Leadership
**Q: How does this improve security?**
A: Developers cannot weaken security thresholds without EM approval. All security scanning must pass before deployment.

**Q: How does this help with compliance?**
A: All governance changes have approval trail via CODEOWNERS. Easy to prove what standards were enforced when.

**Q: What's the maintenance overhead?**
A: One governance repo vs. maintaining configs in 50+ service repos. Net reduction in maintenance.

---

## 📝 License

This is a proof-of-concept for internal use. Not licensed for external distribution.

---

**Last Updated:** 2026-06-22
**POC Owner:** NGPOS Platform Team
**Status:** Proof of Concept
