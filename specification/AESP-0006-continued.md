# AESP-0006: Knowledge Graph, Continued

## 5. Query Semantics

Knowledge graphs are useful only when agents can ask precise, repeatable questions of them. AESP-0006 defines a query surface that supports graph traversal, pattern matching, semantic search, provenance filtering, temporal filtering, and explainable query results.

### 5.1 Query Language Support

Conforming implementations MAY expose SPARQL, Cypher, ISO GQL, GraphQL, SQL graph extensions, or a custom API. The choice of query language is vendor-neutral; the semantic obligations are not.

`KG-REQ-043`: A conforming implementation MUST support graph pattern queries over nodes, edges, types, and properties.

`KG-REQ-044`: A conforming implementation MUST support path queries with bounded path length. Unbounded path traversal MUST NOT be the default.

`KG-REQ-045`: Query APIs MUST declare the query language, supported language version, and any unsupported language features.

### 5.2 Traversal Semantics

Traversal queries walk the graph from one or more starting nodes through predicates, type constraints, and path limits.

`KG-REQ-046`: A traversal query MUST declare its starting node set, allowed predicates, direction (`outbound`, `inbound`, or `both`), maximum depth, and result projection.

`KG-REQ-047`: Traversal implementations MUST detect cycles and MUST NOT return infinite paths. When cycles are encountered, the response MUST indicate whether paths were truncated.

`KG-REQ-048`: Traversal ordering MUST be deterministic when a query declares an order. If no order is declared, implementations MAY return results in any order but SHOULD document the default.

### 5.3 Semantic Search

Semantic search combines symbolic graph constraints with vector similarity, lexical matching, or embedding-based retrieval.

`KG-REQ-049`: Semantic search MUST return both the matched graph entity and the retrieval evidence used to rank it.

`KG-REQ-050`: When embeddings are used, the embedding model identifier, embedding version, distance metric, and index timestamp MUST be available in query metadata.

`KG-REQ-051`: Semantic search results SHOULD be filterable by type, ontology version, provenance source, confidence score, and access-control scope.

### 5.4 Temporal Queries

Knowledge changes over time. Agents often need to ask what was believed at a specific time, what changed between two versions, or which conclusions were valid under an older ontology.

`KG-REQ-052`: A conforming implementation MUST support point-in-time graph reads for committed graph versions.

`KG-REQ-053`: A conforming implementation SHOULD support diff queries that report nodes, edges, and properties added, removed, or changed between two graph versions.

`KG-REQ-054`: Query results derived from historical graph versions MUST identify the graph version and ontology version used to answer the query.

### 5.5 Query Results and Explanations

Knowledge graph answers must be inspectable by agents and humans. A result that cannot explain its sources is unsuitable for governed engineering work.

`KG-REQ-055`: Query responses MUST include result bindings, graph entity IRIs, and the query execution status.

`KG-REQ-056`: Query responses SHOULD include an explanation object containing matched paths, source records, inference rules applied, and confidence values when applicable.

`KG-REQ-057`: Query APIs MUST distinguish between "no result", "query invalid", "access denied", and "query timed out" outcomes.

## 6. Construction and Extraction

Knowledge graphs are constructed from structured systems, semi-structured artifacts, and unstructured text. AESP-0006 defines ingestion semantics so agents can create graph facts without silently degrading provenance or confidence.

### 6.1 Ingestion Sources

Common AEO sources include source repositories, issue trackers, design documents, runbooks, deployment manifests, telemetry events, chat transcripts, and AESP-0004 memory records.

`KG-REQ-058`: Every ingested fact MUST record its source artifact, extraction method, ingestion time, and responsible agent or service.

`KG-REQ-059`: Ingestion pipelines MUST classify source trust level (`authoritative`, `derived`, `observed`, or `unverified`).

`KG-REQ-060`: Ingestion from mutable sources MUST preserve a content hash or version identifier so the extracted fact can be traced back to the source state.

### 6.2 Entity Extraction

Entity extraction identifies candidate graph nodes from text or structured records.

`KG-REQ-061`: Entity extraction outputs MUST include entity type, canonical label, source span or source field, confidence score, and candidate IRI.

`KG-REQ-062`: Automatically extracted entities below the configured confidence threshold MUST be stored as candidates, not committed canonical nodes.

`KG-REQ-063`: Human or agent review decisions on candidate entities MUST be recorded as provenance events.

### 6.3 Relationship Extraction

Relationship extraction identifies typed edges between entities.

`KG-REQ-064`: Relationship extraction outputs MUST include source entity, target entity, predicate, evidence, confidence score, and extraction method.

`KG-REQ-065`: A relationship MUST NOT be committed if either endpoint fails identity resolution, unless the relationship is explicitly stored as a candidate relation.

`KG-REQ-066`: Extracted relationships with temporal qualifiers SHOULD preserve the observed time interval, not only the ingestion timestamp.

### 6.4 Entity Resolution

Entity resolution determines whether two mentions or records refer to the same logical entity.

`KG-REQ-067`: Entity resolution rules MUST be declared and versioned. Silent ad hoc matching is non-conformant.

`KG-REQ-068`: Entity resolution decisions MUST preserve both the pre-merge identifiers and the canonical identifier.

`KG-REQ-069`: Implementations SHOULD support review queues for ambiguous entity resolution decisions.

### 6.5 Curation Workflow

Critical organizational knowledge should move through a controlled curation path.

`KG-REQ-070`: A graph MAY distinguish candidate, accepted, deprecated, and rejected facts.

`KG-REQ-071`: A fact promoted from candidate to accepted MUST record the reviewer, review time, and review rationale.

`KG-REQ-072`: Rejected facts MUST remain auditable unless retention policy requires deletion.

## 7. Reasoning and Inference

Reasoning derives additional facts from declared ontology rules, graph structure, and inference policies. AESP-0006 requires bounded, explainable reasoning suitable for production agent systems.

### 7.1 Reasoning Profiles

`KG-REQ-073`: A knowledge graph MUST declare its reasoning profile (`none`, `rdfs`, `owl-rl`, `rules`, or `custom`).

`KG-REQ-074`: Custom reasoning profiles MUST document supported rule types, termination guarantees, and unsupported ontology features.

`KG-REQ-075`: Reasoning MUST be bounded by configured time, memory, and expansion limits.

### 7.2 Materialized and Virtual Inference

Inferences may be materialized into the graph or computed at query time.

`KG-REQ-076`: A graph MUST declare whether inferred facts are materialized, virtual, or mixed.

`KG-REQ-077`: Materialized inferred facts MUST identify the source facts and rules that produced them.

`KG-REQ-078`: When source facts are removed or changed, affected materialized inferences MUST be invalidated or recomputed.

### 7.3 Rule Semantics

Rules express domain-specific inference beyond standard ontology reasoning.

`KG-REQ-079`: A rule MUST declare its name, version, antecedent pattern, consequent assertion, priority, and termination behavior.

`KG-REQ-080`: Conflicting rules MUST be resolved by declared conflict-resolution policy.

`KG-REQ-081`: Rule execution MUST be deterministic for a fixed graph version, ontology version, and rule set version.

### 7.4 Confidence and Contradiction

Knowledge graphs often contain uncertain or conflicting facts. AESP-0006 permits uncertainty but requires explicit representation.

`KG-REQ-082`: Facts MAY carry confidence scores, but confidence semantics MUST be declared by the graph profile.

`KG-REQ-083`: Contradictory facts MUST NOT be silently overwritten. Implementations MUST preserve contradiction evidence or apply a declared conflict policy.

`KG-REQ-084`: Query results based on uncertain or contradicted facts MUST expose uncertainty metadata to callers.

## 8. Integration with Memory Systems

AESP-0006 treats the knowledge graph as a structured semantic layer over AESP-0004 memory. The graph does not replace memory records; it indexes, connects, and reasons over them.

### 8.1 Memory Record Mapping

`KG-REQ-085`: Every graph fact derived from an AESP-0004 memory record MUST retain a link to the originating memory record.

`KG-REQ-086`: Semantic memory records MAY become graph nodes, graph edge evidence, or graph provenance records depending on their content and extraction profile.

`KG-REQ-087`: Deletion or forgetting of a source memory record MUST trigger the configured graph retention policy for derived facts.

### 8.2 Retrieval Composition

Agents SHOULD combine memory retrieval and graph querying when answering complex questions.

`KG-REQ-088`: A retrieval pipeline that combines vector search and graph traversal MUST expose both retrieval stages in its explanation.

`KG-REQ-089`: GraphRAG-style retrieval MUST ground generated answers in explicit graph entities, paths, or source memory records.

`KG-REQ-090`: A generated answer MUST NOT cite an inferred graph fact as if it were a directly observed source fact.

### 8.3 Access Control Alignment

Graph access must respect memory access policy.

`KG-REQ-091`: A graph fact derived from restricted memory MUST inherit access restrictions at least as strict as the source memory record.

`KG-REQ-092`: Query engines MUST enforce access control before returning graph entities, paths, explanations, or provenance records.

`KG-REQ-093`: Inference MUST NOT leak restricted information through derived public facts unless an explicit declassification policy permits it.

### 8.4 Lifecycle Synchronization

`KG-REQ-094`: Memory lifecycle events (`created`, `updated`, `archived`, `forgotten`) SHOULD produce corresponding graph maintenance events.

`KG-REQ-095`: Graph indexes derived from memory MUST declare their synchronization lag objective.

`KG-REQ-096`: If graph state is stale relative to memory state, query responses SHOULD disclose the latest synchronized memory event position.
