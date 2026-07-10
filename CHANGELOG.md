# Changelog

All notable changes to the Autonomous Engineering Specification (AESP) will be
documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Planned
- Phase 4 ecosystem (reference implementations, conformance suites)
- Community review toward STABLE

## [1.7.1] — 2026-07-10

### Added — Suite Hardening

- `specification/ARCHITECTURE.md` — Agent OS layer map, correlation keys, Hermes levels (also in 1.7.0 commit set).
- `specification/CONFORMANCE.md` — suite profiles (`core-runtime`, `hermes-agent-os`, `mission-control`, `build-ship`).
- Expanded remediation, security, and HITL requirements from cross-spec review (REM/SEC/HITL extensions).

## [1.7.0] — 2026-07-10

### Added — AESP-0015: Integration & Interoperability

- Adapter/connector architecture, LLM provider bindings (OpenAI-compatible, Anthropic-compatible, local).
- MCP client profile, plugins, capability discovery, version negotiation, reliability, security.
- Normative requirements `INT-REQ-001` through `INT-REQ-062`.
- Assets: `specification/AESP-0015.md`, `-continued.md`, `-reference.md`, `aesp-0015.yaml`.

## [1.6.0] — 2026-07-10

### Added — AESP-0014: Human-in-the-Loop

- Human task model, approvals/reviews/intervene, escalation, SLAs, Mission Control API surface.
- Normative requirements `HITL-REQ-001` through `HITL-REQ-045`.
- Assets: `specification/AESP-0014.md`, `-continued.md`, `-reference.md`, `aesp-0014.yaml`.

## [1.5.0] — 2026-07-10

### Added — AESP-0013: Security & Compliance

- Cross-cutting security: identity, authn/authz, secrets, classification, audit, supply chain, multi-agent threats.
- Normative requirements `SEC-REQ-001` through `SEC-REQ-051`.
- Assets: `specification/AESP-0013.md`, `-continued.md`, `-reference.md`, `aesp-0013.yaml`.

## [1.4.0] — 2026-07-10

### Added — AESP-0012: Remediation & Self-Healing

- Incidents, playbooks, automated actions, guardrails, escalation, verification, deploy rollback linkage.
- Normative requirements `REM-REQ-001` through `REM-REQ-048`.
- Assets: `specification/AESP-0012.md`, `-continued.md`, `-reference.md`, `aesp-0012.yaml`.

## [1.3.0] — 2026-07-10

### Added — AESP-0011: Observability

- Telemetry signals, correlation, SLOs, alerting, pipelines, retention, investigation packages.
- Normative requirements `OBS-REQ-001` through `OBS-REQ-084`.
- Assets: `specification/AESP-0011.md`, `-continued.md`, `-reference.md`, `aesp-0011.yaml`.

## [1.2.0] — 2026-07-10

### Added — AESP-0010: Testing & Validation

This release adds the testing and validation specification for autonomous
engineering organizations, defining test request and evidence contracts, test
taxonomy, generation and selection, execution semantics, oracles and coverage,
quality gates, flake handling, environments and data controls, policy, and
conformance requirements.

#### Specification Content (AESP-0010)

- Defines testing model architecture with request/session surfaces, catalog identity, runner isolation, and structured errors.
- Specifies baseline test taxonomy (unit through chaos/smoke) with outcome classes and criticality.
- Defines test generation/authoring modes, impact selection, quarantine hygiene, and linkage to AESP-0007.
- Adds execution semantics for parallelism, sharding, retries, flake classification, determinism, and budgets.
- Specifies oracles, coverage signals, versioned quality gates, and requirements traceability.
- Defines environment fingerprints, fixtures, synthetic data, doubles vs real dependencies, and secret redaction.
- Standardizes immutable results, evidence packages for deploy consumption, catalog lifecycle, and retention.
- Adds security controls for untrusted tests, evidence integrity, and gate break-glass audit.
- Defines L1–L3 conformance levels and AESP-0009 interoperability expectations.

#### Normative Requirements

- Introduces `TEST-REQ-001` through `TEST-REQ-137` for architecture, taxonomy, generation, execution, gates, environments, results, security, implementation, and conformance.

#### Assets

- `specification/AESP-0010.md` — Chapters 1-4
- `specification/AESP-0010-continued.md` — Chapters 5-8
- `specification/AESP-0010-reference.md` — Chapters 9-12 and references
- `specification/aesp-0010.yaml` — AESP-0010 metadata file

## [1.1.0] — 2026-07-10

### Added — AESP-0009: Deployment Automation

This release adds the deployment automation specification for autonomous
engineering organizations, defining deployment request contracts, environment
and target models, rollout strategies, progressive delivery and health gates,
rollback, environment promotion, freeze windows, provenance, policy controls,
and conformance requirements.

#### Specification Content (AESP-0009)

- Defines deployment model architecture with request/session surfaces, controllers, gate engine, session state machine, and structured errors.
- Specifies immutable artifact identity, environment policy profiles, multi-target semantics, and desired vs observed state.
- Defines rollout strategies: recreate, rolling, blue/green, canary, and shadow/dark launch.
- Adds execution pipelines with pre/post hooks, pause/abort, timeouts, provenance, and workflow correlation.
- Specifies health gates, metric baselines, automated canary analysis, traffic weight observation, and human holds.
- Defines rollback modes, abort vs rollback, and post-rollback duties.
- Standardizes promotion chains, freeze windows, multi-region policies, and release-train batching.
- Adds security controls for authorization, supply-chain admission, secrets, policy packs, and blast-radius limits.
- Defines L1–L3 conformance levels and test vector families.

#### Normative Requirements

- Introduces `DEP-REQ-001` through `DEP-REQ-151` for architecture, artifacts/environments, strategies, execution, gates, rollback, promotion, security, implementation, and conformance.

#### Assets

- `specification/AESP-0009.md` — Chapters 1-4
- `specification/AESP-0009-continued.md` — Chapters 5-8
- `specification/AESP-0009-reference.md` — Chapters 9-12 and references
- `specification/aesp-0009.yaml` — AESP-0009 metadata file

## [1.0.0] — 2026-07-10

### Added — AESP-0008: Documentation Generator

This release adds the documentation generator specification for autonomous
engineering organizations, defining documentation request and response
contracts, multi-source inputs, schema-to-docs and living documentation modes,
drift detection, multi-format publishing, quality validation, document
lifecycle, review workflows, security and policy controls, and conformance
requirements.

#### Specification Content (AESP-0008)

- Defines documentation model architecture with request/session surfaces, source graphs, document identity, session state machine, and structured errors.
- Specifies source kinds (OpenAPI, schemas, code, configs, workflows, memory, knowledge graph, codegen artifacts) with pinning, access control, and audience rules.
- Defines generation modes: schema-to-docs, code-to-docs, template, model-driven, hybrid, living, incremental, and partial generation.
- Adds pipeline execution for multi-document sets, multi-format rendering, determinism, provenance, and workflow/codegen correlation.
- Specifies living documentation synchronization, drift types, manual-authoritative sections, and docs-to-source proposal safety.
- Defines document lifecycle states including `published`, `stale`, `deprecated`, and archival rules.
- Standardizes review, publish receipts, quality validators, and append-only audit history.
- Adds security controls for secrets, audience isolation, policy packs, and least-privilege generation.
- Defines L1–L3 conformance levels and test vector families.

#### Normative Requirements

- Introduces `DOC-REQ-001` through `DOC-REQ-169` for architecture, sources, modes, execution, drift, lifecycle, review/publish, security, implementation, and conformance.

#### Assets

- `specification/AESP-0008.md` — Chapters 1-4
- `specification/AESP-0008-continued.md` — Chapters 5-8
- `specification/AESP-0008-reference.md` — Chapters 9-12 and references
- `specification/aesp-0008.yaml` — AESP-0008 metadata file

## [0.9.0] — 2026-07-10

### Added — AESP-0007: Code Generation

This release adds the code generation specification for autonomous engineering
organizations, defining generation request and response contracts, template and
model-driven modes, determinism and provenance, multi-file generation, output
validation, artifact lifecycle management, review workflows, security and policy
controls, and conformance requirements.

#### Specification Content (AESP-0007)

- Defines generation model architecture with request/session surfaces, engine capabilities, artifact identity, session state machine, and structured error model.
- Specifies input contracts for prompts, schemas, templates, variables, constraints, context packs, and generation configuration including determinism modes.
- Defines generation modes: template-driven, model-driven, hybrid, incremental, regeneration, patch, and partial generation.
- Adds execution semantics for multi-file and multi-language sessions, streaming, cancellation, determinism, provenance, result delivery, and workflow correlation.
- Specifies validation pipelines covering syntax, formatting, types, policy, security, dependency integrity, tests, and linting.
- Defines artifact lifecycle states (`draft`, `generated`, `reviewed`, `approved`, `superseded`, `archived`) with transitions, versioning, and retention rules.
- Standardizes human and automated review, approval, rejection, revision, escalation, and append-only audit history.
- Adds security and policy controls for authorization, secrets, supply chain, policy packs, and execution isolation.
- Defines L1–L3 conformance levels, interoperability expectations, quality metrics, and test vector families.

#### Normative Requirements

- Introduces `CG-REQ-001` through `CG-REQ-192` for architecture, inputs, modes, execution, validation, lifecycle, review, security, implementation, and conformance.

#### Assets

- `specification/AESP-0007.md` — Chapters 1-4
- `specification/AESP-0007-continued.md` — Chapters 5-8
- `specification/AESP-0007-reference.md` — Chapters 9-12 and references
- `specification/aesp-0007.yaml` — AESP-0007 metadata file

## [0.8.0] — 2026-07-10

### Added — AESP-0006: Knowledge Graph

This release adds the knowledge graph specification for autonomous engineering
organizations, defining graph semantics, ontology and schema rules, graph
construction, query behavior, reasoning, memory integration, federation, and
conformance requirements.

#### Specification Content (AESP-0006)

- Defines dual RDF/property graph support, typed node and edge models, property typing, graph identity, and graph containers.
- Specifies entity and relationship modeling, including type hierarchies, cardinality, inverse predicates, n-ary relation reification, and entity merging.
- Defines ontology and schema requirements using RDFS, OWL 2 profiles, SHACL validation, ontology versioning, and a baseline AEO ontology.
- Adds query semantics for graph pattern queries, traversal, semantic search, temporal queries, and explainable query responses.
- Specifies construction and extraction pipelines for ingestion, entity extraction, relationship extraction, entity resolution, and curation workflows.
- Defines bounded reasoning and inference profiles, materialized and virtual inference, rule semantics, uncertainty, and contradiction handling.
- Integrates knowledge graphs with AESP-0004 memory systems, including memory record mapping, retrieval composition, access-control alignment, and lifecycle synchronization.
- Adds distributed knowledge graph semantics for federation, partitioning, replication, consistency, and cross-organization graph exchange.

#### Normative Requirements

- Introduces `KG-REQ-001` through `KG-REQ-126` for model architecture, ontology, query, construction, reasoning, memory integration, federation, implementation, and conformance.

#### Assets

- `specification/AESP-0006.md` — Chapters 1-4
- `specification/AESP-0006-continued.md` — Chapters 5-8
- `specification/AESP-0006-reference.md` — Chapters 9-12 and references
- `specification/aesp-0006.yaml` — AESP-0006 metadata file

## [0.7.0] — 2026-07-10

### Added — AESP-0005: Workflow Orchestration

This release adds the workflow orchestration specification for autonomous agents,
defining workflow graph models, task decomposition patterns, execution state
machines, failure handling and compensation, scheduling and triggers, durable
state persistence, human-in-the-loop integration, and multi-agent coordination
models.

#### Specification Content (AESP-0005)

**Chapter 1: Introduction** — Purpose and scope, five fundamental orchestration
questions, relationship to AESP-0000/0001/0002/0003/0004, normative language,
five design principles (explicit orchestration, state machines, anticipated
failure, HITL first-class, hierarchical composition), and core terminology.

**Chapter 2: Workflow Model Architecture** — Workflow graph model with nodes,
edges, and gateways; JSON `WorkflowDefinition` schema; workflow instance state
machine (PENDING → SCHEDULED → RUNNING → PAUSED ⇄ RUNNING → COMPLETED with
FAILED, COMPENSATING, COMPENSATED, CANCELLED branches); task instance state
machine.

**Chapter 3: Task Decomposition** — Sequential, hierarchical (HTN), parallel,
and conditional decomposition strategies; decomposition agent roles and quality
requirements (specific, achievable, ordered, measurable).

**Chapter 4: Execution Semantics** — Workflow engine responsibilities including
durable execution; task dispatch via AESP-0003 envelopes; data flow between
tasks; parallel execution with fan-out and join gateways; conditional routing;
sub-workflow invocation and parent-child hierarchy.

**Chapter 5: Failure Handling** — Error classification (TRANSIENT, SEMANTIC,
FATAL); retry policies with exponential backoff and jitter; circuit breaker
pattern (CLOSED/OPEN/HALF_OPEN); saga pattern with compensating transactions;
timeout handling and escalation.

**Chapter 6: Scheduling and Triggers** — Four execution initiation models
(explicit, scheduled, event-driven, chained); cron semantics with timezone and
catch-up policies; webhook-based triggers with signature verification; workflow
chaining with correlation propagation.

**Chapter 7: State Persistence and Checkpointing** — Durable execution model
aligned with Temporal event history; event-sourced and snapshot checkpoint
models; state storage alignment table mapping workflow data to AESP-0004 memory
types; replay and recovery semantics; state migration strategies.

**Chapter 8: Human-in-the-Loop** — HITL state model (AWAITING_APPROVAL,
AWAITING_INPUT, AWAITING_REVIEW, ESCALATED, INTERVENED); signal-based
communication with JSON schema; escalation chains and timeout policies;
immutable audit requirements; four implementation patterns (pre-approval gate,
review gate, escalation during execution, manual intervention).

**Chapter 9: Multi-Agent Coordination** — Four coordination models
(centralized, hierarchical, choreography, hybrid); delegation patterns and
authority scoping; contract net protocol with bidding; shared workflow state
with access control; multi-agent failure coordination.

**Chapter 10: Implementation Guidelines** — Four-tier conformance levels
(Core, Durable, Distributed, Federated); recommended three-tier architecture
(Definition, Orchestration, Execution); ten anti-patterns to avoid; migration
strategies across definition versions and engines.

**Chapter 11: Conformance and Testing** — Four conformance tiers; twelve
required test families; seven evaluation metrics with recommended targets
(workflow success rate, MTTR, checkpoint recovery time, compensation success
rate, HITL response time, task dispatch latency, audit completeness).

**Chapter 12: Appendices** — Seventeen workflow error codes; example workflow
instance lifecycle JSON; requirement index mapping 138 normative requirements
to their domains; ten references.

#### Normative Requirements

- 138 normative requirements (WF-REQ-001 through WF-REQ-138)
- 5 design principles and 4 design dimensions
- 4 conformance tiers
- 12 chapters across 3 files

#### References

- Temporal Platform Documentation
- LangGraph Multi-Agent Workflows
- Camunda BPMN Specification
- RFC 2119 Normative Language
- Saga Pattern (Temporal Blog)
- Temporal Human-in-the-Loop Cookbook
- HTN Planning (University of Maryland)
- Multi-Agent Orchestration Patterns
- Strands Agents Multi-agent Patterns
- AI Agent Error Handling Patterns

#### Assets

- `specification/AESP-0005.md` — Chapters 1-4, ~26 KB
- `specification/AESP-0005-continued.md` — Chapters 5-8, ~26 KB
- `specification/AESP-0005-reference.md` — Chapters 9-12 and references, ~22 KB
- `specification/aesp-0005.yaml` — AESP-0005 metadata file

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
