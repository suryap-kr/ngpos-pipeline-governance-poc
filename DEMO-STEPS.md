# Pipeline Governance POC - Demo Steps

A step-by-step guide for demonstrating how CODEOWNERS enforces governance controls.

---

## 🎯 Demo Scenario

**Situation:** A developer wants to temporarily disable Snyk security scanning to speed up their pipeline. Without governance controls, they could simply change the config and merge. With governance, an Engineering Manager must approve this change.

**Actors:**
- **Developer:** Tries to disable Snyk scanning
- **Engineering Manager (@HarshitaY-KR):** Reviews and approves/rejects governance changes
- **GitHub:** Enforces CODEOWNERS approval rules

---

## 📋 Prerequisites (Before Demo)

```bash
# 1. Ensure you're in the governance POC repository
cd /Users/Desktop/ngpos-pipeline-governance-agent-poc

# 2. Ensure you're on main branch and up to date
git checkout main
git pull origin main

# 3. Verify current Snyk config (should be enabled)
cat governance/ngpos-java-reference/snyk.properties | grep enabled
# Expected output: enabled=true

# 4. Verify CODEOWNERS is set up
cat .github/CODEOWNERS | grep "ngpos-java-reference"
# Should show @HarshitaY-KR as owner
```

---

## 🎬 Demo Part 1: Developer Attempts to Disable Governance

### Step 1: Developer Creates Feature Branch

```bash
# Create and switch to a new branch
git checkout -b disable-snyk-temporarily

# Verify you're on the new branch
git branch
# Should show: * disable-snyk-temporarily
```

**Talking Point:**
_"The developer creates a feature branch to disable Snyk scanning. They think this is a quick change to speed up the pipeline."_

---

### Step 2: Developer Modifies Governance Config

```bash
# Change enabled=true to enabled=false in Snyk config
sed -i '' 's/enabled=true/enabled=false/' governance/ngpos-java-reference/snyk.properties

# Verify the change
cat governance/ngpos-java-reference/snyk.properties | grep enabled
# Expected output: enabled=false
```

**Talking Point:**
_"The developer disables Snyk security scanning by changing `enabled=true` to `enabled=false`. Without governance, this could allow vulnerable code to be deployed."_

---

### Step 3: Show What the Change Looks Like

```bash
# Show the diff
git diff governance/ngpos-java-reference/snyk.properties
```

**Expected Output:**
```diff
 # Snyk Security Scanning Configuration
-enabled=true
+enabled=false
 failOnError=true
 reportOnly=false
```

**Talking Point:**
_"Notice this is a seemingly small change - just one line. But it has huge security implications. It completely disables vulnerability scanning."_

---

### Step 4: Developer Commits the Change

```bash
# Stage the changed file
git add governance/ngpos-java-reference/snyk.properties

# Commit with a message
git commit -m "Temporarily disable Snyk to speed up pipeline

Need to get a quick release out. Will re-enable after deployment."

# Verify the commit
git log -1 --oneline
```

**Talking Point:**
_"The developer commits the change with a justification - they need a quick release. This sounds reasonable, but bypassing security is never okay."_

---

### Step 5: Developer Pushes to Remote

```bash
# Push the branch to remote (origin)
git push origin disable-snyk-temporarily
```

**Expected Output:**
```
Enumerating objects: X, done.
Counting objects: 100% (X/X), done.
...
To github.com:your-org/ngpos-pipeline-governance-agent-poc.git
 * [new branch]      disable-snyk-temporarily -> disable-snyk-temporarily
```

**Talking Point:**
_"The developer pushes their branch. At this point, the change is on GitHub, but not yet merged into main."_

---

## 🎬 Demo Part 2: Creating Pull Request

### Step 6: Create Pull Request via GitHub UI

**Option A: Using GitHub CLI (Recommended for Demo)**

```bash
# Create PR using GitHub CLI (if installed)
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

**Option B: Using GitHub Web UI**

1. Navigate to: `https://github.com/your-org/ngpos-pipeline-governance-agent-poc`
2. GitHub will show a yellow banner: "disable-snyk-temporarily had recent pushes"
3. Click **"Compare & pull request"**
4. Fill in PR details:
   - **Title:** `Temporarily disable Snyk security scanning`
   - **Description:**
     ```markdown
     ## Why
     Need to speed up pipeline for urgent release.

     ## Changes
     - Disabled Snyk security scanning in Java reference config

     ## Plan
     Will re-enable after this release is deployed.

     **Request:** Please approve for temporary use.
     ```
5. Click **"Create pull request"**

**Talking Point:**
_"The developer creates a pull request. They've written a convincing justification about urgent release timelines."_

---

### Step 7: GitHub Automatically Requests CODEOWNER Review

**What Happens Automatically:**

When the PR is created, GitHub will:

1. ✅ Analyze which files changed
2. ✅ Find `governance/ngpos-java-reference/snyk.properties` in the changeset
3. ✅ Look up `.github/CODEOWNERS`
4. ✅ Find that `/governance/ngpos-java-reference/` requires `@HarshitaY-KR`
5. ✅ **Automatically request review from @HarshitaY-KR**
6. ✅ **Block merge until review is approved**

**On the PR page, you'll see:**

```
┌─────────────────────────────────────────────────────────┐
│ 🔴 Review required                                      │
│                                                         │
│ At least 1 approving review is required by reviewers   │
│ with write access.                                      │
│                                                         │
│ Reviewers: @HarshitaY-KR (requested)                   │
└─────────────────────────────────────────────────────────┘
```

**And at the bottom:**

```
┌─────────────────────────────────────────────────────────┐
│ ⚠️  Merging is blocked                                  │
│                                                         │
│ Review required                                         │
│ At least 1 approving review is required by reviewers   │
│ with write access.                                      │
│                                                         │
│ [ Merge pull request ]  ← BUTTON IS DISABLED/GRAYED OUT│
└─────────────────────────────────────────────────────────┘
```

**Talking Point:**
_"GitHub immediately recognizes this change touches a CODEOWNERS-protected file. The merge button is disabled. The developer CANNOT merge this, even if they're an admin. The Engineering Manager MUST approve."_

---

## 🎬 Demo Part 3: Engineering Manager Review

### Step 8: EM Reviews the Pull Request

**What @HarshitaY-KR sees:**

1. Email notification: "You were requested to review a pull request"
2. GitHub notification: Review request
3. On the PR page, they see:
   - The developer's justification
   - The code changes (enabled=true → enabled=false)
   - They are listed as a required reviewer

**EM Review Process:**

```
Files changed (1)
└── governance/ngpos-java-reference/snyk.properties

@@ -1,5 +1,5 @@
 # Snyk Security Scanning Configuration
-enabled=true
+enabled=false
 failOnError=true
```

**Talking Point:**
_"The Engineering Manager reviews the change. They can see exactly what's being changed - security scanning is being disabled. Now they must decide: approve or reject?"_

---

### Step 9: EM Decision Point

**Option A: EM Rejects the Change ❌**

The EM adds a review comment:

```
**Review Decision: REQUEST CHANGES**

❌ I cannot approve disabling security scanning, even temporarily.

**Alternative Solutions:**
1. Fix the vulnerabilities that are causing the pipeline to fail
2. If specific vulnerabilities are false positives, add them to Snyk ignore list
3. If time-sensitive, we can increase the threshold temporarily (e.g., max.critical.vulnerabilities=1)
   but NOT disable scanning entirely

Please update the PR with one of these approaches instead.
```

**Result:** Developer must change their approach

---

**Option B: EM Approves with Conditions ✅**

The EM adds a review comment:

```
**Review Decision: APPROVED**

✅ Approved with the following conditions:

1. ⏰ This must be re-enabled within 24 hours
2. 📝 Create a follow-up issue to re-enable: #123
3. 🔍 Manual security review required before release
4. 📊 Add comment in config with expiry date

I'm approving because [valid business reason], but this is an exception, not standard practice.
```

**Then clicks:** `Review changes` → `Approve` → `Submit review`

**Talking Point:**
_"If the EM decides to approve (with conditions), they document their reasoning and requirements. This creates an audit trail."_

---

### Step 10: What Happens After Approval

**When EM approves:**

```
✅ @HarshitaY-KR approved these changes [timestamp]

[Review comment appears here]
```

**And at the bottom:**

```
┌─────────────────────────────────────────────────────────┐
│ ✅ All checks have passed                               │
│                                                         │
│ 1 approving review from @HarshitaY-KR                  │
│                                                         │
│ [ Merge pull request ▼ ]  ← BUTTON IS NOW ENABLED     │
└─────────────────────────────────────────────────────────┘
```

**Now the developer can merge!**

**Talking Point:**
_"Only after EM approval does the merge button become enabled. The developer can now merge, but there's a clear audit trail showing who approved weakening security and why."_

---

## 🎬 Demo Part 4: Audit Trail

### Step 11: Show the Audit Trail

**After the PR is merged, anyone can see:**

```bash
# View the PR history (if using GitHub CLI)
gh pr view 123

# Or view in GitHub UI
```

**Audit Trail Shows:**
1. ✅ **Who** made the change (Developer)
2. ✅ **What** was changed (Snyk disabled)
3. ✅ **Why** they wanted to change it (Urgent release)
4. ✅ **Who approved** it (@HarshitaY-KR)
5. ✅ **Why they approved** (EM's review comment)
6. ✅ **When** it was merged (Timestamp)

**Talking Point:**
_"Six months from now, during a security audit, we can prove exactly who approved lowering security standards and why. This is compliance-ready documentation."_

---

## 🎬 Demo Part 5: Show Governance in Action

### Step 12: Run the Pipeline Demo Script

```bash
# Clean up: Restore original config
git checkout main
git pull origin main

# Show that governance now controls pipeline
./test-java-governance.sh
```

**Before the change (enabled=true):**
```
✅ RUNNING SECURITY SCAN (SNYK)
   Scanning dependencies for security vulnerabilities
```

**If the change was merged (enabled=false):**
```
⏭️  SKIPPING SECURITY SCAN (SNYK)
   Reason: disabled in governance config
```

**Talking Point:**
_"The governance config directly controls what runs in the pipeline. Because the config said enabled=false, Snyk is now skipped. This demonstrates that governance truly controls pipeline behavior."_

---

## 📊 Demo Summary: Key Points

### Before Governance (The Problem)
❌ Developer could disable security scanning with no oversight
❌ No approval required for lowering quality thresholds
❌ No audit trail for governance changes
❌ Inconsistent standards across teams

### After Governance (The Solution)
✅ CODEOWNERS enforces EM approval for governance changes
✅ Developer cannot merge without explicit EM approval
✅ Complete audit trail (who, what, when, why)
✅ Centralized standards across all services

---

## 🔄 Cleanup After Demo

```bash
# If you created a PR but don't want to merge it
git checkout main
git branch -D disable-snyk-temporarily
git push origin --delete disable-snyk-temporarily

# Close the PR on GitHub without merging
gh pr close 123  # Use actual PR number

# Or via GitHub UI:
# Go to PR → Click "Close pull request" → Add comment explaining it was a demo
```

---

## 💡 Demo Variations

### Variation 1: Show Multiple Approvers
Change CODEOWNERS to require multiple approvers:
```
/governance/ngpos-java-reference/  @HarshitaY-KR @another-em
```
Now BOTH must approve before merge is allowed.

---

### Variation 2: Show Different Rejection Scenarios

**Scenario A: Lower Coverage Threshold**
```bash
sed -i '' 's/min.coverage.percentage=80/min.coverage.percentage=50/' \
  governance/ngpos-java-reference/unit-test.properties
```

**Scenario B: Allow Critical Vulnerabilities**
```bash
sed -i '' 's/max.critical.vulnerabilities=0/max.critical.vulnerabilities=10/' \
  governance/ngpos-java-reference/snyk.properties
```

**Scenario C: Disable Quality Gate**
```bash
sed -i '' 's/failOnError=true/failOnError=false/' \
  governance/ngpos-java-reference/sonar.properties
```

Each demonstrates governance protecting different aspects of the pipeline.

---

### Variation 3: Show Compliant Change

Developer wants to ADD a governance check, not weaken one:
```bash
# Add a new threshold
echo "max.medium.vulnerabilities=20" >> governance/ngpos-java-reference/snyk.properties
```

**EM is more likely to approve** because it strengthens security, but still requires review for consistency.

---

## 🎤 Presentation Tips

### Opening (2 minutes)
- Show the problem: "Currently, any developer can lower security standards"
- Show the solution: "CODEOWNERS enforces EM approval"

### Demo (5 minutes)
- Live demo: Create branch → Change config → Push → Create PR
- Show GitHub blocking the merge
- Show EM approval requirement

### Impact (2 minutes)
- Show audit trail
- Show governance controlling pipeline
- Emphasize compliance benefits

### Q&A Prep
**Q: "What if we need emergency changes?"**
A: EM can approve quickly via GitHub mobile. Average review time < 10 minutes.

**Q: "Does this slow down development?"**
A: Only for governance changes (rare). Normal code changes unaffected.

**Q: "What if EM is unavailable?"**
A: Multiple EMs can be owners. Add backup reviewers.

**Q: "Can developers bypass this?"**
A: No. Even repo admins cannot bypass CODEOWNERS if branch protection is enabled.

---

## 📁 Files Used in Demo

```
.github/CODEOWNERS                           ← Defines ownership rules
governance/ngpos-java-reference/*.properties ← Governance configs
test-java-governance.sh                      ← Shows config controlling pipeline
DEMO-STEPS.md                                ← This file
```

---

## ✅ Demo Checklist

**Before Presentation:**
- [ ] Repository is on GitHub (not just local)
- [ ] @HarshitaY-KR user exists and has access
- [ ] Branch protection rules are enabled (Settings → Branches)
- [ ] CODEOWNERS feature is enabled (it is by default)
- [ ] You have tested creating a PR and seeing the review requirement
- [ ] You have tested the approval flow
- [ ] `test-java-governance.sh` script works

**During Presentation:**
- [ ] Start on main branch
- [ ] Show current config (enabled=true)
- [ ] Create branch and make change
- [ ] Push and create PR
- [ ] Show merge is blocked
- [ ] (Optional) Have EM approve live, or show screenshot
- [ ] Show audit trail
- [ ] Run test script to show governance controlling pipeline

**After Presentation:**
- [ ] Clean up demo branches
- [ ] Close demo PRs
- [ ] Restore original configs

---

**Last Updated:** 2026-06-22
**Demo Duration:** 10-15 minutes
**Difficulty:** Easy (good for executive audiences)
**Prerequisites:** GitHub repository with branch protection enabled
