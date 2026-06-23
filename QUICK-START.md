# Quick Start Guide

## Installation

```bash
cd ngpos-pipeline-governance-agent-poc
pip install -r requirements.txt
```

## Single Repository Analysis

```bash
python3 analyzer.py /path/to/your/repo
```

**Generates:** `governance-report.md`

## Multi-Repository Analysis

### 1. Create repos.txt

```bash
cat > repos.txt << EOF
./repo1
./repo2
./repo3
EOF
```

### 2. Run Analysis

```bash
python3 analyzer.py repos.txt
```

**Generates:**
- `repo1-governance-report.md`
- `repo2-governance-report.md`
- `repo3-governance-report.md`
- `cross-repo-summary.md` ← **New cross-repo comparison!**

## What Gets Checked?

✅ PR-triggered workflow exists
✅ Blocking build/test gate exists
✅ Security scan exists (CodeQL, Snyk, Trivy, etc.)
✅ Quality scan exists (linting, SonarQube, etc.)
✅ Deploy workflow exists (optional)

## Cross-Repo Summary Includes

1. **Comparison Table** - Side-by-side view of all repos
2. **Common Patterns** - What most repos implement
3. **Outliers** - Repos that differ from the norm
4. **Gap Analysis** - Missing controls across organization
5. **Recommendations** - Data-driven baseline for all repos

## Examples

### Generate repos.txt from subdirectories

```bash
find . -maxdepth 1 -type d ! -name "." ! -name ".*" > repos.txt
```

### Find repos with .github/workflows

```bash
find . -type d -name ".github" -exec dirname {} \; | sort | uniq > repos.txt
```

### Analyze and save output

```bash
python3 analyzer.py repos.txt | tee analysis-output.txt
```

## Exit Codes

- `0` - All repos 100% compliant
- `1` - One or more repos below 100% compliance

## Tips

💡 Use `#` for comments in repos.txt
💡 Empty lines are automatically skipped
💡 Paths with spaces are fully supported
💡 Analysis continues even if one repo fails
💡 Custom rules supported via `rules.yaml`

## Files in This Project

```
analyzer.py              - Main analysis script
rules.yaml              - Governance pattern rules
repos.txt               - List of repos to analyze
requirements.txt        - Python dependencies
README.md               - Full documentation
CROSS-REPO-USAGE.md     - Cross-repo feature guide
QUICK-START.md          - This file
examples/               - Example workflow files
test-edge-cases/        - Test repo with edge cases
```

## Need Help?

See `README.md` for full documentation
See `CROSS-REPO-USAGE.md` for cross-repo analysis guide
