# Spec-First Development — YANG, OpenAPI & AsyncAPI with AI

> **Audience:** All O&A team members building or modifying services, network automation tools, or integration components.
> **The rule:** The interface contract — YANG model, OpenAPI spec, AsyncAPI schema — is written and validated **before** implementation code is generated or reviewed.

---

## The Spec-First Principle

### Definition

Spec-first development means that the formal interface contract for any API, event stream, or network data model is **authored, reviewed, and validated** before a single line of implementation code is written. The spec is not generated from the code. The code is generated from — and must conform to — the spec.

This is not a new principle. It is the standard practice for API-driven development. It becomes critical when AI is in the loop.

### Why It Matters for AI-Assisted Development

AI code generation reverses the instinctive temptation of "I'll write the code and document it later". With AI, the temptation becomes "I'll ask the AI to build it, then maybe generate a spec from the code". This is the **code-first anti-pattern**, and it produces:

- **Inconsistent interfaces:** The AI generates what was asked for in the moment. The next prompt produces slightly different field names, response shapes, or error codes. Without a spec as the ground truth, there is no way to detect the inconsistency until integration breaks.
- **Undocumented APIs:** Code generated without a spec rarely produces complete API documentation. Field semantics, optional vs. required distinctions, and lifecycle constraints live only in the AI's generation history.
- **Standards drift:** Without a spec that references the relevant TM Forum Open API or YANG standard, AI-generated code silently diverges from the standards that make integrations work.
- **Untestable contracts:** Contract tests require a spec. Without one, you can only test behaviour, not conformance.

### The Spec-First Workflow

```
Requirements
     │
     ▼
Spec Authoring ─────────────────────────────────────────┐
  (YANG / OpenAPI / AsyncAPI)                            │
     │                                                   │
     ▼                                              AI assists:
Spec Review & Validation                           - Draft from
  (human + automated tooling)                        requirements
     │                                             - Explain model
     ▼                                             - Validate logic
AI Generates Implementation Stubs ◄────────────────────┘
  (server stubs / client SDKs / data classes)
     │
     ▼
Tests Written Against the Spec
  (contract tests, conformance tests)
     │
     ▼
Implementation
  (AI assists; spec is the source of truth)
     │
     ▼
CI Gate: Spec Validation Passes
  (pyang, openapi-spec-validator, spectral)
```

The spec is the **source of truth** throughout. If the implementation diverges from the spec, the implementation is wrong, not the spec.

---

## YANG Models — Spec-First for Network Device Interfaces

### What YANG Is

YANG (Yet Another Next Generation, RFC 6020 / RFC 7950) is the data modelling language used by NETCONF and RESTCONF — the standard protocols for programmatic network device configuration and state retrieval. YANG defines the structure, types, constraints, and semantics of configuration and operational data on network elements.

If your automation code pushes configuration to a network device via NETCONF, or reads operational state via RESTCONF, you are working with YANG models — either the vendor's published models, IETF standard models, or OpenConfig models. Understanding the relevant YANG model is a prerequisite for correct automation.

For O&A, YANG models serve as the spec-first contract for all **network device interfaces**. The YANG model defines exactly what configuration data looks like, what values are valid, and what the device's operational state structure is. AI generates implementation from the model; the model is the authority.

### Relevant YANG Model Families

| Model Family | Source | O&A Use Cases |
|---|---|---|
| **IETF YANG models** | IETF RFCs (e.g., RFC 8343 ietf-interfaces) | Interface management, routing, IP addressing |
| **OpenConfig models** | openconfig.net | Multi-vendor network automation, telemetry |
| **Vendor YANG models** | Cisco, Nokia, Juniper, Ericsson | Vendor-specific features not covered by IETF/OC |
| **O&A internal models** | This team | Service-layer augmentations, automation metadata |

### AI + YANG Workflow

#### Step 1: Use AI to Draft YANG Modules from Requirements

AI can draft YANG modules from a natural-language description of the data model. This is a productive starting point — but **never trust AI-generated YANG directly**. Always validate with `pyang` and `yanglint` before use.

**Prompt pattern:**
```
I need a YANG module for managing O&A automation metadata on network
interfaces. The module should augment ietf-interfaces:interface with:
- A container 'noa-automation' containing:
  - leaf 'managed' (boolean, default false) — whether O&A manages this interface
  - leaf 'template-id' (string) — ID of the config template applied
  - leaf 'last-pushed' (yang:date-and-time) — timestamp of last config push
  - leaf 'push-status' (enumeration: pending, in-progress, success, failed)

Use RFC 7950 syntax. Import ietf-yang-types for date-and-time.
Namespace: http://noa.example.com/yang/noa-automation
Prefix: noa-auto
```

**Always follow up with validation:**
```bash
pyang --strict -f tree noa-automation.yang
yanglint noa-automation.yang
```

If `pyang` reports errors, feed them back to the AI for correction. Repeat until clean.

#### Step 2: Use AI to Understand Existing YANG Modules

Large vendor YANG modules — Cisco IOS XE, Nokia SR OS, Juniper Junos — are complex. AI is highly effective at explaining them:

```
Prompt: "I've pasted the ietf-interfaces YANG module below.
         Explain the relationship between 'interface', 'interface-ref',
         and 'interface-statistics'. What XPath expressions would I use
         to query operational state for a specific interface by name
         using RESTCONF?"
```

```
Prompt: "In the openconfig-network-instance YANG module, what is the
         correct path to configure a BGP peer group with MD5
         authentication under a specific VRF? Show me the NETCONF
         edit-config RPC XML payload."
```

#### Step 3: Generate Python/Go Data Classes from YANG Modules

Once the YANG model is validated, use AI to generate the language-level data structures that your automation code uses:

**Python (using yangson or pydantic):**
```
Prompt: "Given the following validated YANG module (pasted below),
         generate Python Pydantic v2 dataclasses representing the
         data model. Include:
         - Type mapping: YANG string → str, uint32 → int,
           boolean → bool, enumeration → Python Enum,
           date-and-time → datetime
         - Validators for YANG 'must' expressions where feasible
         - A method to_netconf_xml() that serialises to NETCONF
           edit-config XML format
         - A classmethod from_restconf_json() that deserialises
           from RESTCONF JSON (RFC 7951 encoding)"
```

**Go (using goyang):**
```
Prompt: "Generate Go structs for the YANG module below, suitable
         for use with the goyang library. Include JSON tags using
         RFC 7951 YANG-JSON encoding (namespace-qualified keys for
         top-level identifiers)."
```

#### Step 4: Generate Test Fixtures from YANG Models

```
Prompt: "Generate 5 valid XML instance documents for the noa-automation
         YANG module below. Cover:
         1. Minimal valid instance (only mandatory leaves)
         2. Full instance with all optional fields
         3. Interface in 'failed' push-status
         4. Unmanaged interface (managed=false, no template-id)
         5. Instance with a push in progress

         Also generate 2 invalid instances that should fail YANG
         validation, with an explanation of which constraint is violated."
```

Test fixtures generated this way can be used as `yanglint` validation test cases and as NETCONF RPC payloads in integration tests.

### CI Gate: YANG Validation

Every PR that modifies a YANG module must pass automated validation:

```yaml
# .github/workflows/yang-validate.yml (or equivalent CI config)
- name: Validate YANG modules
  run: |
    pyang --strict -f tree yang/noa-automation.yang
    yanglint yang/noa-automation.yang
    # Validate instance documents
    yanglint -t config yang/noa-automation.yang tests/fixtures/yang/*.xml
```

**`pyang` flags to use:**
- `--strict`: enforces RFC compliance, not just syntax
- `-f tree`: produces a human-readable tree view — include this output in PR descriptions for YANG changes
- `--lint`: runs additional lint checks for RFC compliance

### Common AI YANG Mistakes

| Mistake | Example | Why It Fails |
|---------|---------|-------------|
| **Incorrect `must` expressions** | `must "not(. = 'failed') or ../managed = 'true'";` with wrong XPath scope | `must` uses relative XPath; scope errors cause pyang failures |
| **Missing namespace declarations** | Imports `ietf-yang-types` without `import` statement | YANG modules require explicit imports for every external type |
| **Wrong `uses`/`grouping` patterns** | Defines a `grouping` but uses it before definition in module order | YANG requires groupings to be defined before use in some parsers |
| **Incorrect `augment` target path** | `augment "/ietf-interfaces:interface/config"` (OpenConfig path used on IETF model) | Augment path must exactly match the target module's schema tree |
| **Missing `config false` on operational data** | Omitting `config false` on state-only leaves | Without `config false`, state leaves appear in config operations |
| **Incorrect `default` statement placement** | `default` on a leaf inside a `choice` without a `case` | YANG `default` in `choice` applies to the case, not individual leaves |

### Example: Spec-First YANG Workflow for an Interface Augmentation

**Requirement:** O&A needs to track, per network interface, whether the interface is under O&A management and what config template was last applied.

**Step 1 — Spec:** Draft the YANG module (AI-assisted, human-reviewed, pyang-validated):

```yang
module noa-automation {
  yang-version 1.1;
  namespace "http://noa.example.com/yang/noa-automation";
  prefix noa-auto;

  import ietf-interfaces { prefix if; }
  import ietf-yang-types { prefix yang; }

  // eTOM: 1.3.4.1 Resource Configuration Management
  augment "/if:interfaces/if:interface" {
    container noa-automation {
      description "O&A automation metadata for a network interface.";

      leaf managed {
        type boolean;
        default false;
        description "When true, this interface is under O&A automated management.";
      }

      leaf template-id {
        type string { length "1..64"; }
        description "Identifier of the O&A config template last applied.";
      }

      leaf last-pushed {
        type yang:date-and-time;
        config false;  // operational state only
        description "Timestamp of the most recent successful config push.";
      }

      leaf push-status {
        type enumeration {
          enum pending    { description "Config push queued."; }
          enum in-progress { description "Config push in progress."; }
          enum success    { description "Last push completed successfully."; }
          enum failed     { description "Last push failed. See system log."; }
        }
        config false;
        description "Status of the most recent config push operation.";
      }
    }
  }
}
```

**Step 2 — Validate:**
```bash
pyang --strict -f tree noa-automation.yang
# Expected output:
# module: noa-automation
#   augment /if:interfaces/if:interface:
#     +--rw noa-automation
#        +--rw managed?       boolean
#        +--rw template-id?   string
#        +--ro last-pushed?   yang:date-and-time
#        +--ro push-status?   enumeration
```

**Step 3 — AI generates implementation** (Pydantic models, NETCONF serialiser, RESTCONF client)

**Step 4 — Tests against spec** (yanglint fixture validation, integration tests using generated client)

---

## OpenAPI Specs — Spec-First for REST Services

### When to Use OpenAPI

Every REST API exposed by an O&A service must have a complete, valid OpenAPI 3.x specification. No exceptions. This applies to:

- TM Forum Open API implementations (start from the official TMF spec)
- Internal O&A service APIs
- AI-assisted or AI-generated APIs

### AI + OpenAPI Workflow

#### Implementing a TM Forum Open API

```
1. Download the official TMF OpenAPI spec from the TM Forum Open API table
   (https://www.tmforum.org/oda/open-apis/table/)

2. Provide the spec to the AI as context

3. Prompt: "Using the attached TMF 641 Service Ordering OpenAPI spec,
            generate a FastAPI server implementation with:
            - All endpoints defined in the spec
            - Pydantic v2 models generated from the spec schemas
            - SQLAlchemy async models for persistence of ServiceOrder
              and ServiceOrderItem
            - A service layer interface (abstract base class)
              with NotImplementedError stubs for business logic
            - Standard TMF error responses using the Error schema
              from the spec"

4. Review generated code:
   - Verify all endpoints from the spec are present
   - Verify camelCase field names in request/response models
   - Verify @type discriminator handling
   - Verify TMF error response schema
   - Run openapi-spec-validator against the spec

5. Write conformance tests before implementing business logic
```

#### Creating a New Internal API

```
1. Write a requirements description:
   "I need an API for O&A's config template management service.
    It should allow CRUD operations on config templates, where each
    template has a name, a YANG module reference, a Jinja2 template
    body, and a set of required parameters with types and defaults.
    Templates have a status: draft, published, deprecated."

2. Prompt AI to draft the OpenAPI spec:
   "Generate an OpenAPI 3.1 spec for the following API requirements.
    Follow TM Forum REST API design guidelines:
    - camelCase field names
    - Standard error response schema
    - Pagination via offset/limit and X-Total-Count header
    - Resource IDs as UUID strings
    - Include examples for all schemas
    Requirements: [paste requirements]"

3. Review spec before ANY implementation:
   - Validate with openapi-spec-validator and spectral
   - Review resource model completeness
   - Confirm alignment with SID data model where applicable
   - Team lead/architect sign-off for external-facing APIs

4. Only after review: AI generates server stubs and client SDK
```

#### Generating Request/Response Validation Middleware

```
Prompt: "Using the attached OpenAPI spec, generate FastAPI middleware
         that validates all incoming requests and outgoing responses
         against the spec schemas. Use openapi-core for validation.
         Return 400 with a structured error response for request
         validation failures, and log (but do not block) response
         validation failures."
```

#### Generating Mock Servers for Testing

```
Prompt: "Generate a Prism-compatible mock server configuration for
         the attached OpenAPI spec. Also generate a Python pytest
         fixture that starts the Prism mock server as a subprocess
         before the test session and tears it down after."
```

### Validation Tooling

```bash
# Install
pip install openapi-spec-validator spectral-cli

# Validate spec
openapi-spec-validator openapi.yaml

# Lint with spectral (TM Forum ruleset if available, or OOTB ruleset)
spectral lint openapi.yaml --ruleset .spectral.yml
```

**`.spectral.yml` for TMF-aligned linting:**
```yaml
extends: ["spectral:oas"]
rules:
  operation-tags: error          # All operations must be tagged
  operation-summary: error       # All operations must have summaries
  oas3-unused-component: warn    # Warn on unused schema components
  info-contact: warn             # API should have contact info
```

---

## AsyncAPI Specs — Spec-First for Event-Driven Interfaces

### When to Use AsyncAPI

Every event-driven interface in O&A services must have an AsyncAPI 2.x (or 3.x) specification. This applies to all Kafka topics, NATS subjects, AMQP exchanges, and any other message-bus interface that an O&A component publishes to or subscribes from.

This is not optional for ODA-conformant components. ODA explicitly requires that event interfaces be documented with AsyncAPI schemas. An ODA component whose events are not documented with AsyncAPI will not pass ODA conformance review.

### AI + AsyncAPI Workflow

The workflow mirrors OpenAPI exactly — spec before implementation:

```
1. Define the event interface requirements:
   "The alarm triage service publishes a TriageResult event to
    Kafka topic 'noa.assurance.triage.results' when it completes
    analysis of an alarm cluster. The event contains: the original
    alarm IDs, the inferred root cause (free text), a confidence
    score (0.0-1.0), recommended remediation steps (list of strings),
    and severity classification (critical/major/minor/warning)."

2. Prompt AI to draft the AsyncAPI spec:
   "Generate an AsyncAPI 2.6 spec for the following event interface.
    Use CloudEvents envelope format (JSON, spec version 1.0.1).
    Include schema definitions with JSON Schema.
    Requirements: [paste requirements]"

3. Review the spec:
   - Validate the event schema completeness
   - Confirm CloudEvents envelope fields (type, source, subject, datacontenttype)
   - Confirm Kafka channel binding config (topic name, partitioning key)
   - Team review

4. AI generates publisher stub and subscriber stub from the spec:
   "Using the attached AsyncAPI spec, generate:
    - A Python async Kafka publisher class using aiokafka,
      serialising TriageResult events as CloudEvents JSON
    - A Python async Kafka consumer class with offset management
      and at-least-once delivery semantics
    - Pydantic v2 models for the event payload schema"
```

### Relevance to ODA Components

ODA components must document all their event interfaces in AsyncAPI. When building or refactoring an ODA component in O&A:

- Every Kafka topic the component publishes to → AsyncAPI channel spec
- Every Kafka topic the component subscribes to → AsyncAPI channel spec
- Event schemas → JSON Schema (embedded or referenced)
- Include channel bindings for Kafka (topic name, consumer group conventions)

The AsyncAPI spec lives in the component repository alongside the OpenAPI spec, and both are validated in CI.

---

## The Anti-Pattern to Avoid

### Code-First with AI

The most dangerous pattern in AI-assisted development is:

1. Ask AI to build a REST API
2. It generates working endpoints
3. You ask AI to "document this API" → it generates an OpenAPI spec from the code
4. The spec is used going forward as if it were authoritative

**Why this fails:**

- The generated spec reflects what the AI built in isolation, not what the requirements demanded
- Field names may not match TM Forum standards (AI defaulted to snake_case)
- Mandatory vs. optional field distinctions may be wrong
- The TMF Open API that should have been used as the base was never consulted
- Contract tests written against this spec test a non-conformant implementation
- When the vendor or partner system that speaks TMF standards tries to integrate, it fails

The spec extracted from code is a description of the code, not a contract. It can only validate that the code is consistent with itself — not that it is correct.

### The PR Checklist Item

Add this to your team's PR template:

```markdown
## API/Interface Changes
- [ ] Does this PR introduce a new REST endpoint?
      If yes: Was the OpenAPI spec written and reviewed BEFORE implementation? [Y/N]
              Does the endpoint implement a TM Forum Open API? [Y/N/N/A — document if N]
- [ ] Does this PR introduce a new event interface?
      If yes: Was the AsyncAPI spec written and reviewed BEFORE implementation? [Y/N]
- [ ] Does this PR modify a YANG module?
      If yes: Does `pyang --strict` pass on the updated module? [Y/N]
              Is the tree diff included in this PR description? [Y/N]
```

---

## Summary: The Three Spec Languages

| Spec Language | Used For | Tooling | AI Role |
|---|---|---|---|
| **YANG** | Network device config & state interfaces (NETCONF/RESTCONF) | pyang, yanglint, yangre | Draft modules, explain existing models, generate data classes, generate test fixtures |
| **OpenAPI 3.x** | REST API contracts (services, ODA component APIs) | openapi-spec-validator, spectral, Prism | Draft specs from requirements, generate server stubs, generate clients, generate conformance tests |
| **AsyncAPI 2.x/3.x** | Event-driven interfaces (Kafka, NATS, AMQP) | asyncapi CLI, AsyncAPI Studio | Draft schemas from requirements, generate publisher/subscriber stubs, generate Pydantic event models |

All three follow the same workflow: **spec → validate → generate → test → implement → CI gate**. AI accelerates every step except the validation and review, which remain human responsibilities.
