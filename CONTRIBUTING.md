# Contributing to AESP

Thank you for your interest in contributing to the Autonomous Engineering
Specification (AESP). This document defines the processes, conventions, and
guidelines for all contributions.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [How to Contribute](#how-to-contribute)
- [RFC Process](#rfc-process)
- [Committee Review Process](#committee-review-process)
- [Commit Message Conventions](#commit-message-conventions)
- [Editorial Guidelines](#editorial-guidelines)
- [Getting Help](#getting-help)

## Code of Conduct

All contributors MUST adhere to professional standards of technical
collaboration. Treat all participants with respect. Focus criticism on ideas,
not individuals. Seek to understand before being understood.

## How to Contribute

### Types of Contributions

The following contribution types are welcome:

1. **Specification Changes**: Additions, modifications, or removals of
   normative content in any AESP-NNNN document.
2. **Editorial Fixes**: Corrections to typos, formatting, broken links, or
   unclear wording that does not change normative meaning.
3. **Examples and Diagrams**: New examples, Mermaid diagrams, or
   illustrations that clarify existing specifications.
4. **Bug Reports**: Issues identified in existing specifications —
   inconsistencies, ambiguities, or errors.
5. **Process Improvements**: Suggestions to improve this contributing guide,
   the RFC process, or project governance.

### Contribution Workflow

```
┌─────────────┐    ┌──────────────┐    ┌──────────────┐    ┌─────────────┐
│   Identify  │───▶│   Open an    │───▶│   Submit a   │───▶│   Committee │
│    Need     │    │    Issue     │    │      PR      │    │   Review    │
└─────────────┘    └──────────────┘    └──────────────┘    └─────────────┘
                                                              │
                                    ┌─────────────────────────┼─────────┐
                                    ▼                         ▼         ▼
                              ┌─────────┐               ┌────────┐ ┌────────┐
                              │ Accept  │               │ Request│ │ Reject │
                              │         │               │ Changes│ │        │
                              └─────────┘               └────────┘ └────────┘
```

#### Step 1: Identify the Need

Before making a change, clearly articulate the problem or opportunity. Ask:

- What is the current deficiency or gap?
- Who is affected by this issue?
- What is the proposed solution?
- Does this change align with the AESP vision?

#### Step 2: Open an Issue

For non-trivial changes, open an issue describing the proposed change. This
allows for early feedback and prevents wasted effort. The issue MUST include:

- A clear title describing the change
- Motivation for the change
- The proposed solution (if known)
- Affected specifications (if any)
- Change type classification (see below)

#### Step 3: Submit a Pull Request

After opening an issue (or for trivial editorial fixes), submit a pull request
following the [PR template](.github/PULL_REQUEST_TEMPLATE.md).

#### Step 4: Committee Review

All pull requests undergo committee review. See
[Committee Review Process](#committee-review-process) for details.

### Change Type Classification

Every change MUST be classified as one of the following:

| Type | Description | Review Required |
|------|-------------|-----------------|
| **Editorial** | Typo, formatting, broken link, non-normative wording improvement | Single reviewer |
| **Clarification** | Improves wording without changing normative meaning | Single reviewer |
| **New Feature** | Adds new normative content (new sections, requirements, protocols) | Full committee review |
| **Breaking Change** | Modifies existing normative behavior | Full committee review + RFC |
| **Deprecation** | Marks content as deprecated | Full committee review |
| **Removal** | Removes previously specified behavior | Full committee review + RFC |

## RFC Process

Significant changes (Breaking Changes, major New Features, and Removals) MUST
follow the RFC (Request for Comments) process.

### When an RFC is Required

An RFC is REQUIRED for:

- Changes that modify existing normative requirements (MUST, MUST NOT, SHOULD,
  SHOULD NOT)
- Addition of new major architectural components
- Removal of previously specified features or protocols
- Changes that affect interoperability between implementations
- Changes to the governance model or RFC process itself

An RFC is NOT required for:

- Editorial fixes
- Clarifications that do not change normative meaning
- Addition of examples, diagrams, or non-normative notes
- Addition of new examples to existing protocols

### RFC Lifecycle

```
┌──────────┐   ┌──────────┐   ┌──────────┐   ┌──────────┐   ┌──────────┐
│  Draft   │──▶│ Proposed │──▶│  Under   │──▶│  Final   │──▶│ Superseded│
│          │   │          │   │ Review   │   │  Comment │   │          │
└──────────┘   └──────────┘   └──────────┘   └──────────┘   └──────────┘
                  │                │               │
                  ▼                ▼               ▼
              ┌──────────┐   ┌──────────┐   ┌──────────┐
              │ Withdrawn│   │ Rejected │   │  Stable  │
              └──────────┘   └──────────┘   └──────────┘
```

#### RFC States

| State | Description |
|-------|-------------|
| **Draft** | Initial state. The RFC author is developing the proposal. |
| **Proposed** | The author submits the RFC for review. Open for community feedback. |
| **Under Review** | The committee is actively reviewing. May request changes. |
| **Final Comment** | Two-week final comment period before disposition. |
| **Stable** | Accepted. Merged into the relevant specification(s). |
| **Rejected** | Not accepted. Reasons documented in the RFC. |
| **Withdrawn** | Withdrawn by the author. |
| **Superseded** | Replaced by a newer RFC. Reference to the new RFC provided. |

### RFC Document Format

RFC documents MUST follow the template in [rfc/README.md](rfc/README.md) and
MUST include:

1. **RFC Number**: Sequential number (RFC-0001, RFC-0002, etc.)
2. **Title**: Descriptive title
3. **Author(s)**: Name and affiliation of authors
4. **Status**: Current RFC state
5. **Target Specifications**: Which AESP-NNNN documents are affected
6. **Motivation**: Detailed explanation of the problem
7. **Proposal**: The proposed change in detail
8. **Alternatives Considered**: Other approaches and why they were rejected
9. **Impact Analysis**: Backwards compatibility, implementation impact
10. **Timeline**: Proposed implementation schedule

## Committee Review Process

### Review Criteria

All pull requests are evaluated against the following criteria:

1. **Architectural Coherence**: Does the change align with the overall AESP
   architecture and vision?
2. **Technical Correctness**: Is the proposed change technically sound?
3. **Completeness**: Are all necessary sections, examples, and diagrams
   included?
4. **RFC 2119 Compliance**: Does the change correctly use normative
   terminology (MUST, MUST NOT, SHOULD, SHOULD NOT, MAY, OPTIONAL)?
5. **Vendor Neutrality**: Is the change free of vendor-specific language,
   product references, or marketing content?
6. **Interoperability**: Does the change promote or preserve
   interoperability between implementations?
7. **Backwards Compatibility**: Does the change maintain backwards
   compatibility, or is the breaking change justified?

### Review Tiers

#### Single Reviewer (Editorial and Clarification changes)

- One committee member reviews and approves
- Merge can proceed after approval
- 48-hour review window (auto-approved if no response)

#### Full Committee Review (New Feature, Breaking Change, Deprecation, Removal)

- Minimum two committee members must review
- All review comments must be addressed or dispositioned
- 7-day minimum review window
- Final approval requires consensus (no outstanding objections)

### Review Response Codes

Reviewers SHOULD use the following response codes:

| Code | Meaning |
|------|---------|
| `/approve` | Change is approved. Ready to merge. |
| `/lgtm` | Looks good to me. Minor, non-blocking comments may be included. |
| `/hold` | Do not merge. Blocking concerns must be addressed. |
| `/request-changes` | Specific changes required before approval. |
| `/needs-rfc` | This change requires an RFC process before proceeding. |

## Commit Message Conventions

All commits MUST follow the [Conventional Commits](https://www.conventionalcommits.org/)
specification with the AESP-specific scope conventions described below.

### Format

```
<type>(<scope>): <description>

[optional body]

[optional footer(s)]
```

### Types

| Type | Use For |
|------|---------|
| `docs` | Specification content changes (AESP-NNNN documents) |
| `chore` | Project infrastructure, build, CI/CD changes |
| `feat` | New features in tooling or reference implementations |
| `fix` | Bug fixes in tooling or reference implementations |
| `refactor` | Code refactoring without behavior change |
| `test` | Test additions or corrections |

### Scopes

| Scope | Description |
|-------|-------------|
| `aesp-0000` through `aesp-0015` | Changes to the specific specification |
| `governance` | Changes to governance, process, or committee docs |
| `github` | GitHub workflow, templates, or configuration |
| `adr` | Architecture Decision Records |
| `template` | Specification or RFC templates |
| *(empty)* | General project changes |

### Examples

```
docs(aesp-0001): add component interaction diagram

Add a Mermaid sequence diagram illustrating the interaction between
the Intent Parser, State Reconciler, and Verification Engine.

Closes #42
```

```
docs(aesp-0003): clarify resource descriptor schema

Clarify that the resource descriptor MUST include a version field
and SHOULD include a dependencies array. Previous wording was
ambiguous about whether version was optional.
```

```
chore(github): update PR template to include checklist

Add a compliance checklist section to the pull request template
to ensure contributors verify RFC 2119 terminology and
vendor-neutrality before submission.
```

### Breaking Changes

Breaking changes MUST be indicated with a `!` after the type/scope and MUST
include a `BREAKING CHANGE:` footer:

```
docs(aesp-0007)!: rename code generation output format

The output format previously called `artifact_v1` is renamed to
`artifact_v2` to accommodate the new metadata requirements.

BREAKING CHANGE: Implementations using the `artifact_v1` format
MUST update to `artifact_v2` by 2027-03-01.
```

## Editorial Guidelines

### Language Conventions

- Use **RFC 2119** terminology for all normative content:
  - **MUST** / **REQUIRED** / **SHALL**: Absolute requirement
  - **MUST NOT** / **SHALL NOT**: Absolute prohibition
  - **SHOULD** / **RECOMMENDED**: Strong recommendation with valid exceptions
  - **SHOULD NOT**: Strong recommendation against with valid exceptions
  - **MAY** / **OPTIONAL**: Truly optional
- Use **vendor-neutral** language. Do not mention specific products, companies,
  or platforms unless in the context of examples.
- Use **architecture-first** descriptions. Describe what the system does and
  why before describing how.
- Write in **present tense**, active voice where possible.
- Define all **terms** on first use in the Definitions section.

### Formatting Conventions

- Use Markdown for all documents
- Use Mermaid syntax for all diagrams
- Use code blocks with language identifiers for all examples
- Use tables for structured comparisons and option listings
- Use hierarchical headings (##, ###, ####) consistently

### Example Format

All normative requirements SHOULD be accompanied by:

1. A **positive example** showing correct implementation
2. A **counter-example** showing common incorrect approaches
3. A **Mermaid diagram** where visual representation aids understanding

## Getting Help

- **General questions**: Open a [GitHub Discussion](https://github.com/kishoreHQ/AESP/discussions)
- **Bug reports**: Open a [GitHub Issue](https://github.com/kishoreHQ/AESP/issues)
- **Security concerns**: See [AESP-0013: Security & Compliance](specification/AESP-0013.md)
- **Committee contact**: aesp-committee@example.org

---

Thank you for contributing to the Autonomous Engineering Specification. Your
efforts help build a more interoperable, automated, and resilient engineering
ecosystem.
