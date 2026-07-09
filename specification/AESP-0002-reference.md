# AESP-0002: Agent Roles

## Sections 9–14: Schemas, Examples, Counter-Examples, Best Practices, Security, and Future Work

**AESP Number:** 0002  
**Title:** Agent Roles  
**Status:** Draft  
**Depends On:** AESP-0001 (Foundation)  
**Authors:** Writer D (Sections 9–14)  
**Date:** 2024  

---

## 9. JSON Schema Definitions

This section provides normative JSON Schema Draft 2020-12 definitions for all entities defined in AESP-0002. All schemas share the following conventions:

- The `$schema` keyword identifies JSON Schema Draft 2020-12.
- The `$id` keyword provides a stable URI for each schema under the `https://aesp.org/schemas/` namespace.
- All schemas set `additionalProperties: true` at the root to permit implementation-specific extensions, unless otherwise noted.
- Timestamp fields use the `date-time` format as defined by RFC 3339.
- All `id` fields MUST be globally unique within their scope.

Implementations MAY use these schemas directly for validation or derive implementation-specific schemas from them. Implementations MUST reject documents that fail schema validation.

---

### 9.1 RoleTemplate

The `RoleTemplate` schema defines the blueprint for a role. A RoleTemplate is immutable after publication; changes produce a new version.

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "$id": "https://aesp.org/schemas/role-template.json",
  "title": "RoleTemplate",
  "description": "A reusable, versioned blueprint defining a role's permissions, capabilities, composition rules, and constraints. Immutable after publication.",
  "type": "object",
  "required": ["id", "name", "version", "category", "dimension", "permissions", "required_capabilities", "composition_rules"],
  "properties": {
    "id": {
      "type": "string",
      "pattern": "^role\\.[a-z]+\\.[a-z_]+$",
      "description": "Unique identifier for the role template. Format: role.{category_abbrev}.{name}"
    },
    "name": {
      "type": "string",
      "minLength": 1,
      "maxLength": 128,
      "description": "Human-readable name of the role."
    },
    "description": {
      "type": "string",
      "minLength": 1,
      "description": "Detailed description of the role's purpose, accountabilities, and scope."
    },
    "version": {
      "type": "string",
      "pattern": "^\\d+\\.\\d+\\.\\d+$",
      "description": "Semantic version of the template. Changes are breaking or non-breaking per semver."
    },
    "category": {
      "type": "string",
      "enum": ["Execution", "Coordination", "Quality", "Bridge"],
      "description": "Functional category of the role."
    },
    "dimension": {
      "type": "string",
      "enum": ["delivery", "capability", "community", "system"],
      "description": "Organizational dimension this role belongs to."
    },
    "parent_template_id": {
      "type": ["string", "null"],
      "pattern": "^role\\.[a-z]+\\.[a-z_]+$",
      "description": "Parent role template in the inheritance hierarchy. Null for root templates. Max hierarchy depth: 3."
    },
    "permissions": {
      "type": "array",
      "items": { "$ref": "#/$defs/Permission" },
      "description": "Base permissions granted to agents holding this role."
    },
    "required_capabilities": {
      "type": "array",
      "items": { "type": "string", "minLength": 1 },
      "description": "Capabilities an agent MUST possess to be assigned this role."
    },
    "resource_quota_defaults": {
      "type": "object",
      "description": "Default resource limits applied to agents holding this role. Implementation-defined structure.",
      "properties": {
        "max_tokens_per_request": { "type": "integer", "minimum": 1 },
        "max_tasks_active": { "type": "integer", "minimum": 1 },
        "max_memory_mb": { "type": "integer", "minimum": 1 },
        "max_compute_seconds": { "type": "integer", "minimum": 1 }
      }
    },
    "composition_rules": {
      "$ref": "#/$defs/CompositionRules",
      "description": "Constraints on how this role may coexist with other roles."
    },
    "trust_policy_ids": {
      "type": "array",
      "items": { "type": "string", "minLength": 1 },
      "description": "IDs of TrustPolicy entities governing dynamic assumption of this role."
    },
    "phase_affinity": {
      "type": "array",
      "items": {
        "type": "string",
        "enum": ["planning", "execution", "review", "closure", "all"]
      },
      "description": "Work unit phases where this role is most effective."
    },
    "metadata": {
      "type": "object",
      "description": "Extensible metadata including Belbin analog, ARES dimensions, and timestamps.",
      "properties": {
        "belbin_analog": { "type": "string" },
        "ares_dimensions": { "type": "array", "items": { "type": "string" } },
        "created_at": { "type": "string", "format": "date-time" },
        "updated_at": { "type": "string", "format": "date-time" }
      }
    }
  },
  "$defs": {
    "Permission": {
      "type": "object",
      "required": ["action", "resource"],
      "properties": {
        "action": {
          "type": "string",
          "minLength": 1,
          "description": "The action being permitted or denied. Colon-separated namespace (e.g., task:execute)."
        },
        "resource": {
          "type": "string",
          "minLength": 1,
          "description": "The resource the action applies to. Colon-separated path with wildcards (e.g., workunit:*:task)."
        },
        "condition": {
          "type": ["string", "null"],
          "description": "CEL expression evaluated at runtime. Null means unconditional."
        },
        "relationship_constraint": {
          "type": ["object", "null"],
          "description": "ReBAC relationship tuple constraint. Null means no relationship constraint.",
          "properties": {
            "object": { "type": "string" },
            "relation": { "type": "string" },
            "subject_type": { "type": "string" }
          }
        },
        "effect": {
          "type": "string",
          "enum": ["allow", "deny"],
          "default": "allow",
          "description": "Whether this permission grants or denies access."
        }
      }
    },
    "CompositionRules": {
      "type": "object",
      "required": ["can_coexist_with", "conflicts_with", "requires"],
      "properties": {
        "can_coexist_with": {
          "type": "array",
          "items": { "type": "string", "pattern": "^role\\.[a-z]+\\.[a-z_]+$" },
          "description": "Role IDs that MAY be held simultaneously by the same agent in the same scope."
        },
        "conflicts_with": {
          "type": "array",
          "items": { "type": "string", "pattern": "^role\\.[a-z]+\\.[a-z_]+$" },
          "description": "Role IDs that are mutually exclusive with this role in the same scope."
        },
        "requires": {
          "type": "array",
          "items": { "type": "string", "pattern": "^role\\.[a-z]+\\.[a-z_]+$" },
          "description": "Role IDs that MUST be present in the same scope for this role to activate."
        },
        "max_per_workunit": {
          "type": "integer",
          "minimum": 0,
          "description": "Maximum number of agents that may hold this role in a single workunit."
        },
        "min_per_workunit": {
          "type": "integer",
          "minimum": 0,
          "description": "Minimum number of agents required to hold this role for valid crew composition."
        }
      }
    }
  }
}
```

---

### 9.2 RoleAssignment

The `RoleAssignment` schema defines the binding of a RoleTemplate to an Agent within a specific scope.

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "$id": "https://aesp.org/schemas/role-assignment.json",
  "title": "RoleAssignment",
  "description": "A contextual binding of a RoleTemplate to an Agent in a specific namespace scope, with time bounds and resolved effective permissions.",
  "type": "object",
  "required": ["id", "template_id", "template_version", "agent_id", "scope", "granted_permissions", "effective_permissions", "status", "assumed_at"],
  "properties": {
    "id": {
      "type": "string",
      "format": "uuid",
      "description": "Unique assignment identifier."
    },
    "template_id": {
      "type": "string",
      "pattern": "^role\\.[a-z]+\\.[a-z_]+$",
      "description": "Reference to the RoleTemplate being assigned."
    },
    "template_version": {
      "type": "string",
      "pattern": "^\\d+\\.\\d+\\.\\d+$",
      "description": "Version of the RoleTemplate at assignment time."
    },
    "agent_id": {
      "type": "string",
      "format": "uuid",
      "description": "Reference to the Agent (AESP-0001) receiving this assignment."
    },
    "scope": {
      "$ref": "#/$defs/Scope",
      "description": "Namespace scope where this assignment is valid."
    },
    "granted_permissions": {
      "type": "array",
      "items": { "$ref": "#/$defs/Permission" },
      "description": "Permissions from the template before RBAC+ resolution."
    },
    "effective_permissions": {
      "type": "array",
      "items": { "$ref": "#/$defs/EffectivePermission" },
      "description": "Fully resolved permissions after all RBAC+ layers have been applied."
    },
    "status": {
      "type": "string",
      "enum": ["proposed", "active", "suspended", "revoked", "expired"],
      "description": "Current lifecycle state of this assignment."
    },
    "assumed_at": {
      "type": "string",
      "format": "date-time",
      "description": "Timestamp when the assignment became active."
    },
    "expires_at": {
      "type": ["string", "null"],
      "format": "date-time",
      "description": "Auto-expiration time. Null means no expiration."
    },
    "trust_policy": {
      "type": ["object", "null"],
      "description": "If dynamically assumed, reference to the trust policy used.",
      "properties": {
        "trust_policy_id": { "type": "string" },
        "assumed_at": { "type": "string", "format": "date-time" },
        "approval_id": { "type": ["string", "null"] }
      }
    },
    "elevated_via": {
      "type": ["string", "null"],
      "description": "If elevated, reference to the approval or session that authorized it."
    },
    "metadata": {
      "type": "object",
      "description": "Assignment metadata including assignment reason and ARES score.",
      "properties": {
        "assigned_by": { "type": "string" },
        "assignment_reason": { "type": "string" },
        "ares_score": { "type": "number", "minimum": 0, "maximum": 1 }
      }
    }
  },
  "$defs": {
    "Scope": {
      "type": "object",
      "required": ["type", "id"],
      "properties": {
        "type": {
          "type": "string",
          "enum": ["organization", "workunit"],
          "description": "Whether the scope is an organization or a workunit."
        },
        "id": {
          "type": "string",
          "minLength": 1,
          "description": "The organization or workunit identifier."
        }
      }
    },
    "Permission": {
      "type": "object",
      "required": ["action", "resource"],
      "properties": {
        "action": { "type": "string", "minLength": 1 },
        "resource": { "type": "string", "minLength": 1 },
        "condition": { "type": ["string", "null"] },
        "effect": { "type": "string", "enum": ["allow", "deny"], "default": "allow" }
      }
    },
    "EffectivePermission": {
      "type": "object",
      "required": ["action", "resource", "effect", "source", "resolved_at"],
      "properties": {
        "action": { "type": "string", "minLength": 1 },
        "resource": { "type": "string", "minLength": 1 },
        "condition": { "type": ["string", "null"] },
        "effect": { "type": "string", "enum": ["allow", "deny"] },
        "source": {
          "type": "string",
          "description": "Provenance indicating how this permission was derived (e.g., template inheritance, ABAC evaluation)."
        },
        "resolved_at": {
          "type": "string",
          "format": "date-time",
          "description": "Timestamp when this permission was resolved."
        }
      }
    }
  }
}
```

---

### 9.3 PermissionBoundary

The `PermissionBoundary` schema defines a maximum permission ceiling applied to agents, organizations, or workunits.

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "$id": "https://aesp.org/schemas/permission-boundary.json",
  "title": "PermissionBoundary",
  "description": "A maximum permission ceiling that constrains the effective permissions of agents within a scope.",
  "type": "object",
  "required": ["id", "name", "max_permissions", "scope", "priority"],
  "properties": {
    "id": {
      "type": "string",
      "minLength": 1,
      "description": "Unique boundary identifier."
    },
    "name": {
      "type": "string",
      "minLength": 1,
      "maxLength": 256,
      "description": "Human-readable name for the boundary."
    },
    "description": {
      "type": "string",
      "description": "Description of the boundary's purpose and rationale."
    },
    "max_permissions": {
      "type": "array",
      "items": { "$ref": "#/$defs/Permission" },
      "description": "Permission ceiling. Agent effective permissions cannot exceed these."
    },
    "scope": {
      "$ref": "#/$defs/Scope",
      "description": "Where this boundary applies."
    },
    "priority": {
      "type": "integer",
      "minimum": 0,
      "description": "Evaluation priority. Lower values are evaluated first."
    },
    "metadata": {
      "type": "object",
      "description": "Timestamps, audit information, and implementation-specific metadata.",
      "properties": {
        "created_at": { "type": "string", "format": "date-time" },
        "updated_at": { "type": "string", "format": "date-time" },
        "created_by": { "type": "string" }
      }
    }
  },
  "$defs": {
    "Scope": {
      "type": "object",
      "required": ["type", "id"],
      "properties": {
        "type": {
          "type": "string",
          "enum": ["organization", "workunit", "agent"],
          "description": "The scope type this boundary applies to."
        },
        "id": {
          "type": "string",
          "minLength": 1,
          "description": "The identifier of the organization, workunit, or agent."
        }
      }
    },
    "Permission": {
      "type": "object",
      "required": ["action", "resource"],
      "properties": {
        "action": {
          "type": "string",
          "minLength": 1,
          "description": "The action being bounded."
        },
        "resource": {
          "type": "string",
          "minLength": 1,
          "description": "The resource the bound applies to."
        },
        "effect": {
          "type": "string",
          "enum": ["allow", "deny"],
          "default": "deny",
          "description": "Bound effect. Deny entries explicitly prohibit actions regardless of role permissions."
        }
      }
    }
  }
}
```

---

### 9.4 TrustPolicy

The `TrustPolicy` schema defines rules governing dynamic role assumption by agents.

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "$id": "https://aesp.org/schemas/trust-policy.json",
  "title": "TrustPolicy",
  "description": "Rules specifying which agents may dynamically assume a role, under what conditions, and for how long.",
  "type": "object",
  "required": ["id", "name", "role_template_id", "trusted_agents", "duration"],
  "properties": {
    "id": {
      "type": "string",
      "minLength": 1,
      "description": "Unique trust policy identifier."
    },
    "name": {
      "type": "string",
      "minLength": 1,
      "maxLength": 256,
      "description": "Human-readable name for the trust policy."
    },
    "description": {
      "type": "string",
      "description": "Purpose and intended use of this trust policy."
    },
    "role_template_id": {
      "type": "string",
      "pattern": "^role\\.[a-z]+\\.[a-z_]+$",
      "description": "The RoleTemplate this trust policy governs."
    },
    "trusted_agents": {
      "type": "array",
      "items": { "$ref": "#/$defs/AgentMatcher" },
      "description": "Agents eligible to assume this role under this policy."
    },
    "conditions": {
      "type": ["object", "null"],
      "description": "CEL conditions that must be satisfied for role assumption.",
      "properties": {
        "cel_expression": {
          "type": "string",
          "description": "CEL expression evaluated against the request context."
        },
        "required_context": {
          "type": "array",
          "items": { "type": "string" },
          "description": "Context variables required for condition evaluation."
        }
      }
    },
    "duration": {
      "type": "object",
      "required": ["max_seconds"],
      "description": "Maximum duration of a dynamically assumed role session.",
      "properties": {
        "max_seconds": {
          "type": "integer",
          "minimum": 1,
          "description": "Maximum session duration in seconds."
        },
        "extendable": {
          "type": "boolean",
          "default": false,
          "description": "Whether the session duration can be extended."
        }
      }
    },
    "require_approval": {
      "type": ["object", "null"],
      "description": "Approval requirements for role assumption.",
      "properties": {
        "approver_role": {
          "type": "string",
          "pattern": "^role\\.[a-z]+\\.[a-z_]+$",
          "description": "RoleTemplate ID of agents that may approve the assumption."
        },
        "timeout_seconds": {
          "type": "integer",
          "minimum": 1,
          "description": "Maximum time to wait for approval."
        },
        "auto_deny_on_timeout": {
          "type": "boolean",
          "default": true,
          "description": "If true, the assumption is denied when the timeout expires."
        }
      }
    },
    "metadata": {
      "type": "object",
      "description": "Policy metadata including timestamps and audit information."
    }
  },
  "$defs": {
    "AgentMatcher": {
      "type": "object",
      "required": ["type", "match"],
      "properties": {
        "type": {
          "type": "string",
          "enum": ["pattern", "explicit", "role_holder"],
          "description": "Type of agent matching: pattern (CEL expression), explicit (URN), or role_holder (role template ID)."
        },
        "match": {
          "type": "string",
          "description": "The matching criteria based on the type."
        }
      }
    }
  }
}
```

---

### 9.5 RoleSession

The `RoleSession` schema defines an active, time-bounded role assumption record.

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "$id": "https://aesp.org/schemas/role-session.json",
  "title": "RoleSession",
  "description": "An active, time-bounded record of a role assumption via a TrustPolicy.",
  "type": "object",
  "required": ["id", "assignment_id", "status", "started_at", "expires_at"],
  "properties": {
    "id": {
      "type": "string",
      "format": "uuid",
      "description": "Unique session identifier."
    },
    "assignment_id": {
      "type": "string",
      "format": "uuid",
      "description": "Reference to the parent RoleAssignment."
    },
    "status": {
      "type": "string",
      "enum": ["active", "expired", "revoked"],
      "description": "Current session state."
    },
    "started_at": {
      "type": "string",
      "format": "date-time",
      "description": "When the session started."
    },
    "expires_at": {
      "type": "string",
      "format": "date-time",
      "description": "When the session expires."
    },
    "context": {
      "type": "object",
      "description": "Contextual information about the session trigger and trust policy.",
      "properties": {
        "workunit_id": { "type": "string" },
        "trigger": {
          "type": "string",
          "enum": ["trust_policy_assumption", "scheduled_rotation", "break_glass"]
        },
        "trust_policy_id": { "type": "string" },
        "approval_id": { "type": ["string", "null"] }
      }
    },
    "metadata": {
      "type": "object",
      "description": "Session metadata including token hashes and audit info."
    }
  }
}
```

---

### 9.6 Permission

The `Permission` schema is a reusable sub-schema referenced by other schemas. It represents a single permission grant or denial.

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "$id": "https://aesp.org/schemas/permission.json",
  "title": "Permission",
  "description": "A single permission entry specifying an action on a resource with an effect and optional conditions.",
  "type": "object",
  "required": ["action", "resource"],
  "properties": {
    "action": {
      "type": "string",
      "minLength": 1,
      "description": "The action being permitted or denied (e.g., workunit:execute)."
    },
    "resource": {
      "type": "string",
      "minLength": 1,
      "description": "The resource the action applies to (e.g., organization:org-001:workunit:*)."
    },
    "condition": {
      "type": ["string", "null"],
      "description": "CEL expression evaluated at runtime. Null means unconditional."
    },
    "relationship_constraint": {
      "type": ["object", "null"],
      "description": "ReBAC relationship tuple constraint. Null means no constraint.",
      "properties": {
        "object": { "type": "string" },
        "relation": { "type": "string" },
        "subject_type": { "type": "string" }
      }
    },
    "effect": {
      "type": "string",
      "enum": ["allow", "deny"],
      "default": "allow",
      "description": "Whether this permission grants or denies access."
    }
  }
}
```

---

### 9.7 EffectivePermission

The `EffectivePermission` schema represents a fully resolved permission with provenance metadata.

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "$id": "https://aesp.org/schemas/effective-permission.json",
  "title": "EffectivePermission",
  "description": "A permission after full RBAC+ resolution, including provenance metadata.",
  "type": "object",
  "required": ["permission", "provenance", "resolved_at"],
  "properties": {
    "permission": {
      "$ref": "https://aesp.org/schemas/permission.json",
      "description": "The fully resolved permission."
    },
    "provenance": {
      "type": "array",
      "items": { "type": "string" },
      "description": "Ordered list of pipeline steps that contributed to this permission."
    },
    "resolved_at": {
      "type": "string",
      "format": "date-time",
      "description": "Timestamp when this effective permission was computed."
    }
  }
}
```

---

## 10. Examples

This section provides comprehensive examples illustrating correct application of AESP-0002.

### 10.1 Simple Flat Organization

A flat organization with three agents and three roles: Executor, Orchestrator, and Evaluator.

**Organization structure:**

```json
{
  "organization": {
    "id": "org-simple-001",
    "name": "Simple Dev Team",
    "type": "flat",
    "scope": "organization"
  },
  "agents": [
    {
      "id": "agent-dev-001",
      "name": "Developer Agent",
      "capabilities": ["coding", "testing"]
    },
    {
      "id": "agent-ops-001",
      "name": "Operations Agent",
      "capabilities": ["deployment", "monitoring"]
    },
    {
      "id": "agent-qa-001",
      "name": "Quality Agent",
      "capabilities": ["testing", "review"]
    }
  ]
}
```

**Role templates:**

```json
{
  "role_templates": [
    {
      "id": "role.exec.executor",
      "name": "Executor",
      "version": "1.0.0",
      "category": "Execution",
      "dimension": "delivery",
      "permissions": [
        { "action": "task:execute", "resource": "workunit:*:task:*", "effect": "allow" },
        { "action": "task:modify", "resource": "workunit:*:task:*", "effect": "allow" }
      ],
      "required_capabilities": [],
      "composition_rules": {
        "can_coexist_with": ["role.quality.evaluator"],
        "conflicts_with": ["role.coord.orchestrator"],
        "requires": []
      }
    },
    {
      "id": "role.coord.orchestrator",
      "name": "Orchestrator",
      "version": "1.0.0",
      "category": "Coordination",
      "dimension": "delivery",
      "permissions": [
        { "action": "task:*", "resource": "workunit:*:task:*", "effect": "allow" },
        { "action": "workunit:manage", "resource": "workunit:*", "effect": "allow" }
      ],
      "required_capabilities": [],
      "composition_rules": {
        "can_coexist_with": ["role.quality.evaluator"],
        "conflicts_with": ["role.exec.executor"],
        "requires": []
      }
    },
    {
      "id": "role.quality.evaluator",
      "name": "Evaluator",
      "version": "1.0.0",
      "category": "Quality",
      "dimension": "capability",
      "permissions": [
        { "action": "task:review", "resource": "workunit:*:task:*", "effect": "allow" },
        { "action": "task:approve", "resource": "workunit:*:task:*", "effect": "allow" }
      ],
      "required_capabilities": [],
      "composition_rules": {
        "can_coexist_with": ["role.exec.executor", "role.coord.orchestrator"],
        "conflicts_with": [],
        "requires": []
      }
    }
  ]
}
```

**Role assignments:**

```json
{
  "assignments": [
    {
      "id": "ra-dev-exec",
      "template_id": "role.exec.executor",
      "template_version": "1.0.0",
      "agent_id": "agent-dev-001",
      "scope": { "type": "organization", "id": "org-simple-001" },
      "status": "active",
      "assumed_at": "2024-01-15T09:00:00Z"
    },
    {
      "id": "ra-ops-orch",
      "template_id": "role.coord.orchestrator",
      "template_version": "1.0.0",
      "agent_id": "agent-ops-001",
      "scope": { "type": "organization", "id": "org-simple-001" },
      "status": "active",
      "assumed_at": "2024-01-15T09:00:00Z"
    },
    {
      "id": "ra-qa-eval",
      "template_id": "role.quality.evaluator",
      "template_version": "1.0.0",
      "agent_id": "agent-qa-001",
      "scope": { "type": "organization", "id": "org-simple-001" },
      "status": "active",
      "assumed_at": "2024-01-15T09:00:00Z"
    }
  ]
}
```

**Permission resolution for `agent-dev-001` requesting `task:execute` on `workunit:proj-001:task:123`:**

1. **RBAC Core:** `role.exec.executor` grants `task:execute` on `workunit:*:task:*` → allow.
2. **ABAC:** No condition → passes.
3. **ReBAC:** No relationship constraint → passes.
4. **PBAC:** No boundary restrictions → allow.
5. **Result:** ALLOW.

### 10.2 Hierarchical Organization with Matrix Roles

A Spotify-style matrix organization with delivery, capability, and community dimensions.

**Organization structure:**

```json
{
  "organization": {
    "id": "org-matrix-001",
    "name": "Matrix Engineering",
    "type": "hierarchical",
    "dimensions": ["delivery", "capability", "community"]
  },
  "tribes": [
    {
      "id": "tribe-platform",
      "name": "Platform Tribe",
      "squads": [
        { "id": "squad-infra", "name": "Infrastructure Squad" },
        { "id": "squad-data", "name": "Data Platform Squad" }
      ]
    }
  ],
  "chapters": [
    { "id": "chapter-backend", "name": "Backend Engineering", "dimension": "capability" },
    { "id": "chapter-frontend", "name": "Frontend Engineering", "dimension": "capability" }
  ],
  "guilds": [
    { "id": "guild-security", "name": "Security Guild", "dimension": "community" }
  ]
}
```

**Agent with matrix roles:**

```json
{
  "agent": {
    "id": "agent-matrix-dev",
    "name": "Matrix Developer"
  },
  "assignments": [
    {
      "id": "ra-delivery",
      "template_id": "role.exec.executor",
      "version": "1.0.0",
      "scope": { "type": "workunit", "id": "squad-infra" },
      "dimension": "delivery",
      "status": "active"
    },
    {
      "id": "ra-capability",
      "template_id": "role.exec.specialist",
      "version": "1.0.0",
      "scope": { "type": "organization", "id": "chapter-backend" },
      "dimension": "capability",
      "status": "active"
    },
    {
      "id": "ra-community",
      "template_id": "role.quality.auditor",
      "version": "1.0.0",
      "scope": { "type": "organization", "id": "guild-security" },
      "dimension": "community",
      "status": "active"
    }
  ]
}
```

This agent simultaneously holds:
- A **delivery role** (Executor) in the Infrastructure Squad
- A **capability role** (Specialist) in the Backend Engineering Chapter
- A **community role** (Auditor) in the Security Guild

Because each role belongs to a different dimension, there is no conflict. The agent's effective permissions are the union of all three role permissions within their respective scopes.

### 10.3 Permission Resolution Walkthrough

**Scenario:** Agent `agent-senior-001` holds `role.exec.executor` (with parent `role.exec.base`) in organization `org-prod`. The agent requests `task:deploy` on `workunit:proj-001:task:deploy-pkg`.

**Context:**
- Time: 14:30 UTC, Tuesday
- Agent trust level: 0.85
- No active incidents
- Permission boundary: `pb-default-org` (allows all on `org-prod:*`, denies `*:delete`)

**Step-by-step resolution:**

**Step 1 — Collect template permissions:**
- `role.exec.executor` grants: `task:execute` (allow), `task:modify` (allow)
- `role.exec.executor` denies: `task:approve` (deny)

**Step 2 — Apply role hierarchy:**
- `role.exec.base` (parent) grants: `task:execute` (allow), `task:read` (allow)
- Child (`role.exec.executor`) overrides parent's `task:execute` with its own version
- Combined permissions: `task:execute` (allow), `task:modify` (allow), `task:read` (allow), `task:approve` (deny)

**Step 3 — Deduplicate:**
- `(task:execute, workunit:*:task:*)` → allow (from child)
- `(task:modify, workunit:*:task:*)` → allow
- `(task:read, workunit:*:task:*)` → allow (from parent)
- `(task:approve, workunit:*:task:*)` → deny

**Step 4 — ABAC conditions:**
- `task:execute` has condition `agent.trust_level >= 0.5` → agent trust is 0.85 → TRUE → keep
- `task:modify` has condition `time.of_day >= '09:00' && time.of_day <= '17:00'` → 14:30 is in range → TRUE → keep
- `task:read` has no condition → keep
- `task:approve` has no condition → keep

**Step 5 — ReBAC constraints:**
- None of the permissions have relationship constraints → all pass

**Step 6 — Scope restriction:**
- Agent's assignment scope is `org-prod` (organization-scoped)
- Resource `workunit:proj-001:task:deploy-pkg` is within `org-prod` → all permissions valid

**Step 7 — Permission boundary:**
- Boundary `pb-default-org` allows `task:*` on `org-prod:*`
- Requested action `task:deploy` is not in the executor's permission set
- **Result: DENY** (agent does not have `task:deploy` permission)

This illustrates how the RBAC+ pipeline correctly denies access even when the agent has broad permissions, because the specific action is not granted.

### 10.4 Dynamic Role Assumption — Break-Glass Scenario

**Scenario:** A critical production incident occurs at 03:00 UTC. Agent `agent-junior-001` (trust level 0.6) needs temporary deployment permissions.

**Trust policy:**

```json
{
  "id": "tp-break-glass-deploy",
  "name": "Break-Glass Deployment",
  "role_template_id": "role.coord.strategist",
  "trusted_agents": [
    { "type": "pattern", "match": "agent.trust_level >= 0.5" }
  ],
  "conditions": {
    "cel_expression": "incident.severity == 'critical' || incident.severity == 'high'",
    "required_context": ["incident.severity"]
  },
  "duration": { "max_seconds": 1800, "extendable": false },
  "require_approval": {
    "approver_role": "role.coord.orchestrator",
    "timeout_seconds": 120,
    "auto_deny_on_timeout": false
  }
}
```

**Assumption flow:**
1. Incident severity is `critical` → condition evaluates to TRUE
2. Agent trust level is 0.6 ≥ 0.5 → trusted agent check passes
3. Approval requested from an Orchestrator → approved within 60 seconds
4. RoleSession created with 30-minute expiry
5. Agent can now execute deployment tasks
6. After 30 minutes, session automatically expires and assignment is revoked

---

## 11. Counter-Examples

This section illustrates common anti-patterns and incorrect applications of AESP-0002.

### 11.1 Circular Template Inheritance

**Incorrect:**

```json
{
  "role_templates": [
    {
      "id": "role.exec.senior",
      "parent_template_id": "role.exec.lead"
    },
    {
      "id": "role.exec.lead",
      "parent_template_id": "role.exec.senior"
    }
  ]
}
```

**Violation:** Circular inheritance creates an infinite loop in the permission resolution algorithm. The hierarchy must be a Directed Acyclic Graph (DAG).

**Correction:** Remove the circular reference. Only one direction should exist:

```json
{
  "role_templates": [
    {
      "id": "role.exec.senior",
      "parent_template_id": "role.exec.base"
    },
    {
      "id": "role.exec.lead",
      "parent_template_id": "role.exec.senior"
    }
  ]
}
```

### 11.2 Conflicting Roles Assigned to Same Agent in Same Scope

**Incorrect:**

```json
{
  "assignments": [
    {
      "agent_id": "agent-001",
      "template_id": "role.exec.executor",
      "scope": { "type": "workunit", "id": "wu-001" }
    },
    {
      "agent_id": "agent-001",
      "template_id": "role.coord.orchestrator",
      "scope": { "type": "workunit", "id": "wu-001" }
    }
  ]
}
```

**Violation:** `role.exec.executor` lists `role.coord.orchestrator` in `conflicts_with`. Both assignments are in the same scope (`wu-001`).

**Correction:** Assign the roles in different scopes, or choose non-conflicting roles:

```json
{
  "assignments": [
    {
      "agent_id": "agent-001",
      "template_id": "role.exec.executor",
      "scope": { "type": "workunit", "id": "wu-001" }
    },
    {
      "agent_id": "agent-001",
      "template_id": "role.coord.orchestrator",
      "scope": { "type": "workunit", "id": "wu-002" }
    }
  ]
}
```

### 11.3 Permission Boundary Bypass Attempt

**Incorrect:**

```json
{
  "boundary": {
    "id": "pb-restrictive",
    "max_permissions": [
      { "action": "task:read", "resource": "workunit:wu-001:*", "effect": "allow" }
    ]
  },
  "assignment": {
    "template_id": "role.exec.executor",
    "granted_permissions": [
      { "action": "task:execute", "resource": "workunit:wu-001:*", "effect": "allow" }
    ]
  }
}
```

**Violation:** The assignment grants `task:execute`, but the boundary only allows `task:read`. The agent will be denied `task:execute` because the boundary is more restrictive.

**Correction:** Either expand the boundary or restrict the role's permissions:

```json
{
  "boundary": {
    "id": "pb-permissive",
    "max_permissions": [
      { "action": "task:*", "resource": "workunit:wu-001:*", "effect": "allow" }
    ]
  }
}
```

### 11.4 Missing Namespace Scope on Assignment

**Incorrect:**

```json
{
  "assignment": {
    "id": "ra-invalid",
    "template_id": "role.exec.executor",
    "agent_id": "agent-001",
    "scope": null
  }
}
```

**Violation:** Every assignment MUST have a scope. Null scope is invalid.

**Correction:** Provide a valid scope:

```json
{
  "assignment": {
    "id": "ra-valid",
    "template_id": "role.exec.executor",
    "agent_id": "agent-001",
    "scope": { "type": "organization", "id": "org-001" }
  }
}
```

### 11.5 Unconditional Trust Policy

**Incorrect:**

```json
{
  "trust_policy": {
    "id": "tp-dangerous",
    "trusted_agents": [
      { "type": "pattern", "match": "true" }
    ],
    "conditions": null,
    "duration": { "max_seconds": 86400 },
    "require_approval": null
  }
}
```

**Violation:** This trust policy allows ANY agent to assume the role at ANY time for up to 24 hours without approval. This is a significant security risk.

**Correction:** Add proper conditions and approval requirements:

```json
{
  "trust_policy": {
    "id": "tp-safe",
    "trusted_agents": [
      { "type": "pattern", "match": "agent.trust_level >= 0.8" }
    ],
    "conditions": {
      "cel_expression": "incident.severity == 'critical'",
      "required_context": ["incident.severity"]
    },
    "duration": { "max_seconds": 1800, "extendable": false },
    "require_approval": {
      "approver_role": "role.coord.orchestrator",
      "timeout_seconds": 300,
      "auto_deny_on_timeout": true
    }
  }
}
```

### 11.6 Role Template Without Composition Rules

**Incorrect:**

```json
{
  "role_template": {
    "id": "role.orphan",
    "composition_rules": null
  }
}
```

**Violation:** `composition_rules` is required. Without it, the system cannot validate role coexistence constraints.

**Correction:** Provide explicit composition rules:

```json
{
  "role_template": {
    "id": "role.orphan",
    "composition_rules": {
      "can_coexist_with": [],
      "conflicts_with": [],
      "requires": []
    }
  }
}
```

---

## 12. Best Practices

### 12.1 Role Design

1. **Start with the 12 standard templates.** The standard catalog (Section 7) covers most organizational needs. Only create custom templates when standard ones are genuinely insufficient.

2. **Keep permissions minimal.** Each role SHOULD have the smallest set of permissions needed for its function. Overly broad permissions increase the attack surface.

3. **Use conditions for flexibility.** ABAC conditions allow a single role template to adapt to different contexts without creating multiple versions.

4. **Document role purpose.** Every role template SHOULD have a clear description explaining its purpose, accountabilities, and when to use it.

5. **Test composition rules.** Before publishing a role template, verify that its `can_coexist_with`, `conflicts_with`, and `requires` rules produce the intended behavior with existing templates.

### 12.2 Permission Modeling

6. **Deny by default.** Structure your permission model so that absence of an explicit allow results in deny. This is the system default but should be reinforced by boundary design.

7. **Use resource patterns carefully.** Overly broad patterns (e.g., `*:*`) grant excessive permissions. Prefer specific patterns (e.g., `workunit:proj-001:task:*`).

8. **Layer ABAC conditions for time-of-day restrictions.** Use `time.of_day` and `time.day_of_week` conditions to implement business-hours-only access for sensitive operations.

9. **Document ReBAC relationship types.** Maintain a registry of relationship types used in your organization (e.g., `owner`, `member`, `delegate`) to ensure consistency.

10. **Set permission boundaries before assignments.** Define boundaries early in the organization setup process. Boundaries are the safety net that prevents permission escalation.

### 12.3 Assignment Management

11. **Prefer workunit-scoped assignments.** Organization-scoped assignments grant broader access. Use workunit-scoped assignments where possible to limit the blast radius.

12. **Set expiration on sensitive assignments.** Time-bounded assignments reduce the risk of stale permissions. Set `expires_at` on assignments to sensitive roles.

13. **Monitor active assignments.** Regularly audit active assignments to detect anomalies, such as an agent holding an unusual combination of roles.

14. **Use phase binding for workflow roles.** Bind delivery roles to specific work unit phases (e.g., Executor during execution, Evaluator during review) for automatic lifecycle management.

15. **Implement assignment rotation.** For high-privilege roles, implement periodic rotation where assignments expire and must be explicitly renewed.

### 12.4 Organization Patterns

16. **Adopt matrix dimensions early.** Structure your organization with delivery, capability, and community dimensions from the start. Retrofitting dimensions into a flat organization is difficult.

17. **Align boundaries with org structure.** Permission boundaries SHOULD mirror the organizational hierarchy. Organization boundaries should be broader than workunit boundaries.

18. **Use trust policies for on-call scenarios.** Trust policies with time-based conditions are ideal for on-call rotation, allowing temporary elevated access during designated periods.

19. **Implement break-glass procedures.** Define trust policies for emergency scenarios with appropriate approval workflows. Document the break-glass procedure and train operators on it.

20. **Version templates aggressively.** When in doubt, create a new version rather than modifying a published template. Version history provides an audit trail and enables rollback.

---

## 13. Security Considerations

### 13.1 Principle of Least Privilege

Every agent SHOULD operate with the minimum set of permissions necessary to accomplish its tasks. Implementations SHOULD:

- Default to deny for all permissions not explicitly granted.
- Enforce workunit-scoped assignments as the default.
- Require explicit justification for organization-scoped assignments.
- Regularly audit effective permissions against actual usage patterns.

### 13.2 Permission Boundary Enforcement

Permission boundaries are the primary defense against privilege escalation. Implementations MUST:

- Evaluate boundaries on every permission check, not just at assignment time.
- Fail closed (deny) if boundary evaluation cannot be completed.
- Log all boundary intersections that result in permission denial.
- Prevent boundary modification by the agents being constrained.

### 13.3 Trust Policy Hardening

Trust policies enable powerful just-in-time access but introduce risk. Implementations SHOULD:

- Require approval for all trust policy assumptions except fully automated scenarios.
- Set maximum session durations to the minimum necessary (default: 1 hour).
- Disable session extension by default.
- Require multi-factor context for break-glass scenarios (e.g., active incident + approver confirmation).

### 13.4 Audit Logging for Role Changes

All role lifecycle events MUST be logged with the following minimum fields:

| Event | Required Log Fields |
|---|---|
| Template created | template_id, actor_id, timestamp |
| Template published | template_id, actor_id, timestamp |
| Assignment created | assignment_id, template_id, agent_id, scope, actor_id, timestamp |
| Assignment activated | assignment_id, actor_id, timestamp |
| Assignment revoked | assignment_id, reason, actor_id, timestamp |
| Trust policy assumption | policy_id, agent_id, session_id, approval_id, timestamp |
| Session expired | session_id, assignment_id, timestamp |
| Boundary modified | boundary_id, changes, actor_id, timestamp |

Logs SHOULD be tamper-evident and retained for at least 90 days.

### 13.5 Privilege Escalation Prevention

The RBAC+ architecture includes multiple safeguards against privilege escalation:

- **Hierarchy depth limit:** Maximum 3 levels prevents deep inheritance chains.
- **Assumption chaining limit:** Maximum depth of 1 prevents transitive elevation.
- **Boundary intersection:** The most restrictive boundary always wins.
- **Deny overrides:** Explicit deny entries take precedence over allow.
- **Conflict detection:** Mutually exclusive roles cannot coexist in the same scope.

### 13.6 Deny-by-Default Enforcement

The deny-by-default principle MUST be enforced at every layer of the RBAC+ pipeline:

- **RBAC Core:** No permission without an explicit grant.
- **ABAC:** Condition evaluation failure results in deny.
- **ReBAC:** Missing relationship tuple results in deny.
- **PBAC:** Permission outside the boundary results in deny.
- **Final resolution:** Any deny in the pipeline produces an overall deny.

Implementations MUST NOT provide a "permissive mode" that relaxes deny-by-default.

---

## 14. Future Work

### 14.1 Role Marketplace and Discovery

Future specifications MAY define a protocol for role template discovery and exchange between organizations. A role marketplace would enable:

- Sharing proven role templates across organizational boundaries.
- Rating and reviewing role templates based on operational experience.
- Importing domain-specific role catalogs (e.g., healthcare, finance, gaming).

### 14.2 Emergent Role Detection

Research into automatic detection of emergent roles from agent behavior patterns. If an agent consistently performs actions outside its assigned roles, the system MAY suggest a new role template or assignment adjustment.

### 14.3 Cross-Organizational Role Federation

Extending the role model to support federation across independent AEO instances. A federated role system would enable:

- Cross-organizational collaboration with mutually recognized roles.
- Role mapping between organizations with different role catalogs.
- Trust policies that reference external role assertions.

### 14.4 ML-Based Permission Optimization

Machine learning approaches to permission optimization, including:

- Anomaly detection in permission usage patterns.
- Recommendation of least-privilege permission sets based on actual usage.
- Automatic identification of overprivileged assignments.

### 14.5 Integration with Future AESP Specifications

AESP-0002 is designed to integrate with upcoming specifications:

| Specification | Integration Point |
|---|---|
| AESP-0003 (Workflow & Handoffs) | Role assignments drive workflow routing and task delegation |
| AESP-0004 (Agent Communication) | Roles constrain which agents may communicate with each other |
| AESP-0005 (Memory Systems) | Role-based access control for shared memory segments |
| AESP-0006 (Knowledge Graph) | ReBAC relationship tuples feed into the organizational knowledge graph |
| AESP-0007 (Security & Governance) | Permission boundaries and trust policies are the enforcement layer |

---

## Appendix A: Standard Role Catalog Quick Reference

| Role ID | Category | Dimension | Belbin Analog | When to Use |
|---|---|---|---|---|
| `role.exec.executor` | Execution | delivery | Implementer | Primary task performer |
| `role.exec.architect` | Execution | capability | Plant | System design and structure |
| `role.exec.specialist` | Execution | capability | Specialist | Deep domain expertise |
| `role.exec.researcher` | Execution | delivery | Resource Investigator | Information discovery |
| `role.coord.orchestrator` | Coordination | delivery | Coordinator | Workflow direction |
| `role.coord.facilitator` | Coordination | community | Teamworker | Collaboration enablement |
| `role.coord.strategist` | Coordination | system | Monitor Evaluator | Strategic planning |
| `role.quality.evaluator` | Quality | capability | Monitor Evaluator | Quality assessment |
| `role.quality.guardian` | Quality | delivery | Completer Finisher | Standards enforcement |
| `role.quality.auditor` | Quality | community | Monitor Evaluator | Compliance verification |
| `role.bridge.liaison` | Bridge | community | Resource Investigator | Cross-boundary communication |
| `role.bridge.mediator` | Bridge | system | Teamworker | Conflict resolution |

## Appendix B: Glossary

**ABAC (Attribute-Based Access Control):** A permission model that evaluates attributes of the subject, resource, and environment to make authorization decisions.

**CEL (Common Expression Language):** A portable expression language designed for policy evaluation, used in AESP-0002 for ABAC conditions.

**ReBAC (Relationship-Based Access Control):** A permission model that evaluates relationships between subjects and resources, inspired by Google Zanzibar.

**PBAC (Policy-Based Access Control):** A governance layer that applies organization-wide policies to constrain permissions.

**RBAC+:** The four-layer permission architecture defined in AESP-0002, combining RBAC, ABAC, ReBAC, and PBAC.

**RoleTemplate:** A reusable, versioned blueprint defining a role's permissions and constraints.

**RoleAssignment:** A contextual binding of a RoleTemplate to an Agent in a specific scope.

**PermissionBoundary:** A maximum permission ceiling that constrains effective permissions.

**TrustPolicy:** Rules governing dynamic role assumption by agents.

**RoleSession:** A time-bounded record of an active role assumption.

---

*End of AESP-0002: Agent Roles*
