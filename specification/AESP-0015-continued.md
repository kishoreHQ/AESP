# AESP-0015: Integration & Interoperability, Continued

## 5. MCP Integration Profile

The Model Context Protocol (MCP) standardizes tools, resources, and prompts for LLM applications [^2^]. AESP-0015 defines how Agent OS runtimes host MCP clients/servers under AESP policy.

`INT-REQ-023`: MCP servers registered in an AEO MUST appear as connectors with capability descriptors enumerating tools/resources/prompts.

`INT-REQ-024`: MCP tool calls MUST be authorized via AESP-0013/0002 before execution.

`INT-REQ-025`: MCP tool results MUST be converted into AESP-correlatable tool invocation spans/events when observability is enabled.

`INT-REQ-026`: Resource reads via MCP MUST respect data classification and redaction policy.

`INT-REQ-027`: Untrusted MCP servers MUST run in sandboxed network/fs contexts when hosted by the Agent OS.

`INT-REQ-028`: MCP session lifecycle (initialize, list, call, shutdown) MUST be mapped to connector health and audit events.

`INT-REQ-029`: Transport choices (stdio, HTTP/SSE, etc.) MUST be declared on the connector; credentials for remote MCP MUST use secret references.

`INT-REQ-030`: Tool name collisions across MCP servers MUST be disambiguated by server/connector prefix in the AESP tool registry.

## 6. Plugins

`INT-REQ-031`: Plugins MUST be packaged with a manifest declaring id, version, permissions, entrypoints, and supported AESP versions.

`INT-REQ-032`: Plugin installation MUST verify signature or checksum when supply-chain policy requires (AESP-0013).

`INT-REQ-033`: Plugins MUST NOT receive permissions beyond the manifest grant.

`INT-REQ-034`: Plugin upgrade MUST be versioned; breaking capability removal MUST increment major version.

`INT-REQ-035`: Failed plugin hooks MUST not crash the core runtime; errors MUST be isolated and reported.

`INT-REQ-036`: Plugins MAY register tools, providers, memory backends, or workflow activities through documented extension points only.

## 7. Discovery and Version Negotiation

`INT-REQ-037`: Capability discovery MUST support listing connectors, tools, providers, and plugins visible to a principal.

`INT-REQ-038`: Version negotiation between Agent OS and plugin/adapter MUST exchange semantic versions and feature flags.

`INT-REQ-039`: If minimum required version is not met, invocation MUST fail closed with structured error.

`INT-REQ-040`: Feature flags MUST be explicit; clients MUST NOT assume undocumented vendor behavior for conformance claims.

`INT-REQ-041`: AESP-0003 capability discovery SHOULD advertise integration endpoints when exposed over the message fabric.

## 8. Data Mapping and Reliability

`INT-REQ-042`: Identity mapping between external ids and AESP IRIs MUST be deterministic and stored when bidirectional sync is claimed.

`INT-REQ-043`: Schema mapping definitions MUST be versioned.

`INT-REQ-044`: Partial failure in bulk integrations MUST report per-item outcomes.

`INT-REQ-045`: At-least-once delivery consumers MUST be idempotent or de-duplicate by event id.

`INT-REQ-046`: Rate limit responses from providers MUST surface as `rate_limited` with optional retry-after.

`INT-REQ-047`: Timeouts MUST be configurable per connector class.

`INT-REQ-048`: Dead-letter queues MAY hold failed integration events; poison messages MUST be inspectable without silent drop.

## 8.5 Tool Invocation Runtime Contract

This section closes the gap between AESP-0001 Capabilities, MCP tools, and security policy. Every tool call in a production Agent OS MUST be representable as a tool invocation record.

`INT-REQ-063`: A tool invocation record MUST include: `invocationId`, `toolName` (optionally connector-prefixed), `principalId`, `workUnitId` when known, `arguments` (redacted per policy), `policyDecision` (`allow`/`deny` + policy version), `startedAt`, `endedAt`, `status`, and `resultRef` or error class.

`INT-REQ-064`: Tool arguments and results derived from untrusted content MUST carry a trust label (`trusted`, `untrusted`, `mixed`). Untrusted results MUST NOT be treated as authoritative system facts without validation.

`INT-REQ-065`: Denied invocations MUST still emit an audit/security event and MUST NOT execute side effects.

`INT-REQ-066`: Tool timeouts MUST be enforced; on timeout the invocation status MUST be `timeout` and compensating cancellation SHOULD be attempted when supported.

`INT-REQ-067`: Side-effect class (`read`, `write`, `admin`) declared by the tool MUST be enforced by authorization policy before execution.

## 8.6 Provider Routing and Fallback

`INT-REQ-068`: A provider route MAY declare an ordered fallback list of provider/model pairs.

`INT-REQ-069`: Fallback MUST record `aesp.provider.fallback` (or equivalent) with from/to provider ids and reason (`unavailable`, `rate_limited`, `timeout`, `policy`).

`INT-REQ-070`: Silent fallback without recording the effective provider/model used for a completion is non-conformant.

`INT-REQ-071`: When a WorkUnit requires sticky model selection, fallback to a different model family MUST be denied unless policy allows and the change is audited.

`INT-REQ-072`: Cost or token budgets attached to a WorkUnit or principal MUST be checked before provider invocation; exhaustion MUST fail closed with structured error `policy_denied` or a dedicated budget class.

## 8.7 Suite Version Advertise

`INT-REQ-073`: An AESP runtime SHOULD advertise its supported AESP suite version set (for example max draft version per spec family) via discovery metadata.

`INT-REQ-074`: Peers negotiating features MUST fail closed when a required suite feature is missing, with a structured error identifying the missing feature.

## 8.8 Plan Artifact Binding

`INT-REQ-075`: When an agent produces a multi-step plan for a WorkUnit, the plan MUST be storable as a versioned artifact with: goal, steps[], assumptions[], successCriteria[], and revision history, referenced by the WorkUnit or workflow instance.

`INT-REQ-076`: Plan revisions MUST not erase prior revisions required for audit; supersession pointers are REQUIRED.
