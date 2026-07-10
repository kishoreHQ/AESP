# AESP External Protocol Interoperability Matrix

*Status: Informative + binding where AESP-0015 requirements reference this document*  
*Date: 2026-07-10 | Research basis: MCP, Google A2A, IBM ACP, ANP ecosystem (2025–2026)*

Industry agent ecosystems have converged on complementary protocols rather than a single stack. AESP does **not** replace them; it **profiles** how an Agent OS (e.g. Hermes) composes them under one governance, identity, and evidence model.

## 1. Protocol Map

| External protocol | Primary concern | AESP home | AESP does |
|:---|:---|:---|:---|
| **MCP** (Model Context Protocol) | Agent ↔ tools/resources/prompts | AESP-0015 | Client/server connectors, authz, sandbox, tool invocation records |
| **A2A** (Agent-to-Agent, Google/Linux Foundation) | Agent ↔ peer agents, task delegation across orgs | AESP-0003 + AESP-0015 | Message envelopes, capability cards, trust boundaries, WorkUnit correlation |
| **ACP** (Agent Communication Protocol) | REST multimodal agent messaging | AESP-0003 | Transport binding profile; map ACP messages ↔ AESP envelopes |
| **ANP** (Agent Network Protocol) | Decentralized agent discovery/marketplace | AESP-0015 discovery | Optional registry adapters; fail closed without trust anchors |
| **OpenAI-compatible HTTP** | Chat/tools/embeddings | AESP-0015 | Provider binding |
| **Anthropic Messages API** | Messages/tools | AESP-0015 | Provider binding |
| **OpenTelemetry** | Traces/metrics/logs | AESP-0011 | Correlation keys + semantic conventions |
| **W3C Trace Context** | Distributed trace propagation | AESP-0011 + AESP-0003 | `traceparent` on envelopes |
| **OIDC / SPIFFE** | Workload & user identity | AESP-0013 | Principal model |
| **SLSA / Sigstore** | Supply chain | AESP-0013 + AESP-0009 | Admit artifacts |

Sources informing this matrix include the MCP specification ecosystem, A2A multi-organization agent coordination, and comparative surveys of MCP/ACP/A2A/ANP (2025–2026).

## 2. Layering Rule (Critical)

```text
                    ┌─────────────────────────┐
                    │  AESP governance/identity │  0000–0002, 0013
                    │  evidence & ops           │  0009–0014
                    └───────────┬─────────────┘
          ┌─────────────────────┼─────────────────────┐
          ▼                     ▼                     ▼
     MCP tools            A2A/ACP peers          Providers
     (0015)               (0003+0015)            (0015)
```

1. **MCP is not A2A.** Tools return; peers negotiate and may refuse.  
2. **AESP WorkUnit id** is the pivot across all protocols.  
3. **Never** give an MCP server the same authority as a peer agent identity without explicit policy.  
4. **A2A cross-org** requires AESP-0013 federation + allowlisted trust anchors.

## 3. Mapping Tables

### 3.1 MCP → AESP

| MCP concept | AESP concept |
|:---|:---|
| Server | Connector (`mcp.client` / `mcp.server`) |
| Tool | Tool registry entry + capability |
| Resource | Readable Resource / memory/doc URI |
| Prompt template | Prompt artifact (versioned) |
| Session initialize | Connector health + `aesp.mcp.session.ready` |

### 3.2 A2A → AESP

| A2A concept | AESP concept |
|:---|:---|
| Agent Card / capabilities | AESP-0001 Capability + 0015 discovery document |
| Task | WorkUnit or workflow task |
| Message | AESP-0003 envelope |
| Artifact | Content-addressed Resource |
| Push notifications | 0003 events / 0011 signals |

### 3.3 OpenAI/Anthropic tools → AESP

| Provider tool call | AESP |
|:---|:---|
| `tool_calls[]` / `tool_use` | Tool invocation record (INT-REQ-063+) |
| `tool` result message | Trust-labeled result (`untrusted` default if external) |

## 4. Adoption Roadmap (Recommended)

Aligned with industry phased adoption (MCP → messaging → A2A → network):

| Phase | Adopt | AESP minimum |
|:---|:---|:---|
| 1 | MCP tools | 0015 L2 + 0013 L2 |
| 2 | Multi-agent in one org | 0003 + 0005 + 0002 |
| 3 | Cross-org A2A | 0015 A2A profile + 0013 L3 federation |
| 4 | Marketplace/ANP | Explicit trust registry; optional |

## 5. Non-Goals

- Forking MCP/A2A wire formats  
- Requiring ANP for core Hermes  
- Replacing vendor SDKs when adapters satisfy bindings  

## 6. Conformance Claim Language

Implementations MUST say e.g.:

> “AESP-0015 L2 with MCP client profile and OpenAI-compatible provider; A2A peer profile optional.”

Not: “AESP replaces A2A.”
