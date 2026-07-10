# AESP-0012: Remediation & Self-Healing, Reference

## 9. Security and Policy

`REM-REQ-039`: Remediation authority MUST be role-scoped (AESP-0002).

`REM-REQ-040`: Action adapters MUST use least-privilege credentials per environment.

`REM-REQ-041`: Break-glass elevation MUST be time-bounded and audited.

`REM-REQ-042`: Untrusted automation MUST NOT receive production credentials.

## 10. Implementation Guidelines

`REM-REQ-043`: L1 MUST support incident objects, manual playbook run, audit of actions, and basic escalation contact.

Recommended actions catalog: restart, scale, rollback deploy, toggle feature flag, drain/rebalance, page on-call, open change ticket.

Anti-patterns: infinite restart loops; auto-running unreviewed scripts from chat; remediating without verification; ignoring freezes.

## 11. Conformance

| Level | Scope |
|:---|:---|
| L1 | Incidents, manual/semi-auto playbooks, audit, basic escalation |
| L2 | Auto mode with guardrails, dedup, verification, AESP-0009 rollback integration |
| L3 | Multi-resource coordination, learning hooks, SLO-driven playbooks, multi-tenant isolation |

`REM-REQ-044`: Implementations MUST declare level.

`REM-REQ-045`: L1 satisfies REM-REQ-001–016, 017–018, 031–033, 039–041, 043.

`REM-REQ-046`: L2 adds guardrails, verification, circuit breakers, deploy rollback linkage.

`REM-REQ-047`: L3 adds coordination, learning, advanced policy packs.

`REM-REQ-048`: Tests MUST include conflicting concurrent remediations and freeze-window denial.

`REM-REQ-055`: Conformance suites SHOULD simulate alert storms and verify deduplication.

`REM-REQ-056`: Rollback action tests MUST verify AESP-0009 session linkage when deploy rollback is invoked.

## 12. Appendices

### Action Types (Baseline)
`restart`, `scale`, `rollback_deploy`, `feature_flag`, `traffic_shift`, `failover`, `page_human`, `run_diagnostic`, `custom`.

### Requirement Index
`REM-REQ-001`–`REM-REQ-056`.

# References

[^1^]: RFC 2119, https://www.rfc-editor.org/rfc/rfc2119  
[^2^]: Google SRE, Incident management practices, https://sre.google/  
[^3^]: OpenTelemetry, https://opentelemetry.io/  
