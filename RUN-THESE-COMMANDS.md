
# RUN THESE COMMANDS - Complete Implementation

Copy and paste these commands to implement the REAL GitHub approval flow.

---

## ✅ ALREADY DONE

```
✓ Git repository initialized (commit b6829d9)
✓ CODEOWNERS configured with @HarshitaY-KR
✓ 30 governance config files created
✓ GitHub CLI authenticated (suryap-kr)
```

---

## 🚀 COMMANDS TO RUN NOW

### 1. Create GitHub Repository and Push

```bash
gh repo create ngpos-pipeline-governance-agent-poc \
  --public \
  --source=. \
  --remote=origin \
  --push \
  --description "Pipeline Governance POC with CODEOWNERS enforcement"
```

**Expected output:**
```
✓ Created repository suryap-kr/ngpos-pipeline-governance-agent-poc on GitHub
✓ Added remote https://github.com/suryap-kr/ngpos-pipeline-governance-agent-poc.git
✓ Pushed commits to https://github.com/suryap-kr/ngpos-pipeline-governance-agent-poc.git
```

**Verify:**
```bash
git remote -v
# Should show GitHub URL
```

---

### 2. Add @HarshitaY-KR as Collaborator

```bash
gh api repos/:owner/:repo/collaborators/HarshitaY-KR \
  --method PUT \
  -f permission=write
```

**Expected output:**
```
{}
```

**⚠️ IMPORTANT:** @HarshitaY-KR must accept the invitation!

**Verify:**
```bash
gh api repos/:owner/:repo/collaborators/HarshitaY-KR
# Should show user details
```

---

### 3. Configure Branch Protection

**Via GitHub UI (REQUIRED - Cannot do via CLI easily):**

1. Go to: https://github.com/suryap-kr/ngpos-pipeline-governance-agent-poc/settings/branches

2. Click **"Add rule"** button

3. Fill in:
   - **Branch name pattern:** `main`

4. Check these boxes:
   - ✅ **Require a pull request before merging**
     - Required approvals: `1`
   - ✅ **Require review from Code Owners** ← **THIS IS CRITICAL!**
   - ✅ **Include administrators**

5. Click **"Create"**

**Verify via CLI:**
```bash
gh api repos/:owner/:repo/branches/main/protection \
  --jq '.required_pull_request_reviews.require_code_owner_reviews'

# Should return: true
```

---

### 4. Create Test PR

```bash
# Create branch
git checkout -b disable-snyk-for-demo

# Disable Snyk
sed -i '' 's/enabled=true/enabled=false/' governance/ngpos-java-reference/snyk.properties

# Commit
git add governance/ngpos-java-reference/snyk.properties
git commit -m "Disable Snyk scanning temporarily

Need to speed up pipeline for urgent release.
Will re-enable after deployment."

# Push
git push origin disable-snyk-for-demo
```

**Expected output:**
```
To github.com:suryap-kr/ngpos-pipeline-governance-agent-poc.git
 * [new branch]      disable-snyk-for-demo -> disable-snyk-for-demo
```

---

### 5. Create Pull Request

```bash
gh pr create \
  --title "Disable Snyk security scanning temporarily" \
  --body "## Why
Need to speed up pipeline for urgent release.

## Changes
- Disabled Snyk security scanning in Java reference config

## Plan
Will re-enable after this release is deployed.

**Request:** @HarshitaY-KR please approve for temporary use." \
  --base main \
  --head disable-snyk-for-demo
```

**Expected output:**
```
https://github.com/suryap-kr/ngpos-pipeline-governance-agent-poc/pull/1
```

---

### 6. Verify GitHub Blocks Merge

```bash
# View PR
gh pr view

# Check if mergeable
gh pr view --json mergeStateStatus,mergeable
```

**Expected output:**
```json
{
  "mergeable": "UNKNOWN",
  "mergeStateStatus": "BLOCKED"
}
```

**On GitHub web UI, you should see:**
- ⚠️ Review required
- 👤 HarshitaY-KR (review requested)
- Merge button is DISABLED

---

### 7. @HarshitaY-KR Approves

**As HarshitaY-KR (or simulate approval):**

```bash
# Get PR number first
PR_NUMBER=$(gh pr view --json number --jq '.number')

# Approve
gh pr review $PR_NUMBER --approve --body "Approved for demo purposes.

Conditions:
1. Re-enable within 24 hours
2. Document in follow-up issue"
```

**Verify merge is now unblocked:**
```bash
gh pr view --json mergeStateStatus
# Should return: {"mergeStateStatus": "CLEAN"}
```

---

### 8. Merge the PR

```bash
# Get PR number
PR_NUMBER=$(gh pr view disable-snyk-for-demo --json number --jq '.number')

# Merge
gh pr merge $PR_NUMBER --squash --delete-branch
```

**Expected output:**
```
✓ Squashed and merged pull request #1 (Disable Snyk security scanning temporarily)
✓ Deleted branch disable-snyk-for-demo
```

---

### 9. Verify Governance Controls Pipeline

```bash
# Pull merged changes
git checkout main
git pull origin main

# Run demo script
./test-java-governance.sh | grep -A 5 "SECURITY SCAN"
```

**Expected output:**
```
⏭️  SKIPPING SECURITY SCAN (SNYK)
   Reason: disabled in governance config
```

**This proves governance configs control the pipeline! ✅**

---

### 10. Verify Audit Trail

```bash
# View PR with full history
gh pr view 1 --comments

# Or on GitHub web
# https://github.com/suryap-kr/ngpos-pipeline-governance-agent-poc/pull/1
```

**Audit trail shows:**
- Who made the change
- What was changed
- Why they changed it
- Who approved
- Why they approved
- When it was merged

---

## 🧹 Cleanup (Optional)

```bash
# Re-enable Snyk
git checkout main
sed -i '' 's/enabled=false/enabled=true/' governance/ngpos-java-reference/snyk.properties
git add governance/ngpos-java-reference/snyk.properties
git commit -m "Re-enable Snyk security scanning after demo"
git push origin main
```

---

## ✅ Success Checklist

After running all commands:

- [ ] Repository exists on GitHub
- [ ] @HarshitaY-KR is a collaborator
- [ ] Branch protection is enabled with "Require review from Code Owners"
- [ ] Test PR created and blocked by GitHub
- [ ] PR shows "Review required" status
- [ ] @HarshitaY-KR is requested as reviewer
- [ ] After approval, merge button becomes enabled
- [ ] PR successfully merged
- [ ] `./test-java-governance.sh` shows Snyk is skipped
- [ ] Audit trail visible on PR

---

## 📊 What This Proves

✓ **Developer cannot merge** without EM approval (merge button disabled)
✓ **GitHub automatically requests** review from @HarshitaY-KR (CODEOWNERS working)
✓ **Complete audit trail** (who, what, when, why documented)
✓ **Governance controls pipeline** (enabled=false → Snyk skipped)

---

## 🆘 If Something Fails

**Problem: gh command not found**
```bash
brew install gh
gh auth login
```

**Problem: Branch protection doesn't block**
- Go to Settings → Branches → Edit rule
- Ensure "Require review from Code Owners" is checked

**Problem: @HarshitaY-KR not requested**
- Verify user has accepted collaborator invitation
- Check CODEOWNERS file syntax
- Ensure file is in `.github/CODEOWNERS` not root

**Problem: Can't push**
```bash
gh auth refresh
```

---

**Ready to start? Copy the commands above!**
