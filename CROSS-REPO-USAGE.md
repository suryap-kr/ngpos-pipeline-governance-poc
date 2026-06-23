# Cross-Repo Analysis Usage Guide

## Overview

The analyzer now supports both **single-repo** and **multi-repo** analysis modes.

## Single-Repo Mode (Backward Compatible)

Analyze a single repository:

```bash
python3 analyzer.py /path/to/repo
```

**Output:**
- `governance-report.md` - Detailed governance report for the repo
- Console output with full report

## Multi-Repo Mode (NEW!)

Analyze multiple repositories and generate cross-repo comparison:

### 1. Create repos.txt

List repositories to analyze (one per line):

```bash
cat > repos.txt << EOF
# List of repositories to analyze
./my-first-repo
./my-second-repo
/absolute/path/to/another-repo
EOF
```

### 2. Run Multi-Repo Analysis

```bash
python3 analyzer.py repos.txt
```

**Output:**
- `<repo-name>-governance-report.md` - Per-repo detailed reports
- `cross-repo-summary.md` - Cross-repo comparison and recommendations
- Console output with cross-repo summary

## What's in the Cross-Repo Summary?

The `cross-repo-summary.md` includes:

### 1. Repository Comparison Table
Side-by-side comparison of all repos with:
- Compliance scores
- Governance baseline checklist (PR workflow, build/test, security, quality, deploy)
- Total workflow count

### 2. Common Pipeline Pattern
Analysis of what's common across repos:
- Percentage of repos with each control
- Common trigger types (pull_request, push, schedule, etc.)

### 3. Outlier Repositories
Identifies repos that differ from the norm:
- Low compliance scores (< 50%)
- Missing PR workflows
- Missing security scans

### 4. Missing Governance Controls
Aggregate view of gaps across all repos:
- How many repos are missing each control
- Quick identification of organization-wide issues

### 5. Recommended Standard Baseline
Data-driven recommendations based on actual usage:
- Required controls for all repos
- Common trigger patterns
- Tool recommendations (CodeQL, Trivy, SonarQube, etc.)

## Example Workflow

```bash
# 1. Generate repos.txt from all subdirectories
find . -type d -name ".github" -exec dirname {} \; | sort | uniq > repos.txt

# 2. Run cross-repo analysis
python3 analyzer.py repos.txt

# 3. Review results
cat cross-repo-summary.md

# 4. Review individual repo reports
ls -l *-governance-report.md
```

## Tips

- **Spaces in paths**: Fully supported, just list them normally in repos.txt
- **Comments**: Use # for comments in repos.txt
- **Empty lines**: Automatically skipped
- **Failures**: If one repo fails, analysis continues with remaining repos
- **Exit code**: Returns 0 only if ALL repos are 100% compliant

## Comparing Results

The cross-repo summary makes it easy to:
- Identify which repos need attention
- Standardize pipelines across your organization
- Find common patterns and outliers
- Make data-driven governance decisions
