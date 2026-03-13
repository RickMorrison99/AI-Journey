# TM Forum Open APIs — Look Before You Generate

> **Audience:** All O&A team members involved in any integration work — service fulfilment, alarm management, resource inventory, performance monitoring, or any system-to-system interface.
> **The rule, stated once:** Before asking an AI assistant to write any integration code, open the [TM Forum Open API table](https://www.tmforum.org/oda/open-apis/table/) and search. Every time.

---

## What TM Forum Open APIs Are

TM Forum publishes and maintains a catalogue of over 700 REST API specifications covering the full telecommunications domain. Each specification is a complete OpenAPI 3.x document — resource models, endpoint definitions, request/response schemas, lifecycle state machines, and mandatory/optional field annotations — developed and ratified by a working group of operators, vendors, and system integrators.

These are not guidelines or suggestions. They are the industry-agreed contracts for how telecom systems exchange information. An operator running a TMF 641 Service Ordering client can integrate with any vendor's TMF 641-conformant order management system. That interoperability is the point, and it has real commercial value.

For O&A, TM Forum Open APIs are the default interface contract for every system-to-system integration. The workflow is simple: if TMF defines an API for the domain you're integrating, you use it. You don't design a new one. You don't ask an AI to design a new one.

---

## The Core Rule

!!! danger "API-First, Every Time"
    **Before asking AI to write any integration code:**

    1. Open the [TM Forum Open API table](https://www.tmforum.org/oda/open-apis/table/)
    2. Search for your domain (resource inventory, alarm management, service ordering, etc.)
    3. If a relevant API exists, download the OpenAPI spec and use it as the AI's input
    4. Only if no relevant API exists should you proceed with AI-designed interfaces — and document the gap

    Skipping this check is the single most expensive mistake in AI-assisted telecom development.

### Why AI Cannot Do This Check for You

AI language models have general knowledge of TM Forum APIs but do not have access to the live API catalogue and will not reliably know whether a specific API exists, what version is current, or what the latest resource model looks like. More critically, AI will not spontaneously tell you "there's a TMF API for this" — it will simply generate what you ask for. The lookup is a human responsibility.

**The failure mode:** An team member asks an AI to write a REST client for fetching network resource inventory. The AI generates a clean, well-structured client with reasonable field names. Six months later, an integration with a vendor system fails because the vendor speaks TMF 639 and the bespoke API speaks something entirely different. The fix requires a complete rewrite of the client, the schema, and all downstream consumers.

**The cost:** That six months of work plus the rewrite, for a problem that a two-minute lookup would have prevented.

---

## Top Open APIs Relevant to O&A

### TMF 639 — Resource Inventory Management

**What it governs:** The lifecycle management of physical and logical resources — network elements, ports, links, VNFs, cloud compute, IP addresses. Everything in the network inventory that O&A's automation tooling reads from and writes to.

**Key resources:**
- `Resource` — the core entity representing any physical or logical network resource
- `ResourceSpecification` — the template/type definition for a resource
- `LogicalResource` / `PhysicalResource` — subtypes covering VNFs/VMs and physical hardware

**Key endpoints:**
```
GET    /resourceInventoryManagement/v4/resource          List resources (with rich filtering)
POST   /resourceInventoryManagement/v4/resource          Create a resource record
GET    /resourceInventoryManagement/v4/resource/{id}     Get a specific resource
PATCH  /resourceInventoryManagement/v4/resource/{id}     Update resource attributes or state
DELETE /resourceInventoryManagement/v4/resource/{id}     Decommission a resource
```

**When it's relevant to O&A:** Any time you need to read or write the network inventory — device onboarding, resource state updates post-provisioning, topology queries, capacity management, decommissioning workflows. TMF 639 is the source-of-truth interface.

**How AI helps:**
- Paste the TMF 639 OpenAPI YAML; ask AI to generate a Python async client with retry and pagination handling
- Ask AI to generate Pydantic models for the `Resource` and `ResourceSpecification` schemas
- Ask AI to write conformance test cases for a TMF 639 server implementation
- Ask AI to explain the `resourceRelationship` nested model (it's non-trivial; AI is good at this)

---

### TMF 641 — Service Ordering Management

**What it governs:** The creation, tracking, and lifecycle management of service orders — the requests to provision, modify, or terminate a telecom service.

**Key resources:**
- `ServiceOrder` — the top-level order entity with line items
- `ServiceOrderItem` — individual order lines, each referencing a service specification and action (add/modify/delete)
- `OrderItemRelationship` — dependency ordering between line items

**Key endpoints:**
```
POST   /serviceOrderingManagement/v4/serviceOrder         Submit a new order
GET    /serviceOrderingManagement/v4/serviceOrder/{id}    Retrieve order and current state
PATCH  /serviceOrderingManagement/v4/serviceOrder/{id}    Update order (e.g., cancel)
GET    /serviceOrderingManagement/v4/serviceOrder         Query orders by state, date, customer
```

**State machine:** `acknowledged` → `inProgress` → `completed` / `failed` / `partial`

**When it's relevant to O&A:** Whenever O&A's fulfillment automation is triggered by a service order — whether from a BSS system, a self-service portal, or an operator action. TMF 641 is the inbound trigger for most Fulfillment automation (eTOM 1.1.7.1).

**How AI helps:**
- Generate an order ingestion handler that deserialises TMF 641 `ServiceOrder` payloads and validates required fields
- Generate order state machine logic conformant to the TMF 641 lifecycle
- Generate a mock TMF 641 server for integration testing of downstream fulfillment components

---

### TMF 640 — Service Activation & Configuration

**What it governs:** The operational interface for activating, deactivating, and modifying service configurations on network resources. TMF 640 is the bridge between a service order (TMF 641) and the network-level configuration change.

**Key resources:**
- `ServiceConfiguration` — captures the desired configuration state for a service
- `ServiceActivationConfiguration` — the actionable configuration payload sent to the network layer

**Key endpoints:**
```
POST   /serviceActivationConfiguration/v4/serviceActivationConfiguration
GET    /serviceActivationConfiguration/v4/serviceActivationConfiguration/{id}
PATCH  /serviceActivationConfiguration/v4/serviceActivationConfiguration/{id}
```

**When it's relevant to O&A:** The activation layer between order management and device-level provisioning. O&A services that translate service-layer intents into device configs and push them via NETCONF/RESTCONF should expose or consume TMF 640.

**How AI helps:**
- Generate the translation layer between TMF 640 `ServiceConfiguration` and YANG-modelled device config
- Generate the activation state machine with appropriate error handling and rollback triggers
- Explain the relationship between TMF 640 and TMF 641 in the fulfillment chain

---

### TMF 642 — Alarm Management

**What it governs:** The full lifecycle of network alarms — creation, acknowledgement, escalation, clearing, and querying. TMF 642 is the standard interface for consuming alarms from network management systems and feeding them into assurance workflows.

**Key resources:**
- `Alarm` — the core alarm entity with fields for alarm type, severity, probable cause, affected resource, timestamps
- `AlarmStateChange` — lifecycle state transitions (raised, acknowledged, cleared)
- `Comment` — operator annotations on an alarm

**Key endpoints:**
```
GET    /alarmManagement/v4/alarm                  Query alarms (by state, severity, resource)
GET    /alarmManagement/v4/alarm/{id}             Get alarm details
PATCH  /alarmManagement/v4/alarm/{id}             Acknowledge, annotate, or clear
POST   /alarmManagement/v4/alarm                  Raise an alarm (from a monitoring source)
POST   /alarmManagement/v4/alarm/{id}/clearAlarm  Clear workflow
```

**When it's relevant to O&A:** Any AI-assisted incident triage or alarm correlation capability. AI triage services should consume alarms via TMF 642, not via proprietary alarm stream formats. This keeps the triage service portable.

**How AI helps:**
- Generate an async alarm consumer that polls or subscribes to TMF 642 events and feeds an AI triage pipeline
- Generate alarm correlation logic: "group alarms by affected resource within a 5-minute window"
- Generate a TMF 642-conformant alarm producer for a custom network monitoring integration
- Ask AI to explain the `probableCause` enumeration and map it to your network elements' native alarm codes

---

### TMF 628 — Performance Management

**What it governs:** Collection, storage, and retrieval of performance metrics from network resources — throughput, latency, error rates, utilisation, and custom KPIs.

**Key resources:**
- `PerformanceProfile` — defines what metrics to collect, at what granularity, from which resources
- `PerformanceJob` — an active collection task
- `PerformanceMeasurementReport` — the collected metric data

**Key endpoints:**
```
POST   /performanceManagement/v4/performanceJob          Start a collection job
GET    /performanceManagement/v4/performanceJob/{id}     Check job status
GET    /performanceManagement/v4/performanceMeasurement  Query collected metrics
```

**When it's relevant to O&A:** Telemetry collection orchestration, SLA monitoring, AI-driven anomaly detection, capacity planning inputs.

**How AI helps:**
- Generate the PerformanceJob scheduler that creates collection jobs for newly provisioned resources
- Generate a metric ingestion pipeline that normalises TMF 628 measurement reports for time-series storage
- Ask AI to map vendor-specific SNMP MIBs or gNMI paths to TMF 628 metric concepts

---

### TMF 632 — Party Management

**What it governs:** The management of parties (individuals, organisations, and their roles) involved in telecom operations — customers, operators, vendors, partners.

**Key resources:**
- `Individual` / `Organization` — the two party subtypes
- `PartyRole` — a party's role in a specific context (customer, supplier, operator)

**When it's relevant to O&A:** Less common in pure network automation, but relevant for multi-tenant platforms, operator identity in change management workflows, and any API that needs to associate a change with a responsible party.

**How AI helps:**
- Generate the party context enrichment layer that annotates provisioning events with operator identity from TMF 632
- Generate integration between TMF 632 and your team's identity provider (LDAP/OIDC)

---

### TMF 652 — Resource Order Management

**What it governs:** Orders for network resources — similar to TMF 641 (service orders) but at the resource layer. Where TMF 641 handles "provision this service", TMF 652 handles "allocate this port / assign this IP / reserve this VLAN".

**Key resources:**
- `ResourceOrder` — the resource-layer order entity
- `ResourceOrderItem` — individual resource allocation requests within an order

**Key endpoints:**
```
POST   /resourceOrderManagement/v4/resourceOrder
GET    /resourceOrderManagement/v4/resourceOrder/{id}
PATCH  /resourceOrderManagement/v4/resourceOrder/{id}
```

**When it's relevant to O&A:** The resource-layer counterpart to TMF 641. In a fulfillment chain, a service order (TMF 641) decomposes into one or more resource orders (TMF 652), which trigger actual device configuration. This is the handoff point between service orchestration and resource automation.

**How AI helps:**
- Generate the service-to-resource order decomposition logic: "take a TMF 641 service order, decompose into TMF 652 resource orders for each required network resource"
- Generate resource order tracking and state synchronisation with TMF 641 parent orders

---

### TMF 663 — Shopping Cart (Service Catalog Integration)

**What it governs:** A transient "shopping cart" for assembling service configuration selections before committing to an order. While the name sounds BSS-facing, TMF 663 is relevant for O&A platforms that expose self-service portals or programmable service selection interfaces.

**When it's relevant to O&A:** O&A platforms that expose a service catalog-driven provisioning interface — where operators or automated systems select services and configurations before submitting a TMF 641 order. Also relevant for AI-assisted "what services are available for this resource?" workflows.

**How AI helps:**
- Generate the cart-to-order conversion that transforms a TMF 663 cart into a TMF 641 service order
- Generate product catalog query logic to populate cart options from available service specifications

---

## The API Lookup Workflow

Apply this workflow every time you face an integration requirement, without exception.

```
Step 1: Describe the requirement in plain English
        ──────────────────────────────────────────
        "I need to query the network inventory to find all physical
         ports on a given device and their current operational state."

Step 2: Open the TM Forum Open API table
        ──────────────────────────────────────────
        URL: https://www.tmforum.org/oda/open-apis/table/
        Search for: "resource inventory", "resource management"
        Result: TMF 639 — Resource Inventory Management ✓

Step 3a: Relevant API found → proceed with spec
         ──────────────────────────────────────────
         Download the TMF 639 OpenAPI spec (YAML or JSON).
         Provide it to the AI assistant as context.
         Prompt: "Using the attached TMF 639 OpenAPI spec, generate a
                  Python async client for GET /resource with filtering
                  by resourceCharacteristic.name and .value."
         Review the generated code against the spec before committing.

Step 3b: No relevant API found → document the gap
         ──────────────────────────────────────────
         Create a gap analysis document:
           - What integration is needed
           - Which TMF APIs were evaluated and why they don't apply
           - Decision: contribute to TM Forum working group, or build internal API
         Only then: use AI to generate an internal API, following TMF
         REST API design guidelines (camelCase, JSON:API-aligned patterns).

Step 4: Never skip Step 2.
```

---

## AI + TMF APIs: Practical Guide

### Understanding a TMF API Spec with AI

TMF OpenAPI specs are large — TMF 639 runs to hundreds of lines with deeply nested `$ref` chains. AI is excellent at explaining them:

```
Prompt: "I've pasted the TMF 639 Resource Inventory OpenAPI spec below.
         Explain the relationship between Resource, ResourceSpecification,
         and ResourceRelationship. Give a concrete example for a physical
         port on a router."
```

```
Prompt: "In the TMF 642 Alarm schema, what fields are mandatory for
         a minimum-viable alarm creation request? Show me a minimal
         valid JSON payload."
```

### Generating a Client from a TMF OpenAPI Spec

```
Prompt: "Using the TMF 641 Service Ordering OpenAPI spec (attached),
         generate a Python async client class using httpx with:
         - Method: submit_order(order: ServiceOrder) -> ServiceOrder
         - Method: get_order(order_id: str) -> ServiceOrder
         - Method: list_orders(state: str | None, limit: int) -> list[ServiceOrder]
         Use Pydantic v2 models generated from the schema.
         Include retry logic with exponential backoff for 5xx responses."
```

**Always verify:**

- [ ] Field names are camelCase (TMF uses camelCase — AI sometimes switches to snake_case)
- [ ] Required fields from the spec are present and validated
- [ ] Optional fields have appropriate default handling
- [ ] The `@type` discriminator field is handled (TMF uses JSON Schema polymorphism)
- [ ] Pagination follows TMF patterns (`offset`/`limit` query parameters, `X-Total-Count` header)

### Generating a Server Stub from a TMF OpenAPI Spec

```
Prompt: "Using the TMF 639 Resource Inventory OpenAPI spec (attached),
         generate a FastAPI server stub with:
         - All GET/POST/PATCH/DELETE endpoints for /resource
         - Pydantic request/response models
         - Placeholder service layer (raise NotImplementedError)
         - OpenAPI metadata matching the TMF spec title and version
         Include the standard TMF error response model (Error schema)."
```

### Generating Conformance Tests for a TMF API Implementation

```
Prompt: "Generate pytest test cases for a TMF 642 Alarm Management
         server implementation. Cover:
         - POST /alarm: valid alarm creation with all mandatory fields
         - POST /alarm: rejection of alarm with missing 'alarmType' field
         - GET /alarm: filtering by 'state=raised' query parameter
         - PATCH /alarm/{id}: state transition from 'raised' to 'acknowledged'
         - GET /alarm/{id}: 404 response for non-existent alarm ID
         Use httpx.AsyncClient against a real test server instance."
```

### Common AI Mistakes with TMF APIs

| Mistake | Example | Fix |
|---------|---------|-----|
| **snake_case field names** | `alarm_type`, `resource_id`, `order_state` | TMF uses camelCase: `alarmType`, `id`, `state` |
| **Missing `@type` discriminator** | Omits `"@type": "Resource"` on resource objects | TMF uses JSON Schema `discriminator`; always include `@type` |
| **Inventing non-existent endpoints** | Generates `POST /alarm/acknowledge` | TMF uses PATCH with state change in body; check spec |
| **Missing mandatory fields** | Omits `alarmedObjectType` from Alarm creation | Always validate against `required` array in the spec schema |
| **Wrong pagination pattern** | Uses `page`/`pageSize` | TMF uses `offset`/`limit` query params and `X-Total-Count` header |
| **Ignoring TMF error schema** | Returns `{"error": "not found"}` | TMF defines a standard `Error` schema: `{"code": "...", "reason": "...", "message": "..."}` |
| **Missing event notification support** | Omits hub/subscription endpoints | Many TMF APIs include a `hub` resource for event subscriptions; AI often omits this |

---

## TMF API Quick Reference for O&A

| TMF API | Domain | eTOM Process | Primary Use in O&A |
|---------|--------|--------------|-------------------|
| TMF 639 | Resource Inventory | 1.3.6.1 Resource Provisioning | Network resource CRUD, inventory queries |
| TMF 641 | Service Ordering | 1.1.7.1 Service Order Handling | Inbound service order trigger for fulfillment |
| TMF 640 | Service Activation | 1.1.3.1 Service Config & Activation | Service-to-resource config translation |
| TMF 642 | Alarm Management | 1.2.1.1 Trouble Detection | Alarm ingestion, AI triage input |
| TMF 628 | Performance Management | 1.2.3.1 Performance Monitoring | Telemetry collection, KPI, anomaly detection |
| TMF 632 | Party Management | Cross-cutting | Operator identity, multi-tenancy |
| TMF 652 | Resource Ordering | 1.1.6.1 Resource Provisioning | Service-to-resource order decomposition |
| TMF 663 | Shopping Cart | 1.1.7.1 | Self-service portals, catalog integration |
