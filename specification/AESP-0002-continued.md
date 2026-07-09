# AESP-0002: Agent Roles — Sections 4–6

> **AESP Number:** 0002 | **Title:** Agent Roles | **Status:** Draft  
> **Depends On:** AESP-0001 (Foundation) | **Leads To:** AESP-0003 (Workflow & Handoffs), AESP-0007 (Security & Governance)

---

## 4. Role Assignments

### 4.1 Definition and Purpose

A **RoleAssignment** is the contextual binding of a RoleTemplate to an Agent within a specific scope. While a RoleTemplate defines *what* a role is — its permissions, constraints, and composition rules — a RoleAssignment defines *who* has that role, *where* it applies, and *for how long*.

RoleAssignments serve as the bridge between the static role definition layer and the dynamic runtime authorization layer. Each assignment pins a specific version of a RoleTemplate, resolves that template's permissions through the RBAC+ pipeline defined in Section 5, and produces a set of **effective permissions** that the agent may exercise within the assignment's scope.

The dual-level model (ADR-1) separates concerns: RoleTemplate authors design reusable role blueprints, while assignment administrators bind those blueprints to agents in context. An agent MUST NOT exercise role-derived permissions without a corresponding active RoleAssignment. The system MUST evaluate permission requests against an agent's active assignments in the requesting scope.

### 4.2 Field Specification

A RoleAssignment SHALL contain the following fields:

| Field | Type | Required | Description |
|---|---|---|---|
| `id` | UUID string | yes | Unique assignment identifier. Format: `ra-{uuid}`. |
| `template_id` | string | yes | Reference to a published RoleTemplate by its `id`. |
| `template_version` | semver | yes | The exact template version pinned at assignment creation. |
| `agent_id` | URN | yes | Reference to the Agent (per AESP-0001) that holds this role. Format: `urn:aeo:agent:{agent_id}`. |
| `scope` | Scope object | yes | The namespace in which this assignment is valid (see §4.3). |
| `granted_permissions` | Permission[] | yes | The raw permissions from the template, before RBAC+ resolution. |
| `effective_permissions` | EffectivePermission[] | yes | The fully resolved permissions produced by the RBAC+ pipeline (see §5). |
| `status` | enum | yes | Current lifecycle state: `proposed`, `active`, `suspended`, `revoked`, or `expired` (see §4.4). |
| `assumed_at` | timestamp | yes | The point in time when the assignment entered the `active` state. |
| `expires_at` | timestamp \| null | no | Auto-expiration time. A value of `null` indicates the assignment does not expire. |
| `trust_policy` | TrustPolicyRef \| null | no | If the assignment was created via dynamic assumption, a reference to the TrustPolicy that authorized it (see §4.6). |
| `elevated_via` | string \| null | no | If the assignment represents an elevated session, the session or approval identifier that authorized it. |
| `phase_binding` | PhaseBinding \| null | no | If the assignment is bound to a specific work unit phase, the phase constraint (see §6.4). |
| `metadata` | object | no | Extensible metadata including assignment reason, assigner identity, and audit fields. |

**Scope Sub-entity:**

| Field | Type | Description |
|---|---|---|
| `type` | enum | Either `"organization"` or `"workunit"`. |
| `id` | URN | The organization or work unit identifier. |

**TrustPolicyRef Sub-entity:**

| Field | Type | Description |
|---|---|---|
| `policy_id` | string | The TrustPolicy identifier. |
| `assumed_at` | timestamp | When the dynamic assumption occurred. |
| `session_id` | string | The RoleSession identifier for this assumption. |

**PhaseBinding Sub-entity:**

| Field | Type | Description |
|---|---|---|
| `phase` | enum | The work unit phase: `"planning"`, `"execution"`, `"review"`, or `"closure"`. |
| `auto_transition` | boolean | Whether the assignment status SHOULD transition automatically when the work unit phase changes. |

**Example — RoleAssignment (Organization-Scoped):**

```json
{
  "id": "ra-uuid-1234",
  "template_id": "role.exec.executor",
  "template_version": "1.0.0",
  "agent_id": "urn:aeo:agent:builder-001",
  "scope": { "type": "organization", "id": "urn:aeo:org:team-alpha" },
  "granted_permissions": [
    { "action": "workunit:execute", "resource": "organization:{org_id}:workunits", "effect": "allow" }
  ],
  "effective_permissions": [
    {
      "permission": { "action": "workunit:execute", "resource": "organization:team-alpha:workunits", "effect": "allow" },
      "provenance": ["template:role.exec.executor:v1.0.0", "scope_resolution"]
    }
  ],
  "status": "active",
  "assumed_at": "2024-01-15T10:00:00Z",
  "expires_at": null,
  "trust_policy": null,
  "elevated_via": null,
  "phase_binding": null,
  "metadata": {
    "assigned_by": "urn:aeo:agent:coordinator-001",
    "assignment_reason": "crew_composition_auto",
    "ares_score": 0.85
  }
}
```

### 4.3 Assignment Scope

Every RoleAssignment MUST be scoped to exactly one namespace. The scope determines where the assignment's effective permissions are valid. Two scope types exist:

**Organization-scoped assignments.** When `scope.type` is `"organization"`, the assignment's effective permissions apply across all work units within that organization. Organization-scoped assignments are appropriate for:
- Roles that require cross-workunit visibility (e.g., Orchestrator, Auditor).
- Agents that participate in multiple work units simultaneously.
- Governance and oversight roles.

**Workunit-scoped assignments.** When `scope.type` is `"workunit"`, the assignment's effective permissions apply only within the specified work unit. Workunit-scoped assignments are appropriate for:
- Delivery-aligned roles (e.g., Executor, Guardian).
- Roles with tightly constrained resource access.
- Situations where the principle of least privilege applies.

**Scope resolution rules:**
- An agent with an organization-scoped assignment to role R has the effective permissions of R in every work unit within that organization.
- An agent with a workunit-scoped assignment to role R has the effective permissions of R only in the specified work unit.
- Permission resolution SHALL filter out permissions whose resource references fall outside the assignment scope (see §5.6, Step 6).
- Cross-scope permission leakage SHALL NOT occur. An assignment in scope A MUST NOT grant permissions in scope B unless a ReBAC relationship tuple explicitly authorizes cross-scope access (see §5.4).

### 4.4 Assignment Lifecycle States

A RoleAssignment progresses through a well-defined lifecycle. The system MUST enforce valid transitions between states.

```mermaid
stateDiagram-v2
    [*] --> proposed : create_assignment
    proposed --> active : approve / auto_activate
    proposed --> revoked : reject
    active --> suspended : suspend
    active --> revoked : revoke
    active --> expired : timeout
    suspended --> active : resume
    suspended --> revoked : revoke
    expired --> [*]
    revoked --> [*]
```

**State definitions:**

| State | Description |
|---|---|
| `proposed` | The assignment has been created but is not yet active. Effective permissions are computed but not enforced. The assignment MAY require approval before activation. |
| `active` | The assignment is in effect. The agent MAY exercise the effective permissions within the assignment scope. |
| `suspended` | The assignment is temporarily inactive. The agent MUST NOT exercise the assignment's permissions. The suspension MAY be triggered by agent lifecycle changes, policy violations, or manual administrative action. |
| `revoked` | The assignment has been permanently terminated. The agent MUST NOT exercise the assignment's permissions. Revocation is final and irreversible. |
| `expired` | The assignment reached its `expires_at` timestamp without renewal. The agent MUST NOT exercise the assignment's permissions. Expired assignments MAY be renewed by creating a new assignment. |

**Transition rules:**
- A proposed assignment SHALL transition to `active` when all approval requirements are satisfied or when no approval is required.
- An `active` assignment SHALL transition to `suspended` when its associated agent enters the `suspended` or `terminating` state per AESP-0001.
- An `active` assignment SHALL transition to `expired` when the current time exceeds `expires_at` (if set).
- A `suspended` assignment MAY transition back to `active` when the suspension cause is resolved.
- A `revoked` assignment SHALL NOT transition to any other state.
- An `expired` assignment SHALL NOT transition to any other state; a new assignment MUST be created for continued authorization.

### 4.5 Time-Bounded Assignments

RoleAssignments MAY have a finite lifetime. The `expires_at` field defines the point after which the assignment automatically transitions to the `expired` state.

**Session management.** When an assignment has an `expires_at` value, the system SHALL:
- Monitor the expiration timestamp.
- Transition the assignment to `expired` when `expires_at` is reached.
- Revoke all active RoleSessions associated with the assignment.
- Log the expiration event for audit purposes.

**Renewal.** An active time-bounded assignment MAY be renewed before expiration. Renewal updates `expires_at` to a future timestamp and logs the renewal event. The assignment retains its `active` state through renewal.

**Early expiration.** An assignment MAY be manually expired before its `expires_at` timestamp by transitioning it to `revoked`. This is functionally equivalent to revocation.

**Example — Time-Bounded Assignment:**

```json
{
  "id": "ra-uuid-5678",
  "template_id": "role.coord.strategist",
  "template_version": "1.2.0",
  "agent_id": "urn:aeo:agent:planner-003",
  "scope": { "type": "workunit", "id": "urn:aeo:wu:sprint-42" },
  "granted_permissions": [],
  "effective_permissions": [],
  "status": "active",
  "assumed_at": "2024-06-01T09:00:00Z",
  "expires_at": "2024-06-30T17:00:00Z",
  "trust_policy": null,
  "phase_binding": { "phase": "planning", "auto_transition": true },
  "metadata": { "assigned_by": "system:auto" }
}
```

### 4.6 Dynamic Role Assumption via TrustPolicy

RoleAssignments MAY be created dynamically through the TrustPolicy mechanism (ADR-6). TrustPolicies enable **just-in-time (JIT) role elevation**: an agent without a standing assignment to a role MAY assume that role temporarily if it satisfies the conditions defined in a TrustPolicy attached to the role's template.

**TrustPolicy entity.** A TrustPolicy defines the rules for dynamic role assumption:

| Field | Type | Required | Description |
|---|---|---|---|
| `id` | string | yes | Unique trust policy identifier. Format: `tp.{cat}.{name}`. |
| `name` | string | yes | Human-readable policy name. |
| `role_template_id` | string | yes | The RoleTemplate this policy governs. |
| `trusted_agents` | AgentMatcher[] | yes | Patterns matching agents that MAY assume the role. |
| `conditions` | Condition | no | CEL expression that MUST evaluate to `true` for assumption to proceed. |
| `duration` | Duration | yes | Maximum session length after assumption. |
| `require_approval` | ApprovalRequirement | no | If approval is required, defines the approver and timeout. |
| `metadata` | object | no | Policy purpose, audit info. |

**AgentMatcher Sub-entity:**

| Field | Type | Description |
|---|---|---|
| `type` | enum | `"pattern"`, `"explicit"`, or `"role_holder"`. |
| `match` | string | The matching criteria. For `"pattern"`, a CEL expression against agent attributes. For `"explicit"`, a specific agent URN. For `"role_holder"`, a role template ID. |

**ApprovalRequirement Sub-entity:**

| Field | Type | Description |
|---|---|---|
| `approver_role` | string | The RoleTemplate ID of agents that may approve the assumption. |
| `timeout_seconds` | integer | Maximum time to wait for approval. |
| `auto_deny_on_timeout` | boolean | If `true`, the assumption is denied when the timeout expires. |

**Dynamic assumption workflow:**

When an agent requests to dynamically assume a role, the system SHALL execute the following steps:

1. **Identify matching TrustPolicies.** Find all TrustPolicies where `role_template_id` matches the requested role and where the requesting agent matches at least one entry in `trusted_agents`.
2. **Evaluate conditions.** For each matching policy, evaluate the CEL expression in `conditions.cel_expression` against the current request context. Only policies whose conditions evaluate to `true` are eligible.
3. **Require approval (if configured).** If `require_approval` is set, create an approval workflow and wait for an agent holding the `approver_role` to approve or deny. If `auto_deny_on_timeout` is `true` and the timeout expires, deny the assumption.
4. **Create RoleSession.** On approval (or if no approval is required), create a RoleSession with:
   - `started_at` = current time
   - `expires_at` = current time + `duration.max_seconds`
   - `status` = `"active"`
   - `context` referencing the TrustPolicy and approval (if any)
5. **Create RoleAssignment.** Create a transient RoleAssignment bound to the RoleSession with:
   - `status` = `"active"`
   - `trust_policy` populated with the TrustPolicy reference
   - `elevated_via` = the session or approval identifier
   - `expires_at` = the session expiration time

**Example — TrustPolicy:**

```json
{
  "id": "tp.exec.elevated",
  "name": "Executor Emergency Elevation",
  "role_template_id": "role.exec.executor",
  "trusted_agents": [
    { "type": "pattern", "match": "agent.trust_level >= 0.8" }
  ],
  "conditions": {
    "cel_expression": "time.of_day >= '09:00' && time.of_day <= '17:00' || incident.severity == 'critical'",
    "required_context": ["time.of_day", "incident.severity"]
  },
  "duration": { "max_seconds": 3600, "extendable": false },
  "require_approval": {
    "approver_role": "role.coord.orchestrator",
    "timeout_seconds": 300,
    "auto_deny_on_timeout": true
  },
  "metadata": { "purpose": "incident_response_break_glass" }
}
```

**Example — RoleSession:**

```json
{
  "id": "rs-uuid-9012",
  "assignment_id": "ra-uuid-7890",
  "started_at": "2024-01-15T14:00:00Z",
  "expires_at": "2024-01-15T15:00:00Z",
  "context": {
    "workunit_id": "wu-alpha-001",
    "trigger": "trust_policy_assumption",
    "trust_policy_id": "tp.exec.elevated",
    "approval_id": "approval-uuid-3456"
  },
  "status": "active",
  "metadata": {
    "session_token_hash": "sha256:abc123..."
  }
}
```

**Session validity.** A RoleSession SHALL be considered valid only when ALL of the following hold:
- The parent RoleAssignment is in the `active` state.
- The current time is within the interval `[started_at, expires_at]`.
- The session has not been explicitly revoked.

When a session expires or is revoked, the system SHALL transition the parent RoleAssignment to `expired` or `revoked` respectively.

**Assumption chaining depth.** Dynamic role assumption via TrustPolicy SHALL have a maximum chaining depth of 1. A TrustPolicy MAY only grant the directly referenced role template. An agent that dynamically assumes role R MUST NOT use that assumption as the basis for further dynamic assumptions. This constraint prevents privilege escalation chains.

### 4.7 Multiple Assignments

An agent MAY hold multiple RoleAssignments simultaneously. This is a core feature enabling the matrix role model (ADR-3): an agent can hold one role per dimension (delivery, capability, community, system) without conflict.

**Simultaneous assignment rules:**
- An agent MAY hold any number of assignments across different dimensions simultaneously.
- An agent MAY hold multiple assignments to the same RoleTemplate if each assignment has a different scope.
- An agent MUST NOT hold more than one active assignment to the same RoleTemplate in the same scope.
- When evaluating permissions for an action, the system SHALL consider the union of effective permissions from all active assignments in the requesting scope.
- If assignments grant conflicting permissions (same action and resource with different effects), deny wins (see §5.6, Step 8).

**Assignment set for an agent.** The effective authorization state of an agent in a given scope is the union of all active assignments in that scope. Formally:

```
agent_effective_permissions(agent, scope) =
    ⋃ { assignment.effective_permissions
        | assignment.agent_id = agent.id
        ∧ assignment.scope = scope
        ∧ assignment.status = "active" }
```

### 4.8 Assignment Conflict Detection

Certain RoleTemplates declare mutual exclusion through their `composition_rules.conflicts_with` field. The system MUST enforce these conflict constraints at the assignment level.

**Conflict rules:**
- If RoleTemplate A lists RoleTemplate B in `conflicts_with`, then no agent MAY hold active assignments to both A and B in the same scope.
- Conflict detection SHALL be evaluated when an assignment is created and when an assignment transitions to `active`.
- If creating or activating an assignment would create a conflict, the operation SHALL be rejected with a conflict error.
- Conflicts are scope-local. An agent MAY hold conflicting roles in different scopes.
- An agent MAY hold conflicting roles across different dimensions if the conflicting templates' composition rules permit coexistence across dimensions.

**Conflict detection algorithm:**

```
function detect_conflict(new_assignment):
    agent_assignments = get_active_assignments(new_assignment.agent_id, new_assignment.scope)
    new_template = load_template(new_assignment.template_id)

    for existing in agent_assignments:
        existing_template = load_template(existing.template_id)

        # Direct conflict: new template conflicts with existing
        if existing_template.id in new_template.composition_rules.conflicts_with:
            return CONFLICT(new_template.id, existing_template.id)

        # Reverse conflict: existing template conflicts with new
        if new_template.id in existing_template.composition_rules.conflicts_with:
            return CONFLICT(existing_template.id, new_template.id)

    return NO_CONFLICT
```

**Requirement enforcement.** If RoleTemplate A lists RoleTemplate B in `composition_rules.requires`, an assignment to A in a scope SHALL activate only if at least one active assignment to B exists in the same scope. The system MUST verify requirement satisfaction when an assignment transitions to `active`.

---

## 5. Permission Model (RBAC+)

### 5.1 RBAC+ Architecture Overview

AESP-0002 defines **RBAC+**, a four-layer permission architecture (ADR-2) that extends classical Role-Based Access Control with Attribute-Based conditions (ABAC), Relationship-Based constraints (ReBAC), and Policy-Based governance (PBAC). Each layer processes permissions in sequence, with each subsequent layer able to restrict but not expand beyond the previous layer.

```mermaid
flowchart TB
    subgraph L1["Layer 1: RBAC Core"]
        RBAC["Base Permissions<br/>+ Role Hierarchy Inheritance"]
    end

    subgraph L2["Layer 2: ABAC Conditions"]
        ABAC["CEL Expression Evaluation<br/>Runtime Context Filtering"]
    end

    subgraph L3["Layer 3: ReBAC Relationships"]
        REBAC["Relationship Tuple Resolution<br/>Graph-Based Constraints"]
    end

    subgraph L4["Layer 4: PBAC Governance"]
        PBAC["Permission Boundaries<br/>Deny Overrides<br/>Provenance Recording"]
    end

    TEMPLATE["RoleTemplate<br/>permissions[]"] --> RBAC
    RBAC --> ABAC
    ABAC --> REBAC
    REBAC --> PBAC
    PBAC --> EFFECTIVE["EffectivePermissions[]"]

    BOUNDARY["PermissionBoundary<br/>max_permissions[]"] --> PBAC
    CONTEXT["RequestContext<br/>agent, resource, action, time"] --> ABAC
    RELATIONS["ReBAC Tuple Store<br/>object#relation@subject"] --> REBAC
```

**Layer processing invariant.** The permission set at layer N SHALL be a subset (or equal set) of the permission set at layer N-1. No layer MAY add permissions that were not present in a previous layer. The only exception is the RBAC Core layer, which may expand permissions through role hierarchy inheritance.

**Deny-by-default.** If a permission is not explicitly granted and not denied by any layer, the default effect SHALL be `"deny"`. An agent MUST be able to present at least one active assignment that grants the requested permission for access to be authorized.

### 5.2 RBAC Core — Base Permissions and Role Hierarchy

The RBAC Core layer is the foundation of the permission model. It defines the base permission set for each RoleTemplate and propagates permissions through the template inheritance hierarchy.

**Permission format.** Each permission is an object with the following fields:

| Field | Type | Required | Description |
|---|---|---|---|
| `action` | string | yes | The action being permitted or denied. Format: `{resource_type}:{operation}` (e.g., `workunit:execute`). |
| `resource` | string | yes | The resource pattern. Uses colon-separated path notation with `*` as single-segment wildcard and `**` as multi-segment wildcard (e.g., `organization:org-001:workunits:**`). |
| `effect` | enum | yes | Either `"allow"` or `"deny"`. |
| `condition` | string \| null | no | A CEL expression evaluated at the ABAC layer (see §5.3). |
| `relationship_constraint` | ReBACConstraint \| null | no | A ReBAC relationship constraint evaluated at the ReBAC layer (see §5.4). |

**Role hierarchy inheritance.** RoleTemplates MAY specify a `parent_template_id` to inherit from another template. The inheritance rules are:
- A child template inherits all permissions from its parent.
- The inheritance graph SHALL be a Directed Acyclic Graph (DAG).
- The maximum inheritance depth SHALL NOT exceed 3 levels (template → parent → grandparent).
- Child permissions override parent permissions for the same `(action, resource)` pair.
- Inherited permissions are collected at the RBAC Core layer before subsequent layers process them.

**Example — RBAC Core Permission:**

```json
{
  "action": "workunit:execute",
  "resource": "organization:{org_id}:workunits:*",
  "effect": "allow",
  "condition": null,
  "relationship_constraint": null
}
```

### 5.3 ABAC Conditions — CEL Expression Format

The ABAC layer filters permissions based on runtime context using Common Expression Language (CEL) expressions. Each permission MAY include a `condition` field containing a CEL expression string.

**Available context variables.** CEL expressions in conditions MAY reference the following variables:

| Variable | Type | Description |
|---|---|---|
| `agent.id` | string | The requesting agent's URN. |
| `agent.trust_level` | float | The agent's trust score (0.0 to 1.0). |
| `agent.capabilities` | string[] | The agent's declared capabilities. |
| `agent.roles` | string[] | The role template IDs the agent holds in the current scope. |
| `time.now` | timestamp | The current time (UTC). |
| `time.of_day` | string | The current time formatted as `"HH:MM"` in 24-hour notation. |
| `time.day_of_week` | string | The current day: `"monday"` through `"sunday"`. |
| `resource.id` | string | The resource being accessed. |
| `resource.type` | string | The resource type. |
| `resource.owner` | string | The URN of the resource's owner. |
| `request.action` | string | The action being requested. |
| `request.scope` | object | The scope of the current request. |
| `incident.severity` | string | The severity level of any active incident (for break-glass scenarios). |

**Condition evaluation.** For each permission with a non-null `condition`:
- The system SHALL evaluate the CEL expression against the current request context.
- If the expression evaluates to `true`, the permission passes the ABAC layer.
