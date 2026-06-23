# REAL GitHub Approval Flow - Implementation Guide

**Status:** ✅ Repository initialized locally (commit b6829d9)
**Next:** Push to GitHub and configure approval flow

---

## ✅ COMPLETED: Local Setup

```bash
✓ Git repository initialized
✓ All files committed (75 files, 7383 lines)
✓ CODEOWNERS configured with @HarshitaY-KR
✓ Governance configs created for all services
```

---

## 🚀 STEP 1: Push to GitHub

### Option A: Using GitHub CLI (Recommended)

```bash
# Install GitHub CLI if needed
# macOS: brew install gh
# Then authenticate
gh auth login

# Create repo and push in one command
gh repo create ngpos-pipeline-governance-agent-poc \
  --public \
  --source=. \
  --remote=origin \
  --push \
  --description "Pipeline Governance POC with CODEOWNERS enforcement"
```

**Expected Output:**
```
✓ Created repository YourUsername/ngpos-pipeline-governance-agent-poc on GitHub
✓ Added remote https://github.com/YourUsername/ngpos-pipeline-governance-agent-poc.git
✓ Pushed commits to https://github.com/YourUsername/ngpos-pipeline-governance-agent-poc.git
```

### Option B: Manual via GitHub Web UI

**1. Create repository on GitHub:**
- Go to: https://github.com/new
- Repository name: `ngpos-pipeline-governance-agent-poc`
- Description: `Pipeline Governance POC with CODEOWNERS enforcement`
- Visibility: **Public** (or Private)
- **DO NOT** check "Initialize this repository with a README"
- Click "Create repository"

**2. Add remote and push:**

```bash
# Replace YOUR_USERNAME with your GitHub username
git remote add origin https://github.com/YOUR_USERNAME/ngpos-pipeline-governance-agent-poc.git

# Or use SSH
git remote add origin git@github.com:YOUR_USERNAME/ngpos-pipeline-governance-agent-poc.git

# Push main branch
git push -u origin main
```

**Verify it worked:**
```bash
git remote -v
# Should show:
# origin  https://github.com/YOUR_USERNAME/ngpos-pipeline-governance-agent-poc.git (fetch)
# origin  https://github.com/YOUR_USERNAME/ngpos-pipeline-governance-agent-poc.git (push)
```

---

## 🔒 STEP 2: Add @HarshitaY-KR as Collaborator

**Before branch protection works, the user must have repo access.**

### Via GitHub CLI:
```bash
gh api repos/:owner/:repo/collaborators/HarshitaY-KR \
  --method PUT \
  -f permission=write
```

### Via GitHub Web UI:
1. Go to repository on GitHub
2. Click **Settings** tab
3. Click **Collaborators** (or **Collaborators and teams**)
4. Click **Add people**
5. Enter: `HarshitaY-KR`
6. Select permission: **Write**
7. Click **Add HarshitaY-KR to this repository**

**⚠️ IMPORTANT:** User must accept the invitation before CODEOWNERS will work!

---

## 🛡️ STEP 3: Configure Branch Protection

**This is CRITICAL - without this, CODEOWNERS won't block merges!**

### Via GitHub Web UI (Easier):

1. **Go to repository Settings:**
   - Navigate to your repo on GitHub
   - Click **Settings** tab
   - Click **Branches** in left sidebar

2. **Add branch protection rule:**
   - Click **Add rule** (or **Add branch protection rule**)

3. **Configure the rule:**

   **Branch name pattern:**
   ```
   main
   ```

   **Protect matching branches - Check these boxes:**

   ✅ **Require a pull request before merging**
      - Number of required approvals: `1`

   ✅ **Require review from Code Owners** ← **CRITICAL!**

   ✅ **Require status checks to pass before merging** (optional)

   ✅ **Require conversation resolution before merging** (optional)

   ✅ **Do not allow bypassing the above settings**

   ✅ **Include administrators** (prevents even admins from bypassing)

4. **Click "Create" or "Save changes"**

### Via GitHub CLI (Advanced):

```bash
# Enable branch protection with CODEOWNERS
gh api repos/:owner/:repo/branches/main/protection \
  --method PUT \
  --field required_pull_request_reviews[required_approving_review_count]=1 \
  --field required_pull_request_reviews[require_code_owner_reviews]=true \
  --field enforce_admins=true \
  --field restrictions=null
```

### Verify Branch Protection:

```bash
gh api repos/:owner/:repo/branches/main/protection \
  --jq '.required_pull_request_reviews.require_code_owner_reviews'

# Should return: true
```

---

## ✅ STEP 4: Verify Setup

Run these checks to ensure everything is configured:

```bash
# Check 1: Remote is configured
git remote -v

# Check 2: CODEOWNERS exists on GitHub
gh api repos/:owner/:repo/contents/.github/CODEOWNERS \
  --jq '.name'
# Should return: CODEOWNERS

# Check 3: Branch protection is enabled
gh api repos/:owner/:repo/branches/main/protection \
  --jq '.required_pull_request_reviews.require_code_owner_reviews'
# Should return: true

# Check 4: Collaborator has access
gh api repos/:owner/:repo/collaborators/HarshitaY-KR \
  --jq '.permissions'
# Should show permissions
```

---

## 🎬 STEP 5: Create Test PR (The Real Demo!)

Now let's create a REAL pull request that GitHub will block.

### 5.1: Create Feature Branch

```bash
# Ensure you're on main and up to date
git checkout main
git pull origin main

# Create new branch
git checkout -b disable-snyk-for-demo

# Verify you're on new branch
git branch
# Should show: * disable-snyk-for-demo
```

### 5.2: Modify Governance Config

```bash
# Disable Snyk security scanning
sed -i '' 's/enabled=true/enabled=false/' governance/ngpos-java-reference/snyk.properties

# Verify the change
git diff governance/ngpos-java-reference/snyk.properties
```

**Expected diff:**
```diff
 # Snyk Security Scanning Configuration
-enabled=true
+enabled=false
 failOnError=true
```

### 5.3: Commit the Change

```bash
git add governance/ngpos-java-reference/snyk.properties

git commit -m "Disable Snyk scanning temporarily

Need to speed up pipeline for urgent release.
Will re-enable after deployment."

# Verify commit
git log -1 --oneline
```

### 5.4: Push Branch to GitHub

```bash
git push origin disable-snyk-for-demo
```

**Expected Output:**
```
Enumerating objects: X, done.
...
To github.com:YOUR_USERNAME/ngpos-pipeline-governance-agent-poc.git
 * [new branch]      disable-snyk-for-demo -> disable-snyk-for-demo
```

### 5.5: Create Pull Request

**Option A: Via GitHub CLI (Recommended)**

```bash
gh pr create \
  --title "Disable Snyk security scanning temporarily" \
  --body "## Why
Need to speed up pipeline for urgent release.

## Changes
- Changed \`enabled=true\` to \`enabled=false\` in \`governance/ngpos-java-reference/snyk.properties\`

## Plan
Will re-enable after this release is deployed.

## Request
@HarshitaY-KR - Please approve for temporary use." \
  --base main \
  --head disable-snyk-for-demo
```

**Option B: Via GitHub Web UI**

1. Go to your repository on GitHub
2. GitHub will show yellow banner: "disable-snyk-for-demo had recent pushes"
3. Click **"Compare & pull request"**
4. Fill in:
   - **Title:** `Disable Snyk security scanning temporarily`
   - **Description:**
     ```markdown
     ## Why
     Need to speed up pipeline for urgent release.

     ## Changes
     - Changed `enabled=true` to `enabled=false` in `governance/ngpos-java-reference/snyk.properties`

     ## Plan
     Will re-enable after this release is deployed.

     ## Request
     @HarshitaY-KR - Please approve for temporary use.
     ```
5. Click **"Create pull request"**

---

## 🔴 STEP 6: Observe GitHub Blocking the Merge

**What happens automatically:**

1. **GitHub analyzes the PR:**
   - Detects file changed: `governance/ngpos-java-reference/snyk.properties`
   - Checks `.github/CODEOWNERS`
   - Finds rule: `/governance/ngpos-java-reference/ @HarshitaY-KR`

2. **GitHub automatically requests review:**
   - Adds @HarshitaY-KR as required reviewer
   - Sends notification email to @HarshitaY-KR
   - Shows notification in their GitHub UI

3. **GitHub blocks merge:**
   - Merge button is **DISABLED** (grayed out)
   - Shows message: "Review required"
   - Shows: "At least 1 approving review is required"

**On the PR page, you'll see:**

```
┌─────────────────────────────────────────────────┐
│ ⚠️  Review required                             │
│                                                 │
│ At least 1 approving review is required by     │
│ reviewers with write access.                    │
│                                                 │
│ Reviewers:                                      │
│ 👤 HarshitaY-KR (review requested)              │
└─────────────────────────────────────────────────┘
```

**At the bottom:**

```
┌─────────────────────────────────────────────────┐
│ This branch has no conflicts with the base      │
│ branch                                          │
│                                                 │
│ ⚠️  Merging is blocked                          │
│                                                 │
│ Review required                                 │
│ At least 1 approving review is required by     │
│ reviewers with write access.                    │
│                                                 │
│ [  Merge pull request  ]  ← BUTTON IS GRAYED   │
└─────────────────────────────────────────────────┘
```

### Verify via CLI:

```bash
# View PR status
gh pr view

# Check if mergeable
gh pr view --json mergeable,mergeStateStatus

# Should show:
# {
#   "mergeable": "UNKNOWN",
#   "mergeStateStatus": "BLOCKED"
# }
```

---

## 👤 STEP 7: @HarshitaY-KR Reviews the PR

**What @HarshitaY-KR sees:**

1. **Email notification:**
   - Subject: "Review requested: Disable Snyk security scanning temporarily"
   - From: GitHub
   - Contains link to PR

2. **On GitHub:**
   - Notification bell shows new notification
   - PR shows they're requested as reviewer

**@HarshitaY-KR's workflow:**

### 7.1: View the PR

```bash
# As HarshitaY-KR
gh pr view <PR_NUMBER>
```

### 7.2: Review the changes

```
Files changed (1)
└── governance/ngpos-java-reference/snyk.properties

@@ -1,5 +1,5 @@
 # Snyk Security Scanning Configuration
-enabled=true
+enabled=false
 failOnError=true
```

### 7.3: Make Decision

**Option 1: Approve the change**

```bash
# Via CLI
gh pr review <PR_NUMBER> --approve --body "Approved with conditions:
1. Must be re-enabled within 24 hours
2. Create follow-up issue to track
3. Manual security review required before release"
```

**Via Web UI:**
1. Click **"Files changed"** tab
2. Click **"Review changes"** button (top right)
3. Select **"Approve"**
4. Add comment with conditions
5. Click **"Submit review"**

**Option 2: Request changes**

```bash
# Via CLI
gh pr review <PR_NUMBER> --request-changes --body "Cannot approve disabling security scanning.

Alternative solutions:
1. Fix the vulnerabilities
2. Add exceptions to Snyk ignore file
3. Temporarily increase threshold, don't disable entirely"
```

---

## ✅ STEP 8: After Approval - Merge is Unblocked

**Once @HarshitaY-KR approves:**

```
┌─────────────────────────────────────────────────┐
│ ✅ HarshitaY-KR approved these changes          │
│ 5 minutes ago                                   │
│                                                 │
│ "Approved with conditions:                      │
│  1. Must be re-enabled within 24 hours          │
│  2. Create follow-up issue to track             │
│  3. Manual security review required"            │
└─────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────┐
│ ✅ All checks have passed                       │
│                                                 │
│ [  Merge pull request ▼ ]  ← NOW ENABLED!      │
└─────────────────────────────────────────────────┘
```

**Merge the PR:**

```bash
# Developer can now merge
gh pr merge <PR_NUMBER> --squash --delete-branch
```

---

## 📊 STEP 9: Verify Audit Trail

After merging, anyone can see the complete history:

```bash
# View PR details including approvals
gh pr view <PR_NUMBER>

# View all comments and reviews
gh pr view <PR_NUMBER> --comments
```

**Audit trail shows:**
- ✅ Who made the change (Developer)
- ✅ What was changed (enabled=false)
- ✅ Why they wanted to change it (Urgent release)
- ✅ Who reviewed it (@HarshitaY-KR)
- ✅ Why they approved (Comment with conditions)
- ✅ When it was approved (Timestamp)
- ✅ When it was merged (Timestamp)

**This is permanent and compliance-ready!**

---

## 🎯 STEP 10: Demo the Pipeline Control

Show that governance actually controls the pipeline:

```bash
# Pull the merged changes
git checkout main
git pull origin main

# Run the demo script
./test-java-governance.sh | grep -A 5 "SECURITY SCAN"
```

**Output will show:**
```
⏭️  SKIPPING SECURITY SCAN (SNYK)
   Reason: disabled in governance config
```

**This proves governance configs control pipeline behavior!**

---

## 🧹 Cleanup After Demo

```bash
# Delete the branch (if not auto-deleted)
git branch -D disable-snyk-for-demo
git push origin --delete disable-snyk-for-demo

# Restore snyk.properties to enabled
git checkout main
sed -i '' 's/enabled=false/enabled=true/' governance/ngpos-java-reference/snyk.properties
git add governance/ngpos-java-reference/snyk.properties
git commit -m "Re-enable Snyk security scanning"
git push origin main
```

---

## ⚡ Quick Command Reference

```bash
# Setup (one time)
gh repo create ngpos-pipeline-governance-agent-poc --public --source=. --push
gh api repos/:owner/:repo/collaborators/HarshitaY-KR --method PUT -f permission=write
# Then configure branch protection via UI

# Create demo PR
git checkout -b disable-snyk-for-demo
sed -i '' 's/enabled=true/enabled=false/' governance/ngpos-java-reference/snyk.properties
git add governance/ngpos-java-reference/snyk.properties
git commit -m "Disable Snyk temporarily"
git push origin disable-snyk-for-demo
gh pr create --title "Disable Snyk" --base main --head disable-snyk-for-demo

# Check PR status
gh pr view
gh pr view --json mergeable,mergeStateStatus

# As @HarshitaY-KR - Approve
gh pr review <PR_NUMBER> --approve --body "Approved with conditions"

# Merge
gh pr merge <PR_NUMBER> --squash --delete-branch

# Verify
./test-java-governance.sh
```

---

## 🎤 Presentation Flow

**1. Show the setup (2 min):**
- Show CODEOWNERS file: `cat .github/CODEOWNERS | grep java`
- Show governance config: `cat governance/ngpos-java-reference/snyk.properties`

**2. Create PR live (3 min):**
- Run commands to create branch, change config, push
- Create PR via CLI or UI

**3. Show GitHub blocking (2 min):**
- Navigate to PR on GitHub
- Point out "Review required" message
- Show merge button is disabled
- Show @HarshitaY-KR is requested as reviewer

**4. Show approval flow (2 min):**
- (Have @HarshitaY-KR approve beforehand, or simulate)
- Show how merge button becomes enabled after approval

**5. Show audit trail (1 min):**
- Show PR history with approval
- Show who approved and why

**6. Show pipeline impact (1 min):**
- Run `./test-java-governance.sh`
- Show Snyk is skipped

**Total: 10-11 minutes**

---

## ✅ Success Criteria

After completing these steps, you should have:

- [x] Repository on GitHub
- [x] @HarshitaY-KR as collaborator
- [x] Branch protection enabled
- [x] CODEOWNERS enforcing reviews
- [x] Test PR created
- [x] PR blocked until approval
- [x] Complete audit trail
- [x] Proof that governance controls pipeline

---

**Last Updated:** 2026-06-22
**Status:** Ready for implementation
**Prerequisites:** GitHub account, gh CLI (optional)
