# AESP-0013: Security & Compliance, Reference

## 9. Multi-Agent and LLM-Specific Threats

`SEC-REQ-041`: Implementations MUST document handling of prompt injection, tool abuse, and confused-deputy risks for agents with tools.

`SEC-REQ-042`: Untrusted content used as model input MUST be labeled; high-risk tools MUST require step-up authorization.

`SEC-REQ-043`: Output that attempts to exfiltrate secrets SHOULD be detectable by policy scanners before external send.

`SEC-REQ-044`: Cross-agent delegation MUST not expand authority beyond the min of delegator and policy max for delegatee.

`SEC-REQ-045`: Model provider endpoints MUST be authenticated and allowlisted in production.

## 10. Implementation Guidelines

`SEC-REQ-046`: L1 MUST implement principal identity, deny-by-default for admin ops, TLS, audit of authz denials and admin actions, and secrets not in source.

Common patterns: OIDC + workload identity (SPIFFE), OPA/Cedar policy engines, Vault/SOPS secrets, Sigstore/cosign signing.

Anti-patterns: shared root API keys for all agents; production tools in sandbox agents; audit in the same mutable DB without integrity controls.

## 11. Conformance

| Level | Scope |
|:---|:---|
| L1 | Identity, basic authn/authz, TLS, secrets hygiene, core audit |
| L2 | Short-lived creds, PDP policy versions, classification, supply-chain verify, injection controls |
| L3 | Federation, compliance matrices, multi-party break-glass, continuous control monitoring |

`SEC-REQ-047`: Declare level.

`SEC-REQ-048`: L1: SEC-REQ-001–018, 019–021, 024, 027–028, 046.

`SEC-REQ-049`: L2 adds classification, supply chain, injection, short-lived creds.

`SEC-REQ-050`: L3 adds federation, compliance evidence, advanced break-glass.

`SEC-REQ-051`: Tests MUST include privilege escalation attempts, secret leakage in logs, and unauthorized deploy/tool calls.

`SEC-REQ-055`: Tests MUST include step-up denial for elevated tools without approval.

`SEC-REQ-056`: Tool results labeled `untrusted` (AESP-0015) MUST NOT be eligible to authorize privileged actions without an intervening policy decision or human approval.

`SEC-REQ-057`: When model context includes tool outputs, implementations MUST preserve trust labels across turns or reclassify content as untrusted by default.

`SEC-REQ-058`: Production profiles that claim AESP-0007–AESP-0012 or AESP-0015 conformance MUST also meet at least AESP-0013 L1 (security baseline).

## 12. Appendices

### Baseline Audit Event Types
`authn.success`, `authn.failure`, `authz.deny`, `secret.read`, `policy.change`, `breakglass.activate`, `artifact.admit`, `artifact.deny`.

### Requirement Index
`SEC-REQ-001`–`SEC-REQ-058`.

# References

[^1^]: RFC 2119  
[^2^]: SLSA, https://slsa.dev/  
[^3^]: NIST AI RMF, https://www.nist.gov/itl/ai-risk-management-framework  
[^4^]: OIDC, https://openid.net/connect/  
[^5^]: SPIFFE, https://spiffe.io/  
