# Quick Demo Commands - Copy & Paste Ready

Quick reference for the governance approval flow demo.

---

## 🚀 Setup (Before Demo)

```bash
# Navigate to repo
cd /Users/Desktop/ngpos-pipeline-governance-agent-poc

# Ensure on main and up to date
git checkout main
git pull origin main

# Verify current state
cat governance/ngpos-java-reference/snyk.properties | grep enabled
# Should show: enabled=true
```

---

## 🎬 Demo Flow

### 1. Create Feature Branch
```bash
git checkout -b disable-snyk-temporarily
```

### 2. Disable Snyk in Governance Config
```bash
sed -i '' 's/enabled=true/enabled=false/' governance/ngpos-java-reference/snyk.properties
```

### 3. Show the Change
```bash
git diff governance/ngpos-java-reference/snyk.properties
```

### 4. Commit the Change
```bash
git add governance/ngpos-java-reference/snyk.properties

git commit -m "Temporarily disable Snyk to speed up pipeline

Need to get a quick release out. Will re-enable after deployment."
```

### 5. Push to Remote
```bash
git push origin disable-snyk-temporarily
```

### 6. Create Pull Request

**Option A: GitHub CLI**
```bash
gh pr create \
  --title "Temporarily disable Snyk security scanning" \
  --body "## Why
Need to speed up pipeline for urgent release.

## Changes
- Disabled Snyk security scanning in Java reference config

## Plan
Will re-enable after this release is deployed.

**Request:** Please approve for temporary use." \
  --base main \
  --head disable-snyk-temporarily
```

**Option B: GitHub Web UI**
- Go to repo on GitHub
- Click "Compare & pull request" button
- Fill in title and description
- Click "Create pull request"

---

## 🔍 What to Show on GitHub

1. **PR is created** → GitHub automatically requests review from @HarshitaY-KR
2. **Merge button is disabled** → Shows "Review required"
3. **EM must approve** → Only they can unblock the merge
4. **After approval** → Merge button becomes enabled
5. **Audit trail** → PR shows who approved and why

---

## 🧹 Cleanup After Demo

```bash
# Return to main branch
git checkout main

# Delete local branch
git branch -D disable-snyk-temporarily

# Delete remote branch
git push origin --delete disable-snyk-temporarily

# Close PR (if not merged)
gh pr close <PR_NUMBER>
```

---

## 🎯 Alternative Demo Scenarios

### Scenario: Lower Coverage Threshold
```bash
git checkout -b lower-coverage-threshold
sed -i '' 's/min.coverage.percentage=80/min.coverage.percentage=50/' \
  governance/ngpos-java-reference/unit-test.properties
git add governance/ngpos-java-reference/unit-test.properties
git commit -m "Lower coverage threshold for faster builds"
git push origin lower-coverage-threshold
```

### Scenario: Allow Critical Vulnerabilities
```bash
git checkout -b allow-critical-vulns
sed -i '' 's/max.critical.vulnerabilities=0/max.critical.vulnerabilities=10/' \
  governance/ngpos-java-reference/snyk.properties
git add governance/ngpos-java-reference/snyk.properties
git commit -m "Allow some critical vulnerabilities temporarily"
git push origin allow-critical-vulns
```

### Scenario: Disable Quality Gate Failure
```bash
git checkout -b disable-quality-gate
sed -i '' 's/failOnError=true/failOnError=false/' \
  governance/ngpos-java-reference/sonar.properties
git add governance/ngpos-java-reference/sonar.properties
git commit -m "Make SonarQube report-only mode"
git push origin disable-quality-gate
```

---

## 📊 Show Pipeline Impact

### Before Change (Snyk Enabled)
```bash
./test-java-governance.sh | grep -A 5 "SECURITY SCAN"
```
Output:
```
✅ RUNNING SECURITY SCAN (SNYK)
   Scanning dependencies for security vulnerabilities
```

### After Change (Snyk Disabled)
```bash
# If change was merged to main
git checkout main
git pull origin main
./test-java-governance.sh | grep -A 5 "SECURITY SCAN"
```
Output:
```
⏭️  SKIPPING SECURITY SCAN (SNYK)
   Reason: disabled in governance config
```

---

## 💡 Key Talking Points

1. **Developer cannot bypass governance** - Even if they're a repo admin
2. **EM must explicitly approve** - Creates accountability
3. **Complete audit trail** - Who, what, when, why
4. **Governance controls pipeline** - Configs directly affect what runs
5. **Centralized standards** - One place to manage all service standards

---

## ⚠️ Common Issues & Fixes

### Issue: "gh: command not found"
```bash
# Install GitHub CLI first
# macOS: brew install gh
# Or use GitHub web UI instead
```

### Issue: "Permission denied"
```bash
# Authenticate with GitHub
gh auth login
```

### Issue: "Branch protection not working"
```bash
# Enable in GitHub:
# Settings → Branches → Add rule → main
# ✓ Require pull request reviews before merging
# ✓ Require review from Code Owners
```

### Issue: "@HarshitaY-KR user not found"
```bash
# User must have access to the repository
# Invite via: Settings → Collaborators → Add people
```

---

**Duration:** 5-10 minutes for core demo
**Best for:** Live presentations, stakeholder demos
**Prerequisite:** GitHub repository with branch protection enabled
