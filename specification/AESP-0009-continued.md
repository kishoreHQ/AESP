# AESP-0009: Deployment Automation, Continued

## 5. Deployment Execution

Deployment execution turns a validated request into infrastructure change, verification, and durable evidence.

### 5.1 Execution Pipeline

A conforming session SHOULD progress through:

1. Authorize requester and evaluate freeze windows.
2. Resolve approvals.
3. Precheck artifacts (availability, signature, policy, dependency).
4. Snapshot current desired/observed state for rollback.
5. Execute strategy steps.
6. Evaluate health gates between steps and at completion.
7. Finalize (promote traffic, scale down old version, record success) or abort/rollback.
8. Emit response and persist provenance.

`DEP-REQ-052`: Implementations MUST snapshot the rollback baseline before mutating production desired state when rollback mode is not `none`.

`DEP-REQ-053`: Prechecks MUST fail closed for production when artifact digest cannot be verified or required signatures fail.

`DEP-REQ-054`: Stage failures MUST identify the failing stage and MUST NOT claim later stages succeeded.

### 5.2 Pre-deploy Hooks

`DEP-REQ-055`: Requests MAY declare pre-deploy hooks (migrations dry-run, capacity checks, change tickets).

`DEP-REQ-056`: Failed required pre-deploy hooks MUST block deployment.

`DEP-REQ-057`: Hook executions MUST be recorded with command/procedure identity, version, status, and duration.

### 5.3 Deploy Step Semantics

`DEP-REQ-058`: Each strategy step MUST emit progress events including step index, desired weight or replica counts, and observed readiness.

`DEP-REQ-059`: Progress events MUST include session identifier and a monotonic sequence number or timestamp.

`DEP-REQ-060`: Controllers MUST enforce step order; skipping a required gate evaluation is non-conformant.

### 5.4 Post-deploy Hooks

`DEP-REQ-061`: Post-deploy hooks (smoke tests, cache warmers, synthetic transactions) MAY be required by environment policy.

`DEP-REQ-062`: Required post-deploy hook failure MUST transition the session according to failure policy (`abort`, `rollback`, or `succeeded-with-warnings` only if explicitly allowed).

### 5.5 Cancellation, Pause, and Abort

`DEP-REQ-063`: Authorized actors MUST be able to pause progressive rollouts that support pause.

`DEP-REQ-064`: Authorized actors MUST be able to abort an in-progress deployment.

`DEP-REQ-065`: Abort of a traffic-affecting deploy MUST trigger the configured rollback or safe-stop procedure.

`DEP-REQ-066`: Cancellation before infrastructure mutation MAY terminate without rollback; after mutation, cancellation MUST be treated as abort.

### 5.6 Timeouts

`DEP-REQ-067`: Sessions MUST support overall and per-step timeouts.

`DEP-REQ-068`: Timeout MUST produce a structured error and apply failure policy (abort/rollback) for production-affecting sessions.

### 5.7 Provenance and Evidence

`DEP-REQ-069`: Every completed or rolled-back session MUST produce a provenance record including request id, session id, artifact digest, environment, targets, strategy, gate results, actor identities, timestamps, and prior artifact baseline.

`DEP-REQ-070`: Provenance MUST support lineage from artifact build/generation (when known) to deployment session to runtime revision.

`DEP-REQ-071`: Evidence references (logs, metrics windows, approval records) MUST be linkable from the session without embedding secret material.

### 5.8 Workflow Correlation

`DEP-REQ-072`: When invoked from AESP-0005, the deployment session id MUST correlate with workflow instance id and task id.

`DEP-REQ-073`: Workflow retries MUST be idempotent with respect to artifact+environment+release key, or MUST create an explicitly new session with lineage to the prior attempt.

## 6. Health Gates and Progressive Delivery

### 6.1 Gate Model

A health gate evaluates whether a rollout may proceed.

| Gate Class | Examples |
|:---|:---|
| Readiness | replica ready counts, health endpoints |
| Synthetic | smoke tests, transaction probes |
| SLO metrics | error rate, latency, saturation |
| Business | conversion, checkout success |
| Security | runtime policy violations |
| Approval | human or automated change approval |

`DEP-REQ-074`: Every progressive delivery step that increases blast radius MUST declare one or more gates or an explicit audited waiver.

`DEP-REQ-075`: Gate definitions MUST include metric or check identity, threshold or condition, evaluation window, and failure action.

`DEP-REQ-076`: Gate results MUST be durable and linked from the session.

### 6.2 Metric Gates

`DEP-REQ-077`: Metric gates MUST specify data source, query, comparison operator, threshold, and minimum sample requirements when applicable.

`DEP-REQ-078`: Insufficient sample size SHOULD fail closed or extend the evaluation window according to policy; silent pass is non-conformant for required gates.

`DEP-REQ-079`: Canary metric gates SHOULD compare against a control baseline (previous version or stable cohort) when baseline data is available.

### 6.3 Automated Analysis

`DEP-REQ-080`: Automated canary analysis engines MAY be used; their algorithm identity and version MUST be recorded.

`DEP-REQ-081`: Analysis verdicts MUST be one of `pass`, `fail`, `inconclusive`, or organization-defined equivalents with mapped semantics.

`DEP-REQ-082`: `inconclusive` MUST NOT advance production blast radius unless policy explicitly permits and records the risk acceptance.

### 6.4 Holds and Manual Judgment

`DEP-REQ-083`: Sessions MAY enter `paused` awaiting human judgment between steps.

`DEP-REQ-084`: Human resume or abort decisions MUST be authenticated, authorized, and audited.

`DEP-REQ-085`: Pause timeouts MUST escalate or abort according to policy; indefinite silent pause is non-conformant for production.

### 6.5 Traffic Management

`DEP-REQ-086`: Traffic weights for canary/blue-green MUST be observed and reported, not only desired.

`DEP-REQ-087`: When actual traffic weight diverges materially from desired weight beyond tolerance, the controller MUST alert and apply failure policy if uncorrected before timeout.

`DEP-REQ-088`: Sticky sessions and header-based canaries MUST be documented in the strategy when used, because they change exposure semantics.

## 7. Rollback

### 7.1 Rollback Modes

| Mode | Meaning |
|:---|:---|
| `automatic-on-gate-fail` | Controller rolls back without waiting for human |
| `manual` | Human must initiate rollback |
| `compensate` | Forward fix or compensating workflow instead of classic rollback |
| `none` | No rollback path (requires justification) |

`DEP-REQ-089`: Production deployments MUST declare a rollback mode.

`DEP-REQ-090`: `none` is permitted only with explicit justification and compensating controls recorded on the request.

`DEP-REQ-091`: Automatic rollback MUST target a known-good baseline captured before the deploy when available.

### 7.2 Rollback Execution

`DEP-REQ-092`: Rollback MUST create auditable state transitions (`rolling-back` → `rolled-back` or `failed`).

`DEP-REQ-093`: Rollback success criteria MUST include restoration of prior artifact desired state or declared safe state.

`DEP-REQ-094`: If rollback fails, the session MUST remain in a failed terminal state with high-severity alerting hooks.

`DEP-REQ-095`: Data migrations that cannot be rolled back automatically MUST be declared in the request and MUST reference a compensating procedure.

### 7.3 Abort vs Rollback

`DEP-REQ-096`: Abort stops forward progress; rollback actively restores prior state. Implementations MUST distinguish these concepts in status and events.

`DEP-REQ-097`: For canaries, abort at 5% traffic MUST restore traffic to the stable version unless a different safe-stop is declared.

### 7.4 Post-rollback Duties

`DEP-REQ-098`: After rollback, sessions SHOULD emit incident-correlation identifiers for observability and remediation systems.

`DEP-REQ-099`: Rolled-back artifacts MUST remain marked as rejected for that environment until a new successful session redeploys them.

## 8. Environment Promotion

### 8.1 Promotion Chains

A promotion chain defines allowed movement of release candidates across environments, for example `dev → staging → prod`.

`DEP-REQ-100`: Organizations SHOULD declare promotion graphs for production-bound artifacts.

`DEP-REQ-101`: Promotion to an environment MUST require that the artifact previously succeeded in required predecessor environments when a chain is declared, unless a break-glass override is used.

`DEP-REQ-102`: Break-glass promotions MUST be authenticated, authorized, time-bounded, and audited.

### 8.2 Promotion Requests

`DEP-REQ-103`: Promotion MAY be modeled as a deployment request with `intent: promote` or as a distinct promotion resource that creates environment-specific deploy sessions.

`DEP-REQ-104`: Promotion records MUST reference source environment session evidence (test results, gate reports) when required by policy.

`DEP-REQ-105`: Rebuilding an artifact with a new digest MUST NOT inherit production eligibility from a different digest, even if git commit matches, unless rebuild reproducibility is proven and policy allows.

### 8.3 Freeze Windows and Change Calendars

`DEP-REQ-106`: Environments MAY define freeze windows that block or require elevated approval for deploys.

`DEP-REQ-107`: Active freezes MUST fail closed for unauthorized deploy attempts.

`DEP-REQ-108`: Freeze bypass MUST be an explicit break-glass path with audit.

### 8.4 Multi-region and Multi-cloud Promotion

`DEP-REQ-109`: Multi-region rollouts MUST declare region order and blast-radius limits.

`DEP-REQ-110`: Failure in one region MUST apply declared policy (`stop`, `continue-other-regions`, `rollback-all`).

`DEP-REQ-111`: Cross-cloud deployments MUST record provider-specific target identities while preserving canonical artifact digests.

### 8.5 Release Trains and Batching

`DEP-REQ-112`: Implementations MAY batch multiple services into a release train; each service still MUST have identifiable sessions or sub-sessions.

`DEP-REQ-113`: Partial train failure MUST not leave ambiguous success: each component outcome MUST be explicit.

### 8.6 Coupling to Documentation and Runbooks

`DEP-REQ-114`: When release notes or runbooks are required by policy, missing required docs package references MUST fail precheck.

`DEP-REQ-115`: Deployment provenance SHOULD link to AESP-0008 document set versions when release documentation is produced.
