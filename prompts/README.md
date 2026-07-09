# Prompt Engineering Library

This directory contains a curated library of prompts for the Autonomous
Engineering Specification (AESP). These prompts are designed to support
specification development, implementation, and operation of autonomous
engineering systems.

## Purpose

Prompts are a critical component of intent-driven autonomous systems. This
library provides:

1. **Specification Prompts**: Prompts for generating, reviewing, and improving
   AESP specifications
2. **Implementation Prompts**: Prompts for implementing specification-compliant
   systems
3. **Operational Prompts**: Prompts for operating and troubleshooting
   autonomous engineering platforms
4. **Reference Prompts**: Exemplar prompts demonstrating best practices in
   prompt engineering for autonomous systems

## Prompt Format

Each prompt file MUST be named `PROMPT-NNNN.md` and MUST follow this
structure:

```markdown
# PROMPT-NNNN: [Prompt Title]

**Category:** [Specification | Implementation | Operations | Reference]
**Target Spec:** [AESP-NNNN | N/A]
**Version:** 1.0.0
**Last Updated:** YYYY-MM-DD
**Model Compatibility:** [Model family or "General"]

## Purpose

[What this prompt is designed to accomplish.]

## Prompt

```
[The exact prompt text. Use clear parameter placeholders in {{brackets}}.]

You are an autonomous engineering specialist. Your task is to...

Input:
- Resource: {{RESOURCE_TYPE}}
- Context: {{OPERATIONAL_CONTEXT}}

Instructions:
1. Analyze the input...
2. Generate output in the following format...

Output Format:
```yaml
result:
  resource: "{{RESOURCE_TYPE}}"
  actions: []
```
```

## Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `{{RESOURCE_TYPE}}` | string | Yes | The type of resource to process |
| `{{OPERATIONAL_CONTEXT}}` | string | Yes | Additional context for the operation |

## Example Usage

### Input

```yaml
RESOURCE_TYPE: "Kubernetes Deployment"
OPERATIONAL_CONTEXT: "Production environment, high availability required"
```

### Output

```yaml
result:
  resource: "Kubernetes Deployment"
  actions:
    - action: "reconfigure"
      target: "replica_count"
      value: 3
```

## Notes

[Additional context, caveats, or usage notes.]

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | YYYY-MM-DD | Initial version |
```

## Prompt Categories

### Specification Prompts

Prompts for creating and maintaining AESP specifications:

| Prompt | Purpose | Target |
|--------|---------|--------|
| [PROMPT-0001](PROMPT-0001.md) | [Reserved] | — |

### Implementation Prompts

Prompts for implementing AESP-compliant systems:

| Prompt | Purpose | Target |
|--------|---------|--------|
| [PROMPT-0001](PROMPT-0001.md) | [Reserved] | — |

### Operational Prompts

Prompts for running and troubleshooting autonomous engineering systems:

| Prompt | Purpose | Target |
|--------|---------|--------|
| [PROMPT-0001](PROMPT-0001.md) | [Reserved] | — |

### Reference Prompts

Exemplar prompts demonstrating prompt engineering best practices:

| Prompt | Purpose | Target |
|--------|---------|--------|
| [PROMPT-0001](PROMPT-0001.md) | [Reserved] | — |

## Prompt Engineering Guidelines

When creating prompts for autonomous engineering systems:

### DO

- **Be specific**: Clearly define the task, input format, and expected output
- **Provide context**: Include relevant operational context in the prompt
- **Use structured output**: Request output in machine-parseable formats (YAML, JSON)
- **Include examples**: Provide input/output examples to guide the model
- **Define constraints**: Specify what the model MUST NOT do
- **Version prompts**: Track prompt versions as they evolve

### DO NOT

- **Include secrets**: Never embed credentials, tokens, or sensitive data
- **Assume model knowledge**: Provide sufficient context for the task
- **Use ambiguous language**: Be precise in requirements
- **Overload context**: Keep prompts focused on a single concern
- **Ignore failure modes**: Consider and handle error cases

## Prompt Versioning

Prompts MUST be versioned using [Semantic Versioning](https://semver.org/):

- **Major (X.0.0)**: Breaking changes to output format or behavior
- **Minor (x.Y.0)**: New parameters or capabilities added
- **Patch (x.y.Z)**: Bug fixes, clarification, no behavioral change

## Prompt Testing

All prompts in this library SHOULD be tested for:

1. **Correctness**: Output matches expected format and content
2. **Consistency**: Similar inputs produce similar outputs across runs
3. **Robustness**: Handles edge cases and invalid inputs gracefully
4. **Safety**: Does not produce harmful or insecure output
5. **Performance**: Completes within acceptable time limits

## Contributing

To propose a new prompt:

1. Follow the prompt format template above
2. Include at least one complete example
3. Document all parameters
4. Test the prompt with at least one model
5. Submit a pull request with commit message: `docs(prompts): add PROMPT-NNNN [title]`

See [CONTRIBUTING.md](../CONTRIBUTING.md) for the full contribution process.

---

*For questions about prompts, open a [GitHub Discussion](https://github.com/kishoreHQ/AESP/discussions).*
