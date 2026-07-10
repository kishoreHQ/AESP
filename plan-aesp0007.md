# AESP-0007: Code Generation — Execution Plan

## Date
2026-07-10

## Specification
**AESP-0007**: Code Generation — Generation Protocols, Template Engines, Output Validation, and Artifact Lifecycle Management

## Dependencies
- AESP-0000 (Constitution): Governance, normative language, machine-readable artifacts
- AESP-0001 (Core Model): Agent identity, WorkUnit, Capability, Resource references
- AESP-0003 (Communication Protocols): Generation requests, result delivery, review messages
- AESP-0005 (Workflow Orchestration): Multi-step generation workflows, retries, approval gates
- AESP-0006 (Knowledge Graph): Optional semantic context, schema grounding, retrieval for generation

## Scope
Define code generation semantics for autonomous engineering organizations including:
- Generation request and response contracts
- Input specification formats for prompts, schemas, templates, and constraints
- Template-driven, model-driven, and hybrid generation modes
- Determinism, reproducibility, and provenance requirements
- Output validation for syntax, types, policy, tests, and security constraints
- Review, approval, and regeneration workflows
- Artifact lifecycle management (draft, accepted, deprecated, regenerated)
- Multi-file and multi-language generation sessions
- Integration with AESP workflows, memory, and knowledge graph context
- Conformance levels and evaluation metrics

## Estimated Size
~40,000 words across 12 chapters

## Stages

### Stage 1: Research
- **10 research dimensions**:
  1. Code generation systems and assistants
  2. Template engines and scaffolding frameworks
  3. AST- and IR-based generation approaches
  4. Deterministic generation and reproducible builds
  5. Validation pipelines (syntax, compile, lint, test, policy)
  6. Secure-by-default generation and guardrails
  7. Regeneration, patching, and merge semantics
  8. Provenance, traceability, and audit for generated artifacts
  9. Multi-file, multi-language project generation
  10. Human review and acceptance patterns for generated code
- **Outputs**: Research artifacts in `research/aesp0007_dim*.md`

### Stage 2: Outline Design
- **4 parallel outline agents**: requirement_analyst, artifact_analyst, structure_designer, content_planner
- **Output**: `aesp0007.agent.outline.md`

### Stage 3: Content Creation
- **Style**: Technical specification (RFC 2119 normative language)
- **Rounds**:
  - Round 1: Ch 1 (Introduction) + Ch 2 (Generation Model Architecture)
  - Round 2: Ch 3 (Inputs and Constraints) + Ch 4 (Generation Modes) + Ch 6 (Validation) + Ch 12 (Appendices)
  - Round 3: Ch 5 (Generation Execution) + Ch 7 (Artifact Lifecycle) + Ch 8 (Review and Approval) + Ch 9 (Security and Policy) + Ch 11 (Conformance)
  - Round 4: Ch 10 (Implementation Guidelines)
- **Output**: Chapter files `aesp0007_sec*.md`

### Stage 4: Assembly
- Merge all chapter files into final markdown
- Convert to docx via md2docx pipeline if available
- **Output**: `aesp0007.agent.final.md`

### Stage 5: Commit
- Create metadata file `aesp-0007.yaml`
- Split into 3 parts if >100K chars
- Push to GitHub: AESP-0007.md, AESP-0007-continued.md, AESP-0007-reference.md, aesp-0007.yaml
- Update CHANGELOG for v0.9.0
- Update ROADMAP.md

## Expected Deliverables
| Deliverable | Path | Est. Size |
|-------------|------|-----------|
| Plan | plan-aesp0007.md | ~3K chars |
| Research artifacts | research/aesp0007_dim*.md | ~500K total |
| Final Markdown | aesp0007.agent.final.md | ~320-380K chars |
| Part 1 (GitHub) | specification/AESP-0007.md | ~70-90K B |
| Part 2 (GitHub) | specification/AESP-0007-continued.md | ~90-110K B |
| Part 3 (GitHub) | specification/AESP-0007-reference.md | ~60-80K B |
| Metadata | specification/aesp-0007.yaml | ~1 KB |
