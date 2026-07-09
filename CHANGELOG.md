# Changelog

All notable changes to the Autonomous Engineering Specification (AESP) will be
documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Planned
- AESP-0003: Communication Protocols
- AESP-0004: Memory Systems
- AESP-0005: Workflow Orchestration
- AESP-0006: Knowledge Graph
- AESP-0007 through AESP-0015

## [0.4.0] — 2026-07-09

### Added — AESP-0002: Agent Roles

This release delivers the role system for autonomous agents — a ~28,000-word
specification defining a dual-level role model (Role Templates + Role
Assignments), a 4-layer RBAC+ permission architecture, 12 standard role
templates, and comprehensive lifecycle management.

#### Specification Content (AESP-0002)

**Section 1: Introduction** — Purpose and scope, relationship to AESP-0001
(mapping table + Mermaid diagram), 8 core terms defined, 4 abbreviations,
9 conformance criteria across 3 levels (Basic/Standard/Full)

**Section 2: Role Model Overview** — Dual-level model (Template + Assignment)
with 4 benefits, RBAC+ 4-layer architecture with Mermaid diagram (RBAC Core →
ABAC Conditions → ReBAC Constraints → PBAC Governance), 5 entity overview
with summary table, ER diagram with multiplicity (8 relationships) and 6 key
constraints, 4 matrix dimensions (delivery/capability/community/system) with
table, namespace scoping with 4 scoping rules

**Section 3: Role Templates** — Complete field spec (14 fields + Permission
sub-entity + CompositionRules sub-entity + QuotaEntry sub-entity), 4
categories (Execution, Coordination, Quality, Bridge), multi-dimension
semantics (4 rules), composition rules (can_coexist_with, conflicts_with,
requires, cardinality constraints), template versioning (semver semantics,
pinning, upgrade semantics), template inheritance (DAG rules, max depth 2,
field overriding, resolution algorithm + Mermaid diagram), built-in vs custom
templates (2 complete JSON examples)

**Section 4: Role Assignments** — Complete field spec, scope types
(organization vs workunit), 5-state lifecycle with Mermaid diagram,
time-bounded assignments, dynamic role assumption via TrustPolicy, multiple
assignments, conflict detection with pseudocode

**Section 5: Permission Model (RBAC+)** — 4-layer architecture overview,
RBAC Core, ABAC Conditions (CEL expressions), ReBAC Relationships
(Zanzibar-style tuples), PBAC Governance (boundaries + policies), 9-step
Permission Resolution Algorithm with Python pseudocode,
EffectivePermission format with provenance

**Section 6: Role Lifecycle** — Template lifecycle (draft→published→
deprecated→retired) with Mermaid diagram, Assignment lifecycle, version
migration, phase-based assignment, role rotation, emergency revocation
(break-glass)

**Section 7: Standard Role Catalog** — 12 roles across 4 categories with
full definitions (Executor, Architect, Specialist, Researcher, Orchestrator,
Facilitator, Strategist, Evaluator, Guardian, Auditor, Liaison, Mediator),
Belbin analogs, ARES dimensions, crew composition rules, phase-based
assignment table, role-to-topology mapping

**Section 8: Advanced Patterns** — Matrix organization, delegation patterns
(4 types), permission boundaries in practice, dynamic role assumption,
role rotation, cross-organizational roles, Agent Card integration, custom
templates

**Section 9: JSON Schema Definitions** — 7 complete JSON Schema Draft 2020-12
schemas (RoleTemplate, RoleAssignment, PermissionBoundary, TrustPolicy,
RoleSession, Permission, EffectivePermission)

**Section 10: Examples** — 4 comprehensive examples with complete JSON

**Section 11: Counter-Examples** — 6 anti-patterns with incorrect JSON,
explanations, and corrections

**Section 12: Best Practices** — 20 practices across 4 categories

**Section 13: Security Considerations** — 6 subsections covering least
privilege, boundary enforcement, trust policy hardening, audit logging,
privilege escalation prevention, deny-by-default

**Section 14: Future Work** — Role marketplace, emergent role detection,
cross-org federation, ML-based optimization, future spec integration

#### Assets
- `specification/AESP-0002.md` — Sections 1-3, 54,001 bytes
- `specification/AESP-0002-continued.md` — Sections 4-8, 92,501 bytes
- `specification/AESP-0002-reference.md` — Sections 9-14, 88,650 bytes
- `specification/aesp-0002.yaml` — AESP-0002 metadata file
- 11 Mermaid diagrams, 7 JSON Schemas, 12 standard role definitions

## [0.3.0] — 2026-07-09

### Added — AESP-0001: Autonomous Engineering Organization Core Model

This release delivers the foundational data model for all Autonomous Engineering
Organizations — a ~31,000-word specification defining the five core entities
(Agent, Organization, Role, WorkUnit, Capability) and their relationships,
lifecycle models, resource management, and persistence mechanisms.

#### Specification Content (AESP-0001)

**Section 1: Introduction** — Specification positioning within the AESP family,
relationship to the Constitution, scope definition, terminology, and conformance
criteria. Includes Mermaid diagram of AESP specification dependencies.

**Section 2: Agent Model** — Agent definition grounded in the Actor Model,
four agent types (worker, coordinator, human_proxy, system), full 8-state
lifecycle state machine with Mermaid diagram, URN-based identity and addressing,
Agent Cards (JSON metadata for capability discovery), agent configuration model,
and BDI-inspired state model (Beliefs, Desires, Intentions).

**Section 3: Organization Model** — Five organizational topologies (flat,
hierarchical, mesh, pipeline, hybrid) with Mermaid diagrams for each, topology
comparison table, organization lifecycle states, governance mode binding
(HITL/HOTL/HOOTL), and policy attachment points.

**Section 4: Role Model** — Role definition with inheritance hierarchy,
permission model using action:resource:condition patterns with allow/deny
effects, approval matrix for multi-person authorization, resource quota defaults,
RBAC design patterns, and role assignment lifecycle.

**Section 5: WorkUnit Model** — HTN-inspired hierarchical task decomposition,
10-state WorkUnit lifecycle with Mermaid diagram, priority-based scheduling,
optional Contract Net Protocol for dynamic task delegation, delegation chains,
retry policies with configurable backoff, and timeout handling.

**Section 6: Capability Model** — Capability definition with JSON Schema
interface contracts, discovery mechanisms, sequential/parallel/conditional
composition patterns, capability versioning, and required resource declarations.

**Section 7: Resource Model** — Six resource types (compute, memory, tokens,
storage, network, time) with units, three allocation strategies (quota-based,
burst, unlimited), resource monitoring metrics, backpressure mechanisms
(4 strategies), resource inheritance through organizational hierarchy, and
resource lifecycle management.

**Section 8: State and Persistence** — Three-layer state classification
(entity, runtime, derived), state transition validation, event sourcing as
required persistence mechanism (event stream is source of truth), 6 event
categories with required event types, CRDT requirements for distributed state
with CAP theorem positioning (AP for operational state, CP for identity),
snapshotting requirements, and Mermaid event flow diagram.

**Section 9: JSON Schema Definitions** — Complete JSON Schema Draft 2020-12
definitions for all 5 core entities (Agent, Organization, Role, WorkUnit,
Capability) with full property specifications, required fields, and cross-references.

**Section 10: Examples** — Four comprehensive examples with complete JSON:
Software Development Organization (flat), Hierarchical Data Processing Pipeline,
Human-in-the-Loop Approval Flow (finance), and Capability Composition.

**Section 11: Counter-Examples** — Seven anti-patterns with incorrect code,
explanation of violations, and corrections: Missing Capability Declaration,
Circular Role Inheritance, Invalid State Transition, Hard-Coded Agent IDs,
Unlimited Production Quotas, Missing Approval Matrix, Flat Topology for
Complex Domains.

**Section 12: Best Practices** — 20 production recommendations across four
categories: Agent Design (5), Organization Design (5), WorkUnit Design (5),
and Security (5).

**Section 13: Security Considerations** — Authentication and authorization
requirements, human oversight controls (approval gates, emergency stop, audit
logging, anomaly detection), data protection (encryption in transit/at rest,
data minimization, retention), supply chain security, and DoS prevention.

**Section 14: Future Work** — Table of 15 planned specifications with domain
classification and descriptions, plus 4 research directions (formal verification,
emergent behavior, human-agent teaming, cross-organization trust).

#### Appendices
- **Appendix A**: Complete resource quota configuration example (JSON)
- **Appendix B**: 5 Architecture Decision Records (Actor Model, RBAC, HTN,
  Content-Addressable Identifiers, CRDTs)
- **Appendix C**: Migration Guide (5-phase, 8-week plan for ad-hoc to
  AESP-0001 compliance, plus version migration procedures)

#### Assets
- `specification/AESP-0001.md` — Sections 1-2, 27,582 bytes
- `specification/AESP-0001-continued.md` — Sections 3-6, 27,386 bytes
- `specification/AESP-0001-reference.md` — Sections 7-14 + Appendices, 48,520 bytes
- `specification/aesp-0001.yaml` — AESP-0001 metadata file
- 3 Mermaid diagrams + 1 event flow diagram
- 5 complete JSON Schemas

## [0.2.0] — 2026-07-09

### Added — AESP-0000: Constitution of the Autonomous Engineering Specification

This release delivers the foundational specification of the AESP standard — a
~21,000-word RFC-quality document establishing the principles, architecture,
governance, and framework for all subsequent specifications.

#### Specification Content (AESP-0000)
- **Section 1: Introduction** — Definition of Autonomous Engineering, what AESP
  is ("the OpenAPI Specification for AI Engineering Organizations"), motivation
  (fragmentation, vendor lock-in, interoperability gaps), comprehensive
  terminology glossary, RFC 8174 requirements language boilerplate
- **Section 2: 8 Foundational Principles** — Autonomy with Oversight, Vendor
  Neutrality, Declarative over Imperative, Machine-Readable First, Extensibility
  by Design, Rough Consensus and Running Code, Content-Addressable Artifacts,
  Continuous Evolution
- **Section 3: AEO Model** — Six-element AEO definition, five core concepts
  (Agent, Swarm, Workflow, Memory, Governance Policy), five organizational
  topologies with Mermaid diagrams (Mesh, Hub-and-Spoke, Hierarchical, Pipeline,
  Hybrid), eight standard agent roles with attribute tables, HITL/HOTL/HOOTL
  governance modes, escalation paths, audit trails, approval matrices
- **Section 4: Specification Framework** — 16-specification family overview,
  dependency graph with Mermaid diagram, hierarchical numbering system
  (0000–9999), aesp.yaml metadata schema, cross-specification reference rules
- **Section 5: Governance Structure** — 7 governance principles, Steering
  Committee (3–5 elected), 4 Domain Committees (DC-Core, DC-Infra, DC-Ops,
  DC-Cross), Technical Oversight Board (7–9 elected), Special Interest Groups,
  Editorial Board, 5-level membership ladder (Contributor → Member → Reviewer →
  Approver → Domain Chair)
- **Section 6: Specification Lifecycle** — 8 lifecycle states, state transition
  diagram, maturity levels (experimental/stable/canonical), 2-phase review
  process (/lgtm then /approve), approval criteria, deprecation/superseding
  procedures with rich metadata
- **Section 7: Document Standards** — Required section structure, RFC 2119 usage
  guidelines with common pitfalls table, Mermaid diagram requirements, examples
  and counter-examples, checklists, Architecture Decision Records
- **Section 8: Extension Mechanism** — x-aesp-* reserved prefix, x-vendor-*
  vendor extensions, Postel's Law processing requirements, extension graduation
  process, Extension Registry
- **Section 9: Conformance and Certification** — Conformance test suites,
  self-testing (AESP Conformant), formal certification (AESP Certified), 2+
  implementation requirement for stable maturity, Implementation Registry,
  interoperability testing
- **Section 10: Security Considerations** — Agent authentication/authorization,
  human oversight for high-risk actions, audit logging requirements, data
  privacy/protection, supply chain security, DoS prevention, secure defaults,
  vulnerability disclosure
- **Section 11: Future Work** — Expected expansion areas (testing, deployment,
  monitoring, marketplace, multi-org), community-driven proposals, integration
  with emerging standards (MCP, A2A), conformance program maturity
- **Appendices A–D** — RFC 2119 quick reference card, aesp.yaml full schema,
  review response codes (/lgtm, /approve, /hold, etc.), publication checklist

#### Assets
- `specification/AESP-0000.md` — Main specification (Sections 1–4), 89,521 bytes
- `specification/AESP-0000-supplement.md` — Supplement (Sections 5–11 +
  Appendices), 75,280 bytes
- `aesp.yaml` — AESP-0000 metadata file
- 12 Mermaid diagrams across both files

## [0.1.0] — 2026-07-09

### Added — Project Bootstrap

This is the initial bootstrap release of the Autonomous Engineering
Specification (AESP). It establishes the project structure, governance model,
and foundational documentation upon which all specifications will be built.

#### Project Structure
- `README.md` — Primary project overview, vision, and specification index
- `LICENSE` — MIT License (Copyright 2026 Kishore Kumar Behera and AESP Contributors)
- `ROADMAP.md` — Five-phase development roadmap (Foundation through Standardization)
- `CHANGELOG.md` — This file, establishing Keep a Changelog format
- `CONTRIBUTING.md` — Contribution guidelines, RFC process, and commit conventions

#### GitHub Templates and Workflow
- `.github/PULL_REQUEST_TEMPLATE.md` — PR template for specification changes

#### Directory Indexes
- `specification/README.md` — Index of all 16 planned specifications (AESP-0000 through AESP-0015)
- `adr/README.md` — Architecture Decision Records index
- `checklists/README.md` — Operational checklists index
- `diagrams/README.md` — Architecture diagrams index
- `patterns/README.md` — Design patterns catalog index
- `reference/README.md` — Reference implementations index
- `prompts/README.md` — Prompt engineering library index
- `examples/README.md` — Specification examples index
- `rfc/README.md` — RFC process documentation index

#### Templates
- `templates/specification-template.md` — RFC-quality specification template for
  all future AESP-NNNN documents, including required sections: Abstract,
  Motivation, Scope, Non-Goals, Definitions, Normative Language, Architecture,
  Protocols, Examples, Counter-Examples, Implementation Notes, Best Practices,
  Anti-Patterns, Security Considerations, Future Work, References, Mermaid
  Diagrams, Checklists, Decision Records, Migration Guide, and Compatibility.

---

## Release Legend

| Status | Meaning |
|--------|---------|
| DRAFT | Under active development, subject to breaking changes |
| CANDIDATE | Feature-complete, undergoing final review |
| STABLE | Released, backward-compatible changes only |
| DEPRECATED | Superseded by a newer specification |
| RETIRED | No longer maintained |
