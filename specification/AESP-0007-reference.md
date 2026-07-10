# AESP-0007: Code Generation, Reference

## 9. Security and Policy

Code generation can introduce vulnerabilities, secrets, license violations, and supply-chain risk at machine speed. AESP-0007 therefore treats security and policy as intrinsic to the generation protocol.

### 9.1 Threat Model

Relevant threats include:

1. Prompt injection via untrusted context that causes unsafe code emission.
2. Secret leakage into generated files or logs.
3. Dependency confusion and malicious package introduction.
4. Privilege escalation through generated infrastructure or CI configuration.
5. Silent bypass of review gates.
6. Provenance forgery or audit gaps.
7. Path traversal outside allowed generation scopes.

`CG-REQ-155`: Conforming implementations MUST document their generation threat model or adopt the AESP-0007 baseline threats above.

`CG-REQ-156`: Untrusted context MUST be labeled as untrusted. Engines MUST apply injection-resistance controls appropriate to the engine type when untrusted context is present.

`CG-REQ-157`: Generated CI/CD, infrastructure-as-code, and permission-policy artifacts SHOULD require stricter review policy than application business logic by default.

### 9.2 Authorization

`CG-REQ-158`: Generation requests MUST be authorized against the requester's roles and capabilities from AESP-0001 and AESP-0002 where those specifications apply.

`CG-REQ-159`: Path scope enforcement MUST occur server-side in the generation service or engine boundary, not only in client UI.

`CG-REQ-160`: Agents MUST NOT be able to approve their own generation output when policy requires independent review, unless a documented break-glass procedure is used and audited.

### 9.3 Secrets and Sensitive Data

`CG-REQ-161`: Engines MUST NOT intentionally emit known secrets from context into artifacts. If a secret is required at runtime, generators SHOULD emit references to secret managers, not plaintext secrets.

`CG-REQ-162`: Logs, traces, and provenance exports MUST redact secret material while preserving non-sensitive references.

`CG-REQ-163`: Secret-scanning validators MUST run before artifacts are published to shared branches or artifact registries when those destinations are in scope.

### 9.4 Supply Chain

`CG-REQ-164`: Newly introduced dependencies SHOULD be constrained by allowlists, denylists, or advisory policies.

`CG-REQ-165`: When lockfiles are part of the repository contract, generation MUST update them consistently or fail validation.

`CG-REQ-166`: Implementations SHOULD attach or update SBOM information for generated components when organizational policy requires SBOMs [^4^][^5^].

### 9.5 Policy Packs

Policy packs group organization rules for reuse across projects.

`CG-REQ-167`: Policy packs MUST be versioned and referenced by generation requests or project configuration.

`CG-REQ-168`: Effective policy for a session MUST be computable and exportable: organization defaults, project overrides, and request overrides with precedence rules.

`CG-REQ-169`: Policy evaluation results MUST be part of the durable validation report.

### 9.6 Isolation and Side Effects

`CG-REQ-170`: Generation execution SHOULD run in an isolated environment with least privilege.

`CG-REQ-171`: Network access during generation MUST be denied by default for untrusted sessions and enabled only when explicitly allowed by policy.

`CG-REQ-172`: Shell execution and package installation during generation MUST be declared, sandboxed, and audited when permitted.

## 10. Implementation Guidelines

This chapter is non-normative unless a requirement explicitly binds behavior. It provides practical guidance for implementers.

### 10.1 Minimum Viable Implementation

A minimum viable AESP-0007 implementation can be built with:

1. A request/response API with session identifiers.
2. One engine (template or model).
3. Content hashing and basic provenance.
4. Path constraints and secret scanning.
5. A validation report object.
6. Artifact lifecycle states at least for `generated`, `approved`, and `superseded`.

`CG-REQ-173`: A Level 1 implementation MUST provide request contracts, session identity, artifact hashing, provenance, path constraints, and at least syntax or schema validation for supported artifact types.

### 10.2 Recommended Architecture

A common three-tier deployment is:

| Tier | Components |
|:---|:---|
| Control | Request API, policy engine, session orchestrator, review service |
| Generation | Template engine, model gateway, AST/patch tools |
| Evidence | Artifact store, provenance store, validation runners, audit log |

`CG-REQ-174`: Control-plane decisions (authorization, policy, review) MUST NOT be bypassable by direct calls to generation workers in conforming deployments.

`CG-REQ-175`: Workers SHOULD be stateless with respect to approval authority; only the control plane transitions artifacts to `approved`.

### 10.3 Toolchain Integration

Implementations commonly integrate:

- Language servers and compilers for type and syntax checks.
- Formatters and linters already adopted by the repository.
- Test runners in ephemeral sandboxes.
- Repository hosts for commit-based delivery.
- Workflow engines implementing AESP-0005.

`CG-REQ-176`: External tool versions used during validation MUST be recorded when they can change validation outcomes.

`CG-REQ-177`: Repository delivery adapters MUST preserve the association between artifact versions and commits.

### 10.4 Performance and Cost Controls

`CG-REQ-178`: Implementations SHOULD expose budgets for tokens, time, file count, and parallel sessions.

`CG-REQ-179`: Budget exhaustion MUST produce structured errors and MAY return partial results only under Section 4.7 rules.

### 10.5 Anti-Patterns

The following practices are non-conformant or strongly discouraged:

- Applying model output directly to main branches without validation or review policy.
- Omitting model/template versions from provenance.
- Treating chat transcripts as the system of record for generated code.
- Silent scope expansion beyond path allowlists.
- Auto-approving security findings.
- Regenerating approved artifacts without supersession lineage.
- Logging secrets present in prompts or context.
- Claiming reproducibility without pinned inputs.

## 11. Conformance and Testing

AESP-0007 defines three conformance levels.

### 11.1 Conformance Levels

| Level | Name | Scope |
|:---|:---|:---|
| L1 | Basic Generation | Request/session model, one engine mode, artifact hashing, provenance, path constraints, basic validation |
| L2 | Governed Generation | Multi-file sessions, full validation pipeline, lifecycle states, review workflows, workflow correlation |
| L3 | Deterministic Enterprise | Reproducible mode guarantees, SBOM/policy packs, advanced security isolation, exportable audit, multi-engine capability negotiation |

`CG-REQ-180`: A conforming implementation MUST declare its AESP-0007 conformance level.

`CG-REQ-181`: L1 implementations MUST satisfy `CG-REQ-001` through `CG-REQ-044`, `CG-REQ-069` through `CG-REQ-071`, `CG-REQ-085` through `CG-REQ-095`, `CG-REQ-099` through `CG-REQ-104`, `CG-REQ-123` through `CG-REQ-125`, `CG-REQ-155` through `CG-REQ-163`, and `CG-REQ-173`.

`CG-REQ-182`: L2 implementations MUST satisfy all L1 requirements plus multi-file generation, broader validation families, lifecycle transitions, review and approval, and workflow integration requirements.

`CG-REQ-183`: L3 implementations MUST satisfy all L2 requirements plus reproducible-mode guarantees, policy packs, supply-chain controls, isolation defaults, and enterprise audit export requirements.

### 11.2 Interoperability Expectations

`CG-REQ-184`: Independent implementations MUST be able to exchange generation request and response documents in JSON without proprietary mandatory fields, though extension fields MAY be included under namespaced keys.

`CG-REQ-185`: Artifact provenance documents MUST be interpretable by third-party audit tools given this specification and referenced AESP schemas.

`CG-REQ-186`: Conformance claims MUST list supported generation modes and languages.

### 11.3 Quality and Repeatability Metrics

Implementations SHOULD publish or internally track:

| Metric | Description |
|:---|:---|
| Validation pass rate | Share of sessions that pass required validators |
| Review rework rate | Share of sessions requiring revision |
| Secret incident rate | Secrets reaching shared branches per session volume |
| Repro hash match rate | Match rate for reproducible-mode replays |
| Mean time to approved artifact | Request to approval latency |
| Scope violation attempts | Blocked path or policy violations |

`CG-REQ-187`: Conformance test suites MUST include request validation tests, path constraint tests, provenance completeness tests, and lifecycle transition tests.

`CG-REQ-188`: Security conformance suites MUST include secret leakage tests, path traversal tests, and review-bypass tests.

`CG-REQ-189`: Reproducibility suites for L3 MUST replay pinned sessions and compare artifact content hashes.

### 11.4 Test Vectors

`CG-REQ-190`: Test vectors MUST cover template-driven, model-driven or hybrid (if supported), patch, incremental, partial, and regeneration flows for the modes an implementation claims.

`CG-REQ-191`: Negative tests MUST cover missing context, invalid schema, over-scope paths, validator failure, review rejection, and cancellation.

`CG-REQ-192`: Multi-file tests MUST verify manifest completeness and content hash integrity across all produced artifacts.

## 12. Appendices

### 12.1 Example Generation Request (Template Mode)

```yaml
id: urn:aeo:codegen:request:template-example-1
requester: urn:aeo:agent:scaffold-bot
mode: template
targets:
  - path: services/billing/handler.go
    language: go
    kind: source
  - path: services/billing/handler_test.go
    language: go
    kind: test
inputs:
  templateRef: urn:aeo:template:go-http-handler:2.1.0
  variables:
    package: billing
    route: /v1/invoices
constraints:
  pathsAllowed:
    - services/billing/**
  languagesAllowed:
    - go
config:
  determinism: reproducible
validators:
  - syntax
  - lint
  - tests
reviewPolicy: automated-only
```

### 12.2 Example Provenance Record

```json
{
  "id": "urn:aeo:provenance:artifact:billing-handler-v1",
  "artifactId": "urn:aeo:artifact:services/billing/handler.go:v1",
  "requestId": "urn:aeo:codegen:request:template-example-1",
  "sessionId": "urn:aeo:codegen:session:template-example-1",
  "producer": "urn:aeo:agent:scaffold-bot",
  "engine": {
    "id": "template-engine",
    "version": "1.4.2"
  },
  "templates": [
    "urn:aeo:template:go-http-handler:2.1.0"
  ],
  "contextHashes": {
    "urn:aeo:context:billing-openapi": "sha256:example-context"
  },
  "contentHash": "sha256:example-artifact",
  "createdAt": "2026-07-10T15:30:00Z"
}
```

### 12.3 Example Review Decision

```json
{
  "id": "urn:aeo:review:decision:9001",
  "sessionId": "urn:aeo:codegen:session:2026-07-10-42",
  "decision": "request_revision",
  "actor": "urn:aeo:human:alice",
  "at": "2026-07-10T16:00:00Z",
  "comment": "Add idempotency key handling before approval.",
  "subjects": [
    "urn:aeo:artifact:src/payments/retry.ts:v3"
  ]
}
```

### 12.4 Error Code Registry (Baseline)

| Code | Stage | Meaning |
|:---|:---|:---|
| `CG-ERR-REQUEST-INVALID` | request validation | Request fails schema or required fields |
| `CG-ERR-AUTHZ` | authorization | Requester not permitted |
| `CG-ERR-SCOPE` | constraints | Target outside allowlist or in denylist |
| `CG-ERR-CONTEXT` | context resolution | Required context missing or unreadable |
| `CG-ERR-ENGINE` | generation | Engine failure or unsupported capability |
| `CG-ERR-VALIDATION` | validation | Blocking validator failed |
| `CG-ERR-REVIEW-REJECT` | review | Reviewer rejected artifacts |
| `CG-ERR-TIMEOUT` | execution | Session exceeded time budget |
| `CG-ERR-CANCELLED` | execution | Session cancelled by authorized actor |
| `CG-ERR-PATCH-CONFLICT` | patch apply | Patch does not apply to base revision |

### 12.5 Requirement Index

Requirements `CG-REQ-001` through `CG-REQ-192` define the normative surface of this draft. Future revisions SHOULD preserve identifiers and append new identifiers rather than renumbering existing requirements.

| Range | Domain |
|:---|:---|
| `CG-REQ-001` to `CG-REQ-020` | Generation Model Architecture |
| `CG-REQ-021` to `CG-REQ-044` | Inputs and Constraints |
| `CG-REQ-045` to `CG-REQ-068` | Generation Modes |
| `CG-REQ-069` to `CG-REQ-098` | Generation Execution |
| `CG-REQ-099` to `CG-REQ-122` | Validation |
| `CG-REQ-123` to `CG-REQ-136` | Artifact Lifecycle |
| `CG-REQ-137` to `CG-REQ-154` | Review and Approval |
| `CG-REQ-155` to `CG-REQ-172` | Security and Policy |
| `CG-REQ-173` to `CG-REQ-192` | Implementation and Conformance |

# References

[^1^]: Cookiecutter, "Project documentation", accessed 2026-07-10, https://cookiecutter.readthedocs.io/

[^2^]: GitHub, "GitHub Copilot documentation", accessed 2026-07-10, https://docs.github.com/en/copilot

[^3^]: tree-sitter, "Introduction", accessed 2026-07-10, https://tree-sitter.github.io/tree-sitter/

[^4^]: NTIA, "The Minimum Elements For a Software Bill of Materials (SBOM)", accessed 2026-07-10, https://www.ntia.gov/report/2021/minimum-elements-software-bill-materials-sbom

[^5^]: OpenSSF, "Supply chain security best practices", accessed 2026-07-10, https://openssf.org/

[^6^]: Bradner, S., "Key words for use in RFCs to Indicate Requirement Levels", BCP 14, RFC 2119, March 1997, https://www.rfc-editor.org/rfc/rfc2119

[^7^]: OpenAPI Initiative, "OpenAPI Specification v3.1.0", accessed 2026-07-10, https://spec.openapis.org/oas/v3.1.0

[^8^]: ECMA International, "ECMA-404 The JSON Data Interchange Syntax", accessed 2026-07-10, https://www.ecma-international.org/publications-and-standards/standards/ecma-404/

[^9^]: OWASP, "Source Code Analysis Tools", accessed 2026-07-10, https://owasp.org/www-community/Source_Code_Analysis_Tools

[^10^]: SLSA, "Supply-chain Levels for Software Artifacts", accessed 2026-07-10, https://slsa.dev/
