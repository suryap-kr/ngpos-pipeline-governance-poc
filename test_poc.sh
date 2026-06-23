#!/bin/bash
# Quick test script for the NGPOS Pipeline Governance Agent POC

set -e

echo "====================================="
echo "NGPOS Pipeline Governance Agent POC"
echo "Test Script"
echo "====================================="
echo ""

# Create test repository structure
echo "Creating test repository structure..."
TEST_REPO="test-repo"
rm -rf "$TEST_REPO"
mkdir -p "$TEST_REPO/.github/workflows"

# Copy example workflows
echo "Copying example workflows..."
cp examples/*.yml "$TEST_REPO/.github/workflows/"

echo ""
echo "Test repository created with the following workflows:"
ls -1 "$TEST_REPO/.github/workflows/"

echo ""
echo "====================================="
echo "Running governance analysis..."
echo "====================================="
echo ""

# Run the analyzer
python3 analyzer.py "$TEST_REPO"

echo ""
echo "====================================="
echo "Test complete!"
echo "====================================="
echo ""
echo "Check 'governance-report.md' for the full report."
echo ""
echo "To test on your own repository:"
echo "  python3 analyzer.py /path/to/your/repo"
echo ""
