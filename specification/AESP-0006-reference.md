# AESP-0006: Knowledge Graph, Reference

## 9. Distributed Knowledge Graphs

Autonomous Engineering Organizations may operate across teams, regions, vendors, and security domains. AESP-0006 therefore defines federation and replication semantics for knowledge graphs that cannot be held in a single centralized store.

### 9.1 Federation Model

Federation allows multiple graph authorities to answer queries without surrendering ownership of their data.

`KG-REQ-097`: A federated graph MUST declare each participating graph authority, its namespace, supported query capabilities, and trust relationship.

`KG-REQ-098`: Federated query planning MUST respect authority boundaries and access-control rules.

`KG-REQ-099`: Federated query results MUST identify which authority supplied each binding, path, or inferred fact.

### 9.2 Partitioning

Graphs MAY be partitioned by namespace, entity type, tenant, project, region, or sensitivity level.

`KG-REQ-100`: Partitioning rules MUST be deterministic and documented.

`KG-REQ-101`: Cross-partition edges MUST preserve source partition, target partition, predicate, and consistency expectation.

`KG-REQ-102`: Implementations SHOULD support partition-local queries that do not require global coordination.

### 9.3 Replication and Consistency

`KG-REQ-103`: Replicated graph partitions MUST declare their consistency model (`strong`, `causal`, `eventual`, or `read-only snapshot`).

`KG-REQ-104`: Eventually consistent replicas MUST expose replica version, replication lag, and conflict status in query metadata.

`KG-REQ-105`: Conflicting updates to the same graph entity MUST be resolved using a declared merge policy or escalated for review.

### 9.4 Cross-Organization Exchange

Organizations may exchange subgraphs using signed graph packages.

`KG-REQ-106`: A graph export package MUST include graph data, ontology version, provenance metadata, access policy, and content hash.

`KG-REQ-107`: Graph import MUST validate ontology compatibility before accepting imported facts.

`KG-REQ-108`: Imported facts MUST retain their external provenance and MUST NOT be relabeled as locally observed facts.

## 10. Implementation Guidelines

This chapter is non-normative unless explicitly referenced by a requirement. It describes practical implementation patterns for AESP-0006.

### 10.1 Minimum Viable Implementation

A minimum viable AESP-0006 implementation can be built with:

1. A persistent graph store or relational store with graph tables.
2. JSON-LD or RDF/Turtle import and export.
3. An ontology registry with SHACL validation.
4. A query API supporting bounded traversal and typed pattern matching.
5. Provenance records for every accepted fact.
6. Integration hooks for AESP-0004 memory lifecycle events.

`KG-REQ-109`: A Level 1 implementation MUST provide typed nodes, typed edges, schema validation, provenance, and bounded traversal queries.

### 10.2 Storage Backends

Property graph databases are natural for operational traversal and developer ergonomics. RDF triple stores are natural for ontology alignment, linked-data exchange, and standards-based reasoning. Hybrid systems may expose both views over a shared fact store.

`KG-REQ-110`: Implementations that expose both property graph and RDF views MUST define a lossless or explicitly lossy mapping between the two models.

`KG-REQ-111`: Backend-specific identifiers MUST NOT replace canonical AESP IRIs in external APIs.

### 10.3 Indexing

Graph workloads commonly require indexes on IRI, type, predicate, labels, full-text fields, vector embeddings, and temporal validity.

`KG-REQ-112`: Implementations SHOULD maintain indexes sufficient to enforce type lookup, direct-neighbor traversal, and provenance lookup without full graph scans.

`KG-REQ-113`: Index rebuilds MUST preserve query correctness. During rebuild, the system MUST either serve from the previous valid index or disclose degraded query status.

### 10.4 Operational Controls

`KG-REQ-114`: Implementations MUST provide backup and restore procedures for graph data, ontology registry, rule sets, and provenance records.

`KG-REQ-115`: Implementations SHOULD expose metrics for graph size, query latency, inference latency, validation failures, extraction confidence, and replication lag.

`KG-REQ-116`: Administrative operations that change ontology, rule sets, partition policy, or access policy MUST be audited.

### 10.5 Anti-Patterns

The following practices are non-conformant or strongly discouraged:

- Using free-form edge labels without ontology registration.
- Merging entities silently during ingestion.
- Treating inferred facts as observed facts.
- Returning graph answers without provenance.
- Allowing unbounded graph traversal from agent prompts.
- Embedding restricted facts into public graph indexes.

## 11. Conformance and Testing

AESP-0006 defines three conformance levels.

### 11.1 Conformance Levels

| Level | Name | Scope |
|:---|:---|:---|
| L1 | Basic Graph | Typed nodes and edges, schema validation, provenance, bounded query |
| L2 | Governed Graph | Curation workflow, temporal reads, memory integration, access control |
| L3 | Reasoned Federation | Bounded reasoning, distributed graph support, explainable inference |

`KG-REQ-117`: A conforming implementation MUST declare its AESP-0006 conformance level.

`KG-REQ-118`: L1 implementations MUST satisfy `KG-REQ-001` through `KG-REQ-057` and `KG-REQ-109` through `KG-REQ-113`.

`KG-REQ-119`: L2 implementations MUST satisfy all L1 requirements plus construction, memory integration, lifecycle synchronization, and access-control requirements.

`KG-REQ-120`: L3 implementations MUST satisfy all L2 requirements plus reasoning and distributed graph requirements.

### 11.2 Test Vectors

`KG-REQ-121`: Conformance suites MUST include ontology validation tests, graph mutation tests, query result tests, provenance tests, and access-control tests.

`KG-REQ-122`: Reasoning conformance suites MUST include positive inference tests, negative inference tests, conflict tests, and termination tests.

`KG-REQ-123`: Federation conformance suites MUST include cross-authority query tests, partial failure tests, and provenance preservation tests.

### 11.3 Security and Privacy Testing

`KG-REQ-124`: Implementations MUST test that restricted source facts cannot be recovered through public queries, inferred facts, explanations, embeddings, or aggregate counts.

`KG-REQ-125`: Implementations SHOULD run differential access tests that compare query results across roles and verify that policy boundaries are enforced.

`KG-REQ-126`: Forgetting tests MUST verify that deleted memory records are removed from graph facts, indexes, materialized inferences, and exported graph packages according to policy.

## 12. Appendices

### 12.1 Example Graph Package Manifest

```yaml
graphPackage:
  id: urn:aeo:graph-package:example:2026-07-10
  graph: urn:aeo:graph:platform-knowledge
  ontology: urn:aeo:ontology:baseline:1.0.0
  exportedAt: "2026-07-10T12:00:00Z"
  exporter: urn:aeo:agent:knowledge-curator
  hash: sha256:example
  includes:
    nodes: 1250
    edges: 4300
    provenanceRecords: 4300
  accessPolicy: urn:aeo:policy:internal-knowledge
```

### 12.2 Example Query Response

```json
{
  "status": "ok",
  "graphVersion": "42",
  "ontologyVersion": "1.0.0",
  "results": [
    {
      "entity": "urn:aeo:service:payments-api",
      "type": "aeo:Service",
      "label": "payments-api",
      "evidence": [
        "urn:aeo:memory:semantic:service-catalog-2026-07-10"
      ]
    }
  ],
  "explanation": {
    "matchedPaths": [
      [
        "urn:aeo:team:payments",
        "aeo:owns",
        "urn:aeo:service:payments-api"
      ]
    ],
    "inferenceRulesApplied": []
  }
}
```

### 12.3 Requirement Index

Requirements `KG-REQ-001` through `KG-REQ-126` define the normative surface of this draft. Future revisions SHOULD preserve identifiers and append new identifiers rather than renumbering existing requirements.

| Range | Domain |
|:---|:---|
| `KG-REQ-001` to `KG-REQ-018` | Knowledge Graph Model Architecture |
| `KG-REQ-019` to `KG-REQ-031` | Entity and Relationship Modeling |
| `KG-REQ-032` to `KG-REQ-042` | Ontology and Schema |
| `KG-REQ-043` to `KG-REQ-057` | Query Semantics |
| `KG-REQ-058` to `KG-REQ-072` | Construction and Extraction |
| `KG-REQ-073` to `KG-REQ-084` | Reasoning and Inference |
| `KG-REQ-085` to `KG-REQ-096` | Memory Integration |
| `KG-REQ-097` to `KG-REQ-108` | Distributed Knowledge Graphs |
| `KG-REQ-109` to `KG-REQ-126` | Implementation and Conformance |

# References

[^1^]: Neo4j, "Cypher Manual", accessed 2026-07-10, https://neo4j.com/docs/cypher-manual/

[^2^]: W3C, "SPARQL 1.1 Query Language", accessed 2026-07-10, https://www.w3.org/TR/sparql11-query/

[^3^]: W3C, "RDF 1.1 Concepts and Abstract Syntax", accessed 2026-07-10, https://www.w3.org/TR/rdf11-concepts/

[^4^]: W3C, "OWL 2 Web Ontology Language Document Overview", accessed 2026-07-10, https://www.w3.org/TR/owl2-overview/

[^5^]: W3C, "Shapes Constraint Language (SHACL)", accessed 2026-07-10, https://www.w3.org/TR/shacl/

[^6^]: W3C, "PROV-O: The PROV Ontology", accessed 2026-07-10, https://www.w3.org/TR/prov-o/

[^7^]: ISO/IEC, "Information technology - Database languages GQL", ISO/IEC 39075, 2024.

[^8^]: Microsoft Research, "GraphRAG: Graph-based Retrieval-Augmented Generation", accessed 2026-07-10, https://www.microsoft.com/en-us/research/project/graphrag/

[^9^]: W3C, "JSON-LD 1.1", accessed 2026-07-10, https://www.w3.org/TR/json-ld11/

[^10^]: W3C, "RDF Schema 1.1", accessed 2026-07-10, https://www.w3.org/TR/rdf-schema/
