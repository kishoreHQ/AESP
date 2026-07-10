# AESP-0010: Testing & Validation, Reference

## 9. Security and Policy

Testing systems execute untrusted code, hold credentials, and produce release evidence. AESP-0010 treats security as intrinsic.

### 9.1 Threat Model

Relevant threats include:

1. Malicious tests exfiltrating secrets or pivoting via CI network.
2. Poisoned fixtures or snapshots.
3. Gate bypass or status forgery.
4. Coverage gaming with generated vacuous tests.
5. Flake-driven alert fatigue masking real failures.
6. Production-smoke tests causing customer impact.
7. Evidence tampering after the fact.

`TEST-REQ-107`: Conforming implementations MUST document their testing threat model or adopt the AESP-0010 baseline threats above.

`TEST-REQ-108`: Untrusted subject tests MUST run with isolation and secret minimization controls appropriate to trust level.

### 9.2 Authorization

`TEST-REQ-109`: Test requests MUST be authorized for the subjects and environments they access.

`TEST-REQ-110`: Break-glass gate overrides MUST be authenticated, authorized, reasoned, and audited.

`TEST-REQ-111`: Catalog quarantine and criticality changes MUST require authorization commensurate with risk.

### 9.3 Integrity of Evidence

`TEST-REQ-112`: Evidence packages used for production deploy gates MUST be integrity-protected (hash, signature, or append-only store).

`TEST-REQ-113`: Gate outcome APIs MUST prevent unauthorized actors from writing pass outcomes.

`TEST-REQ-114`: Subject digest in evidence MUST match the artifact later deployed when the evidence is cited by AESP-0009 prechecks.

### 9.4 Policy Packs

`TEST-REQ-115`: Policy packs MUST be versioned and referenceable.

`TEST-REQ-116`: Effective policy for a session MUST be computable and exportable.

`TEST-REQ-117`: Policy evaluation details MUST be included or referenced from the evidence package.

### 9.5 Data Protection

`TEST-REQ-118`: Tests processing personal data MUST declare data classification and retention constraints.

`TEST-REQ-119`: Logs and artifacts MUST be scanned or filtered for secrets before broad publication.

## 10. Implementation Guidelines

This chapter is non-normative unless a requirement explicitly binds behavior.

### 10.1 Minimum Viable Implementation

A minimum viable AESP-0010 implementation can be built with:

1. Request/response API with session ids.
2. Two test types (for example unit + integration).
3. JUnit-like result ingestion.
4. Subject digest recording.
5. Basic gate (fail on failed blocking tests).
6. Evidence package persistence.

`TEST-REQ-120`: A Level 1 implementation MUST provide request/session model, subject pinning, stable case ids for gated tests, structured results, basic gate outcome, and evidence package references.

### 10.2 Recommended Architecture

| Tier | Components |
|:---|:---|
| Control | Request API, policy/gates, catalog, session orchestrator |
| Execution | Runners, sharded workers, environment provisioners |
| Evidence | Result store, artifact store, coverage store, provenance |
| Insight | Flake analytics, impact analysis, trends |

`TEST-REQ-121`: Control-plane gate decisions MUST NOT be bypassable by worker self-assertion in conforming deployments.

### 10.3 Mapping Common Tooling

Implementations commonly wrap language runners, Playwright/Cypress, Pact, k6, and security scanners behind AESP-0010 session semantics.

`TEST-REQ-122`: Tool versions that affect outcomes MUST be recorded in environment fingerprints.

`TEST-REQ-123`: Proprietary report formats MAY be stored as artifacts but MUST be accompanied by a normalized summary for interoperability.

### 10.4 Agent OS Placement

In an Agent OS built on AESP, AESP-0010 is the **proof surface** of the infrastructure layer:

```text
Operations     0011–0015  observe, remediate, secure, HITL, integrate
Infrastructure 0006–0010  know, generate, document, deploy, test  ← you are here
Foundation     0000–0005  govern, model, authorize, communicate, remember, orchestrate
```

Testing closes the loop between generation (0007) and deployment (0009): agents may change the system only when evidence packages satisfy policy.

`TEST-REQ-124`: Implementations SHOULD expose evidence packages as AESP-0001 Resources with stable IRIs.

### 10.5 Anti-Patterns

The following practices are non-conformant or strongly discouraged:

- Using only end-to-end tests for all confidence.
- Retrying until green without flake classification.
- Counting coverage from untracked generated tests.
- Deploying with CI “green” UI state but no durable evidence package.
- Running untrusted PR tests on privileged runners with production secrets.
- Quarantining failures indefinitely without expiry.
- Treating snapshot updates as routine without review.

## 11. Conformance and Testing

### 11.1 Conformance Levels

| Level | Name | Scope |
|:---|:---|:---|
| L1 | Basic Test | Request/session, subject pins, ≥2 types, structured results, basic gate, evidence reference |
| L2 | Governed Test | Catalog identity, quarantine, flake detection, versioned gate policy, workflow correlation, isolation controls |
| L3 | Enterprise Assurance | Impact selection, requirements traceability, integrity-protected release evidence, advanced security/perf gates, exportable audit |

`TEST-REQ-125`: A conforming implementation MUST declare its AESP-0010 conformance level.

`TEST-REQ-126`: L1 implementations MUST satisfy `TEST-REQ-001` through `TEST-REQ-029`, `TEST-REQ-044` through `TEST-REQ-046`, `TEST-REQ-057` through `TEST-REQ-059`, `TEST-REQ-072` through `TEST-REQ-074`, `TEST-REQ-094` through `TEST-REQ-099`, `TEST-REQ-107` through `TEST-REQ-110`, and `TEST-REQ-120`.

`TEST-REQ-127`: L2 implementations MUST satisfy all L1 requirements plus flake/quarantine, catalog lifecycle, environment isolation, and workflow correlation requirements.

`TEST-REQ-128`: L3 implementations MUST satisfy all L2 requirements plus impact selection, traceability, evidence integrity, and enterprise policy/audit requirements.

### 11.2 Interoperability Expectations

`TEST-REQ-129`: Independent implementations MUST exchange request/response and summary result documents in JSON without proprietary mandatory fields; extensions MAY use namespaced keys.

`TEST-REQ-130`: Evidence summaries MUST be interpretable by deploy controllers and audit tools given this specification.

`TEST-REQ-131`: Conformance claims MUST list supported test types, selection modes, and gate kinds.

### 11.3 Quality Metrics

Implementations SHOULD track:

| Metric | Description |
|:---|:---|
| Gate fail rate | Sessions failing gates |
| Flake rate | Flaky cases / executed cases |
| Mean time to feedback | Request to terminal status |
| Quarantine age | Age of open quarantines |
| Escaped defect rate | Production incidents without preceding failing gate |
| Suite duration growth | Duration trend by suite |

`TEST-REQ-132`: Conformance suites MUST include request validation, subject pinning, result integrity, and basic gate evaluation tests.

`TEST-REQ-133`: Flake suites for L2+ MUST demonstrate multi-attempt classification.

`TEST-REQ-134`: Security suites MUST include untrusted isolation and gate override audit tests.

### 11.4 Test Vectors

`TEST-REQ-135`: Test vectors MUST cover each test type an implementation claims.

`TEST-REQ-136`: Negative tests MUST cover invalid selection, environment failure, timeout, cancellation, and gate failure.

`TEST-REQ-137`: Integration tests with AESP-0009 MUST verify that deploy prechecks can consume evidence packages and reject digest mismatches.

### 11.5 Agent and System Evaluation Campaigns

Software test suites (unit/integration) are necessary but not sufficient for Agent OS quality. Evaluation campaigns assess agent trajectories, costs, and safety.

`TEST-REQ-138`: An evaluation campaign MUST declare: dataset or scenario pack id/version, subject agent or runtime version, metrics (at least task success rate), and budget limits.

`TEST-REQ-139`: Campaign results MUST be immutable evidence packages with subject pins, metric summaries, and per-scenario outcomes.

`TEST-REQ-140`: Safety evaluations (prompt injection, tool abuse) SHOULD be separable from capability evaluations in reporting.

`TEST-REQ-141`: Evaluation campaigns MUST NOT silently mutate production systems; side effects require isolated environments or record/replay harnesses.

`TEST-REQ-142`: When evaluation gates release promotion of an agent/plugin version, gate policy MUST reference campaign evidence package ids.

`TEST-REQ-143`: L3 implementations SHOULD support evaluation campaigns; L2 MAY.

## 12. Appendices

### 12.1 Example Gate Policy Pack

```yaml
id: urn:aeo:policy:test-gate:payments:3
version: 3.0.0
requiredSuites:
  - unit:payments
  - contract:payments-openapi
failOn:
  - failed
  - error
maxFlakeRate: 0.02
coverage:
  line: 0.80
breakGlass:
  roles: [urn:aeo:role:release-manager]
  requiresReason: true
```

### 12.2 Example Case Result

```json
{
  "caseId": "urn:aeo:test:case:payments:unit:retry-backoff",
  "outcome": "failed",
  "durationMs": 42,
  "message": "expected delay 100ms, got 0ms",
  "attempt": 1,
  "artifacts": ["urn:aeo:evidence:log:payments-pr-8842:case-77"]
}
```

### 12.3 Error Code Registry (Baseline)

| Code | Stage | Meaning |
|:---|:---|:---|
| `TEST-ERR-REQUEST-INVALID` | request validation | Request fails schema or required fields |
| `TEST-ERR-AUTHZ` | authorization | Requester not permitted |
| `TEST-ERR-SUBJECT` | resolution | Subject unresolved or digest missing |
| `TEST-ERR-SUITE` | resolution | Suite/selector invalid |
| `TEST-ERR-ENV` | environment | Provisioning or fingerprint failure |
| `TEST-ERR-RUNNER` | execution | Runner infrastructure failure |
| `TEST-ERR-TIMEOUT` | execution | Budget exceeded |
| `TEST-ERR-CANCELLED` | execution | Cancelled by authorized actor |
| `TEST-ERR-GATE` | gating | Quality gate failed |

### 12.4 Requirement Index

Requirements `TEST-REQ-001` through `TEST-REQ-143` define the normative surface of this draft. Future revisions SHOULD preserve identifiers and append new identifiers rather than renumbering existing requirements.

| Range | Domain |
|:---|:---|
| `TEST-REQ-001` to `TEST-REQ-017` | Testing Model Architecture |
| `TEST-REQ-018` to `TEST-REQ-029` | Test Taxonomy |
| `TEST-REQ-030` to `TEST-REQ-043` | Test Generation and Authoring |
| `TEST-REQ-044` to `TEST-REQ-064` | Execution Semantics |
| `TEST-REQ-065` to `TEST-REQ-081` | Coverage, Oracles, and Quality Gates |
| `TEST-REQ-082` to `TEST-REQ-093` | Environments and Data |
| `TEST-REQ-094` to `TEST-REQ-106` | Results, Reporting, and Lifecycle |
| `TEST-REQ-107` to `TEST-REQ-119` | Security and Policy |
| `TEST-REQ-120` to `TEST-REQ-137` | Implementation and Conformance |
| `TEST-REQ-138` to `TEST-REQ-143` | Agent/System Evaluation Campaigns |

# References

[^1^]: JUnit, "JUnit 5 User Guide", accessed 2026-07-10, https://junit.org/junit5/docs/current/user-guide/

[^2^]: Pact, "Pact documentation", accessed 2026-07-10, https://docs.pact.io/

[^3^]: Hypothesis, "Property-based testing", accessed 2026-07-10, https://hypothesis.works/

[^4^]: Fowler, M., "Continuous Integration", accessed 2026-07-10, https://martinfowler.com/articles/continuousIntegration.html

[^5^]: Google Testing Blog, "Test impact analysis / related practices", accessed 2026-07-10, https://testing.googleblog.com/

[^6^]: PIT, "Mutation testing", accessed 2026-07-10, https://pitest.org/

[^7^]: Bradner, S., "Key words for use in RFCs to Indicate Requirement Levels", BCP 14, RFC 2119, March 1997, https://www.rfc-editor.org/rfc/rfc2119

[^8^]: OWASP, "Web Security Testing Guide", accessed 2026-07-10, https://owasp.org/www-project-web-security-testing-guide/

[^9^]: W3C, "WebDriver", accessed 2026-07-10, https://www.w3.org/TR/webdriver/

[^10^]: CNCF, "Cloud Native Glossary — Observability/Testing related terms", accessed 2026-07-10, https://glossary.cncf.io/
