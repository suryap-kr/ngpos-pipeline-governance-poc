import os
import sys
import yaml
import glob
import re
from typing import List, Dict

RULES_FILE = "rules.yaml"
SUMMARY_FILE = "cross-repo-summary.md"
REPORT_FILE = "governance-report.md"

# Load rules from rules.yaml
def load_rules(rules_path: str) -> Dict:
    with open(rules_path, "r") as f:
        return yaml.safe_load(f)

def find_workflow_files(repo_path: str) -> List[str]:
    workflows_dir = os.path.join(repo_path, ".github", "workflows")
    if not os.path.isdir(workflows_dir):
        return []
    return glob.glob(os.path.join(workflows_dir, "*.yml")) + \
           glob.glob(os.path.join(workflows_dir, "*.yaml"))

def parse_yaml_file(path: str) -> dict:
    with open(path, "r") as f:
        return yaml.safe_load(f)

def match_patterns(step: dict, patterns: List[str]) -> bool:
    text = str(step)
    for pat in patterns:
        if re.search(pat, text, re.IGNORECASE):
            return True
    return False

def analyze_workflow(workflow: dict, rules: dict) -> dict:
    has_pr_trigger = False
    has_build = False
    has_test = False
    has_security = False
    has_quality = False
    has_deploy = False
    triggers = []
    has_continue_on_error = False
    has_workflow_call = False
    tools = []

    # Triggers - handle 'on:' or YAML quirk where it becomes True:
    on = workflow.get('on') or workflow.get(True)

    if on is not None:
        if isinstance(on, dict):
            triggers.extend(on.keys())
            # Check for pull_request or pull_request_target
            if 'pull_request' in on or 'pull_request_target' in on:
                has_pr_trigger = True
            if 'workflow_call' in on:
                has_workflow_call = True
        elif isinstance(on, list):
            triggers.extend(on)
            # List format: on: [push, pull_request]
            if 'pull_request' in on or 'pull_request_target' in on:
                has_pr_trigger = True
            if 'workflow_call' in on:
                has_workflow_call = True
        elif isinstance(on, str):
            triggers.append(on)
            # String format: on: pull_request
            if on in ('pull_request', 'pull_request_target'):
                has_pr_trigger = True
            if on == 'workflow_call':
                has_workflow_call = True

    # Jobs
    jobs = workflow.get('jobs', {})
    for job in jobs.values():
        # Check for continue-on-error at job level
        if job.get('continue-on-error', False):
            has_continue_on_error = True

        steps = job.get('steps', [])
        for step in steps:
            # Check for continue-on-error at step level
            if step.get('continue-on-error', False):
                has_continue_on_error = True

            # Detect tooling
            step_text = str(step).lower()
            if 'sonar' in step_text:
                tools.append('sonar')
            if 'snyk' in step_text:
                tools.append('snyk')
            if 'codeql' in step_text:
                tools.append('codeql')
            if 'trivy' in step_text:
                tools.append('trivy')
            if 'eslint' in step_text or 'pylint' in step_text or 'flake8' in step_text:
                tools.append('linting')

            if match_patterns(step, rules.get('build_patterns', [])):
                has_build = True
            if match_patterns(step, rules.get('test_patterns', [])):
                has_test = True
            if match_patterns(step, rules.get('security_patterns', [])):
                has_security = True
            if match_patterns(step, rules.get('quality_patterns', [])):
                has_quality = True
            if match_patterns(step, rules.get('deploy_patterns', [])):
                has_deploy = True

    return {
        'pr_trigger': has_pr_trigger,
        'build': has_build,
        'test': has_test,
        'security': has_security,
        'quality': has_quality,
        'deploy': has_deploy,
        'triggers': triggers,
        'has_continue_on_error': has_continue_on_error,
        'has_workflow_call': has_workflow_call,
        'tools': list(set(tools))  # unique tools
    }

def analyze_repo(repo_path: str, rules: dict) -> dict:
    workflows = find_workflow_files(repo_path)
    result = {
        'repo': os.path.basename(repo_path),
        'pr_trigger': False,
        'build': False,
        'test': False,
        'security': False,
        'quality': False,
        'deploy': False,
        'score': 0,
        'report_path': os.path.join(repo_path, REPORT_FILE),
        # Implementation details
        'workflow_count': len(workflows),
        'triggers': set(),
        'has_reusable_workflows': False,
        'has_continue_on_error': False,
        'tools': set(),
        'has_manual_deploy': False,
        'has_auto_deploy': False
    }

    for wf_file in workflows:
        try:
            wf = parse_yaml_file(wf_file)
            # Skip if workflow is None or not a dict
            if not wf or not isinstance(wf, dict):
                continue
            wf_result = analyze_workflow(wf, rules)

            # Aggregate boolean flags
            for k in ['pr_trigger', 'build', 'test', 'security', 'quality', 'deploy']:
                result[k] = result[k] or wf_result[k]

            # Aggregate implementation details
            result['triggers'].update(wf_result['triggers'])
            result['tools'].update(wf_result['tools'])

            if wf_result['has_workflow_call']:
                result['has_reusable_workflows'] = True

            if wf_result['has_continue_on_error']:
                result['has_continue_on_error'] = True

            # Detect deployment strategy
            if wf_result['deploy']:
                if 'workflow_dispatch' in wf_result['triggers']:
                    result['has_manual_deploy'] = True
                if 'push' in wf_result['triggers'] or 'release' in wf_result['triggers']:
                    result['has_auto_deploy'] = True

        except Exception as e:
            # Continue analyzing other workflows even if one fails
            continue

    # Convert sets to sorted lists for consistent output
    result['triggers'] = sorted(list(result['triggers']))
    result['tools'] = sorted(list(result['tools']))

    # Scoring
    score = 0
    if result['pr_trigger']:
        score += 20
    if result['build'] and result['test']:
        score += 20
    if result['security']:
        score += 20
    if result['quality']:
        score += 20
    if result['deploy']:
        score += 20
    result['score'] = score
    return result

def write_repo_report(repo_path: str, result: dict):
    lines = [
        f"# Pipeline Governance Report for {result['repo']}",
        "",
        f"| Requirement     | Status |",
        f"|-----------------|--------|",
        f"| PR Workflow     | {'✅' if result['pr_trigger'] else '❌'} |",
        f"| Build Step      | {'✅' if result['build'] else '❌'} |",
        f"| Test Step       | {'✅' if result['test'] else '❌'} |",
        f"| Security Scan   | {'✅' if result['security'] else '❌'} |",
        f"| Quality Scan    | {'✅' if result['quality'] else '❌'} |",
        f"| Deploy Workflow | {'✅' if result['deploy'] else '❌'} |",
        "",
        f"**Compliance Score:** {result['score']}%"
    ]
    with open(os.path.join(repo_path, REPORT_FILE), "w") as f:
        f.write("\n".join(lines))

def write_cross_repo_summary(results: List[dict], out_path: str):
    lines = [
        "# Cross-Repo Pipeline Governance Summary",
        "",
        "| Repository | PR Workflow | Build | Test | Security | Quality | Deploy | Score |",
        "|------------|-------------|-------|------|----------|---------|--------|-------|"
    ]
    for r in results:
        lines.append(
            f"| {r['repo']} | {'✅' if r['pr_trigger'] else '❌'} | {'✅' if r['build'] else '❌'} | {'✅' if r['test'] else '❌'} | {'✅' if r['security'] else '❌'} | {'✅' if r['quality'] else '❌'} | {'✅' if r['deploy'] else '❌'} | {r['score']}% |"
        )

    # Add Missing Controls by Repository section
    lines.append("")
    lines.append("## Missing Controls by Repository")
    lines.append("")

    # Find repos with missing controls
    repos_with_gaps = [r for r in results if r['score'] < 100]

    if repos_with_gaps:
        for r in repos_with_gaps:
            lines.append(f"**{r['repo']}:**")

            # List specific missing controls
            if not r['pr_trigger']:
                lines.append("- Missing PR-triggered workflow")
            if not r['build'] or not r['test']:
                lines.append("- Missing build/test gate")
            if not r['security']:
                lines.append("- Missing security scan")
            if not r['quality']:
                lines.append("- Missing quality checks")
            if not r['deploy']:
                lines.append("- Missing deployment workflow")

            lines.append("")
    else:
        lines.append("All repositories have complete governance controls!")
        lines.append("")

    # Add Implementation Differences Across Repositories section
    lines.append("## Implementation Differences Across Repositories")
    lines.append("")

    # 1. Trigger Patterns
    lines.append("### Trigger Patterns")
    lines.append("")
    all_triggers = set()
    for r in results:
        all_triggers.update(r['triggers'])

    for trigger in sorted(all_triggers):
        repos_with_trigger = [r['repo'] for r in results if trigger in r['triggers']]
        lines.append(f"**{trigger}:** {len(repos_with_trigger)}/{len(results)} repos")
        if len(repos_with_trigger) <= 5:  # Show repo names if <= 5
            lines.append(f"  - {', '.join(repos_with_trigger)}")
    lines.append("")

    # 2. Pipeline Structure
    lines.append("### Pipeline Structure")
    lines.append("")

    # Group by workflow count
    single_wf = [r for r in results if r['workflow_count'] == 1]
    multi_wf = [r for r in results if r['workflow_count'] > 1]

    lines.append(f"**Single workflow:** {len(single_wf)} repos")
    if single_wf and len(single_wf) <= 5:
        lines.append(f"  - {', '.join([r['repo'] for r in single_wf])}")
    lines.append(f"**Multiple workflows:** {len(multi_wf)} repos (avg: {sum(r['workflow_count'] for r in multi_wf) / len(multi_wf):.1f} workflows)" if multi_wf else "**Multiple workflows:** 0 repos")
    if multi_wf and len(multi_wf) <= 5:
        repo_wf_list = ', '.join([f"{r['repo']} ({r['workflow_count']})" for r in multi_wf])
        lines.append(f"  - {repo_wf_list}")
    lines.append("")

    # Reusable workflows
    reusable_wf = [r for r in results if r['has_reusable_workflows']]
    lines.append(f"**Using reusable workflows (workflow_call):** {len(reusable_wf)}/{len(results)} repos")
    if reusable_wf and len(reusable_wf) <= 8:
        lines.append(f"  - {', '.join([r['repo'] for r in reusable_wf])}")
    lines.append("")

    # 3. Enforcement Level
    lines.append("### Enforcement Level")
    lines.append("")
    blocking = [r for r in results if not r['has_continue_on_error']]
    non_blocking = [r for r in results if r['has_continue_on_error']]

    lines.append(f"**Fully blocking (no continue-on-error):** {len(blocking)}/{len(results)} repos")
    if blocking and len(blocking) <= 5:
        lines.append(f"  - {', '.join([r['repo'] for r in blocking])}")
    lines.append(f"**Non-blocking (has continue-on-error):** {len(non_blocking)}/{len(results)} repos")
    if non_blocking and len(non_blocking) <= 8:
        lines.append(f"  - {', '.join([r['repo'] for r in non_blocking])}")
    lines.append("")

    # 4. Deployment Strategy
    lines.append("### Deployment Strategy")
    lines.append("")
    manual_deploy = [r for r in results if r['has_manual_deploy']]
    auto_deploy = [r for r in results if r['has_auto_deploy']]
    no_deploy = [r for r in results if not r['deploy']]

    lines.append(f"**Manual deployment (workflow_dispatch):** {len(manual_deploy)}/{len(results)} repos")
    if manual_deploy and len(manual_deploy) <= 5:
        lines.append(f"  - {', '.join([r['repo'] for r in manual_deploy])}")
    lines.append(f"**Automatic deployment (push/release):** {len(auto_deploy)}/{len(results)} repos")
    if auto_deploy and len(auto_deploy) <= 5:
        lines.append(f"  - {', '.join([r['repo'] for r in auto_deploy])}")
    lines.append(f"**No deployment:** {len(no_deploy)}/{len(results)} repos")
    if no_deploy and len(no_deploy) <= 5:
        lines.append(f"  - {', '.join([r['repo'] for r in no_deploy])}")
    lines.append("")

    # 5. Tooling Differences
    lines.append("### Tooling Differences")
    lines.append("")
    all_tools = set()
    for r in results:
        all_tools.update(r['tools'])

    for tool in sorted(all_tools):
        repos_with_tool = [r['repo'] for r in results if tool in r['tools']]
        lines.append(f"**{tool}:** {len(repos_with_tool)}/{len(results)} repos")
        if len(repos_with_tool) <= 5:
            lines.append(f"  - {', '.join(repos_with_tool)}")
    lines.append("")

    # Summary of common patterns and variations
    lines.append("### Implementation Differences Summary")
    lines.append("")
    lines.append("**Common Patterns:**")

    # Find most common trigger pattern
    most_common_trigger = max(all_triggers, key=lambda t: len([r for r in results if t in r['triggers']])) if all_triggers else None
    if most_common_trigger:
        count = len([r for r in results if most_common_trigger in r['triggers']])
        lines.append(f"- Most common trigger: `{most_common_trigger}` ({count}/{len(results)} repos)")

    # Most common tool
    if all_tools:
        most_common_tool = max(all_tools, key=lambda t: len([r for r in results if t in r['tools']]))
        count = len([r for r in results if most_common_tool in r['tools']])
        lines.append(f"- Most common tool: {most_common_tool} ({count}/{len(results)} repos)")

    # Average workflows
    avg_workflows = sum(r['workflow_count'] for r in results) / len(results) if results else 0
    lines.append(f"- Average workflows per repo: {avg_workflows:.1f}")

    lines.append("")
    lines.append("**Key Variations:**")

    # Identify variations
    if len(multi_wf) > 0 and len(single_wf) > 0:
        lines.append(f"- Pipeline complexity: {len(single_wf)} repos use single workflow, {len(multi_wf)} use multiple workflows")

    if len(reusable_wf) > 0:
        lines.append(f"- {len(reusable_wf)} repos leverage reusable workflows for standardization")

    if len(non_blocking) > 0:
        lines.append(f"- {len(non_blocking)} repos use non-blocking checks (continue-on-error)")

    deployment_strategies = []
    if len(manual_deploy) > 0:
        deployment_strategies.append("manual")
    if len(auto_deploy) > 0:
        deployment_strategies.append("automatic")
    if deployment_strategies:
        lines.append(f"- Deployment strategies vary: {', '.join(deployment_strategies)}")

    lines.append("")
    lines.append("**Potential Reasons for Inconsistency:**")
    lines.append("- Different service maturity levels (legacy vs new pipelines)")
    lines.append("- Team preferences and organizational silos")
    if len(reusable_wf) > 0:
        lines.append("- Mix of centralized reusable workflows and custom implementations")
    lines.append("- Varying security and compliance requirements")
    lines.append("- Gradual adoption of governance standards")
    lines.append("")

    with open(out_path, "w") as f:
        f.write("\n".join(lines))

def main():
    if len(sys.argv) < 2:
        print("Usage: python3 analyzer.py <repo_path|repos.txt>")
        sys.exit(1)
    rules = load_rules(RULES_FILE)
    arg = sys.argv[1]
    repo_paths = []
    if os.path.isdir(arg):
        repo_paths = [arg]
    elif os.path.isfile(arg):
        with open(arg) as f:
            repo_paths = [line.strip() for line in f if line.strip() and not line.strip().startswith('#')]
    else:
        print(f"Error: {arg} is not a valid directory or file.")
        sys.exit(1)
    results = []
    for repo in repo_paths:
        if not os.path.isdir(repo):
            continue
        result = analyze_repo(repo, rules)
        write_repo_report(repo, result)
        results.append(result)
    write_cross_repo_summary(results, SUMMARY_FILE)
    print(f"Analyzed {len(results)} repos. Summary written to {SUMMARY_FILE}.")

if __name__ == "__main__":
    main()

