# Engineering Principles — DRY, SoC, API-First, Model-Driven

!!! quote "Sam Newman, *Building Microservices*"
    "Services should be modelled around business capabilities. If you find yourself constantly
    having to deploy two services together, ask whether they should in fact be one service."

!!! quote "Gregor Hohpe, *Enterprise Integration Patterns*"
    "The canonical data model is not an abstraction exercise. It is the contract that lets
    systems evolve independently."

---

## Why Engineering Principles Matter More with AI

Software engineering principles — DRY, Separation of Concerns, API-First, Model-Driven Development
— exist because they reflect hard-won lessons about what makes systems maintainable, scalable, and
safe to change over time. They are not style preferences. They are load-bearing constraints.

AI changes the risk profile of these principles in a specific way: **LLMs are optimised for
immediate task completion, not long-term maintainability.** An LLM will generate code that solves
the stated problem in the stated context, with no awareness of what exists elsewhere in the
codebase, what contracts other systems depend on, or what the team agreed in ADR-007.

This is not a criticism of AI tools. It is a statement about their design. The team member's job,
when using AI assistance, is to bring the principles that the LLM cannot apply autonomously.

For the O&A team, each of the four principles in this section has a specific failure mode when
AI is applied without discipline — and a specific practice that preserves the principle.

---

## DRY — Don't Repeat Yourself

### The Principle

The DRY principle, from *The Pragmatic Programmer* (Hunt & Thomas), states that every piece of
knowledge should have a single, unambiguous, authoritative representation in a system. Duplication
of logic — not just code, but *knowledge* — means that when the knowledge changes, it must be
updated in multiple places. One update is missed. The system diverges.

### Why LLMs Violate DRY

LLMs generate *self-contained, contextually complete* outputs. They do not look across the
codebase. When asked to "write a function that calls the NETCONF get-config operation for an
interface", the LLM will write that function — even if an identical function already exists
in `noa/netconf/client.py`. It cannot know about `noa/netconf/client.py` unless you tell it.

Over time, AI-assisted development without DRY discipline produces codebases with:

- Multiple implementations of NETCONF session establishment, each slightly different.
- YANG helper functions duplicated across three services, maintained independently.
- Ansible task blocks for standard interface configuration copy-pasted across fifteen playbooks.
- Python NETCONF XML builders in four different modules, each with a different bug.

When the NETCONF namespace changes (it does, with device NED upgrades), every duplicate must
be updated. The team finds them one at a time, in production incidents.

### Team Practice: Shared Utility Library

The O&A team maintains a shared library — `noa-common` — that is the single source of truth for:

```
noa-common/
├── netconf/
│   ├── session.py          # Connection pool, session lifecycle
│   ├── rpc_builder.py      # edit-config, get-config, commit, discard-changes
│   ├── response_parser.py  # XML response to Python dict/dataclass
│   └── exceptions.py       # NetconfError hierarchy
├── yang/
│   ├── validator.py        # pyang/yanglint programmatic API
│   ├── diff.py             # YANG tree diffing utilities
│   └── fixtures.py         # Test fixture generation from YANG models
├── ansible/
│   ├── filters/            # Shared Jinja2 filter plugins
│   └── modules/            # Custom Ansible modules for O&A operations
├── tmf/
│   ├── clients/
│   │   ├── tmf639.py       # Resource Inventory client
│   │   ├── tmf641.py       # Service Ordering client
│   │   └── tmf652.py       # Resource Order Management client
│   └── schemas/            # TMF JSON schemas for validation
└── testing/
    ├── netsim.py           # netsim lifecycle management for tests
    └── fixtures/           # Shared pytest fixtures
```

**When AI is asked to write a NETCONF function:** the team member first checks `noa-common/netconf/`.
If it exists, the prompt includes: *"Use the `noa.netconf.rpc_builder.RpcBuilder` class from
our shared library — do not create a new implementation."*

### PR Review Checklist Item

Every PR that involves NETCONF operations, TMF API calls, YANG handling, or Ansible patterns
includes the following review item:

> **DRY check:** Does this change introduce any logic that is already present in `noa-common`?
> Does it introduce any logic that *should* be in `noa-common` for future reuse?

### AI-Assisted DRY Enforcement

Periodically, use AI to audit for duplication:

```
Prompt: "Review the following files from our O&A services repository [paste file list and contents].
Identify any cases where similar logic appears in more than one file — specifically:
NETCONF session management, YANG validation, TMF API client patterns, and Ansible variable
handling. For each duplication found, suggest the common abstraction and which module in
noa-common it should live in."
```

Use the output as an audit starting point. A human reviews and prioritises consolidation work.

### O&A-Specific DRY Hotspots

| Duplication Type | Impact | Consolidation Target |
|---|---|---|
| NETCONF `edit-config` XML construction | Device config corruption risk on namespace drift | `noa.netconf.rpc_builder.RpcBuilder` |
| YANG validation wrapper (`pyang` subprocess call) | Inconsistent error reporting; version drift | `noa.yang.validator.YangValidator` |
| Ansible `ios_config` task patterns | Inconsistent idempotency handling across playbooks | Shared role: `noa_interface_base` |
| TMF Resource Inventory `GET /resource/{id}` calls | Inconsistent 404 handling; retry logic varies | `noa.tmf.clients.tmf639.ResourceInventoryClient` |
| NSO `ncs.maapi` session management | Session leak risk; inconsistent error handling | `noa.nso.session.NsoSession` context manager |

---

## Separation of Concerns (SoC)

### The Principle

Separation of Concerns means that each module, service, or layer has one clearly defined
responsibility, and that it does not reach into the responsibilities of others. In microservices
architecture (Newman), this maps to service boundaries aligned with business capabilities. In
clean architecture, it maps to layer separation — presentation, application, domain, infrastructure.

For the O&A team, SoC protects the boundaries between:

- **Network data collection** (what is happening on the network)
- **Business logic / orchestration** (what should happen based on policy and orders)
- **API layer** (how external systems interact with O&A)
- **Device interaction** (how O&A talks to network elements)

### How AI Violates SoC

AI tools work within the context provided in the prompt. If the prompt describes a task that spans
multiple concerns — "write a function that reads the current interface config from NETCONF, applies
the business rule for bandwidth limits, and updates the TMF Resource Inventory" — the LLM will
produce a single function that does all three. This is the most direct solution to the stated problem.

It is also a SoC violation. The NETCONF retrieval logic is now coupled to the business rule, which
is coupled to the TMF client. Changing any one requires understanding — and potentially modifying —
all three.

### AI Tools Given Explicit Scope Boundaries

When using AI assistance in service development, system prompts explicitly state scope:

```
System prompt: "You are working on the 'resource-collection' service in the O&A platform.
This service is ONLY responsible for:
1. Retrieving network element state via NETCONF get-config and get-data operations.
2. Parsing the response and mapping it to the canonical data model (noa.models.network_state).
3. Publishing the result to the 'network-state-events' Kafka topic.

This service does NOT:
- Apply any business rules or thresholds.
- Call TMF APIs directly.
- Make any decisions about what to do with the data.

Do not generate code that violates these boundaries. If a task requires cross-boundary
logic, flag it and describe what the correct service decomposition would be."
```

This system prompt is stored in `.ai/prompts/resource-collection-context.md` in the service
repository. Team Members paste it at the start of any AI session working on that service.

### Architect Review Gate for AI-Suggested Refactors

Any AI-suggested change that touches module or service boundaries requires architecture review
before merging. The signals that trigger this gate:

- AI suggests importing a class from a sibling service's internal module.
- AI suggests adding a new external API call to a service that previously had no external dependencies.
- AI suggests merging two services "for simplicity".
- AI suggests adding business logic to a data access layer.

The fitness function `FF-04` (no cross-service DB access) catches some of these automatically.
The architecture review gate catches the rest.

### O&A-Specific SoC Boundaries

```
┌─────────────────────────────────────────────────────────────────────────┐
│                         O&A Platform Layers                             │
├─────────────────────────────────────────────────────────────────────────┤
│  API Layer           │ TMF REST APIs (641, 639, 652, 657)               │
│                      │ AsyncAPI event streams                           │
│  Rules:              │ - Validates input; translates to domain model    │
│                      │ - Does NOT contain business logic                │
│                      │ - Does NOT contain NETCONF/NSO calls             │
├─────────────────────────────────────────────────────────────────────────┤
│  Orchestration /     │ Service order fulfilment, state machines         │
│  Business Logic      │ Policy evaluation, SLA checking                  │
│  Rules:              │ - Uses domain model; calls collection/device svcs│
│                      │ - Does NOT parse NETCONF XML directly            │
│                      │ - Does NOT construct TMF response payloads       │
├─────────────────────────────────────────────────────────────────────────┤
│  Collection Layer    │ NETCONF get-config, SNMP polling, telemetry      │
│                      │ Raw state → canonical data model mapping         │
│  Rules:              │ - Returns structured data; no business decisions │
│                      │ - Does NOT call TMF APIs                         │
│                      │ - Does NOT apply thresholds or policies          │
├─────────────────────────────────────────────────────────────────────────┤
│  Device Interaction  │ NETCONF edit-config, RESTCONF, NSO service calls │
│                      │ Device NED abstraction                           │
│  Rules:              │ - Translates canonical model to device config    │
│                      │ - Does NOT contain business logic                │
│                      │ - Does NOT call TMF APIs directly                │
└─────────────────────────────────────────────────────────────────────────┘
```

**AI prompt boundary enforcement:** team members working in a layer include the layer boundary rules
in their AI session system prompt. AI suggestions that cross a boundary are flagged, not accepted.

---

## API-First & Spec-First

### The Principle

API-First means the API contract is designed and agreed before implementation begins. For REST APIs,
this means an OpenAPI specification. For async messaging, an AsyncAPI specification. For YANG-managed
resources, the YANG model.

The specification is not documentation that describes the implementation. It is the *contract* that
precedes and constrains the implementation. Implementation may not deviate from the spec. The spec
is the source of truth.

Sam Newman, in *Building Microservices*, frames this as the key enabler of service independence:
when services communicate only through their published APIs, they can be changed independently,
deployed independently, and scaled independently. The moment one service depends on an internal
implementation detail of another, that independence is lost.

### The O&A API-First Workflow

```
┌─────────────────────────────────────────────────────────────────────┐
│  Step 1: Check TM Forum Open APIs                                   │
│  Does TMF have an existing API for this resource or operation?      │
│  Search TM Forum Open API table: tmforum.org/open-apis             │
│  Candidates: TMF639 (Resource Inventory), TMF641 (Service Order),   │
│  TMF652 (Resource Order Mgmt), TMF657 (Service Quality Mgmt)        │
└────────────────────────┬────────────────────────────────────────────┘
                         │ If TMF API covers it: extend/implement it.
                         │ If TMF API partially covers it: extend with
                         │ extensions (`x-noa-` prefix in OpenAPI).
                         │ If TMF has nothing: proceed to Step 2.
                         ▼
┌─────────────────────────────────────────────────────────────────────┐
│  Step 2: Check Existing O&A Internal APIs                           │
│  Does an existing O&A service already expose this operation?        │
│  Check ./specs/ for existing OpenAPI/AsyncAPI specs.               │
│  If yes: use the existing API. File an enhancement if it's missing  │
│  an operation you need. Do not create a parallel implementation.    │
└────────────────────────┬────────────────────────────────────────────┘
                         │ If no existing coverage: proceed to Step 3.
                         ▼
┌─────────────────────────────────────────────────────────────────────┐
│  Step 3: Author the YANG Model or OpenAPI / AsyncAPI Spec           │
│  YANG: for network resource schemas and NETCONF-managed config.     │
│  OpenAPI: for synchronous REST APIs.                                │
│  AsyncAPI: for event-driven / message bus interactions.             │
│  AI can draft the spec; pyang/spectral validates it; human reviews. │
└────────────────────────┬────────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────────────┐
│  Step 4: Generate Stubs and Validate                                │
│  OpenAPI → FastAPI/Go-chi stubs via openapi-generator              │
│  YANG → Python dataclasses via pyang pyangbind or custom codegen    │
│  AsyncAPI → typed message producers/consumers                       │
│  AI generates the conforming implementation from the validated spec │
└─────────────────────────────────────────────────────────────────────┘
```

**The rule that prevents the most common AI anti-pattern:**

!!! danger "Never: 'Write me a function to call the inventory API'"
    If the first prompt in an AI session is "write me a function to call the inventory API",
    the team member has skipped Steps 1–3. The AI will generate something that works for this
    specific case, is not TMF-compliant, duplicates the existing `noa.tmf.clients.tmf639`
    client, and will be maintained independently of the spec.

    **The correct prompt:** "Using the `noa.tmf.clients.tmf639.ResourceInventoryClient` from
    our shared library (noa-common), write a function that retrieves a logical resource by
    its `@type` attribute. Refer to TMF639 section 5.2 for the expected query parameters."

### AI-Assisted Spec Authoring

AI is genuinely effective at drafting OpenAPI and AsyncAPI specifications when given the right inputs:

```
Prompt: "Draft an OpenAPI 3.1 specification for a O&A internal service that manages
NETCONF session health monitoring. The service should:
- Expose GET /sessions (list active sessions with host, port, username, state, last-used)
- Expose GET /sessions/{id} (get a specific session)
- Expose DELETE /sessions/{id} (forcefully terminate a session)
- Use TMF-consistent naming conventions (id, href, @type, @baseType)
- Return RFC 7807 Problem Details for 4xx/5xx errors.

Use the TMF639 Resource schema as a model for consistent attribute naming."
```

The output is a valid starting point. Run it through `spectral lint` with the O&A ruleset. Review
the resource schema for TMF consistency. Adjust and commit the spec before writing any implementation.

### YANG Validation as a CI Gate

YANG is the spec-first artefact for network configuration. The CI gate ensures that:

1. YANG models are valid before any code is generated from them.
2. Code generated from YANG is regenerated when the YANG changes (not maintained in parallel).
3. AI-generated YANG passes the same CI gate as human-authored YANG.

```makefile
# Makefile — spec-first workflow for YANG
.PHONY: validate-yang generate-models

validate-yang:
    find ./yang/noa -name "*.yang" -exec \
        pyang --strict \
              --path ./yang/modules:./yang/vendor/ietf:./yang/vendor/openconfig \
              {} \;

generate-models: validate-yang
    # Generate Python Pydantic models from validated YANG
    pyang -f jstree ./yang/noa/noa-interface.yang | \
        python3 tools/yang_to_pydantic.py > ./noa/models/interface.py

    # Generate Go structs
    go run tools/yang_to_go.go \
        --yang ./yang/noa/noa-interface.yang \
        --output ./internal/models/interface.go
```

---

## Model-Driven Development

### The Principle

Model-Driven Development (MDD) means that a formal, machine-readable model is the single source
of truth for a domain, and that code artefacts (data classes, serialisers, validators, test
fixtures) are *derived from* that model — not written in parallel to it.

For the O&A team, the YANG model is the canonical source of truth for network resource schemas.
YANG is not just documentation for what the device configuration looks like. It is the schema from
which all other representations are derived.

### YANG as Canonical Source

```
                        ┌─────────────────┐
                        │  YANG Model     │  ← Single source of truth
                        │  (noa/*.yang)   │    validated in CI
                        └────────┬────────┘
               ┌─────────────────┼──────────────────┐
               ▼                 ▼                  ▼
    ┌───────────────────┐  ┌──────────────┐  ┌──────────────────┐
    │ Python Pydantic   │  │ Go structs   │  │ Test fixtures    │
    │ models (generated)│  │  (generated) │  │ (AI-generated    │
    │                   │  │              │  │  from YANG)      │
    └───────────────────┘  └──────────────┘  └──────────────────┘
               ▼                 ▼                  ▼
    ┌───────────────────┐  ┌──────────────┐  ┌──────────────────┐
    │ JSON serialisation│  │ NETCONF RPC  │  │ yanglint instance│
    │ (derived from     │  │ builder      │  │ validation in CI │
    │  Pydantic models) │  │ (derived from│  │                  │
    │                   │  │  Go structs) │  │                  │
    └───────────────────┘  └──────────────┘  └──────────────────┘
```

**The rule:** if data structure X is derived from a YANG model, X is generated from the YANG, not
hand-authored. When the YANG model changes, X is regenerated. X is never edited manually.

If X must be edited manually (because the generator is imperfect or the use case has exceptions),
that fact is recorded as an ADR, the manual additions are clearly marked with a comment explaining
why they are not generated, and they are reviewed when the YANG model changes.

### AI-Assisted Model-Driven Workflows

**Generating Python data classes from YANG:**

```
Prompt: "Given the following YANG module [paste noa-interface.yang], generate Pydantic v2
data model classes for all containers, lists, and leaf types. Use Python 3.12 type hints.
Map YANG types to Python types as follows: uint32 → int, string → str, boolean → bool,
enumeration → Enum, union → Union. Preserve YANG description fields as Python docstrings.
Add a class-level validator for each 'must' constraint using @field_validator."
```

**Generating test fixtures from YANG:**

```
Prompt: "Given the following YANG module and Pydantic models [paste both], generate five
XML test fixture files that would be valid NETCONF get-config responses. Include:
(1) minimal valid instance with only mandatory leaves,
(2) full instance with all optional leaves populated,
(3) list with three entries,
(4) instance that violates the 'must' constraint on 'bandwidth-mbps',
(5) instance with an invalid 'pattern' on 'interface-description'.
Use the ietf-interfaces namespace: urn:ietf:params:xml:ns:yang:ietf-interfaces"
```

### eTOM Process Traceability

The enhanced Telecom Operations Map (eTOM / TM Forum GB921) defines the business processes
that O&A services implement. Tracing code to eTOM process IDs provides:

- **Accountability** — each piece of code can be traced to the business capability it implements.
- **AI context** — when asking AI to work on a service, including the eTOM process ID constrains
  the scope and provides business context.
- **Impact analysis** — when an eTOM process changes (in a new TM Forum release), the affected
  code can be located.

**Practice:** Include eTOM process IDs in module docstrings and in AI session system prompts:

```python
"""
O&A Resource Provisioning Service.

Implements eTOM process: 1.1.1.1 — Enable Resource Provisioning
Sub-process: 1.1.1.1.1 — Allocate & Install Resource

TMF API: TMF652 Resource Order Management v4.0
         TMF639 Resource Inventory Management v4.0

YANG: noa-resource-provisioning (./yang/noa/noa-resource-provisioning.yang)
ADRs: ADR-008 (resource provisioning state machine), ADR-012 (NETCONF session pooling)
"""
```

```
AI system prompt addition: "This code implements eTOM process 1.1.1.1 (Enable Resource
Provisioning). All changes must remain within the scope of this process. If a change
requires logic from eTOM 1.1.1.2 (Configure Resource on Demand), flag it — that logic
belongs in the resource-configuration service, not here."
```

### AI-Assisted ADR Authoring

YANG model decisions — how to model a resource, whether to use augment vs. deviation, which
standard modules to extend — are architectural decisions that deserve ADRs.

```
Prompt: "We are deciding whether to model O&A logical resource interconnections using
(a) a YANG list with leafref keys pointing to existing interface resources, or (b) a
separate 'topology' YANG module that augments the interface module. Draft an ADR using
our template. Context: we use NSO for device provisioning, pyang for validation, and
our consumers are Python services that generate NETCONF RPCs. Our YANG models must
conform to RFC 8342 (Network Management Datastore Architecture). Flag any RFC 7950
constraints that affect the decision."
```

---

## Consolidated Engineering Principles Checklist

### DRY

- [ ] `noa-common` shared library exists and is the single source for NETCONF, YANG, TMF, and Ansible utilities.
- [ ] PR review includes a DRY check: "Does this introduce logic already in `noa-common`?"
- [ ] AI sessions for service work include: "Use the `noa-common` library — do not create new implementations of existing utilities."
- [ ] A DRY audit is run at least once per quarter using AI-assisted duplication detection.

### Separation of Concerns

- [ ] Layer boundaries are documented (API / Orchestration / Collection / Device Interaction).
- [ ] AI session system prompts for each service include explicit scope boundaries.
- [ ] AI-suggested changes that cross layer or service boundaries trigger architecture review.
- [ ] Fitness function FF-04 (no cross-service DB access) runs in CI.

### API-First & Spec-First

- [ ] The workflow (Check TMF → Check internal → Author spec → Generate) is documented and followed.
- [ ] All O&A services have OpenAPI or AsyncAPI specs in `./specs/`.
- [ ] `spectral lint` runs on all spec files in CI.
- [ ] Implementation stubs are generated from specs, not hand-authored.
- [ ] "Write me a function to call the inventory API" is never the first AI prompt — check the spec first.

### Model-Driven Development

- [ ] YANG models are the canonical schema source for all network resource data structures.
- [ ] Python and Go data models are generated from YANG, not authored in parallel.
- [ ] Generated code is clearly marked as generated and is not manually edited.
- [ ] eTOM process IDs are present in module docstrings for services that implement eTOM processes.
- [ ] YANG model decisions are captured as ADRs.
- [ ] AI-assisted ADR authoring is used for YANG modelling decisions, with human review and sign-off.

---

*Previous: [Cognitive Load ←](cognitive-load.md) | Back to: [MSD Foundations Overview ↑](index.md)*
