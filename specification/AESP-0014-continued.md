# AESP-0014: Human-in-the-Loop, Continued

## 5. Interaction Protocols

`HITL-REQ-017`: Notifications MUST include task id, priority, summary, deep link or machine handle, and deadline when set.

`HITL-REQ-018`: Multi-channel delivery MAY fan out; completion on one channel MUST complete the task globally (single writer).

`HITL-REQ-019`: Decision messages MUST be authenticated as the human principal (or legitimate deputy with delegation record).

`HITL-REQ-020`: Workflows waiting on HITL MUST resume only on validated task completion signals (AESP-0005).

`HITL-REQ-021`: Cancellation by system or requester MUST notify assignees when already claimed.

`HITL-REQ-022`: Delegation (reassign) MUST be authorized and audited.

## 6. SLAs and Timeouts

`HITL-REQ-023`: Tasks SHOULD declare `respondBy` SLA timestamps by priority class.

`HITL-REQ-024`: SLA breach MUST emit observability events (AESP-0011) and MAY auto-escalate.

`HITL-REQ-025`: Business hours calendars MAY adjust SLA clocks; the calendar id MUST be recorded.

`HITL-REQ-026`: Expired tasks MUST not silently count as approvals.

## 7. Mission Control Surfaces

`HITL-REQ-027`: A Mission Control-compatible API MUST list open tasks for a principal with filters (priority, type, team).

`HITL-REQ-028`: Task detail MUST present subject context sufficient to decide without out-of-band tribal knowledge for standard types.

`HITL-REQ-029`: Bulk acknowledge is permitted only for `acknowledge` type or policy-allowed sets—not for production approve.

`HITL-REQ-030`: Operator takeover MUST pause autonomous mutation on the subject session when intervene is accepted.

`HITL-REQ-031`: Return-to-agent handoff MUST record human notes and residual authority.

## 8. Quality and Safety

`HITL-REQ-032`: Dual control (two-person approval) MUST be expressible for high-risk actions.

`HITL-REQ-033`: Self-approval (requester equals approver) MUST be denied when policy forbids it.

`HITL-REQ-034`: Stale context: if subject digest changes after task creation, completion MUST revalidate or fail with conflict.

`HITL-REQ-035`: Human feedback artifacts MAY be written to AESP-0004 memory with provenance linking the task id.

## 5.5 Decision Payload Schema

`HITL-REQ-046`: Completed approval decisions MUST include decision enum, optional comment, timestamp, and subject digest acknowledged.

`HITL-REQ-047`: Review decisions that request revision MUST include machine-readable issue codes when available (for example `security`, `correctness`, `style`, `incomplete`).

## 7.1 Operator Presence

`HITL-REQ-048`: Mission Control MAY expose operator presence/availability; routing SHOULD prefer available on-call principals when schedules exist.

`HITL-REQ-049`: Unavailable principals MUST be skipped in escalation with audit of skip reason.
