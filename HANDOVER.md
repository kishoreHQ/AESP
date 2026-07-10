# AESP Project Handover Document

**Date**: 2026-07-10
**Repository**: https://github.com/kishoreHQ/AESP
**Branch**: main
**Current Status**: AESP-0000 through AESP-0003 completed. Ready for AESP-0004.

---

## 1. Project Overview

AESP (Autonomous Engineering Specification Protocol) is a vendor-neutral open standard for Autonomous Engineering Organizations (AEOs). The specification family (AESP-0000 through AESP-0015) defines the architecture, protocols, roles, and operational models for multi-agent systems that self-organize to accomplish engineering tasks.

### Completed Specifications

| Spec | Title | Status | Files on GitHub | Approx. Words |
|------|-------|--------|-----------------|---------------|
| AESP-0000 | Constitution | Committed | AESP-0000.md, AESP-0000-supplement.md, aesp-0000.yaml | ~21,000 |
| AESP-0001 | Core Model | Committed | AESP-0001.md, AESP-0001-continued.md, AESP-0001-reference.md, aesp-0001.yaml | ~31,000 |
| AESP-0002 | Agent Roles | Committed | AESP-0002.md, AESP-0002-continued.md, AESP-0002-reference.md, aesp-0002.yaml | ~28,000 |
| AESP-0003 | Communication Protocols | Committed | AESP-0003.md, AESP-0003-continued.md, AESP-0003-reference.md, aesp-0003.yaml | ~49,000 |

### Specification Pipeline Status
- **AESP-0004**: Memory Systems — NOT STARTED (next in queue)
- **AESP-0005**: Workflow Orchestration — PENDING
- **AESP-0006**: Knowledge Graph — PENDING
- **AESP-0007 through AESP-0015** — PENDING

---

## 2. Repository Structure

```
kishoreHQ/AESP (main branch)
|
|-- specification/
|   |-- AESP-0000.md              (89,521 B)   # Constitution Sections 1-4
|   |-- AESP-0000-supplement.md   (75,280 B)   # Constitution Sections 5-11 + Appendices
|   |-- AESP-0001.md              (27,582 B)   # Core Model Sections 1-2
|   |-- AESP-0001-continued.md   (27,386 B)   # Core Model Sections 3-6
|   |-- AESP-0001-reference.md   (48,520 B)   # Core Model Sections 7-14 + Appendices
|   |-- AESP-0002.md              (34,330 B)   # Agent Roles Sections 1-3
|   |-- AESP-0002-continued.md   (102,483 B)  # Agent Roles Sections 4-8
|   |-- AESP-0002-reference.md   (48,306 B)   # Agent Roles Sections 9-14
|   |-- AESP-0003.md              (72,886 B)   # Comm Protocols Ch 1-4
|   |-- AESP-0003-continued.md   (109,580 B)  # Comm Protocols Ch 5-8
|   |-- AESP-0003-reference.md   (64,097 B)   # Comm Protocols Ch 9-12
|   |-- aesp-0000.yaml            (~1 KB)      # AESP-0000 metadata
|   |-- aesp-0001.yaml            (~1.5 KB)    # AESP-0001 metadata
|   |-- aesp-0002.yaml            (~1.5 KB)    # AESP-0002 metadata
|   |-- aesp-0003.yaml            (~1 KB)      # AESP-0003 metadata
|
|-- CHANGELOG.md                   (5,604 B)   # v0.1.0 through v0.5.0
|-- aesp.yaml                      (~1 KB)      # Project root metadata
```

### Metadata Format (per spec)
Each `aesp-XXXX.yaml` follows this structure:
```yaml
id: AESP-0003
title: Communication Protocols
status: draft
category: protocol
version: "0.1.0"
authors: ["AESP Technical Committee"]
date: "2026-07-09"
description: "..."
dependencies: ["AESP-0000", "AESP-0001", "AESP-0002"]
```

### CHANGELOG Format
Uses keepachangelog.com format with versions:
- v0.1.0: AESP-0000 Constitution
- v0.2.0: AESP-0001 Core Model
- v0.3.0: AESP-0002 Agent Roles
- v0.4.0: AESP-0003 Communication Protocols
- v0.5.0: CHANGELOG + metadata updates

---

## 3. Specification Conventions

### File Splitting Strategy
Specifications > 100KB characters are split into 3 files at logical chapter boundaries:
- **Part 1** (`AESP-XXXX.md`): Chapters 1-4 (Introduction, Architecture, Core concepts)
- **Part 2** (`AESP-XXXX-continued.md`): Chapters 5-8 (Detailed specifications)
- **Part 3** (`AESP-XXXX-reference.md`): Chapters 9-12 + Appendices (Advanced topics, references)

### Writing Standards
- **Normative language**: RFC 2119 (MUST/SHOULD/MAY/REQUIRED/OPTIONAL)
- **Tone**: Technical specification, vendor-neutral, precise
- **Citations**: `[^N^]` format tracked via MCP citation database
- **Heading levels**: H1 for spec title, H2 for chapters (numbered), H3 for sections, H4 for subsections
- **Code blocks**: JSON/YAML for schemas, HTTP for protocol examples

### Three-File Naming Convention
| File Suffix | Content Range | Purpose |
|-------------|--------------|---------|
| (none) `.md` | Sections 1-4, Chapters 1-4 | Introduction + core architecture |
| `-continued.md` | Sections 5-8, Chapters 5-8 | Detailed specifications |
| `-reference.md` | Sections 9+, Chapters 9-12 + Appendices | Advanced topics, references, appendices |

---

## 4. Execution Loop Template

For each new specification (AESP-0004 onwards), follow this pipeline:

```
Phase 1: RESEARCH
  Load skill: deep-research-swarm
  Route: B (Focused Search) — specs have clear dimensions
  Steps:
    1. Landscape scan (5 searches, coarse-to-fine)
    2. Decompose into 10+ dimensions
    3. Deploy 10 parallel deep-dive sub-agents
    4. Cross-verify findings, extract insights
    5. Save all artifacts to /mnt/agents/output/research/

Phase 2: DESIGN
  Load skill: report-writing
  Deploy 4 parallel outline design agents:
    - requirement_analyst: Extract requirements from spec scope
    - artifact_analyst: Synthesize research artifacts
    - structure_designer: Design chapter hierarchy with word counts
    - content_planner: Define per-chapter content specs
  Synthesize unified outline (4-level heading format)
  Save: /mnt/agents/output/aespXXXX.agent.outline.md

Phase 3: WRITE
  Deploy writer agents in dependency-aware rounds:
    Round 1: Chapters with no dependencies (usually Ch 1-2)
    Round 2: Chapters depending on Round 1 (usually Ch 3-4, 6, 12)
    Round 3: Chapters depending on earlier rounds (usually Ch 5, 7-9, 11)
    Round 4: Synthesis chapters (usually Ch 10)
  Each writer: create_subagent + task dispatch
  Save per-chapter: /mnt/agents/output/aespXXXX_secNN.md

Phase 4: ASSEMBLE
  Merge all chapter files into final markdown
  Save: /mnt/agents/output/aespXXXX.agent.final.md
  Convert to docx using md2docx pipeline
  Save: /mnt/agents/output/aespXXXX.agent.final.footnote.docx

Phase 5: COMMIT
  Create metadata file (aesp-XXXX.yaml)
  Split into 3 parts if >100K chars
  Push to GitHub using github_pusher subagent:
    - 3 spec files (or 1 if short)
    - metadata YAML
    - CHANGELOG.md update
  Note: docx files >2MB cannot be pushed via MCP, keep locally
```

---

## 5. Key Technical Patterns

### 5.1 GitHub Push Pattern (for large files)
```python
# github_pusher subagent approach:
# 1. Read file in ~8K character chunks
# 2. Accumulate content
# 3. Call create_or_update_file with full accumulated content
# 4. Track SHA via get_file_contents for updates
```

### 5.2 Sub-agent Patterns
| Sub-agent | Purpose | When to Use |
|-----------|---------|-------------|
| github_pusher | Push large files to GitHub | Every commit phase |
| aespXXXX_researcher | Research dimension investigator | Phase 1 (10 parallel) |
| requirement_analyst | Extract requirements | Phase 2 |
| artifact_analyst | Synthesize research | Phase 2 |
| structure_designer | Design chapter hierarchy | Phase 2 |
| content_planner | Plan per-chapter content | Phase 2 |
| aespXXXX_writer | Write chapter content | Phase 3 |
| aespXXXX_merger | Merge + assemble final doc | Phase 4 |

### 5.3 Dependency Graph for Writer Rounds
- **Round 1**: Introduction, Scope, Terminology (foundational chapters)
- **Round 2**: Architecture, Data Models, Core Mechanisms (build on Round 1)
- **Round 3**: Protocol Details, Security, Patterns (build on Round 2)
- **Round 4**: Summary, Conformance, Appendices (synthesize all prior)

### 5.4 Citation Handling
- Research phase: citations auto-recorded to `/mnt/agents/.citation.jsonl`
- Writers use `[^N^]` format with indices from research artifacts
- md2docx pipeline converts citations to Word footnotes
- 92 footnotes and 518 NOTEREFs typical for a 49K-word spec

---

## 6. Upstream Dependencies per Specification

| Spec | Depends On | Downstream Consumers |
|------|-----------|---------------------|
| AESP-0000 (Constitution) | None | All specs |
| AESP-0001 (Core Model) | AESP-0000 | AESP-0002, 0003, 0004, 0005, 0006 |
| AESP-0002 (Agent Roles) | AESP-0000, 0001 | AESP-0005, 0007 |
| AESP-0003 (Comm Protocols) | AESP-0000, 0001, 0002 | AESP-0004, 0005, 0008 |
| **AESP-0004 (Memory Systems)** | AESP-0000, 0001, 0003 | AESP-0005, 0006 |
| AESP-0005 (Workflow Orchestration) | AESP-0001, 0002, 0003, 0004 | AESP-0007, 0008 |
| AESP-0006 (Knowledge Graph) | AESP-0001, 0004 | AESP-0009 |

---

## 7. AESP-0004: Memory Systems — Kickoff Brief

### Scope
AESP-0004 defines memory architectures for autonomous agents: working memory, episodic memory, semantic memory, and procedural memory. It specifies memory operations (store, retrieve, forget, consolidate), memory addressing (content-based, temporal, associative), memory lifecycle, and inter-agent memory sharing protocols.

### Key Topics to Research
1. Vector databases and embedding-based retrieval (Pinecone, Weaviate, Milvus)
2. Memory hierarchies in cognitive architectures (SOAR, ACT-R, CLARION)
3. Episodic vs semantic memory in AI systems (MemGPT, AgentKit memory)
4. CRDT-based distributed memory consistency
5. Memory compression and forgetting mechanisms
6. Temporal memory and recency/frequency decay
7. Memory sharing protocols between agents
8. Knowledge graphs as semantic memory backends
9. Persistent storage patterns for agent memory
10. Privacy and access control for shared memories

### Expected Structure (preliminary, to be refined by research)
- Ch 1: Introduction and Scope
- Ch 2: Memory Model Architecture (4 types: working, episodic, semantic, procedural)
- Ch 3: Memory Operations (CRUD + consolidation + decay)
- Ch 4: Storage Backends (vector DBs, KGs, key-value)
- Ch 5: Retrieval Mechanisms (similarity, temporal, associative)
- Ch 6: Distributed Memory (CRDTs, consistency, sharing)
- Ch 7: Memory Lifecycle (creation → active → archived → forgotten)
- Ch 8: Inter-Agent Memory Protocols
- Ch 9: Security and Privacy
- Ch 10: Implementation Guidelines
- Ch 11: Conformance and Testing
- Ch 12: Appendices

### Files Expected
- `/mnt/agents/output/aesp0004.agent.outline.md` — Final outline
- `/mnt/agents/output/aesp0004_sec01.md` through `sec12.md` — Chapter files
- `/mnt/agents/output/aesp0004.agent.final.md` — Assembled markdown (~45-55K words)
- `/mnt/agents/output/aesp0004.agent.final.footnote.docx` — Word document
- `specification/AESP-0004.md` — Part 1 (GitHub)
- `specification/AESP-0004-continued.md` — Part 2 (GitHub)
- `specification/AESP-0004-reference.md` — Part 3 (GitHub)
- `specification/aesp-0004.yaml` — Metadata (GitHub)

---

## 8. Local Artifacts Inventory

### AESP-0003 Deliverables (keep)
| File | Size | Location |
|------|------|----------|
| aesp0003.agent.final.md | 378,804 chars | /mnt/agents/output/ |
| aesp0003.agent.final.footnote.docx | 2,089,512 B | /mnt/agents/output/ |
| aesp0003.agent.outline.md | ~15K chars | /mnt/agents/output/ |

### Research Artifacts (can archive after use)
| File Set | Size | Location |
|----------|------|----------|
| aesp0003_dim01.md through dim10.md | ~477K total | /mnt/agents/output/research/ |
| aesp0003_insight.md | ~40K chars | /mnt/agents/output/research/ |

### Cleanup Notes
- Remove `aesp0003_sec01.md` through `sec12.md` after successful assembly (already merged)
- Remove `aesp0003-part1.md`, `part2.md`, `part3.md` after GitHub push (already pushed)
- Keep research files until next spec is complete (for reference)

---

## 9. MCP GitHub Plugin

Authenticated GitHub operations use `mcp__plugin-github_github__*` tools:
- `get_file_contents` — Read file + SHA (needed before update)
- `create_or_update_file` — Create new or update existing
- `create_or_update_file` with `sha` parameter — Update existing file

**Critical**: Always get SHA before updating. Use `get_file_contents` first.

**Large file pattern**: For files > ~40K chars, use `github_pusher` subagent with chunk accumulation.

---

## 10. Version History

| Version | Date | Changes |
|---------|------|---------|
| v0.1.0 | 2026-07-06 | AESP-0000 Constitution |
| v0.2.0 | 2026-07-07 | AESP-0001 Core Model |
| v0.3.0 | 2026-07-08 | AESP-0002 Agent Roles |
| v0.4.0 | 2026-07-09 | AESP-0003 Communication Protocols |
| v0.5.0 | 2026-07-10 | CHANGELOG + metadata updates |

---

## 11. Next Steps for Continuing Agent

1. **Read this handover** — You are here!
2. **Clean up AESP-0003 artifacts** if desired (optional)
3. **Write plan.md** for AESP-0004 with specific stage definitions
4. **Load deep-research-swarm skill** — Execute Phase 1 (landscape scan)
5. **Follow execution loop template** (Section 4) through all 5 phases
6. **Update CHANGELOG.md** with v0.6.0 entry after commit
7. **Proceed to AESP-0005** following same pattern

---

*This handover was generated on 2026-07-10. The repository state reflects all work through AESP-0003.*
