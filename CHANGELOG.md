# Changelog

All notable changes to the Autonomous Engineering Specification (AESP) will be
documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Planned
- AESP-0005: Workflow Orchestration
- AESP-0006: Knowledge Graph
- AESP-0007 through AESP-0015

## [0.6.0] — 2026-07-10

### Added — AESP-0004: Memory Systems

This release adds the memory systems specification for autonomous agents, defining
typed memory records, memory operations, backend roles, retrieval mechanisms,
distributed consistency, lifecycle controls, inter-agent memory sharing, security
requirements, and conformance tests.

#### Specification Content (AESP-0004)

**Chapter 1: Introduction** — Purpose and scope, four-type memory taxonomy,
relationship to AESP-0000/0001/0003, normative language, design principles, and
core terminology for agent memory systems.

**Chapter 2: Memory Model Architecture** — Working, episodic, semantic, and
procedural memory types; memory scopes; ownership rules; and the JSON
`MemoryRecord` data model.

**Chapter 3: Memory Operations** — Store, retrieve, update, delete, forget,
suppress, restore, consolidate, export, import, migrate, compact, and audit
operation semantics.

**Chapter 4: Storage Backends** — Backend role model for context windows, event
logs, vector indexes, relational stores, knowledge graphs, object stores, and
key-value stores.

**Chapter 5: Retrieval Mechanisms** — Similarity, lexical, hybrid, temporal,
associative, graph, and working-memory selection semantics.

**Chapter 6: Distributed Memory** — Consistency levels, event sourcing alignment,
CRDT mappings, remove-wins deletion, and conflict resolution rules.

**Chapter 7: Memory Lifecycle** — Admission, active use, suppression,
consolidation, archival, expiry, forgetting, tombstoning, and rehydration.

**Chapter 8: Inter-Agent Memory Protocol** — Memory capability declarations,
sharing leases, subscriptions, and federation requirements using AESP-0003
message envelopes.

**Chapter 9: Security and Privacy** — Threat model, authorization, privacy,
data minimization, prompt injection, and memory poisoning controls.

**Chapter 10: Implementation Guidelines** — Minimum viable implementation,
recommended event-sourced architecture, anti-patterns, and migration guidance.

**Chapter 11: Conformance and Testing** — Conformance tiers, test families, and
evaluation metrics for retrieval quality, policy safety, and task outcomes.

**Chapter 12: Appendices** — Error codes, example retrieval response,
requirement index, and references.

#### Assets

- `specification/AESP-0004.md` — Chapters 1-4
- `specification/AESP-0004-continued.md` — Chapters 5-8
- `specification/AESP-0004-reference.md` — Chapters 9-12 and references
- `specification/aesp-0004.yaml` — AESP-0004 metadata file

## [0.5.0] — 2026-07-10

### Added — AESP-0003: Communication Protocols

This release delivers the communication protocol specification for autonomous
agents — a ~49,000-word specification (across 3 files) defining message formats,
transport layer bindings, communication patterns, capability discovery, error
handling, security, session management, and multi-agent coordination protocols.

#### Specification Content (AESP-0003)

**Chapter 1: Introduction** — Purpose and scope, relationship to AESP-0000/0001/0002,
conformance tiers (3 levels), RFC 2119 normative language definitions,
20-row referenced standards table, 29-entry abbreviations/glossary table,
requirement identifier mapping (REQ-001 through REQ-132)

**Chapter 2: Core Architecture** — Three-layer model (Data Model / Operations /
Transport Bindings) with convergence evidence from A2A, ANP, MCP, AEE,
transport-agnostic design principles, forward compatibility rules,
3 conformance tiers (Core/Extended/Optional), 4 design principles
(idempotency, event-driven, defense in depth, human readability)

**Chapter 3: Message Envelope and Serialization** — MVE-Required tier (10 fields)
and MVE-5 tier (5 fields), message type classification (7 types), protocol
version negotiation, W3C Trace Context integration, 4 JSON schemas
(MessageEnvelope, ErrorPayload, BatchMessage, CloudEventEnvelope), 3 comparison
tables (serialization formats, envelope fields across protocols, content-type
matrix), CloudEvents integration for agent events, message batching, size limits

**Chapter 4: Transport Layer** — Transport abstraction interface, HTTP(S) binding
(HTTP/1.1 minimum, HTTP/2 recommended), SSE with graceful degradation chain
(SSE→webhook→polling), WebSocket with heartbeat, STDIO (NDJSON), gRPC
(p99 53ms vs REST p99 1,245ms), message broker adapters (NATS 11-12M msgs/sec,
Kafka 1M+ msgs/sec, Redis Streams 0.8ms p99), transport selection matrix

**Chapter 5: Communication Patterns** — Request-response (JSON-RPC 2.0, deadline
propagation, idempotency keys), publish-subscribe (topic hierarchies with MQTT
wildcards, DLQ), broadcast (gossip protocol), streaming (SSE vs WebSocket
comparison), 3 delivery semantics (at-most/least/exactly-once), pattern selection
matrix, 2 case studies (retry storm, hub-and-spoke context overflow)

**Chapter 6: Capability Discovery** — Agent Description Document with JWS signing,
well-known URI discovery (RFC 8615), centralized vs decentralized discovery
comparison, 3-phase version negotiation, feature/extension negotiation with
governance hooks (rate limits, approval workflows, budget caps)

**Chapter 7: Reliability and Error Handling** — 7-category error taxonomy with
code ranges, exponential backoff with jitter (60-80% retry storm reduction),
circuit breaker pattern (3 states), semantic validation layer ("successful garbage"
problem), saga pattern with automated compensation (SagaLLM), durable execution
vs checkpointing, 2 case studies (retry storm incident, poison pill blocking)

**Chapter 8: Security and Authentication** — TLS mandate (1.2 min, 1.3 rec),
4 auth methods (OAuth 2.0, mTLS, DID/IBCT), RBAC+ 4-layer authorization,
Invocation-Bound Capability Tokens (100% attack rejection), tamper-evident audit
trails (IETF AAT, L0-L4 trust levels), EU AI Act compliance, secure defaults,
MCP authentication gap case study (~2,000 servers with zero auth)

**Chapter 9: Session Management** — Session lifecycle state machine, stateful vs
stateless modes (MCP SEP-2575 stateless-first), session affinity strategies,
task lifecycle (9 states including input-required), context management
(FullContext 12.3:1 compression), formal input-required primitive with
pause-and-resume semantics, 2 case studies (MCP stateless migration,
context overflow)

**Chapter 10: Multi-Agent Patterns** — 3×2 topology taxonomy (centralized/
decentralized/hierarchical × static/dynamic), 4 delegation patterns
(supervisor-worker, hierarchical, CNP, fan-out), orchestration vs choreography
vs hybrid, blackboard and event sourcing patterns, BFT consensus (CP-WBFT 85.7%
fault tolerance), cross-organizational trust federation, 2 case studies
(ESAA clinical dashboard, CNP task allocation)

**Chapter 11: Protocol Interoperability** — MCP binding (JSON-RPC 2.0,
Streamable HTTP, stateless-first), A2A binding (Agent Card translation,
9-state task mapping), ACP binding (REST API, multipart MIME), ANP binding
(DID-based identity), complementary protocol stack (MCP+A2A+Kafka/NATS)

**Chapter 12: Extensibility and Versioning** — Namespaced extension mechanism,
semantic versioning (MAJOR/MINOR/PATCH), backward compatibility guarantee,
12-month breaking change policy, feature deprecation lifecycle

#### Assets
- `specification/AESP-0003.md` — Chapters 1-4, ~118,000 bytes
- `specification/AESP-0003-continued.md` — Chapters 5-8, ~136,000 bytes
- `specification/AESP-0003-reference.md` — Chapters 9-12, ~124,000 bytes
- `specification/aesp-0003.yaml` — AESP-0003 metadata file
- `dist/AESP-0003.docx` — Word format with 92 footnotes, 610 citations
- 40 tables, 20 JSON schemas, 15 sequence diagrams, 9 case studies

---
