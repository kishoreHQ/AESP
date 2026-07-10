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
