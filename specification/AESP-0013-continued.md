# AESP-0013: Security & Compliance, Continued

## 5. Secrets and Data Protection

`SEC-REQ-019`: Secrets MUST be stored in a dedicated secrets system; embedding secrets in prompts, repos, or memory records by default is non-conformant.

`SEC-REQ-020`: Secret access MUST be authorized and audited.

`SEC-REQ-021`: Secret injection into runtimes MUST prefer short-lived credentials.

`SEC-REQ-022`: Data classification labels MUST be supported on memory, docs, telemetry, and artifacts when those systems are present.

`SEC-REQ-023`: Restricted data MUST NOT flow to models, tools, or publish targets lacking clearance.

`SEC-REQ-024`: Encryption in transit is REQUIRED for production control-plane and data-plane external channels.

`SEC-REQ-025`: Encryption at rest is RECOMMENDED for memory, artifacts, and telemetry stores handling confidential data.

`SEC-REQ-026`: Key management MUST support rotation.

## 6. Audit Logging

`SEC-REQ-027`: Security audit events MUST include timestamp, principal, action, resource, outcome, and correlation ids when available.

`SEC-REQ-028`: Audit logs MUST be append-only or integrity-protected against undetected tampering by the audited system alone.

`SEC-REQ-029`: Audit retention MUST meet organizational and regulatory policy; security-relevant events SHOULD retain at least as long as related deploy/test evidence.

`SEC-REQ-030`: Agents and admins MUST NOT be able to disable audit for their own actions without break-glass.

`SEC-REQ-031`: Export of audit evidence for compliance MUST be supported in machine-readable form.

## 7. Supply Chain

`SEC-REQ-032`: Production admission SHOULD verify artifact signatures and provenance attestations (SLSA-aligned or equivalent) [^2^].

`SEC-REQ-033`: Model and tool packages used by agents SHOULD be inventoried with version pins.

`SEC-REQ-034`: Dependency and image digests MUST be recorded for production deploys (aligns AESP-0009).

`SEC-REQ-035`: Compromised artifact revocation MUST be enforceable (deny list / policy update).

`SEC-REQ-036`: Prompt/tool plugins from untrusted sources MUST run at reduced trust levels.

## 8. Compliance Frameworks

`SEC-REQ-037`: Implementations MAY map AESP controls to external frameworks (SOC2, ISO 27001, NIST AI RMF, GDPR) via a control matrix.

`SEC-REQ-038`: Control matrices MUST reference stable AESP requirement ids.

`SEC-REQ-039`: Compliance evidence packages MUST include policy versions, audit extracts, and access reviews when claimed.

`SEC-REQ-040`: Data subject rights workflows (access/delete) MUST be supported when personal data is processed, coordinated with AESP-0004 forgetting semantics.

## 5.1 Prompt and Tool Output Controls

`SEC-REQ-052`: Production agents with tool access MUST enforce an allowlist or policy decision per tool invocation.

`SEC-REQ-053`: High-risk tools (shell, production deploy, secret read, payment) MUST require step-up auth or HITL when policy classifies them as elevated.

`SEC-REQ-054`: Model outputs that include credential-shaped strings SHOULD be blocked or redacted before tool execution or external send.
