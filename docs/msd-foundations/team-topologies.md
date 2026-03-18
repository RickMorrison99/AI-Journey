# Team Topologies for O&A AI Adoption

*Based on Matthew Skelton & Manuel Pais, **Team Topologies** (2019)*

!!! quote "Matthew Skelton & Manuel Pais, *Team Topologies*"
    "The goal is not to optimise teams for delivering features but to optimise them for a
    sustainable flow of change — and that requires explicitly managing cognitive load."

---

## 1. Why Team Structure Shapes AI Adoption

### Conway's Law as a Design Tool

Conway's Law — *"Any organisation that designs a system will produce a design whose structure is
a copy of the organisation's communication structure"* — is typically cited as a warning. Skelton
and Pais reframe it as a design tool: **deliberately shape team structures to produce the
architecture you want**.

For O&A, this has immediate implications for AI adoption. If AI tooling is owned by a single
enthusiastic champion with no platform abstraction around it, the communication structure looks
like a hub-and-spoke: every team routes AI questions through that person. The resulting
"architecture" mirrors that structure: every team reimplements prompt engineering from scratch,
no shared patterns emerge, the champion burns out, and when they leave, organisational knowledge
leaves with them.

The inverse is equally true. If the team deliberately creates a **platform team** responsible for
AI infrastructure — Ollama deployment, shared prompt libraries, CI/CD AI gates, MCP server — and
positions that team to serve stream-aligned delivery teams via well-defined interfaces, then the
communication structure produces a modular AI capability: composable, replaceable, and maintainable.

### The O&A AI Adoption Risk Without Deliberate Structure

Without deliberate team topology design, O&A AI adoption tends to produce:

| Dysfunction | Cause | Effect |
|---|---|---|
| Prompt library fragmentation | Each engineer maintains their own prompts | No shared learning; effort duplicated |
| AI capability bottleneck | One champion owns all AI knowledge | Single point of failure; blocks scaling |
| Inconsistent AI governance | Each squad invents its own approval process | Compliance gaps; audit risk |
| Tool sprawl | No platform team to standardise | High extraneous cognitive load |
| Parallel reinvention | No enabling team to share patterns | Wasted experimentation across squads |

Skelton and Pais would diagnose this as **unmanaged cognitive load** — specifically extraneous
load imposed by poor organisational structure rather than the inherent complexity of the work.

---

## 2. The Four Team Types — O&A Context

### Stream-Aligned Team

The primary delivery team. Owns a specific automation domain end-to-end: development, deployment,
operation, and AI augmentation within that domain.

**O&A Example:** The IP Topology Automation squad owns the full lifecycle of IP topology
discovery and visualisation — the ncclient collectors, the YANG models, the NSO service
templates, and the AI-assisted anomaly detection that runs against topology snapshots. They
consume AI tools as a capability but own their own prompts, their own AI-generated test suites,
and their own AI-assisted runbook generation.

**What stream-aligned teams should own in AI context:**
- Domain-specific prompt tuning and prompt libraries for their bounded domain
- AI-assisted test generation for their own services
- The decision of whether to use AI for a given task within their domain
- AI-generated documentation for their own YANG models and runbooks

**What they should NOT own:**
- The Ollama infrastructure or LLM deployment
- Enterprise-wide AI governance process design
- Cross-cutting AI security and data classification tooling

The goal for stream-aligned teams is **fast flow** — the ability to sense, respond, and deliver
value continuously. AI adoption succeeds when it increases the team's flow velocity; it fails
when it adds coordination overhead or tool maintenance burden.

---

### Platform Team

Builds and maintains the shared AI infrastructure that stream-aligned teams consume. The platform
team's primary output is not features — it is **reduced cognitive load** for stream-aligned teams.

**O&A Example:** The AI Platform squad (initially may be 1–2 people from the enabling team
transitioning into a permanent role) owns:

- **Ollama deployment and lifecycle management** — model updates, hardware allocation, access
  control, monitoring
- **Shared prompt library** — curated, version-controlled collection of proven O&A prompts for
  YANG authoring, NETCONF test generation, incident summarisation, etc.
- **CI/CD AI gates** — the automated pipeline steps that run AI-assisted review (e.g., YANG
  linting with AI, test coverage suggestions) as reusable pipeline components
- **MCP server** — the Model Context Protocol server that provides O&A-specific tools to
  Copilot/Claude clients (network topology context, NSO device inventory, YANG schema lookup)
- **AI usage telemetry** — aggregated, anonymised adoption metrics shared back to the team

**Platform team success metric:** Stream-aligned teams can use AI capabilities without needing
to understand how they are deployed, maintained, or secured. If a stream-aligned team is
spending time troubleshooting Ollama connectivity, the platform team has failed.

**The Thinnest Viable Platform principle:** Do not over-engineer the platform. Start with a
simple, well-documented shared Ollama instance and a Git-hosted prompt library. Add complexity
only when stream-aligned teams express a specific unmet need.

---

### Enabling Team

A temporary team of coaches and champions whose purpose is to help stream-aligned teams adopt
new practices. The enabling team's goal is to **make themselves unnecessary** — they succeed by
transferring capability, not by becoming a permanent intermediary.

**O&A Example:** The AI Champions cohort (one per squad, as defined in
[team norms](../governance/team-norms.md)) functions as a lightweight enabling team. During
Stages 1–2 of the adoption roadmap, they collaborate closely with each stream-aligned squad to:

- Run AI experiment design workshops
- Share results across squads (via the shared retrospective format)
- Introduce the prompt library and CI gate patterns to teams encountering them for the first time
- Coach on responsible AI practices without gatekeeping

At Stage 3, the enabling team begins stepping back. By Stage 4, individual squads should be
self-sufficient; the champion role becomes a lighter-touch coordination and sharing function
rather than active coaching.

**What distinguishes enabling from platform:** The enabling team transfers knowledge; the
platform team transfers capability as a service. An enabling team should never become a
dependency. If squads cannot function without the enabling team's involvement, the enabling
team has failed.

---

### Complicated-Subsystem Team

A small specialist group owning a high-complexity AI component whose internal workings require
deep specialist knowledge that stream-aligned teams should not need to acquire.

**O&A Example — YANG-to-Code Generation Pipeline:** A two-person specialist team owns a custom
pipeline that takes YANG models as input and generates typed Python data classes, NSO service
package skeletons, and pytest fixture stubs as output. The pipeline uses a fine-tuned code
generation model and a YANG parser. Stream-aligned teams invoke it via a CLI tool or CI pipeline
step — they do not need to understand the fine-tuning process, the YANG AST traversal, or the
template engine.

**O&A Example — NSO Service Template Fine-Tuned Model:** A specialist maintains a fine-tuned
variant of a code generation model trained on the organisation's internal NSO service package
corpus. Stream-aligned teams consume outputs via the platform team's prompt library. The
complicated-subsystem team handles model updates, evaluation, and regression testing.

**Key principle:** Stream-aligned teams consume the *output* of complicated-subsystem teams, not
their *expertise*. If a stream-aligned engineer needs to understand the fine-tuning process to
use the tool, the interface is too leaky.

---

## 3. The Three Interaction Modes

### Collaboration

Two teams work closely together, sharing a high-bandwidth communication channel, during a
bounded period of discovery or exploration.

**When to use in O&A:** During Stages 1–2, when stream-aligned squads and the enabling team are
actively exploring what AI can and cannot do for O&A-specific tasks. Collaboration is expensive
(high cognitive load for both teams) and should be time-limited. A collaboration mode engagement
might last one sprint to two quarters.

**Signs collaboration mode has gone on too long:** The enabling team is doing the work rather
than coaching it. Stream-aligned teams wait for the enabling team before starting AI-related
tasks.

---

### X-as-a-Service

The platform team delivers a well-defined, stable capability that stream-aligned teams consume
without needing to understand the internals.

**When to use in O&A:** From Stage 3 onwards, once the AI platform is stable enough to be
offered as a service. The Ollama API, the shared prompt library, the MCP server, and the CI
AI gates are all candidates for X-as-a-Service delivery.

**What makes it work:** Clear documentation, stable interfaces, SLOs (uptime, latency), and a
low-friction onboarding path. The platform team maintains a service catalogue entry for each
capability with examples, known limitations, and a support channel.

---

### Facilitating

An enabling team coaches a stream-aligned team without doing the work for them. Knowledge
transfer is the goal; the enabling team does not make decisions for the stream-aligned team.

**When to use in O&A:** When introducing a new AI practice (e.g., characterisation testing with
AI assistance) that the stream-aligned team has not encountered before. The enabling team runs
a workshop, provides reference examples, reviews the team's first attempt, and then steps back.

---

### Interaction Mode × Adoption Stage Mapping

| O&A Adoption Stage | Recommended Primary Interaction Mode | Notes |
|---|---|---|
| **Stage 1: Aware** | Collaboration | Champions and squads explore together; all learning is shared |
| **Stage 2: Experimenting** | Collaboration → Facilitating | Enabling team coaches experiments; squads own their own results |
| **Stage 3: Practicing** | Facilitating + X-as-a-Service (emerging) | Platform begins stabilising; enabling team steps back domain by domain |
| **Stage 4: Scaling** | X-as-a-Service | Platform is the primary channel; enabling team is lightweight coordination only |
| **Stage 5: Optimising** | X-as-a-Service | Platform optimises cost and capability; stream-aligned teams self-sufficient |

---

## 4. Cognitive Load as the Primary Constraint

Skelton and Pais draw directly on John Sweller's cognitive load theory as the theoretical
foundation for team design. Understanding the three types of cognitive load is essential for
making good O&A team topology decisions.

### Three Types of Cognitive Load

**Intrinsic load** — the inherent complexity of the task domain. For O&A engineers, intrinsic
load is already high: YANG data modelling, NETCONF/RESTCONF protocol semantics, NSO service
package architecture, Ansible idempotency constraints, network protocol behaviour under failure
conditions. This load cannot be eliminated — it is the job. Good team design acknowledges it
and scopes team ownership accordingly.

**Extraneous load** — the friction imposed by poor tooling, unclear processes, cognitive
overhead that does not build lasting capability. For O&A AI adoption, extraneous load sources
include: prompt engineering overhead with no shared library, inconsistent AI tool interfaces
across squads, time spent troubleshooting Ollama connectivity, unclear AI governance processes,
switching context between five different AI tools with no integration.

**Germane load** — the cognitive effort that builds genuine, lasting capability. For O&A, this
means: learning AI-assisted YANG design patterns that the engineer will reuse across projects;
understanding how to write effective characterisation tests for legacy code; building intuition
for where AI code generation is reliable and where it requires extra scrutiny.

### The O&A AI Adoption Risk

The core risk of unstructured AI adoption is this: **AI tools add extraneous cognitive load
before they reduce intrinsic load.**

In the early stages of adoption (Stages 1–2), engineers are simultaneously:
- Learning which AI tools are available and how they differ
- Learning how to write effective prompts for O&A-specific tasks
- Learning how to verify AI outputs quickly without re-reading every line
- Dealing with inconsistent AI quality across different task types
- Navigating governance uncertainty about what is and is not permitted

All of this is extraneous load. None of it is the job. The germane load — genuine skill-building
in AI-augmented engineering — only starts accumulating once the extraneous friction is reduced.

**The platform team's primary purpose is to absorb extraneous load.** A well-functioning
platform team means stream-aligned engineers do not need to understand Ollama deployment,
model selection rationale, or prompt library curation. They consume a stable service and focus
their cognitive capacity on their actual domain.

### Cognitive Load Budget per Team

Skelton and Pais suggest teams should be structured so that no team's total cognitive load
exceeds what a healthy team can sustainably manage. For O&A squads:

| Load Component | Level | Comment |
|---|---|---|
| Core domain knowledge (YANG, NETCONF, NSO) | High (intrinsic) | Cannot be reduced; scope domain ownership accordingly |
| AI tool operation (prompting, verification) | Medium (germane, improving) | Reduces as shared patterns mature |
| AI infrastructure management | Should be near-zero | Platform team absorbs this |
| AI governance and compliance | Low (extraneous, manageable) | Clear documented process eliminates uncertainty |
| Cross-squad coordination overhead | Should be low | Stream-aligned ownership minimises this |

If a squad's cognitive load budget is already near capacity with their domain work, adding AI
tool operation overhead without platform support will cause flow to slow, quality to drop, or
engineers to disengage from AI adoption entirely.

---

## 5. Team API

Skelton and Pais introduce the **Team API** concept: every team should publish an explicit
description of how to interact with them, what they offer, and what not to ask them. This
reduces the coordination overhead between teams and makes interaction patterns explicit rather
than assumed.

### O&A AI Platform Team — Template Team API

```
Team: AI Platform
As-of: [date]
Interaction mode: X-as-a-Service (primary), Facilitating (by arrangement)

--- WHAT WE OFFER ---

Services:
  - Ollama API endpoint (internal)
      URL: http://ollama.oa-internal/api
      Models available: [see service catalogue]
      SLO: 99% uptime during business hours; best-effort out-of-hours
      Rate limits: 100 req/min per squad token

  - Shared O&A Prompt Library
      Location: /docs/prompt-library/ in this repo
      Contents: curated, tested prompts for YANG authoring, NETCONF test gen,
                incident summarisation, ADR drafting, legacy characterisation
      Update process: PR to main; platform team reviews within 2 working days

  - CI/CD AI Gates (reusable pipeline components)
      Location: .github/workflows/components/
      Available gates: yang-ai-lint, test-coverage-suggest, ai-pr-summary
      Docs: /docs/tools/custom-pipelines.md

  - MCP Server (O&A tools for Copilot/Claude clients)
      Provides: network topology context, NSO device inventory, YANG schema lookup
      Access: configure in your .vscode/mcp.json (see onboarding guide)

--- HOW TO INTERACT WITH US ---

Primary channel: X-as-a-Service via internal docs + #ai-platform Slack channel
Office hours for collaboration: Tuesday and Thursday 14:00–15:00
Onboarding: use the self-service guide at /docs/tools/github-copilot.md
Incidents / outages: raise in #ai-platform; SLA is next-business-day acknowledgement

--- WHAT NOT TO ROUTE TO US ---

Do NOT ask us to:
  - Tune prompts for your specific domain (own your domain-specific prompt library)
  - Choose which AI tools to use for your squad's workflow (your autonomy, your decision)
  - Do your AI-assisted development work for you (we coach; we don't do)
  - Review every AI-generated PR (that is your team's code review process)
  - Approve exceptions to responsible AI policy (that is the governance process, not us)
```

The Team API should be reviewed quarterly and updated as the platform evolves. Publishing it in
the docs site (not just in Slack or Confluence) makes it discoverable without asking.

---

## 6. Signals That Team Structure Is Blocking AI Adoption

The following warning signs indicate that team topology is impeding AI adoption — and the
recommended structural response for each:

| Warning Sign | Root Cause | Recommended Structural Response |
|---|---|---|
| Every squad reinvents the same prompts independently | No platform team or shared prompt library | Create a platform team responsibility for prompt library curation; move prompts to a shared repo |
| One person is the AI bottleneck for all squads | AI capability concentrated in a single champion with no platform abstraction | Form a platform team; offload infrastructure to it; champion transitions to enabling role |
| AI tooling decisions made by procurement, not teams | AI adoption treated as a top-down tool rollout, not an engineering capability | Ensure stream-aligned teams have autonomy over their AI tooling within a governance framework |
| Squads cannot explain their AI-generated code in review | Extraneous cognitive load too high; verification is superficial | Slow down adoption pace; use enabling team to coach verification practices |
| The enabling team is doing the AI work, not coaching it | Enabling team has become a dependency rather than a coach | Reset enabling team mandate: time-box coaching engagements; require squads to own outputs |
| Platform team is asked to build features, not infrastructure | Boundary between platform and stream-aligned work is unclear | Publish the platform Team API; enforce "we build the road, not the car" principle |
| No squad can articulate their AI adoption stage | No shared framework for assessing or communicating adoption progress | Run the Stage Navigator assessment with all squads; surface and share results |
| AI adoption metrics measure tool activation, not engineering outcomes | Metrics designed for reporting, not learning | Replace activation metrics with outcome metrics: cognitive load scores, DORA delta, defect origin tracking |

---

## 7. Recommended O&A Starting Structure

The following ASCII diagram shows a practical starting team topology for O&A AI adoption at
Stages 2–3. This is a **lightweight** starting structure — not a reorganisation proposal. It
can be implemented by assigning existing people to these roles temporarily, not by creating new
headcount.

```
┌─────────────────────────────────────────────────────────────────────────┐
│                          O&A AI ADOPTION TOPOLOGY                       │
│                             Stage 2 → Stage 3                           │
└─────────────────────────────────────────────────────────────────────────┘

  ┌──────────────────────┐        FACILITATING         ┌─────────────────────┐
  │    ENABLING TEAM     │◄────────────────────────────►│  STREAM-ALIGNED     │
  │                      │    (coaching, workshops,     │  TEAM: IP Topology  │
  │  AI Champions cohort │     experiment design,       │  Automation         │
  │  (1 per squad,       │     shared retrospectives)   │                     │
  │   rotating)          │                              │  Owns: YANG models, │
  │                      │                              │  collectors, AI-    │
  │  Time-limited role   │                              │  assisted tests     │
  └──────────────────────┘                              └─────────────────────┘
            │                                                     │
            │ COLLABORATION                           X-AS-A-SERVICE (Stage 3+)
            │ (Stage 1-2 only)                                    │
            ▼                                                     ▼
  ┌──────────────────────┐                              ┌─────────────────────┐
  │    PLATFORM TEAM     │◄────────────────────────────►│  STREAM-ALIGNED     │
  │    (emerging)        │    X-AS-A-SERVICE             │  TEAM: Service      │
  │                      │    ─────────────              │  Fulfilment         │
  │  Ollama deployment   │    Ollama API                 │                     │
  │  Prompt library      │    Prompt library             │  Owns: fulfilment   │
  │  CI/CD AI gates      │    CI gates                   │  flows, NSO pkgs,   │
  │  MCP server          │    MCP server                 │  AI-assisted gen    │
  │                      │                              └─────────────────────┘
  │  Initially: 1-2 ppl  │
  │  from enabling team  │                              ┌─────────────────────┐
  │  transitioning to    │◄────────────────────────────►│  STREAM-ALIGNED     │
  │  permanent role      │    X-AS-A-SERVICE             │  TEAM: Network      │
  └──────────────────────┘                              │  Assurance          │
            │                                           │                     │
            │ COLLABORATION                             │  Owns: monitoring,  │
            │                                           │  anomaly detection, │
            ▼                                           │  AI summarisation   │
  ┌──────────────────────┐                              └─────────────────────┘
  │  COMPLICATED-        │
  │  SUBSYSTEM TEAM      │◄ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ Stream-aligned teams
  │  (specialist, later) │       consume output          consume CLI/API
  │                      │       not expertise           not internals
  │  YANG-to-Code gen    │
  │  Fine-tuned NSO      │
  │  model maintenance   │
  └──────────────────────┘

  Interaction modes:
  ════  Collaboration (high-bandwidth, time-limited, Stages 1-2)
  ────  X-as-a-Service (stable API, Stages 3-5)
  ─ ─   Facilitating (coaching, knowledge transfer, stepping back)
```

### Starting Structure Guidance

**Stage 2:** The enabling team (AI Champions) is the dominant structure. No platform team yet —
the champions share a single Ollama instance and a shared prompt library in the repo. Stream-
aligned teams experiment with AI under champion guidance. Interaction mode: Collaboration and
Facilitating.

**Stage 3 transition:** One or two champions with the deepest infrastructure knowledge begin
formally owning the shared services — this is the platform team emerging. The rest of the
champion cohort continues in a lighter enabling role. Stream-aligned teams increasingly consume
AI capabilities via the platform API rather than routing through champions. Interaction mode
shifts: X-as-a-Service for infrastructure, Facilitating for new practice introduction.

**Stage 4+:** Platform team is permanent and explicit. Enabling team is a lightweight, rotating
coordination function. Complicated-subsystem team exists only if there is a genuine specialist
need (e.g., a custom fine-tuned model that no cloud provider offers). Stream-aligned teams are
self-sufficient within their domains.

---

## References and Further Reading

- Skelton, M. & Pais, M. (2019). *Team Topologies: Organising Business and Technology Teams
  for Fast Flow*. IT Revolution Press.
- Conway, M. (1968). How do committees invent? *Datamation*, 14(4), 28–31.
- Sweller, J. (1988). Cognitive load during problem solving. *Cognitive Science*, 12, 257–285.
- Forsgren, N., Humble, J. & Kim, G. (2018). *Accelerate*. IT Revolution Press.
- Related O&A docs: [Cognitive Load](cognitive-load.md) | [Engineering Principles](engineering-principles.md) | [Team Norms](../governance/team-norms.md)

---

*Previous: [Evolutionary Architecture ←](evolutionary-architecture.md) | Next: [Cognitive Load →](cognitive-load.md)*
