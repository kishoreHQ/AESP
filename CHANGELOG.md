# Changelog

All notable changes to the Autonomous Engineering Specification (AESP) will be
documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Initial development of AESP-0000 through AESP-0015 specifications
- Project governance framework and contribution guidelines

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

#### Specifications
- No individual specification documents included in this release. All 16
  specifications (AESP-0000 through AESP-0015) are targeted for delivery in
  Phase 1–3 (Q3 2026 – Q1 2027) per the project roadmap.

---

## Release Legend

| Status | Meaning |
|--------|---------|
| DRAFT | Under active development, subject to breaking changes |
| CANDIDATE | Feature-complete, undergoing final review |
| STABLE | Released, backward-compatible changes only |
| DEPRECATED | Superseded by a newer specification |
| RETIRED | No longer maintained |
