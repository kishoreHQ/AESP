# AESP-0012: Remediation & Self-Healing, Continued

## 5. Execution Semantics

`REM-REQ-017`: Mutating actions MUST check guardrails immediately before execution.

`REM-REQ-018`: Action results MUST record status, duration, adapter identity, and evidence references.

`REM-REQ-019`: Verification steps MUST run after mitigation when success criteria are declared.

`REM-REQ-020`: If verification fails, the session MUST continue, rollback the mitigation, or escalate per playbook policy.

`REM-REQ-021`: Concurrent remediation sessions on the same resource MUST be coordinated (lock, queue, or merge) to avoid conflicting actions.

`REM-REQ-022`: Timeouts on steps MUST be enforced; hung actions MUST be cancelled or escalated.

`REM-REQ-023`: Workflow-backed remediations SHOULD use AESP-0005 durable execution.

`REM-REQ-024`: Deploy rollbacks invoked as actions MUST create or reference AESP-0009 sessions.

## 6. Safety and Guardrails

`REM-REQ-025`: Guardrails MUST include at least: allowed action types per environment, max blast radius, rate limits, freeze-window respect, and approval requirements.

`REM-REQ-026`: Production data-destructive actions (drop table, delete bucket) MUST default to forbidden for auto mode.

`REM-REQ-027`: Auto mode MUST NOT disable observability or delete audit logs.

`REM-REQ-028`: Circuit breakers MUST stop repeated failed remediations on the same fingerprint within a cool-down.

`REM-REQ-029`: Change budgets (max remediations per hour) MUST be enforceable.

`REM-REQ-030`: Guardrail violations MUST fail closed and audit.

## 7. Escalation

`REM-REQ-031`: Escalation policies MUST define triggers (severity, time, failed mitigation, uncertainty).

`REM-REQ-032`: Escalation to humans MUST use AESP-0014 (or equivalent) with incident context package.

`REM-REQ-033`: Escalation MUST not clear the incident until human or policy resolution.

`REM-REQ-034`: Page storms MUST be prevented via grouping and rate limits.

## 8. Learning and Feedback

`REM-REQ-035`: Resolved incidents SHOULD produce a structured post-incident record with timeline, actions, root cause hypothesis, and follow-ups.

`REM-REQ-036`: Successful playbook outcomes MAY update procedural memory (AESP-0004) with provenance.

`REM-REQ-037`: Failed playbooks MUST be marked for review; auto-disable of failing playbooks MAY occur under policy.

`REM-REQ-038`: Knowledge graph entities (AESP-0006) MAY link services, incidents, and change events.

## 5.5 Diagnosis Package

`REM-REQ-049`: Before mutating production, semi-auto and auto sessions SHOULD assemble a diagnosis package including: trigger fingerprint, recent deploy sessions, error-rate delta, top log signatures, and candidate playbooks.

`REM-REQ-050`: Diagnosis packages MUST be attached to the incident for human review when escalated.

## 5.6 Action Catalog Contracts

`REM-REQ-051`: Each action type MUST declare parameters schema, side-effect class, estimated blast radius class (`instance`, `service`, `region`, `global`), and whether it is reversible.

`REM-REQ-052`: Unknown action types MUST be rejected unless a `custom` action is explicitly allowed by policy with review.

## 8.1 Post-Incident Timeline

`REM-REQ-053`: Post-incident records MUST include a timeline of detection, mitigation, verification, and resolution timestamps.

`REM-REQ-054`: Follow-up WorkUnits created from incidents MUST reference the incident id.

## 8.2 Coordination with Deploy and Feature Flags

`REM-REQ-057`: When error-budget burn correlates with a recent deploy session, playbooks SHOULD prefer AESP-0009 rollback or traffic reduction before speculative config mutation.

`REM-REQ-058`: Feature-flag remediations MUST record flag id, prior value, new value, and expiry or review time.

`REM-REQ-059`: Remediation actions that change production MUST emit `aesp.remediation.action.executed` events consumable by AESP-0011.

## 8.3 Multi-Incident Storm Control

`REM-REQ-060`: Incident storms with related fingerprints MUST collapse into a parent incident or incident group with a single primary remediation session when policy enables grouping.

`REM-REQ-061`: Grouping policies MUST be versioned and MUST NOT drop SEV1 visibility from operator dashboards.
