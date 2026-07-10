# AESP Suite Architecture — Agent Operating System Map

*Status: Informative | Date: 2026-07-10*

This document is the **architectural spine** for the AESP-0000 through AESP-0015 specification suite. It is non-normative except where individual specifications incorporate its terms. Implementers of Hermes Agent OS, Mission Control, and multi-vendor AEO runtimes SHOULD use this map to place components and validate boundaries.

## 1. Layered Model

```text
┌─────────────────────────────────────────────────────────────────┐
│  Phase 3 — Operations                                           │
│  0011 Observability │ 0012 Remediation │ 0013 Security          │
│  0014 Human-in-the-Loop │ 0015 Integration & Interoperability   │
├─────────────────────────────────────────────────────────────────┤
│  Phase 2 — Infrastructure                                       │
│  0006 Knowledge Graph │ 0007 Code Generation │ 0008 Docs        │
│  0009 Deployment │ 0010 Testing & Validation                    │
├─────────────────────────────────────────────────────────────────┤
│  Phase 1 — Foundation                                           │
│  0000 Constitution │ 0001 Core Model │ 0002 Roles               │
│  0003 Communication │ 0004 Memory │ 0005 Workflow               │
└─────────────────────────────────────────────────────────────────┘
```

## 2. Control Loop (Hermes Agent OS)

A production Agent OS implements a closed loop:

1. **Intent** — WorkUnit created (0001), authorized by role (0002).
2. **Plan/Orchestrate** — Workflow graph (0005) dispatches tasks over (0003).
3. **Context** — Memory (0004) + Knowledge Graph (0006) retrieve evidence.
4. **Act** — Tools/providers via Integration (0015); generate code (0007), docs (0008).
5. **Verify** — Tests (0010) produce evidence packages.
6. **Ship** — Deploy (0009) with gates consuming test + policy evidence.
7. **Observe** — Telemetry (0011) correlates WorkUnit → deploy → runtime.
8. **Remediate** — Alerts trigger playbooks (0012) with HITL (0014) as needed.
9. **Govern** — Security (0013) and Constitution (0000) bind the loop.

## 3. Shared Identity and Correlation

| Key | Defined primarily in | Used by |
|:---|:---|:---|
| Agent / principal id | 0001, 0013 | all |
| WorkUnit id | 0001 | 0003–0015 |
| Workflow instance / task id | 0005 | 0007–0012, 0014 |
| Artifact digest | 0007, 0009, 0010 | deploy, test, docs |
| Session ids (codegen, docs, deploy, test, remediate) | 0007–0012 | 0011 correlation |
| Trace id | 0011 (W3C) | 0003 propagation, 0015 boundary calls |
| HITL task id | 0014 | 0005 waits, 0007–0012 gates |

**Rule:** Production-grade implementations MUST be able to pivot from a WorkUnit id to related sessions, traces, and human tasks.

## 4. Requirement Families

| Spec | Prefix | Approx. range |
|:---|:---|:---|
| AESP-0004 | `MEM-REQ` | memory |
| AESP-0005 | `WF-REQ` | workflow |
| AESP-0006 | `KG-REQ` | knowledge graph |
| AESP-0007 | `CG-REQ` | code generation |
| AESP-0008 | `DOC-REQ` | documentation |
| AESP-0009 | `DEP-REQ` | deployment |
| AESP-0010 | `TEST-REQ` | testing |
| AESP-0011 | `OBS-REQ` | observability |
| AESP-0012 | `REM-REQ` | remediation |
| AESP-0013 | `SEC-REQ` | security |
| AESP-0014 | `HITL-REQ` | human-in-the-loop |
| AESP-0015 | `INT-REQ` | integration |

Requirement identifiers are stable; extensions append new numbers.

## 5. Protocol Boundaries (Do Not Blur)

| Concern | Owns | Does not own |
|:---|:---|:---|
| 0003 Communication | envelopes, transport, sessions | business workflow graphs |
| 0005 Workflow | durable orchestration | tool vendor protocols |
| 0007 Codegen | generation contracts | deploy traffic shifting |
| 0009 Deploy | rollout/rollback | test execution engines |
| 0010 Test | evidence packages | production remediation actions |
| 0011 Observability | signals/SLO/alert model | playbook mutation |
| 0012 Remediation | incidents/playbooks | raw metric storage |
| 0014 HITL | human task protocol | channel UX branding |
| 0015 Integration | adapters/MCP/providers | core RBAC data model (0002) |

## 6. Conformance Profile: Hermes Agent OS (Recommended)

| Component | Minimum levels |
|:---|:---|
| Core runtime | 0001 + 0003 L core + 0005 L durable |
| Memory + KG | 0004 L2 + 0006 L1 |
| Build path | 0007 L2 + 0008 L1 + 0010 L2 |
| Ship path | 0009 L2 + 0010 evidence consumption |
| Ops path | 0011 L2 + 0012 L2 + 0014 L2 |
| Security | 0013 L2 |
| Ecosystem | 0015 L2 (OpenAI-compat or Anthropic-compat + MCP client) |

## 7. Versioning and Compatibility

- Spec documents use draft semantic versions in YAML metadata.
- Suite releases are tracked in `CHANGELOG.md`.
- Breaking changes to normative requirement meaning require major version discussion under AESP-0000 governance.
- Adapters (0015) negotiate feature flags; cores fail closed on unmet minimums.

## 8. Conformance Profiles

Named suite profiles (`aesp.profile.hermes-agent-os`, `mission-control`, `build-ship`, `core-runtime`) are defined in [CONFORMANCE.md](CONFORMANCE.md).

## 9. Plan Artifact (Agent Planning Surface)

Planning is not a separate AESP number in the 0000–0015 set; it is a **first-class artifact** bound to WorkUnits and workflows:

| Field | Purpose |
|:---|:---|
| `goal` | Declared intent |
| `steps[]` | Ordered or graph-linked actions |
| `assumptions[]` | Beliefs that invalidate the plan if false |
| `successCriteria[]` | Machine or human checkable outcomes |
| `revision` | Monotonic plan version |

Normative storage/revision rules: AESP-0015 `INT-REQ-075`–`INT-REQ-076`. Execution of steps typically uses AESP-0005 tasks and AESP-0015 tools/providers.

## 10. Tool Invocation (Runtime Boundary)

Canonical tool call record: AESP-0015 tool invocation contract. Authorization: AESP-0002 + AESP-0013. Telemetry: `aesp.tool.*` in [EVENT-REGISTRY.md](EVENT-REGISTRY.md). Untrusted tool outputs MUST keep trust labels (SEC + INT).

## 11. Tenant / Organization Isolation Model

| Scope | Authority |
|:---|:---|
| Organization / tenant id | AESP-0001 Organization |
| Data classification | AESP-0013 |
| Telemetry isolation | AESP-0011 L3 |
| Connector egress | AESP-0015 |
| Memory scope | AESP-0004 |

Cross-tenant queries and credential reuse are deny-by-default unless explicitly federated.

## 12. Security Cross-Cut Rule

For production profiles, **the stricter of AESP-0013 and the feature spec applies**. YAML dependencies for build/ship/ops/integration paths list AESP-0013 after gap pass GAP-005.

## 13. Gap Analysis

Working group gap register and dispositions: [GAP-ANALYSIS.md](GAP-ANALYSIS.md).

## 13.1 External Protocol & Runtime Guides

| Doc | Purpose |
|:---|:---|
| [INTEROP-MATRIX.md](INTEROP-MATRIX.md) | MCP, A2A, ACP, ANP, providers → AESP |
| [AGENT-RUNTIME.md](AGENT-RUNTIME.md) | Agent harness loop, control vs compute |
| [EVENT-REGISTRY.md](EVENT-REGISTRY.md) | Shared event type names |
| [CONFORMANCE.md](CONFORMANCE.md) | Suite profiles |
| `../schemas/` | JSON Schema interop package |

## 14. Implementation Checklist (Publication Quality)

- [ ] All sessions have IRIs and audit trails
- [ ] Digests pin production artifacts
- [ ] Gates consume machine-readable evidence (not CI UI alone)
- [ ] HITL tasks never auto-approve on timeout
- [ ] Secrets never appear in logs, prompts by default, or provenance
- [ ] MCP/tools authorized before invoke; invocation records persisted
- [ ] Provider fallback records effective model/provider
- [ ] WorkUnit correlation present in telemetry
- [ ] Remediation respects freeze windows and blast-radius caps
- [ ] Plans versioned when multi-step autonomy is used
- [ ] Untrusted tool results cannot authorize privileged actions
