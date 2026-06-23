# AUTH-INTEGRATION IMPACT ANALYSIS

**Date:** May 18, 2026
**Prepared by:** Surya Pasala - NGPOS Architecture / Integration Analysis
**Scope:** 52 repositories across POS, Fuel, Payment, and Elera services

---

## EXECUTIVE SUMMARY

### Overview
Analysis of 52 repositories identified multiple authentication patterns for outbound HTTP integrations:
- **89 files** using WebClient (reactive HTTP client)
- **93 files** using RestTemplate (blocking HTTP client)
- **24 files** using FeignClient (declarative REST)
- **86 files** with OAuth patterns (OKTA, Ping, Client Credentials)

### Authentication Patterns
1. OAuth2 Client Credentials (Payment Hub, Gateway, MX services)
2. OAuth2 PKCE Flow (OKTA-based services)
3. Ping OAuth2 ROPC (Resource Owner Password Credentials)
4. Feign Manual Header Injection (Fuel services)
5. Basic Auth (legacy systems)

### Impact Summary
- **Direct Impact:** 15 repositories requiring code changes
- **Indirect Impact:** 20+ repositories needing configuration updates
- **Estimated Timeline:** 6-8 weeks for phased rollout
- **Risk Level:** MEDIUM-HIGH

---

## DECISIONS REQUIRED

Leadership must decide on the following before proceeding:

1. **Approach Selection:** Approve phased rollout with shared abstraction module vs. per-service manual implementation
2. **Timeline Commitment:** Allocate 6-8 weeks for phased implementation across 15 priority repositories
3. **Resource Allocation:** Assign dedicated team/owner for shared auth module development
4. **Risk Tolerance:** Approve canary deployment strategy for production services, especially payment systems
5. **Scope Boundaries:** Confirm which services are in-scope for initial rollout vs. deferred

---

## REPOSITORY CATEGORIZATION

### Tier 1: Production-Ready Auth Infrastructure (6 repositories)
Services with existing centralized auth patterns that can be adapted with minimal changes:

| Repository | Current Auth | Complexity | Effort |
|-----------|--------------|------------|--------|
| pos-service-tender-restrictions | OKTA/Ping TokenProvider | Medium | 2-3 days |
| pos-service-posaas | Dual auth with TokenScheduler | Medium | 3-4 days |
| payments-acceptance-workflow | Centralized AuthClientHelper | Low-Medium | 2-3 days |
| pos-elera-orchestration-api | OAuth2 TokenClient | Low | 1-2 days |
| pos-elera-sales-compliance | Ping/Kount with Redis cache | Medium | 2-3 days |
| pos-service-business-day-workflow | Conditional PingOne/PingFed | Low | 1-2 days |

**Key Characteristics:**
- Already have token caching and refresh mechanisms
- Centralized auth components in place
- High fallback feasibility
- Lower risk for pilot implementation

### Tier 2: Centralization Opportunities (16 repositories)

**Fuel Services (8 repos):** Split between manual Feign header injection and centralized auth services. Opportunity to create shared Feign auth configuration module.

**Elera Services (8 repos):** Mix of RestTemplate and WebClient patterns. Can leverage existing PingClient patterns with configuration-based toggles.

**Complexity:** Medium | **Effort:** 1-2 days per service after shared module created

### Tier 3: Minimal/No Outbound Auth (30 repositories)
Services with simple or no outbound authentication requirements. Configuration updates only, no code changes required initially.

---

## BLAST RADIUS

### Direct Impact: 15 Repositories
Repositories requiring code changes for toggle implementation:

| Repository | Lines Changed | Risk Level | Notes |
|-----------|---------------|------------|-------|
| pos-service-tender-restrictions | 50-100 | Medium | Dual OKTA/Ping providers |
| pos-service-posaas | 100-150 | Medium | Multiple scheduled token refreshes |
| payments-acceptance-workflow | 75-125 | Low | Centralized AuthClientHelper |
| pos-elera-orchestration-api | 25-50 | Low | Existing authEnabled pattern |
| pos-elera-sales-compliance | 50-75 | Medium | Redis cache integration needed |
| pos-service-business-day-workflow | 25-50 | Low | Conditional bean pattern exists |
| pos-service-customer-loyalty | 75-100 | Medium | Feign centralized auth |
| pos-service-FuelPriceChangeController | 50-75 | Medium | Kalibrate auth service |
| pos-service-fuel-transaction-workflow | 100-200 | High | Manual header pattern refactor |
| pos-service-fuel-core | 50-100 | Medium | Manual header pattern |
| pos-elera-receipt-api | 25-50 | Low | Standard PingClient pattern |
| pos-elera-dmo-service | 50-75 | Medium | RestTemplate configuration |
| pos-service-instore-accntg-ingress | 50-75 | Medium | Ping auth integration |
| pos-service-instore-till-management | 25-50 | Low | Simple auth pattern |
| pos-service-instore-data-loader | 25-50 | Low | Simple auth pattern |

**Total Estimated Code Changes:** 800-1,300 lines

### Indirect Impact: 20+ Repositories
Configuration-only updates required:
- Application property files (yaml/properties)
- Environment variable mappings
- Feature flag integration
- No immediate code changes

### Shared Library Dependencies
Existing auth libraries that may be affected:
- pos-utils-instore-ping-auth-client
- pos-utils-instore-ping-auth-client-isc
- pos-utils-instore-commons-library
- pos-utils-instore-ping-security

**Strategy:** Create new shared auth abstraction module rather than modifying existing libraries to avoid ripple effects

---

## ROLLOUT STRATEGY

### Phase 1: Foundation (Weeks 1-2)

**Objective:** Build shared infrastructure to minimize per-service changes

**Deliverables:**
1. **Shared Auth Abstraction Module** (`ngpos-auth-abstraction`)
   - Pluggable AuthProvider interface supporting Ping, Kroger, and OKTA
   - Configuration-driven provider selection
   - Fallback mechanism for provider failures
   - Single toggle point across all services

2. **Token Cache Service**
   - Redis/Caffeine-backed caching with configurable TTL
   - Reduces auth endpoint load by 80-90%
   - Pre-expiry refresh to avoid cache misses

3. **HTTP Client Interceptors**
   - Auto-configuration for WebClient and Feign
   - Automatic token injection in Authorization headers
   - Eliminates manual auth code in individual services

**Benefits:** Single toggle point, runtime switchable, consistent caching, reduced code duplication

---

### Phase 2: Pilot Implementation (Weeks 3-4)

**Target Services:** 3 low-risk repositories with existing auth patterns
- pos-elera-orchestration-api (has authEnabled flag)
- pos-service-business-day-workflow (conditional bean pattern)
- payments-acceptance-workflow (centralized AuthClientHelper)

**Validation:**
- Toggle switches auth provider without redeployment
- Fallback mechanism tested under failure scenarios
- Token caching validated (target: 80%+ reduction in auth calls)
- No functional regression

**Metrics to Monitor:**
- Auth endpoint call rate
- Token cache hit ratio (target: >90%)
- Auth failure rate by provider
- Fallback activation frequency

---

### Phase 3: Gradual Rollout (Weeks 5-6)

**Tier 1 Services:** 6 high-value repositories
- pos-service-tender-restrictions
- pos-service-posaas
- pos-elera-sales-compliance
- Plus 3 pilot services

**Rollout Approach:**
- Canary deployment: 10% → 50% → 100% of traffic
- Environment progression: dev → qa → stage → prod
- Automated rollback on error threshold breach

**Fuel Services Consolidation:**
- Create shared Feign auth configuration module
- Migrate centralized services to shared base
- Evaluate ROI for migrating manual header services

---

### Phase 4: Complete Migration (Weeks 7-8)

**Remaining Services:** 9 additional repositories
- Elera services (RestTemplate-based)
- Instore services (Ping auth with Kafka)
- Additional payment/fuel services

**Prioritization:**
- Services with Ping auth: HIGH (leverage existing patterns)
- Services with no outbound auth: SKIP
- Complex legacy auth: LOW (defer or manual approach)

**Closeout:**
- Migration documentation and runbooks
- Metrics dashboard for ongoing monitoring
- Architecture decision record (ADR)
- Knowledge transfer sessions

---

## IMPLEMENTATION OPPORTUNITIES

### Shared Components (Reusable Across All Services)

| Component | Benefit | Effort | Applicable To |
|-----------|---------|--------|---------------|
| Token Provider Abstraction | Reduces per-repo changes 70% | 3-5 days | All 15 direct impact repos |
| WebClient/Feign Auto-Config | Zero-code auth injection | 5-7 days | 89 WebClient + 24 Feign files |
| Centralized Token Cache | Reduces auth calls 80-90% | 2-3 days | All services with outbound auth |
| Feature Flag Integration | Runtime toggle without redeploy | 3-4 days | All services |
| Observability & Metrics | Real-time health monitoring | 2-3 days | All services |

**Total Investment:** 15-21 days for shared infrastructure
**ROI:** Eliminates 120-180 days of per-service manual implementation

---

## IMPLEMENTATION COMPLEXITY MATRIX

| Approach | Timeline | Total Effort | Risk | Code Reuse | Long-term Maintenance |
|----------|----------|--------------|------|------------|----------------------|
| Per-Service Manual | 16-24 weeks | 120-180 days | High | Low | High |
| Shared Module + Selective | 8-12 weeks | 60-90 days | Medium | High | Medium |
| **Phased with Abstraction (Recommended)** | **6-8 weeks** | **40-60 days** | **Low** | **Very High** | **Low** |

**Rationale:** Phased approach with shared abstraction maximizes code reuse, minimizes risk through incremental rollout, and reduces long-term maintenance burden.

---

## SUCCESS METRICS

### Technical KPIs
- Auth endpoint call reduction: 85%+ (via caching)
- Token cache hit rate: 90%+
- Auth failure rate: <0.1% with fallback enabled
- Toggle switch time: <5 minutes (config-only change)
- Code duplication reduction: 60%+

### Operational KPIs
- Service availability: Maintain 99.9%+ SLA during migration
- Deployment frequency: Increase 20% (faster auth changes)
- Mean time to recovery: Reduce 30% (toggle vs. redeploy)
- Developer velocity: Reduce auth implementation time 70%

### Migration Progress
- Services migrated: Track weekly progress toward 15 target repositories
- Regression defects: 0 critical defects
- Rollback events: < 2 during entire migration

---

## RISKS AND MITIGATION

| Risk Area | Impact | Probability | Mitigation Strategy |
|-----------|--------|-------------|---------------------|
| **Payment Service Failures** | Critical | Low | Extended 2-week canary, real-time transaction monitoring, instant rollback, dual-run both auth methods initially |
| **Fuel Service Disruption** | High | Medium | Retain manual pattern as fallback, gradual RequestInterceptor migration, per-service toggle control |
| **Token Cache Failures** | Medium | Low | Fetch fresh on cache miss, circuit breaker on cache service, fallback to non-cached flow, pre-expiry refresh buffer |
| **Multi-Tenant Auth Complexity** | Medium | Medium | Per-environment config profiles, tenant-specific provider selection, isolated cache keys |
| **Shared Library Breaking Changes** | High | Low | Create new module vs. modifying existing libraries, maintain backward compatibility during transition |
| **Production Outage During Rollout** | Critical | Low | Canary deployments, environment-based feature flags, automated rollback on error thresholds |

### Critical Success Factors
1. **Pilot validation** must demonstrate zero functional regression before broader rollout
2. **Payment services** require extra scrutiny due to financial impact
3. **Fallback mechanisms** must be tested under actual failure conditions, not just theoretical scenarios
4. **Monitoring and alerting** must be in place before each phase begins

---

## RECOMMENDATIONS

### Immediate (Week 1)
1. Review and approve phased approach with shared abstraction
2. Create Jira epic for auth abstraction initiative
3. Assign dedicated team/owner for shared module development
4. Schedule Phase 1 kickoff meeting with stakeholders

### Short-Term (Weeks 2-4)
1. Build `ngpos-auth-abstraction` shared module
2. Implement pilot in 3 low-risk services (pos-elera-orchestration-api, pos-service-business-day-workflow, payments-acceptance-workflow)
3. Configure observability dashboard and alerting
4. Document migration patterns and troubleshooting guide

### Medium-Term (Weeks 5-8)
1. Roll out to Tier 1 services (6 repositories) using canary deployment
2. Publish shared Feign auth configuration module for Fuel services
3. Monitor technical and operational KPIs, adjust rollout pace based on results
4. Incorporate pilot learnings into remaining service migrations

### Long-Term (Post-Migration)
1. Complete migration of all 15 priority repositories
2. Deprecate legacy auth patterns in favor of shared module
3. Conduct knowledge transfer sessions with service teams
4. Evaluate service mesh or next-generation auth solutions for future simplification

---

## NEXT STEPS

1. **Review Meeting:** Schedule stakeholder review session to approve approach and timeline
2. **Resource Allocation:** Identify and assign team for shared module development
3. **Jira Setup:** Create epic and initial stories for Phase 1 deliverables
4. **Pilot Planning:** Coordinate with owners of 3 pilot services for Phase 2 implementation

---

**Document Version:** 1.0
**Last Updated:** May 18, 2026
**Stakeholders:** NGPOS Architecture, Payment Services, Fuel Services, Elera Integration


