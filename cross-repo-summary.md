# Cross-Repo Pipeline Governance Summary

| Repository | PR Workflow | Build | Test | Security | Quality | Deploy | Score |
|------------|-------------|-------|------|----------|---------|--------|-------|
| payments-acceptance-workflow | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | 100% |
| pos-elera-configurator-service | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | 100% |
| pos-elera-orchestration-api | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | 100% |
| pos-elera-sales-compliance | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | 100% |
| pos-key-generation-service | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | 100% |
| pos-receipts | ❌ | ✅ | ❌ | ❌ | ❌ | ✅ | 20% |
| pos-service-FuelPriceChangeController | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | 20% |
| pos-service-business-day-api | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | 80% |
| pos-service-business-day-workflow | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | 80% |
| pos-service-fuel-drpin-kash-interface | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | 20% |
| pos-service-posaas | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | 100% |
| pos-service-sco-security | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | 100% |
| pos-service-tender-restrictions | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | 100% |
| payments-check-cashing-service | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | 100% |
| payments-workflow-core-connector | ✅ | ✅ | ✅ | ❌ | ❌ | ✅ | 60% |
| pos-elera-cash-management | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | 100% |
| pos-elera-cloud-config | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | 100% |
| pos-elera-dmo-service | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | 100% |
| pos-elera-event-api | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | 100% |
| pos-elera-event-service | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | 100% |
| pos-elera-klog-integrator | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | 100% |
| pos-elera-loader-catalog | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | 100% |
| pos-elera-receipt-api | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | 100% |
| pos-service-customer-loyalty | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | 20% |
| pos-service-elera-krogerized | ❌ | ✅ | ✅ | ❌ | ❌ | ✅ | 40% |
| pos-service-fuel-car-wash-api | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | 20% |
| pos-service-fuel-configuration | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | 20% |
| pos-service-fuel-core | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | 20% |
| pos-service-fuel-drpin | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | 20% |
| pos-service-fuel-emergency-api | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | 20% |
| pos-service-fuel-eodaccountreporting | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | 20% |
| pos-service-fuel-eps-ingestion | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | 20% |
| pos-service-fuel-eps-sseevent-streaming | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | 20% |
| pos-service-fuel-forecourt | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | 20% |
| pos-service-fuel-fuelingpointinformation | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | 20% |
| pos-service-fuel-fuelingpointtransaction | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | 20% |
| pos-service-fuel-noneps-ingestion | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | 20% |
| pos-service-fuel-tankmonitorreading | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | 20% |
| pos-service-fuel-transaction-workflow | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | 20% |
| pos-service-instore-accntg-batch | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | 80% |
| pos-service-instore-accntg-ingress | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | 80% |
| pos-service-instore-accntg-retry | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | 80% |
| pos-service-instore-cash-management | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | 80% |
| pos-service-instore-data-loader | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | 80% |
| pos-service-instore-facility-workflow | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | 80% |
| pos-service-instore-g4s-manager | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | 80% |
| pos-service-instore-ingress-sales | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | 80% |
| pos-service-instore-ledger-operations | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | 80% |
| pos-service-instore-rabbitmq | ❌ | ✅ | ✅ | ❌ | ❌ | ✅ | 40% |
| pos-service-instore-rems-ingest-manager | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | 80% |
| pos-service-instore-service-virtualization | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | 0% |
| pos-service-instore-till-management | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | 80% |
| pos-service-pinpad-connector | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | 100% |
| pos-service-tender-utility | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | 100% |

## Missing Controls by Repository

**pos-receipts:**
- Missing PR-triggered workflow
- Missing build/test gate
- Missing security scan
- Missing quality checks

**pos-service-FuelPriceChangeController:**
- Missing build/test gate
- Missing security scan
- Missing quality checks
- Missing deployment workflow

**pos-service-business-day-api:**
- Missing deployment workflow

**pos-service-business-day-workflow:**
- Missing deployment workflow

**pos-service-fuel-drpin-kash-interface:**
- Missing build/test gate
- Missing security scan
- Missing quality checks
- Missing deployment workflow

**payments-workflow-core-connector:**
- Missing security scan
- Missing quality checks

**pos-service-customer-loyalty:**
- Missing build/test gate
- Missing security scan
- Missing quality checks
- Missing deployment workflow

**pos-service-elera-krogerized:**
- Missing PR-triggered workflow
- Missing security scan
- Missing quality checks

**pos-service-fuel-car-wash-api:**
- Missing build/test gate
- Missing security scan
- Missing quality checks
- Missing deployment workflow

**pos-service-fuel-configuration:**
- Missing build/test gate
- Missing security scan
- Missing quality checks
- Missing deployment workflow

**pos-service-fuel-core:**
- Missing build/test gate
- Missing security scan
- Missing quality checks
- Missing deployment workflow

**pos-service-fuel-drpin:**
- Missing build/test gate
- Missing security scan
- Missing quality checks
- Missing deployment workflow

**pos-service-fuel-emergency-api:**
- Missing build/test gate
- Missing security scan
- Missing quality checks
- Missing deployment workflow

**pos-service-fuel-eodaccountreporting:**
- Missing build/test gate
- Missing security scan
- Missing quality checks
- Missing deployment workflow

**pos-service-fuel-eps-ingestion:**
- Missing build/test gate
- Missing security scan
- Missing quality checks
- Missing deployment workflow

**pos-service-fuel-eps-sseevent-streaming:**
- Missing build/test gate
- Missing security scan
- Missing quality checks
- Missing deployment workflow

**pos-service-fuel-forecourt:**
- Missing build/test gate
- Missing security scan
- Missing quality checks
- Missing deployment workflow

**pos-service-fuel-fuelingpointinformation:**
- Missing build/test gate
- Missing security scan
- Missing quality checks
- Missing deployment workflow

**pos-service-fuel-fuelingpointtransaction:**
- Missing build/test gate
- Missing security scan
- Missing quality checks
- Missing deployment workflow

**pos-service-fuel-noneps-ingestion:**
- Missing build/test gate
- Missing security scan
- Missing quality checks
- Missing deployment workflow

**pos-service-fuel-tankmonitorreading:**
- Missing build/test gate
- Missing security scan
- Missing quality checks
- Missing deployment workflow

**pos-service-fuel-transaction-workflow:**
- Missing build/test gate
- Missing security scan
- Missing quality checks
- Missing deployment workflow

**pos-service-instore-accntg-batch:**
- Missing deployment workflow

**pos-service-instore-accntg-ingress:**
- Missing deployment workflow

**pos-service-instore-accntg-retry:**
- Missing deployment workflow

**pos-service-instore-cash-management:**
- Missing deployment workflow

**pos-service-instore-data-loader:**
- Missing deployment workflow

**pos-service-instore-facility-workflow:**
- Missing deployment workflow

**pos-service-instore-g4s-manager:**
- Missing deployment workflow

**pos-service-instore-ingress-sales:**
- Missing deployment workflow

**pos-service-instore-ledger-operations:**
- Missing deployment workflow

**pos-service-instore-rabbitmq:**
- Missing PR-triggered workflow
- Missing security scan
- Missing quality checks

**pos-service-instore-rems-ingest-manager:**
- Missing deployment workflow

**pos-service-instore-service-virtualization:**
- Missing PR-triggered workflow
- Missing build/test gate
- Missing security scan
- Missing quality checks
- Missing deployment workflow

**pos-service-instore-till-management:**
- Missing deployment workflow

## Implementation Differences Across Repositories

### Trigger Patterns

**pull_request:** 50/54 repos
**push:** 52/54 repos
**schedule:** 10/54 repos
**workflow_call:** 6/54 repos
**workflow_dispatch:** 47/54 repos

### Pipeline Structure

**Single workflow:** 2 repos
  - pos-service-elera-krogerized, pos-service-instore-rabbitmq
**Multiple workflows:** 51 repos (avg: 4.9 workflows)

**Using reusable workflows (workflow_call):** 6/54 repos
  - payments-acceptance-workflow, pos-service-posaas, pos-service-tender-restrictions, pos-elera-dmo-service, pos-service-pinpad-connector, pos-service-tender-utility

### Enforcement Level

**Fully blocking (no continue-on-error):** 49/54 repos
**Non-blocking (has continue-on-error):** 5/54 repos
  - payments-acceptance-workflow, pos-elera-orchestration-api, pos-service-posaas, pos-service-pinpad-connector, pos-service-tender-utility

### Deployment Strategy

**Manual deployment (workflow_dispatch):** 7/54 repos
**Automatic deployment (push/release):** 17/54 repos
**No deployment:** 31/54 repos

### Tooling Differences

**snyk:** 15/54 repos
**sonar:** 31/54 repos

### Implementation Differences Summary

**Common Patterns:**
- Most common trigger: `push` (52/54 repos)
- Most common tool: sonar (31/54 repos)
- Average workflows per repo: 4.7

**Key Variations:**
- Pipeline complexity: 2 repos use single workflow, 51 use multiple workflows
- 6 repos leverage reusable workflows for standardization
- 5 repos use non-blocking checks (continue-on-error)
- Deployment strategies vary: manual, automatic

**Potential Reasons for Inconsistency:**
- Different service maturity levels (legacy vs new pipelines)
- Team preferences and organizational silos
- Mix of centralized reusable workflows and custom implementations
- Varying security and compliance requirements
- Gradual adoption of governance standards
