# AESP Pull Request Template

## Specification Change Proposal

### Summary

Provide a concise summary of the change. What is being added, modified, or
removed? Why is this change necessary?

### Affected Specification(s)

- [ ] AESP-0000 — Specification Governance & Process
- [ ] AESP-0001 — Architecture Overview
- [ ] AESP-0002 — Intent & Prompt Engineering
- [ ] AESP-0003 — Declarative Infrastructure
- [ ] AESP-0004 — Scaffolding & Project Templates
- [ ] AESP-0005 — Knowledge Graph & Memory
- [ ] AESP-0006 — Continuous Verification
- [ ] AESP-0007 — Code Generation
- [ ] AESP-0008 — Documentation Generator
- [ ] AESP-0009 — Deployment Automation
- [ ] AESP-0010 — Testing & Validation
- [ ] AESP-0011 — Observability
- [ ] AESP-0012 — Remediation & Self-Healing
- [ ] AESP-0013 — Security & Compliance
- [ ] AESP-0014 — Human-in-the-Loop
- [ ] AESP-0015 — Integration & Interoperability
- [ ] Multiple specifications (list below)
- [ ] Project infrastructure (README, LICENSE, etc.)

**If multiple specifications:** <!-- list affected spec numbers -->

### Change Type

- [ ] Editorial fix (typo, formatting, broken link)
- [ ] Clarification (improves wording without changing normative meaning)
- [ ] New feature (adds new normative content)
- [ ] Breaking change (modifies existing normative behavior)
- [ ] Deprecation (marks content as deprecated)
- [ ] Removal (removes previously specified behavior)

### Motivation

Explain the problem this change solves. What is the current deficiency? How
does this change address it? Reference any relevant issues or discussions.

### Detailed Description

Describe the change in detail. For specification changes, include:

- Exact sections being added, modified, or removed
- New normative requirements (MUST, SHOULD, MAY statements)
- Impact on existing implementations
- Cross-references to other specifications affected by this change

### Backwards Compatibility

- [ ] This change is backward-compatible
- [ ] This change introduces a breaking change (explain below)

**Breaking change explanation:** <!-- if applicable -->

### Checklist

Before submitting, ensure the following:

- [ ] I have read and agree to follow the [CONTRIBUTING.md](../CONTRIBUTING.md) guidelines.
- [ ] The change follows RFC 2119 terminology conventions (MUST, MUST NOT, SHOULD, SHOULD NOT, MAY, OPTIONAL).
- [ ] Language is vendor-neutral and architecture-first.
- [ ] Examples provided for new normative content.
- [ ] Counter-examples provided where ambiguity could arise.
- [ ] Mermaid diagrams updated or added where applicable.
- [ ] Cross-references to other specifications verified.
- [ ] No marketing or promotional language included.
- [ ] The commit message follows conventional commit format:
      `docs(aesp-NNNN): description` for specification changes, or
      `chore: description` for project infrastructure changes.

### Review Notes

<!-- Any specific areas where reviewer attention is needed -->

### Related Issues

<!-- Link to related issues or discussions -->
