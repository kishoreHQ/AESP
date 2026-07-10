# AESP-0004: Memory Systems — Agent Handover Document

**Date**: 2026-07-10
**Repository**: https://github.com/kishoreHQ/AESP
**Handover Type**: Research Phase Partial Completion + Full Plan
**Status**: Phase 1 (Landscape Scan) COMPLETE — Ready for Phase 2 (Dimension Decomposition) and Phase 3 (Parallel Deep Dive)

---

## 1. Executive Summary

AESP-0004 defines memory architectures for autonomous agents. The **Phase 1 landscape scan** has been completed with 5 targeted web searches revealing a rich and converging ecosystem. The research confirms a **three-tier memory taxonomy** (episodic/semantic/procedural) as the dominant paradigm, with production-grade vector databases, emerging consolidation mechanisms, and nascent multi-agent memory sharing protocols. No external conflicts detected — the field shows strong convergence.

**Key Strategic Insight**: The agent memory space has shifted from "simple context buffers" to "full cognitive memory architectures" between 2024-2025. This AESP-0004 specification should codify the converged patterns while remaining extensible for emerging approaches.

---

## 2. Landscape Scan Results (Phase 1 Complete)

### 2.1 Macro Overview — Agent Memory Taxonomy

The industry has converged on a **three-tier memory taxonomy**:

| Memory Type | Function | Duration | Primary Store | Key Implementations |
|-------------|----------|----------|---------------|---------------------|
| **Episodic** | Event sequences, conversations, task histories | Short-to-medium term | Vector databases (embedding-based) | MemGPT, Letta, LangChain buffer memory |
| **Semantic** | Facts, relationships, domain knowledge | Long-term | Knowledge graphs, vector DBs | Neo4j + LangChain, Mem0 Graph Memory |
| **Procedural** | Skills, workflows, learned patterns | Persistent | Code stores, prompt libraries, fine-tuned models | DSPy, AutoGPT skill libraries |

**Evidence**: Mem0 (YC-backed, 25K+ GitHub stars) explicitly implements this three-tier model [^1^]. Letta (formerly MemGPT, 16K+ stars) uses "archival memory" (semantic) + "recall memory" (episodic) + "core memory" (working) [^2^]. MemGPT's original paper (Nov 2023) introduced the OS-inspired memory hierarchy that has become the reference architecture [^3^].

**Working Memory**: A fourth type (working/context memory) holds active conversation context, typically limited by token window (4K-128K tokens depending on model). This is handled by the LLM's native context window + prompt engineering.

### 2.2 Structural Mapping — Technology Landscape

#### Vector Databases for Memory Storage
| Database | Embedding Dim | Hybrid Search | Scalar Filtering | Best For | Notes |
|----------|--------------|---------------|------------------|----------|-------|
| **Pinecone** | Up to 20K | Metadata + vector | Yes | Production cloud | Managed, serverless, $$ |
| **Weaviate** | Up to 65K | BM25 + vector | Yes | Multi-modal | GraphQL interface, open-source |
| **Milvus/Zilliz** | Up to 32K | Full-text + vector | Yes | Large-scale | GPU index building, distributed |
| **pgvector** | 2K (recommended) | ivfflat/hnsw | Yes | Postgres users | Simple, SQL-native |
| **Qdrant** | Up to 65K | Payload + vector | Yes | Edge/on-prem | Rust-based, fast |
| **Chroma** | Flexible | Metadata + vector | Limited | Prototyping | Easy setup, local first |
| **Redis Vector** | Up to 32K | Vector only | Yes | Real-time | Sub-millisecond latency |
| **Elasticsearch** | 1K-2K | BM25 + vector | Yes | Text-heavy | Already in many stacks |

**Key Finding**: Pinecone leads in managed cloud deployments; Milvus dominates large-scale; pgvector wins for simplicity/Postgres integration [^4^][^5^].

#### Agent Memory Frameworks
| Framework | Memory Model | Key Feature | Maturity | GitHub Stars |
|-----------|-------------|-------------|----------|--------------|
| **Mem0** (ex Mem0.ai) | Episodic + Semantic + Procedural | Adaptive personalization, user memory | Production | 25K+ |
| **Letta** (ex MemGPT) | Core + Archival + Recall | OS-inspired virtual context mgmt | Production | 16K+ |
| **LangChain Memory** | Buffer + Summary + Vector | Modular, chain-integrated | Mature | 100K+ (parent) |
| **LlamaIndex** | Index + Query + Chat | RAG-focused memory | Mature | 40K+ |
| **CrewAI Memory** | Short + Long + Entity | Crew-level shared memory | Growing | 25K+ |
| **AG2 (ex AutoGen)** | None native | Per-agent context only | Legacy | 40K+ |
| **Memary** | Hebbian learning | Knowledge graph memory | Experimental | <1K |

### 2.3 Emerging Issues & Tensions

#### Tension 1: Vector-Only vs. Hybrid (Vector + Graph)
- **Vector-only camp**: Simple retrieval, fast similarity search, proven at scale (Pinecone, Qdrant)
- **Hybrid camp**: Graph + vector for complex relationships, multi-hop reasoning (Neo4j + LangChain, Weaviate, Mem0 Graph Memory)
- **Convergence**: All major frameworks adding graph capabilities to vector stores

#### Tension 2: Centralized vs. Distributed Memory
- **Centralized**: Single vector DB instance serving all agents (simpler, but bottleneck)
- **Distributed**: Per-agent memory with federation (scales, but consistency challenges)
- **No clear winner** — depends on deployment topology

#### Tension 3: Explicit vs. Implicit Memory Management
- **Explicit** (MemGPT/Letta): Agent explicitly decides what to store/retrieve via function calls
- **Implicit** (LangChain): Automatic memory management via chain configuration
- **Trend**: Moving toward explicit with smart defaults

#### Tension 4: Privacy vs. Sharing
- Individual agent memories may contain sensitive information
- Shared team memory (CrewAI, enterprise Multi-Agent Systems) needs access control
- No standard protocol for inter-agent memory sharing exists yet

### 2.4 Memory Operations Patterns

From the landscape scan, standard memory operations emerging:

```
STORE:   (content, metadata, embedding) → memory_id
RETRIEVE: (query_embedding, filters, top_k) → [memory_records]
UPDATE:   (memory_id, new_content) → updated_record
DELETE:   (memory_id) → void
CONSOLIDATE: ([memories]) → summary_memory  # NEW: Mem0, Letta support
FORGET:   (memory_id | filter) → void  # Temporal decay or explicit
```

**Consolidation**: MemGPT introduced the concept — background processes summarize old episodic memories into higher-level semantic memories [^3^]. Mem0 implements "adaptive personalization" that consolidates user preferences over time [^1^].

**Forgetting Mechanisms**:
- Time-to-live (TTL) — Redis-native, simple
- Recency-weighted retrieval — de-prioritize older memories (standard in vector DBs)
- Explicit summarization — condense multiple episodes into one summary
- Importance scoring — MemGPT's heuristic: "how much would this memory's absence change the agent's behavior?"

### 2.5 CRDTs for Distributed Memory

CRDTs (Conflict-free Replicated Data Types) identified as the leading approach for distributed agent memory:

| CRDT Type | Use Case | Trade-off |
|-----------|----------|-----------|
| **G-Set** | Append-only memories (audit logs) | Simple, grows unbounded |
| **OR-Set** | Removable memories with unique IDs | Good for general memory |
| **LWW-Register** | Single-value memory slots | Last-write-wins semantics |
| **PN-Counter** | Importance/attention scores | Numeric decay tracking |
| **Delta-State** | Efficient synchronization | Reduced bandwidth |

**Key Insight**: CRDTs align perfectly with AESP-0001's event sourcing model — memory updates are events, and CRDTs provide the merge semantics for distributed agents [^6^].

### 2.6 Multi-Agent Memory Sharing

Current approaches are framework-specific with **no cross-platform standard**:

| Approach | Mechanism | Limitation |
|----------|-----------|------------|
| CrewAI Memory | Shared crew-level context | CrewAI-only |
| LangGraph Shared State | Graph-level state variables | LangGraph-only |
| Mem0 Organization Memory | Multi-user shared memory | Mem0 platform only |
| Custom MCP Tools | Memory exposed as tools | Requires tool protocol |
| Event Bus | Pub/sub memory updates | Custom implementation |

**Gap Identified**: No vendor-neutral protocol for inter-agent memory sharing exists. This is a key opportunity for AESP-0004 to define.

---

## 3. Dimension Decomposition (Phase 2 — Pre-Decomposed)

Based on the landscape scan, the following 12 research dimensions are recommended for Phase 3 parallel deep dive:

| Dim | Title | Scope | Expected Sources |
|-----|-------|-------|-----------------|
| **01** | Vector Databases & Embedding Retrieval | Pinecone, Weaviate, Milvus, Qdrant, pgvector — capabilities, limits, selection criteria | Vendor docs, benchmarks, GitHub |
| **02** | Cognitive Memory Architectures | SOAR, ACT-R, CLARION, Global Workspace Theory — biological inspiration for AI memory | Academic papers, cognitive science |
| **03** | Agent Memory Frameworks | Mem0, Letta/MemGPT, LangChain memory, LlamaIndex — implementation patterns | GitHub, docs, papers |
| **04** | CRDTs for Distributed Memory | OR-Set, LWW-Register, G-Set, Delta-State — merge semantics for shared memory | Academic papers, Riak/AntidoteDB |
| **05** | Memory Consolidation & Forgetting | Summarization, decay models, sleep-inspired compression, importance scoring | MemGPT paper, Mem0 docs, neuroscience |
| **06** | Temporal Memory & Decay | Recency/frequency (RF), time-to-live, sliding windows, clock algorithms | Cache theory, vector DB features |
| **07** | Knowledge Graphs as Semantic Memory | Neo4j, RDF stores, property graphs, graph + vector hybrid | Neo4j docs, academic papers |
| **08** | Inter-Agent Memory Protocols | Shared memory, memory federation, access control, privacy | Framework docs, research papers |
| **09** | Persistent Storage Patterns | Write-ahead logging, snapshotting, event sourcing for memory | Database internals, AESP-0001 |
| **10** | Memory Security & Privacy | Encryption at rest/transit, PII handling, access control, GDPR | Security standards, framework docs |
| **11** | Working Memory & Context Management | Token budgets, prompt compression, context window optimization | LLM papers, framework implementations |
| **12** | Memory Metrics & Evaluation | Recall@K, relevance scoring, memory drift detection, benchmarks | Evaluation papers, MemGPT evals |

---

## 4. Key Findings Summary

### High Confidence (Multiple sources agree)
1. **Three-tier taxonomy** (episodic/semantic/procedural) is the industry consensus
2. **Vector databases are the standard** for episodic memory storage
3. **MemGPT/Letta's OS-inspired approach** is the most cited academic reference
4. **Mem0 leads in production adoption** with explicit three-tier implementation
5. **CRDTs are the right abstraction** for distributed memory (aligns with AESP-0001)
6. **No cross-platform memory sharing protocol exists** — gap for AESP to fill

### Medium Confidence ( Emerging trends)
1. Graph + vector hybrid stores will become standard for semantic memory
2. Memory consolidation (sleep-inspired) will be a standard operation
3. Explicit memory management (function-calling) beats implicit (automatic)
4. Per-agent memory with federation preferred over centralized

### Low Confidence / Research Needed
1. Optimal decay functions for different memory types
2. Standard evaluation metrics for agent memory systems
3. Privacy-preserving memory sharing techniques
4. Memory compression ratios without quality loss

---

## 5. Cross-Cutting Themes for AESP-0004

### Theme 1: The "Memory as a Service" Pattern
Modern agent frameworks treat memory as a separate service with its own API, not just a data structure. This aligns with AESP-0001's Capability model and AESP-0003's communication patterns.

### Theme 2: Event Sourcing Alignment
All memory operations (store, retrieve, consolidate, forget) can be modeled as events. This creates a natural fit with AESP-0001's event sourcing and CRDT-based state management.

### Theme 3: The Convergence Vector
The field is converging toward: **Vector DB for episodic + Knowledge Graph for semantic + Code/Model for procedural**. AESP-0004 should codify this while allowing innovation.

---

## 6. Recommended Outline (Preliminary)

Based on landscape findings, the following 12-chapter structure is recommended:

```
Ch 1:  Introduction and Scope                    (~3000 words)
Ch 2:  Memory Model Architecture                 (~5000 words)  ← 3-tier + working memory
Ch 3:  Memory Operations                         (~4000 words)  ← CRUD + consolidate + forget
Ch 4:  Storage Backends                          (~4000 words)  ← Vector DBs, KGs, hybrid
Ch 5:  Retrieval Mechanisms                      (~4000 words)  ← Similarity, temporal, associative
Ch 6:  Distributed Memory                        (~4000 words)  ← CRDTs, consistency, federation
Ch 7:  Memory Lifecycle                          (~3000 words)  ← Creation → active → archive → forget
Ch 8:  Inter-Agent Memory Protocol               (~4000 words)  ← Sharing, sync, access control
Ch 9:  Security and Privacy                      (~3000 words)  ← Encryption, PII, compliance
Ch 10: Implementation Guidelines                 (~4000 words)  ← MVE, patterns, anti-patterns
Ch 11: Conformance and Testing                   (~2000 words)  ← Test vectors, benchmarks
Ch 12: Appendices                                (~3000 words)  ← Schemas, examples, references
```
**Total estimated**: ~43,000 words (may expand during writing)

---

## 7. Execution Status

| Phase | Status | Notes |
|-------|--------|-------|
| Phase 0: Route Selection | COMPLETE | Route B (Focused Search) selected |
| Phase 1: Landscape Scan | COMPLETE | 5 searches, results synthesized above |
| Phase 2: Dimension Decomposition | READY | 12 dimensions defined (Section 3) |
| Phase 3: Parallel Deep Dive | NOT STARTED | Deploy 12 research sub-agents |
| Phase 4: Cross-Verification | NOT STARTED | After Phase 3 completes |
| Phase 5: Conflict Resolution | NOT STARTED | If conflicts detected |
| Phase 6: Insight Extraction | NOT STARTED | Synthesis into insight file |
| Stage 1: Outline Design | NOT STARTED | Load report-writing skill, deploy 4 agents |
| Stage 2: Content Creation | NOT STARTED | Deploy writer agents in rounds |
| Stage 3: Review Pipeline | NOT STARTED | Section → transition → intro/conclusion |
| Stage 4: Assembly | NOT STARTED | Merge + md2docx conversion |
| Stage 5: GitHub Commit | NOT STARTED | Push 3 files + metadata + CHANGELOG |

---

## 8. Next Steps for Continuing Agent

### Immediate Next Step: Phase 3 — Parallel Deep Dive

1. **Create research sub-agent** (`aesp0004_researcher`) with system prompt for dimension investigation
2. **Deploy 12 parallel research agents** (one per dimension from Section 3)
3. Each agent saves output to `/mnt/agents/output/research/aesp0004_dim{NN}.md`
4. Each agent performs ≥20 independent searches

### Sub-Agent Prompt Template
```
You are a research agent investigating Dimension {NN}: {Title} for AESP-0004 (Memory Systems).

## Mission
Investigate {specific scope} from these angles:
1. Current state — what implementations exist now
2. Key evidence — data, benchmarks, adoption metrics  
3. Tensions and counter-arguments — competing approaches
4. Relevance to agent memory standards — what should AESP-0004 specify

## Context
{Landscape scan findings relevant to this dimension}

## Output Requirements
- ≥20 independent web searches (varied queries, no keyword recycling)
- All citations in [^N^] format
- Save output to /mnt/agents/output/research/aesp0004_dim{NN}.md
- Structure: Key Findings, Major Players, Technical Details, Tensions, Recommendations for AESP-0004
```

### After Phase 3 Completes
5. Phase 4: Read all dim files, cross-verify findings, note conflicts
6. Phase 5: Resolve any conflicts detected
7. Phase 6: Extract insights → `/mnt/agents/output/research/aesp0004_insight.md`
8. Load `report-writing` skill, begin Stage 1 (outline design)
9. Continue through Stages 2-5 per standard pipeline

---

## 9. Files and Locations

### Local Files
| File | Path | Status |
|------|------|--------|
| Main handover | `/mnt/agents/output/HANDOVER.md` | Pushed to GitHub |
| AESP-0004 handover | `/mnt/agents/output/HANDOVER-AESP0004.md` | This file |
| Execution plan | `/mnt/agents/output/plan.md` | Written, ready |

### GitHub Files
| File | Path | SHA |
|------|------|-----|
| HANDOVER.md | `HANDOVER.md` | ca18dabb... |

### Expected Research Outputs (Phase 3)
| File | Path | Description |
|------|------|-------------|
| Dim 01 | `/mnt/agents/output/research/aesp0004_dim01.md` | Vector Databases |
| Dim 02 | `/mnt/agents/output/research/aesp0004_dim02.md` | Cognitive Architectures |
| Dim 03 | `/mnt/agents/output/research/aesp0004_dim03.md` | Agent Memory Frameworks |
| Dim 04 | `/mnt/agents/output/research/aesp0004_dim04.md` | CRDTs |
| Dim 05 | `/mnt/agents/output/research/aesp0004_dim05.md` | Consolidation & Forgetting |
| Dim 06 | `/mnt/agents/output/research/aesp0004_dim06.md` | Temporal Memory |
| Dim 07 | `/mnt/agents/output/research/aesp0004_dim07.md` | Knowledge Graphs |
| Dim 08 | `/mnt/agents/output/research/aesp0004_dim08.md` | Inter-Agent Protocols |
| Dim 09 | `/mnt/agents/output/research/aesp0004_dim09.md` | Storage Patterns |
| Dim 10 | `/mnt/agents/output/research/aesp0004_dim10.md` | Security & Privacy |
| Dim 11 | `/mnt/agents/output/research/aesp0004_dim11.md` | Working Memory |
| Dim 12 | `/mnt/agents/output/research/aesp0004_dim12.md` | Metrics & Evaluation |
| Insights | `/mnt/agents/output/research/aesp0004_insight.md` | Cross-dimension synthesis |

---

## 10. Dependencies and Constraints

### Upstream Dependencies
- **AESP-0000**: Use normative language (MUST/SHOULD/MAY), follow specification lifecycle
- **AESP-0001**: Align with Agent entity, WorkUnit, CRDT, and event sourcing models
- **AESP-0003**: Use message envelope format for memory operations over transports

### Downstream Consumers
- **AESP-0005** (Workflow Orchestration): Will use memory for state persistence
- **AESP-0006** (Knowledge Graph): Will extend semantic memory layer

### Technical Constraints
- All memory operations must work with AESP-0001's event sourcing
- CRDT-based consistency is preferred over consensus (availability > strong consistency)
- MVE (Minimum Viable Ecosystem) must be implementable with open-source tools
- Must specify both in-memory and persistent storage modes

---

*This handover was generated on 2026-07-10 after Phase 1 landscape scan completion. All findings are evidence-based from web searches conducted during the scan. Phase 3 parallel deep dive is the next step.*
