# AESP-0011: Observability, Reference

## 9. Security and Policy

`OBS-REQ-071`: Telemetry access MUST be authorized; agents MUST only query signals within their policy scope.

`OBS-REQ-072`: Prompt content, tool secrets, and personal data in spans/logs MUST be redacted or encrypted according to classification policy.

`OBS-REQ-073`: Admin operations changing retention, sampling, or alert routes MUST be audited.

`OBS-REQ-074`: Telemetry backends MUST support encryption in transit; encryption at rest is RECOMMENDED for production.

`OBS-REQ-075`: Exported investigation packages MUST honor the same access controls as live queries.

## 10. Implementation Guidelines

### 10.1 Minimum Viable Implementation

`OBS-REQ-076`: L1 MUST provide structured logs, baseline agent/service metrics, work-unit correlation ids, and authorized metric/log query.

### 10.2 Recommended Stack Patterns

OpenTelemetry SDK + Collector + Prometheus/Tempo/Loki-compatible stores is a common pattern; commercial APM is acceptable if semantic requirements are met.

`OBS-REQ-077`: Semantic attribute mapping to AESP ids MUST be documented for the implementation.

### 10.3 Agent OS Placement

```text
Operations     0011 Observability ← you are here; feeds 0012 remediation
Infrastructure 0006–0010
Foundation     0000–0005
```

`OBS-REQ-078`: Runtimes SHOULD expose a health endpoint for the observability pipeline itself (dogfooding).

### 10.4 Anti-Patterns

- Logging raw secrets/prompts by default
- Metrics with unbounded label values
- Alerts without runbooks or remediation hooks
- Trace sampling that drops all errors
- Dashboards as sole SLO source of truth

## 11. Conformance and Testing

| Level | Name | Scope |
|:---|:---|:---|
| L1 | Basic Telemetry | Logs, metrics, work-unit correlation, query auth |
| L2 | Traced AEO | Traces, events, SLOs, alerts, pipelines, redaction |
| L3 | Autonomous Ops | Investigation packages, multi-tenant isolation, burn alerts, deploy/test linking |

`OBS-REQ-079`: Implementations MUST declare conformance level.

`OBS-REQ-080`: L1 MUST satisfy `OBS-REQ-001`–`OBS-REQ-017`, `OBS-REQ-026`–`OBS-REQ-027`, `OBS-REQ-057`–`OBS-REQ-058`, `OBS-REQ-071`–`OBS-REQ-072`, `OBS-REQ-076`.

`OBS-REQ-081`: L2 MUST satisfy L1 plus traces, SLOs/alerts, pipeline, and redaction requirements.

`OBS-REQ-082`: L3 MUST satisfy L2 plus multi-tenant, investigation packages, and cross-spec linking requirements.

`OBS-REQ-083`: Conformance tests MUST verify correlation key propagation and unauthorized query denial.

`OBS-REQ-084`: Security tests MUST verify secret redaction on sample payloads.

## 12. Appendices

### 12.1 Baseline Agent Metrics (Recommended)

| Metric | Type | Description |
|:---|:---|:---|
| `aesp.workunit.started` | counter | Work units started |
| `aesp.workunit.completed` | counter | Work units completed by status |
| `aesp.tool.call.duration` | histogram | Tool call latency |
| `aesp.model.invocation.duration` | histogram | Model call latency |
| `aesp.model.tokens` | counter | Token usage when available |

### 12.2 Requirement Index

`OBS-REQ-001` through `OBS-REQ-084`.

| Range | Domain |
|:---|:---|
| 001–010 | Architecture |
| 011–025 | Signals |
| 026–032 | Correlation |
| 033–043 | Pipelines |
| 044–056 | SLO/Alerting |
| 057–064 | Query/Viz |
| 065–070 | Retention/Cost |
| 071–084 | Security/Conformance |

# References

[^1^]: OpenTelemetry, "Documentation", accessed 2026-07-10, https://opentelemetry.io/docs/

[^2^]: W3C, "Trace Context", accessed 2026-07-10, https://www.w3.org/TR/trace-context/

[^3^]: Beyer et al., "Site Reliability Engineering", O'Reilly / Google SRE books, accessed 2026-07-10, https://sre.google/

[^4^]: Bradner, S., RFC 2119, https://www.rfc-editor.org/rfc/rfc2119

[^5^]: CNCF, "Observability Whitepaper", https://www.cncf.io/

[^6^]: Prometheus, "Documentation", https://prometheus.io/docs/
