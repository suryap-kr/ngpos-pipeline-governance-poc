#!/bin/bash

# ==================================================
# GOVERNANCE POC - JAVA REFERENCE DEMO SCRIPT
# ==================================================
#
# PURPOSE:
# Demonstrates how governance configurations control pipeline behavior
# by reading governance/ngpos-java-reference/*.properties files
#
# This script simulates what a real pipeline would do:
# - Read governance configs
# - Execute checks only if enabled=true
# - Skip checks if enabled=false
#
# ==================================================

set -e  # Exit on error

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Governance configuration directory
GOVERNANCE_DIR="governance/ngpos-java-reference"

echo ""
echo "════════════════════════════════════════════════════════════"
echo "   NGPOS PIPELINE GOVERNANCE POC - JAVA REFERENCE DEMO"
echo "════════════════════════════════════════════════════════════"
echo ""
echo "📂 Reading governance configs from: ${GOVERNANCE_DIR}"
echo ""

# Helper function to read property value from .properties file
get_property() {
    local file=$1
    local key=$2
    local default=$3

    if [ ! -f "$file" ]; then
        echo "$default"
        return
    fi

    # Read property, strip comments, trim whitespace
    value=$(grep "^${key}=" "$file" 2>/dev/null | cut -d'=' -f2- | sed 's/#.*//' | xargs || echo "$default")

    # Return default if empty
    if [ -z "$value" ]; then
        echo "$default"
    else
        echo "$value"
    fi
}

# Helper function to check and run a governance-controlled step
check_and_run() {
    local check_name=$1
    local config_file=$2
    local description=$3

    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "🔍 ${check_name}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    # Read governance config
    enabled=$(get_property "$config_file" "enabled" "false")
    fail_on_error=$(get_property "$config_file" "failOnError" "true")

    echo "📄 Config file: ${config_file}"
    echo "⚙️  Enabled: ${enabled}"
    echo "⚙️  Fail on error: ${fail_on_error}"
    echo ""

    if [ "$enabled" = "true" ]; then
        echo -e "${GREEN}✅ RUNNING ${check_name}${NC}"
        echo "   ${description}"
        echo ""

        # Simulate the check running (in real pipeline, actual tool would run here)
        sleep 0.5
        echo "   → Check completed successfully"

        if [ "$fail_on_error" = "true" ]; then
            echo "   → Pipeline will FAIL if this check fails"
        else
            echo "   → Pipeline will CONTINUE even if this check fails (report-only mode)"
        fi
    else
        echo -e "${YELLOW}⏭️  SKIPPING ${check_name}${NC}"
        echo "   Reason: disabled in governance config"
    fi

    echo ""
}

# ==================================================
# STAGE 1: UNIT TESTS
# ==================================================
check_and_run \
    "UNIT TESTS" \
    "${GOVERNANCE_DIR}/unit-test.properties" \
    "Running JUnit tests with JaCoCo coverage analysis"

# Read additional unit test properties for demonstration
if [ "$(get_property ${GOVERNANCE_DIR}/unit-test.properties enabled false)" = "true" ]; then
    min_coverage=$(get_property "${GOVERNANCE_DIR}/unit-test.properties" "min.coverage.percentage" "80")
    echo "   📊 Governance requires minimum coverage: ${min_coverage}%"
    echo ""
fi

# ==================================================
# STAGE 2: SECURITY SCANNING (SNYK)
# ==================================================
check_and_run \
    "SECURITY SCAN (SNYK)" \
    "${GOVERNANCE_DIR}/snyk.properties" \
    "Scanning dependencies for security vulnerabilities"

# Read additional Snyk properties for demonstration
if [ "$(get_property ${GOVERNANCE_DIR}/snyk.properties enabled false)" = "true" ]; then
    severity=$(get_property "${GOVERNANCE_DIR}/snyk.properties" "severity.threshold" "high")
    max_critical=$(get_property "${GOVERNANCE_DIR}/snyk.properties" "max.critical.vulnerabilities" "0")
    max_high=$(get_property "${GOVERNANCE_DIR}/snyk.properties" "max.high.vulnerabilities" "5")
    echo "   🔒 Severity threshold: ${severity}"
    echo "   🔒 Max critical vulnerabilities allowed: ${max_critical}"
    echo "   🔒 Max high vulnerabilities allowed: ${max_high}"
    echo ""
fi

# ==================================================
# STAGE 3: CODE QUALITY (SONARQUBE)
# ==================================================
check_and_run \
    "CODE QUALITY (SONARQUBE)" \
    "${GOVERNANCE_DIR}/sonar.properties" \
    "Analyzing code quality, coverage, and technical debt"

# Read additional SonarQube properties for demonstration
if [ "$(get_property ${GOVERNANCE_DIR}/sonar.properties enabled false)" = "true" ]; then
    coverage_threshold=$(get_property "${GOVERNANCE_DIR}/sonar.properties" "coverage.threshold" "80")
    bugs_threshold=$(get_property "${GOVERNANCE_DIR}/sonar.properties" "bugs.threshold" "0")
    code_smells=$(get_property "${GOVERNANCE_DIR}/sonar.properties" "code.smells.threshold" "10")
    echo "   📈 Coverage threshold: ${coverage_threshold}%"
    echo "   🐛 Max bugs allowed: ${bugs_threshold}"
    echo "   👃 Max code smells allowed: ${code_smells}"
    echo ""
fi

# ==================================================
# STAGE 4: CONTRACT TESTING (PACT)
# ==================================================
check_and_run \
    "CONTRACT TESTS (PACT)" \
    "${GOVERNANCE_DIR}/pact.properties" \
    "Verifying API contracts with consumer/provider services"

# Read additional Pact properties for demonstration
if [ "$(get_property ${GOVERNANCE_DIR}/pact.properties enabled false)" = "true" ]; then
    broker_url=$(get_property "${GOVERNANCE_DIR}/pact.properties" "pact.broker.url" "")
    publish_results=$(get_property "${GOVERNANCE_DIR}/pact.properties" "publish.verification.results" "true")
    echo "   🤝 Pact broker: ${broker_url}"
    echo "   📤 Publish results: ${publish_results}"
    echo ""
fi

# ==================================================
# STAGE 5: INTEGRATION TESTS
# ==================================================
check_and_run \
    "INTEGRATION TESTS" \
    "${GOVERNANCE_DIR}/integration-test.properties" \
    "Testing integration with databases and external services"

# Read additional integration test properties for demonstration
if [ "$(get_property ${GOVERNANCE_DIR}/integration-test.properties enabled false)" = "true" ]; then
    test_env=$(get_property "${GOVERNANCE_DIR}/integration-test.properties" "test.environment" "integration")
    use_containers=$(get_property "${GOVERNANCE_DIR}/integration-test.properties" "use.testcontainers" "true")
    echo "   🔧 Test environment: ${test_env}"
    echo "   🐳 Use testcontainers: ${use_containers}"
    echo ""
fi

# ==================================================
# STAGE 6: BDD/ACCEPTANCE TESTS
# ==================================================
check_and_run \
    "BDD/ACCEPTANCE TESTS" \
    "${GOVERNANCE_DIR}/bdd-test.properties" \
    "Running behavior-driven acceptance tests (Cucumber)"

# Read additional BDD properties for demonstration
if [ "$(get_property ${GOVERNANCE_DIR}/bdd-test.properties enabled false)" = "true" ]; then
    test_env=$(get_property "${GOVERNANCE_DIR}/bdd-test.properties" "test.environment" "staging")
    include_tags=$(get_property "${GOVERNANCE_DIR}/bdd-test.properties" "include.tags" "@smoke,@regression")
    echo "   🎭 Test environment: ${test_env}"
    echo "   🏷️  Include tags: ${include_tags}"
    echo ""
fi

# ==================================================
# SUMMARY
# ==================================================
echo "════════════════════════════════════════════════════════════"
echo "                    PIPELINE SUMMARY"
echo "════════════════════════════════════════════════════════════"
echo ""
echo "✅ All governance-controlled checks completed"
echo ""
echo "🔒 Key Points:"
echo "   • All thresholds enforced by Engineering Manager-approved configs"
echo "   • Developers cannot bypass these checks without EM approval"
echo "   • To change these settings, modify files in ${GOVERNANCE_DIR}/"
echo "   • Changes require @ngpos-em-reference approval via CODEOWNERS"
echo ""
echo "📂 Governance configs location:"
echo "   ${GOVERNANCE_DIR}/"
echo ""
echo "════════════════════════════════════════════════════════════"
echo ""
