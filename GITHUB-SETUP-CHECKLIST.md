# GitHub Setup Checklist for Demo

Ensure GitHub repository is properly configured for the governance approval flow demo.

---

## ✅ Pre-Demo Checklist

### 1. Repository Setup

- [ ] **Repository exists on GitHub**
  - Not just local - must be pushed to GitHub
  - Example: `https://github.com/your-org/ngpos-pipeline-governance-agent-poc`

- [ ] **CODEOWNERS file is present**
  ```bash
  # Verify locally
  cat .github/CODEOWNERS | grep "HarshitaY-KR"
  ```

- [ ] **All governance config files are committed**
  ```bash
  # Verify files exist
  ls -la governance/ngpos-java-reference/
  # Should show all 6 .properties files
  ```

---

### 2. GitHub User/Team Setup

- [ ] **@HarshitaY-KR user exists on GitHub**
  - Visit: `https://github.com/HarshitaY-KR`
  - Should show a valid GitHub profile

- [ ] **@HarshitaY-KR has access to the repository**
  ```
  Settings → Collaborators and teams → Add people
  Username: HarshitaY-KR
  Role: Write (or Admin)
  ```

- [ ] **Placeholder teams are acceptable**
  - `@ngpos-em-posaas` - okay to not exist (won't block Java demo)
  - `@ngpos-em-poswf` - okay to not exist (won't block Java demo)

---

### 3. Branch Protection Setup (CRITICAL)

Navigate to: **Settings → Branches → Branch protection rules**

- [ ] **Protection rule exists for `main` branch**

  Click **"Add rule"** if none exists

  **Branch name pattern:** `main`

- [ ] **✓ Require a pull request before merging**
  - This forces all changes to go through PRs

- [ ] **✓ Require approvals**
  - Require: `1` approving review(s)

- [ ] **✓ Require review from Code Owners**
  - **THIS IS THE KEY SETTING**
  - Without this, CODEOWNERS won't block merges

- [ ] **Optional: ✓ Dismiss stale pull request approvals when new commits are pushed**
  - Good for production, not required for demo

- [ ] **Optional: ✓ Require status checks to pass before merging**
  - Good for production, not required for demo

- [ ] **Click "Create" or "Save changes"**

---

### 4. Verify Branch Protection

```bash
# Method 1: Check via GitHub UI
# Go to: Settings → Branches
# Should see: main (1 rule)

# Method 2: Check via GitHub CLI
gh api repos/:owner/:repo/branches/main/protection \
  --jq '.required_pull_request_reviews.require_code_owner_reviews'
# Should return: true
```

---

### 5. Test Setup (Dry Run)

**Before the actual demo, do a quick test:**

```bash
# 1. Create test branch
git checkout -b test-codeowners-setup

# 2. Make a small change
echo "# Test" >> governance/ngpos-java-reference/snyk.properties

# 3. Commit and push
git add governance/ngpos-java-reference/snyk.properties
git commit -m "Test CODEOWNERS setup"
git push origin test-codeowners-setup

# 4. Create PR
gh pr create --title "Test PR" --body "Testing CODEOWNERS" \
  --base main --head test-codeowners-setup

# 5. Check PR on GitHub
# You should see:
# - ⚠️ Review required
# - @HarshitaY-KR listed as reviewer
# - Merge button DISABLED
```

**If test successful:**
```bash
# Clean up test
gh pr close --delete-branch <PR_NUMBER>
git checkout main
```

**If test failed, see troubleshooting below.**

---

## ⚠️ Common Issues & Fixes

### Issue 1: Merge button is NOT blocked

**Symptom:** PR can be merged without approval

**Causes:**
1. Branch protection not enabled
2. "Require review from Code Owners" not checked
3. CODEOWNERS file in wrong location
4. CODEOWNERS syntax error

**Fix:**
```bash
# 1. Verify CODEOWNERS location
ls -la .github/CODEOWNERS
# Must be in .github/ not root

# 2. Verify branch protection
# Settings → Branches → main → Edit
# Ensure "Require review from Code Owners" is ✓

# 3. Check CODEOWNERS syntax
cat .github/CODEOWNERS
# Lines should match: /path/to/file @username
```

---

### Issue 2: @HarshitaY-KR not requested as reviewer

**Symptom:** PR created but no review request

**Causes:**
1. User doesn't have repo access
2. CODEOWNERS pattern doesn't match changed file
3. CODEOWNERS file not on base branch (main)

**Fix:**
```bash
# 1. Verify user has access
# Settings → Collaborators → Check if HarshitaY-KR is listed

# 2. Verify CODEOWNERS pattern
cat .github/CODEOWNERS | grep "ngpos-java-reference"
# Should show: /governance/ngpos-java-reference/ @HarshitaY-KR

# 3. Verify CODEOWNERS is on main branch
git checkout main
git pull origin main
ls -la .github/CODEOWNERS
# File should exist on main
```

---

### Issue 3: "gh: command not found"

**Symptom:** Cannot use `gh` commands

**Fix:**
```bash
# Install GitHub CLI
# macOS
brew install gh

# Or use GitHub web UI instead
# No CLI required - just create PR manually
```

---

### Issue 4: Permission denied when pushing

**Symptom:** `git push` fails with authentication error

**Fix:**
```bash
# Authenticate with GitHub
gh auth login
# Follow prompts

# Or use SSH instead of HTTPS
git remote set-url origin git@github.com:your-org/repo.git
```

---

### Issue 5: User can merge despite CODEOWNERS

**Symptom:** Merge button is enabled even without approval

**Possible Causes:**
1. User is repo admin AND "Do not allow bypassing the above settings" is not checked
2. Branch protection applies to wrong branch

**Fix:**
```bash
# Settings → Branches → Edit rule for main
# Scroll to bottom
# ✓ Do not allow bypassing the above settings
# ✓ Include administrators
# Save changes
```

---

## 🎯 Quick Validation Commands

```bash
# Check 1: CODEOWNERS file exists and has correct content
cat .github/CODEOWNERS | grep -A 2 "ngpos-java-reference"

# Check 2: Governance files exist
ls governance/ngpos-java-reference/*.properties | wc -l
# Should return: 6

# Check 3: On main branch
git branch --show-current
# Should return: main

# Check 4: Up to date with remote
git status
# Should say: "Your branch is up to date with 'origin/main'"

# Check 5: GitHub CLI authenticated
gh auth status
# Should show: Logged in to github.com as [username]
```

---

## 📋 Pre-Presentation Final Check (5 min before)

**Morning of presentation:**

```bash
# 1. Pull latest changes
git checkout main
git pull origin main

# 2. Verify governance config is in default state
cat governance/ngpos-java-reference/snyk.properties | grep enabled
# Should show: enabled=true

# 3. Verify no old demo branches exist
git branch --list "disable-*"
# Should be empty

# 4. Verify GitHub is accessible
gh repo view
# Should show repository information

# 5. Test script works
./test-java-governance.sh
# Should run without errors
```

**If all checks pass → Ready for demo! ✅**

---

## 🆘 Emergency Fallback

**If GitHub is down or setup fails:**

**Plan B: Local Demo Only**

1. Show CODEOWNERS file
   ```bash
   cat .github/CODEOWNERS
   ```

2. Show governance configs
   ```bash
   cat governance/ngpos-java-reference/snyk.properties
   ```

3. Show what WOULD happen (verbal walkthrough using APPROVAL-FLOW.md)

4. Show test script proving governance controls pipeline
   ```bash
   ./test-java-governance.sh
   ```

5. Show screenshots from a previous successful demo

**This still demonstrates the concept, just without live GitHub interaction.**

---

## 📞 Support Contacts

**Before Demo:**
- Test setup: 1 day before
- Verify access: 1 hour before
- Final check: 15 min before

**If Issues:**
- Check this document for troubleshooting
- Have screenshots ready as backup
- Local demo (Plan B) is still valuable

---

**Last Updated:** 2026-06-22
**Estimated Setup Time:** 15 minutes
**Test Run Recommended:** Yes (1 day before presentation)
