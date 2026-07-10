# AESP Suite Conformance Guide

*Status: Informative companion to normative conformance chapters | Date: 2026-07-10*

This guide helps implementers claim **suite-level** conformance profiles for Hermes Agent OS and multi-vendor AEO runtimes. Normative requirements remain in each AESP-NNNN document; this file aggregates profiles only.

## 1. Per-Spec Levels (Summary)

| Spec | L1 focus | L2 focus | L3 focus |
|:---|:---|:---|:---|
| 0004 Memory | basic store/retrieve | lifecycle + sharing | distributed consistency |
| 0005 Workflow | graphs + dispatch | durable + HITL wait | multi-agent coordination |
| 0006 KG | typed graph + query | memory integration | reasoning + federation |
| 0007 Codegen | request/session + hash | multi-file + review | reproducible + enterprise policy |
| 0008 Docs | schema/template docs | review + publish | living + drift |
| 0009 Deploy | digest + one strategy | progressive + gates | multi-region + supply chain |
| 0010 Test | results + gate | flake + catalog | evidence integrity + impact |
| 0011 Observability | logs/metrics + correlation | traces + SLO/alert | multi-tenant + investigation packs |
| 0012 Remediation | manual playbooks | auto + guardrails | learning + coordination |
| 0013 Security | identity + audit + TLS | classification + supply chain | federation + compliance matrix |
| 0014 HITL | tasks + auth decisions | escalation + SLA | dual control + intervene |
| 0015 Integration | one provider + registry | MCP + discovery | signed plugins + negotiation |

Exact requirement lists are normative in each specification.

## 2. Named Suite Profiles

### 2.1 `aesp.profile.core-runtime`

Minimum to call a process an AESP agent runtime:

- AESP-0001 identity model for agents and WorkUnits  
- AESP-0003 messaging (core tier)  
- AESP-0002 roles for authorization attributes  
- AESP-0013 L1 security  

### 2.2 `aesp.profile.hermes-agent-os`

Recommended for Hermes Agent OS production pilots:

| Area | Spec levels |
|:---|:---|
| Kernel | 0001 + 0002 + 0003 + 0005 (durable) + 0013 L2 |
| Cognition | 0004 L2 + 0006 L1 |
| Delivery | 0007 L2 + 0008 L1 + 0010 L2 + 0009 L2 |
| Operations | 0011 L2 + 0012 L2 + 0014 L2 |
| Ecosystem | 0015 L2 (provider + MCP client) |

### 2.3 `aesp.profile.mission-control`

Operator supervision plane:

- 0014 L3 (Mission Control API + intervene)  
- 0011 L2 (query + alerts)  
- 0012 L1+ (incident visibility)  
- 0005 HITL bridge  

### 2.4 `aesp.profile.build-ship`

CI/CD autonomy path:

- 0007 L2 + 0010 L2 + 0009 L2  
- 0013 supply-chain controls as required by environment  
- 0014 approvals for production  

## 3. Objective Claim Rules

1. Claims MUST list profile name and each included spec level.  
2. Claims MUST reference implementation version and test suite version.  
3. Partial profiles are allowed if explicitly named (for example `hermes-agent-os` minus KG).  
4. Marketing claims of “AESP compliant” without a profile id are non-conformant as suite claims.

## 4. Cross-Spec Test Themes

Implementations SHOULD automate:

1. WorkUnit id propagation: workflow → tool → trace → deploy → test evidence  
2. Digest continuity: codegen artifact → test subject → deploy artifact  
3. HITL timeout ≠ approve  
4. MCP tool deny without authz  
5. Remediation freeze-window deny  
6. Secret redaction in logs and provenance  

## 5. Mapping to Product Surfaces

| Product | Profiles |
|:---|:---|
| Hermes Agent OS | `hermes-agent-os` |
| Mission Control | `mission-control` + observability |
| Multi-agent orchestration | `core-runtime` + 0005 |
| Plugin marketplace | 0015 L3 + 0013 supply chain |
