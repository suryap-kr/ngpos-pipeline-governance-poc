#!/bin/bash

# Configuration
BASE_DIR="/Users/replace_with_euid/ngpos-repos"
GITHUB_ORG="krogertechnology"
REPOS_TXT="${BASE_DIR}/repos.txt"

# Repository list
REPOS=(
  "payments-acceptance-workflow"
  "pos-elera-configurator-service"
  "pos-elera-orchestration-api"
  "pos-elera-sales-compliance"
  "pos-key-generation-service"
  "pos-receipts"
  "pos-service-FuelPriceChangeController"
  "pos-service-business-day-api"
  "pos-service-business-day-workflow"
  "pos-service-fuel-drpin-kash-interface"
  "pos-service-posaas"
  "pos-service-sco-security"
  "pos-service-tender-restrictions"
  "payments-check-cashing-service"
  "payments-workflow-core-connector"
  "pos-elera-cash-management"
  "pos-elera-cloud-config"
  "pos-elera-dmo-service"
  "pos-elera-event-api"
  "pos-elera-event-service"
  "pos-elera-klog-integrator"
  "pos-elera-loader-catalog"
  "pos-elera-receipt-api"
  "pos-service-business-day-scheduler"
  "pos-service-customer-loyalty"
  "pos-service-elera-krogerized"
  "pos-service-fuel-car-wash-api"
  "pos-service-fuel-configuration"
  "pos-service-fuel-core"
  "pos-service-fuel-drpin"
  "pos-service-fuel-emergency-api"
  "pos-service-fuel-eodaccountreporting"
  "pos-service-fuel-eps-ingestion"
  "pos-service-fuel-eps-sseevent-streaming"
  "pos-service-fuel-forecourt"
  "pos-service-fuel-fuelingpointinformation"
  "pos-service-fuel-fuelingpointtransaction"
  "pos-service-fuel-noneps-ingestion"
  "pos-service-fuel-pricechange-api"
  "pos-service-fuel-pump-authorize"
  "pos-service-fuel-tankmonitorreading"
  "pos-service-fuel-transaction-workflow"
  "pos-service-instore-accntg-batch"
  "pos-service-instore-accntg-ingress"
  "pos-service-instore-accntg-retry"
  "pos-service-instore-cash-management"
  "pos-service-instore-data-loader"
  "pos-service-instore-facility-workflow"
  "pos-service-instore-g4s-manager"
  "pos-service-instore-ingress-sales"
  "pos-service-instore-ledger-operations"
  "pos-service-instore-rabbitmq"
  "pos-service-instore-rems-ingest-manager"
  "pos-service-instore-service-virtualization"
  "pos-service-instore-till-management"
  "pos-service-pinpad-connector"
  "pos-service-tender-utility"
)

# Create base directory
echo "Creating base directory: ${BASE_DIR}"
mkdir -p "${BASE_DIR}"

# Change to base directory
cd "${BASE_DIR}" || exit 1

# Clear repos.txt if it exists
> "${REPOS_TXT}"

# Clone repositories
TOTAL=${#REPOS[@]}
CURRENT=0

echo "Starting to clone ${TOTAL} repositories..."
echo ""

for repo in "${REPOS[@]}"; do
  CURRENT=$((CURRENT + 1))
  echo "[${CURRENT}/${TOTAL}] Cloning ${repo}..."

  if [ -d "${repo}" ]; then
    echo "  ⚠️  Directory already exists, skipping clone"
  else
    git clone "https://github.com/${GITHUB_ORG}/${repo}.git"
    if [ $? -eq 0 ]; then
      echo "  ✓ Successfully cloned"
    else
      echo "  ✗ Failed to clone"
    fi
  fi

  # Add to repos.txt
  echo "${BASE_DIR}/${repo}" >> "${REPOS_TXT}"
  echo ""
done

echo "============================================"
echo "Clone operation complete!"
echo "Repositories location: ${BASE_DIR}"
echo "Repository list saved to: ${REPOS_TXT}"
echo "============================================"
