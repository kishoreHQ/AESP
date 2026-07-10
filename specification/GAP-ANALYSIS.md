# AESP Suite Gap Analysis

*Status: Working Group Review Artifact | Date: 2026-07-10 | Pass: 2*  
*Scope: AESP-0000 through AESP-0015 against Hermes Agent OS / Mission Control / multi-vendor goals*

This document records **gap analysis, cross-spec validation findings, and dispositions**. It is informative unless a disposition says a normative change was applied in a listed specification.

## 1. Method

For each gap we record:

| Field | Meaning |
|:---|:---|
| ID | `GAP-NNN` |
| Severity | `blocker` / `major` / `minor` / `future` |
| Area | product or protocol concern |
| Finding | what is missing or inconsistent |
| Disposition | `fixed` / `mitigated` / `accepted` / `deferred` |
| Resolution | where/how addressed |

**Inputs:** suite specs, `ARCHITECTURE.md`, `CONFORMANCE.md`, Hermes goals (multi-agent, Mission Control, MCP, OpenAI/Anthropic/local providers, memory, KG, codegen, workflows).

**Passes:** (1) completeness vs roadmap, (2) cross-spec boundaries and deps, (3) enterprise/Agent OS scenarios, (4) metadata consistency.

## 2. Executive Summary

| Severity | Count | Notes |
|:---|:---|:---|
| blocker | 0 remaining | Suite authored 0000–0015; no missing planned numbers |
| major | several mitigated | Tool runtime, planning surface, eval harness, metadata drift, 0013 cross-deps |
| minor | tracked | YAML schema dual formats; depth variance Phase 3 vs Phase 2 |
| future | Phase 4+ | Reference impl, automated REQ linter, STABLE process |

**Honest prior state:** Completing AESP-0011–0015 delivered *coverage of titles*, not automatically full gap closure. This pass focuses on analysis and hardening.

## 3. Gap Register

### GAP-001 — Agent planning as first-class protocol
- **Severity:** major  
- **Area:** Planning / Mission Control  
- **Finding:** Planning is implied by AESP-0005 task decomposition and agent behavior but there is no explicit **Plan artifact** (goals, steps, assumptions, success criteria, revision history) shared across agents.  
- **Disposition:** mitigated  
- **Resolution:** `ARCHITECTURE.md` §10 Plan artifact; normative `INT-REQ` / runtime loop requirements in AESP-0015 (agent runtime profile) binding plans to WorkUnits and workflows.

### GAP-002 — Unified tool execution runtime
- **Severity:** major  
- **Area:** Tool orchestration / MCP  
- **Finding:** Tools appear in AESP-0001 Capabilities, AESP-0015 MCP, and security (0013), but a single **tool invocation record** (args, policy decision, result, side-effects, timeout) was underspecified.  
- **Disposition:** fixed (normative extension)  
- **Resolution:** AESP-0015 tool invocation contract (`INT-REQ-063+`).

### GAP-003 — Provider fallback and routing
- **Severity:** major  
- **Area:** Multi-provider LLMs  
- **Finding:** OpenAI/Anthropic/local bindings exist; ordered fallback, health-based routing, and sticky model selection for a WorkUnit were thin.  
- **Disposition:** fixed  
- **Resolution:** AESP-0015 provider routing profile.

### GAP-004 — Agent/system evaluation harness
- **Severity:** major  
- **Area:** Quality / offline eval  
- **Finding:** AESP-0010 covers software tests; agent trajectory evaluation (task success, cost, safety, rubric scores) was not explicit.  
- **Disposition:** fixed  
- **Resolution:** AESP-0010 evaluation campaigns (`TEST-REQ-138+`).

### GAP-005 — AESP-0013 not listed as dependency of production paths
- **Severity:** major  
- **Area:** Security cross-cut  
- **Finding:** Codegen/deploy/test/integration YAML deps omitted 0013 though production claims require it.  
- **Disposition:** fixed  
- **Resolution:** YAML dependency updates + ARCHITECTURE rule “stricter of 0013 wins”.

### GAP-006 — Metadata schema dualism
- **Severity:** minor  
- **Area:** Repository hygiene  
- **Finding:** `aesp-0001.yaml` / `aesp-0002.yaml` use a richer schema; `aesp-0004+` use compact schema. RelatedSpecs in 0001 mislabel later specs (e.g. 0007 as “Tool Integration”).  
- **Disposition:** mitigated  
- **Resolution:** Corrected relatedSpecs labels; documented dual metadata as accepted transitional state in this file §5; full schema unification deferred to avoid noisy rewrites.

### GAP-007 — Cost / token budgets in agent loop
- **Severity:** major  
- **Area:** FinOps / multi-tenant  
- **Finding:** AESP-0001 has resource quotas; runtime enforcement at provider/tool boundary needs explicit linkage.  
- **Disposition:** mitigated  
- **Resolution:** INT provider/tool budget hooks; OBS recommended cost metrics already present; crosswalk in ARCHITECTURE.

### GAP-008 — Multi-tenancy model
- **Severity:** major  
- **Area:** Enterprise SaaS Agent OS  
- **Finding:** Tenant isolation appears in OBS/INT/REM L3 but no single tenant resource model.  
- **Disposition:** mitigated  
- **Resolution:** ARCHITECTURE §11 Tenant model (organization-scoped isolation); SEC classification remains authority for data; full tenant API deferred (future AESP amendment or 0001 extension).

### GAP-009 — Suite/protocol version negotiation between implementations
- **Severity:** minor  
- **Area:** Interoperability  
- **Finding:** Plugin negotiation exists; peer AESP runtime version advertise was missing.  
- **Disposition:** fixed  
- **Resolution:** INT suite version advertise/negotiate requirements.

### GAP-010 — Depth variance Phase 3 vs 0007–0010
- **Severity:** minor  
- **Area:** Spec quality  
- **Finding:** 0012–0014 denser on requirements than narrative/examples vs 0007–0010.  
- **Disposition:** accepted (with hardening pass)  
- **Resolution:** Expanded REQs in prior pass; further prose expansion optional, not blocking suite DRAFT.

### GAP-011 — Automated cross-reference / REQ linter
- **Severity:** future  
- **Area:** Tooling  
- **Disposition:** deferred — Phase 4 ecosystem.

### GAP-012 — Reference implementation & golden fixtures
- **Severity:** future  
- **Area:** Ecosystem  
- **Disposition:** deferred — Phase 4.

### GAP-013 — Event type registry fragmentation
- **Severity:** minor  
- **Area:** Observability / integration  
- **Finding:** Deploy, test, remediate, HITL events not in one registry.  
- **Disposition:** fixed  
- **Resolution:** `specification/EVENT-REGISTRY.md` baseline event types.

### GAP-014 — Confused deputy across MCP + deploy tools
- **Severity:** major  
- **Area:** Security  
- **Finding:** Documented in 0013 but missing MUST for tool-result untrusted labeling into subsequent model turns.  
- **Disposition:** fixed  
- **Resolution:** SEC-REQ extension + INT tool result trust labels.

### GAP-015 — Workflow ↔ HITL signal contract underspecified edge cases
- **Severity:** minor  
- **Area:** 0005 / 0014  
- **Finding:** Completion signals defined; concurrent cancel+complete races thin.  
- **Disposition:** mitigated  
- **Resolution:** HITL-REQ race rule (last authorized writer wins with audit; approve after cancel rejected).

### GAP-016 — Knowledge graph optional in Hermes profile vs retrieval quality
- **Severity:** minor  
- **Area:** Conformance  
- **Finding:** Hermes profile allows KG L1; GraphRAG-style agent quality may need L2.  
- **Disposition:** accepted  
- **Resolution:** CONFORMANCE note: elevate KG for knowledge-heavy products.

### GAP-017 — aesp-0001 relatedSpecs wrong titles
- **Severity:** minor  
- **Area:** Metadata  
- **Disposition:** fixed  
- **Resolution:** Correct titles/descriptions for 0007, 0011, etc.

## 4. Cross-Spec Validation Matrix

| Shared concept | Canonical home | Consumers | Status |
|:---|:---|:---|:---|
| WorkUnit | 0001 | 0003–0015 | OK |
| Role / RBAC+ | 0002 | 0005, 0013, 0014, 0015 | OK |
| Message envelope | 0003 | all networked | OK |
| Memory record | 0004 | 0005, 0006, 0007 context | OK |
| Workflow instance | 0005 | 0007–0012, 0014 | OK |
| Artifact digest | 0007/0009/0010 | deploy+test chain | OK — reaffirmed |
| Evidence package | 0010 | 0009 gates | OK |
| Trace/WorkUnit correlation | 0011 | 0015 boundary | OK |
| Incident | 0012 | 0011, 0014 | OK |
| Human task | 0014 | 0005, 0007–0012 | OK + race harden |
| Connector/MCP/Provider | 0015 | runtime | OK + tool invoke |
| Security baseline | 0013 | all production | deps updated |

## 5. Metadata Consistency

| Specs | Schema style | Action |
|:---|:---|:---|
| 0001–0002 | rich (specNumber, relatedSpecs, implements) | keep; fix wrong labels |
| 0003 | intermediate | accepted transitional |
| 0004–0015 | compact (id, dependencies[]) | preferred for new specs |
| Unification | — | deferred (GAP-006) |

## 6. Scenario Coverage (Agent OS)

| Scenario | Covered by | Gap? |
|:---|:---|:---|
| Multi-agent workflow with HITL approve | 0005+0014 | mitigated |
| Codegen → test → deploy canary → rollback | 0007+0010+0009 | OK |
| Alert → remediate → page human | 0011+0012+0014 | OK |
| MCP tool call with authz + audit | 0015+0013 | fixed |
| Local LLM fallback when cloud 429 | 0015 | fixed |
| Living docs drift after API change | 0008 | OK |
| Memory forget + KG sync | 0004+0006 | OK (prior) |
| Prompt injection via tool output | 0013+0015 | fixed |
| Offline agent eval harness | 0010 | fixed |
| Cross-org federation | 0003/0006 L3 | future depth |

## 7. Residual Risks (Accepted for DRAFT)

1. No single formal JSON Schema package for all request objects (examples only).  
2. Phase 3 narrative thinner than 0003/0007 long-form.  
3. No executable conformance suite yet.  
4. Early specs (0001–0002 relatedSpecs) still describe historical roadmap names in places until fully scrubbed.

## 8. Disposition Summary

| Status | Gaps |
|:---|:---|
| fixed | 002, 003, 004, 005, 009, 013, 014, 017 |
| mitigated | 001, 006, 007, 008, 015 |
| accepted | 010, 016 |
| deferred | 011, 012 |

## 9. Next Working Group Actions

1. Phase 4: golden OpenAI-compat + MCP mock conformance tests.  
2. Emit JSON Schema bundle for session objects.  
3. Optional AESP amendment: Tenant resource (if multi-tenant SaaS becomes primary).  
4. Promote profiles after two independent implementations.
