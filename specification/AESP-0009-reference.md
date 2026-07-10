# AESP-0009: Deployment Automation, Reference

## 9. Security and Policy

Deployment is a privileged operation. AESP-0009 treats authorization, supply chain integrity, and least privilege as intrinsic.

### 9.1 Threat Model

Relevant threats include:

1. Unauthorized production deploys.
2. Artifact substitution / digest mismatch.
3. Compromised CI signing keys.
4. Privilege escalation via deploy-time config.
5. Skip of health gates or approvals.
6. Rollback disablement without justification.
7. Credential leakage in deploy logs.
8. Freeze-window bypass without audit.

`DEP-REQ-116`: Conforming implementations MUST document their deployment threat model or adopt the AESP-0009 baseline threats above.

`DEP-REQ-117`: Production deploy authority MUST be separable from build authority where organizational policy requires two-person or two-system control.

### 9.2 Authorization

`DEP-REQ-118`: Deployment requests MUST be authorized against requester roles and environment policies.

`DEP-REQ-119`: Approval decisions MUST be authenticated and MUST NOT be forgeable by the deploying agent alone when independent approval is required.

`DEP-REQ-120`: Target-level permissions MUST be enforced server-side by the deployment control plane.

### 9.3 Supply Chain Controls

`DEP-REQ-121`: Production environments SHOULD require signed artifacts and provenance attestations (for example SLSA-aligned) when organizational policy enables supply-chain enforcement [^6^].

`DEP-REQ-122`: Admission MUST verify that the digest being deployed matches the approved request digest.

`DEP-REQ-123`: SBOM presence and license/policy checks MAY be required as prechecks for production.

### 9.4 Secrets and Config Security

`DEP-REQ-124`: Deploy-time secret injection MUST use secret managers or sealed references, not plaintext request fields.

`DEP-REQ-125`: Logs and provenance MUST redact secrets and sensitive environment variables.

`DEP-REQ-126`: Config changes that grant new network or IAM privileges SHOULD require elevated review.

### 9.5 Policy Packs

`DEP-REQ-127`: Policy packs MUST be versioned and referenced by environment or request.

`DEP-REQ-128`: Effective policy for a session MUST be computable and exportable.

`DEP-REQ-129`: Policy evaluation results MUST be part of durable session evidence.

### 9.6 Isolation and Blast Radius

`DEP-REQ-130`: Controllers SHOULD default to least privilege against cloud APIs.

`DEP-REQ-131`: Production canary weight increases MUST respect configured maximum step size.

`DEP-REQ-132`: Emergency broad deploys (all regions immediately) MUST be explicit high-risk operations with enhanced audit.

## 10. Implementation Guidelines

This chapter is non-normative unless a requirement explicitly binds behavior.

### 10.1 Minimum Viable Implementation

A minimum viable AESP-0009 implementation can be built with:

1. Request/response API with session identifiers.
2. One strategy (rolling or recreate).
3. Immutable artifact digests.
4. Environment authorization checks.
5. Basic health gate (readiness or smoke).
6. Rollback to previous digest.
7. Provenance record persistence.

`DEP-REQ-133`: A Level 1 implementation MUST provide request contracts, session identity, artifact digest enforcement for production, at least one strategy, basic gate or smoke verification, rollback or documented none-with-justification, and provenance.

### 10.2 Recommended Architecture

| Tier | Components |
|:---|:---|
| Control | Request API, policy/approval, freeze calendar, session orchestrator |
| Delivery | Strategy controller, traffic manager, infrastructure adapters |
| Evidence | Provenance store, gate results, audit log |
| Observe | Metrics/log/trace queries for gates (often via future AESP-0011) |

`DEP-REQ-134`: Control-plane decisions (authorization, approval, freeze) MUST NOT be bypassable by direct adapter calls in conforming deployments.

`DEP-REQ-135`: Adapters SHOULD be credential-scoped per environment.

### 10.3 GitOps Alignment

GitOps can implement AESP-0009 by treating desired state commits as deployment intents, provided session identity, gates, and approvals are still explicit.

`DEP-REQ-136`: GitOps implementations MUST map each production sync that changes desired state to a deployment session or equivalent auditable record.

`DEP-REQ-137`: Auto-sync without gates is insufficient for L2 progressive delivery claims.

### 10.4 Agent OS Placement

In an Agent OS built on AESP, AESP-0009 is the **ship surface** of the infrastructure layer:

```text
Operations     0011–0015  observe, remediate, secure, HITL, integrate
Infrastructure 0006–0010  know, generate code, document, deploy, test
Foundation     0000–0005  govern, model, authorize, communicate, remember, orchestrate
```

Deploy agents consume workflow (0005), artifacts (0007), optional docs (0008), and emit evidence for observability (0011) and remediation (0012).

`DEP-REQ-138`: Implementations SHOULD expose deployment sessions as AESP-0001 Resources with stable IRIs for cross-agent query.

### 10.5 Anti-Patterns

The following practices are non-conformant or strongly discouraged:

- Deploying `:latest` without digest resolution.
- Skipping canary gates because “it worked in staging.”
- Using the same credentials for staging and production deploys.
- Manual production kubectl/apply with no session record.
- Disabling rollback to “save time.”
- Treating CI green as a production health gate substitute without runtime signals.
- Silent freeze bypass.

## 11. Conformance and Testing

### 11.1 Conformance Levels

| Level | Name | Scope |
|:---|:---|:---|
| L1 | Basic Deploy | Request/session, digest-pinned artifacts, one strategy, smoke/readiness check, rollback or justified none, provenance |
| L2 | Governed Deploy | Approvals, multi-target, progressive strategy (canary or blue/green), health gates, freeze windows, workflow correlation |
| L3 | Enterprise Delivery | Promotion chains, multi-region policies, automated canary analysis, supply-chain admission, exportable audit |

`DEP-REQ-139`: A conforming implementation MUST declare its AESP-0009 conformance level.

`DEP-REQ-140`: L1 implementations MUST satisfy `DEP-REQ-001` through `DEP-REQ-036`, `DEP-REQ-052` through `DEP-REQ-054`, `DEP-REQ-063` through `DEP-REQ-071`, `DEP-REQ-089` through `DEP-REQ-094`, `DEP-REQ-116` through `DEP-REQ-122`, and `DEP-REQ-133`.

`DEP-REQ-141`: L2 implementations MUST satisfy all L1 requirements plus progressive delivery gates, approvals, freeze handling, and workflow correlation requirements.

`DEP-REQ-142`: L3 implementations MUST satisfy all L2 requirements plus promotion chains, multi-region controls, advanced analysis, and enterprise audit/supply-chain requirements.

### 11.2 Interoperability Expectations

`DEP-REQ-143`: Independent implementations MUST exchange deployment request/response documents in JSON without proprietary mandatory fields; extensions MAY use namespaced keys.

`DEP-REQ-144`: Provenance records MUST be interpretable by third-party audit tools given this specification.

`DEP-REQ-145`: Conformance claims MUST list supported strategies, target types, and gate types.

### 11.3 Quality Metrics

Implementations SHOULD track:

| Metric | Description |
|:---|:---|
| Deploy success rate | Succeeded / attempted sessions |
| Rollback rate | Sessions ending in rollback |
| Gate catch rate | Failures detected by gates before full exposure |
| Mean time to rollback | Abort decision to restored baseline |
| Change fail rate | Production deploys causing incidents |
| Approval latency | Time waiting on human gates |

`DEP-REQ-146`: Conformance suites MUST include request validation, digest enforcement, authorization, basic strategy execution, and rollback tests.

`DEP-REQ-147`: Progressive delivery suites MUST include gate fail → abort/rollback tests.

`DEP-REQ-148`: Security suites MUST include unauthorized deploy, digest mismatch, and freeze bypass tests.

### 11.4 Test Vectors

`DEP-REQ-149`: Test vectors MUST cover each strategy an implementation claims.

`DEP-REQ-150`: Negative tests MUST cover approval rejection, precheck failure, gate failure, rollback failure, and cancellation.

`DEP-REQ-151`: Multi-target tests MUST verify per-target outcomes and declared failure policy behavior.

## 12. Appendices

### 12.1 Example Canary Request (YAML)

```yaml
id: urn:aeo:deploy:request:checkout-canary-21
requester: urn:aeo:agent:release-conductor
artifact:
  id: urn:aeo:artifact:checkout:9.2.1
  digest: sha256:example
  type: oci-image
environment: prod
targets:
  - urn:aeo:target:k8s:prod-us-east-1:checkout
strategy:
  type: canary
  steps:
    - weight: 5
      pause: PT15M
    - weight: 20
      pause: PT30M
    - weight: 100
gates:
  - id: error-rate
    threshold: "<=0.5%"
    window: PT10M
  - id: latency-p99
    threshold: "<=300ms"
    window: PT10M
rollback:
  mode: automatic-on-gate-fail
  toArtifact: urn:aeo:artifact:checkout:9.2.0
approvalPolicy: human-required-for-prod
```

### 12.2 Example Provenance Record

```json
{
  "id": "urn:aeo:provenance:deploy:checkout-canary-21",
  "sessionId": "urn:aeo:deploy:session:checkout-canary-21",
  "requestId": "urn:aeo:deploy:request:checkout-canary-21",
  "environment": "prod",
  "artifactDigest": "sha256:example",
  "previousArtifact": "urn:aeo:artifact:checkout:9.2.0",
  "strategy": "canary",
  "result": "rolled-back",
  "gateFailures": ["error-rate"],
  "startedAt": "2026-07-10T20:00:00Z",
  "endedAt": "2026-07-10T20:18:00Z"
}
```

### 12.3 Error Code Registry (Baseline)

| Code | Stage | Meaning |
|:---|:---|:---|
| `DEP-ERR-REQUEST-INVALID` | request validation | Request fails schema or required fields |
| `DEP-ERR-AUTHZ` | authorization | Requester not permitted |
| `DEP-ERR-FREEZE` | policy | Freeze window blocks deploy |
| `DEP-ERR-APPROVAL` | approval | Approval denied or timed out |
| `DEP-ERR-PRECHECK` | precheck | Artifact/signature/policy precheck failed |
| `DEP-ERR-STRATEGY` | deploy | Strategy execution failure |
| `DEP-ERR-GATE` | verification | Health gate failed |
| `DEP-ERR-ROLLBACK` | rollback | Rollback failed |
| `DEP-ERR-TIMEOUT` | execution | Session or step timeout |
| `DEP-ERR-CANCELLED` | execution | Cancelled/aborted by actor |

### 12.4 Requirement Index

Requirements `DEP-REQ-001` through `DEP-REQ-151` define the normative surface of this draft. Future revisions SHOULD preserve identifiers and append new identifiers rather than renumbering existing requirements.

| Range | Domain |
|:---|:---|
| `DEP-REQ-001` to `DEP-REQ-017` | Deployment Model Architecture |
| `DEP-REQ-018` to `DEP-REQ-033` | Artifacts, Environments, and Targets |
| `DEP-REQ-034` to `DEP-REQ-051` | Rollout Strategies |
| `DEP-REQ-052` to `DEP-REQ-073` | Deployment Execution |
| `DEP-REQ-074` to `DEP-REQ-088` | Health Gates and Progressive Delivery |
| `DEP-REQ-089` to `DEP-REQ-099` | Rollback |
| `DEP-REQ-100` to `DEP-REQ-115` | Environment Promotion |
| `DEP-REQ-116` to `DEP-REQ-132` | Security and Policy |
| `DEP-REQ-133` to `DEP-REQ-151` | Implementation and Conformance |

# References

[^1^]: Kubernetes, "Deployments", accessed 2026-07-10, https://kubernetes.io/docs/concepts/workloads/controllers/deployment/

[^2^]: Argo Project, "Argo Rollouts", accessed 2026-07-10, https://argo-rollouts.readthedocs.io/

[^3^]: Spinnaker, "Spinnaker documentation", accessed 2026-07-10, https://spinnaker.io/docs/

[^4^]: OpenGitOps, "GitOps Principles", accessed 2026-07-10, https://opengitops.dev/

[^5^]: Microsoft, "Progressive delivery / service mesh patterns", accessed 2026-07-10, https://learn.microsoft.com/

[^6^]: SLSA, "Supply-chain Levels for Software Artifacts", accessed 2026-07-10, https://slsa.dev/

[^7^]: Bradner, S., "Key words for use in RFCs to Indicate Requirement Levels", BCP 14, RFC 2119, March 1997, https://www.rfc-editor.org/rfc/rfc2119

[^8^]: Flux, "Flux documentation", accessed 2026-07-10, https://fluxcd.io/docs/

[^9^]: CNCF, "Cloud Native Trail Map / Progressive Delivery", accessed 2026-07-10, https://www.cncf.io/

[^10^]: OWASP, "CI/CD Security Cheat Sheet", accessed 2026-07-10, https://cheatsheetseries.owasp.org/
