#!/bin/bash

# REAL GitHub Approval Flow - Executable Commands
# Run each command one by one and verify output

set -e

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "STEP 1: Create GitHub Repo & Push"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Run this command:"
echo ""
echo "gh repo create ngpos-pipeline-governance-agent-poc \\"
echo "  --public \\"
echo "  --source=. \\"
echo "  --remote=origin \\"
echo "  --push \\"
echo "  --description \"Pipeline Governance POC - CODEOWNERS Demo\""
echo ""
read -p "Press ENTER after running command 1..."

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "STEP 2: Add Collaborator"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "gh api repos/:owner/:repo/collaborators/HarshitaY-KR --method PUT -f permission=write"
echo ""
read -p "Press ENTER after running command 2..."

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "STEP 3: Configure Branch Protection (MANUAL)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Open browser: gh repo view --web"
echo ""
echo "Then:"
echo "1. Go to Settings → Branches"
echo "2. Click 'Add rule'"
echo "3. Branch name pattern: main"
echo "4. Check:"
echo "   ✓ Require a pull request before merging"
echo "   ✓ Require review from Code Owners"
echo "   ✓ Include administrators"
echo "5. Click 'Create'"
echo ""
read -p "Press ENTER after configuring branch protection..."

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "STEP 4: Verify Branch Protection"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
gh api repos/:owner/:repo/branches/main/protection --jq '.required_pull_request_reviews.require_code_owner_reviews'
echo ""
read -p "Should show 'true'. Press ENTER to continue..."

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "STEP 5-9: Create Test PR"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
git checkout -b disable-snyk-demo
sed -i '' 's/enabled=true/enabled=false/' governance/ngpos-java-reference/snyk.properties
echo ""
echo "Change made:"
git diff governance/ngpos-java-reference/snyk.properties
echo ""
git add governance/ngpos-java-reference/snyk.properties
git commit -m "Disable Snyk scanning temporarily"
git push origin disable-snyk-demo
echo ""

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "STEP 10: Create Pull Request"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
gh pr create \
  --title "Disable Snyk security scanning" \
  --body "Need to disable Snyk for urgent release. @HarshitaY-KR please approve." \
  --base main \
  --head disable-snyk-demo
echo ""

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "STEP 11-12: Check PR Status (SHOULD BE BLOCKED)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
gh pr view
echo ""
gh pr view --json mergeStateStatus,mergeable
echo ""

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "STEP 13: View in Browser"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Opening PR in browser..."
gh pr view --web
echo ""
echo "You should see:"
echo "⚠️  Review required"
echo "👤 HarshitaY-KR (review requested)"
echo "[  Merge pull request  ] ← DISABLED"
echo ""

echo "✅ DEMO COMPLETE!"
echo ""
echo "Next: Have @HarshitaY-KR approve the PR to unblock merge"
