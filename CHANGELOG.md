# Changelog

All notable changes to the Autonomous Engineering Specification (AESP) will be
documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Planned
- AESP-0001: AEO Core Model
- AESP-0002: Agent Roles
- AESP-0003: Communication Protocols
- AESP-0004: Memory Systems
- AESP-0005: Workflow Orchestration
- AESP-0006: Knowledge Graph
- AESP-0007 through AESP-0015

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
