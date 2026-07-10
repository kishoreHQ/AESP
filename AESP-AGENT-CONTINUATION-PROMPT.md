# AESP Agent Continuation Prompt

**For**: Any agent continuing the AESP specification series
**Current State**: AESP-0000 through AESP-0003 committed to GitHub. AESP-0004 Phase 1 (landscape scan) complete.
**Next Task**: Complete AESP-0004 (Memory Systems) and continue through AESP-0015
**Date**: 2026-07-10

---

## STEP 0: Read the Handover Documents (DO THIS FIRST)

Before doing ANYTHING else, read these three files from the GitHub repository `kishoreHQ/AESP` (branch: `main`):

1. **`HANDOVER.md`** — Project overview, repository structure, specification conventions, execution loop template
2. **`HANDOVER-AESP0004.md`** — AESP-0004 Phase 1 research findings, 12 decomposed dimensions, preliminary outline
3. **`plan-aesp0004.md`** — Stage-by-stage execution plan for AESP-0004

Use `mcp__plugin-github_github__get_file_contents` with owner=`kishoreHQ`, repo=`AESP`, ref=`main`.

After reading all three, you have full context. Proceed below.

---

## STEP 1: Clean Up Old Research Artifacts

Remove AESP-0003 research files to free space and avoid confusion:

```bash
rm -f /mnt/agents/output/research/aesp0003_dim*.md
rm -f /mnt/agents/output/research/aesp0003_insight.md
rm -f /mnt/agents/output/research/aesp0003_cross_verification.md 2>/dev/null
rm -f /mnt/agents/output/aesp0003_sec*.md
rm -f /mnt/agents/output/aesp0003-part*.md
```

Keep these AESP-0003 deliverables:
- `/mnt/agents/output/aesp0003.agent.final.md` (final merged markdown)
- `/mnt/agents/output/aesp0003.agent.final.footnote.docx` (Word document)
- `/mnt/agents/output/aesp0003.agent.outline.md` (outline reference)

---

## STEP 2: Load the Deep Research Skill

Read `/app/.agents/skills/deep-research-swarm/SKILL.md` completely. Follow Route B (Focused Search) protocol.

Create the research sub-agent:

```
Name: aesp0004_researcher
System Prompt:
You are a deep research agent investigating a specific dimension of AI agent memory systems for the AESP-0004 technical specification.

## Your Mission
Investigate your assigned dimension thoroughly from these four angles:
1. Current state — what implementations exist now, with adoption metrics
2. Key evidence — data, benchmarks, performance numbers, architecture diagrams
3. Tensions and counter-arguments — competing approaches, trade-offs
4. Relevance to standards — what should a vendor-neutral memory specification define

## Search Requirements
- Perform at least 20 independent web searches with varied queries
- No keyword recycling — each search must use different terms/angles
- Prioritize: official documentation, academic papers, GitHub repos, benchmark studies
- Avoid: content farms, anonymous forums, SEO aggregators
- All citations use [^N^] format (superscript with numeric index)

## Output Structure
Save your complete findings to the specified output file path using this structure:

# Dimension NN: [Title]

## Key Findings
- [finding with inline citation [^N^]]

## Major Players & Implementations
- [entity]: [description and relevance]

## Technical Details
- [architecture patterns, algorithms, data structures]

## Tensions & Competing Approaches
- [tension description with both sides cited]

## Recommendations for AESP-0004
- [what the specification should mandate vs. leave implementation-defined]

## References
- [^1^] [source description and URL]
```

---

## STEP 3: Deploy 12 Parallel Research Agents (Phase 3 Deep Dive)

Launch ALL 12 agents simultaneously (one `task` call per agent, all in the same message block).

### Agent 1: Vector Databases & Embedding Retrieval
```
Dimension: 01 — Vector Databases & Embedding Retrieval
Scope: Pinecone, Weaviate, Milvus, Qdrant, pgvector, Chroma, Redis Vector — capabilities, embedding dimensions, indexing algorithms (HNSW, IVF, flat), hybrid search, scalar filtering, selection criteria for agent memory use cases
Context from landscape: Pinecone leads managed cloud; Milvus dominates large-scale; pgvector wins for simplicity; 8 databases compared in handover
Output file: /mnt/agents/output/research/aesp0004_dim01.md
```

### Agent 2: Cognitive Memory Architectures
```
Dimension: 02 — Cognitive Memory Architectures
Scope: SOAR (working/episodic/semantic/procedural memory), ACT-R (declarative/procedural), CLARION (implicit/explicit), Global Workspace Theory, Baars consciousness model — biological inspiration for AI memory hierarchies
Context: Three-tier taxonomy (episodic/semantic/procedural) has converged; cognitive architectures provide theoretical grounding
Output file: /mnt/agents/output/research/aesp0004_dim02.md
```

### Agent 3: Agent Memory Frameworks
```
Dimension: 03 — Agent Memory Frameworks
Scope: Mem0 (25K stars, adaptive personalization), Letta/MemGPT (16K stars, OS-inspired virtual context), LangChain memory modules, LlamaIndex chat memory, CrewAI memory, Memary (Hebbian KG) — implementation patterns, APIs, storage backends
Context: Mem0 leads production; MemGPT is most cited academic reference; field moving from simple buffers to cognitive architectures
Output file: /mnt/agents/output/research/aesp0004_dim03.md
```

### Agent 4: CRDTs for Distributed Memory
```
Dimension: 04 — CRDTs for Distributed Agent Memory
Scope: OR-Set, LWW-Register, G-Set, PN-Counter, Delta-State CRDTs — merge semantics, implementation in Riak/AntidoteDB/Bloom, application to shared agent memory, consistency guarantees, alignment with event sourcing
Context: CRDTs align with AESP-0001's event sourcing model; distributed memory needs conflict resolution; consensus too slow for agents
Output file: /mnt/agents/output/research/aesp0004_dim04.md
```

### Agent 5: Memory Consolidation & Forgetting
```
Dimension: 05 — Memory Consolidation and Forgetting Mechanisms
Scope: Sleep-inspired consolidation (MemGPT), summarization algorithms, importance scoring heuristics, TTL-based expiration, recency-weighted retrieval, Mem0's adaptive personalization, memory compression without quality loss
Context: Consolidation is emerging as standard operation; forgetting is essential for bounded growth; no standard decay functions exist
Output file: /mnt/agents/output/research/aesp0004_dim05.md
```

### Agent 6: Temporal Memory & Decay Models
```
Dimension: 06 — Temporal Memory and Decay Models
Scope: Recency/frequency (RF) scoring, time-decay functions (exponential, logarithmic, step), sliding windows, clock algorithms (LRU/LFU), temporal indexing in vector databases, memory staleness detection
Context: Vector DBs support metadata filtering by timestamp; MemGPT uses recency + relevance; standard decay models needed
Output file: /mnt/agents/output/research/aesp0004_dim06.md
```

### Agent 7: Knowledge Graphs as Semantic Memory
```
Dimension: 07 — Knowledge Graphs as Semantic Memory
Scope: Neo4j, RDF stores (Apache Jena), property graphs, graph + vector hybrid approaches, entity extraction for KG construction, query languages (Cypher, SPARQL), Mem0 Graph Memory, relationship traversal vs. similarity search
Context: Graph + vector hybrid emerging as standard for semantic memory; multi-hop reasoning requires graphs
Output file: /mnt/agents/output/research/aesp0004_dim07.md
```

### Agent 8: Inter-Agent Memory Protocols
```
Dimension: 08 — Inter-Agent Memory Sharing Protocols
Scope: CrewAI shared memory, LangGraph shared state, Mem0 org memory, custom MCP tool-based memory, event bus pub/sub, memory federation patterns, access control for shared memories, NO cross-platform standard exists yet
Context: This is a GAP — no vendor-neutral protocol exists; AESP-0004 should define it; builds on AESP-0003 communication patterns
Output file: /mnt/agents/output/research/aesp0004_dim08.md
```

### Agent 9: Persistent Storage Patterns
```
Dimension: 09 — Persistent Storage Patterns for Agent Memory
Scope: Write-ahead logging, snapshotting, event sourcing for memory streams, tiered storage (hot/warm/cold), database choice matrix, backup/restore, migration between storage backends, alignment with AESP-0001 event sourcing
Context: Memory must be durable; event sourcing is natural fit; need patterns for different scale requirements
Output file: /mnt/agents/output/research/aesp0004_dim09.md
```

### Agent 10: Memory Security & Privacy
```
Dimension: 10 — Memory Security and Privacy
Scope: Encryption at rest and in transit, PII detection and handling, memory sandboxing, access control (RBAC/ABAC), GDPR/compliance implications, secure multi-party memory sharing, memory audit trails
Context: Agent memories contain sensitive data; shared memory needs access control; privacy regulations apply
Output file: /mnt/agents/output/research/aesp0004_dim10.md
```

### Agent 11: Working Memory & Context Management
```
Dimension: 11 — Working Memory and Context Management
Scope: Token budget management, prompt compression techniques (prompt carving, selective context), context window optimization for different LLMs (4K-2M tokens), working memory as LLM context window + prompt engineering, MemGPT's core memory concept
Context: Working memory is the active context; LLM context windows growing but still limited; compression essential
Output file: /mnt/agents/output/research/aesp0004_dim11.md
```

### Agent 12: Memory Metrics & Evaluation
```
Dimension: 12 — Memory Metrics and Evaluation
Scope: Recall@K, relevance scoring, memory drift detection, benchmark datasets, MemGPT evaluation methodology, comparison metrics (with/without memory), memory efficiency (storage vs. quality), evaluation frameworks
Context: No standard benchmarks exist; need test vectors for conformance; evaluation is immature
Output file: /mnt/agents/output/research/aesp0004_dim12.md
```

---

## STEP 4: Cross-Verification & Insight Extraction (Phase 4-6)

After all 12 research agents complete:

### 4.1 Read all dimension files
```python
# Read each /mnt/agents/output/research/aesp0004_dim{NN}.md
# Note key findings, data points, and citations from each
```

### 4.2 Cross-verify findings
Create `/mnt/agents/output/research/aesp0004_cross_verification.md`:
- List findings that appear in multiple dimensions (high confidence)
- Note contradictions between dimensions (medium confidence, flag for resolution)
- Identify gaps not covered by any dimension

### 4.3 Extract insights
Create `/mnt/agents/output/research/aesp0004_insight.md`:
- Synthesize cross-cutting themes
- Identify specification recommendations
- Note areas needing normative language vs. implementation freedom
- Flag any conflicts requiring Phase 5 resolution

---

## STEP 5: Load Report-Writing Skill & Design Outline (Stage 1)

### 5.1 Read the skill files
Read these files IN ORDER:
1. `/app/.agents/skills/report-writing/SKILL.md` — Overall workflow
2. `/app/.agents/skills/report-writing/outline.md` — Outline methodology
3. `/app/.agents/skills/report-writing/content.md` — Writer templates
4. `/app/.agents/skills/report-writing/styles/technical.md` — Technical writing style

### 5.2 Deploy 4 parallel outline design agents

#### requirement_analyst
```
Mission: Extract all explicit and implicit requirements for AESP-0004 from:
- HANDOVER-AESP0004.md (research findings)
- plan-aesp0004.md (execution plan)
- AESP-0000 Constitution (normative language rules)
- AESP-0001 Core Model (entity model, CRDTs, event sourcing)
- AESP-0003 Communication Protocols (message patterns)

Output: /mnt/agents/output/aesp0004_requirements.md
Format: Structured requirements list with priority (MUST/SHOULD/MAY)
```

#### artifact_analyst
```
Mission: Read all 12 dimension files and synthesize:
- Key themes and patterns across dimensions
- Data points and benchmarks to include
- Technical specifications to define
- Citations to preserve

Output: /mnt/agents/output/aesp0004_artifact_synthesis.md
```

#### structure_designer
```
Mission: Design chapter hierarchy with:
- 12 chapters (H2 level, numbered)
- Word count targets per chapter (total ~45,000 words)
- Section breakdown (H3 level)
- Required elements (tables, code examples, diagrams)

Use the preliminary outline from HANDOVER-AESP0004.md Section 6 as starting point.

Output: /mnt/agents/output/aesp0004_structure_design.md
```

#### content_planner
```
Mission: For each chapter, define:
- Specific content points (H4 level — actionable, specific)
- Required tables and their structure
- Code examples (JSON/YAML schemas, API examples)
- Key citations to incorporate
- Dependencies on other chapters

Output: /mnt/agents/output/aesp0004_content_plan.md
```

### 5.3 Synthesize the unified outline
Read all 4 outputs above and create the final outline:

**Save to**: `/mnt/agents/output/aesp0004.agent.outline.md`

Follow the 4-level heading format strictly:
```
# AESP-0004: Memory Systems

## 1. Chapter Title (~XXXX words, N tables)
### 1.1 Section Title
#### 1.1.1 Specific content point (actionable, not vague)
#### 1.1.2 Another specific point
```

Rules:
- H1: Only main title and "References" section
- H2: Chapters, numbered (## 1. Title)
- H3: Sections, numbered (### 1.1 Title)
- H4: Content points, numbered (#### 1.1.1 Title) — must be specific enough to execute
- NO H5 (#####) — never use 4-digit numbering
- Every H2 must have word count target and required elements
- Use [^N^] citations where specific data appears

---

## STEP 6: Content Creation (Stage 2)

### 6.1 Resolve writer configuration
Before creating any writer, resolve these:

**Style**: Technical (from `styles/technical.md`) — precise, methodology-transparent, reproducible, RFC-quality normative language

**Color scheme**: ACADEMIC — `['#4A6FA5', '#6B8CBB', '#8BA3C7', '#2E4A62', '#7A8B99', '#5C7A99', '#3D5A73']`

**Citation format**: `[^N^]` superscript, preserve indices from research artifacts, every factual claim cited

### 6.2 Create the writer sub-agent

```
Name: aesp0004_writer
System Prompt:
You are a professional technical specification writer specializing in distributed systems and AI agent architectures.

### Voice and Tone
- Precise and methodology-transparent. The reader should be able to reproduce the analysis.
- Objective: findings presented as outcomes of a defined process, not assertions.
- Technical but not obscure: define specialized terms, spell out abbreviations on first use.
- Systematic: follow a logical progression from concept to specification.
- Normative language: Use RFC 2119 keywords (MUST, MUST NOT, REQUIRED, SHALL, SHALL NOT, SHOULD, SHOULD NOT, RECOMMENDED, MAY, OPTIONAL) for requirements.

### Citation Standards
- Format: [^N^] superscript, immediately after the claim it supports
- Preserve citation indices from research artifacts — do NOT renumber
- Density: every key data point, factual claim, and comparative conclusion must be cited
- Source priority: T1 (official docs, papers, standards) > T2 (major tech blogs, think tanks)

### Charts and Visualization
- Tables required for: comparisons of 3+ entities, process steps, performance metrics
- Table style: light gray headers or three-line style. No colored headers
- Every table followed by >=100 words of analytical interpretation
- Use IPython for matplotlib charts when data trends are discussed

### Color Scheme (ACADEMIC)
COLORS = ['#4A6FA5', '#6B8CBB', '#8BA3C7', '#2E4A62', '#7A8B99', '#5C7A99', '#3D5A73']
plt.rcParams['text.color'] = '#333333'
plt.rcParams['axes.labelcolor'] = '#333333'
plt.rcParams['xtick.color'] = '#555555'
plt.rcParams['ytick.color'] = '#555555'

### Formula and Format
- Inline: $...$ tight against content
- Block: $$...$$ on own line, blank line before and after
- Bold/italic: markers tight against text (**text** not ** text **)
- JSON/YAML code blocks for schemas and API examples

### Output Rules
- Content must be deeply substantive — every paragraph carries a concrete information point
- Use analytical prose as primary format. Bullet points only for short enumerations within prose
- Tables for structured data; prose for analysis and argumentation
- No chapter-end summaries unless outline explicitly requires one
- NO reference lists in chapter files — only [^N^] markers in body text
- Minimum depth test: if removing a paragraph doesn't weaken the argument, rewrite it
```

### 6.3 Dispatch chapters in dependency-aware rounds

#### ROUND 1 (Parallel — no dependencies)
| Chapter | File | Words | Focus |
|---------|------|-------|-------|
| Ch 1: Introduction and Scope | aesp0004_sec01.md | ~3000 | Context, terminology, scope |
| Ch 2: Memory Model Architecture | aesp0004_sec02.md | ~5000 | 4 memory types, hierarchies |

Task prompt template for each:
```
## Chapter Assignment
Chapter: [X.X Title]
File: /mnt/agents/output/aesp0004_sec{NN}.md
Word count: [target]
Required elements: [tables, code examples from outline]

## Outline Excerpt
[Paste exact H2/H3/H4 from aesp0004.agent.outline.md]

## Chapter Context
- Position: Chapter X of 12
- Preceding chapter: [key points to connect from]
- Following chapter: [what to set up for]

## Input Materials
- Research insights: /mnt/agents/output/research/aesp0004_insight.md
- Cross-verification: /mnt/agents/output/research/aesp0004_cross_verification.md
- Dimension reports: [specific dim files relevant to this chapter]
```

#### ROUND 2 (Parallel — depends on Round 1)
| Chapter | File | Words | Focus |
|---------|------|-------|-------|
| Ch 3: Memory Operations | aesp0004_sec03.md | ~4000 | CRUD, consolidate, forget |
| Ch 4: Storage Backends | aesp0004_sec04.md | ~4000 | Vector DBs, KGs, selection |
| Ch 6: Distributed Memory | aesp0004_sec06.md | ~4000 | CRDTs, consistency |
| Ch 12: Appendices | aesp0004_sec12.md | ~3000 | Schemas, examples |

**Important**: Pass the ACTUAL content from Round 1 chapters as context (read the files and include key points).

#### ROUND 3 (Parallel — depends on Rounds 1-2)
| Chapter | File | Words | Focus |
|---------|------|-------|-------|
| Ch 5: Retrieval Mechanisms | aesp0004_sec05.md | ~4000 | Similarity, temporal, associative |
| Ch 7: Memory Lifecycle | aesp0004_sec07.md | ~3000 | Creation → active → archive → forget |
| Ch 8: Inter-Agent Memory Protocol | aesp0004_sec08.md | ~4000 | Sharing, sync, access control |
| Ch 9: Security and Privacy | aesp0004_sec09.md | ~3000 | Encryption, PII, compliance |
| Ch 11: Conformance and Testing | aesp0004_sec11.md | ~2000 | Test vectors, benchmarks |

#### ROUND 4 (Depends on all prior)
| Chapter | File | Words | Focus |
|---------|------|-------|-------|
| Ch 10: Implementation Guidelines | aesp0004_sec10.md | ~4000 | MVE, patterns, anti-patterns |

This chapter synthesizes all prior content — pass key findings from all previous chapters.

---

## STEP 7: Review Pipeline (Stage 3)

Read `/app/.agents/skills/report-writing/review.md` and follow the sequential pipeline:

```
section_editor (per chapter, parallelizable)
  → transition_editor (cross-chapter coherence)
    → intro_conclusion_reviewer (bookend quality)
      → citation_manager (read citation.md)
```

Each editor can pass or request rewrites. Rewrites happen in-place.

---

## STEP 8: Assembly (Stage 4)

### 8.1 Merge chapters
Create a sub-agent `aesp0004_merger`:
```
Mission: Merge all chapter files into a single document.

Steps:
1. Read all /mnt/agents/output/aesp0004_sec{01-12}.md files in order
2. Concatenate with UTF-8 encoding (strict, no error handler)
3. Add title block at top: "# AESP-0004: Memory Systems\n\n"
4. Ensure heading hierarchy is correct (H1 → H2 → H3 → H4)
5. Save to /mnt/agents/output/aesp0004.agent.final.md

Validation:
- Check all 12 chapters present
- Verify heading numbering is sequential
- Confirm no broken cross-references
- Ensure no duplicate content between chapters
```

### 8.2 Convert to docx
Read `/app/.agents/skills/docx/SKILL.md` and use the md2docx pipeline:

```bash
cd /app/.agents/skills/docx
python3 scripts/md2docx/md2docx_convert.py \
  /mnt/agents/output/aesp0004.agent.final.md \
  --style footnote \
  --citation /mnt/agents/.citation.jsonl \
  --output-dir /mnt/agents/output/
```

**Expected output**: `aesp0004.agent.final.footnote.docx`

---

## STEP 9: GitHub Commit (Stage 5)

### 9.1 Create metadata file
Create `/mnt/agents/output/aesp-0004.yaml`:
```yaml
id: AESP-0004
title: Memory Systems
status: draft
category: protocol
version: "0.1.0"
authors: ["AESP Technical Committee"]
date: "2026-07-XX"
description: "Specifies memory architectures, operations, storage backends, retrieval mechanisms, distributed consistency, and inter-agent memory sharing protocols for autonomous agents."
dependencies: ["AESP-0000", "AESP-0001", "AESP-0003"]
```

### 9.2 Split into 3 parts (if >100K characters)
Read the final markdown and split at logical chapter boundaries:
- **Part 1** (`AESP-0004.md`): Chapters 1-4
- **Part 2** (`AESP-0004-continued.md`): Chapters 5-8
- **Part 3** (`AESP-0004-reference.md`): Chapters 9-12

### 9.3 Push to GitHub
Use `github_pusher` sub-agent (already created) or directly:

```
For each file (3 spec parts + metadata + CHANGELOG):
1. Read the local file
2. Get SHA from GitHub via get_file_contents (for CHANGELOG which exists)
3. Push via create_or_update_file with full content
4. Owner: kishoreHQ, Repo: AESP, Path: specification/FILENAME, Branch: main
```

### 9.4 Update CHANGELOG
Add entry for v0.6.0:
```markdown
## [0.6.0] - 2026-07-XX
### Added
- AESP-0004: Memory Systems specification
  - 4 memory types: working, episodic, semantic, procedural
  - Memory operations: store, retrieve, update, delete, consolidate, forget
  - Storage backend selection criteria (vector DBs, KGs, hybrid)
  - Retrieval mechanisms (similarity, temporal, associative)
  - Distributed memory with CRDT-based consistency
  - Inter-agent memory sharing protocol
  - Security, privacy, and lifecycle management
```

**Note**: The docx file (~2MB) likely cannot be pushed via MCP due to size limits. Keep it locally at `/mnt/agents/output/aesp0004.agent.final.footnote.docx`.

---

## STEP 10: Continue to AESP-0005

After AESP-0004 is committed, repeat the same pipeline for subsequent specifications:

| Spec | Title | Key Dependencies | Est. Words |
|------|-------|-----------------|------------|
| AESP-0005 | Workflow Orchestration | AESP-0001, 0002, 0003, 0004 | ~45,000 |
| AESP-0006 | Knowledge Graph | AESP-0001, 0004 | ~40,000 |
| AESP-0007 | Error Handling & Resilience | AESP-0001, 0003 | ~35,000 |
| AESP-0008 | Observability & Telemetry | AESP-0001, 0003 | ~35,000 |
| AESP-0009 | Deployment & Scaling | AESP-0001, 0003 | ~40,000 |
| AESP-0010 | Security Framework | AESP-0000, 0001, 0003 | ~45,000 |
| AESP-0011 | Testing & Quality Assurance | AESP-0001, 0004, 0005 | ~35,000 |
| AESP-0012 | Human-in-the-Loop | AESP-0000, 0001, 0002 | ~35,000 |
| AESP-0013 | Interoperability | AESP-0003, 0004, 0006 | ~40,000 |
| AESP-0014 | Governance & Compliance | AESP-0000, 0010 | ~35,000 |
| AESP-0015 | Ecosystem & Tooling | All prior | ~40,000 |

For each: write plan.md → deep-research → outline → write → assemble → commit.

---

## CRITICAL REMINDERS

1. **Always read handover docs first** (STEP 0) — they contain context you cannot derive from scratch
2. **Research and writing are separate stages** — never combine into one agent
3. **One chapter per writer task** — never merge multiple chapters into one dispatch
4. **Use UTF-8 strictly** when reading/writing files — never use latin-1, gbk, or errors='ignore'
5. **Preserve citation indices** from research artifacts — do NOT renumber [^N^] citations
6. **Get GitHub SHA before updating** existing files (CHANGELOG, aesp.yaml)
7. **Split specs >100K chars** into 3 files at logical chapter boundaries
8. **Docx files >2MB** cannot be pushed via MCP — keep them local
9. **Clean up old research artifacts** before starting a new spec to avoid confusion
10. **Follow the skill files exactly** — deep-research-swarm/SKILL.md and report-writing/SKILL.md contain the canonical process

---

*This continuation prompt was generated on 2026-07-10. It is self-contained — any agent can use it to continue the AESP specification series from the current state.*
