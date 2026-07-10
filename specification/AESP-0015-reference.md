# AESP-0015: Integration & Interoperability, Reference

## 9. Security

`INT-REQ-049`: Connector credentials MUST follow AESP-0013 secrets rules.

`INT-REQ-050`: Egress allowlists SHOULD restrict connector network destinations in production.

`INT-REQ-051`: User-controlled URLs in tools MUST be validated against SSRF policies.

`INT-REQ-052`: Provider prompts containing restricted data MUST enforce model/provider clearance.

`INT-REQ-053`: Plugin and MCP code execution MUST be sandboxed when untrusted.

`INT-REQ-054`: Audit events MUST record connector id, principal, operation, and outcome for write/admin calls.

## 10. Implementation Guidelines

### 10.1 Minimum Viable Implementation

`INT-REQ-055`: L1 MUST support at least one LLM provider binding, connector registry, structured boundary errors, and secret-referenced credentials.

### 10.2 Hermes Agent OS Profile

Recommended integration surface for Hermes:

| Concern | Binding |
|:---|:---|
| Cloud LLMs | OpenAI-compatible + Anthropic-compatible providers |
| Local LLMs | Local provider interface with pinned models |
| Tools | MCP clients + native AESP tools |
| Mission Control | HITL + observability APIs |
| Extensibility | Signed plugins |

`INT-REQ-056`: Implementations claiming "Hermes-ready" SHOULD implement L2+ of AESP-0015 and document provider/MCP matrices.

### 10.3 Anti-Patterns

- Hard-coding a single vendor SDK in core agent logic
- Running unreviewed MCP servers with prod credentials
- Silent model fallback without recording provider id
- Plugins with ambient authority

## 11. Conformance

| Level | Scope |
|:---|:---|
| L1 | Connector registry, one provider binding, structured errors, secrets hygiene |
| L2 | OpenAI+Anthropic or OpenAI+local, MCP client profile, capability discovery, sandboxed untrusted tools |
| L3 | Plugins with signed manifests, version negotiation, dual-run, multi-tenant egress controls |

`INT-REQ-057`: Declare level.

`INT-REQ-058`: L1: INT-REQ-001–014, 049–050, 055.

`INT-REQ-059`: L2: L1 + MCP profile core + discovery + authz on tools.

`INT-REQ-060`: L3: L2 + plugins + negotiation + advanced isolation.

`INT-REQ-061`: Tests MUST include unauthorized tool call denial, provider timeout mapping, and MCP tool prefix disambiguation.

`INT-REQ-062`: Interoperability tests SHOULD run a golden suite against mock OpenAI-compatible and mock MCP servers.

`INT-REQ-077`: L2+ implementations MUST implement the tool invocation record (`INT-REQ-063`–`INT-REQ-067`) for gated tool use.

`INT-REQ-078`: L3 implementations MUST implement provider fallback recording and suite version advertise (`INT-REQ-068`–`INT-REQ-074`).

`INT-REQ-079`: Conformance tests MUST include: untrusted tool-result labeling, fallback audit, and budget exhaustion deny.

`INT-REQ-087`: A2A peer profile claims MUST be tested for unauthenticated peer rejection and classification enforcement.

`INT-REQ-088`: Interoperability documentation MUST reference `specification/INTEROP-MATRIX.md` or an equivalent mapping of MCP/A2A/provider bindings.

## 12. Appendices

### 12.1 Example Provider Descriptor

```yaml
id: urn:aeo:provider:openai-compat-prod
binding: openai.compatible.v1
baseUrl: https://api.example.com/v1
models:
  - id: codegen-pro
    features: [chat, tools, streaming]
auth:
  secretRef: urn:aeo:secret:provider-openai-compat
```

### 12.2 Example MCP Connector

```yaml
id: urn:aeo:connector:mcp:github-tools
adapter: mcp.client
transport: stdio
command: ["uvx", "mcp-server-github"]
permissions: [repo.read, issues.write]
sandbox: restricted
```

### 12.3 Requirement Index

`INT-REQ-001` through `INT-REQ-088`.

| Range | Domain |
|:---|:---|
| 001–011 | Architecture / Adapters |
| 012–022 | Providers |
| 023–030 | MCP |
| 031–036 | Plugins |
| 037–041 | Discovery |
| 042–048 | Mapping / Reliability |
| 049–062 | Security / Conformance (base) |
| 063–079 | Tool runtime, fallback, suite version, plan binding |
| 080–088 | A2A peer profile, loop hooks, extended conformance |

# References

[^1^]: RFC 2119, https://www.rfc-editor.org/rfc/rfc2119

[^2^]: Model Context Protocol, https://modelcontextprotocol.io/

[^3^]: OpenAI API reference (compatible ecosystem), https://platform.openai.com/docs/api-reference

[^4^]: Anthropic API docs, https://docs.anthropic.com/

[^5^]: OpenTelemetry Semantic Conventions, https://opentelemetry.io/
