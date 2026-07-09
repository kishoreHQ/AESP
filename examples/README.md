# Specification Examples

This directory contains practical examples demonstrating the application of
the Autonomous Engineering Specification (AESP). These examples serve as
learning materials, reference implementations, and conformance benchmarks.

## Purpose

Examples serve several important functions in the AESP ecosystem:

1. **Learning**: Help practitioners understand how specifications apply in
   real-world scenarios
2. **Validation**: Demonstrate that specifications are implementable and
   produce correct results
3. **Reference**: Provide starting points for new implementations
4. **Testing**: Serve as test cases for conformance verification

## Example Structure

Each example is contained in its own directory with the following structure:

```
examples/
├── EX-NNNN-[name]/
│   ├── README.md              # Example description and instructions
│   ├── architecture.md        # Architecture documentation
│   ├── manifests/             # Configuration files, descriptors
│   ├── code/                  # Implementation code
│   ├── tests/                 # Test cases
│   ├── docs/                  # Generated documentation
│   └── diagram.png            # Architecture diagram
```

## Example Index

| Example | Title | Target Specs | Complexity | Status |
|---------|-------|-------------|------------|--------|
| [EX-0001](EX-0001-basic-infrastructure/) | Basic Declarative Infrastructure | AESP-0003 | Beginner | PLANNED |
| [EX-0002](EX-0002-intent-pipeline/) | Intent-to-Deployment Pipeline | AESP-0002, AESP-0009 | Intermediate | PLANNED |
| [EX-0003](EX-0003-knowledge-graph/) | Operational Knowledge Graph | AESP-0005 | Intermediate | PLANNED |
| [EX-0004](EX-0004-self-healing/) | Self-Healing Service Mesh | AESP-0011, AESP-0012 | Advanced | PLANNED |
| [EX-0005](EX-0005-compliance-engine/) | Automated Compliance Engine | AESP-0006, AESP-0013 | Advanced | PLANNED |

*Note: Examples will be developed during Phase 4 (Q2 2027)*

## Example Format

Each example README MUST include:

```markdown
# EX-NNNN: [Example Title]

**Target Specs:** [AESP-NNNN, AESP-NNNN]
**Complexity:** [Beginner | Intermediate | Advanced]
**Prerequisites:** [Required knowledge or setup]
**Estimated Time:** [Time to complete]

## Scenario

[Description of the real-world scenario this example addresses.]

## Architecture

[Mermaid diagram showing the example architecture.]

## Prerequisites

- [Prerequisite 1]
- [Prerequisite 2]

## Step-by-Step Guide

### Step 1: [Step Name]

[Detailed instructions.]

### Step 2: [Step Name]

[Detailed instructions.]

## Verification

[How to verify the example works correctly.]

## Key Concepts Demonstrated

- [Concept 1 with spec reference]
- [Concept 2 with spec reference]

## Extensions

[Suggestions for extending the example.]
```

## Complexity Levels

### Beginner

Examples suitable for those new to AESP:

- Focus on a single specification
- Minimal prerequisites
- Complete, copy-pasteable instructions
- Extensive explanations of each step

### Intermediate

Examples for practitioners with basic AESP understanding:

- Combine 2-3 specifications
- Require some setup or configuration
- Include troubleshooting guidance
- Demonstrate realistic use cases

### Advanced

Examples for experienced practitioners:

- Integrate multiple specifications
- Require significant setup
- Address complex, production-like scenarios
- Include performance and scaling considerations

## Running Examples

### Prerequisites

All examples require:

- Git
- Docker (for containerized examples)
- A text editor

Individual examples may have additional requirements documented in their
README files.

### Quick Start

```bash
# Clone the repository
git clone https://github.com/kishoreHQ/AESP.git
cd AESP/examples

# Navigate to an example
cd EX-0001-basic-infrastructure

# Follow the README instructions
cat README.md
```

## Contributing

To propose a new example:

1. Identify a gap in current examples
2. Create a new directory following the naming convention `EX-NNNN-[descriptive-name]/`
3. Follow the example format template above
4. Include complete, tested instructions
5. Submit a pull request with commit message: `docs(examples): add EX-NNNN [title]`

### Example Review Criteria

- [ ] Example demonstrates one or more AESP specifications
- [ ] Instructions are complete and tested
- [ ] Architecture diagram is included
- [ ] Verification steps are provided
- [ ] Key concepts are documented with spec references
- [ ] Example is free of vendor-specific dependencies (where possible)

See [CONTRIBUTING.md](../CONTRIBUTING.md) for the full contribution process.

---

*For questions about examples, open a [GitHub Discussion](https://github.com/kishoreHQ/AESP/discussions).*
