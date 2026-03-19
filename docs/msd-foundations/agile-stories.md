# Epics, Stories & Product Discovery

> **Team context:** OSS – Orchestration & Automation (O&A) builds the network automation layer
> at Rogers Communications — YANG models, NETCONF/RESTCONF config push, NSO service packs,
> and TM Forum Open APIs (TMF641, TMF640, TMF639). Every story written here either automates
> a network operation or surfaces data that a human operator used to configure by hand.
> The stakes are high. Poorly written stories produce fragile automation.

---

## 1. Introduction

### Why Story Quality Matters More Than Ever

Agile user stories have always been the unit of work that translates business intent into
software. In a network automation context that unit carries additional weight: a vague story
describing a NETCONF config push can produce automation that silently misconfigures a live
router. There is no "it looks fine in the UI" safety net — the blast radius is a production
outage.

The arrival of AI pair programming raises the stakes further. Addy Osmani, Engineering Lead at
Google Chrome DevTools, articulates this clearly in his writing on **spec-driven AI development**:

!!! quote "Addy Osmani — *AI-Assisted Engineering* (2024)"
    "The quality of your AI output is a direct function of the quality of your specification.
    Garbage in, garbage out has never been more literally true. A fuzzy ticket produces fuzzy
    code — but now it produces that fuzzy code at ten times the speed."

When a developer uses GitHub Copilot or a chat-based LLM to implement a story, the story *is*
the prompt. A story that says *"As a network engineer I want to push configs"* will generate
plausible-looking but semantically wrong code far faster than a human could write it. A story
with precise acceptance criteria — device type, YANG model path, rollback behaviour on failure,
idempotency contract — produces a focused, testable implementation.

This document synthesises the thinking of four product and agile thought leaders whose ideas,
taken together, give the O&A team a coherent framework for story quality:

| Thought Leader | Core Contribution | O&A Relevance |
|---|---|---|
| **Mike Cohn** | INVEST criteria, *User Stories Applied* | Practical quality bar for every ticket |
| **Ron Jeffries** | 3 Cs (Card, Conversation, Confirmation) | Stories are living conversations, not frozen specs |
| **Marty Cagan** | Outcome-driven discovery, empowered teams | Don't build features; solve outcomes |
| **Teresa Torres** | Continuous Discovery Habits, Opportunity Solution Trees | Structured path from insight to story |

---

## 2. Thought Leader Profiles

### 2.1 Mike Cohn — The Craft of Writing Stories

Mike Cohn is the author of **User Stories Applied** (Addison-Wesley, 2004) and **Agile
Estimating and Planning** (2005). More than any other writer he turned user story writing from
a vague XP concept into an engineering discipline with testable quality criteria.

**His central argument:** A user story is not a requirements document. It is a placeholder for a
conversation. But that conversation still needs to produce a story that a team can commit to,
build, and verify. The **INVEST** criteria are his answer to the question: *"How do I know if
this story is ready to be worked on?"*

#### INVEST Criteria

| Letter | Criterion | What It Means | O&A Example Check |
|---|---|---|---|
| **I** | Independent | Stories can be developed and released in any order without blocking each other | "Push NETCONF config for MPLS tunnel" should not depend on "Build the NSO service pack" being in the same sprint |
| **N** | Negotiable | The story is not a contract — scope can change through conversation | The specific YANG path for `ietf-interfaces` may change; the *outcome* (interface state matches intent) is fixed |
| **V** | Valuable | Delivers value to an end user or the business | "Refactor NSO plan callback" is not a story — it is a task. Wrap it: "Reduce config push failure rate by improving error detection in NSO plan" |
| **E** | Estimable | The team can size it | If a story can't be estimated it is too vague or too large — split or spike first |
| **S** | Small | Fits within one sprint | "Automate all Layer 3 VPN provisioning" is an epic; "Automate creation of a BGP peer on a given PE router via NETCONF" is a story |
| **T** | Testable | Acceptance criteria exist and can be verified | "Config is correct" is not testable. "NETCONF `get-config` response for `ietf-routing` matches the intended state JSON fixture within 5 seconds of API call" is testable |

**Story Mapping** is Cohn's technique for organising stories across a horizontal narrative spine
(user activities) and vertical slices (priority). For O&A, the spine might be the
*Service Lifecycle*: Order → Provision → Activate → Monitor → Assure → Decommission. Stories
sit below each activity in priority order. The first horizontal slice across all activities
defines the Minimum Viable Automation — the thinnest end-to-end flow that proves the platform.

??? tip "Story Mapping for a TMF641 Service Ordering Epic"
    Map the spine as the order lifecycle stages defined in TMF641:
    `createServiceOrder` → `acknowledgeServiceOrder` → `provisionService` →
    `activateService` → `notifyOrderCompletion`.

    Each column then contains stories. The top row (walking skeleton) might be:
    - Column 1: Accept a TMF641 POST and persist the order
    - Column 2: Validate order items against the service catalogue
    - Column 3: Translate order to NETCONF RPC and push to NSO
    - Column 4: Poll NSO plan and map state to TMF641 `orderItemRelationship`
    - Column 5: Fire TMF641 Hub notification on state change

    Releases are horizontal cuts. Slice thin first.

---

### 2.2 Ron Jeffries — Stories Are Promises, Not Specifications

Ron Jeffries is one of the three founders of Extreme Programming (XP), alongside Kent Beck and
Ward Cunningham. He coined the **3 Cs** formulation of user stories — arguably the most
important two pages ever written about what a story actually *is*.

**The 3 Cs:**

- **Card** — The physical (or virtual) card is just a token. It holds a reminder, not a
  requirement. The title "Automate NETCONF config push for PE routers" is enough.
- **Conversation** — The real content of a story lives in the conversation between the product
  owner, the engineer, and the tester. The card is a promise that this conversation will happen.
- **Confirmation** — Acceptance tests are the written residue of the conversation. They confirm
  what was agreed. Without them, there is no definition of done.

Jeffries is notably critical of teams that mistake a well-formatted JIRA ticket for a well-
understood story. A story can have beautiful Gherkin syntax and still be semantically hollow if
the conversation never happened.

!!! warning "Jeffries' Warning: AI Can Skip the Conversation"
    When a developer uses an LLM to generate acceptance criteria for a story, they are
    producing a *plausible* Confirmation without the Conversation. The criteria look right.
    They may even be syntactically valid Gherkin. But they encode the *AI's assumptions*
    about the problem, not the *team's shared understanding*.

    For O&A, this is dangerous. An AI-generated acceptance criterion like
    *"Given a valid NETCONF session, when config is pushed, then the device responds with OK"*
    passes a unit test and fails a production router. The conversation with a network engineer
    would have surfaced: Which device platform? Which OS version? Which YANG deviation file?
    Does "OK" mean `<ok/>` in the RPC reply or a subsequent `get-config` validation?

    **Use AI to draft stories. Use humans to validate the Conversation happened.**

**YAGNI (You Aren't Gonna Need It)** — Jeffries also advocates ruthlessly for scope control.
In a network automation platform it is tempting to build for every future device type, every
future YANG model, every conceivable error code. YAGNI says: build what the story asks for,
nothing more. The conversation will surface what is actually needed.

---

### 2.3 Marty Cagan — Outcome-Driven Product Discovery

Marty Cagan is the founder of the Silicon Valley Product Group (SVPG) and author of
**Inspired: How to Create Tech Products Customers Love** (2018) and **Empowered** (2020).
His work is less about story format and more about the organisational conditions that produce
good stories in the first place.

**Cagan's central critique of most tech organisations:** They are **feature factories**. A
business stakeholder asks for a feature, a product manager writes it as a story, engineers
build it. The team ships but the outcome never improves. Cagan argues this is a fundamental
inversion: *outcomes should drive stories, not the other way around*.

#### Empowered Product Teams vs Feature Factories

| Feature Factory (what to avoid) | Empowered Team (what to aim for) |
|---|---|
| Stakeholder says: "Build a dashboard for NOC engineers" | Team owns outcome: "Reduce mean time to detect faults from 45 min to 10 min" |
| PM writes story for the requested feature | PM discovers *why* NOC engineers miss faults, then discovers solutions |
| Engineers estimate and build | Engineers co-own the problem, propose multiple solutions |
| Ship, move on | Measure outcome, iterate |
| Stories trace to feature requests | Stories trace to OKRs |

For O&A, the feature factory trap looks like this: a network operations stakeholder says
*"We need an API to push VLAN configs"*. A feature factory team writes the story and builds
it. An empowered O&A team asks: *"What outcome are we trying to achieve? Is it faster
provisioning? Fewer manual errors? What does good look like in six months?"*

#### Connecting OKRs to Stories

Cagan recommends that every story should be traceable to an Objective and Key Result. For O&A
this might look like:

```
Objective: Automate 80% of routine Layer 2 provisioning tasks by Q3
Key Result: Reduce L2 provisioning cycle time from 4 hours to 15 minutes
Key Result: Zero manual CLI steps required for VLAN create/modify/delete workflows

  Epic: Automate VLAN lifecycle management via NETCONF/YANG
    Story: As a service delivery engineer, I can create a VLAN on a given
           switch port by calling POST /api/v1/vlans with a JSON body, so
           that provisioning time drops from hours to seconds.
    Story: As a service delivery engineer, I can delete a VLAN and confirm
           the device running-config no longer contains the VLAN ID within
           10 seconds, so that decommission workflows require no CLI access.
```

**Continuous Product Discovery** — Cagan argues discovery is not a phase. It is an ongoing
practice, running in parallel with delivery. The O&A team should always have a discovery
track: talking to NOC engineers, platform SREs, and service delivery teams to surface the
next highest-value automation opportunity before the current sprint ends.

---

### 2.4 Teresa Torres — Continuous Discovery and Opportunity Solution Trees

Teresa Torres is the author of **Continuous Discovery Habits** (Product Talk, 2021) and a
practitioner-researcher who has coached hundreds of product teams. Her contribution is
a *structural framework* for the space between a business outcome and a written story.

**The core problem she solves:** Most teams jump from "we have an outcome" directly to
"here are the stories". Torres argues this leap skips the most important work — understanding
the *opportunity space* (the customer problems and desires that, if addressed, would produce
the outcome) and the *solution space* (the specific ideas that address those opportunities).

#### The Opportunity Solution Tree (OST)

```
                    [OUTCOME]
            Reduce fault detection time
            from 45 min → 10 min (NOC)
                        |
          ┌─────────────┼─────────────┐
          │             │             │
    [OPPORTUNITY]  [OPPORTUNITY]  [OPPORTUNITY]
    NOC engineers  Fault events    Alert routing
    don't see      buried in       sends to wrong
    fault alerts   noise           on-call team
    in time        
          │             │             │
    ┌─────┴────┐   ┌────┴─────┐  ┌───┴──────┐
  [SOLUTION] [SOL] [SOLUTION] [SOL] [SOLUTION]
  Real-time  Push  Severity   ML   Escalation YANG
  dashboard  notif  filter    rank  model config
          │
    ┌─────┴─────┐
  [EXPERIMENT] [EXPERIMENT]
  Prototype    A/B test
  dashboard    notification
  with 3 NOC   format with
  engineers    NOC team
```

Torres insists that teams should be exploring **multiple opportunities in parallel** and
**multiple solutions per opportunity** rather than serially validating one idea at a time.
The tree structure makes the reasoning explicit and auditable.

#### Interview-Driven Discovery

Torres' discovery method centres on **weekly customer interviews** — not surveys, not usage
analytics alone, but structured conversations with real users. For O&A, "customers" are:

- **NOC Tier 1/2 engineers** — who manually correlate alarms and push fix configs
- **Service Delivery engineers** — who provision customer circuits
- **Platform SREs** — who maintain the automation infrastructure itself
- **Network Architects** — who define YANG models and service design patterns

A Torres-style interview for O&A would not ask *"What features do you want?"* It would ask:
*"Walk me through the last time you had to manually intervene in a provisioning workflow.
What happened? What were you looking for? What did you do next?"*

These stories (in the interview sense) become the raw material for opportunities in the OST,
which in turn drive epics and stories.

---

## 3. The 3 Cs and INVEST in O&A Practice

### 3.1 Applying the 3 Cs to O&A Tickets

A JIRA ticket is a **Card**. The sprint planning and backlog refinement sessions are the
**Conversation**. The acceptance criteria and automated tests are the **Confirmation**.

For O&A, the Conversation must involve at least:

- A **network SME** (What is the expected device behaviour? Which YANG model?)
- A **developer** (What is technically feasible? What are the API contracts?)
- A **tester or quality advocate** (How will we prove this works on a real or simulated device?)

Without all three voices, the Confirmation — the acceptance criteria — will have blind spots.

### 3.2 INVEST Checklist Applied to O&A Examples

#### Example Story 1: NETCONF Config Push

> *"As a service delivery engineer, I can push an interface configuration update to a PE router
> via the platform API so that I no longer need CLI access to complete a circuit activation."*

| INVEST | Pass? | Notes |
|---|---|---|
| Independent | ✅ | Does not depend on any other story in the sprint |
| Negotiable | ✅ | Specific YANG path is negotiable; the no-CLI outcome is fixed |
| Valuable | ✅ | Removes manual CLI step from provisioning workflow |
| Estimable | ✅ | Team has done similar NETCONF work; 3-point estimate agreed |
| Small | ✅ | Scoped to one interface config type on one device OS |
| Testable | ✅ | AC defined: `get-config` response matches intended state fixture within 5s |

#### Example Story 2: TMF641 Service Order Integration

> *"As the OSS integration layer, I can receive a TMF641 `createServiceOrder` POST request and
> translate it into an NSO service input so that service orders flow end-to-end without manual
> handoff."*

| INVEST | Pass? | Notes |
|---|---|---|
| Independent | ⚠️ | Depends on NSO service pack existing — may need to be sequenced or split |
| Negotiable | ✅ | Field mapping between TMF641 and NSO input model is negotiable |
| Valuable | ✅ | Eliminates manual translation step between OSS and NSO |
| Estimable | ⚠️ | TMF641 schema is large — needs a spike to confirm scope before estimating |
| Small | ❌ | Full TMF641 → NSO translation is too large. Split: start with `createServiceOrder` for L3VPN service type only |
| Testable | ✅ | AC: POST to `/tmf-api/serviceOrdering/v4/serviceOrder` with valid L3VPN payload triggers NSO `create-service` RPC with correct input; response `state` is `acknowledged` within 2s |

!!! note "Spike Stories are Valid"
    When a story fails **Estimable**, the right response is a **spike** — a time-boxed
    investigation (typically half a sprint) that produces knowledge, not production code.
    A spike for TMF641 integration might be: *"Spend 2 days mapping TMF641 `serviceSpecification`
    fields to the existing NSO L3VPN service model and produce a field mapping document."*
    The spike output then makes the real story estimable.

---

## 4. AI and Story Quality

### 4.1 Osmani's Spec-Driven Lens

Addy Osmani's framing is simple: when you use an AI coding assistant, your ticket *is* your
prompt. The LLM has no access to:

- Your YANG deviation files
- The specific Cisco IOS-XR or Nokia SR OS platform behaviour your code must handle
- Your team's error handling conventions (do you return `207 Multi-Status` or `422` on partial
  NSO plan failure?)
- Your test infrastructure (do you test against a NETCONF sandbox or a real lab device?)

A developer who pastes a vague story into Copilot Chat will get code that compiles, passes
linting, and is confidently wrong. A developer who pastes a story with precise acceptance
criteria, YANG model references, and example payloads will get a first draft that is worth
reviewing and refining.

**Practical guidance:** Before using an AI assistant to implement a story, ensure the story
contains:

- [ ] The YANG model or TM Forum API endpoint involved
- [ ] At least one example input payload (JSON, XML, or YANG instance data)
- [ ] The expected output or state change (with specifics — not "it works")
- [ ] The error/edge case to handle (e.g., device unreachable, NETCONF lock held by another session)
- [ ] The definition of done (automated test? manual lab verification? both?)

### 4.2 The Shallow Story Risk

!!! warning "AI-Generated Stories Can Be Syntactically Valid But Semantically Empty"
    LLMs are very good at writing user stories that *look* well-formed. They will produce
    INVEST-compliant templates, Gherkin Given/When/Then blocks, and professionally worded
    acceptance criteria — for problems they do not actually understand.

    Consider asking an LLM to write acceptance criteria for:
    *"Integrate the platform with TMF640 Service Activation Testing API."*

    The LLM will produce something like:

    ```gherkin
    Given a valid service order exists
    When a test execution request is submitted
    Then the response status is 201 Created
    And the test result is returned within the SLA
    ```

    This looks reasonable. It is not. It misses:
    - Which test type (`testType`: CONNECTIVITY, THROUGHPUT, LATENCY)?
    - Which service type is being tested (L3VPN? Ethernet E-Line?)?
    - What "within the SLA" means numerically?
    - What happens when the target device is in maintenance mode?
    - Does the platform need to poll for async results or register a Hub callback?

    These questions only surface through Ron Jeffries' **Conversation** — with the network
    SME, the TMF API owner, and the operations team. AI can draft. Humans must validate.

### 4.3 Using AI Well in the Story Lifecycle

| Story Stage | Good AI Use | Poor AI Use |
|---|---|---|
| **Discovery** | Summarise interview notes, cluster opportunities | Replace interviews with AI-generated user problems |
| **Epic framing** | Suggest how to decompose a large capability | Define the outcome without talking to users |
| **Story drafting** | Generate a first-draft story from notes | Write final acceptance criteria without review |
| **Refinement** | Check INVEST compliance, suggest splits | Estimate story points (AI has no team context) |
| **Implementation** | Generate NETCONF RPC boilerplate, YANG path traversal | Write business logic without spec |
| **Testing** | Generate test fixtures from example payloads | Define what "correct" means |

---

## 5. Outcome-Driven Stories

### 5.1 The Cagan Approach: Start With the Outcome

The O&A team should resist the pull toward story writing as the first step. Before the first
story is written, the team should be able to answer:

1. **What outcome are we trying to achieve?** (Measurable, time-bound)
2. **How will we know we've achieved it?** (Leading and lagging indicators)
3. **What do we currently know about why the outcome is not being achieved?**
4. **What have we learned from users about their actual experience?**

Only then does story writing begin — and stories are scoped to test hypotheses about how to
achieve the outcome, not to implement a predetermined feature list.

### 5.2 Torres' OST for an O&A Epic

#### Epic: Automate Fault Detection and First-Response Config Push

**Outcome:** Reduce mean time to restore (MTTR) for common network faults from 45 minutes
to under 10 minutes by automating detection-to-remediation workflows.

```
OUTCOME: MTTR < 10 min for common L3 faults
│
├── OPPORTUNITY 1: NOC engineers discover faults too late
│   (Source: interview — "I check the alarm screen every 15 min manually")
│   │
│   ├── SOLUTION 1A: NETCONF event notification subscription (RFC 5277)
│   │   └── EXPERIMENT: Subscribe to `ietf-alarms` on 3 lab devices, measure
│   │                   notification latency vs polling
│   │
│   └── SOLUTION 1B: Streaming telemetry ingest (gNMI/gRPC)
│       └── EXPERIMENT: gNMI dial-out from 2 Nokia devices to collector,
│                       compare fault visibility with current SNMP traps
│
├── OPPORTUNITY 2: Remediation requires manual CLI — no automation exists
│   (Source: interview — "I SSH in and type the same 6 commands every time")
│   │
│   ├── SOLUTION 2A: Pre-approved config templates pushed via NETCONF
│   │   └── EXPERIMENT: Build 3 templates (BGP peer reset, interface bounce,
│   │                   route flap dampening clear) and test with NOC shadow
│   │
│   └── SOLUTION 2B: NSO reactive FASTMAP service for auto-remediation
│       └── EXPERIMENT: Prototype NSO action that fires on alarm event,
│                       present to NOC team for approval workflow discussion
│
└── OPPORTUNITY 3: No audit trail for remediation actions
    (Source: interview — "I write it in a notepad and forget")
    │
    └── SOLUTION 3A: Immutable event log (what fired, what changed, who approved)
        └── EXPERIMENT: Log NETCONF edit-config RPCs to append-only store,
                        show NOC team mock audit report
```

From this OST, the team writes stories for the **experiments first** — not the full solutions.
The stories validate assumptions before full build-out.

**Example story from Experiment 1A:**

> *As a platform engineer, I can subscribe to `ietf-alarms` NETCONF event notifications on a
> lab PE router so that I can measure notification latency versus our current 15-minute polling
> cycle.*
>
> **Acceptance Criteria:**
> - NETCONF `create-subscription` RPC is issued against a Cisco IOS-XR lab device
> - Notifications for `alarm-notification` stream are received within 5 seconds of a
>   simulated interface-down event
> - Latency data is logged to a CSV for comparison with current SNMP polling baseline
> - Findings documented in a one-page spike report for the team

This is a Torres-style experiment story — small, testable, and explicitly designed to produce
*learning* rather than production code.

---

## 6. Discovery in a Telecom Context

### 6.1 Who Are the Users in O&A?

Before writing a single story, the O&A team must be clear about who their users are and what
those users actually care about. These are not hypothetical personas — they are real people
at Rogers with real pain.

| User | Role | Primary Pain | Metric They Care About |
|---|---|---|---|
| NOC Tier 1 Engineer | First-line fault response | Manual steps to correlate and remediate faults | MTTR, false alarm rate |
| Service Delivery Engineer | Provisions customer services | Manual CLI steps, ticket SLA pressure | Provisioning cycle time, error rate |
| Platform SRE | Runs automation infrastructure | Alert fatigue, on-call for infra the team built | Platform availability, deployment frequency |
| Network Architect | Designs YANG models and service patterns | Drift between model and device reality | Config compliance rate |
| Operations Manager | Owns SLAs and staffing | Unpredictable manual workload spikes | SLA compliance, headcount efficiency |

### 6.2 Discovery Cadence for O&A

Torres recommends **one customer interview per week per product trio** (PM, designer,
tech lead). For O&A, adapt this as:

- **Weekly:** 30-minute conversation with one NOC or service delivery engineer
- **Bi-weekly:** Review of automation failure logs with an SRE
- **Monthly:** Demo of current automation to network architects for YANG model feedback
- **Quarterly:** Review of OST with operations manager to validate outcome is still the
  right outcome

Discovery should feed the backlog *continuously*, not as a big-bang requirements phase at
the start of a project.

### 6.3 Epic to Story: "Automate Fault Detection" Worked Example

**Step 1 — Define the outcome** (Cagan):
> Reduce MTTR for common L3 faults from 45 minutes to under 10 minutes.

**Step 2 — Build the OST** (Torres):
> Identify 3–5 opportunities through interviews. Map solutions. Design experiments.

**Step 3 — Write experiment stories** (Jeffries — small, testable, Conversation-first):

```
Epic: Automate L3 Fault Detection and Remediation [OKR: MTTR < 10 min]

  Sprint 1 Stories:
  ┌─────────────────────────────────────────────────────────────────┐
  │ SPIKE: Evaluate NETCONF event notifications vs gNMI telemetry   │
  │ for fault detection latency on Cisco IOS-XR lab devices         │
  │ Value: Informs solution choice; unblocks Stories 2 and 3        │
  │ AC: Latency comparison document produced; recommendation made   │
  └─────────────────────────────────────────────────────────────────┘

  Sprint 2 Stories (post-spike):
  ┌─────────────────────────────────────────────────────────────────┐
  │ STORY: Subscribe to ietf-alarms event stream on PE-01           │
  │ As a platform service, I receive alarm events within 5s of      │
  │ a simulated fault so that downstream remediation can begin      │
  │ without manual NOC intervention.                                │
  │ AC: See acceptance criteria block below                         │
  └─────────────────────────────────────────────────────────────────┘
```

**Acceptance Criteria for the `ietf-alarms` subscription story:**

```gherkin
Feature: NETCONF alarm event subscription

  Scenario: Successful subscription to alarm stream
    Given a NETCONF session is established to lab device PE-01
    And PE-01 is running Cisco IOS-XR 7.5.x with ietf-alarms support
    When the platform issues a create-subscription RPC for the alarm-notification stream
    Then the subscription is acknowledged with <ok/> within 2 seconds

  Scenario: Alarm notification received after interface fault
    Given a valid alarm-notification subscription exists on PE-01
    When interface GigabitEthernet0/0/0/1 is administratively shut down in the lab
    Then an alarm-notification event is received by the platform within 5 seconds
    And the event contains: alarm-type-id, resource (interface name), perceived-severity
    And the event is persisted to the fault event log with a UTC timestamp

  Scenario: Subscription survives a NETCONF session reconnect
    Given a valid alarm-notification subscription exists
    When the NETCONF session drops and reconnects within 30 seconds
    Then the platform re-establishes the subscription automatically
    And no alarm events are silently lost during the reconnect window
```

---

## 7. Anti-Patterns

### 7.1 The Story Factory

!!! warning "Anti-Pattern: Writing Stories Without Discovery"
    The most common anti-pattern in feature factories: a stakeholder meeting produces
    a list of requested features, and a product manager converts that list into JIRA stories
    within 24 hours — without a single user interview, without an OST, without evidence that
    the features will achieve any outcome.

    For O&A this looks like: a network ops director says *"We need a self-service portal for
    VLAN provisioning"*. Stories appear in the backlog by end of day. The team builds a portal.
    Adoption is low because service delivery engineers prefer the existing ticket-based workflow
    and don't trust the portal's validation logic.

    The solution is not to be slower — it is to do discovery *in parallel* with delivery,
    so that by the time the team is ready to build the portal, they have already interviewed
    five service delivery engineers and know which specific part of the workflow is painful.

### 7.2 Points Worship

!!! warning "Anti-Pattern: Optimising for Velocity Instead of Outcomes"
    Story points and velocity are internal planning tools. They are not business value.
    A team that ships 40 points per sprint of poorly-chosen stories is delivering less value
    than a team that ships 20 points of high-impact automation that NOC engineers actually use.

    Signs of points worship in an O&A context:
    - Stories are split to hit a target point count rather than to reduce risk or create value
    - "Chores" (infra maintenance, YANG model updates) are inflated with points to show progress
    - The backlog is measured in total story points rather than in outcome-proximity
    - Sprint reviews report velocity rather than automation coverage or MTTR change

### 7.3 Missing Acceptance Criteria

!!! warning "Anti-Pattern: Stories Without Confirmation"
    A story without acceptance criteria is a Jeffries Card without a Confirmation. The
    team will implement it, ship it, and have no agreed definition of done. In a network
    automation context this is particularly dangerous:

    - "Push interface config" — does that include rollback on error?
    - "Integrate with TMF641" — which version? Which mandatory fields?
    - "Monitor for faults" — what is the polling interval? What is the alert threshold?

    Every O&A story must have at minimum:
    - **Given**: the pre-condition (system state, data present, device reachable)
    - **When**: the trigger (API call, event, user action)
    - **Then**: the verifiable outcome (state change, response code, data persisted)
    - **And/But**: edge cases (error response, device unreachable, duplicate request)

### 7.4 Epics That Never Get Split

!!! warning "Anti-Pattern: Epics as Permanent Backlog Items"
    An epic that has lived in the backlog for more than two sprints without producing
    any child stories is a sign that discovery has not happened. The epic is a wish,
    not a plan.

    *"Automate all MPLS provisioning"* is not an epic. It is an aspiration. The work of
    product discovery is to reduce that aspiration to a sequence of small, independently
    valuable stories that each move the MTTR or provisioning cycle time metric.

    **The test:** Can you name the first story that would come out of this epic and ship it
    in the current sprint? If not, schedule discovery before scheduling build.

---

## 8. Practical Starting Point: INVEST Checklist for AI-Assisted Story Writing

Use this checklist before asking an AI coding assistant to implement any O&A story.
If any item is unchecked, resolve it through conversation before generating code.

### Story Readiness Checklist

**Identity and Outcome**
- [ ] The story has a clear actor (who benefits from this story being done?)
- [ ] The story has a clear goal (what can the actor now do that they couldn't before?)
- [ ] The story is traceable to an OKR or measurable team outcome
- [ ] The story has been discussed in a refinement session with a network SME present

**INVEST Quality**
- [ ] **Independent:** This story can be developed without blocking other sprint stories
- [ ] **Negotiable:** The *what* is fixed; the *how* can still be discussed in development
- [ ] **Valuable:** Delivers value to a real user or reduces operational risk
- [ ] **Estimable:** The team has enough information to size this (or a spike has been run)
- [ ] **Small:** Can be completed and reviewed within one sprint
- [ ] **Testable:** Acceptance criteria exist and can be verified with automation or a lab test

**Technical Specificity (O&A-specific)**
- [ ] The YANG model, NSO service name, or TM Forum API endpoint is named
- [ ] At least one example request payload is included or linked
- [ ] The expected response or device state change is specified (with data, not adjectives)
- [ ] The error/edge case behaviour is defined (device unreachable, lock conflict, bad input)
- [ ] The device OS and version constraints are known (IOS-XR, SR OS, version ranges)
- [ ] The idempotency contract is stated (safe to call twice? safe to retry on timeout?)

**Acceptance Criteria**
- [ ] At least one Gherkin scenario (Given/When/Then) is written and reviewed by the team
- [ ] The happy path is covered
- [ ] At least one error path is covered
- [ ] Performance or timing requirements are stated if relevant (e.g., "within 5 seconds")

**AI Assistance Readiness**
- [ ] The story contains enough context that an LLM could generate a meaningful first draft
- [ ] Example payloads or data fixtures are available to include in the prompt
- [ ] The team knows which part of the implementation to review most carefully (the part
      where AI assumptions are most likely to be wrong: error handling, YANG path accuracy,
      NSO service pack behaviour)

??? tip "Prompt Template for Copilot / LLM Story Implementation"
    When you are ready to use an AI assistant to implement a story, structure your prompt as:

    ```
    Context: I am working on a network automation platform (Python/NSO/NETCONF) for
    Rogers Communications OSS. We use YANG models (ietf-interfaces, ietf-routing,
    Cisco-IOS-XR vendor models), Cisco NSO for orchestration, and expose TM Forum
    Open APIs externally.

    Story: [paste full story title and description]

    Acceptance Criteria:
    [paste all Gherkin scenarios]

    Technical constraints:
    - Device OS: [e.g., Cisco IOS-XR 7.5.x]
    - YANG model: [e.g., Cisco-IOS-XR-ifmgr-cfg]
    - NSO version: [e.g., 6.1.x]
    - Error handling: Return HTTP 422 with structured error body on NETCONF error
    - Idempotency: Edit-config calls must be idempotent (merge operation)

    Example input payload:
    [paste JSON or XML]

    Expected output / device state:
    [paste expected get-config response or JSON]

    Please implement the Python service layer function and corresponding pytest
    test using the ncclient library.
    ```

    This structured prompt gives the LLM the Conversation context that would otherwise be
    lost. It is not a replacement for human review — it is a way of encoding the team's
    shared understanding into the AI interaction.

---

## 9. References

### Books

| Author | Title | Year | Key Contribution |
|---|---|---|---|
| Mike Cohn | *User Stories Applied: For Agile Software Development* | 2004 | INVEST criteria, story mapping, story splitting patterns |
| Mike Cohn | *Agile Estimating and Planning* | 2005 | Velocity, relative sizing, sprint planning |
| Ron Jeffries, Ann Anderson, Chet Hendrickson | *Extreme Programming Installed* | 2000 | Original 3 Cs formulation, XP practices |
| Marty Cagan | *Inspired: How to Create Tech Products Customers Love* | 2018 (2nd ed.) | Empowered teams, product discovery, outcome thinking |
| Marty Cagan | *Empowered: Ordinary People, Extraordinary Products* | 2020 | Product leadership, OKR-connected teams |
| Teresa Torres | *Continuous Discovery Habits* | 2021 | Opportunity Solution Trees, interview cadence, experiment stories |
| Jeff Patton | *User Story Mapping* | 2014 | Story map structure, walking skeleton, release slicing |

### Articles and Posts

| Author | Title | Source |
|---|---|---|
| Ron Jeffries | *"Bill Wake's INVEST Criteria"* | RonJeffries.com |
| Ron Jeffries | *"The Breakdown of Agile"* | RonJeffries.com, 2018 |
| Marty Cagan | *"The Most Important Thing"* | SVPG.com (outcome over output) |
| Teresa Torres | *"Opportunity Solution Trees"* | ProductTalk.org, 2016 |
| Addy Osmani | *"The Art of Prompting for Engineers"* | addyosmani.com, 2024 |
| Bill Wake | *"INVEST in Good Stories and SMART Tasks"* | XP123.com, 2003 |

### TM Forum Standards Referenced

| Standard | Title | Relevance to O&A |
|---|---|---|
| TMF641 | Service Ordering Management API | Service order intake and lifecycle |
| TMF640 | Service Activation Testing API | Post-activation service validation |
| TMF639 | Resource Inventory Management API | Network resource state and topology |
| TMF628 | Performance Management API | KPI collection and reporting |

### IETF / YANG Standards Referenced

| RFC / Model | Title | Relevance to O&A |
|---|---|---|
| RFC 6241 | Network Configuration Protocol (NETCONF) | Core config push mechanism |
| RFC 8342 | Network Management Datastore Architecture (NMDA) | Running/intended/operational datastores |
| RFC 5277 | NETCONF Event Notifications | Alarm subscription for fault detection |
| RFC 8632 | ietf-alarms YANG module | Structured alarm model for event-driven automation |
| RFC 7950 | YANG 1.1 | Data modelling language for all O&A YANG work |

---

!!! note "Living Document"
    This document is part of the O&A AI Adoption knowledge base. It should be reviewed
    and updated as the team's discovery practices mature. If you have run an Opportunity
    Solution Tree exercise with a real user cohort, or have a worked O&A story that
    illustrates these principles well, add it to Section 6 with a pull request.

    **Owner:** O&A Platform Engineering  
    **Review cadence:** Quarterly, or after any retrospective that surfaces story quality issues  
    **Related pages:** [Engineering Principles](engineering-principles.md) · [Testing Discipline](testing-discipline.md) · [Cognitive Load](cognitive-load.md)
