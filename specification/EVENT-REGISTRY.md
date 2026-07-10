# AESP Baseline Event Type Registry

*Status: Informative registry referenced by AESP-0011 and integrations | Date: 2026-07-10*

Event type strings SHOULD use reverse-DNS or `aesp.*` namespacing. Implementations MAY add namespaced extensions (`vendor.*`).

## 1. Work and Workflow

| Type | When |
|:---|:---|
| `aesp.workunit.created` | WorkUnit accepted |
| `aesp.workunit.completed` | WorkUnit terminal success |
| `aesp.workunit.failed` | WorkUnit terminal failure |
| `aesp.workflow.started` | Workflow instance started |
| `aesp.workflow.task.started` | Task started |
| `aesp.workflow.task.completed` | Task completed |
| `aesp.workflow.completed` | Workflow terminal |

## 2. Generation and Docs

| Type | When |
|:---|:---|
| `aesp.codegen.session.started` | Codegen session start |
| `aesp.codegen.session.completed` | Codegen terminal |
| `aesp.docs.session.completed` | Docs session terminal |
| `aesp.docs.drift.detected` | Living docs drift |

## 3. Test and Deploy

| Type | When |
|:---|:---|
| `aesp.test.session.completed` | Test session terminal |
| `aesp.test.gate.failed` | Quality gate fail |
| `aesp.deploy.session.started` | Deploy start |
| `aesp.deploy.gate.failed` | Health gate fail |
| `aesp.deploy.rolled_back` | Rollback finished |
| `aesp.deploy.succeeded` | Deploy success |

## 4. Observability and Remediation

| Type | When |
|:---|:---|
| `aesp.alert.fired` | Alert transition to firing |
| `aesp.alert.resolved` | Alert resolved |
| `aesp.slo.burn` | Error budget burn threshold |
| `aesp.incident.opened` | Incident created |
| `aesp.incident.mitigated` | Mitigation applied |
| `aesp.incident.resolved` | Incident closed |
| `aesp.remediation.action.executed` | Playbook action result |

## 5. HITL and Security

| Type | When |
|:---|:---|
| `aesp.hitl.task.created` | Human task created |
| `aesp.hitl.task.completed` | Human decision recorded |
| `aesp.hitl.task.expired` | Timeout without decision |
| `aesp.security.authz.deny` | Authorization denied |
| `aesp.security.breakglass` | Break-glass activated |

## 6. Integration

| Type | When |
|:---|:---|
| `aesp.tool.invoked` | Tool call started |
| `aesp.tool.completed` | Tool call finished |
| `aesp.provider.invoked` | LLM provider call |
| `aesp.provider.fallback` | Provider fallback used |
| `aesp.mcp.session.ready` | MCP server initialized |
| `aesp.connector.unhealthy` | Connector health fail |

## 7. Rules

1. Events MUST include timestamp and producer resource identity when emitted under AESP-0011.  
2. Events SHOULD include `workUnitId` when available.  
3. Payload fields MUST NOT include raw secrets.
