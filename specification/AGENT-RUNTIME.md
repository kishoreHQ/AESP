# AESP Agent Runtime (Harness) Profile

*Status: Informative with normative cross-references | Date: 2026-07-10*

Industry practice (Anthropic agent harness / eval harness distinction, OpenAI Agents SDK control-vs-compute plane, long-running agent scaffolds) separates:

1. **Model** — weights and sampling  
2. **Agent harness (runtime)** — loop, tools, context, subagents  
3. **Eval harness** — offline grading (AESP-0010 campaigns)

This document defines how Hermes-class runtimes MUST compose AESP specs into a coherent **agent loop**.

## 1. Canonical Agent Loop

```text
┌──────────────┐
│  Accept WorkUnit (0001) + authz (0002/0013)
└──────┬───────┘
       ▼
┌──────────────┐
│  Load context: memory (0004), KG (0006), docs/code (0007/0008)
└──────┬───────┘
       ▼
┌──────────────┐
│  Plan artifact (0015 INT-REQ-075) — transparent steps
└──────┬───────┘
       ▼
┌──────────────┐
│  Act: provider (0015) + tools/MCP (0015) under policy
│      record tool invocations; emit spans (0011)
└──────┬───────┘
       ▼
┌──────────────┐
│  Verify: tests (0010), validators (0007), human (0014)
└──────┬───────┘
       ▼
┌──────────────┐
│  Persist: memory/KG updates, evidence, audit
└──────────────┘
```

Principles (aligned with industry “building effective agents” guidance):

1. **Simplicity** — prefer explicit workflows (0005) over opaque free agents when risk is high.  
2. **Transparency** — plans and tool calls are first-class, inspectable artifacts.  
3. **ACI quality** — tools have schemas, docs, and tests (0010 + 0015).

## 2. Control Plane vs Compute Plane

| Plane | Owns | AESP |
|:---|:---|:---|
| Control | Policy, HITL, budgets, session ids | 0013, 0014, 0001 quotas, 0015 routing |
| Compute | Model inference, sandboxed tools | 0015 providers, MCP sandbox |
| Evidence | Traces, eval, deploy proofs | 0011, 0010, 0009 |

**Rule:** Compute workers MUST NOT self-approve production side effects (0013, 0014).

## 3. Context Management

| Mechanism | Spec |
|:---|:---|
| Working memory selection | 0004 |
| Compaction / summarization | 0004 (working memory) |
| Semantic retrieval | 0004 + 0006 |
| Untrusted retrieval isolation | 0013 memory poison + trust labels |
| Prompt caching (provider) | Record in provider invocation metadata (0015) |

**Long-running agents:** Prefer durable workflow state (0005) over stuffing entire history into the model context.

## 4. Subagents

| Requirement | Home |
|:---|:---|
| Subagent = distinct agent principal or scoped capability set | 0001, 0002 |
| Context isolation between parent and child | 0004 scopes + runtime |
| Tool allowlists per subagent | 0013, 0015 |
| Parent monitors child WorkUnits | 0005 hierarchy |

Subagents MUST NOT silently inherit parent break-glass credentials.

## 5. Stopping Conditions

A runtime MUST define for each WorkUnit:

- success criteria (plan or task contract)  
- max steps / max tokens / max wall time (0001 quotas + 0015 budgets)  
- escalation path (0014)  
- failure taxonomy (structured errors)

Unbounded agent loops are non-conformant for production profiles.

## 6. Mapping to Hermes Product Surfaces

| Hermes surface | Runtime concern |
|:---|:---|
| Mission Control | 0014 + 0011 + open WorkUnits |
| Plugin marketplace | 0015 plugins + 0013 supply chain |
| Multi-agent orchestration | 0005 + 0003 + optional A2A |
| Local/offline models | 0015 local provider + budgets |

## 7. Minimum Hermes Runtime Claim

To claim `aesp.profile.hermes-agent-os` runtime completeness:

1. Implement the loop in §1 with correlation ids.  
2. Tool invocation records for every gated tool.  
3. Provider metadata on every completion.  
4. HITL never auto-approves on timeout.  
5. Eval campaign path for agent version promotion (0010).
