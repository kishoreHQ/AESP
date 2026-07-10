# AESP-0011: Observability, Continued

## 5. Collection and Pipelines

### 5.1 Pipeline Model

`OBS-REQ-033`: Telemetry pipelines MUST support collect → process → export stages.

`OBS-REQ-034`: Processors MUST be able to filter, redact, sample, batch, and route by attribute.

`OBS-REQ-035`: Pipeline configuration MUST be versioned and auditable when used in production AEOs.

### 5.2 Sampling

`OBS-REQ-036`: Trace sampling strategies MUST be declared (`always_on`, `probabilistic`, `rate_limiting`, `tail-based`, or extension).

`OBS-REQ-037`: Tail-based sampling decisions MUST be recorded when available for audit of dropped high-value traces.

`OBS-REQ-038`: Error spans and work-unit-failure spans SHOULD be preferentially retained relative to successful noise.

### 5.3 Exporters and Backends

`OBS-REQ-039`: Exporters MUST declare signal types supported and reliability guarantees (at-most-once vs at-least-once best effort).

`OBS-REQ-040`: Backend outages MUST NOT crash instrumented agents by default; buffering and drop policies MUST be configurable and observable.

`OBS-REQ-041`: Dropped signal counts MUST be measurable.

### 5.4 Multi-tenant Pipelines

`OBS-REQ-042`: Multi-tenant Agent OS deployments MUST isolate telemetry by tenant or organization attribute before cross-tenant query.

`OBS-REQ-043`: Cross-tenant aggregation queries MUST require elevated authorization.

## 6. SLOs and Alerting

### 6.1 SLI Definition

`OBS-REQ-044`: An SLI MUST declare name, metric or query, good-event definition, and total-event definition (or equivalent ratio form).

`OBS-REQ-045`: SLIs MUST be versioned.

### 6.2 SLO Definition

`OBS-REQ-046`: An SLO MUST declare SLI reference, target (for example 99.9%), and compliance window (for example 28d or 30d).

`OBS-REQ-047`: Error budget remaining MUST be computable from SLO state.

`OBS-REQ-048`: SLO objects MUST identify the owner team or agent role responsible for response.

### 6.3 Alert Rules

`OBS-REQ-049`: Alert rules MUST declare condition, severity, evaluation interval, for-duration (pending window), and notification routes.

`OBS-REQ-050`: Multi-window multi-burn-rate alerts are RECOMMENDED for SLO burn [^3^].

`OBS-REQ-051`: Alert firings MUST include labels sufficient to identify resource, SLO (if any), and correlation keys when available.

### 6.4 Notification and Silences

`OBS-REQ-052`: Notification channels MUST be addressable resources with auth configuration stored securely.

`OBS-REQ-053`: Silences/mutes MUST be time-bounded, authorized, and audited.

`OBS-REQ-054`: Alert flapping MUST be mitigable via pending windows or hysteresis.

### 6.5 Agent-Consumable Alerts

`OBS-REQ-055`: Alerts intended for autonomous remediation MUST be available as structured events (not only email HTML).

`OBS-REQ-056`: Structured alert events MUST include severity, fingerprint, resource, start time, and deep-link or query references.

## 7. Query and Visualization

### 7.1 Query APIs

`OBS-REQ-057`: Implementations MUST provide query capability for metrics and logs; trace query is REQUIRED when traces are supported.

`OBS-REQ-058`: Queries MUST enforce authorization based on resource and tenant scope.

`OBS-REQ-059`: Query APIs MUST support time range and correlation-key filters for `workUnitId` and `traceId` when those fields are indexed.

### 7.2 Investigation Packages

`OBS-REQ-060`: Agents and humans MUST be able to export an investigation package containing selected signals, annotations, and time range for a subject.

`OBS-REQ-061`: Investigation packages MUST include content hashes for immutability of captured evidence snapshots when used in incidents.

### 7.3 Dashboards as Code

`OBS-REQ-062`: Dashboard definitions SHOULD be version-controlled and referencable by IRI.

`OBS-REQ-063`: Dashboard variables MUST NOT embed secrets.

`OBS-REQ-064`: Critical operational dashboards SHOULD be regenerable from code rather than only click-ops.

## 8. Retention and Cost

### 8.1 Retention Policies

`OBS-REQ-065`: Retention MUST be configurable per signal type and sensitivity class.

`OBS-REQ-066`: Production incident-related evidence SHOULD have retention at least as long as related deployment and test evidence when used for postmortems.

`OBS-REQ-067`: Deletion/expiry MUST be logged for audit when policy requires.

### 8.2 Cost Controls

`OBS-REQ-068`: Implementations SHOULD expose volume metrics (spans/sec, log bytes, metric series count).

`OBS-REQ-069`: Budget policies MAY drop or downsample non-critical signals; drops MUST be counted.

`OBS-REQ-070`: Cardinality storms MUST be detectable and containable.
