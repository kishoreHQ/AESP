# AESP-0010: Testing & Validation, Continued

## 5. Execution Semantics

Execution turns a resolved suite selection into case outcomes under a controlled environment.

### 5.1 Execution Pipeline

A conforming session SHOULD progress through:

1. Authorize requester and resolve policy packs.
2. Resolve subjects and pin digests/revisions.
3. Resolve suite catalog and selection.
4. Provision or attach environment.
5. Execute cases (possibly sharded/parallel).
6. Collect logs, artifacts, coverage.
7. Classify flakes if enabled.
8. Evaluate quality gates.
9. Persist evidence package and emit response.

`TEST-REQ-044`: Subjects MUST be pinned (digest or immutable revision) before gating runs for production-bound evidence.

`TEST-REQ-045`: Stage failures MUST identify the failing stage and MUST NOT claim later stages succeeded.

`TEST-REQ-046`: Runners MUST enforce declared resource budgets (time, parallelism, memory) when configured.

### 5.2 Ordering, Parallelism, and Sharding

`TEST-REQ-047`: Parallel execution MUST preserve case isolation expectations declared by the suite; tests marked serial MUST not run concurrently with conflicting cases.

`TEST-REQ-048`: Sharding MUST be deterministic for a fixed shard count, shard index, and suite version when determinism mode requires it.

`TEST-REQ-049`: Aggregate session results MUST merge shards without dropping cases or double-counting.

### 5.3 Retries and Flake Detection

`TEST-REQ-050`: Retries MUST be bounded by configured max attempts.

`TEST-REQ-051`: A case that both fails and passes across retries in the same session MUST be classified as flaky (or equivalent) in results.

`TEST-REQ-052`: Retry-on-failure policies MUST record each attempt outcome; only the final gate-relevant interpretation is used for pass/fail, but attempts remain auditable.

`TEST-REQ-053`: Silent infinite retries are non-conformant.

### 5.4 Determinism Modes

`TEST-REQ-054`: Sessions MUST declare determinism mode: `reproducible`, `best-effort`, or `exploratory` (for example fuzz campaigns).

`TEST-REQ-055`: For `reproducible` mode, environment class, tool versions, seeds, and subject pins MUST be recorded.

`TEST-REQ-056`: Fuzz and chaos sessions MAY be exploratory but MUST still produce evidence packages when used as risk signals.

### 5.5 Cancellation and Timeouts

`TEST-REQ-057`: Authorized actors MUST be able to cancel running sessions.

`TEST-REQ-058`: Timeouts MUST yield `timed-out` status and partial results when available, clearly marked incomplete.

`TEST-REQ-059`: Cancelled and timed-out sessions MUST retain audit history according to retention policy.

### 5.6 Runner Isolation

`TEST-REQ-060`: Untrusted tests (for example from untrusted forks or unreviewed agent PRs) SHOULD run in isolated environments with least privilege.

`TEST-REQ-061`: Network egress during tests MUST be deny-by-default for untrusted sessions when policy requires.

`TEST-REQ-062`: Containers or VMs used as runners MUST record image digests when reproducible mode is claimed.

### 5.7 Integration with Workflows

`TEST-REQ-063`: When invoked from AESP-0005, session ids MUST correlate with workflow instance and task ids.

`TEST-REQ-064`: Workflow retries MUST create linked sessions or explicit retry records rather than mutating completed evidence.

## 6. Coverage, Oracles, and Quality Gates

### 6.1 Oracles

`TEST-REQ-065`: Each test case MUST declare or inherit an oracle class: `assert`, `contract`, `snapshot`, `metamorphic`, `differential`, `human`, or namespaced extension.

`TEST-REQ-066`: Snapshot oracles MUST fail on unexpected drift and MUST require explicit accept operations to update baselines.

`TEST-REQ-067`: Human oracles MUST record reviewer identity and decision when they determine gate outcomes.

### 6.2 Coverage Signals

Coverage may include line, branch, condition, path, mutation score, API operation coverage, or requirements coverage.

`TEST-REQ-068`: When coverage gates are configured, the coverage tool identity and version MUST be recorded.

`TEST-REQ-069`: Coverage numbers MUST identify the subject digest they measure.

`TEST-REQ-070`: Coverage thresholds alone MUST NOT be treated as proof of correctness; they are signals for gates, not substitutes for oracles.

`TEST-REQ-071`: Generated tests MUST NOT inflate coverage gates without being included in catalog identity and flake analytics.

### 6.3 Quality Gates

`TEST-REQ-072`: Gate evaluation MUST produce a structured outcome: `pass`, `fail`, or `pass-with-warnings`.

`TEST-REQ-073`: Gate inputs MUST be explicit (for example max failed blocking tests, max flake rate, min coverage, required suite set).

`TEST-REQ-074`: Gate policy packs MUST be versioned.

`TEST-REQ-075`: Overriding a failed gate for production progression MUST be an authenticated break-glass action with reason and audit.

### 6.4 Requirements and Traceability

`TEST-REQ-076`: Cases MAY link to requirement, user story, or risk identifiers.

`TEST-REQ-077`: Acceptance suites used for release SHOULD report requirements coverage when requirement ids are present.

`TEST-REQ-078`: Traceability links MUST be durable in evidence packages when used for compliance claims.

### 6.5 Performance and Security Gate Specifics

`TEST-REQ-079`: Performance gates MUST compare measured metrics against declared thresholds or baselines with versioned workload profiles.

`TEST-REQ-080`: Security findings mapped into test results MUST include severity and whether they are blocking.

`TEST-REQ-081`: Informational security findings MUST NOT silently become blocking without policy change.

## 7. Environments and Data Management

### 7.1 Environment Classes

Common classes: `local`, `ephemeral-ci`, `shared-integration`, `staging`, `production-smoke`.

`TEST-REQ-082`: Every session MUST record environment class and a fingerprint sufficient to debug differences (tool versions, OS, service dependency versions when known).

`TEST-REQ-083`: Production-smoke sessions MUST minimize side effects and MUST declare write-safety constraints.

`TEST-REQ-084`: Shared environments MUST support contention controls or scheduling to avoid cross-talk false failures when used for gating.

### 7.2 Fixtures and Test Data

`TEST-REQ-085`: Fixtures MUST be versioned or content-hashed when they affect gating outcomes.

`TEST-REQ-086`: Synthetic data generation parameters and seeds MUST be recorded for reproducible sessions.

`TEST-REQ-087`: Production data cloning for tests MUST follow privacy policy; presence of personal data MUST be classified and access-controlled.

`TEST-REQ-088`: Tests MUST clean up mutable shared state they create, or use unique namespacing to avoid pollution; pollution-related failures SHOULD be classified as environment errors when detected.

### 7.3 Service Dependencies and Test Doubles

`TEST-REQ-089`: Suites MUST declare whether dependencies are real, containerized, or mocked/doubled.

`TEST-REQ-090`: Contract tests against mocks MUST NOT be reported as full integration proof for the real dependency.

`TEST-REQ-091`: Record/replay stubs MUST pin recording versions and fail on unhandled interactions according to suite policy.

### 7.4 Secrets in Test Environments

`TEST-REQ-092`: Secrets required for tests MUST be injected via secret references, not stored in suite definitions as plaintext.

`TEST-REQ-093`: Evidence packages MUST redact secret values from logs and artifacts when detected by configured scanners.

## 8. Results, Reporting, and Lifecycle

### 8.1 Case Result Model

`TEST-REQ-094`: Each case result MUST include case id, outcome, duration, and optional message/details references.

`TEST-REQ-095`: Failed and errored cases MUST include enough diagnostic reference (message, log pointer, artifact pointer) to support triage.

`TEST-REQ-096`: Results MUST be immutable after session terminal state.

### 8.2 Evidence Packages

```json
{
  "sessionId": "urn:aeo:test:session:payments-pr-8842",
  "subjects": [{ "digest": "sha256:example" }],
  "summary": { "passed": 1200, "failed": 2, "flaky": 1, "skipped": 15 },
  "gate": { "outcome": "fail", "policy": "urn:aeo:policy:test-gate:payments:3" },
  "artifacts": [
    "urn:aeo:evidence:junit:payments-pr-8842",
    "urn:aeo:evidence:coverage:payments-pr-8842"
  ],
  "provenance": "urn:aeo:provenance:test:payments-pr-8842"
}
```

`TEST-REQ-097`: Every terminal session MUST produce an evidence package reference.

`TEST-REQ-098`: Evidence packages MUST include subject pins, suite selection, environment fingerprint, summary counts, gate outcome, and provenance.

`TEST-REQ-099`: Consumers (including AESP-0009) MUST be able to retrieve gate outcome without parsing proprietary CI UI state.

### 8.3 Lifecycle States for Suite Catalog Entries

| State | Meaning |
|:---|:---|
| `active` | Eligible for selection and gating |
| `quarantined` | Excluded from gating with tracking |
| `deprecated` | Discouraged; may still run |
| `retired` | Not selected by default; retained historically |

`TEST-REQ-100`: Catalog state transitions MUST be auditable.

`TEST-REQ-101`: Retired tests MUST remain queryable for historical sessions.

### 8.4 Reporting and Notifications

`TEST-REQ-102`: Implementations SHOULD emit structured notifications for gate failures and flake budget breaches.

`TEST-REQ-103`: Reports MUST support both human-readable and machine-readable forms.

`TEST-REQ-104`: Trend analytics (pass rate, flake rate, duration) SHOULD key off stable case ids.

### 8.5 Retention

`TEST-REQ-105`: Evidence retention MUST follow organization policy; production release evidence MUST be retained at least as long as related deployment provenance when used as a deploy gate.

`TEST-REQ-106`: Deletion of gate evidence for released artifacts MUST be authorized and audited.
