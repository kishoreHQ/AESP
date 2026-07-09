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
