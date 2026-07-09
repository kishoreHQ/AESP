# AESP-0002: Agent Roles — Sections 4–6

> **AESP Number:** 0002 | **Title:** Agent Roles | **Status:** Draft  
> **Depends On:** AESP-0001 (Foundation) | **Leads To:** AESP-0003 (Workflow & Handoffs)

---

## Section 4: Role Selection Algorithm

### 4.1 Overview

The role selection algorithm translates a **task description** and **context** into a **recommended role** with confidence scoring and explicit trade-off documentation. It is the bridge between unstructured work and structured role assignment.

```
Input:  Task description + context
Output: Role recommendation + confidence score + trade-off notes
```

> **Philosophy:** The algorithm is **advisory, not deterministic**. It produces recommendations that human operators can override. The confidence score communicates certainty; trade-off notes communicate nuance.

---

### 4.2 Algorithm Steps

#### Step 1: Decompose Task

Break the task into its constituent dimensions using the Four-Dimension Role Analysis framework (Section 6).

| Analysis | Question | Output |
|----------|----------|--------|
| **Cognitive** | What thinking style is required? | Processing dimension score |
| **Execution** | What is the interaction pattern? | Interaction dimension score |
| **Temporal** | What is the engagement model? | Duration dimension score |
| **Collaboration** | How does it relate to other tasks? | Boundary dimension score |

**Output:** Four-dimension profile for the task

---

#### Step 2: Score Against Roles

For each dimension, score how well each role template matches the task requirements.

**Scoring rubric per dimension:**

| Score | Meaning |
|-------|---------|
| **3** | Ideal match — role is designed for this pattern |
| **2** | Good match — role can handle this effectively |
| **1** | Partial match — role can do this but it's not optimal |
| **0** | Mismatch — role is poorly suited or explicitly conflicts |

**Example scoring for a code review task:**

| Role | Cognitive | Execution | Temporal | Collaboration | **Total** |
|------|-----------|-----------|----------|---------------|-----------|
| Analyst (ANA) | 3 | 1 | 2 | 1 | **7** |
| Critic (CRT) | 3 | 1 | 2 | 1 | **7** |
| Strategist (STG) | 1 | 1 | 1 | 1 | **4** |
| Auditor (AUD) | 2 | 1 | 1 | 2 | **6** |

---

#### Step 3: Apply Contextual Adjustments

After dimension scoring, apply contextual modifiers that adjust recommendations based on situational factors.

**Contextual adjustment factors:**

| Factor | When Applied | Adjustment |
|--------|--------------|------------|
| **Parallelism** | Multiple agents can work simultaneously | Prefer Composable roles |
| **Latency sensitivity** | Quick response needed | Prefer Pre-initialized roles |
| **Specialization depth** | Deep expertise required | Prefer Specialist roles |
| **Consistency need** | Same behavior across sessions | Prefer Singleton roles |
| **Failure isolation** | Need to contain failures | Prefer Auditor roles |
| **Knowledge transfer** | Cross-team learning needed | Prefer Bridge roles |

---

#### Step 4: Generate Recommendation

Produce the final recommendation with confidence scoring.

**Confidence levels:**

| Confidence | Range | Interpretation |
|------------|-------|----------------|
| **High** | 85-100% | Clear best choice; multiple dimensions align |
| **Medium** | 60-84% | Good fit; some trade-offs exist |
| **Low** | 40-59% | Marginal fit; significant trade-offs |
| **Uncertain** | <40% | No clear match; consider custom role or human review |

**Recommendation format:**

```yaml
recommendation:
  primary_role: <role_code>
  confidence: <percentage>
  justification: <why this role>
  trade_offs:
    - <dimension>: <what you gain>
    - <dimension>: <what you sacrifice>
  alternatives:
    - role: <alt_role_code>
      reason: <when to choose>
  overrides:
    - condition: <when to override>
      action: <what to do instead>
```

---

### 4.3 Example: API Endpoint Design Task

**Task:** Design the API schema for a new payment processing endpoint

**Step 1 — Decomposition:**
- **Cognitive:** Requires analytical breakdown of requirements + creative design of interface → *Hybrid: ANA + CRT*
- **Execution:** Requires external validation with stakeholders → *External*
- **Temporal:** Defined project milestone with review gates → *Milestone*
- **Collaboration:** Must integrate with existing payment system → *Integration*

**Step 2 — Scoring:**

| Role | Cog | Exec | Temp | Collab | Total |
|------|-----|------|------|--------|-------|
| Analyst (ANA) | 3 | 1 | 2 | 2 | 8 |
| Critic (CRT) | 2 | 2 | 1 | 1 | 6 |
| Designer (DSG) | 2 | 2 | 2 | 2 | 8 |
| **Architect (ARC)** | **3** | **2** | **2** | **3** | **10** |

**Step 3 — Contextual adjustments:**
- **Integration requirement** (+1 to Architect): Must align with existing payment architecture
- **Stakeholder review** (+1 to Critic): Design will face external scrutiny

**Step 4 — Recommendation:**

```yaml
recommendation:
  primary_role: ARC
  confidence: 92%
  justification: |
    Architect role optimally matches all four dimensions:
    - Cognitive: Deep analytical + design synthesis required
    - Execution: External stakeholder validation needed
    - Temporal: Milestone-driven with review gates
    - Collaboration: System integration is primary concern
  trade_offs:
    - speed: "Thorough design process takes longer than rapid prototyping"
    - flexibility: "Architecture decisions constrain future options"
  alternatives:
    - role: DSG
      reason: "If the focus is UX/interface over system integration"
    - role: ANA
      reason: "If requirements are unclear and analysis is primary need"
  overrides:
    - condition: "Existing API standards must be followed exactly"
      action: "Add AUD role for standards compliance review"
```

---

### 4.4 Confidence Score Calculation

The confidence score is computed as:

```
confidence = (dimension_score / max_possible) * 100

Where:
  dimension_score = sum of all dimension scores for recommended role
  max_possible    = 3 points * 4 dimensions = 12 (or 3 * N for N dimensions used)
```

**Example:**
- Architect scores: 3 + 2 + 2 + 3 = 10
- Max possible: 12
- Confidence: (10 / 12) * 100 = **83% (Medium-High)**

---

## Section 5: Dimension Combinations & Role Matrix

### 5.1 Overview

Individual dimension selections (from Section 6) combine to produce distinct role signatures. This section maps common and important combinations to concrete role definitions.

> **Key Insight:** Not all combinations are equally common or useful. This section catalogs **the 12 most important combinations** that cover ~90% of agent use cases. Rare or invalid combinations are noted but not given full role definitions.

---

### 5.2 Complete Dimension-to-Role Mapping

The following table maps all valid dimension combinations to role codes and names. Invalid combinations (marked ✗) produce no role.

| Cognitive | Execution | Temporal | Collaboration | Role Code | Role Name | Category |
|-----------|-----------|----------|---------------|-----------|-----------|----------|
| **Analytical** | Solo | Continuous | Independent | ANA | Analyst | Specialist |
| **Analytical** | Solo | Continuous | Integration | INT | Integrator | Specialist |
| **Analytical** | Solo | Milestone | Independent | RSC | Researcher | Specialist |
| **Analytical** | Solo | Milestone | Integration | AUD | Auditor | Specialist |
| **Analytical** | External | Continuous | Independent | MON | Monitor | Specialist |
| **Analytical** | External | Continuous | Integration | BRI | Bridge Analyst | Bridge |
| **Analytical** | External | Milestone | Independent | RPT | Reporter | Specialist |
| **Analytical** | External | Milestone | Integration | CSL | Consultant | Specialist |
| **Analytical** | Interactive | Continuous | Independent | CRT | Critic | Specialist |
| **Analytical** | Interactive | Continuous | Integration | REV | Reviewer | Specialist |
| **Analytical** | Interactive | Milestone | Independent | JUD | Judge | Specialist |
| **Analytical** | Interactive | Milestone | Integration | ARB | Arbiter | Specialist |
| **Creative** | Solo | Continuous | Independent | GEN | Generator | Specialist |
| **Creative** | Solo | Continuous | Integration | DSG | Designer | Specialist |
| **Creative** | Solo | Milestone | Independent | EXP | Explorer | Specialist |
| **Creative** | Solo | Milestone | Integration | ARC | Architect | Specialist |
| **Creative** | External | Continuous | Independent | WRI | Writer | Specialist |
| **Creative** | External | Continuous | Integration | BRI-C | Bridge Creative | Bridge |
| **Creative** | External | Milestone | Independent | AUT | Author | Specialist |
| **Creative** | External | Milestone | Integration | PRP | Preparer | Specialist |
| **Creative** | Interactive | Continuous | Independent | BRA | Brainstormer | Specialist |
| **Creative** | Interactive | Continuous | Integration | FAC | Facilitator | Coordinator |
| **Creative** | Interactive | Milestone | Independent | NGT | Negotiator | Specialist |
| **Creative** | Interactive | Milestone | Integration | MED | Mediator | Coordinator |
| **Directive** | Solo | Continuous | Independent | OPR | Operator | Specialist |
| **Directive** | Solo | Continuous | Integration | TEC | Technician | Specialist |
| **Directive** | Solo | Milestone | Independent | PLN | Planner | Specialist |
| **Directive** | Solo | Milestone | Integration | MGR | Manager | Coordinator |
| **Directive** | External | Continuous | Independent | DIR | Director | Coordinator |
| **Directive** | External | Continuous | Integration | COO | Coordinator | Coordinator |
| **Directive** | External | Milestone | Independent | LEAD | Leader | Coordinator |
| **Directive** | External | Milestone | Integration | ORC | Orchestrator | Coordinator |
| **Directive** | Interactive | Continuous | Independent | DRV | Driver | Specialist |
| **Directive** | Interactive | Continuous | Integration | SUP | Supervisor | Coordinator |
| **Directive** | Interactive | Milestone | Independent | CMD | Commander | Specialist |
| **Directive** | Interactive | Milestone | Integration | HND | Handler | Coordinator |
| **Synthesizing** | Solo | Continuous | Independent | SYN | Synthesizer | Specialist |
| **Synthesizing** | Solo | Continuous | Integration | BLN | Blender | Specialist |
| **Synthesizing** | Solo | Milestone | Independent | TH | Theorist | Specialist |
| **Synthesizing** | Solo | Milestone | Integration | STG | Strategist | Specialist |
| **Synthesizing** | External | Continuous | Independent | ADV | Advisor | Specialist |
| **Synthesizing** | External | Continuous | Integration | BRI-S | Bridge Synthesizer | Bridge |
| **Synthesizing** | External | Milestone | Independent | POL | Policymaker | Specialist |
| **Synthesizing** | External | Milestone | Integration | CON | Consultant-S | Specialist |
| **Synthesizing** | Interactive | Continuous | Independent | CCH | Coach | Coordinator |
| **Synthesizing** | Interactive | Continuous | Integration | MEN | Mentor | Coordinator |
| **Synthesizing** | Interactive | Milestone | Independent | GUI | Guide | Coordinator |
| **Synthesizing** | Interactive | Milestone | Integration | FAC-S | Facilitator-S | Coordinator |

> **Note:** ✗ combinations occur when dimension selections are logically incompatible (e.g., "Reactive" temporal + "Milestone" temporal selection).

---

### 5.3 The 12 Standard Roles (Primary Catalog)

These 12 roles cover approximately 90% of agent use cases. Each role includes full dimension signature, template, and usage guidance.

---

#### ANA — Analyst

| Attribute | Value |
|-----------|-------|
| **Category** | Specialist |
| **Dimensions** | Analytical · Solo · Continuous · Independent |
| **Strength** | Deep analytical processing without external dependencies |
| **Weakness** | Siloed; may miss integration context |

**Template:**

```yaml
role:
  code: ANA
  name: Analyst
  description: |
    Deep analytical processing agent. Excels at breaking down complex problems,
    identifying patterns, and producing structured insights. Works independently
    without requiring external interaction.
  
  dimensions:
    cognitive: analytical
    execution: solo
    temporal: continuous
    collaboration: independent
  
  capabilities:
    - data_analysis
    - pattern_recognition
    - structured_reasoning
    - report_generation
  
  limitations:
    - no_external_communication
    - no_real_time_collaboration
    - may_miss_system_context
  
  typical_tasks:
    - data analysis and interpretation
    - requirements decomposition
    - pattern identification in datasets
    - structured report writing
    - comparative analysis
  
  composability:
    can_lead: false
    can_follow: true
    can_parallelize: true
    notes: |
      Works well as a parallel analysis node in multi-agent systems.
      Output feeds into integrator or synthesizer roles.
```

**Usage guidance:**
- **Best for:** Data-heavy tasks, structured analysis, independent research
- **Combine with:** INT (for integration context), SYN (for synthesis), BRI (for stakeholder communication)
- **Avoid when:** Real-time collaboration needed, external stakeholder interaction required

---

#### CRT — Critic

| Attribute | Value |
|-----------|-------|
| **Category** | Specialist |
| **Dimensions** | Analytical · Interactive · Continuous · Independent |
| **Strength** | Rigorous evaluation and quality assurance |
| **Weakness** | Can be overly negative; may slow progress |

**Template:**

```yaml
role:
  code: CRT
  name: Critic
  description: |
    Rigorous evaluation agent. Provides critical analysis, identifies flaws,
    and ensures quality standards. Operates continuously with interactive
    feedback loops but maintains independence in judgment.
  
  dimensions:
    cognitive: analytical
    execution: interactive
    temporal: continuous
    collaboration: independent
  
  capabilities:
    - quality_assurance
    - flaw_identification
    - standards_verification
    - risk_assessment
    - constructive_feedback
  
  limitations:
    - tendency_toward_negativity
    - may_create_analysis_paralysis
    - not_solution_oriented
  
  typical_tasks:
    - code review
    - design evaluation
    - requirements validation
    - risk analysis
    - quality assessment
  
  composability:
    can_lead: false
    can_follow: true
    can_parallelize: true
    notes: |
      Essential in multi-agent quality gates. Should not work alone;
      pair with constructive roles (DSG, ARC) for balanced output.
```

**Usage guidance:**
- **Best for:** Quality gates, review processes, risk identification
- **Combine with:** DSG (for constructive balance), ARC (for design validation), STG (for strategic assessment)
- **Avoid when:** Generative work needed, positive/encouraging tone required

---

#### DSG — Designer

| Attribute | Value |
|-----------|-------|
| **Category** | Specialist |
| **Dimensions** | Creative · Solo · Continuous · Integration |
| **Strength** | Creative problem-solving with system awareness |
| **Weakness** | May over-engineer; can lose sight of constraints |

**Template:**

```yaml
role:
  code: DSG
  name: Designer
  description: |
    Creative design agent that produces novel solutions while maintaining
    awareness of system integration requirements. Works independently
    but considers how outputs connect to broader systems.
  
  dimensions:
    cognitive: creative
    execution: solo
    temporal: continuous
    collaboration: integration
  
  capabilities:
    - creative_problem_solving
    - system_aware_design
    - ux_ui_design
    - architecture_design
    - pattern_creation
  
  limitations:
    - may_over_engineer
    - can_exceed_constraints
    - iterative_refinement_needed
  
  typical_tasks:
    - user interface design
    - system architecture design
    - API design
    - workflow design
    - creative writing
  
  composability:
    can_lead: true
    can_follow: true
    can_parallelize: true
    notes: |
      Can lead design sessions or contribute as a parallel design node.
      Requires CRT or AUD for quality validation.
```

**Usage guidance:**
- **Best for:** Design tasks, creative problem-solving, architecture work
- **Combine with:** CRT (for quality validation), ARC (for system alignment), BRI (for stakeholder presentation)
- **Avoid when:** Strict adherence to existing patterns required, minimal creativity context

---

#### ARC — Architect

| Attribute | Value |
|-----------|-------|
| **Category** | Specialist |
| **Dimensions** | Creative · Solo · Milestone · Integration |
| **Strength** | System-level design with milestone-based delivery |
| **Weakness** | Slow for rapid iteration; may over-architect |

**Template:**

```yaml
role:
  code: ARC
  name: Architect
  description: |
    System-level design agent that produces comprehensive architectures
    delivered at defined milestones. Excels at balancing creative design
    with integration constraints and long-term maintainability.
  
  dimensions:
    cognitive: creative
    execution: solo
    temporal: milestone
    collaboration: integration
  
  capabilities:
    - system_architecture
    - technical_design
    - integration_planning
    - scalability_analysis
    - technology_selection
  
  limitations:
    - slow_iteration_cycle
    - may_over_architect
    - requires_clear_milestones
  
  typical_tasks:
    - system architecture design
    - technology stack selection
    - integration architecture
    - scalability planning
    - technical roadmap creation
  
  composability:
    can_lead: true
    can_follow: false
    can_parallelize: false
    notes: |
      Typically leads architecture workstreams. Cannot effectively follow
      other roles due to system-level ownership requirement.
```

**Usage guidance:**
- **Best for:** System architecture, technology decisions, integration design
- **Combine with:** TEC (for implementation detail), AUD (for standards compliance), STG (for strategic alignment)
- **Avoid when:** Rapid prototyping needed, narrow scope without system implications

---

#### STG — Strategist

| Attribute | Value |
|-----------|-------|
| **Category** | Specialist |
| **Dimensions** | Synthesizing · Solo · Milestone · Independent |
| **Strength** | Long-term strategic thinking with milestone-based delivery |
| **Weakness** | Can be abstract; may lack implementation detail |

**Template:**

```yaml
role:
  code: STG
  name: Strategist
  description: |
    Strategic thinking agent that synthesizes complex information into
    actionable long-term plans. Delivers milestone-based outputs with
    comprehensive strategic analysis.
  
  dimensions:
    cognitive: synthesizing
    execution: solo
    temporal: milestone
    collaboration: independent
  
  capabilities:
    - strategic_planning
    - trend_analysis
    - scenario_modeling
    - competitive_analysis
    - roadmap_development
  
  limitations:
    - abstract_output
    - lacks_implementation_detail
    - requires_translation_to_action
  
  typical_tasks:
    - strategic planning
    - market analysis
    - scenario planning
    - competitive positioning
    - long-term roadmap creation
  
  composability:
    can_lead: true
    can_follow: false
    can_parallelize: false
    notes: |
      Leads strategic workstreams. Output requires translation by
      operational roles (OPR, TEC, PLN) into executable plans.
```

**Usage guidance:**
- **Best for:** Strategic planning, long-term thinking, complex synthesis
- **Combine with:** OPR (for operational translation), ANA (for data foundation), MGR (for execution management)
- **Avoid when:** Immediate execution needed, concrete implementation required

---

#### AUD — Auditor

| Attribute | Value |
|-----------|-------|
| **Category** | Specialist |
| **Dimensions** | Analytical · Solo · Milestone · Integration |
| **Strength** | Rigorous compliance and standards verification |
| **Weakness** | Cannot create; only validates existing work |

**Template:**

```yaml
role:
  code: AUD
  name: Auditor
  description: |
    Compliance and standards verification agent. Provides rigorous
    audit of existing work against defined standards, policies, and
    requirements. Milestone-based delivery with full integration context.
  
  dimensions:
    cognitive: analytical
    execution: solo
    temporal: milestone
    collaboration: integration
  
  capabilities:
    - compliance_verification
    - standards_auditing
    - policy_validation
    - risk_identification
    - gap_analysis
  
  limitations:
    - cannot_create_content
    - only_validates_existing_work
    - requires_clear_standards
  
  typical_tasks:
    - compliance audits
    - standards verification
    - security review
    - policy adherence check
    - certification validation
  
  composability:
    can_lead: false
    can_follow: true
    can_parallelize: true
    notes: |
      Works as a quality gate following any production role.
      Cannot lead or create; only validates. Essential for
      regulated environments.
```

**Usage guidance:**
- **Best for:** Compliance verification, security review, standards validation
- **Combine with:** Any production role (follows them), MGR (for audit scheduling)
- **Avoid when:** Creative work needed, no standards exist to audit against

---

#### MGR — Manager

| Attribute | Value |
|-----------|-------|
| **Category** | Coordinator |
| **Dimensions** | Directive · Solo · Milestone · Integration |
| **Strength** | Project execution management with integration oversight |
| **Weakness** | Can become bureaucratic; may lose strategic sight |

**Template:**

```yaml
role:
  code: MGR
  name: Manager
  description: |
    Project management agent that oversees execution of milestone-based
    work with full integration awareness. Coordinates resources, tracks
    progress, and ensures delivery alignment.
  
  dimensions:
    cognitive: directive
    execution: solo
    temporal: milestone
    collaboration: integration
  
  capabilities:
    - project_management
    - resource_coordination
    - milestone_tracking
    - risk_management
    - status_reporting
  
  limitations:
    - bureaucratic_tendency
    - may_lose_strategic_sight
    - requires_clear_structure
  
  typical_tasks:
    - project planning
    - milestone tracking
    - resource allocation
    - status reporting
    - risk management
  
  composability:
    can_lead: true
    can_follow: true
    can_parallelize: false
    notes: |
      Can lead project workstreams or follow strategists for
      operational execution. Manages other agents in the system.
```

**Usage guidance:**
- **Best for:** Project management, milestone tracking, resource coordination
- **Combine with:** STG (for strategic direction), TEC (for technical execution), AUD (for compliance oversight)
- **Avoid when:** Strategic thinking needed, creative exploration required

---

#### DIR — Director

| Attribute | Value |
|-----------|-------|
| **Category** | Coordinator |
| **Dimensions** | Directive · External · Continuous · Independent |
| **Strength** | Executive decision-making with stakeholder communication |
| **Weakness** | High-level; lacks implementation detail |

**Template:**

```yaml
role:
  code: DIR
  name: Director
  description: |
    Executive decision-making agent that provides directional guidance
    and communicates with external stakeholders. Operates continuously
    with external focus while maintaining independent judgment.
  
  dimensions:
    cognitive: directive
    execution: external
    temporal: continuous
    collaboration: independent
  
  capabilities:
    - executive_decision_making
    - stakeholder_communication
    - direction_setting
    - priority_management
    - organizational_alignment
  
  limitations:
    - high_level_only
    - lacks_implementation_detail
    - requires_translation_layer
  
  typical_tasks:
    - executive briefings
    - stakeholder communication
    - priority setting
    - organizational alignment
    - strategic direction
  
  composability:
    can_lead: true
    can_follow: false
    can_parallelize: false
    notes: |
      Sits at the top of multi-agent hierarchies. Communicates
      externally but maintains independent strategic judgment.
      Cannot follow other roles due to executive positioning.
```

**Usage guidance:**
- **Best for:** Executive decision-making, stakeholder communication, direction setting
- **Combine with:** MGR (for operational management), STG (for strategic input), BRI (for external communication)
- **Avoid when:** Implementation detail needed, hands-on work required

---

#### COO — Coordinator

| Attribute | Value |
|-----------|-------|
| **Category** | Coordinator |
| **Dimensions** | Directive · External · Continuous · Integration |
| **Strength** | Cross-system coordination with continuous operation |
| **Weakness** | Coordination overhead; can become bottleneck |

**Template:**

```yaml
role:
  code: COO
  name: Coordinator
  description: |
    Cross-system coordination agent that manages continuous operations
    across integrated components. Ensures smooth inter-system communication
    and operational alignment.
  
  dimensions:
    cognitive: directive
    execution: external
    temporal: continuous
    collaboration: integration
  
  capabilities:
    - cross_system_coordination
    - operational_management
    - communication_routing
    - dependency_management
    - status_synchronization
  
  limitations:
    - coordination_overhead
    - potential_bottleneck
    - requires_clear_interfaces
  
  typical_tasks:
    - system integration coordination
    - operational monitoring
    - communication routing
    - dependency tracking
    - cross-team synchronization
  
  composability:
    can_lead: true
    can_follow: true
    can_parallelize: false
    notes: |
      Essential in multi-system environments. Can lead operational
      workstreams or follow executives (DIR) for operational translation.
      Is a natural bottleneck — monitor for overload.
```

**Usage guidance:**
- **Best for:** Cross-system coordination, operational management, communication routing
- **Combine with:** DIR (for direction), TEC (for technical operations), BRI (for inter-team communication)
- **Avoid when:** Single-system work, no integration complexity

---

#### ORC — Orchestrator

| Attribute | Value |
|-----------|-------|
| **Category** | Coordinator |
| **Dimensions** | Directive · External · Milestone · Integration |
| **Strength** | Complex multi-agent orchestration with milestone delivery |
| **Weakness** | Heavy overhead; requires sophisticated setup |

**Template:**

```yaml
role:
  code: ORC
  name: Orchestrator
  description: |
    Complex multi-agent orchestration agent that coordinates multiple
    agents and systems toward milestone-based deliverables. Manages
    dependencies, sequences work, and ensures integration coherence.
  
  dimensions:
    cognitive: directive
    execution: external
    temporal: milestone
    collaboration: integration
  
  capabilities:
    - multi_agent_orchestration
    - workflow_management
    - dependency_coordination
    - milestone_synchronization
    - integration_management
  
  limitations:
    - heavy_overhead
    - sophisticated_setup_required
    - single_point_of_failure
  
  typical_tasks:
    - multi-agent workflow orchestration
    - complex project coordination
    - dependency management
    - milestone synchronization
    - system integration orchestration
  
  composability:
    can_lead: true
    can_follow: false
    can_parallelize: false
    notes: |
      The ultimate coordination role. Leads entire multi-agent systems.
      Cannot follow other roles — sits at the apex of the coordination
      hierarchy. Single point of failure — consider backup strategies.
```

**Usage guidance:**
- **Best for:** Complex multi-agent systems, workflow orchestration, large-scale coordination
- **Combine with:** All roles (orchestrates them), DIR (for strategic direction), MGR (for project management)
- **Avoid when:** Simple single-agent tasks, low coordination complexity

---

#### BRI — Bridge

| Attribute | Value |
|-----------|-------|
| **Category** | Bridge |
| **Dimensions** | Analytical · External · Continuous · Integration |
| **Strength** | Cross-boundary communication with analytical depth |
| **Weakness** | Juggling act; may lack depth in any single domain |

**Template:**

```yaml
role:
  code: BRI
  name: Bridge
  description: |
    Cross-boundary communication agent that translates between domains,
    teams, or systems with analytical rigor. Operates continuously
    with external focus and full integration awareness.
  
  dimensions:
    cognitive: analytical
    execution: external
    temporal: continuous
    collaboration: integration
  
  capabilities:
    - cross_boundary_translation
    - stakeholder_communication
    - domain_bridge_building
    - requirements_reconciliation
    - communication_facilitation
  
  limitations:
    - juggling_multiple_domains
    - may_lack_domain_depth
    - context_switching_overhead
  
  typical_tasks:
    - cross-team communication
    - requirements translation
    - stakeholder management
    - domain bridging
    - communication facilitation
  
  composability:
    can_lead: false
    can_follow: true
    can_parallelize: true
    notes: |
      Works as a communication bridge between otherwise siloed
      agents or teams. Can parallelize across multiple boundaries
      simultaneously. Cannot lead — facilitates others' leadership.
```

**Usage guidance:**
- **Best for:** Cross-team communication, requirements translation, stakeholder management
- **Combine with:** ANA (for analytical depth), DIR (for executive communication), MGR (for project coordination)
- **Avoid when:** Deep domain expertise needed, single-team work

---

#### CCH — Coach

| Attribute | Value |
|-----------|-------|
| **Category** | Coordinator |
| **Dimensions** | Synthesizing · Interactive · Continuous · Independent |
| **Strength** | Continuous guidance with synthesizing insight |
| **Weakness** | Long-term commitment; slow initial results |

**Template:**

```yaml
role:
  code: CCH
  name: Coach
  description: |
    Continuous guidance agent that provides ongoing support through
    interactive sessions. Synthesizes insights from ongoing work to
    provide personalized guidance and development support.
  
  dimensions:
    cognitive: synthesizing
    execution: interactive
    temporal: continuous
    collaboration: independent
  
  capabilities:
    - ongoing_guidance
    - skill_development
    - performance_coaching
    - feedback_synthesis
    - continuous_improvement
  
  limitations:
    - long_term_commitment
    - slow_initial_results
    - requires_relationship_building
  
  typical_tasks:
    - ongoing coaching
    - skill development
    - performance improvement
    - feedback integration
    - continuous guidance
  
  composability:
    can_lead: false
    can_follow: true
    can_parallelize: false
    notes: |
      Works alongside other agents in a support capacity. Cannot
      lead workstreams but significantly enhances other agents'
      performance through continuous guidance. Long-term relationship
      required for effectiveness.
```

**Usage guidance:**
- **Best for:** Ongoing guidance, skill development, performance improvement
- **Combine with:** Any execution role (supports them), MEN (for mentorship), GUI (for guided tasks)
- **Avoid when:** One-time task, immediate results needed, no ongoing relationship

---

### 5.4 Role Selection Quick Reference

**By task type:**

| Task Type | Primary Role | Supporting Roles |
|-----------|-------------|------------------|
| Data analysis | ANA | INT, SYN |
| Code review | CRT | DSG, ARC |
| UI/UX design | DSG | CRT, ARC |
| System architecture | ARC | TEC, AUD |
| Strategic planning | STG | OPR, MGR |
| Compliance audit | AUD | MGR, DIR |
| Project management | MGR | TEC, AUD |
| Executive briefing | DIR | BRI, STG |
| System integration | COO | TEC, BRI |
| Multi-agent workflow | ORC | MGR, COO |
| Cross-team communication | BRI | ANA, DIR |
| Ongoing guidance | CCH | MEN, GUI |

---

## Section 6: Four-Dimension Role Analysis Framework

### 6.1 Overview

Every role is defined across **four independent dimensions**. No single dimension determines a role; the **combination** produces the complete behavioral signature.

> **Key Principle:** These dimensions are **orthogonal** — a role's position on one dimension does not constrain its position on another. This produces a rich combinatorial space of 4 × 3 × 3 × 3 = 108 theoretical combinations (of which ~48 are valid and ~12 are commonly used).

---

### 6.2 Dimension 1: Cognitive Processing Style

**Question:** *How does the agent process information and generate outputs?*

| Value | Code | Description | When to Use |
|-------|------|-------------|-------------|
| **Analytical** | `analytical` | Breaks down complex information, identifies patterns, produces structured insights | Data-heavy tasks, structured problem-solving, research |
| **Creative** | `creative` | Generates novel ideas, explores unconventional solutions, produces original output | Design tasks, brainstorming, innovation, artistic work |
| **Directive** | `directive` | Provides guidance, makes decisions, sets direction, prioritizes action | Leadership tasks, decision-making, crisis management |
| **Synthesizing** | `synthesizing` | Combines disparate information, finds connections, produces integrated understanding | Complex synthesis, strategic planning, cross-domain work |

**Selection guidance:**

```
IF task_requires_breaking_down_complex_data:
    → Analytical
ELIF task_requires_generating_novel_solutions:
    → Creative
ELIF task_requires_providing_guidance_or_decisions:
    → Directive
ELIF task_requires_combining_disparate_information:
    → Synthesizing
```

---

### 6.3 Dimension 2: Execution Interaction Pattern

**Question:** *How does the agent interact with its environment during execution?*

| Value | Code | Description | When to Use |
|-------|------|-------------|-------------|
| **Solo** | `solo` | Works independently, minimal external interaction, self-directed execution | Self-contained tasks, deep work, independent research |
| **External** | `external` | Communicates with external systems/entities, produces outputs for consumption | Stakeholder communication, system integration, reporting |
| **Interactive** | `interactive` | Engages in back-and-forth dialogue, responds to feedback in real-time | Collaborative tasks, pair programming, mentoring, negotiation |

**Selection guidance:**

```
IF task_is_self_contained_and_independent:
    → Solo
ELIF task_requires_external_communication_or_output:
    → External
ELIF task_requires_real_time_collaboration:
    → Interactive
```

---

### 6.4 Dimension 3: Temporal Engagement Model

**Question:** *What is the time pattern of the agent's engagement?*

| Value | Code | Description | When to Use |
|-------|------|-------------|-------------|
| **Continuous** | `continuous` | Ongoing, always-available engagement with no defined endpoint | Monitoring, coaching, real-time assistance, ambient intelligence |
| **Milestone** | `milestone` | Defined start and end points with deliverables at specific checkpoints | Projects, sprints, defined tasks with clear completion criteria |
| **Reactive** | `reactive` | Triggered by events or conditions, dormant between activations | Alert handling, incident response, exception management |

**Selection guidance:**

```
IF task_has_no_defined_endpoint_and_is_ongoing:
    → Continuous
ELIF task_has_defined_start_end_and_deliverables:
    → Milestone
ELIF task_is_triggered_by_events_or_conditions:
    → Reactive
```

---

### 6.5 Dimension 4: Collaboration Boundary

**Question:** *How does the agent relate to other agents and systems?*

| Value | Code | Description | When to Use |
|-------|------|-------------|-------------|
| **Independent** | `independent` | Operates autonomously, no dependency on other agents | Isolated tasks, competitive analysis, independent verification |
| **Integration** | `integration` | Works within a larger system, connects with other components | System components, pipeline stages, collaborative workflows |
| **Boundary-spanning** | `boundary` | Bridges across organizational or system boundaries | Cross-team work, stakeholder management, translation layers |

**Selection guidance:**

```
IF task_operates_in_isolation:
    → Independent
ELIF task_connects_to_other_systems_or_agents:
    → Integration
ELIF task_spans_across_boundaries:
    → Boundary
```

---

### 6.6 Combining Dimensions

Dimensions are combined in order:

```
Role Signature = Cognitive + Execution + Temporal + Collaboration

Example:
  Analytical + Solo + Continuous + Independent = ANA (Analyst)
  Creative + Solo + Milestone + Integration = ARC (Architect)
  Directive + External + Milestone + Integration = ORC (Orchestrator)
```

**Validation rules for combinations:**

| Rule | Invalid Combination | Reason |
|------|---------------------|--------|
| Temporal "Reactive" + Collaboration "Boundary" | ✗ | Reactive roles cannot span boundaries |
| Cognitive "Directive" + Execution "Solo" + Temporal "Reactive" | ✗ | Directive reactive roles require external or interactive execution |
| Temporal "Continuous" + Execution "Solo" + Collaboration "Boundary" | ✗ | Boundary-spanning requires external interaction |

---

### 6.7 Dimension Selection Worksheet

Use this worksheet to determine dimension values for a new task:

```
TASK: ___________________________________________________

1. COGNITIVE PROCESSING:
   [ ] The task requires breaking down complex information
   [ ] The task requires generating novel ideas
   [ ] The task requires providing guidance or decisions
   [ ] The task requires combining disparate information
   → Selection: _______________

2. EXECUTION INTERACTION:
   [ ] The task is self-contained and independent
   [ ] The task requires external communication or output
   [ ] The task requires real-time collaboration
   → Selection: _______________

3. TEMPORAL ENGAGEMENT:
   [ ] The task has no defined endpoint and is ongoing
   [ ] The task has defined start/end and deliverables
   [ ] The task is triggered by events or conditions
   → Selection: _______________

4. COLLABORATION BOUNDARY:
   [ ] The task operates in isolation
   [ ] The task connects to other systems or agents
   [ ] The task spans across organizational boundaries
   → Selection: _______________

ROLE SIGNATURE: _______________ + _______________ + _______________ + _______________
MATCHING ROLE: _______________
```

---

## Section 7: Standard Role Catalog

### 7.1 Overview

The Standard Role Catalog provides **12 complete, production-ready role definitions** organized into **4 categories**. Each role includes a YAML template, usage guidance, composability notes, and real-world examples.

> **Coverage:** These 12 roles address approximately **90% of common agent use cases**. For specialized needs, use the Dynamic Role Builder (Section 7.6) or the Four-Dimension Framework (Section 6) to create custom roles.

---

### 7.2 Category: Specialists (6 roles)

Specialists excel at **specific, focused tasks**. They are the workhorses of agent systems — deep expertise in narrow domains.

---

#### ANA — Analyst

| Attribute | Value |
|-----------|-------|
| **Category** | Specialist |
| **Tagline** | *"Deep analytical processing without external dependencies"* |
| **Dimensions** | Analytical · Solo · Continuous · Independent |
| **Use frequency** | Very High (~25% of tasks) |

**Full Template:**

```yaml
role:
  code: ANA
  name: Analyst
  version: "1.0"
  description: |
    Deep analytical processing agent. Excels at breaking down complex problems,
    identifying patterns, and producing structured insights. Works independently
    without requiring external interaction. The foundation of data-driven
    decision-making in agent systems.
  
  dimensions:
    cognitive: analytical
    execution: solo
    temporal: continuous
    collaboration: independent
  
  capabilities:
    - data_analysis
    - pattern_recognition
    - structured_reasoning
    - report_generation
    - comparative_analysis
    - statistical_analysis
    - requirements_decomposition
  
  limitations:
    - no_external_communication
    - no_real_time_collaboration
    - may_miss_system_context
    - can_produce_analysis_paralysis
  
  typical_tasks:
    - data analysis and interpretation
    - requirements decomposition
    - pattern identification in datasets
    - structured report writing
    - comparative analysis
    - feasibility analysis
    - trend identification
  
  input_format:
    - raw_data
    - structured_queries
    - analysis_requirements
  
  output_format:
    - structured_reports
    - analysis_summaries
    - pattern_identifications
    - recommendations
  
  composability:
    can_lead: false
    can_follow: true
    can_parallelize: true
    preferred_partners:
      - INT
      - SYN
      - BRI
    notes: |
      Works well as a parallel analysis node in multi-agent systems.
      Output feeds into integrator or synthesizer roles. Cannot lead
      workstreams but is essential for data foundation.
  
  examples:
    - "Analyze user behavior data to identify churn patterns"
    - "Decompose enterprise requirements into technical specifications"
    - "Compare three cloud provider offerings across 15 dimensions"
    - "Identify security vulnerabilities in codebase analysis"
```

**Usage Guidance:**

| Aspect | Guidance |
|--------|----------|
| **Best for** | Data-heavy tasks, structured analysis, independent research |
| **Combine with** | INT (integration context), SYN (synthesis), BRI (stakeholder communication) |
| **Avoid when** | Real-time collaboration needed, external stakeholder interaction required |
| **Scaling** | Highly parallelizable — deploy multiple ANA agents for different data slices |

---

#### CRT — Critic

| Attribute | Value |
|-----------|-------|
| **Category** | Specialist |
| **Tagline** | *"Rigorous evaluation and quality assurance"* |
| **Dimensions** | Analytical · Interactive · Continuous · Independent |
| **Use frequency** | High (~15% of tasks) |

**Full Template:**

```yaml
role:
  code: CRT
  name: Critic
  version: "1.0"
  description: |
    Rigorous evaluation agent. Provides critical analysis, identifies flaws,
    and ensures quality standards. Operates continuously with interactive
    feedback loops but maintains independence in judgment. Essential for
    quality gates and risk management.
  
  dimensions:
    cognitive: analytical
    execution: interactive
    temporal: continuous
    collaboration: independent
  
  capabilities:
    - quality_assurance
    - flaw_identification
    - standards_verification
    - risk_assessment
    - constructive_feedback
    - peer_review
    - compliance_checking
  
  limitations:
    - tendency_toward_negativity
    - may_create_analysis_paralysis
    - not_solution_oriented
    - can_demotivate_if_unbalanced
  
  typical_tasks:
    - code review
    - design evaluation
    - requirements_validation
    - risk_analysis
    - quality_assessment
    - peer_review
    - standards_compliance_check
  
  input_format:
    - work_products
    - design_documents
    - code_changes
    - requirements_specs
  
  output_format:
    - review_reports
    - issue_identifications
    - risk_assessments
    - improvement_recommendations
  
  composability:
    can_lead: false
    can_follow: true
    can_parallelize: true
    preferred_partners:
      - DSG
      - ARC
      - STG
    notes: |
      Essential in multi-agent quality gates. Should not work alone;
      pair with constructive roles (DSG, ARC) for balanced output.
      Multiple CRT agents can review different aspects in parallel.
  
  examples:
    - "Review pull request for code quality and security issues"
    - "Evaluate API design against REST principles"
    - "Assess project plan for risk factors"
    - "Validate requirements document for completeness"
```

**Usage Guidance:**

| Aspect | Guidance |
|--------|----------|
| **Best for** | Quality gates, review processes, risk identification |
| **Combine with** | DSG (constructive balance), ARC (design validation), STG (strategic assessment) |
| **Avoid when** | Generative work needed, positive/encouraging tone required |
| **Scaling** | Parallelize by review dimension — one CRT per aspect (security, performance, UX) |

---

#### DSG — Designer

| Attribute | Value |
|-----------|-------|
| **Category** | Specialist |
| **Tagline** | *"Creative problem-solving with system awareness"* |
| **Dimensions** | Creative · Solo · Continuous · Integration |
| **Use frequency** | High (~15% of tasks) |

**Full Template:**

```yaml
role:
  code: DSG
  name: Designer
  version: "1.0"
  description: |
    Creative design agent that produces novel solutions while maintaining
    awareness of system integration requirements. Works independently
    but considers how outputs connect to broader systems. Bridges
    creativity and engineering.
  
  dimensions:
    cognitive: creative
    execution: solo
    temporal: continuous
    collaboration: integration
  
  capabilities:
    - creative_problem_solving
    - system_aware_design
    - ux_ui_design
    - architecture_design
    - pattern_creation
    - prototype_design
    - design_system_management
  
  limitations:
    - may_over_engineer
    - can_exceed_constraints
    - iterative_refinement_needed
    - may_miss_user_perspective
  
  typical_tasks:
    - user interface design
    - system architecture design
    - API design
    - workflow design
    - creative writing
    - design system creation
    - prototyping
  
  input_format:
    - design_briefs
    - constraints_and_requirements
    - reference_designs
    - user_personas
  
  output_format:
    - design_documents
    - wireframes
    - architecture_diagrams
    - design_specifications
  
  composability:
    can_lead: true
    can_follow: true
    can_parallelize: true
    preferred_partners:
      - CRT
      - ARC
      - BRI
    notes: |
      Can lead design sessions or contribute as a parallel design node.
      Requires CRT or AUD for quality validation. Works well with ARC
      for system-level design coherence.
  
  examples:
    - "Design the user interface for a mobile banking app"
    - "Create API schema for microservices communication"
    - "Design the data model for an e-commerce platform"
    - "Develop brand identity and visual design system"
```

**Usage Guidance:**

| Aspect | Guidance |
|--------|----------|
| **Best for** | Design tasks, creative problem-solving, architecture work |
| **Combine with** | CRT (quality validation), ARC (system alignment), BRI (stakeholder presentation) |
| **Avoid when** | Strict adherence to existing patterns required, minimal creativity context |
| **Scaling** | Parallelize design explorations — multiple DSG agents for different approaches |

---

#### ARC — Architect

| Attribute | Value |
|-----------|-------|
| **Category** | Specialist |
| **Tagline** | *"System-level design with milestone-based delivery"* |
| **Dimensions** | Creative · Solo · Milestone · Integration |
| **Use frequency** | Medium-High (~10% of tasks) |

**Full Template:**

```yaml
role:
  code: ARC
  name: Architect
  version: "1.0"
  description: |
    System-level design agent that produces comprehensive architectures
    delivered at defined milestones. Excels at balancing creative design
    with integration constraints and long-term maintainability. The
    strategic thinker of technical design.
  
  dimensions:
    cognitive: creative
    execution: solo
    temporal: milestone
    collaboration: integration
  
  capabilities:
    - system_architecture
    - technical_design
    - integration_planning
    - scalability_analysis
    - technology_selection
    - design_pattern_application
    - technical_debt_assessment
  
  limitations:
    - slow_iteration_cycle
    - may_over_architect
    - requires_clear_milestones
    - can_be_costly_to_change_course
  
  typical_tasks:
    - system architecture design
    - technology stack selection
    - integration architecture
    - scalability planning
    - technical roadmap creation
    - design_pattern_selection
    - platform_evaluation
  
  input_format:
    - requirements_documents
    - constraint_specifications
    - scalability_requirements
    - integration_requirements
  
  output_format:
    - architecture_documents
    - technology_decision_records
    - integration_diagrams
    - technical_roadmaps
  
  composability:
    can_lead: true
    can_follow: false
    can_parallelize: false
    preferred_partners:
      - TEC
      - AUD
      - STG
    notes: |
      Typically leads architecture workstreams. Cannot effectively follow
      other roles due to system-level ownership requirement. Partners with
      TEC for implementation feasibility and AUD for standards compliance.
  
  examples:
    - "Design microservices architecture for e-commerce platform"
    - "Create data architecture for real-time analytics system"
    - "Select cloud-native technology stack for greenfield project"
    - "Design integration architecture for ERP consolidation"
```

**Usage Guidance:**

| Aspect | Guidance |
|--------|----------|
| **Best for** | System architecture, technology decisions, integration design |
| **Combine with** | TEC (implementation detail), AUD (standards compliance), STG (strategic alignment) |
| **Avoid when** | Rapid prototyping needed, narrow scope without system implications |
| **Scaling** | Not parallelizable — single ARC per system for coherence |

---

#### STG — Strategist

| Attribute | Value |
|-----------|-------|
| **Category** | Specialist |
| **Tagline** | *"Long-term strategic thinking with milestone-based delivery"* |
| **Dimensions** | Synthesizing · Solo · Milestone · Independent |
| **Use frequency** | Medium (~8% of tasks) |

**Full Template:**

```yaml
role:
  code: STG
  name: Strategist
  version: "1.0"
  description: |
    Strategic thinking agent that synthesizes complex information into
    actionable long-term plans. Delivers milestone-based outputs with
    comprehensive strategic analysis. The executive thinking partner
    for complex decisions.
  
  dimensions:
    cognitive: synthesizing
    execution: solo
    temporal: milestone
    collaboration: independent
  
  capabilities:
    - strategic_planning
    - trend_analysis
    - scenario_modeling
    - competitive_analysis
    - roadmap_development
    - market_analysis
    - opportunity_assessment
  
  limitations:
    - abstract_output
    - lacks_implementation_detail
    - requires_translation_to_action
    - can_be_overwhelmed_by_detail
  
  typical_tasks:
    - strategic planning
    - market analysis
    - scenario planning
    - competitive positioning
    - long-term roadmap creation
    - investment_analysis
    - partnership_evaluation
  
  input_format:
    - market_data
    - competitive_landscape
    - internal_capabilities
    - strategic_questions
  
  output_format:
    - strategic_plans
    - scenario_analyses
    - competitive_assessments
    - roadmap_documents
  
  composability:
    can_lead: true
    can_follow: false
    can_parallelize: false
    preferred_partners:
      - OPR
      - ANA
      - MGR
    notes: |
      Leads strategic workstreams. Output requires translation by
      operational roles (OPR, TEC, PLN) into executable plans.
      Cannot follow — sets direction rather than executes.
  
  examples:
    - "Develop 3-year product strategy for SaaS platform"
    - "Analyze market entry options for European expansion"
    - "Create scenario plan for supply chain disruption"
    - "Assess competitive positioning in AI tooling market"
```

**Usage Guidance:**

| Aspect | Guidance |
|--------|----------|
| **Best for** | Strategic planning, long-term thinking, complex synthesis |
| **Combine with** | OPR (operational translation), ANA (data foundation), MGR (execution management) |
| **Avoid when** | Immediate execution needed, concrete implementation required |
| **Scaling** | Not parallelizable — single STG per strategic domain for coherence |

---

#### AUD — Auditor

| Attribute | Value |
|-----------|-------|
| **Category** | Specialist |
| **Tagline** | *"Rigorous compliance and standards verification"* |
| **Dimensions** | Analytical · Solo · Milestone · Integration |
| **Use frequency** | Medium (~8% of tasks) |

**Full Template:**

```yaml
role:
  code: AUD
  name: Auditor
  version: "1.0"
  description: |
    Compliance and standards verification agent. Provides rigorous
    audit of existing work against defined standards, policies, and
    requirements. Milestone-based delivery with full integration context.
    Essential for regulated and safety-critical environments.
  
  dimensions:
    cognitive: analytical
    execution: solo
    temporal: milestone
    collaboration: integration
  
  capabilities:
    - compliance_verification
    - standards_auditing
    - policy_validation
    - risk_identification
    - gap_analysis
    - certification_validation
    - security_assessment
  
  limitations:
    - cannot_create_content
    - only_validates_existing_work
    - requires_clear_standards
    - can_be_overly_prescriptive
  
  typical_tasks:
    - compliance audits
    - standards verification
    - security review
    - policy adherence check
    - certification validation
    - gap_analysis
    - risk_assessment
  
  input_format:
    - work_products
    - standards_documents
    - policies
    - compliance_requirements
  
  output_format:
    - audit_reports
    - compliance_assessments
    - gap_analyses
    - risk_registers
  
  composability:
    can_lead: false
    can_follow: true
    can_parallelize: true
    preferred_partners:
      - MGR
      - DIR
      - All_production_roles
    notes: |
      Works as a quality gate following any production role.
      Cannot lead or create; only validates. Essential for
      regulated environments. Parallelize by audit dimension.
  
  examples:
    - "Audit codebase for SOC 2 compliance requirements"
    - "Verify API implementation against OpenAPI specification"
    - "Assess data handling for GDPR compliance"
    - "Validate security controls against NIST framework"
```

**Usage Guidance:**

| Aspect | Guidance |
|--------|----------|
| **Best for** | Compliance verification, security review, standards validation |
| **Combine with** | Any production role (follows them), MGR (for audit scheduling) |
| **Avoid when** | Creative work needed, no standards exist to audit against |
| **Scaling** | Highly parallelizable — one AUD per standard/domain |

---

### 7.3 Category: Coordinators (4 roles)

Coordinators excel at **managing, directing, and orchestrating** other agents and systems. They provide the structural backbone of multi-agent systems.

---

#### MGR — Manager

| Attribute | Value |
|-----------|-------|
| **Category** | Coordinator |
| **Tagline** | *"Project execution management with integration oversight"* |
| **Dimensions** | Directive · Solo · Milestone · Integration |
| **Use frequency** | High (~12% of tasks) |

**Full Template:**

```yaml
role:
  code: MGR
  name: Manager
  version: "1.0"
  description: |
    Project management agent that oversees execution of milestone-based
    work with full integration awareness. Coordinates resources, tracks
    progress, and ensures delivery alignment. The operational backbone
    of multi-agent projects.
  
  dimensions:
    cognitive: directive
    execution: solo
    temporal: milestone
    collaboration: integration
  
  capabilities:
    - project_management
    - resource_coordination
    - milestone_tracking
    - risk_management
    - status_reporting
    - dependency_management
    - timeline_optimization
  
  limitations:
    - bureaucratic_tendency
    - may_lose_strategic_sight
    - requires_clear_structure
    - can_become_reporting_burden
  
  typical_tasks:
    - project planning
    - milestone tracking
    - resource allocation
    - status reporting
    - risk management
    - dependency tracking
    - timeline management
  
  input_format:
    - project_requirements
    - resource_constraints
    - milestone_definitions
    - risk_registers
  
  output_format:
    - project_plans
    - status_reports
    - risk_assessments
    - resource_allocations
  
  composability:
    can_lead: true
    can_follow: true
    can_parallelize: false
    preferred_partners:
      - STG
      - TEC
      - AUD
    notes: |
      Can lead project workstreams or follow strategists for
      operational execution. Manages other agents in the system.
      Cannot parallelize — single MGR per project for coherence.
  
  examples:
    - "Manage sprint execution for 5-agent development team"
    - "Coordinate resources across parallel workstreams"
    - "Track milestones and escalate risks for product launch"
    - "Manage cross-functional project with 8 dependencies"
```

**Usage Guidance:**

| Aspect | Guidance |
|--------|----------|
| **Best for** | Project management, milestone tracking, resource coordination |
| **Combine with** | STG (strategic direction), TEC (technical execution), AUD (compliance oversight) |
| **Avoid when** | Strategic thinking needed, creative exploration required |
| **Scaling** | One MGR per project; sub-projects may have deputy MGRs |

---

#### DIR — Director

| Attribute | Value |
|-----------|-------|
| **Category** | Coordinator |
| **Tagline** | *"Executive decision-making with stakeholder communication"* |
| **Dimensions** | Directive · External · Continuous · Independent |
| **Use frequency** | Medium (~6% of tasks) |

**Full Template:**

```yaml
role:
  code: DIR
  name: Director
  version: "1.0"
  description: |
    Executive decision-making agent that provides directional guidance
    and communicates with external stakeholders. Operates continuously
    with external focus while maintaining independent judgment. The
    strategic voice of the multi-agent system.
  
  dimensions:
    cognitive: directive
    execution: external
    temporal: continuous
    collaboration: independent
  
  capabilities:
    - executive_decision_making
    - stakeholder_communication
    - direction_setting
    - priority_management
    - organizational_alignment
    - vision_communication
    - executive_briefing
  
  limitations:
    - high_level_only
    - lacks_implementation_detail
    - requires_translation_layer
    - can_be_disconnected_from_reality
  
  typical_tasks:
    - executive briefings
    - stakeholder communication
    - priority setting
    - organizational alignment
    - strategic direction
    - vision_articulation
    - decision_authorization
  
  input_format:
    - strategic_options
    - performance_data
    - stakeholder_feedback
    - market_intelligence
  
  output_format:
    - strategic_directives
    - priority_frameworks
    - stakeholder_communications
    - decision_records
  
  composability:
    can_lead: true
    can_follow: false
    can_parallelize: false
    preferred_partners:
      - MGR
      - STG
      - BRI
    notes: |
      Sits at the top of multi-agent hierarchies. Communicates
      externally but maintains independent strategic judgment.
      Cannot follow other roles due to executive positioning.
  
  examples:
    - "Provide executive summary of quarterly agent performance"
    - "Set strategic priorities for upcoming product cycle"
    - "Communicate roadmap to external stakeholders"
    - "Authorize resource reallocation for critical initiative"
```

**Usage Guidance:**

| Aspect | Guidance |
|--------|----------|
| **Best for** | Executive decision-making, stakeholder communication, direction setting |
| **Combine with** | MGR (operational management), STG (strategic input), BRI (external communication) |
| **Avoid when** | Implementation detail needed, hands-on work required |
| **Scaling** | Single DIR per organizational unit |

---

#### COO — Coordinator

| Attribute | Value |
|-----------|-------|
| **Category** | Coordinator |
| **Tagline** | *"Cross-system coordination with continuous operation"* |
| **Dimensions** | Directive · External · Continuous · Integration |
| **Use frequency** | Medium (~6% of tasks) |

**Full Template:**

```yaml
role:
  code: COO
  name: Coordinator
  version: "1.0"
  description: |
    Cross-system coordination agent that manages continuous operations
    across integrated components. Ensures smooth inter-system communication
    and operational alignment. The nervous system of multi-system
    agent deployments.
  
  dimensions:
    cognitive: directive
    execution: external
    temporal: continuous
    collaboration: integration
  
  capabilities:
    - cross_system_coordination
    - operational_management
    - communication_routing
    - dependency_management
    - status_synchronization
    - event_handling
    - health_monitoring
  
  limitations:
    - coordination_overhead
    - potential_bottleneck
    - requires_clear_interfaces
    - can_cascade_failures
  
  typical_tasks:
    - system integration coordination
    - operational monitoring
    - communication routing
    - dependency tracking
    - cross-team synchronization
    - event_coordination
    - health_check_management
  
  input_format:
    - system_statuses
    - event_streams
    - dependency_maps
    - operational_metrics
  
  output_format:
    - coordination_logs
    - status_synchronizations
    - event_routings
    - health_reports
  
  composability:
    can_lead: true
    can_follow: true
    can_parallelize: false
    preferred_partners:
      - DIR
      - TEC
      - BRI
    notes: |
      Essential in multi-system environments. Can lead operational
      workstreams or follow executives (DIR) for operational translation.
      Is a natural bottleneck — monitor for overload.
  
  examples:
    - "Coordinate data flow between CRM, ERP, and analytics systems"
    - "Manage real-time synchronization across microservices"
    - "Route alerts to appropriate response teams"
    - "Monitor cross-system health and coordinate failover"
```

**Usage Guidance:**

| Aspect | Guidance |
|--------|----------|
| **Best for** | Cross-system coordination, operational management, communication routing |
| **Combine with** | DIR (for direction), TEC (for technical operations), BRI (for inter-team communication) |
| **Avoid when** | Single-system work, no integration complexity |
| **Scaling** | Single COO per integration domain; consider backup |

---

#### ORC — Orchestrator

| Attribute | Value |
|-----------|-------|
| **Category** | Coordinator |
| **Tagline** | *"Complex multi-agent orchestration with milestone delivery"* |
| **Dimensions** | Directive · External · Milestone · Integration |
| **Use frequency** | Low-Medium (~4% of tasks) |

**Full Template:**

```yaml
role:
  code: ORC
  name: Orchestrator
  version: "1.0"
  description: |
    Complex multi-agent orchestration agent that coordinates multiple
    agents and systems toward milestone-based deliverables. Manages
    dependencies, sequences work, and ensures integration coherence.
    The conductor of the multi-agent symphony.
  
  dimensions:
    cognitive: directive
    execution: external
    temporal: milestone
    collaboration: integration
  
  capabilities:
    - multi_agent_orchestration
    - workflow_management
    - dependency_coordination
    - milestone_synchronization
    - integration_management
    - conflict_resolution
    - resource_orchestration
  
  limitations:
    - heavy_overhead
    - sophisticated_setup_required
    - single_point_of_failure
    - requires_expert_configuration
  
  typical_tasks:
    - multi-agent workflow orchestration
    - complex project coordination
    - dependency management
    - milestone synchronization
    - system integration orchestration
    - conflict_resolution
    - resource_optimization
  
  input_format:
    - workflow_definitions
    - agent_capabilities
    - dependency_graphs
    - milestone_specifications
  
  output_format:
    - orchestration_plans
    - execution_sequences
    - synchronization_schedules
    - integration_manifests
  
  composability:
    can_lead: true
    can_follow: false
    can_parallelize: false
    preferred_partners:
      - All_roles
      - DIR
      - MGR
    notes: |
      The ultimate coordination role. Leads entire multi-agent systems.
      Cannot follow other roles — sits at the apex of the coordination
      hierarchy. Single point of failure — consider backup strategies.
  
  examples:
    - "Orchestrate 12-agent workflow for product launch"
    - "Manage complex CI/CD pipeline across 5 environments"
    - "Coordinate multi-vendor integration project"
    - "Orchestrate disaster recovery workflow across systems"
```

**Usage Guidance:**

| Aspect | Guidance |
|--------|----------|
| **Best for** | Complex multi-agent systems, workflow orchestration, large-scale coordination |
| **Combine with** | All roles (orchestrates them), DIR (for strategic direction), MGR (for project management) |
| **Avoid when** | Simple single-agent tasks, low coordination complexity |
| **Scaling** | Single ORC per major workflow; backup ORC recommended |

---

### 7.4 Category: Bridge Roles (2 roles)

Bridge roles excel at **crossing boundaries** — between teams, systems, domains, or organizations. They are the diplomatic corps of agent systems.

---

#### BRI — Bridge

| Attribute | Value |
|-----------|-------|
| **Category** | Bridge |
| **Tagline** | *"Cross-boundary communication with analytical depth"* |
| **Dimensions** | Analytical · External · Continuous · Integration |
| **Use frequency** | Medium (~6% of tasks) |

**Full Template:**

```yaml
role:
  code: BRI
  name: Bridge
  version: "1.0"
  description: |
    Cross-boundary communication agent that translates between domains,
    teams, or systems with analytical rigor. Operates continuously
    with external focus and full integration awareness. The diplomatic
    translator of agent systems.
  
  dimensions:
    cognitive: analytical
    execution: external
    temporal: continuous
    collaboration: integration
  
  capabilities:
    - cross_boundary_translation
    - stakeholder_communication
    - domain_bridge_building
    - requirements_reconciliation
    - communication_facilitation
    - context_switching
    - terminology_alignment
  
  limitations:
    - juggling_multiple_domains
    - may_lack_domain_depth
    - context_switching_overhead
    - can_misinterpret_nuances
  
  typical_tasks:
    - cross-team communication
    - requirements translation
    - stakeholder management
    - domain bridging
    - communication facilitation
    - terminology_standardization
    - cultural_translation
  
  input_format:
    - domain_specific_inputs
    - stakeholder_communications
    - requirements_from_multiple_sources
    - terminology_glossaries
  
  output_format:
    - translated_requirements
    - alignment_documents
    - communication_summaries
    - reconciliation_reports
  
  composability:
    can_lead: false
    can_follow: true
    can_parallelize: true
    preferred_partners:
      - ANA
      - DIR
      - MGR
    notes: |
      Works as a communication bridge between otherwise siloed
      agents or teams. Can parallelize across multiple boundaries
      simultaneously. Cannot lead — facilitates others' leadership.
  
  examples:
    - "Translate business requirements to technical specifications"
    - "Facilitate communication between engineering and product teams"
    - "Align terminology across acquired company systems"
    - "Bridge communication between onshore and offshore teams"
```

**Usage Guidance:**

| Aspect | Guidance |
|--------|----------|
| **Best for** | Cross-team communication, requirements translation, stakeholder management |
| **Combine with** | ANA (for analytical depth), DIR (for executive communication), MGR (for project coordination) |
| **Avoid when** | Deep domain expertise needed, single-team work |
| **Scaling** | One BRI per boundary pair; can parallelize across multiple boundaries |

---

#### BRI-C — Bridge Creative

| Attribute | Value |
|-----------|-------|
| **Category** | Bridge |
| **Tagline** | *"Cross-boundary creative communication"* |
| **Dimensions** | Creative · External · Continuous · Integration |
| **Use frequency** | Low (~2% of tasks) |

**Full Template:**

```yaml
role:
  code: BRI-C
  name: Bridge Creative
  version: "1.0"
  description: |
    Cross-boundary creative communication agent that translates creative
    vision between domains, teams, or systems. Bridges the gap between
    creative and technical teams with empathy for both perspectives.
    The creative diplomat of agent systems.
  
  dimensions:
    cognitive: creative
    execution: external
    temporal: continuous
    collaboration: integration
  
  capabilities:
    - creative_translation
    - vision_communication
    - design_thought_bridge
    - creative_facilitation
    - concept_reconciliation
    - aesthetic_alignment
    - creative_collaboration
  
  limitations:
    - may_favor_creative_perspective
    - can_lose_technical_accuracy
    - context_switching_overhead
    - may_create_unrealistic_expectations
  
  typical_tasks:
    - translate creative vision to technical constraints
    - facilitate design-engineering collaboration
    - align aesthetic goals with implementation reality
    - bridge user experience and development perspectives
    - reconcile creative differences between teams
  
  input_format:
    - creative_briefs
    - technical_constraints
    - design_references
    - stakeholder_feedback
  
  output_format:
    - translated_creative_briefs
    - alignment_proposals
    - collaboration_frameworks
    - feasibility_assessments
  
  composability:
    can_lead: false
    can_follow: true
    can_parallelize: true
    preferred_partners:
      - DSG
      - TEC
      - DIR
    notes: |
      Specialized bridge for creative-technical boundaries.
      Works between design and engineering teams. Can parallelize
      across multiple creative-technical boundaries.
  
  examples:
    - "Translate UX vision to implementable component specifications"
    - "Bridge brand creative direction with development constraints"
    - "Facilitate design sprint between designers and engineers"
    - "Align marketing creative with technical platform capabilities"
```

**Usage Guidance:**

| Aspect | Guidance |
|--------|----------|
| **Best for** | Creative-technical translation, design-engineering alignment |
| **Combine with** | DSG (design input), TEC (technical input), DIR (executive alignment) |
| **Avoid when** | Purely analytical work, no creative dimension |
| **Scaling** | One BRI-C per creative-technical boundary |

---

### 7.5 Complete Role Summary Table

| Code | Name | Category | Dimensions | Frequency | Best For |
|------|------|----------|------------|-----------|----------|
| **ANA** | Analyst | Specialist | Analytical · Solo · Continuous · Independent | 25% | Data analysis, pattern recognition |
| **CRT** | Critic | Specialist | Analytical · Interactive · Continuous · Independent | 15% | Quality assurance, review |
| **DSG** | Designer | Specialist | Creative · Solo · Continuous · Integration | 15% | Creative design, problem-solving |
| **ARC** | Architect | Specialist | Creative · Solo · Milestone · Integration | 10% | System architecture, design |
| **STG** | Strategist | Specialist | Synthesizing · Solo · Milestone · Independent | 8% | Strategic planning, synthesis |
| **AUD** | Auditor | Specialist | Analytical · Solo · Milestone · Integration | 8% | Compliance, standards verification |
| **MGR** | Manager | Coordinator | Directive · Solo · Milestone · Integration | 12% | Project management, execution |
| **DIR** | Director | Coordinator | Directive · External · Continuous · Independent | 6% | Executive decision-making |
| **COO** | Coordinator | Coordinator | Directive · External · Continuous · Integration | 6% | Cross-system coordination |
| **ORC** | Orchestrator | Coordinator | Directive · External · Milestone · Integration | 4% | Multi-agent orchestration |
| **BRI** | Bridge | Bridge | Analytical · External · Continuous · Integration | 6% | Cross-boundary communication |
| **BRI-C** | Bridge Creative | Bridge | Creative · External · Continuous · Integration | 2% | Creative-technical translation |

---

### 7.6 Dynamic Role Builder

When standard roles are insufficient, build custom roles using this guided process.

#### Step 1: Analyze Task Requirements

Document what the task requires:

```yaml
task_analysis:
  description: <clear task description>
  required_cognitive: <analytical | creative | directive | synthesizing>
  required_execution: <solo | external | interactive>
  required_temporal: <continuous | milestone | reactive>
  required_collaboration: <independent | integration | boundary>
  special_requirements:
    - <any unique needs>
```

#### Step 2: Check Standard Role Fit

Compare against the 12 standard roles:

```
FOR each standard_role:
    score = dimension_match(task, standard_role)
    IF score > 85%:
        → Use standard_role with minor customization
    IF score > 60%:
        → Use standard_role as base, add extensions
    IF score <= 60%:
        → Proceed to custom role build
```

#### Step 3: Build Custom Role

If no standard role fits adequately:

```yaml
custom_role:
  code: <unique 3-letter code>
  name: <descriptive name>
  extends: <base_role_code or null>
  
  dimensions:
    cognitive: <value>
    execution: <value>
    temporal: <value>
    collaboration: <value>
  
  custom_capabilities:
    - <capability not in base role>
  
  custom_limitations:
    - <limitation not in base role>
  
  composability_rules:
    - <special composability notes>
```

#### Step 4: Validate Custom Role

Before deployment, validate:

| Check | Question | Pass Criteria |
|-------|----------|---------------|
| **Uniqueness** | Does this role duplicate an existing standard role? | Must be meaningfully different |
| **Consistency** | Are dimensions internally consistent? | No invalid combinations |
| **Composability** | Does this role work with existing roles? | At least 2 viable partnerships |
| **Utility** | Does this role address a real gap? | Clear use case with frequency >2% |
| **Clarity** | Is the role distinguishable from similar roles? | Clear differentiation statement |

#### Step 5: Register and Document

```yaml
registration:
  role_code: <code>
  registration_date: <date>
  author: <author>
  use_cases:
    - <documented use case>
  deprecation_conditions:
    - <when to retire this role>
  
  review_schedule:
    frequency: quarterly
    next_review: <date>
    criteria:
      - usage_frequency
      - partner_feedback
      - task_success_rate
```

---

### 7.7 Role Selection Quick Reference

**By Task Pattern:**

| Task Pattern | Primary | Secondary | Avoid |
|-------------|---------|-----------|-------|
| Analyze data | ANA | SYN, INT | DSG, DIR |
| Design solution | DSG | ARC, BRI-C | AUD, ANA |
| Review work | CRT | AUD, REV | DSG, GEN |
| Plan project | STG | MGR, PLN | DIR, OPR |
| Manage execution | MGR | COO, SUP | STG, ANA |
| Communicate externally | BRI | DIR, CSL | ANA, INT |
| Orchestrate workflow | ORC | MGR, COO | ANA, CRT |
| Ensure compliance | AUD | CRT, ARB | DSG, GEN |
| Strategic thinking | STG | ADV, POL | TEC, OPR |
| Creative translation | BRI-C | DSG, BRI | ANA, AUD |
| Quality assurance | CRT | AUD, REV | GEN, EXP |
| System design | ARC | DSG, TEC | OPR, PLN |

---

## Section 8: Advanced Patterns

### 8.1 Overview

This section covers **advanced role usage patterns** for sophisticated multi-agent systems. These patterns go beyond single-role assignment to explore how roles compose, interact, and evolve.

> **Audience:** This section is for experienced practitioners building complex agent systems. Beginners should master Sections 4-7 before attempting these patterns.

---

### 8.2 Composite Roles

A composite role combines **two or more standard roles** into a single agent instance, producing hybrid behavior.

#### When to Use Composite Roles

| Situation | Approach |
|-----------|----------|
| Task requires two distinct cognitive modes simultaneously | Composite: primary + secondary role |
| Agent must switch between execution patterns | Composite with mode-switching logic |
| Limited agent count but diverse task needs | Composite: multiple roles in one agent |
| Context-dependent behavior required | Composite with context-driven role selection |

#### Composite Role Structure

```yaml
composite_role:
  name: <composite_name>
  primary_role: <main_role_code>
  secondary_role: <supporting_role_code>
  
  composition_mode:
    type: <sequential | parallel | context_switching>
    description: <how roles interact>
  
  primary_role:
    code: <code>
    activation: <when primary is active>
    weight: <priority percentage>
  
  secondary_role:
    code: <code>
    activation: <when secondary is active>
    weight: <priority percentage>
  
  context_switching:
    trigger: <what causes role switch>
    transition_rules:
      - <rule for switching>
  
  conflict_resolution:
    when_roles_disagree: <resolution_strategy>
    precedence: <which_role_wins>
```

#### Example: Architect-Analyst Composite

```yaml
composite_role:
  name: Architect-Analyst
  primary_role: ARC
  secondary_role: ANA
  
  composition_mode:
    type: sequential
    description: |
      Begins in ANA mode to analyze requirements and constraints.
      Switches to ARC mode for design synthesis. Returns to ANA
      mode for design validation.
  
  workflow:
    - phase: analysis
      role: ANA
      output: requirements_analysis
    - phase: design
      role: ARC
      input: requirements_analysis
      output: architecture_design
    - phase: validation
      role: ANA
      input: architecture_design
      output: validated_architecture
  
  conflict_resolution:
    when_roles_disagree: "ANA constraints override ARC creativity"
    precedence: ANA
```

**Usage:** System design tasks where deep analysis must inform and constrain creative architecture.

---

#### Example: Strategist-Manager Composite

```yaml
composite_role:
  name: Strategist-Manager
  primary_role: STG
  secondary_role: MGR
  
  composition_mode:
    type: context_switching
    description: |
      Operates in STG mode for strategic planning phases.
      Switches to MGR mode for execution phases.
      Context determines active role.
  
  context_switching:
    trigger: "Phase transition between planning and execution"
    transition_rules:
      - if: "task_requires_long_term_thinking"
        then: "activate STG"
      - if: "task_requires_execution_management"
        then: "activate MGR"
      - if: "task_requires_both"
        then: "STG primary (70%), MGR secondary (30%)"
  
  conflict_resolution:
    when_roles_disagree: "STG vision guides; MGR adjusts execution"
    precedence: STG
```

**Usage:** Product management tasks where strategic vision and operational execution must coexist.

---

#### Composite Role Compatibility Matrix

Not all roles can be effectively combined. This matrix indicates compatibility:

|  | ANA | CRT | DSG | ARC | STG | AUD | MGR | DIR | COO | ORC | BRI | BRI-C |
|--|-----|-----|-----|-----|-----|-----|-----|-----|-----|-----|-----|-------|
| **ANA** | — | ✓ | △ | ✓ | ✓ | ✗ | △ | ✗ | △ | ✗ | ✓ | △ |
| **CRT** | ✓ | — | ✓ | ✓ | △ | ✓ | △ | ✗ | △ | ✗ | △ | ✓ |
| **DSG** | △ | ✓ | — | ✓ | ✓ | ✗ | △ | ✗ | △ | ✗ | △ | ✓ |
| **ARC** | ✓ | ✓ | ✓ | — | ✓ | ✓ | ✓ | △ | ✓ | △ | ✓ | ✓ |
| **STG** | ✓ | △ | ✓ | ✓ | — | △ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| **AUD** | ✗ | ✓ | ✗ | ✓ | △ | — | ✓ | ✗ | ✓ | ✗ | ✗ | ✗ |
| **MGR** | △ | △ | △ | ✓ | ✓ | ✓ | — | ✓ | ✓ | ✓ | ✓ | △ |
| **DIR** | ✗ | ✗ | ✗ | △ | ✓ | ✗ | ✓ | — | ✓ | ✓ | ✓ | ✗ |
| **COO** | △ | △ | △ | ✓ | ✓ | ✓ | ✓ | ✓ | — | ✓ | ✓ | △ |
| **ORC** | ✗ | ✗ | ✗ | △ | ✓ | ✗ | ✓ | ✓ | ✓ | — | ✓ | ✗ |
| **BRI** | ✓ | △ | △ | ✓ | ✓ | ✗ | ✓ | ✓ | ✓ | ✓ | — | ✓ |
| **BRI-C** | △ | ✓ | ✓ | ✓ | ✓ | ✗ | △ | ✗ | △ | ✗ | ✓ | — |

**Legend:**
- ✓ Compatible — effective composite possible
- △ Partial — works with limitations
- ✗ Incompatible — roles conflict

---

### 8.3 Dynamic Capability-Based Roles

Dynamic roles are **constructed at runtime** based on the specific capabilities required by a task, rather than being selected from a predefined catalog.

#### When to Use Dynamic Roles

| Situation | Rationale |
|-----------|-----------|
| Task doesn't match any standard role | Custom capability set needed |
| Capability requirements change during execution | Runtime adaptation required |
| Multi-domain task requiring unusual combinations | Novel role signature needed |
| Experimental or exploratory work | No established pattern exists |

#### Dynamic Role Construction Process

**Step 1: Capability Extraction**

```yaml
capability_extraction:
  task: <task_description>
  
  extract_capabilities:
    method: analyze_task_requirements
    output:
      - capability: <name>
        priority: <required | preferred | optional>
        source_dimension: <which_dimension_provides>
  
  example:
    task: "Design a real-time fraud detection system"
    capabilities:
      - capability: pattern_recognition
        priority: required
        source_dimension: cognitive.analytical
      - capability: system_design
        priority: required
        source_dimension: cognitive.creative
      - capability: real_time_processing
        priority: required
        source_dimension: temporal.continuous
      - capability: integration_awareness
        priority: required
        source_dimension: collaboration.integration
      - capability: risk_assessment
        priority: preferred
        source_dimension: cognitive.analytical
```

**Step 2: Dimension Inference**

```yaml
dimension_inference:
  from_capabilities:
    - aggregate_capability_sources
    - identify_dominant_dimensions
    - resolve_conflicts
  
  inference_rules:
    - if: "multiple_cognitive_capabilities"
      then: "select_dominant_or_use_composite"
    - if: "conflicting_temporal_requirements"
      then: "priority_required_over_preferred"
    - if: "optional_capabilities_missing"
      then: "note_limitation_continue"
```

**Step 3: Role Assembly**

```yaml
dynamic_role:
  name: "<auto-generated from dimensions>"
  code: "<auto-generated 3-letter code>"
  
  source_dimensions:
    cognitive: <inferred>
    execution: <inferred>
    temporal: <inferred>
    collaboration: <inferred>
  
  capabilities:
    - <extracted capabilities>
  
  limitations:
    - <noted gaps>
  
  confidence: <how well dimensions match capabilities>
  
  validation:
    - check: "role_can_perform_task"
    - check: "no_critical_gaps"
    - check: "composability_verified"
```

**Step 4: Validation and Deployment**

```yaml
deployment:
  pre_deployment_checks:
    - capability_coverage: "all_required_present"
    - limitation_acceptance: "gaps_acknowledged"
    - fallback_plan: "if_dynamic_role_fails"
  
  runtime_monitoring:
    - track: "capability_utilization"
    - track: "task_success_indicators"
    - track: "unexpected_limitations"
  
  post_execution:
    - evaluate: "role_effectiveness"
    - capture: "lessons_learned"
    - decide: "promote_to_standard_role"
```

#### Example: Dynamic Role for "Real-Time Fraud Detection Design"

```yaml
dynamic_role:
  name: "Fraud-Detection-Designer"
  code: "FDD"
  
  source_dimensions:
    cognitive: analytical    # dominant: pattern recognition
    execution: solo          # deep design work
    temporal: milestone      # design phase delivery
    collaboration: integration  # system integration required
  
  base_role: ARC            # closest standard match
  
  custom_capabilities:
    - real_time_system_design
    - fraud_pattern_analysis
    - risk_model_integration
    - compliance_mapping
  
  limitations:
    - no_fraud_domain_experience  # must be provided in context
    - no_ml_implementation_detail  # requires TEC partnership
  
  composite_partners:
    - ANA: "for pattern analysis phase"
    - TEC: "for implementation feasibility"
    - AUD: "for compliance validation"
  
  confidence: 78%
  
  rationale: |
    ARC base provides system design foundation. Custom capabilities
    extend for fraud-specific needs. ANA partnership fills analytical
    gaps. TEC partnership ensures implementation feasibility.
```

---

### 8.4 Cross-Dimensional Synthesis

Some tasks require **synthesizing across dimension boundaries** — combining different cognitive, execution, temporal, and collaboration modes in a single workflow.

#### Cross-Dimensional Workflow Pattern

```yaml
cross_dimensional_workflow:
  name: <workflow_name>
  
  phases:
    - phase: <name>
      dimension_focus: <which_dimension_dominates>
      role: <assigned_role>
      output: <phase_output>
      
    - phase: <name>
      dimension_focus: <different_dimension>
      role: <different_role>
      output: <phase_output>
      
  synthesis_point:
    where: <which_phase_combines>
    how: <synthesis_method>
    role: <synthesizing_role>
  
  handoff_rules:
    - from: <phase>
      to: <phase>
      format: <handoff_format>
      validation: <handoff_checks>
```

#### Example: Cross-Dimensional Product Development

```yaml
cross_dimensional_workflow:
  name: "Product Development Pipeline"
  
  phases:
    - phase: research
      dimension_focus: cognitive.analytical
      role: ANA
      output: "market_analysis_report"
      
    - phase: design
      dimension_focus: cognitive.creative
      role: DSG
      output: "product_design_document"
      
    - phase: strategy
      dimension_focus: cognitive.synthesizing
      role: STG
      output: "product_strategy"
      
    - phase: execution
      dimension_focus: cognitive.directive
      role: MGR
      output: "project_plan"
      
    - phase: review
      dimension_focus: cognitive.analytical
      role: CRT
      output: "quality_assessment"
      
  synthesis_point:
    where: "strategy phase"
    how: "STG synthesizes ANA + DSG outputs into coherent strategy"
    role: STG
    
  handoff_rules:
    - from: research
      to: design
      format: "structured_findings_with_insights"
      validation: "findings_relevance_check"
      
    - from: design
      to: strategy
      format: "design_document_with_rationale"
      validation: "design_completeness_check"
      
    - from: strategy
      to: execution
      format: "actionable_strategy_with_priorities"
      validation: "strategy_feasibility_check"
```

#### Cross-Dimensional Synthesis Rules

| Rule | Description | Rationale |
|------|-------------|-----------|
| **Sequential synthesis** | Each dimension phase feeds the next | Prevents cognitive overload |
| **Single dimension dominance** | One dimension dominates per phase | Clear role assignment |
| **Mandatory synthesis point** | All strands must converge | Prevents fragmentation |
| **Validation at handoffs** | Each phase output validated before next | Quality assurance |
| **Feedback loops** | Later phases can loop back | Adaptive refinement |

---

### 8.5 Role Evolution Patterns

Roles can **evolve over time** as tasks, context, and system maturity change.

#### Evolution Triggers

| Trigger | From | To | Rationale |
|---------|------|-----|-----------|
| **Task complexity increases** | ANA | ARC | Analysis grows into architecture |
| **Scope expands** | DSG | ARC | Design grows into system design |
| **Team grows** | MGR | ORC | Management becomes orchestration |
| **External exposure increases** | MGR | DIR | Management becomes directorship |
| **Boundaries blur** | BRI | COO | Bridging becomes coordination |
| **Strategic depth needed** | MGR | STG | Management adds strategy |

#### Evolution Pattern

```yaml
role_evolution:
  trigger: <what_caused_evolution>
  
  from_role:
    code: <original_role>
    maturity: <current_maturity_level>
  
  to_role:
    code: <new_role>
    maturity: <target_maturity_level>
  
  transition_plan:
    - phase: "dual_role_period"
      duration: "2-4 weeks"
      activities:
        - "new_role shadowing"
        - "capability_building"
        - "gradual_handoff"
    
    - phase: "full_transition"
      duration: "1-2 weeks"
      activities:
        - "complete_handoff"
        - "old_role_decommissioning"
        - "new_role_full_activation"
  
  risk_mitigation:
    - risk: "capability_gap"
      mitigation: "training + documentation"
    - risk: "relationship_disruption"
      mitigation: "stakeholder_communication"
    - risk: "reversion_temptation"
      mitigation: "clear_success_metrics"
```

---

### 8.6 Multi-Agent Composition Patterns

#### Pattern 1: Assembly Line

Sequential processing where each agent adds value and passes to the next.

```
[ANA] → [DSG] → [ARC] → [TEC] → [AUD]
Analysis  Design   Arch.    Build    Validate
```

**Best for:** Well-defined workflows with clear sequential dependencies.
**Risk:** Bottlenecks at any stage block entire pipeline.

#### Pattern 2: Parallel Exploration

Multiple agents explore different approaches simultaneously.

```
        ┌→ [DSG-A] →┐
[ANA] → ├→ [DSG-B] →┤ → [STG] → [ARC]
        └→ [DSG-C] →┘
   Analysis  Options    Synthesis  Architecture
```

**Best for:** Design exploration, creative tasks with multiple valid approaches.
**Risk:** Synthesis complexity increases with number of parallel branches.

#### Pattern 3: Hub and Spoke

Central coordinator manages multiple specialist agents.

```
         ┌→ [ANA]
         │
[ORC] → ┼→ [DSG] → [ARC]
         │
         └→ [CRT]
```

**Best for:** Complex projects requiring diverse expertise.
**Risk:** ORC bottleneck; single point of failure.

#### Pattern 4: Peer Network

Agents collaborate as equals without central coordination.

```
[ANA] ←→ [DSG] ←→ [ARC]
  ↑                  ↑
  └──── [BRI] ──────┘
```

**Best for:** Collaborative environments with high trust and clear interfaces.
**Risk:** Coordination overhead; potential for conflicting outputs.

---

### 8.7 Advanced Anti-Patterns

#### Anti-Pattern 1: Role Overloading

```yaml
anti_pattern:
  name: "Role Overloading"
  description: "Assigning too many responsibilities to a single role"
  
  symptoms:
    - "Role has 10+ capabilities defined"
    - "Role is involved in every workflow phase"
    - "Agent context window frequently exceeded"
    - "Output quality degrades over time"
  
  consequences:
    - "Cognitive overload"
    - "Shallow execution"
    - "Context window exhaustion"
    - "Burnout (in human analogs)"
  
  remediation:
    - "Split into 2-3 focused roles"
    - "Use composite role with mode switching"
    - "Introduce coordinator to distribute load"
  
  example:
    bad: "ANA also does design, strategy, and management"
    good: "ANA + DSG + STG + MGR as separate roles"
```

#### Anti-Pattern 2: Role Conflict

```yaml
anti_pattern:
  name: "Role Conflict"
  description: "Assigning incompatible roles to the same agent or workflow"
  
  symptoms:
    - "Contradictory outputs from same agent"
    - "Frequent override of role behavior"
    - "Agents working at cross-purposes"
    - "Escalation loops"
  
  consequences:
    - "Wasted computation"
    - "Inconsistent outputs"
    - "System instability"
    - "User confusion"
  
  remediation:
    - "Separate conflicting roles to different agents"
    - "Introduce arbiter role for conflict resolution"
    - "Redesign workflow to eliminate conflict"
  
  example:
    bad: "CRT and DSG in same agent without mode switching"
    good: "CRT reviews DSG output; separate agents"
```

#### Anti-Pattern 3: Premature Orchestration

```yaml
anti_pattern:
  name: "Premature Orchestration"
  description: "Introducing ORC before simpler coordination suffices"
  
  symptoms:
    - "ORC managing 2-3 agents"
    - "Complex orchestration for simple workflows"
    - "Overhead exceeds value"
    - "Frequent orchestration failures"
  
  consequences:
    - "Unnecessary complexity"
    - "Debugging difficulty"
    - "Overhead waste"
    - "Fragility"
  
  remediation:
    - "Start with MGR or COO coordination"
    - "Introduce ORC only when agent count > 5"
    - "Use peer network for simple collaborations"
  
  example:
    bad: "ORC for ANA + DSG 2-agent workflow"
    good: "Direct ANA → DSG handoff; no coordinator needed"
```

---

### 8.8 Decision Framework for Advanced Patterns

Use this decision tree to select the appropriate advanced pattern:

```
START: What is your multi-agent challenge?
│
├─ Single task requiring multiple capabilities
│  ├─ Capabilities from different cognitive modes? → COMPOSITE ROLE
│  └─ Capabilities from same cognitive mode? → ENHANCED STANDARD ROLE
│
├─ Multiple related tasks with handoffs
│  ├─ Sequential dependency? → ASSEMBLY LINE
│  ├─ Parallel exploration? → PARALLEL EXPLORATION
│  └─ Mixed dependencies? → CROSS-DIMENSIONAL WORKFLOW
│
├─ Multiple agents requiring coordination
│  ├─ 2-4 agents, simple coordination? → HUB AND SPOKE (MGR/COO)
│  ├─ 5+ agents, complex orchestration? → ORCHESTRATOR
│  └─ Collaborative equals? → PEER NETWORK
│
├─ Role behavior needs to change over time
│  └─ Context or maturity driven? → ROLE EVOLUTION
│
└─ No standard role fits
   └─ Custom capabilities needed? → DYNAMIC ROLE BUILDER
```

---

### 8.9 Pattern Maturity Model

| Level | Name | Description | Indicators |
|-------|------|-------------|------------|
| **1** | Basic | Single roles, simple assignments | 1-2 agents, no coordination |
| **2** | Structured | Standard roles with clear handoffs | 2-4 agents, sequential workflows |
| **3** | Coordinated | Coordinator roles managing multiple agents | 3-6 agents, managed workflows |
| **4** | Composed | Composite roles and parallel execution | 4-8 agents, complex patterns |
| **5** | Orchestrated | Full orchestration with dynamic adaptation | 6+ agents, self-optimizing |
| **6** | Autonomous | Self-organizing role systems | Agents create/assign roles dynamically |

> **Recommendation:** Start at Level 2 and progress organically. Do not jump to Level 5 without mastering each preceding level.

---

## Appendix A: Dimension Quick Reference Card

### Cognitive Processing Style

| Value | Use When | Examples |
|-------|----------|----------|
| **Analytical** | Breaking down complex information | Data analysis, research, debugging |
| **Creative** | Generating novel solutions | Design, brainstorming, innovation |
| **Directive** | Providing guidance or decisions | Leadership, crisis management, prioritization |
| **Synthesizing** | Combining disparate information | Strategy, planning, cross-domain work |

### Execution Interaction Pattern

| Value | Use When | Examples |
|-------|----------|----------|
| **Solo** | Self-contained independent work | Deep analysis, writing, coding |
| **External** | Communication with outside entities | Reporting, stakeholder management, APIs |
| **Interactive** | Real-time back-and-forth | Pair programming, mentoring, negotiation |

### Temporal Engagement Model

| Value | Use When | Examples |
|-------|----------|----------|
| **Continuous** | Ongoing always-available engagement | Monitoring, coaching, assistance |
| **Milestone** | Defined start/end with checkpoints | Projects, sprints, defined tasks |
| **Reactive** | Event-triggered activation | Alerts, incidents, exceptions |

### Collaboration Boundary

| Value | Use When | Examples |
|-------|----------|----------|
| **Independent** | Autonomous operation | Isolated tasks, verification, competition |
| **Integration** | Part of larger system | Pipeline stages, components, workflows |
| **Boundary-spanning** | Cross-organizational work | Stakeholder management, translation |

---

## Appendix B: YAML Template Reference

### Minimal Role Definition

```yaml
role:
  code: <3-letter-code>
  name: <Human-readable name>
  dimensions:
    cognitive: <analytical|creative|directive|synthesizing>
    execution: <solo|external|interactive>
    temporal: <continuous|milestone|reactive>
    collaboration: <independent|integration|boundary>
```

### Standard Role Definition

```yaml
role:
  code: <3-letter-code>
  name: <Human-readable name>
  description: <What this role does>
  dimensions:
    cognitive: <value>
    execution: <value>
    temporal: <value>
    collaboration: <value>
  capabilities:
    - <capability-1>
    - <capability-2>
  limitations:
    - <limitation-1>
    - <limitation-2>
  typical_tasks:
    - <task-1>
    - <task-2>
  composability:
    can_lead: <true|false>
    can_follow: <true|false>
    can_parallelize: <true|false>
    preferred_partners:
      - <role-code-1>
      - <role-code-2>
```

### Composite Role Definition

```yaml
composite_role:
  name: <composite-name>
  primary_role: <role-code>
  secondary_role: <role-code>
  composition_mode:
    type: <sequential|parallel|context_switching>
    description: <how roles interact>
  conflict_resolution:
    when_roles_disagree: <strategy>
    precedence: <which-role-wins>
```

### Dynamic Role Definition

```yaml
dynamic_role:
  name: <generated-name>
  code: <generated-code>
  source_dimensions:
    cognitive: <inferred>
    execution: <inferred>
    temporal: <inferred>
    collaboration: <inferred>
  base_role: <closest-standard-role>
  custom_capabilities:
    - <capability-1>
  limitations:
    - <limitation-1>
  confidence: <percentage>
```

---

## Appendix C: Changelog

| Version | Date | Changes | Author |
|---------|------|---------|--------|
| 0.1 | 2024-01-15 | Initial draft — Sections 1-3 | @kishore |
| 0.2 | 2024-01-22 | Added Section 4: Role Selection Algorithm | @kishore |
| 0.3 | 2024-02-01 | Added Section 5: Dimension Combinations | @kishore |
| 0.4 | 2024-02-10 | Added Section 6: Four-Dimension Framework | @kishore |
| 0.5 | 2024-02-20 | Added Section 7: Standard Role Catalog | @kishore |
| 0.6 | 2024-03-01 | Added Section 8: Advanced Patterns | @kishore |
| 1.0 | 2024-03-15 | **Complete specification — Sections 1-8** | @kishore |

---

## Appendix D: Glossary

| Term | Definition |
|------|------------|
| **Agent** | An autonomous software entity that performs tasks on behalf of users or other systems |
| **AESP** | Agent Engineering Specification Protocol — this specification series |
| **Boundary-spanning** | Collaboration mode where an agent bridges across organizational or system boundaries |
| **Composite Role** | A role formed by combining two or more standard roles |
| **Coordinator** | A role category focused on managing, directing, and orchestrating other agents |
| **Dimension** | One of four independent axes (Cognitive, Execution, Temporal, Collaboration) that define a role |
| **Dynamic Role** | A role constructed at runtime based on task-specific capability requirements |
| **Role** | A defined behavioral pattern for an agent, specified by dimensions and capabilities |
| **Specialist** | A role category focused on specific, deep expertise in narrow domains |
| **Synthesis** | The process of combining information from multiple sources into coherent understanding |

---

## Appendix E: Decision Trees

### Which role category should I use?

```
Does the task require managing other agents?
├─ YES → COORDINATOR (MGR, DIR, COO, ORC)
│   ├─ Project execution? → MGR
│   ├─ Executive decisions? → DIR
│   ├─ Cross-system coordination? → COO
│   └─ Complex orchestration? → ORC
│
└─ NO → Is the task cross-boundary?
    ├─ YES → BRIDGE (BRI, BRI-C)
    │   ├─ Analytical translation? → BRI
    │   └─ Creative translation? → BRI-C
    │
    └─ NO → SPECIALIST (ANA, CRT, DSG, ARC, STG, AUD)
        ├─ Analysis needed? → ANA
        ├─ Review needed? → CRT
        ├─ Design needed? → DSG
        ├─ Architecture needed? → ARC
        ├─ Strategy needed? → STG
        └─ Compliance needed? → AUD
```

### When should I use a composite role?

```
Does a single standard role provide >85% fit?
├─ YES → Use standard role
│
└─ NO → Can the task be split into sequential phases?
    ├─ YES → Use sequential workflow with handoffs
    │
    └─ NO → Do capabilities need to coexist simultaneously?
        ├─ YES → COMPOSITE ROLE
        │   ├─ Check compatibility matrix (Section 8.2)
        │   ├─ Define mode-switching or weighting
        │   └─ Specify conflict resolution
        │
        └─ NO → DYNAMIC ROLE BUILDER (Section 8.3)
```

### When should I use dynamic role building?

```
Does the task match any standard role >60%?
├─ YES → Use or extend standard role
│
└─ NO → Are capability requirements clear?
    ├─ YES → DYNAMIC ROLE BUILDER
    │   ├─ Extract capabilities
    │   ├─ Infer dimensions
    │   ├─ Assemble role
    │   └─ Validate before deployment
    │
    └─ NO → Human review required
        └─ Task may not be suitable for agent automation
```

---

*End of AESP-0002: Agent Roles — Sections 4-8*

*This specification is part of the Agent Engineering Specification Protocol (AESP). For the full specification set, see the AESP repository.*
