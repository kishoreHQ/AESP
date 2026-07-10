# AESP-0014: Human-in-the-Loop, Reference

## 9. Security

`HITL-REQ-036`: Task read/complete MUST be authorized; unauthorized users MUST NOT see restricted payloads.

`HITL-REQ-037`: Channel adapters MUST NOT log secret payload fields.

`HITL-REQ-038`: Decision integrity MUST be protected (signed or server-side only writes).

`HITL-REQ-039`: Out-of-band approvals without task ids are non-conformant for gated production actions.

## 10. Implementation Guidelines

`HITL-REQ-040`: L1 MUST provide task CRUD/claim/complete, audit, timeout to expired/escalated, and authenticated decisions.

Channels: web console, Slack/Teams, email magic links, mobile push—adapters only.

Anti-patterns: approvals in unstructured chat without task id; infinite waits; auto-approving on timeout.

## 11. Conformance

| Level | Scope |
|:---|:---|
| L1 | Task model, auth decisions, timeout, audit |
| L2 | Escalation chains, SLA events, multi-channel single-writer, stale digest checks |
| L3 | Dual control, Mission Control API, on-call routing, intervene/takeover |

`HITL-REQ-041`: Declare level.  
`HITL-REQ-042`: L1 covers HITL-REQ-001–011, 017–020, 026, 036–038, 040.  
`HITL-REQ-043`: L2 adds escalation, SLA, multi-channel, stale checks.  
`HITL-REQ-044`: L3 adds dual control, Mission Control, intervene.  
`HITL-REQ-045`: Tests MUST include double-claim prevention and timeout non-approval.

`HITL-REQ-050`: Tests MUST include self-approval denial when forbidden and stale-digest conflict on complete.

## 12. Appendices

### Task Types
`approve`, `review`, `input`, `intervene`, `acknowledge`.

### Requirement Index
`HITL-REQ-001`–`HITL-REQ-050`.

# References

[^1^]: RFC 2119  
[^2^]: Temporal HITL patterns / human tasks in workflow engines  
[^3^]: AESP-0005 Human-in-the-Loop chapter  
