# AESP JSON Schemas

Machine-readable request/response shapes for core Agent OS surfaces.

| Schema | Spec |
|:---|:---|
| `tool-invocation.json` | AESP-0015 |
| `plan-artifact.json` | AESP-0015 / ARCHITECTURE |
| `test-evidence-summary.json` | AESP-0010 |
| `deploy-session-summary.json` | AESP-0009 |
| `hitl-task.json` | AESP-0014 |
| `aesp-envelope-min.json` | AESP-0003 (minimal) |

Schemas use JSON Schema 2020-12. Fields marked required are the interoperability minimum; implementations MAY add namespaced extensions (`x-vendor-*`).
