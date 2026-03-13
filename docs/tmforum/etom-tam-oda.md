# eTOM, TAM & ODA — The O&A Reference Architecture

> **Audience:** All O&A team members. Mandatory reading before proposing or accepting AI-generated architectural changes.
> **Purpose:** Establish the three TM Forum structural frameworks as the lens through which all O&A design decisions — AI-assisted or otherwise — must be viewed.

---

## eTOM — Business Process Framework

### What It Is

The **enhanced Telecom Operations Map** (eTOM, TM Forum GB921) is the telecommunications industry's standard business process reference framework. It provides a hierarchical taxonomy of every process a telco must run — from board-level strategic planning down to the atomic operational steps that configure a port or raise a trouble ticket. eTOM is vendor-neutral, carrier-neutral, and has been refined by hundreds of operators and vendors over two decades.

eTOM organises processes into three top-level horizontal layers:

- **Strategy, Infrastructure & Product (SIP):** Long-horizon processes — product lifecycle, strategic planning, infrastructure investment.
- **Operations:** The day-to-day processes that deliver and assure services to customers. This is where O&A lives.
- **Enterprise Management:** Corporate support functions — HR, finance, legal.

Within Operations, the four process domains most relevant to O&A are:

```
Operations
├── Fulfillment          (1.1.x)   ← Service & resource provisioning
├── Assurance            (1.2.x)   ← Fault management, performance, SLA
├── Billing & Revenue    (1.4.x)   ← Mostly out of O&A scope
└── Resource Management & Operations (1.3.x)  ← Core of O&A work
```

### Relevant Process Domains for O&A

#### Fulfillment (1.1.x) — Where Most Network Automation Lives
Fulfillment covers everything required to provision a service for a customer: order capture, feasibility check, design, resource assignment, activation, and confirmation. For O&A, the most active Fulfillment sub-processes are:

| eTOM ID | Process | O&A Relevance |
|---------|---------|--------------|
| 1.1.3.1 | Service Configuration & Activation | Automated service turn-up via NETCONF/RESTCONF |
| 1.1.6.1 | Resource Provisioning & Allocation | Config push to network devices, IP address management |
| 1.1.7.1 | Service Order Handling | Integration with TMF 641 Service Ordering API |

#### Assurance (1.2.x) — Fault Management, Performance Monitoring
Assurance covers the processes that keep services running: fault detection, alarm correlation, trouble ticketing, performance data collection, and SLA monitoring. AI-assisted incident triage and anomaly detection live here.

| eTOM ID | Process | O&A Relevance |
|---------|---------|--------------|
| 1.2.1.1 | Trouble Detection & Diagnosis | AI-assisted root cause analysis of alarms |
| 1.2.2.1 | Trouble Handling | AI-suggested remediation; automated escalation workflows |
| 1.2.3.1 | Performance Monitoring | Threshold violation detection; AI-driven capacity forecasting |

#### Resource Management & Operations (1.3.x) — The Core of O&A
Resource Management & Operations governs the lifecycle of the physical and logical resources (network nodes, links, VNFs, cloud infrastructure) that underpin all services. This is where the majority of O&A's automation tooling lives.

| eTOM ID | Process | O&A Relevance |
|---------|---------|--------------|
| 1.3.6.1 | Resource Provisioning | Template-driven config generation, zero-touch provisioning |
| 1.3.4.1 | Resource Configuration Management | YANG-modelled config state; drift detection |
| 1.3.2.1 | Resource Performance Management | Telemetry collection; KPI computation |
| 1.3.1.1 | Resource Inventory Management | Source-of-truth integration (TMF 639) |

### How to Use eTOM with AI

**Rule: Map the AI use case to its eTOM process before writing a line of code.**

This is not bureaucracy. It is problem scoping. If you can't identify the eTOM process a feature automates, you are either solving the wrong problem or building in the wrong domain. Mapping forces you to answer:

- Whose process is this? (Which team owns it?)
- What triggers it? (An order? An alarm? A scheduled job?)
- What is its output? (A configured device? A closed ticket? An updated inventory record?)
- Which TMF Open API is its external interface?

The mapping also creates a natural review checkpoint: show the eTOM process to a domain expert before AI generates the implementation.

### Concrete Examples

#### Example 1: AI-Assisted Configuration Push
**eTOM Process:** Fulfillment → Resource Provisioning & Allocation (1.1.6.1)
**Trigger:** A service order (TMF 641) arrives; resource allocation is completed.
**AI Role:** Generate the device-specific NETCONF RPC payload from a validated YANG template and the allocated resource parameters.
**Code comment convention:**
```python
# eTOM: 1.1.6.1 Resource Provisioning & Allocation
# TMF API: TMF641 Service Ordering → TMF652 Resource Order Management
# ODA Component: Resource Management & Orchestration
def push_interface_config(resource_id: str, config_params: InterfaceConfig) -> ProvisioningResult:
    ...
```

#### Example 2: AI-Assisted Incident Triage
**eTOM Process:** Assurance → Trouble Detection & Diagnosis (1.2.1.1) → Trouble Handling (1.2.2.1)
**Trigger:** Alarm stream from network elements via TMF 642 Alarm Management API.
**AI Role:** Correlate alarms, identify root cause candidates, suggest remediation steps from runbook index.
**Code comment convention:**
```python
# eTOM: 1.2.1.1 Trouble Detection & Diagnosis → 1.2.2.1 Trouble Handling
# TMF API: TMF642 Alarm Management
# ODA Component: Assurance
def triage_alarm_cluster(alarms: list[Alarm]) -> TriageResult:
    ...
```

#### Example 3: AI-Generated Runbooks
**eTOM Process:** Resource Management & Operations → Resource Configuration Management (1.3.4.1)
**Trigger:** Engineering request or post-incident review.
**AI Role:** Generate runbook draft from YANG model and historical remediation logs; human review mandatory before publish.

### eTOM Process ID in Code Comments

Embedding eTOM process IDs in code comments creates searchable traceability between implementation and the business process it realises. Use this format consistently:

```
# eTOM: <process-id> <process-name>
```

Examples:
```python
# eTOM: 1.1.6.1 Resource Provisioning & Allocation
# eTOM: 1.2.1.1 Trouble Detection & Diagnosis
# eTOM: 1.3.6.1 Resource Provisioning
```

This convention enables impact analysis ("which code changes affect Assurance processes?"), onboarding clarity, and audit trails for automated operations.

---

## TAM — TM Forum Application Framework

### What It Is

The **TM Forum Application Framework** (TAM, GB929) is a map of the *application capabilities* that make up a telco's IT landscape. Where eTOM describes *what processes* are run, TAM describes *what software does the running*. TAM organises application capabilities into a matrix of functional areas — Operations Support Systems (OSS), Business Support Systems (BSS), and supporting domains — and defines the capability boundaries between them.

TAM is the inventory of application capability the telco already has (or should have). Every capability on the TAM map corresponds to a category of software: inventory management, order management, fault management, configuration management, performance management, and so on.

### How O&A Uses TAM

The primary O&A use of TAM is **duplication prevention** — specifically, preventing AI from generating new components that replicate capability already present in the team's existing application estate.

Before accepting an AI-generated architectural suggestion that introduces a new service, module, or data store, the team lead or architect must answer: **Is this capability already on our TAM map?**

Common TAM-relevant capability areas for O&A:

| TAM Area | Typical Existing Application | AI Risk |
|----------|------------------------------|---------|
| Resource Inventory | Network inventory system (e.g., NetCracker, Cisco NSO inventory) | AI generates a shadow inventory store |
| Configuration Management | Network configuration tool (e.g., Cisco NSO, Anuta NCX) | AI creates a parallel config database |
| Fault Management | Alarm correlation platform (e.g., Moogsoft, Netcool) | AI generates a separate alarm store |
| Service Order Management | OSS order management system | AI adds order state machine outside the OSS |
| Performance Management | Telemetry platform (e.g., InfluxDB + Grafana, Kafka) | AI builds a duplicate metrics pipeline |

### The Anti-Pattern: AI-Generated Capability Duplication

**Scenario:** An team member asks an AI assistant to "build a configuration management module to track device config state". The AI generates a well-structured service with a PostgreSQL schema, REST API, and sync logic. It is clean, functional, and completely duplicates the configuration management capability already mapped in TAM and implemented in the team's existing OSS.

**Why it happens:** AI has no awareness of your TAM map or existing application landscape. It solves the stated problem in isolation.

**Consequence:** Two sources of truth for config state. Integration debt between the AI-generated service and the existing system. Eventual inconsistency. Costly consolidation.

**Prevention:** TAM alignment review as part of any AI-assisted architecture session.

### TAM Alignment Review Checklist

Before accepting an AI-generated component or service proposal:

- [ ] Identify the TAM capability area the new component addresses
- [ ] Check whether an existing application already covers this capability in the O&A estate
- [ ] If yes: determine whether the AI should be extending the existing application, not creating a new one
- [ ] If no gap exists: reject the AI-generated proposal; redirect to extending existing capability
- [ ] If a genuine gap exists: document it, confirm it's in O&A's scope, then proceed with AI assistance

### Integrating TAM into Architecture Reviews

Add TAM mapping as a standard field in architecture decision records (ADRs):

```markdown
## TAM Mapping
- **TAM Capability Area:** Resource Inventory Management
- **Existing Application:** [System name]
- **Gap Addressed:** Real-time config diff tracking (not present in existing system)
- **Justification for new component:** [Explanation]
```

---

## ODA — Open Digital Architecture

### What It Is

The **Open Digital Architecture** (ODA) is TM Forum's target operating model for modern, cloud-native telecoms. Published as a suite of specifications (IG1171, IG1179 and related), ODA defines the structural rules for how telecom software components must be built, deployed, and interconnected. It is not a theoretical framework — TM Forum members, including major network operators and vendors, are actively certifying ODA-conformant components and building ODA Canvases for production deployment.

ODA's foundational premise is that traditional monolithic OSS/BSS stacks must be decomposed into a set of loosely coupled, standards-conformant, independently deployable **ODA Components**. Each component:

- Is **autonomous**: owns its data and its business logic.
- Is **API-exposed**: all external interfaces are TM Forum Open APIs (REST for synchronous operations, AsyncAPI for events).
- Is **event-driven**: publishes and subscribes to domain events rather than relying on synchronous coupling.
- Is **cloud-native**: designed for containerised deployment, horizontal scaling, and lifecycle management by an ODA Canvas.

### ODA Components: The Unit of Architecture

An ODA Component is the atomic building block of an ODA-conformant system. Components are categorised into functional domains:

| ODA Component Domain | Examples |
|----------------------|---------|
| **Resource Management & Orchestration** | Resource inventory, network configuration management, topology |
| **Assurance** | Alarm management, performance management, SLA assurance |
| **Intelligent Automation** | Policy engine, AI/ML inference, automation workflow |
| **Customer Management** | Party management, customer order, billing |
| **Core Commerce** | Product catalogue, offer management, pricing |

For O&A, the most relevant ODA component domains are:

- **Resource Management & Orchestration** — encompasses the bulk of O&A's automation tooling: resource provisioning, config management, topology management.
- **Assurance** — alarm correlation, performance monitoring, AI-assisted incident triage.
- **Intelligent Automation** — the home for AI-driven policy engines, ML inference services, and orchestration workflows.

### How AI Fits Within ODA

AI-assisted capabilities in O&A must be delivered as ODA-conformant components. This means:

1. **Exposed via Open APIs:** An AI inference service that recommends remediation actions must expose its interface as a TM Forum Open API (or, where no TMF API exists, a documented API conforming to TMF REST API design guidelines).
2. **Event-driven with AsyncAPI:** An AI component that reacts to alarm events must document its event interfaces using AsyncAPI schemas, conforming to TM Forum event patterns.
3. **Autonomous data ownership:** An AI model serving resource configuration recommendations owns the recommendation data. It does not reach directly into the inventory system's database.
4. **Canvas lifecycle management:** AI components are managed by the ODA Canvas (Kubernetes operators, ONAP, or equivalent) — they are not bespoke deployments managed by hand.

### ODA Canvas: Positioning AI Capabilities

The ODA Canvas is the runtime environment that manages component lifecycle, enforces API contracts, and routes events between components. When positioning a new AI capability, ask: **which Canvas slot does this fill?**

```
ODA Canvas — O&A AI Capability Positioning
───────────────────────────────────────────────────────────────────────
│  Resource Management       │  Assurance              │  Intelligent  │
│  & Orchestration           │                         │  Automation   │
│                            │                         │               │
│  ┌─────────────────────┐   │  ┌──────────────────┐  │  ┌──────────┐ │
│  │ Resource Inventory  │   │  │ Alarm Management │  │  │ AI Policy│ │
│  │ (TMF 639)           │   │  │ (TMF 642)        │  │  │ Engine   │ │
│  └─────────────────────┘   │  └──────────────────┘  │  └──────────┘ │
│  ┌─────────────────────┐   │  ┌──────────────────┐  │  ┌──────────┐ │
│  │ Config Management   │   │  │ AI Triage        │  │  │ ML Model │ │
│  │ (TMF 640)           │◄──┼──┤ Service          │  │  │ Serving  │ │
│  └─────────────────────┘   │  └──────────────────┘  │  └──────────┘ │
───────────────────────────────────────────────────────────────────────
```

**AI-assisted config generation** belongs in the Resource Management & Orchestration domain, as a sub-capability of the Config Management component (exposed via TMF 640).

**AI incident triage** belongs in the Assurance domain, consuming TMF 642 alarm events and publishing triage results back via event.

**ML model serving and policy engines** belong in Intelligent Automation — a domain specifically designed to host AI/ML capabilities that other components invoke.

### How AI Accelerates ODA Adoption

ODA adoption is accelerated, not blocked, by AI assistance — provided the team maintains ODA conformance as a non-negotiable constraint.

| ODA Task | AI Assistance |
|----------|--------------|
| Generate ODA-conformant component boilerplate | AI generates component scaffolding with correct API exposure patterns, event contracts, and health check endpoints |
| Draft OpenAPI spec for a new ODA component | AI drafts the spec from requirements; team member validates TMF alignment before implementation |
| Generate AsyncAPI event schemas | AI generates event schemas from the component's domain model; team member validates against TMF event patterns |
| Write ODA component conformance tests | AI generates test cases from the component specification and API contract |
| Map component to ODA Canvas domain | AI assists with Canvas positioning analysis given a description of the component's responsibility |

### ODA Resources

- [ODA Component Specifications](https://www.tmforum.org/oda/open-digital-architecture/) — TM Forum member portal
- [ODA Canvas Reference Implementation](https://github.com/tmforum-oda/oda-canvas) — open-source reference on GitHub
- [TMF Open API Table](https://www.tmforum.org/oda/open-apis/table/) — the canonical API catalogue

---

## Summary: Using All Three Together

The three frameworks are complementary, not alternatives. Use them in sequence when scoping any new O&A capability:

```
1. eTOM  → What process does this capability automate? (Scope & ownership)
      ↓
2. TAM   → Does this capability already exist in our application estate? (Duplication check)
      ↓
3. ODA   → How must this capability be structured and exposed? (Architecture conformance)
      ↓
4. Open APIs → Which TM Forum API governs the interface? (Contract selection)
```

This four-step sequence, applied before AI generates implementation code, is the difference between standards-conformant automation and a growing pile of bespoke, unmaintainable scripts.
