# GitHub Approval Flow - Visual Guide

Visual representation of how CODEOWNERS enforces governance approval.

---

## 🔄 Complete Approval Flow

```
┌─────────────────────────────────────────────────────────────────┐
│                    STEP 1: DEVELOPER MAKES CHANGE               │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
                    ┌─────────────────┐
                    │   Developer     │
                    │   Changes:      │
                    │   enabled=false │
                    └─────────────────┘
                              │
                              ▼
                ┌──────────────────────────┐
                │  git add                 │
                │  git commit              │
                │  git push                │
                └──────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                    STEP 2: CREATE PULL REQUEST                  │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
                    ┌─────────────────┐
                    │  GitHub PR      │
                    │  Created        │
                    └─────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                 STEP 3: GITHUB CHECKS CODEOWNERS                │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
              ┌───────────────────────────────┐
              │ GitHub scans changed files:   │
              │                               │
              │ governance/ngpos-java-        │
              │   reference/snyk.properties   │
              │                               │
              │ Checks .github/CODEOWNERS:    │
              │ /governance/ngpos-java-       │
              │   reference/ @HarshitaY-KR    │
              └───────────────────────────────┘
                              │
                              ▼
              ┌───────────────────────────────┐
              │ 🔴 MATCH FOUND!               │
              │                               │
              │ This file requires approval   │
              │ from: @HarshitaY-KR          │
              └───────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                  STEP 4: GITHUB BLOCKS MERGE                    │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
              ┌───────────────────────────────┐
              │  PR Status:                   │
              │  ⚠️  Review Required          │
              │                               │
              │  Reviewers:                   │
              │  👤 @HarshitaY-KR (requested) │
              │                               │
              │  🔴 Merge: BLOCKED            │
              │  [ Merge PR ]  ← DISABLED     │
              └───────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│              STEP 5: EM RECEIVES REVIEW REQUEST                 │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
                    ┌─────────────────┐
                    │  @HarshitaY-KR  │
                    │  receives:      │
                    │  📧 Email       │
                    │  🔔 Notification│
                    └─────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                    STEP 6: EM REVIEWS CHANGE                    │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
                    ┌─────────────────┐
                    │  EM Reviews:    │
                    │  - What changed │
                    │  - Why changed  │
                    │  - Impact       │
                    └─────────────────┘
                              │
                ┌─────────────┴─────────────┐
                │                           │
                ▼                           ▼
        ┌──────────────┐          ┌──────────────┐
        │   REJECT ❌  │          │  APPROVE ✅  │
        │              │          │              │
        │ Request      │          │ Click:       │
        │ Changes      │          │ "Approve"    │
        └──────────────┘          └──────────────┘
                │                           │
                │                           ▼
                │              ┌──────────────────────┐
                │              │  ✅ Approved         │
                │              │                      │
                │              │  Merge: UNBLOCKED    │
                │              │  [ Merge PR ] ← ON   │
                │              └──────────────────────┘
                │                           │
                │                           ▼
                │              ┌──────────────────────┐
                │              │  Developer can now   │
                │              │  merge the PR        │
                │              └──────────────────────┘
                │                           │
                ▼                           ▼
┌─────────────────────────────────────────────────────────────────┐
│                      AUDIT TRAIL CREATED                        │
│                                                                 │
│  PR #123: Temporarily disable Snyk                             │
│  │                                                              │
│  ├─ 👤 Opened by: developer-name                               │
│  ├─ 📝 Changes: enabled=true → enabled=false                   │
│  ├─ 💬 Justification: "Urgent release needed"                  │
│  ├─ 👤 Reviewed by: @HarshitaY-KR                              │
│  ├─ ✅ Decision: Approved with conditions                      │
│  ├─ 📅 Approved: 2026-06-22 14:30 UTC                          │
│  └─ 🔀 Merged: 2026-06-22 14:32 UTC                            │
│                                                                 │
│  Permanent record for compliance audits                        │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🎯 Key Decision Points

### Point 1: GitHub Auto-Detection (Step 3)
```
File changed: governance/ngpos-java-reference/snyk.properties
              ↓
Checks CODEOWNERS: /governance/ngpos-java-reference/ @HarshitaY-KR
              ↓
MATCH! → Automatically request review
```

**Automatic - No manual intervention needed**

---

### Point 2: Merge Blocking (Step 4)
```
Is required reviewer approved?
    │
    ├─ YES → Merge button ENABLED ✅
    │
    └─ NO  → Merge button DISABLED ❌
```

**Cannot be bypassed - Even by admins**

---

### Point 3: EM Decision (Step 6)
```
Review governance change
    │
    ├─ Approve → PR can be merged
    │    └─ Creates audit trail
    │
    └─ Reject → Developer must revise
         └─ PR stays open
```

**EM accountability - Decision is documented**

---

## 📊 Comparison: Before vs After

### Before Governance (No CODEOWNERS)
```
Developer                          Main Branch
    │                                  │
    ├─ Change governance config        │
    ├─ Commit                          │
    ├─ Push to branch                  │
    ├─ Create PR                       │
    ├─ Merge (no approval needed) ─────┤
    │                                  │
    └─────────────────────────────> MERGED
                                   (Security disabled!)

❌ No review required
❌ No approval needed
❌ No audit trail
```

### After Governance (With CODEOWNERS)
```
Developer           GitHub              EM                Main Branch
    │                  │                 │                    │
    ├─ Change config   │                 │                    │
    ├─ Commit          │                 │                    │
    ├─ Push to branch  │                 │                    │
    ├─ Create PR ──────┤                 │                    │
    │                  ├─ Request review ┤                    │
    │                  ├─ Block merge    │                    │
    │                  │                 ├─ Review change     │
    │                  │                 ├─ Approve/Reject    │
    │                  │<────────────────┤                    │
    │                  ├─ Unblock merge  │                    │
    ├─ Merge ──────────┼─────────────────┼────────────────────┤
    │                  │                 │                MERGED
    │                  │                 │             (With EM approval)
    │                  │                 │
    └──────────────────┴─────────────────┴────> Audit Trail Created

✅ Review required
✅ EM approval needed
✅ Complete audit trail
```

---

## 🔒 Security Guarantees

### What CODEOWNERS Prevents

❌ **Developer cannot:**
- Merge governance changes without EM approval
- Bypass review by deleting/recreating PR
- Override CODEOWNERS protection
- Merge even with admin privileges (if branch protection enabled)

✅ **System enforces:**
- Required review from specified owners
- Blocking merge until approval
- Audit trail of all approvals
- No backdoor bypasses

---

## 📋 Example PR States

### State 1: Awaiting Review
```
┌─────────────────────────────────────────────┐
│ PR #42: Disable Snyk scanning               │
├─────────────────────────────────────────────┤
│ Status: 🔴 Changes requested                │
│                                             │
│ Reviewers:                                  │
│ 👤 @HarshitaY-KR (review requested)         │
│                                             │
│ Checks:                                     │
│ ⚠️  Review required                         │
│                                             │
│ [  Merge pull request  ] ← DISABLED         │
└─────────────────────────────────────────────┘
```

### State 2: After Approval
```
┌─────────────────────────────────────────────┐
│ PR #42: Disable Snyk scanning               │
├─────────────────────────────────────────────┤
│ Status: ✅ Approved                         │
│                                             │
│ Reviewers:                                  │
│ ✅ @HarshitaY-KR approved 5 min ago         │
│                                             │
│ Checks:                                     │
│ ✅ All checks passed                        │
│                                             │
│ [  Merge pull request ▼ ] ← ENABLED        │
└─────────────────────────────────────────────┘
```

### State 3: After Rejection
```
┌─────────────────────────────────────────────┐
│ PR #42: Disable Snyk scanning               │
├─────────────────────────────────────────────┤
│ Status: ❌ Changes requested                │
│                                             │
│ Reviewers:                                  │
│ ❌ @HarshitaY-KR requested changes          │
│                                             │
│ 💬 "Cannot approve disabling security.     │
│     Please fix vulnerabilities instead."    │
│                                             │
│ Checks:                                     │
│ ⚠️  Review required                         │
│                                             │
│ [  Merge pull request  ] ← DISABLED         │
└─────────────────────────────────────────────┘
```

---

## 🎓 For Presentation

### Slide 1: The Problem
- Show "Before" flow
- Highlight: No approval, no oversight

### Slide 2: The Solution
- Show "After" flow
- Highlight: EM approval required, audit trail

### Slide 3: Live Demo
- Create PR changing governance
- Show GitHub blocking merge
- Show review request to EM

### Slide 4: Audit Trail
- Show PR history
- Highlight who approved and why

### Slide 5: Impact
- Security: Cannot disable scanning without EM approval
- Compliance: Complete audit trail
- Consistency: Centralized governance

---

**Visual Aid:** Print this flow diagram for stakeholder presentations
**Duration:** 2 minutes to explain the flow
**Complexity:** Easy to understand (non-technical audiences)
