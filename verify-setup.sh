#!/bin/bash

# Verification script for GitHub approval flow setup

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "GITHUB APPROVAL FLOW - SETUP VERIFICATION"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check 1: Git initialized
echo "1. Git Repository"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if git rev-parse --git-dir > /dev/null 2>&1; then
    echo -e "${GREEN}✓${NC} Git repository initialized"
    git log -1 --oneline
else
    echo -e "${RED}✗${NC} Not a git repository"
fi
echo ""

# Check 2: CODEOWNERS exists
echo "2. CODEOWNERS File"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if [ -f ".github/CODEOWNERS" ]; then
    echo -e "${GREEN}✓${NC} CODEOWNERS file exists"
    java_rules=$(grep -c "ngpos-java-reference.*@HarshitaY-KR" .github/CODEOWNERS)
    echo -e "${GREEN}✓${NC} Found $java_rules rules for ngpos-java-reference with @HarshitaY-KR"
else
    echo -e "${RED}✗${NC} CODEOWNERS file not found"
fi
echo ""

# Check 3: Governance configs exist
echo "3. Governance Configurations"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
java_configs=$(ls governance/ngpos-java-reference/*.properties 2>/dev/null | wc -l)
if [ "$java_configs" -eq 6 ]; then
    echo -e "${GREEN}✓${NC} All 6 Java reference configs exist"
    ls governance/ngpos-java-reference/*.properties | sed 's/^/  /'
else
    echo -e "${RED}✗${NC} Missing Java reference configs (found: $java_configs, expected: 6)"
fi
echo ""

# Check 4: Demo script exists and is executable
echo "4. Demo Script"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if [ -x "test-java-governance.sh" ]; then
    echo -e "${GREEN}✓${NC} test-java-governance.sh exists and is executable"
else
    echo -e "${RED}✗${NC} test-java-governance.sh not found or not executable"
fi
echo ""

# Check 5: GitHub remote
echo "5. GitHub Remote"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if git remote -v | grep -q origin; then
    echo -e "${GREEN}✓${NC} Remote 'origin' configured"
    git remote -v | grep origin | head -1
else
    echo -e "${YELLOW}⚠${NC} Remote 'origin' not configured yet"
    echo "   Run: gh repo create ngpos-pipeline-governance-agent-poc --public --source=. --push"
fi
echo ""

# Check 6: GitHub CLI
echo "6. GitHub CLI"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if command -v gh &> /dev/null; then
    echo -e "${GREEN}✓${NC} GitHub CLI installed: $(gh --version | head -1)"
    if gh auth status &> /dev/null; then
        echo -e "${GREEN}✓${NC} Authenticated with GitHub"
        gh auth status | grep "Logged in" | head -1
    else
        echo -e "${YELLOW}⚠${NC} Not authenticated with GitHub"
        echo "   Run: gh auth login"
    fi
else
    echo -e "${YELLOW}⚠${NC} GitHub CLI not installed"
    echo "   Install: brew install gh"
fi
echo ""

# Summary
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "SUMMARY"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

if [ -d ".git" ] && [ -f ".github/CODEOWNERS" ] && [ "$java_configs" -eq 6 ]; then
    echo -e "${GREEN}✓ Local setup complete${NC}"
    echo ""
    if git remote -v | grep -q origin; then
        echo -e "${GREEN}✓ Ready for GitHub push${NC}"
        echo ""
        echo "Next steps:"
        echo "1. Configure branch protection (see IMPLEMENTATION-GUIDE.md)"
        echo "2. Create test PR to verify CODEOWNERS blocking"
    else
        echo "Next steps:"
        echo "1. Push to GitHub: gh repo create ... (see output above)"
        echo "2. Add collaborator: gh api repos/:owner/:repo/collaborators/HarshitaY-KR"
        echo "3. Configure branch protection (see IMPLEMENTATION-GUIDE.md)"
    fi
else
    echo -e "${RED}✗ Setup incomplete${NC}"
    echo "Please fix the issues above"
fi
echo ""
