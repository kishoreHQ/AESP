# AESP-0005: Workflow Orchestration, Continued

## 5. Failure Handling

Failure handling in workflow orchestration is not an afterthought; it is a first-class design dimension that must be specified at workflow definition time, not discovered at runtime. The probability that a workflow succeeds on the first attempt decays exponentially with the number of tasks: a workflow with ten tasks each succeeding at 90% reliability completes without intervention only 35% of the time (0.90^10). At 95% per-task reliability, the ten-task completion rate rises to 60% [^8^]. Production agent workflows with dozens of tasks, external API calls, LLM invocations, and human-in-the-loop gates therefore require systematic failure handling at every level of the execution stack.

This chapter defines retry policies, circuit breaker patterns, the saga compensation model, escalation semantics, and error classification for workflow orchestration.

### 5.1 Error Classification

Every task failure MUST be classified into one of three categories to determine the appropriate handling strategy.

| Category | Definition | Examples | Handling Strategy |
|:---|:---|:---|:---|
| `TRANSIENT` | Temporary condition expected to resolve | Network timeout, rate limit, service unavailable | Retry with backoff |
| `SEMANTIC` | Logical error in input, state, or precondition | Invalid input data, missing dependency, policy violation | Escalate or compensate |
| `FATAL` | Unrecoverable condition requiring intervention | Schema violation, authorization denied, resource exhausted | Fail workflow, escalate to human |

`WF-REQ-045`: Every task failure MUST include an error classification (`TRANSIENT`, `SEMANTIC`, or `FATAL`), a machine-readable error code, a human-readable message, and a correlation identifier linking to the execution context.

`WF-REQ-046`: Error classifications MUST be deterministically assignable based on error type, error code, or custom classification rules declared in the workflow definition.

`WF-REQ-047`: A `TRANSIENT` error that persists beyond the maximum retry count MUST be reclassified as `SEMANTIC` or `FATAL` based on the final error observed.

### 5.2 Retry Policies

Retry policies control how many times a failed task is re-attempted and with what delay between attempts. Every task node in a workflow graph MAY declare a retry policy; if none is declared, the workflow-level default applies.

A retry policy consists of five parameters: `maxAttempts` (including the initial attempt), `initialInterval`, `maxInterval`, `backoffCoefficient`, and `nonRetryableErrors`. Temporal's retry policy implementation provides the reference pattern: exponential backoff with jitter prevents thundering herd problems when multiple tasks fail simultaneously [^1^].

`WF-REQ-048`: A retry policy MUST declare `maxAttempts` as a positive integer or zero (unlimited retries). Zero-attempt retry policies mean no retry is attempted — the task fails immediately on first error.

`WF-REQ-049`: Exponential backoff MUST follow the formula: `delay = min(initialInterval × backoffCoefficient^(attempt-1), maxInterval)`. Jitter (randomization of up to 50% of the delay) SHOULD be applied to prevent synchronized retry storms.

`WF-REQ-050`: The `nonRetryableErrors` list MUST declare error codes or error types that cause immediate task failure without retry, regardless of remaining attempts. Authorization failures and schema validation errors are RECOMMENDED as non-retryable by default.

`WF-REQ-051`: Retry policies SHOULD distinguish between idempotent and non-idempotent tasks. Non-idempotent tasks that fail after partial execution MUST NOT be automatically retried without compensation.

### 5.3 Circuit Breaker Pattern

A circuit breaker prevents cascading failures by stopping task dispatch to a failing agent, capability, or external service when failure thresholds are exceeded. The circuit breaker has three states: `CLOSED` (normal operation), `OPEN` (rejecting requests), and `HALF_OPEN` (testing recovery).

`WF-REQ-052`: A workflow execution engine MAY implement circuit breakers for agent assignment, external API calls, and sub-workflow invocation.

`WF-REQ-053`: A circuit breaker MUST transition from `CLOSED` to `OPEN` when the failure rate exceeds a configurable threshold (default: 50% failure rate over a one-minute window with a minimum of 10 requests).

`WF-REQ-054`: A circuit breaker in `OPEN` state MUST reject new task assignments to the failing target with error code `CIRCUIT_OPEN` and SHOULD provide an estimated time-to-recovery based on the configured cooldown period.

`WF-REQ-055`: A circuit breaker MUST transition from `OPEN` to `HALF_OPEN` after a configurable cooldown period (default: 60 seconds) and allow one probe request. If the probe succeeds, the breaker transitions to `CLOSED`; if it fails, the breaker returns to `OPEN` with a doubled cooldown.

### 5.4 Saga Pattern and Compensation

The saga pattern manages long-running, multi-step workflows by pairing each forward action with a compensating action that semantically reverses it. When a later step fails, the saga coordinator executes compensations for all previously completed steps in reverse (last-in-first-out) order, restoring a consistent state [^5^].

```
Forward Actions:      Book Flight → Book Hotel → Book Car → Pay
                            ↓            ↓           ↓       ↓
Compensations:        Cancel Flight ← Cancel Hotel ← Cancel Car ← Refund
```

AESP-0005 requires that every side-effecting task declare a compensation action. A side-effecting task is any task that modifies external state beyond the workflow's own data: making an API call, sending a message, creating a record, or executing a payment.

`WF-REQ-056`: Every side-effecting task MUST declare a compensation action or explicitly declare that no compensation is possible. Tasks that declare no compensation MUST include a rationale in the workflow definition.

`WF-REQ-057`: Compensation actions MUST be idempotent — invoking the same compensation twice MUST produce the same result as invoking it once, and MUST NOT produce new side effects.

`WF-REQ-058`: The saga coordinator MUST execute compensations in strict reverse order of the corresponding forward actions. Concurrent forward actions MUST have their compensations executed in reverse order within their parallel branch.

`WF-REQ-059`: If a compensation action itself fails, the saga coordinator MUST record the compensation failure, attempt the remaining compensations, and escalate the unresolved state to human operators with full context of which compensations succeeded and which failed.

The following JSON schema defines the compensation declaration for a task node:

```json
{
  "compensation": {
    "strategy": "compensate",
    "action": "urn:aeo:activity:cancel-hotel-booking",
    "input": {
      "bookingId": "$.outputs.book-hotel.bookingId",
      "reason": "Workflow failed at task: pay"
    },
    "timeout": "30s",
    "onFailure": "escalate"
  }
}
```

`WF-REQ-060`: Compensation strategies MUST be one of: `compensate` (execute named compensation action), `skip` (no action needed, safe to leave as-is), `notify` (send notification but take no automated action), or `escalate` (raise to human operator immediately without attempting automated compensation).

### 5.5 Timeout Handling

Tasks, sub-workflows, and entire workflows MUST declare timeout values. Timeouts prevent workflows from blocking indefinitely on unresponsive agents, hung LLM calls, or stalled external services.

`WF-REQ-061`: Every task MUST declare a `startToCloseTimeout` (maximum time from task start to completion). Tasks MAY additionally declare `scheduleToStartTimeout` (time from scheduling to assignment) and `heartbeatTimeout` (maximum interval between progress signals).

`WF-REQ-062`: When a task times out, the workflow engine MUST transition the task to `FAILED_RETRYABLE` or `FAILED_FATAL` depending on the remaining retry count.

`WF-REQ-063`: Workflow-level timeout (the maximum wall-clock duration for the entire workflow instance) MUST be enforced. Workflows exceeding this timeout MUST enter `FAILED` state with reason `workflow_timeout`.

### 5.6 Escalation

When automated failure handling is exhausted — retries depleted, compensation unavailable, policy prohibits automated compensation — the workflow MUST escalate to a human operator with structured context.

`WF-REQ-064`: An escalation record MUST include: workflow instance identifier, failed task identifier and type, error classification and code, retry history (attempt timestamps and outcomes), compensation status (none, partial, complete, failed), partial results from completed tasks, and suggested remediation actions.

`WF-REQ-065`: Escalation delivery MUST support multiple channels: message to AESP-0003 inbox of the designated escalation agent, event published to the AEO event bus, or external notification (email, ticketing system) via a configured notification activity.

`WF-REQ-066`: Escalation targets MUST be configurable per workflow definition, with fallback escalation to the AEO governance agent defined in the AEO's organizational model.

## 6. Scheduling and Triggers

Workflow execution may be initiated by explicit request, scheduled time, or external event. This chapter defines the scheduling models and trigger types that conforming implementations MUST support.

### 6.1 Execution Initiation Models

| Model | Trigger | Latency | Use Case |
|:---|:---|:---|:---|
| Explicit | Direct invocation | Immediate | On-demand tasks, API-driven workflows |
| Scheduled | Cron expression or calendar | Deterministic | Periodic maintenance, reports |
| Event-driven | External event or message | Sub-second | Real-time responses, webhook handlers |
| Chained | Completion of another workflow | Variable | Workflow composition, pipelines |

`WF-REQ-067`: A conforming implementation MUST support explicit workflow invocation with full input parameters.

`WF-REQ-068`: A conforming implementation SHOULD support at least one of scheduled or event-driven initiation.

### 6.2 Scheduled Execution

Scheduled execution initiates a workflow instance at a predetermined time or on a recurring schedule.

`WF-REQ-069`: Scheduled workflows MUST use standard cron expressions (five-field UNIX cron or six-field with seconds) for recurring schedules, or ISO 8601 datetime for one-time schedules.

`WF-REQ-070`: A scheduled workflow MUST declare its timezone. If no timezone is declared, UTC is assumed.

`WF-REQ-071`: Missed schedules (due to system downtime or backpressure) SHOULD be handled according to a declared catch-up policy: `catchUp` (execute all missed instances), `catchUpLast` (execute only the most recent missed instance), or `skip` (do not execute missed instances).

`WF-REQ-072`: Scheduled workflow instances MUST share the same workflow definition version at the time of each execution, unless a newer version is explicitly deployed for the schedule.

### 6.3 Event-Driven Triggers

Event-driven triggers initiate workflows in response to external events, messages, or signals.

`WF-REQ-073`: An event-driven trigger MUST declare the event source, event type, optional filter conditions, and mapping from event payload to workflow input parameters.

`WF-REQ-074`: Event sources MAY include AESP-0003 message bus, webhook endpoints, message queue topics, or custom event adapters.

`WF-REQ-075`: Event delivery MUST include at-least-once semantics with idempotency key deduplication. Implementations SHOULD reject duplicate events based on the event's unique identifier.

`WF-REQ-076`: Webhook-based triggers MUST validate the webhook payload using a configurable signature verification mechanism (HMAC, JWS, or TLS client certificate) before workflow creation.

### 6.4 Workflow Chaining

Workflow chaining triggers a downstream workflow upon completion of an upstream workflow.

`WF-REQ-077`: A workflow chaining trigger MUST declare the upstream workflow identifier, completion status filter (`completed`, `compensated`, or `any`), and input mapping from upstream outputs to downstream inputs.

`WF-REQ-078`: Chained workflows MUST be correlated through a shared correlation identifier that traces across the chain.

`WF-REQ-079`: Circular workflow chains MUST be detected and prevented at definition validation time.

### 6.5 Trigger Registration and Management

`WF-REQ-080`: Trigger definitions MUST be versioned and stored alongside workflow definitions. A trigger reference MUST include the trigger identifier, type, and version.

`WF-REQ-081`: Trigger lifecycle (enabled, disabled, paused, retired) MUST be independent of workflow definition lifecycle. Disabling a trigger MUST prevent new workflow instances from being created by that trigger; running instances are unaffected.

`WF-REQ-082`: All trigger activations MUST be auditable, recording the trigger identifier, created workflow instance identifier, event payload (or reference), and timestamp.

## 7. State Persistence and Checkpointing

Workflow state persistence is the mechanism that ensures workflow execution survives process crashes, machine failures, network partitions, and planned restarts. Without durable state, a workflow that runs for hours or days risks total progress loss on any infrastructure disruption. This chapter defines checkpointing models, state storage alignment with AESP-0004, replay semantics, and migration procedures.

### 7.1 Durable Execution Model

A durable workflow execution engine maintains the invariant that a workflow instance will eventually reach a terminal state (COMPLETED, FAILED, COMPENSATED, or CANCELLED) regardless of infrastructure failures. This is achieved through event-sourced state persistence: every state transition, task result, and signal received is recorded as an immutable event, and the current workflow state is reconstructed by replaying the event log from the beginning [^1^].

`WF-REQ-083`: A conforming workflow execution engine MUST persist workflow state durably. In-memory-only execution without persistence is non-conformant for any workflow with `timeout` greater than 60 seconds or any workflow that declares compensation actions.

Temporal's event history model serves as the reference architecture: each workflow execution appends events to a history stream, and workers reconstruct state by replaying the history from the event store. This enables time-travel debugging, deterministic replay, and complete audit trails [^1^]. LangGraph uses checkpointing where each node execution saves state including the pending outbox of messages to send, enabling pause-and-resume at any graph node [^2^].

### 7.2 Checkpoint Models

Checkpoints capture workflow state at specific execution points. Two checkpoint models are supported:

**Event-sourced checkpoints** record every state mutation as an immutable event. State reconstruction replays all events from the beginning. This provides the strongest audit guarantees but requires more storage and replay time for long-running workflows with many events.

**Snapshot checkpoints** record the complete workflow state at periodic intervals. Recovery loads the most recent snapshot and replays only events after that snapshot. This trades some audit granularity for faster recovery.

`WF-REQ-084`: A workflow engine MUST support at least one checkpoint model. Implementations SHOULD support both event-sourced and snapshot checkpointing for production deployments.

`WF-REQ-085`: Snapshot checkpoints MUST include: workflow instance identifier, workflow definition version, current node and state, task completion map, pending signals, compensation stack, variable values, and a causal timestamp or version vector.

`WF-REQ-086`: Snapshot frequency MUST be configurable: after each task, after N tasks, after each state transition, or at explicit checkpoint nodes in the workflow graph.

### 7.3 State Storage Alignment with AESP-0004

Workflow state SHOULD be stored using the AESP-0004 memory model to ensure consistency with the AEO's overall data management strategy.

`WF-REQ-087`: Workflow checkpoint and event data MAY be stored in any backend, but if AESP-0004 memory is available, workflow state SHOULD use episodic memory records (for execution traces) and procedural memory records (for workflow definitions that represent learned procedures).

`WF-REQ-088`: Workflow state memory records MUST include workflow instance identifier as a required field for correlation.

`WF-REQ-089`: Workflow execution events stored as AESP-0004 memory MUST conform to the episodic memory record schema with `observedAt`, `recordedAt`, `actor`, `source`, and `provenance` fields as defined in AESP-0004 Section 2.3.

The following mapping aligns workflow state with AESP-0004 memory types:

| Workflow Data | AESP-0004 Memory Type | Retention | Retrieval Mode |
|:---|:---|:---|:---|
| Workflow definition | Procedural | Lifetime of workflow version | Capability, intent |
| Execution trace | Episodic | Configurable (default 90 days) | Temporal, work-unit |
| Task results | Episodic | Configurable (default 30 days) | Temporal, associative |
| Checkpoint snapshot | Episodic (with fast projection) | Until superseded | Direct lookup |
| Human decisions | Semantic | Lifetime of organization audit policy | Entity, temporal |
| Compensation records | Episodic | Lifetime of organization compliance policy | Temporal, work-unit |

### 7.4 Replay and Recovery

Replay is the process of reconstructing workflow state from persisted events or checkpoints after a failure or restart.

`WF-REQ-090`: A workflow engine MUST support transparent recovery: after a crash or restart, running and paused workflow instances MUST be automatically reconstructed from durable state and continue execution from the correct point.

`WF-REQ-091`: Replay MUST be deterministic. Nondeterministic workflow code (random number generation, system time access, unordered collection iteration) MUST be identified and prohibited at validation time.

`WF-REQ-092`: Workflow engines SHOULD support time-travel debugging: the ability to replay a workflow to any point in its execution history and inspect the state at that point.

### 7.5 State Migration

Workflow state may need to migrate across workflow definition versions, storage backends, or AEO deployments.

`WF-REQ-093`: Running workflow instances SHOULD continue execution using the workflow definition version they were started with, unless explicitly migrated to a newer version.

`WF-REQ-094`: State migration across storage backends MUST preserve all task results, compensation state, pending signals, and audit history. A migration that loses state is non-conformant.

`WF-REQ-095`: Version migration of running workflows MUST be explicitly triggered and auditable. Automatic version upgrades for running workflows are NOT RECOMMENDED unless the version change is backward-compatible (only PATCH-level changes).

## 8. Human-in-the-Loop

Human-in-the-loop (HITL) integration is not an optional feature for production agent workflows; it is a governance requirement. Workflows that modify protected resources, authorize financial transactions, approve code deployments, make legal determinations, or affect user data MUST include human review gates. This chapter defines the HITL state model, signal-based communication patterns, timeout and escalation semantics, and audit requirements.

### 8.1 HITL State Model

A workflow that requires human intervention enters a `PAUSED` sub-state indicating what input is expected and from whom.

| HITL State | Definition | Exit Condition |
|:---|:---|:---|
| `AWAITING_APPROVAL` | Waiting for yes/no decision | Approval or rejection signal received |
| `AWAITING_INPUT` | Waiting for data, selection, or instruction | Input signal with valid data received |
| `AWAITING_REVIEW` | Waiting for quality review | Review signal with pass/fail received |
| `ESCALATED` | Timeout expired, escalated to alternate | Escalation resolution signal received |
| `INTERVENED` | Human manually modified state or rerouted | Intervention complete signal |

`WF-REQ-096`: A workflow that enters HITL state MUST record: the requesting agent and task, the human role or identity expected to respond, the input schema or decision options, the context provided to the human, and the timeout for automatic escalation.

`WF-REQ-097`: HITL pauses MUST be resource-efficient. A paused workflow MUST NOT consume compute resources (LLM tokens, agent execution slots) while waiting. Temporal's durable timer pattern — where a workflow waits indefinitely without consuming compute — is the RECOMMENDED implementation [^6^].

### 8.2 Signal-Based Communication

HITL interactions are mediated through signals — asynchronous messages delivered to a running workflow instance. Signals are the primary mechanism for delivering human decisions, approvals, inputs, and interventions into a workflow.

`WF-REQ-098`: Signals MUST include: signal type (approve, reject, input, escalate, intervene), sender identity, workflow and task identifiers, payload conforming to the expected schema, and timestamp.

`WF-REQ-099`: Signal delivery MUST be durable. A signal sent to a PAUSED workflow MUST be persisted and delivered when the workflow resumes, even if the workflow engine restarts between signal send and delivery.

`WF-REQ-100`: A workflow instance awaiting a signal MUST expose its pending signal requirements — what signal types are expected, from whom, with what schema — via a query handler accessible to monitoring and UI tooling.

The following JSON schema defines the approval signal payload:

```json
{
  "signalType": "approval.decision",
  "sender": "urn:aeo:human:senior-engineer",
  "workflowId": "urn:aeo:workflow:deploy-review:v3-instance-42",
  "taskId": "approve-deployment",
  "decision": "approved",
  "rationale": "All tests pass, security review complete",
  "conditions": "Roll back if error rate exceeds 1% within 1 hour",
  "timestamp": "2026-07-10T14:30:00Z",
  "signature": "jws-encoded-signature"
}
```

`WF-REQ-101`: Signals carrying approval or rejection decisions SHOULD be digitally signed (JWS) when the workflow involves regulated, financial, or legal actions.

### 8.3 Escalation and Timeout

HITL pauses MUST have timeout policies to prevent workflows from blocking indefinitely on unresponsive human participants.

`WF-REQ-102`: Every HITL pause MUST declare a timeout duration. If the timeout expires before the expected signal is received, the workflow MUST execute the escalation policy.

`WF-REQ-103`: Escalation policies MUST be one of: `autoApprove` (treat as approved), `autoReject` (treat as rejected), `escalateToSupervisor` (route to next-level human), `escalateToAlternate` (route to a different human of the same role), or `fail` (fail the workflow with reason `hitl_timeout`).

`WF-REQ-104`: Escalation chains MUST be configurable. An escalation policy that routes to a supervisor MAY itself have a timeout that routes to a higher-level supervisor or executive. Escalation depth SHOULD be limited to a maximum of five levels to prevent infinite escalation loops.

### 8.4 HITL Audit Requirements

`WF-REQ-105`: All HITL interactions MUST be recorded in the workflow audit trail, including: the workflow instance identifier and current node, the requesting agent and task, the human identity or role, the input or context provided, the decision or input received, the timestamp of request and response, and the escalation chain if timeouts occurred.

`WF-REQ-106`: HITL audit records MUST be immutable after creation. Corrections to a human decision MUST create a new audit record superseding the previous one, not modify the original.

### 8.5 HITL Implementation Patterns

The following patterns are RECOMMENDED for integrating HITL into workflow definitions:

**Pre-approval gate**: A workflow pauses for human approval before executing a high-risk task. The approval request includes context (what will happen, what changed, risk assessment) and expected output (approved, rejected, modified). This is the most common HITL pattern and SHOULD be used for deployments, financial transactions, user communications, and permission changes.

**Review gate**: A workflow executes a task, then pauses for human review of the output before proceeding. Review gates SHOULD be used for content generation, code review, incident response actions, and any LLM-generated output that affects users or systems.

**Escalation during execution**: A task that encounters an unexpected condition or confidence threshold below a configured minimum automatically routes to a human for guidance. This pattern SHOULD be used when the agent's confidence in its output falls below a threshold (default: 0.7 on a 0-1 scale), when the agent encounters an error class it cannot handle, or when the input contains sensitive data that requires human handling.

**Manual intervention**: A human may intervene in a running workflow at any point, modifying inputs, rerouting execution, or canceling tasks. This MAY be supported but is NOT REQUIRED for conformance.

`WF-REQ-107`: Pre-approval gates MUST be used for workflow tasks that: modify access control policies, execute financial transactions exceeding configurable thresholds, approve code deployments to production, modify user data in bulk, or initiate communications with external parties on behalf of the organization.

`WF-REQ-108`: Review gates SHOULD be used for LLM-generated content that will be published, shared with customers, or used in legal or compliance contexts.
