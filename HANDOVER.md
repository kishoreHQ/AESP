# AESP Project Handover Document

**Date**: 2026-07-10  
**Repository**: https://github.com/kishoreHQ/AESP  
**Branch**: main (worktree may be detached)  
**Current Status**: **AESP-0000 through AESP-0015 DRAFT complete** with **gap-analysis pass 3** (industry interop + harness + security). Assets: `INTEROP-MATRIX.md`, `AGENT-RUNTIME.md`, `schemas/`, `scripts/validate-suite.sh`. Next: Phase 4 golden conformance tests and STABLE review.

---

## 1. Project Overview

AESP (Autonomous Engineering Specification Protocol / Agent Execution Specification Protocol family) is a vendor-neutral open standard for Autonomous Engineering Organizations (AEOs) and Agent Operating Systems. The suite (AESP-0000 through AESP-0015) defines governance, core model, roles, communication, memory, workflow, knowledge graph, code generation, documentation, deployment, testing, observability, remediation, security, human-in-the-loop, and integration (including MCP and multi-provider LLMs).

### Suite Status

| Spec | Title | Status | Requirement family |
|------|-------|--------|-------------------|
| AESP-0000 | Constitution / Governance | DRAFT | (constitutional) |
| AESP-0001 | Core Model | DRAFT | core entities |
| AESP-0002 | Agent Roles | DRAFT | RBAC+ |
| AESP-0003 | Communication Protocols | DRAFT | envelopes/transport |
| AESP-0004 | Memory Systems | DRAFT | `MEM-REQ` |
| AESP-0005 | Workflow Orchestration | DRAFT | `WF-REQ` |
| AESP-0006 | Knowledge Graph | DRAFT | `KG-REQ` |
| AESP-0007 | Code Generation | DRAFT | `CG-REQ` |
| AESP-0008 | Documentation Generator | DRAFT | `DOC-REQ` |
| AESP-0009 | Deployment Automation | DRAFT | `DEP-REQ` |
| AESP-0010 | Testing & Validation | DRAFT | `TEST-REQ` |
| AESP-0011 | Observability | DRAFT | `OBS-REQ` |
| AESP-0012 | Remediation & Self-Healing | DRAFT | `REM-REQ` |
| AESP-0013 | Security & Compliance | DRAFT | `SEC-REQ` |
| AESP-0014 | Human-in-the-Loop | DRAFT | `HITL-REQ` |
| AESP-0015 | Integration & Interoperability | DRAFT | `INT-REQ` |

### Pipeline Status

- **Phase 1 Foundation** — DRAFT COMPLETE  
- **Phase 2 Infrastructure** — DRAFT COMPLETE  
- **Phase 3 Operations** — DRAFT COMPLETE  
- **Phase 4 Ecosystem** — NEXT (reference impl, examples, conformance suite)  
- **Phase 5 Standardization** — PLANNED (STABLE v1.0)

---

## 2. Key Entry Points

| Doc | Purpose |
|-----|---------|
| [specification/ARCHITECTURE.md](specification/ARCHITECTURE.md) | Agent OS layer map, correlation keys, Hermes profile |
| [specification/README.md](specification/README.md) | Spec index |
| [CHANGELOG.md](CHANGELOG.md) | Release history |
| [ROADMAP.md](ROADMAP.md) | Phases and exit criteria |
| [README.md](README.md) | Project overview |

### File Convention (per large spec)

- `AESP-NNNN.md` — Chapters 1–4  
- `AESP-NNNN-continued.md` — Chapters 5–8  
- `AESP-NNNN-reference.md` — Chapters 9–12 + references  
- `aesp-nnnn.yaml` — metadata  

---

## 3. Hermes / Mission Control Mapping

| Product surface | Primary specs |
|-----------------|---------------|
| Agent runtime kernel | 0001, 0002, 0003, 0005, 0013 |
| Memory & knowledge | 0004, 0006 |
| Build & ship | 0007, 0008, 0009, 0010 |
| Ops & supervision | 0011, 0012, 0014 |
| Ecosystem / MCP / LLM providers | 0015 |

---

## 4. Conventions for Continuers

1. Extend—do not rewrite—prior specs.  
2. RFC 2119 language; stable `XXX-REQ-NNN` ids.  
3. Vendor-neutral; implementation-independent.  
4. Three-file split for large specs.  
5. Update CHANGELOG + ROADMAP + specification/README on each release.  
6. Cross-check `specification/ARCHITECTURE.md` when adding shared concepts.

---

## 5. Definition of Done (Suite DRAFT)

- [x] AESP-0000–0015 authored  
- [x] Metadata YAML for 0001–0015 style specs present for 0004–0015  
- [x] CHANGELOG through 1.7.0  
- [x] ROADMAP Phase 1–3 DRAFT COMPLETE  
- [x] Architecture map published  
- [ ] Multi-vendor pilot implementations  
- [ ] Automated cross-reference linter  
- [ ] STABLE promotion under AESP-0000 process  

---

*Handover updated at suite DRAFT completion.*
