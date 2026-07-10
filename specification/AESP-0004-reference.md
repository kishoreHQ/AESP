# AESP-0004: Memory Systems, Reference

## 9. Security and Privacy

### 9.1 Threat Model

Agent memory systems store information that can directly affect future behavior. Threats include unauthorized retrieval, prompt injection persisted as memory, stale policy resurrection, privacy leakage through shared memory, embedding inversion, cross-tenant index leakage, poisoned consolidation, and deletion failure in distributed replicas.

`MEM-REQ-088`: A memory implementation MUST perform access control on store, retrieve, update, delete, forget, consolidate, share, subscribe, export, and import operations.

`MEM-REQ-089`: A memory implementation MUST audit denied access attempts for protected scopes.

`MEM-REQ-090`: A memory implementation SHOULD scan candidate long-term memories for sensitive data classes before admission.

NIST SP 800-53 provides a broad catalog of security and privacy controls, including access control, audit and accountability, identification and authentication, system and communications protection, and system and information integrity families [^11^]. AESP-0004 does not import NIST controls wholesale, but implementations operating in regulated environments SHOULD map memory controls to their applicable control catalog.

### 9.2 Authorization

Authorization decisions MUST consider actor, role, scope, operation, purpose, sensitivity, source, lifecycle state, and retention policy.

`MEM-REQ-091`: Memory authorization MUST integrate with AESP-0002 role and permission semantics when deployed in an AEO that implements AESP-0002.

`MEM-REQ-092`: Purpose-bound access SHOULD be supported for team, organization, and federation scopes.

`MEM-REQ-093`: A memory service MUST prevent an agent from laundering private memory into a broader scope without authorization.

### 9.3 Privacy and Data Minimization

Long-term memory increases the risk of retaining information that users or organizations did not expect to persist.

`MEM-REQ-094`: A memory service MUST support configurable non-storage policies for sensitive classes.

`MEM-REQ-095`: A memory service SHOULD support redaction, anonymization, pseudonymization, and cryptographic deletion.

`MEM-REQ-096`: A memory service MUST expose export and deletion workflows for data subject or organizational retention processes when applicable law or policy requires them.

### 9.4 Prompt Injection and Memory Poisoning

Prompt injection becomes more durable when malicious content is stored as memory. A memory service MUST treat retrieved memory as data, not as inherently trusted instruction.

`MEM-REQ-097`: Retrieved memories MUST be labeled by source and trust class before insertion into working memory.

`MEM-REQ-098`: Agents MUST NOT treat user-originated episodic memories as higher authority than system, policy, or human-governance instructions.

`MEM-REQ-099`: Consolidation SHOULD detect attempts to convert untrusted episodic content into authoritative semantic or procedural memory.

`MEM-REQ-108`: Memories admitted from tool outputs, web retrieval, or peer agents MUST default to trust class `untrusted` unless a higher trust policy explicitly applies.

`MEM-REQ-109`: Indirect prompt injection defenses MUST include blocking promotion of untrusted memory into procedural instructions that change tool policy or system prompts.

`MEM-REQ-110`: When a memory is found to be poisoned (malicious instruction content), implementations MUST support quarantine of that record and optional cascade review of consolidations derived from it.

`MEM-REQ-111`: Cross-session memory reuse MUST re-evaluate authorization and trust class at retrieval time, not only at write time.

## 10. Implementation Guidelines

### 10.1 Minimum Viable Implementation

A minimum viable conforming implementation supports:

1. JSON `MemoryRecord` serialization.
2. Memory types and scopes.
3. Store, retrieve, update, delete, forget, and audit.
4. Authorization checks for all operations.
5. Time-bounded episodic retrieval.
6. At least one semantic retrieval mode.
7. Lifecycle states and retention policy.
8. A memory capability manifest.

`MEM-REQ-100`: An implementation claiming Core conformance MUST satisfy all requirements marked as MUST in Chapters 1-10.

### 10.2 Recommended Architecture

The RECOMMENDED production architecture is an event-sourced memory service with specialized projections:

| Component | Responsibility |
|:---|:---|
| Memory API | AESP operation surface and validation |
| Policy engine | Authorization, retention, sensitivity, purpose |
| Event log | Durable source of truth for mutations |
| Metadata store | Record headers, scopes, lifecycle state |
| Vector projection | Similarity and hybrid candidate generation |
| Graph projection | Entity and relationship traversal |
| Object store | Large content and immutable artifacts |
| Audit service | Compliance evidence and access reports |

This architecture keeps governance close to the API while allowing retrieval backends to evolve independently. It also gives the AEO a replayable source of truth when embeddings, indexes, or graph extraction methods change.

### 10.3 Anti-Patterns

The following patterns are discouraged:

| Anti-Pattern | Why It Fails |
|:---|:---|
| One global vector namespace | Blurs ownership, scope, and retention |
| Memory without provenance | Cannot explain or audit behavior |
| Deleting index entries only | Leaves source records or replicas active |
| Treating retrieval as authorization | Candidate generation can leak policy-protected records |
| Full-history replay as memory | Expensive, stale, and brittle over long sessions |
| Summaries without source links | Prevents verification and correction |
| Last-write-wins for policies | Can erase safer concurrent changes |

### 10.4 Migration

Memory systems evolve. Implementations SHOULD plan for embedding migration, schema migration, backend migration, and policy migration.

`MEM-REQ-101`: A memory migration MUST preserve record identifiers or provide a redirect map.

`MEM-REQ-102`: A memory migration MUST preserve lifecycle state, policy, provenance, and audit references.

`MEM-REQ-103`: Re-embedding migrations SHOULD retain old embeddings until retrieval quality is validated or rollback is no longer required.

## 11. Conformance and Testing

### 11.1 Conformance Tiers

| Tier | Name | Requirements |
|:---|:---|:---|
| Tier 1 | Core Memory | Types, records, operations, policy, audit |
| Tier 2 | Retrieval Memory | Hybrid retrieval, explanations, lifecycle controls |
| Tier 3 | Distributed Memory | CRDT/event synchronization and inter-agent sharing |
| Tier 4 | Regulated Memory | Advanced privacy, federation, legal retention |

`MEM-REQ-104`: A conformance claim MUST identify its tier and unsupported optional features.

### 11.2 Required Test Families

A conforming test suite SHOULD include:

1. Schema validation for memory records and capability manifests.
2. Store/retrieve/update/delete/forget operation tests.
3. Authorization denial and non-disclosure tests.
4. Retrieval ranking and explanation tests.
5. Lifecycle transition tests.
6. Tombstone replication tests for distributed memory.
7. Consolidation provenance tests.
8. Privacy redaction and export tests.
9. Migration replay tests.

`MEM-REQ-105`: A Core conformance test MUST verify that forgotten records are excluded from default retrieval and working-memory selection.

`MEM-REQ-106`: A Distributed conformance test MUST verify convergence after concurrent add/delete and update/delete operations.

### 11.3 Evaluation Metrics

Memory quality SHOULD be evaluated using task-level and retrieval-level metrics. Retrieval metrics include Recall@K, Precision@K, mean reciprocal rank, freshness, contradiction rate, policy violation rate, and explanation coverage. Task metrics include outcome quality with and without memory, latency, token cost, user correction rate, and stale-memory harm rate.

LoCoMo evaluates very long-term conversational memory across long dialogues and reports that long-context and retrieval-augmented systems still struggle with long-range temporal and causal dynamics [^9^]. Mem0 reports improved judge-based performance and substantial latency and token-cost reductions compared with full-context approaches on long-term memory evaluations [^4^]. These results support evaluating memory systems as end-to-end behavioral systems, not just as nearest-neighbor indexes.

`MEM-REQ-107`: Implementations SHOULD report memory evaluation results separately for retrieval quality, policy safety, and task outcome quality.

## 12. Appendices

### 12.1 Memory Operation Error Codes

| Code | Meaning |
|:---|:---|
| `MEMORY_NOT_FOUND` | Requested memory identifier does not exist or is not visible |
| `MEMORY_ACCESS_DENIED` | Actor lacks permission for the operation |
| `MEMORY_POLICY_CONFLICT` | Requested operation conflicts with retention or privacy policy |
| `MEMORY_STALE_VERSION` | Update base version is no longer current |
| `MEMORY_UNSUPPORTED_TYPE` | Memory type is not supported by the service |
| `MEMORY_UNSUPPORTED_RETRIEVAL_MODE` | Requested retrieval mode is unavailable |
| `MEMORY_INDEX_STALE` | Search projection is behind the source of truth |
| `MEMORY_BACKEND_UNAVAILABLE` | Required backend is unavailable |
| `MEMORY_CONSOLIDATION_FAILED` | Transformation failed or was rejected by policy |

### 12.2 Example Retrieval Response

```json
{
  "operation": "memory.retrieve",
  "auditRef": "urn:aeo:audit:memory:ret-2026-07-10-001",
  "results": [
    {
      "memoryId": "urn:aeo:memory:team:aesp-0004:decision-17",
      "type": "episodic",
      "scope": "team",
      "state": "active",
      "excerpt": "The team rejected Redis-only memory because graph traversal is required for architecture decisions.",
      "rank": 1,
      "scores": {
        "semantic": 0.84,
        "temporal": 0.71,
        "combined": 0.80
      },
      "provenance": {
        "source": "session",
        "workUnitRef": "urn:aeo:workunit:aesp-0004"
      },
      "explanation": {
        "matchedModes": ["semantic", "temporal"],
        "policy": "allowed",
        "selectedBecause": "high semantic similarity and matching work unit"
      }
    }
  ]
}
```

### 12.3 Requirement Index

Requirements `MEM-REQ-001` through `MEM-REQ-111` define the normative surface of this draft. Future revisions SHOULD preserve identifiers and append new identifiers rather than renumbering existing requirements.

# References

[^1^]: Charles Packer, Sarah Wooders, Kevin Lin, Vivian Fang, Shishir G. Patil, Ion Stoica, and Joseph E. Gonzalez, "MemGPT: Towards LLMs as Operating Systems", arXiv, 2023, https://arxiv.org/abs/2310.08560
[^2^]: Letta Documentation, "Introduction to Stateful Agents", accessed 2026-07-10, https://docs.letta.com/guides/core-concepts/stateful-agents
[^3^]: LangChain Documentation, "Memory overview", accessed 2026-07-10, https://docs.langchain.com/oss/python/concepts/memory
[^4^]: Prateek Chhikara, Dev Khant, Saket Aryan, Taranjeet Singh, and Deshraj Yadav, "Mem0: Building Production-Ready AI Agents with Scalable Long-Term Memory", arXiv, 2025, https://arxiv.org/abs/2504.19413
[^5^]: Pinecone Documentation, "Hybrid search", accessed 2026-07-10, https://docs.pinecone.io/guides/search/hybrid-search
[^6^]: pgvector project, "Open-source vector similarity search for Postgres", accessed 2026-07-10, https://github.com/pgvector/pgvector
[^7^]: Nuno Preguiça, Carlos Baquero, and Marc Shapiro, "Conflict-free Replicated Data Types (CRDTs)", arXiv, 2018, https://arxiv.org/abs/1805.06358
[^8^]: Pinecone Documentation, "Filter by metadata", accessed 2026-07-10, https://docs.pinecone.io/guides/search/filter-by-metadata
[^9^]: Adyasha Maharana, Dong-Ho Lee, Sergey Tulyakov, Mohit Bansal, Francesco Barbieri, and Yuwei Fang, "Evaluating Very Long-Term Conversational Memory of LLM Agents", arXiv, 2024, https://arxiv.org/abs/2402.17753
[^10^]: Scott Bradner, "Key words for use in RFCs to Indicate Requirement Levels", RFC 2119, 1997, https://www.rfc-editor.org/rfc/rfc2119
[^11^]: NIST, "Security and Privacy Controls for Information Systems and Organizations", SP 800-53 Rev. 5, https://csrc.nist.gov/pubs/sp/800/53/r5/upd1/final
