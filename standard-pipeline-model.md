## Overview

This Document defines a standard pipeline model for NGPOS services based on the reusable workflows available in the central CICD repository.

The goal is to:
- Ensure consistency across all repositories
- Reduce custom pipeline implementations
- Enable flexibility per application using configurable toggles
- Capture useful outputs beyond just pass/fail (e.g., performance, build insights)

## Pipeline Capabilities

📦 BUILD (5 workflows)

- build_golang.yml - Go project builds with unit tests and coverage
- build_maven.yml - Maven/Java builds with Artifactory integration
- unit_test_maven.yml - Maven unit test execution
- dockerize_template.yml - Docker image builds and push to JFrog Artifactory
- run_soa_tests.yml - SOA service testing in Docker containers

  ---
🧪 TEST (6 workflows)

- contract_tests_maven.yml - Maven integration/contract testing
- contract_tests_golang.yml - Go contract tests (placeholder)
- regression_maven.yml - Regression testing with Karate framework
- regression_tests_golang.yml - Go regression tests (placeholder)
- test_env_using_docker.yml - Core testing orchestrator (Docker Compose setup, dependencies, JFR collection)

  ---
✅ QUALITY & LINTING (5 workflows)

- checkstyle_maven.yml - Java code style enforcement (100 error threshold)
- checkstyle_golang.yml - Go formatting verification (gofmt)
- code_linting_golang.yml - Go linting (golangci-lint)
- api_linting.yml - OpenAPI spec validation
- sonar-scan-maven.yml - SonarQube static analysis with quality gates

  ---
🔒 SECURITY (5 workflows)

- snyk_scan_golang.yml - Snyk vulnerability scanning for Go
- snyk_scan_java17.yml - Snyk dependency + SAST scanning for Java 17
- vulnerability_scan_golang.yml - Combined Snyk + X-Ray for Go images
- vulnerability_scan_java17_maven.yml - Combined Snyk + X-Ray for Java images
- xray_scan.yml - JFrog X-Ray Docker image scanning

  ---
🚀 DEPLOY (2 workflows)

- release_tag_docker.yml - Docker image re-tagging for releases
- main-branch-api-maven.yml - Full production pipeline (build → test → quality → security → deploy to Harness)

  ---
🔄 INTEGRATION/FULL PIPELINES (3 workflows)

- feature-branch-api-maven.yml - Complete CI/CD for Maven feature branches
- feature-branch-api-golang.yml - Complete CI/CD for Go feature branches
- bypass-with-approval-maven.yml - Emergency deployment with multi-level approvals

  ---
📊 PROFILING (2 workflows + 1 action)

- jfr-profiler.yml - Java Flight Recorder analysis
- .github/actions/profiler/action_gradle.yml - Gradle JFR profiling action
- .github/actions/profiler/action.yml - JFR summary generation

  ---
🛠️ CUSTOM ACTIONS (2 additional)

- .github/actions/test_env_creation/action.yml - Docker Compose environment setup
- .github/actions/profiler/action.yml - JFR analysis and PR comments

## Mandatory Baseline Controls

All repositories should implement:
- PR-triggered workflow
- Blocking build and test gate
- Code quality checks (Sonar, linting)
- Security scanning (Snyk, X-Ray)
- Standard reporting of results

This ensures a minimum governance baseline across all services.

## Optional / Toggle_based Controls

To support flexibility per application, the pipeline should be configurable.

Example toggles:
- enable_build
- enable_test
- enable_quality
- enable_security
- enable_deploy
- enable_profiling
- enable_integration

Each application can enable only the capabilities it needs while still using the same reusable pipeline.

This avoids custom pipeline duplication while still supporting application-specific needs.

## Optimization & Observability

The pipeline should support optional optimization steps:
- JVM profiling (JFR)
- Startup time analysis
- Memory usage awareness
- Runtime configuration visibility

These insights should be captured as part of pipeline outputs to support performance tuning and operational visibility.

## Release Outputs to Capture

Each pipeline run should capture:
- Build artifacts and image metadata
- Test results
- Security scan results
- Quality metrics
- Profiling/optimization outputs (if enabled)
This ensures visibility into both correctness and performance per release.

## Adoption Model

1. Align all repositories to the mandatory baseline
2. Replace custom pipelines with reusable workflows from CICD repo
3. Introduce configuration-based toggles for flexibility
4. Gradually enable optimization and advanced capabilities

This allows incremental adoption without disrupting existing pipelines.


This model builds on the existing reusable workflows in the central CICD repository and extends them with configuration-driven flexibility.