# Changelog: Cross-Repo Analysis Feature

## Summary

Added cross-repository comparison and analysis capabilities while maintaining full backward compatibility with single-repo mode.

## New Features

### 1. Multi-Repo Analysis Mode
- Automatically detects if input is a file (repos.txt) or directory (single repo)
- Processes multiple repositories from a text file
- Generates individual reports for each repo
- Creates comprehensive cross-repo comparison summary

### 2. Cross-Repo Summary Report
New `cross-repo-summary.md` file includes:
- **Comparison table**: Side-by-side view of all repos
- **Common patterns**: What most repos are doing
- **Outlier detection**: Repos that differ significantly
- **Gap analysis**: Missing controls across the organization
- **Recommendations**: Data-driven baseline for standardization

### 3. Enhanced Data Extraction
- Collects trigger types across workflows
- Aggregates workflow filenames
- Calculates organization-wide statistics
- Identifies common tooling patterns

## Code Changes

### New Classes/Dataclasses

**RepoComparison** (line 45-58)
```python
@dataclass
class RepoComparison:
    """Cross-repo comparison data for a single repo."""
    repo_name: str
    repo_path: str
    compliance_score: float
    has_pr_workflow: bool
    has_blocking_gate: bool
    has_security_scan: bool
    has_quality_scan: bool
    has_deploy_workflow: bool
    workflow_files: List[str]
    trigger_types: Set[str]
    total_workflows: int
```

### New Methods

**ReportGenerator.create_repo_comparison()** (line 423-449)
- Extracts comparison data from GovernanceReport
- Collects workflow filenames and trigger types
- Returns RepoComparison object

**ReportGenerator.generate_cross_repo_summary()** (line 451-654)
- Generates comprehensive cross-repo markdown report
- Includes 5 analysis sections
- ~200 lines of report generation logic

### Modified Methods

**main()** (line 657-778)
- Detects file vs directory input
- Multi-repo mode: reads repos.txt, analyzes all repos, generates cross-repo summary
- Single-repo mode: unchanged behavior (backward compatible)
- Named output files: `<repo-name>-governance-report.md` for multi-repo
- Enhanced console output with progress indicators

## Files Generated

### Single-Repo Mode (unchanged)
```
governance-report.md
```

### Multi-Repo Mode (new)
```
<repo1>-governance-report.md
<repo2>-governance-report.md
...
cross-repo-summary.md
```

## Usage Examples

### Before (single repo only)
```bash
python3 analyzer.py /path/to/repo
# Output: governance-report.md
```

### After (backward compatible + new multi-repo)
```bash
# Single repo (same as before)
python3 analyzer.py /path/to/repo
# Output: governance-report.md

# Multi-repo (NEW!)
python3 analyzer.py repos.txt
# Output:
#   repo1-governance-report.md
#   repo2-governance-report.md
#   cross-repo-summary.md
```

## Backward Compatibility

✅ **100% backward compatible**
- Existing single-repo usage works exactly as before
- Same output filename (`governance-report.md`) for single repos
- Same console output format
- Same exit codes

## Benefits

1. **Organization-wide visibility**: Compare governance across all repos
2. **Pattern identification**: See what's common vs unique
3. **Gap analysis**: Quickly identify repos missing controls
4. **Standardization**: Data-driven recommendations for baseline
5. **Batch processing**: Analyze dozens of repos at once
6. **Failure resilience**: Continues processing if one repo fails

## Testing

Tested with:
- Single directory (backward compatibility) ✓
- Multi-repo file with 2 repos ✓
- Repos with varying compliance levels ✓
- Malformed YAML files ✓
- Empty workflows ✓
- Comments in repos.txt ✓

## Lines of Code Added

- New dataclass: ~15 lines
- create_repo_comparison(): ~25 lines
- generate_cross_repo_summary(): ~200 lines
- main() modifications: ~70 lines
- **Total: ~310 lines added**

## Performance

- No impact on single-repo mode
- Multi-repo mode: O(n) where n = number of repos
- Each repo analyzed independently
- Minimal memory overhead (stores comparison objects only)
