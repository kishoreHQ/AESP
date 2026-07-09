# Reference Implementations

This directory contains reference implementations for the Autonomous
Engineering Specification (AESP). These implementations serve as working
examples of how the specifications can be realized in practice.

## Purpose

Reference implementations serve several important purposes:

1. **Validation**: They validate that specifications are implementable and
   self-consistent
2. **Guidance**: They provide concrete examples for implementors
3. **Testing**: They host conformance tests that verify specification compliance
4. **Learning**: They enable hands-on learning for practitioners

## Reference Implementation Principles

All reference implementations in this repository adhere to the following
principles:

- **Complete**: Each reference implementation covers the full scope of its
target specification
- **Correct**: Implementations conform exactly to the normative requirements
- **Documented**: All code is documented with references to specification sections
- **Tested**: Comprehensive test suite with conformance tests
- **Minimal**: No unnecessary complexity or features beyond the specification

## Reference Implementation Index

| Implementation | Language | Target Specs | Status |
|----------------|----------|-------------|--------|
| [ref-go](ref-go/) | Go | AESP-0000 through AESP-0005 | PLANNED |
| [ref-python](ref-python/) | Python | AESP-0000 through AESP-0005 | PLANNED |

*Note: Reference implementations will be developed during Phase 4 (Q2 2027)*

## Structure

Each reference implementation directory follows this structure:

```
ref-<language>/
├── README.md              # Implementation-specific documentation
├── CONTRIBUTING.md        # Guidelines for contributing to this implementation
├── cmd/                   # Command-line tools
├── pkg/
│   ├── intent/            # AESP-0002: Intent & Prompt Engineering
│   ├── declarative/       # AESP-0003: Declarative Infrastructure
│   ├── scaffolding/       # AESP-0004: Scaffolding & Project Templates
│   ├── knowledge/         # AESP-0005: Knowledge Graph & Memory
│   ├── verification/      # AESP-0006: Continuous Verification
│   ├── codegen/           # AESP-0007: Code Generation
│   ├── documentation/     # AESP-0008: Documentation Generator
│   ├── deployment/        # AESP-0009: Deployment Automation
│   ├── testing/           # AESP-0010: Testing & Validation
│   ├── observability/     # AESP-0011: Observability
│   ├── remediation/       # AESP-0012: Remediation & Self-Healing
│   ├── security/          # AESP-0013: Security & Compliance
│   ├── hitl/              # AESP-0014: Human-in-the-Loop
│   └── integration/       # AESP-0015: Integration & Interoperability
├── internal/              # Internal implementation details
├── api/                   # API definitions and schemas
├── docs/                  # Generated documentation
├── examples/              # Usage examples
└── test/                  # Conformance and integration tests
```

## Conformance Testing

Reference implementations include a conformance test suite that verifies
compliance with the specifications. The test suite covers:

### Required Tests

- **Normative Requirement Tests**: Verify all MUST and MUST NOT requirements
- **Protocol Compliance Tests**: Verify protocol implementations match spec
- **Schema Validation Tests**: Verify data models conform to defined schemas
- **Error Handling Tests**: Verify correct error responses and recovery

### Recommended Tests

- **Performance Tests**: Verify performance characteristics meet guidelines
- **Stress Tests**: Verify behavior under load and edge conditions
- **Compatibility Tests**: Verify interoperability between implementations

### Test Results

| Implementation | Tests Passing | Tests Total | Coverage | Last Run |
|----------------|--------------|-------------|----------|----------|
| ref-go | — | — | — | — |
| ref-python | — | — | — | — |

## Using Reference Implementations

### For Learning

Reference implementations are the best way to understand how specifications
translate into working code:

1. Read the relevant specification first
2. Explore the corresponding package in the reference implementation
3. Run the examples and tests
4. Modify and experiment

### For Development

Reference implementations can serve as a foundation for production systems:

1. Evaluate the reference implementation against your requirements
2. Fork or vendor the relevant packages
3. Extend with your specific business logic
4. Run the conformance tests regularly to ensure spec compliance

### For Conformance Verification

Implementations can verify their conformance by:

1. Running the conformance test suite against their implementation
2. Checking that all REQUIRED tests pass
3. Submitting conformance results to the AESP project

## Contributing

Contributions to reference implementations are welcome. Each implementation
has its own `CONTRIBUTING.md` with language-specific conventions.

General guidelines:

1. All code MUST reference the relevant specification section in comments
2. All changes MUST include corresponding test updates
3. Conformance tests MUST NOT be modified to match implementation behavior
4. Performance characteristics SHOULD be documented

See [CONTRIBUTING.md](../CONTRIBUTING.md) for the overall contribution process.

---

*For questions about reference implementations, open a [GitHub Discussion](https://github.com/kishoreHQ/AESP/discussions).*
