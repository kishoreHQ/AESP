# AESP-0008: Documentation Generator, Reference

## 9. Security and Policy

Documentation can leak secrets, expose internal architecture, and create compliance violations. AESP-0008 treats security as intrinsic to documentation pipelines.

### 9.1 Threat Model

Relevant threats include:

1. Secret or PII leakage into published docs.
2. Over-sharing restricted source content into public audiences.
3. Prompt injection via untrusted source text into model-driven docs.
4. Publish gate bypass.
5. Provenance forgery or silent staleness.
6. Path traversal into protected documentation trees.
7. Malicious links or supply-chain docs packages.

`DOC-REQ-134`: Conforming implementations MUST document their documentation threat model or adopt the AESP-0008 baseline threats above.

`DOC-REQ-135`: Untrusted sources MUST be labeled untrusted. Model-driven generators MUST apply injection-resistance controls when untrusted sources are present.

`DOC-REQ-136`: Customer-facing and public publish targets SHOULD require stricter review and redaction policies than internal targets.

### 9.2 Authorization

`DOC-REQ-137`: Documentation requests MUST be authorized against requester roles and capabilities.

`DOC-REQ-138`: Path scope enforcement for write targets MUST occur server-side.

`DOC-REQ-139`: Agents MUST NOT approve and publish their own high-sensitivity documentation when policy requires independent review, unless a documented break-glass procedure is used and audited.

### 9.3 Secrets and Sensitive Data

`DOC-REQ-140`: Generators MUST NOT intentionally emit known secrets from sources into documents. Secret references (not values) SHOULD be used when configuration examples are required.

`DOC-REQ-141`: Secret scanning MUST run before publish to shared or external targets when those destinations are in scope.

`DOC-REQ-142`: Logs, traces, and provenance exports MUST redact secret material while preserving non-sensitive references.

### 9.4 Audience Isolation

`DOC-REQ-143`: Audience-specific builds MUST enforce redaction and inclusion rules before publish.

`DOC-REQ-144`: Cross-audience contamination (internal content appearing in external docs) MUST be treated as a blocking policy failure when detected.

`DOC-REQ-145`: Agent-consumable documentation packages MAY include extra machine-readable metadata but MUST still respect the same access controls as human docs derived from the same sources.

### 9.5 Policy Packs

`DOC-REQ-146`: Policy packs MUST be versioned and referenced by documentation requests or project configuration.

`DOC-REQ-147`: Effective policy for a session MUST be computable and exportable (organization defaults, project overrides, request overrides).

`DOC-REQ-148`: Policy evaluation results MUST be part of the durable validation report.

### 9.6 Isolation of Generation Workloads

`DOC-REQ-149`: Documentation generation SHOULD run with least privilege and limited network access by default.

`DOC-REQ-150`: Fetching remote sources during generation MUST be declared and allowed by policy.

## 10. Implementation Guidelines

This chapter is non-normative unless a requirement explicitly binds behavior.

### 10.1 Minimum Viable Implementation

A minimum viable AESP-0008 implementation can be built with:

1. A request/response API with session identifiers.
2. One generator mode (schema-to-docs or template).
3. Source pinning by content hash.
4. Content hashing and basic provenance.
5. Structure and link validation.
6. Document states for `generated`, `published`, `stale`, and `superseded`.

`DOC-REQ-151`: A Level 1 implementation MUST provide request contracts, session identity, source pins, document hashing, provenance, path constraints, and at least structure or schema-linked validation for supported document kinds.

### 10.2 Recommended Architecture

| Tier | Components |
|:---|:---|
| Control | Request API, policy engine, session orchestrator, review/publish service |
| Generation | Schema renderers, template engine, optional model gateway, diff tools |
| Evidence | Document store, provenance store, drift detector, audit log |
| Delivery | VCS adapter, portal adapter, package publisher |

`DOC-REQ-152`: Control-plane decisions (authorization, policy, review, publish) MUST NOT be bypassable by direct calls to generation workers in conforming deployments.

`DOC-REQ-153`: Workers SHOULD be stateless with respect to publish authority; only the control plane transitions documents to `published`.

### 10.3 Toolchain Integration

Common integrations include OpenAPI/AsyncAPI renderers, MkDocs/Docusaurus/Sphinx, language doc extractors (TypeDoc, godoc, Javadoc), link checkers, secret scanners, and AESP-0005 workflows.

`DOC-REQ-154`: External tool versions that can change documentation outcomes MUST be recorded.

`DOC-REQ-155`: Portal and VCS adapters MUST preserve association between document versions and external locations.

### 10.4 Agent OS Placement

In an Agent OS built on AESP, AESP-0008 occupies the **explanation and contract surface** of the infrastructure layer:

```text
Operations     0011–0015  observability, remediation, security, HITL, integration
Infrastructure 0006–0010  knowledge, codegen, docs, deploy, test
Foundation     0000–0005  governance, model, roles, comms, memory, workflow
```

Documentation generation consumes foundation services (identity, messaging, workflows, memory) and infrastructure peers (knowledge graph facts, generated code/schemas) to produce human- and agent-readable system truth.

`DOC-REQ-156`: Implementations SHOULD expose documentation packages in a form agents can retrieve as AESP-0001 Resources with stable IRIs.

### 10.5 Anti-Patterns

The following practices are non-conformant or strongly discouraged:

- Publishing docs without source pins for contract/API content.
- Treating chat transcripts as the system of record for operator docs.
- Silent overwrite of manual-authoritative sections.
- Leaving living docs labeled current after known drift.
- Auto-publishing security-sensitive architecture docs.
- Omitting generator/template/model versions from provenance.
- Mixing internal secrets into external audience builds.

## 11. Conformance and Testing

### 11.1 Conformance Levels

| Level | Name | Scope |
|:---|:---|:---|
| L1 | Basic Docs | Request/session model, one generation mode, source pins, hashing, provenance, basic validation, publish or export |
| L2 | Governed Docs | Multi-document sets, review workflows, lifecycle states, workflow correlation, link/freshness validation |
| L3 | Living Enterprise | Living sync policies, drift detection, audience isolation, policy packs, exportable audit, reproducible mode |

`DOC-REQ-157`: A conforming implementation MUST declare its AESP-0008 conformance level.

`DOC-REQ-158`: L1 implementations MUST satisfy `DOC-REQ-001` through `DOC-REQ-041`, `DOC-REQ-061` through `DOC-REQ-063`, `DOC-REQ-076` through `DOC-REQ-080`, `DOC-REQ-098` through `DOC-REQ-100`, `DOC-REQ-124`, `DOC-REQ-129`, `DOC-REQ-134` through `DOC-REQ-142`, and `DOC-REQ-151`.

`DOC-REQ-159`: L2 implementations MUST satisfy all L1 requirements plus multi-document sets, broader validation, review/publish workflows, and lifecycle transitions.

`DOC-REQ-160`: L3 implementations MUST satisfy all L2 requirements plus living documentation, drift detection, audience isolation, policy packs, and enterprise audit export.

### 11.2 Interoperability Expectations

`DOC-REQ-161`: Independent implementations MUST be able to exchange documentation request and response documents in JSON without proprietary mandatory fields; extensions MAY use namespaced keys.

`DOC-REQ-162`: Provenance and publish receipts MUST be interpretable by third-party audit tools given this specification.

`DOC-REQ-163`: Conformance claims MUST list supported modes, source kinds, and output formats.

### 11.3 Quality Metrics

Implementations SHOULD track:

| Metric | Description |
|:---|:---|
| Drift rate | Share of living doc sets with open drift |
| Freshness SLA | Time from source change to regenerate or flag |
| Link health | Broken internal/external link rate |
| Review rework rate | Sessions requiring revision |
| Secret incident rate | Secrets reaching publish targets |
| Repro hash match rate | Match rate for reproducible-mode replays |

`DOC-REQ-164`: Conformance suites MUST include request validation, source pin, path constraint, provenance completeness, and lifecycle transition tests.

`DOC-REQ-165`: Security suites MUST include secret leakage, audience isolation, and publish-bypass tests.

`DOC-REQ-166`: Living-documentation suites for L3 MUST include source-change → drift → regenerate flows.

### 11.4 Test Vectors

`DOC-REQ-167`: Test vectors MUST cover each generation mode an implementation claims.

`DOC-REQ-168`: Negative tests MUST cover missing sources, over-scope paths, validator failure, review rejection, publish failure, and cancellation.

`DOC-REQ-169`: Multi-document tests MUST verify manifest completeness and content hash integrity.

## 12. Appendices

### 12.1 Example Living Documentation Policy

```yaml
documentSet: urn:aeo:docs:set:payments-api
syncPolicy:
  profile: living
  triggers:
    - on-schema-change
    - scheduled: "0 */6 * * *"
  onSourceChange: regenerate
  maxStaleness: P1D
  onFailure: mark-stale-and-escalate
  escalateTo: urn:aeo:role:api-docs-owner
publishPolicy: review-then-publish
audiences:
  - developer
  - agent
```

### 12.2 Example Provenance Record

```json
{
  "id": "urn:aeo:provenance:doc:payments-api-ref-v12",
  "documentId": "urn:aeo:doc:docs/api/payments/index.md:v12",
  "requestId": "urn:aeo:docs:request:payments-api-ref-42",
  "sessionId": "urn:aeo:docs:session:payments-api-ref-42",
  "producer": "urn:aeo:agent:doc-curator",
  "engine": {
    "id": "schema-docs-engine",
    "version": "2.1.0"
  },
  "sources": [
    {
      "id": "urn:aeo:source:openapi:payments:3.1.0",
      "contentHash": "sha256:example-openapi"
    }
  ],
  "templates": [
    "urn:aeo:template:api-ref-md:1.4.0"
  ],
  "contentHash": "sha256:example-doc",
  "createdAt": "2026-07-10T18:00:00Z"
}
```

### 12.3 Example Drift Report

```json
{
  "documentSet": "urn:aeo:docs:set:payments-api",
  "detectedAt": "2026-07-10T19:00:00Z",
  "findings": [
    {
      "documentId": "urn:aeo:doc:docs/api/payments/index.md:v12",
      "sourceId": "urn:aeo:source:openapi:payments:3.1.0",
      "driftType": "content-hash-mismatch",
      "severity": "blocking",
      "recommendedAction": "regenerate"
    }
  ]
}
```

### 12.4 Error Code Registry (Baseline)

| Code | Stage | Meaning |
|:---|:---|:---|
| `DOC-ERR-REQUEST-INVALID` | request validation | Request fails schema or required fields |
| `DOC-ERR-AUTHZ` | authorization | Requester not permitted |
| `DOC-ERR-SOURCE` | source resolution | Required source missing or unreadable |
| `DOC-ERR-SCOPE` | constraints | Target outside allowlist |
| `DOC-ERR-GENERATE` | generation | Generator failure or unsupported mode |
| `DOC-ERR-VALIDATION` | validation | Blocking validator failed |
| `DOC-ERR-DRIFT` | synchronization | Blocking drift under living policy |
| `DOC-ERR-REVIEW-REJECT` | review | Reviewer rejected documents |
| `DOC-ERR-PUBLISH` | publish | Publish target failure |
| `DOC-ERR-TIMEOUT` | execution | Session exceeded time budget |
| `DOC-ERR-CANCELLED` | execution | Session cancelled |

### 12.5 Requirement Index

Requirements `DOC-REQ-001` through `DOC-REQ-169` define the normative surface of this draft. Future revisions SHOULD preserve identifiers and append new identifiers rather than renumbering existing requirements.

| Range | Domain |
|:---|:---|
| `DOC-REQ-001` to `DOC-REQ-020` | Documentation Model Architecture |
| `DOC-REQ-021` to `DOC-REQ-041` | Sources and Inputs |
| `DOC-REQ-042` to `DOC-REQ-060` | Generation Modes |
| `DOC-REQ-061` to `DOC-REQ-083` | Pipeline Execution |
| `DOC-REQ-084` to `DOC-REQ-097` | Synchronization and Drift |
| `DOC-REQ-098` to `DOC-REQ-111` | Document Lifecycle |
| `DOC-REQ-112` to `DOC-REQ-133` | Review, Publishing, Validation, Audit |
| `DOC-REQ-134` to `DOC-REQ-150` | Security and Policy |
| `DOC-REQ-151` to `DOC-REQ-169` | Implementation and Conformance |

# References

[^1^]: OpenAPI Initiative, "OpenAPI Specification", accessed 2026-07-10, https://www.openapis.org/

[^2^]: MkDocs, "MkDocs documentation", accessed 2026-07-10, https://www.mkdocs.org/

[^3^]: Protocol Buffers, "Language Guide", accessed 2026-07-10, https://protobuf.dev/

[^4^]: Quinn, M. et al., "Architecture Decision Records (ADRs)", accessed 2026-07-10, https://adr.github.io/

[^5^]: Fowler, M., "Living Documentation" (related practices via contract testing and docs-as-code), accessed 2026-07-10, https://martinfowler.com/

[^6^]: Bradner, S., "Key words for use in RFCs to Indicate Requirement Levels", BCP 14, RFC 2119, March 1997, https://www.rfc-editor.org/rfc/rfc2119

[^7^]: AsyncAPI Initiative, "AsyncAPI Specification", accessed 2026-07-10, https://www.asyncapi.com/

[^8^]: Docusaurus, "Documentation", accessed 2026-07-10, https://docusaurus.io/

[^9^]: Backstage, "TechDocs", accessed 2026-07-10, https://backstage.io/docs/features/techdocs/

[^10^]: OWASP, "Secrets Management Cheat Sheet", accessed 2026-07-10, https://cheatsheetseries.owasp.org/cheatsheets/Secrets_Management_Cheat_Sheet.html
