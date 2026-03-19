# Flow Metrics & Work Management

> **Team context:** OSS – Orchestration & Automation (O&A), Rogers Communications.
> This guide applies flow-thinking to a team that ships network automation through
> YANG/NETCONF/NSO, TM Forum APIs, and increasingly AI-assisted tooling.

---

## 1. Introduction — Why Flow Matters for AI-Augmented Teams

Software delivery is a flow problem, not a resource-utilisation problem.
The moment a team starts measuring *how busy people are* instead of *how fast value moves*,
it optimises the wrong thing.
For the O&A team this tension is acute: network automation work spans everything from a
three-hour YANG schema tweak to a multi-week NSO function pack that touches five service
models, multiple vendors, and integration test harnesses.
Stacking those work items in a sprint backlog and reporting velocity hides the real signal —
**how long does it take for a committed piece of work to reach production?**

The arrival of LLM-assisted development sharpens this further.
When a developer can ask an AI assistant to draft the first cut of a NETCONF RPC handler
in minutes, the bottleneck shifts from *writing code* to *reviewing, testing, and releasing*
that code.
Teams that still measure story points will not notice the shift; teams that measure
**cycle time** and **throughput** will see it immediately in their data.

### Why O&A specifically

| O&A work type | Typical flow challenge |
|---|---|
| YANG schema authoring | Long feedback loops — schema must be validated against device, then against NSO, then against TM Forum contract |
| NSO service template development | Large batch sizes; templates often grow scope mid-flight |
| TM Forum API integration | Dependency on external teams; items sit *In Progress* but blocked for days |
| LLM-generated automation scripts | Fast draft, slow review — cycle time dominated by human-in-the-loop validation |
| Network-as-code pipeline changes | Infrequent, high-risk deploys that inflate lead time perception |

Flow metrics give the team an empirical, blameless lens on all of these.
They do not require changing the way work is done on day one — only measuring it.

!!! note "AI amplifies flow problems"
    LLMs can generate a YANG model, an NSO Python callback, or a TM Forum payload mapping
    in seconds. If your review and release process takes two weeks, LLM adoption will make
    your WIP pile larger, not smaller. Measure flow first; then layer in AI assistance.

---

## 2. Thought Leader Profiles

### 2.1 David J. Anderson — The Kanban Method

**Key works:** *Kanban: Successful Evolutionary Change for Your Technology Business* (2010);
*Lessons in Agile Management* (2012); founder of Lean Kanban University.

Anderson invented what is now called the **Kanban Method** while managing a software team
at Microsoft in 2004–2005 and formalised it at Corbis in 2006–2007.
His starting insight was deceptively simple: make your existing process visible, then limit
the amount of work actively in flight.

#### Core ideas

**WIP limits** are the heartbeat of Anderson's method.
A WIP limit is a number placed on a column of a Kanban board that says: *at most N items
may be in this state simultaneously*.
When the column is full and something new arrives, the team must *finish* before it *starts*.
This is not a bureaucratic rule — it is a forcing function that exposes blockers,
dependency waits, and over-specialisation.

**The Five Properties of the Kanban Method:**

1. Visualise the workflow
2. Limit WIP
3. Manage flow
4. Make policies explicit
5. Improve collaboratively, evolve experimentally

**Classes of Service (CoS)** are Anderson's mechanism for differentiating work items by
their risk profile and urgency without abandoning a single board.
He defines four canonical classes:

| Class of Service | Cost of Delay curve | Typical O&A example |
|---|---|---|
| Expedite | Immediate and ongoing — delay is catastrophic | P1 network incident, RCA automation fix |
| Fixed-date | Flat then cliff — penalty triggers on a specific date | Rogers regulatory filing deadline |
| Standard | Linear — delay costs accumulate steadily | New NSO service template feature |
| Intangible | Near-zero visible cost of delay but long-term risk | YANG model refactoring, tech debt |

Anderson argues that *not* distinguishing CoS causes teams to treat every item as equal,
which means expedite items crowd out everything else invisibly.

**Flow efficiency** is the ratio of active work time to total elapsed time for an item.
Anderson's observation from real teams: knowledge-work items are *actively worked on* for
only 15–20 % of their total lead time.
The other 80–85 % is waiting — in queues, pending review, blocked on dependency.

```
Flow Efficiency = Active time / (Active time + Wait time) × 100 %

Example: An NSO template story that takes 12 days end-to-end
but is only actively coded/reviewed for 2 days has:
  Flow Efficiency = 2/12 × 100 = 16.7 %
```

For O&A, Anderson's prescription is: **start fewer things, finish more things**.
Every unfinished YANG model or half-tested NSO function pack in progress is a context
switch cost and a risk of merge conflict accumulating in the background.

#### Applying Anderson to O&A

- Set explicit WIP limits per swimlane: e.g., *Development* ≤ 3, *NSO Integration Test* ≤ 2.
- Create a separate **Expedite** swim lane with a WIP limit of 1.
- Hold a brief daily **flow meeting** (not a standup) in front of the board, scanning
  right-to-left (closest-to-done items first).

---

### 2.2 Don Reinertsen — The Economics of Flow

**Key works:** *Principles of Product Development Flow* (2009);
*Managing the Design Factory* (1997); frequent speaker at Lean/Agile conferences.

Reinertsen approaches product development as an **economic problem**.
His 2009 book is considered one of the most rigorous treatments of product development
physics ever written. He argues that most organisations make poor development decisions
because they quantify some costs (headcount, tooling) but leave the most important cost —
**cost of delay** — invisible.

#### Cost of Delay

**Cost of Delay (CoD)** is the economic value lost per unit of time because a feature,
fix, or capability is not yet in production.
Reinertsen insists: *if you cannot quantify the cost of delay, you cannot make good
prioritisation decisions*.

For O&A, CoD manifests in concrete ways:

- A YANG model for a new device type that sits in backlog for three weeks delays the
  automation of provisioning for every network engineer waiting to use it.
- An NSO function pack upgrade blocked by a review queue means manual provisioning
  continues — with its associated error rate and labour cost — for every day of delay.
- An LLM-assisted config-diff tool that takes two months to reach production misses
  every change window it could have caught during that period.

#### Little's Law

Reinertsen applies **Little's Law** — originally from queuing theory — to product
development:

```
L = λ × W

Where:
  L  = average number of items in the system (WIP)
  λ  = average throughput (items completed per time unit)
  W  = average time an item spends in the system (cycle time)

Rearranged:
  W (cycle time) = L (WIP) / λ (throughput)

For O&A example:
  If the team has 20 items in progress and finishes 2 per week:
  Average cycle time = 20 / 2 = 10 weeks
```

The brutal implication: **the only way to reduce average cycle time without adding
capacity is to reduce WIP**.

#### Queue management and batch size

Reinertsen models development queues with **queueing theory**: as utilisation approaches
100%, queue length and wait time grow exponentially.
A developer at 100% utilisation has infinite theoretical queue length.
He advocates targeting 70–80% utilisation for knowledge workers handling high-variability
tasks — leaving slack to absorb variability without queue explosion.

**Batch size economics** is another Reinertsen lens.
Large batches of work feel efficient (one planning ceremony for many items) but carry
hidden costs: long feedback delays, larger integration risk, and high cost if the batch
turns out to be wrong.
Small batches have higher transaction costs per item but dramatically lower holding cost,
risk cost, and feedback latency.

For O&A, this argues for:

- Breaking NSO function packs into independently deployable increments rather than
  delivering everything in one large drop.
- Deploying YANG model additions incrementally as device support is confirmed,
  rather than waiting for full vendor coverage.
- Reviewing LLM-generated code in small slices, not accumulating a large PR.

!!! tip "Reinertsen's challenge to O&A"
    Next time a story is estimated at 13 points, ask instead: what is the cost of delay
    if this is not delivered for another sprint (2 weeks)? For operational automation,
    that number is often measurable — and often surprising.

---

### 2.3 Daniel Vacanti — Metrics That Predict

**Key works:** *Actionable Agile Metrics for Predictability* (2015);
*When Will It Be Done?* (2018); creator of ActionableAgile™ Analytics.

Vacanti is a practitioner and consultant who worked with Anderson early in the Kanban
movement and then specialised in the **statistical treatment of flow data**.
His central thesis: teams already generate the data they need to make reliable forecasts —
they just do not analyse it properly.

#### The three primary flow metrics

Vacanti defines three metrics every Kanban team should track:

1. **Cycle time** — elapsed time from when work *starts* to when it is *done*.
   This is per-item and measured in days (or hours for very fast flows).
2. **Throughput** — number of items completed per unit of time (typically per week).
   This is a count, not a sum of estimates.
3. **WIP** — number of items currently in progress at a snapshot in time.

These three are linked by Little's Law, so any two determine the third.

#### Cycle time scatter plot

The **cycle time scatter plot** plots each completed work item as a dot:
x-axis = completion date, y-axis = cycle time in days.
Overlaying percentile lines (50th, 85th, 95th) gives the team a **service level
expectation (SLE)**: "85% of our stories complete within 12 days."

```
Cycle Time Scatter Plot — O&A example (illustrative)

Days
 25 |                          ·
 20 |         ·           ·
 15 | ·   ·       · ·           95th percentile ----
 12 |   ·   · · ·   ·   ·  ·   85th percentile ----
  8 | ·   ·   ·   · ·  ·  ·
  5 |   ·   ·   · ·   · ·
  3 | · · ·   · ·   · ·
    +---------------------------------------> Date
```

The scatter plot also reveals **aging items** — dots far above the percentile lines that
signal a blocked or zombie item that needs intervention.

#### Throughput histogram

The **throughput histogram** shows, for each week (or fortnight), how many items were
completed.
It answers: "what is our typical delivery rate?"
Because it is a count of completed items, it is immune to the gaming that plagues
story-point velocity.

#### Monte Carlo simulation for forecasting

Vacanti's most powerful technique: use historical throughput data to run **Monte Carlo
simulations** that forecast future delivery.

```python
# Conceptual Monte Carlo for O&A sprint forecast
import random

historical_weekly_throughput = [3, 5, 4, 6, 3, 4, 5, 4, 3, 6]  # last 10 weeks
items_remaining = 25
simulations = 10_000
results = []

for _ in range(simulations):
    weeks = 0
    delivered = 0
    while delivered < items_remaining:
        delivered += random.choice(historical_weekly_throughput)
        weeks += 1
    results.append(weeks)

results.sort()
p50 = results[int(0.50 * simulations)]
p85 = results[int(0.85 * simulations)]
p95 = results[int(0.95 * simulations)]

# "With 85% confidence, 25 items will be done within N weeks"
```

This replaces sprint commitment theatre with **probabilistic forecasting**.
Instead of promising "we will deliver 25 points", the team says:
"based on our last 10 weeks of data, there is an 85% chance all 25 items are done
within 9 weeks."

#### Applying Vacanti to O&A

- Track cycle time separately for different O&A **story types**:
  YANG authoring, NSO template dev, TM Forum integration, LLM tooling.
  Each type has a different distribution shape — mixing them obscures the signal.
- Use the 85th-percentile cycle time as the team's **SLE** when asked "when will this be done?"
- Run a Monte Carlo before each programme increment planning session to give
  stakeholders a data-grounded forecast.

---

### 2.4 Henrik Kniberg — Visualising Flow and the Spotify Model

**Key works:** *Lean from the Trenches* (2011); *Scrum and XP from the Trenches* (2007);
co-author of the *Spotify Engineering Culture* whitepaper (2014); Principal Agile Coach at Spotify.

Kniberg is one of the most widely read agile practitioners in the world, known for making
complex ideas concrete through clear writing and illustration.
His work spans Scrum, Kanban, Lean, and large-scale organisational design.

#### Lean from the Trenches

In *Lean from the Trenches*, Kniberg documents a real Kanban implementation at a Swedish
police authority.
Key lessons relevant to O&A:

- **Visualisation is the first intervention.** Before changing anything, make the work
  visible. A wall with cards reveals blockers, uneven distribution, and hidden queues
  that no status report ever would.
- **Policies beat opinions.** When the team disagrees about priority, an explicit policy
  (written on the board) resolves it without escalation.
- **Improvement is continuous, not periodic.** Rather than retrospective-driven change,
  Kniberg documents teams that improved *daily* as they observed flow.

#### Done-done

Kniberg's concept of **"done-done"** is deceptively important.
"Done" (capital D) means the developer considers it finished.
"Done-done" means it is *deployed, tested in production, and delivering value to the user*.

For O&A:

| State | Meaning |
|---|---|
| Done | Developer has committed the YANG model / NSO template |
| Done-done | The change is deployed to production NSO, validated against a live device, and monitored through at least one change window |

Counting items as done before they are done-done inflates apparent throughput and hides
cycle time in the deployment and stabilisation phases.

#### The Spotify model

The **Spotify model** — Tribes, Squads, Chapters, Guilds — is Kniberg's most famous
contribution to organisational design, though he has repeatedly clarified it was a
description of Spotify at a point in time, not a prescription.

For O&A's context within a large telco:

- **Squad** = a cross-functional team owning end-to-end delivery of a capability
  (e.g., the NSO Automation squad).
- **Chapter** = a grouping of specialists across squads who share a craft
  (e.g., all YANG/NETCONF engineers across O&A teams).
- **Guild** = a voluntary community of interest
  (e.g., a "Network-as-Code" guild spanning O&A, Network Engineering, and Cloud teams).
- **Tribe** = the O&A team itself, as a cluster of squads sharing a mission.

The practical takeaway for Rogers O&A: **Chapter alignment** ensures YANG modelling
standards, NSO best practices, and TM Forum API conventions are shared consistently
across squads, without each squad re-inventing them.

#### Visualising flow practically

Kniberg advocates **physical or digital boards with explicit swimlanes** for different
work types, and **public metrics** visible to the whole team.
His boards typically show:

- **Blocked** as a first-class state (not a sticky on top of another card).
- **Ready for review** as a distinct column, not part of *In Progress*.
- **Deployment** as its own column, separate from *Done*.

---

### 2.5 Allen Holub — Against Velocity, For Conversations

**Key works:** *Holub on Patterns* (2004); widely followed via Twitter/X and conference
talks including "Beyond Estimates", "Real Agility", and "No, you don't need estimates".

Holub is a software engineer and consultant who has become one of the most prominent
voices arguing that mainstream "Scrum-but" practices actively harm teams.
His critique is grounded in the original Agile Manifesto and in flow thinking.

#### The velocity trap

Holub's central argument about **velocity**: it is a *planning tool*, not a *performance
metric*, and most organisations use it as the latter.

Problems with velocity as a metric:

1. **Story points are not consistent.** A "5" for one developer is a "2" for another.
   Aggregating them into a team velocity creates false precision.
2. **Velocity gamification.** Teams learn that large point estimates are rewarded with
   "good velocity" numbers, and inflate estimates accordingly.
3. **Velocity says nothing about value.** Completing 40 points of low-value work is
   worse than completing 10 points of high-value work.
4. **Velocity pressure kills quality.** Under velocity pressure, teams cut corners on
   testing, documentation, and operability — all of which are critical in NSO automation
   where a bad service template can misconfigure thousands of network devices.

#### No estimates and story conversations

Holub advocates replacing estimates with **conversations**.
The goal of a story is not to produce a number — it is to produce enough shared
understanding that the team can build the right thing.

A **Holub-style story conversation** for O&A might look like:

```
Story: "As a network engineer, I need to provision a new L3VPN service
       using the NSO CLI so I don't have to manually configure each PE router."

Conversation topics:
  - What does the NSO service model need to look like?
  - Which vendors/platforms are in scope for this sprint?
  - What is the acceptance test? (Configure a VPN, verify BGP peering comes up,
    verify rollback works on failure.)
  - What are the TM Forum API attributes this service exposes?
  - How will this interact with the existing IP/MPLS YANG model?

Result: not a point estimate, but a shared mental model and explicit acceptance criteria.
```

#### Continuous flow over sprints

Holub is also a critic of mandatory sprints for knowledge work.
He argues that **continuous flow** with explicit WIP limits is more honest than the
fiction of a two-week timebox in which "everything is planned."
For O&A, where work items range from one-hour config fixes to three-month function pack
projects, a pure sprint model forces artificial chopping of work into sprint-sized
pieces — which often means delivering incomplete increments that cannot be deployed.

!!! warning "Holub's warning for O&A"
    If your team is regularly carrying items across sprint boundaries, or splitting stories
    to "fit the sprint" without a real vertical slice, your sprints are theatre.
    The ceremony is consuming planning overhead without delivering the predictability
    a real sprint promises. Consider a flow model instead.

#### What Holub advocates instead

- Kanban or a hybrid Scrumban with minimal ceremony overhead.
- Acceptance criteria written as **examples** (in the spirit of BDD), not point estimates.
- Definition of Done that includes operability: *the feature is monitored in production
  and a runbook exists*.
- Team **autonomy** on how work is sliced and scheduled; management interaction at the
  portfolio level (what to build), not the sprint level (how many points).

---

### 2.6 Mary & Tom Poppendieck — Lean Software Development

**Key works:** *Lean Software Development: An Agile Toolkit* (2003);
*Implementing Lean Software Development* (2006);
*Leading Lean Software Development* (2009).

The Poppendiecks brought the **Toyota Production System (TPS)** into software.
Mary, a manufacturing engineer who later led software product development at 3M,
recognised that the principles underlying lean manufacturing applied — with adaptation —
to software delivery.

#### The seven wastes of software development

Toyota identified **muda** (waste) as the enemy of flow.
The Poppendiecks translated Toyota's seven manufacturing wastes into software terms:

| Toyota waste | Software equivalent | O&A example |
|---|---|---|
| Overproduction | Building features not yet needed | Modelling YANG for 10 device types when only 2 are in production |
| Inventory | Partially done work in backlog | NSO templates written but not yet tested or deployed |
| Extra processing | More work than customer needs | Gold-plating TM Forum API responses with fields no consumer reads |
| Transportation | Handoffs between teams | NSO dev → QA → Ops → Change Mgmt handoff chain |
| Motion | Switching between tasks/contexts | Developer context-switching across 4 active YANG models |
| Waiting | Items blocked in queues | PR sitting unreviewed for 5 days; device lab unavailable |
| Defects | Bugs, rework, misconfigurations | NSO template that misconfigures router; requires manual remediation |

**Partially done work is inventory** and is the most important waste to understand.
A YANG model that is 80% complete but not yet deployed is not 80% of the value —
it is 0% of the value, *plus* it carries the carrying cost of context and risk.

#### Amplify learning

The second Poppendieck principle is **amplify learning**.
In software, learning is the primary activity — the code is a by-product.
Practices that accelerate learning cycles (short feedback loops, automated testing,
continuous deployment) are therefore not overhead; they are the core of the process.

For O&A:
- Automated NSO simulation tests that run on every commit amplify learning faster than
  a monthly lab validation cycle.
- LLM-generated drafts of YANG models that a senior engineer reviews in minutes amplify
  learning for junior engineers faster than weeks of solo study.

#### Decide as late as possible

The third key principle: **decide as late as possible** — not out of procrastination,
but because a decision made with more information is a better decision.
In network automation, this means:

- Do not lock a YANG model to a specific vendor's MIB until the device is physically in
  the lab and can be interrogated with NETCONF `<get>`.
- Do not finalise the TM Forum API contract for a new service until at least one
  consumer team has validated the attribute set.
- Do not choose between two NSO action implementations until performance tests exist.

#### Respect for people

The Poppendiecks, following Toyota, place **respect for people** at the foundation.
This manifests in O&A as:

- Engineers are the experts in YANG modelling and NSO — management sets direction,
  engineers design the solution.
- Metrics (flow metrics included) are used to improve the *system*, not to judge
  *individuals*.
- A deployment failure is a system problem and an opportunity to improve CI/CD,
  not a cause for blame.

---

## 3. Core Flow Concepts

### 3.1 WIP Limits

A **Work-in-Progress limit** is a cap on the number of items that can simultaneously
occupy a workflow state.
It is the single most impactful intervention a team can make to improve flow.

**Why WIP limits work:**

- They force *finishing* over *starting*.
- They expose bottlenecks: when a downstream column is full, upstream must stop,
  making the constraint visible.
- They reduce context switching: fewer items per person means more focused work.
- They reduce cycle time (via Little's Law): lower WIP with stable throughput means
  shorter time in system.

**Practical O&A WIP limits:**

| Board column | Suggested WIP limit | Rationale |
|---|---|---|
| Analysis / Breakdown | 4 | Prevents over-planning ahead of capacity |
| Development (coding) | 3 | One per engineer; encourages pairing on overflow |
| NSO Integration Test | 2 | Lab resource constraint; avoid contention |
| Code Review / PR | 3 | Stale PRs are inventory; small limit forces timely review |
| Deployment Prep | 2 | Avoid change window pile-up |
| Done-done | ∞ | No limit on finished work |

!!! note "Start with 1.5× your current average"
    If you have no existing WIP limits, audit your board for the last two weeks and
    calculate the average items per column. Set limits at 1.5× that average initially.
    Tighten progressively as the team adapts.

### 3.2 Little's Law

As derived in Section 2.2, Little's Law is the fundamental relationship between WIP,
throughput, and cycle time:

```
Cycle Time = WIP / Throughput
```

This equation has three implications for O&A:

1. **To reduce cycle time, reduce WIP** (holding throughput constant).
2. **To increase throughput** without adding people, reduce WIP (which reduces
   context switching overhead and increases focus).
3. **Measuring all three** gives you a consistency check: if your cycle time is 10 days,
   your throughput is 2/week, your WIP should average ~2.9 items.
   If it averages 15, something in the measurement is wrong (likely "started" items
   that are actually blocked/zombie items).

### 3.3 Cycle Time vs Lead Time

These two terms are frequently confused:

| Term | Definition | Clock starts | Clock stops |
|---|---|---|---|
| **Lead time** | Total elapsed time from request to delivery | Item enters the backlog / is requested | Item is in production |
| **Cycle time** | Elapsed time from commitment to delivery | Team *commits* to working on the item (moves to "In Progress") | Item is done-done |

For SLA and forecasting purposes, O&A should track **both**:

- **Cycle time** is the team's controllable metric — it measures their execution.
- **Lead time** is the customer's experience — it includes backlog wait time, which may
  reflect prioritisation decisions above the team's control.

```
Example timeline for an NSO service template story:

Day 0:   Story written by Product Owner (lead time clock starts)
Day 8:   Story pulled into development (cycle time clock starts; 8 days backlog wait)
Day 14:  NSO integration test complete
Day 16:  PR reviewed and merged
Day 19:  Deployed to production, validated (cycle time clock stops: 11 days)
         (lead time = 19 days)
```

### 3.4 Throughput

**Throughput** is the number of items completed per unit of time.
Measured as a count (not story points), it is the most honest proxy for team output.

Key properties:

- Throughput is **a rate over a period**, not a snapshot.
  "We delivered 4 items this week" is less useful than "our median weekly throughput
  over 10 weeks is 4, with a standard deviation of 1.2."
- Throughput is sensitive to **item size homogeneity**.
  If items range from 2-hour bug fixes to 3-week features, throughput count is
  misleading. Split work into similarly sized items, or track throughput by story type.
- Throughput combined with remaining backlog count enables **Monte Carlo forecasting**.

### 3.5 Cumulative Flow Diagram (CFD)

The **Cumulative Flow Diagram** is the richest single visualisation of a Kanban system.
It plots, for each date, the cumulative count of items in each workflow state.

```
CFD interpretation guide:

Items
 ^
 |████████████████████████████  Done-done
 |██████████████████████
 |███████████████               Deployment
 |█████████████
 |████████████                  Review / PR
 |█████████
 |████████                      Development
 |███
 +---------------------------------> Date

Healthy CFD: bands grow at similar rates; narrow bands between states.
Warning sign 1: "Development" band widens while "Done" is flat
               → items pile up, not completing → WIP explosion
Warning sign 2: "Review" band widens
               → review bottleneck; items finishing dev but not getting reviewed
Warning sign 3: Flat periods in all bands
               → team not completing work (holiday, incident, blocked sprint)
```

---

## 4. Kanban for AI Work

AI-assisted tasks have a different flow profile from traditional development tasks.
A developer using GitHub Copilot or a custom LLM assistant to draft YANG models or
NSO Python callbacks can generate *output* much faster — but the **review and validation**
time may be unchanged or longer.

### 4.1 Anatomy of an AI-Assisted O&A Task

```
Traditional YANG schema task:
  [Backlog] → [Analysis: 1 day] → [Development: 3 days] → [Review: 2 days]
  → [NSO Integration Test: 2 days] → [Deploy: 1 day] → [Done-done]
  Total cycle time: ~9 days

AI-assisted YANG schema task:
  [Backlog] → [Analysis: 0.5 days] → [LLM Draft + Engineer Review: 1 day]
  → [Human Review (correctness + safety): 2 days] → [NSO Integration Test: 2 days]
  → [Deploy: 1 day] → [Done-done]
  Total cycle time: ~6.5 days (but review is now the bottleneck)
```

The Kanban board should make the **LLM draft** and **human validation** stages explicit.

### 4.2 Recommended Kanban Columns for O&A AI Work

| Column | WIP limit | Notes |
|---|---|---|
| Backlog / Ready | — | Items refined and ready to pull |
| Analysis | 3 | Story conversation; define acceptance criteria |
| In Development (human) | 3 | Traditional coding |
| LLM-Assisted Draft | 2 | Items where an AI assistant is generating initial code/config |
| Human Validation | 3 | Engineer reviews LLM output for correctness, safety, compliance |
| NSO Integration Test | 2 | Automated + manual lab validation |
| Code Review / PR | 3 | Peer review; policy: review within 1 business day |
| Deployment | 1 | In change window queue or actively deploying |
| Done-done | — | Deployed, monitored, runbook updated |
| Blocked | — | Explicit blocked state; every blocked item has a named owner and unblock date |

!!! tip "Separate 'LLM Draft' from 'In Development'"
    Merging AI-generated work with human-authored work in the same column hides the
    distinction. Keeping them separate lets you measure cycle time *per generation method*
    and compare quality outcomes over time.

### 4.3 Practical O&A Kanban Examples

#### Example 1: YANG schema generation task

```
Story: "Generate YANG model for Cisco IOS-XR interface statistics (oper data)"

Flow:
1. Analysis (0.5 days):
   - Define which oper paths are needed (counters, error rates, utilisation)
   - Identify the NETCONF get-schema response to use as source of truth
   - Write acceptance test: "YANG model loads cleanly in NSO 5.x without warnings"

2. LLM-Assisted Draft (0.5 days):
   - Provide NETCONF schema excerpt to LLM
   - LLM generates initial YANG module
   - Engineer assesses: does it compile? Are types correct? Are must/when constraints present?

3. Human Validation (1 day):
   - Senior YANG engineer reviews for RFC 7950 compliance
   - Check: does the model align with the ietf-interfaces base module?
   - Check: are operational vs configuration nodes correctly classified?

4. NSO Integration Test (1 day):
   - Load model into NSO dev instance
   - Run NETCONF <get> against a simulated device (netsim or real lab)
   - Verify data populates correctly

5. Deploy (0.5 days):
   - Merge to trunk, CI/CD deploys to NSO staging, then production
   - Monitor: verify no NSO alarms for model load

Total cycle time: ~3.5 days (vs ~7 days without LLM assistance)
```

#### Example 2: NSO service template review

```
Story: "Review and certify NSO L2VPN service template v2.3 for production"

Flow:
1. Analysis: Define review checklist
   □ YANG service model compiles in target NSO version
   □ Python service callbacks handle all error cases (device unreachable, rollback)
   □ TM Forum TMF640 API mapping is complete
   □ Service create/modify/delete all tested
   □ Dry-run mode tested
   □ Performance: <5s for single instance provisioning

2. Review (2 days): Senior engineer + automated checks

3. NSO Integration Test (2 days): Full regression against lab topology
   (Cisco ASR, Nokia 7750, Juniper MX all represented)

4. Change Advisory Board approval (async, up to 3 days wait)
   → This is a *queue wait*, not active work — track it in flow data as blocked/waiting

5. Deploy during change window (0.5 days)

Done-done criteria: Template provisioning confirmed live on two PE routers;
  alerts configured; rollback procedure documented in Confluence.
```

!!! warning "Change Advisory Board wait is flow waste"
    If your CAB process adds 3–5 days of wait time to every deployment, that is a
    systemic queue that inflates lead time. Instrument it, report it to management,
    and work toward lighter-weight approval for low-risk automation changes.

---

## 5. Flow Metrics for O&A

### 5.1 Which Metrics to Track

Start with three metrics (Vacanti's recommendation) before adding complexity:

1. **Cycle time** — per item, by story type
2. **Throughput** — items completed per week
3. **WIP** — snapshot count at end of each week

Add these once the basics are instrumented:

4. **Flow efficiency** — active time vs total elapsed time
5. **Lead time** — from request to done-done (customer experience)
6. **Blocked time** — days items spent in Blocked state (identifies systemic impediments)
7. **Age of active items** — how long current WIP has been in flight (identifies zombies)

### 5.2 Example Metrics Table — O&A Team Dashboard

Track the following weekly. Review in a 30-minute metrics review (separate from standup):

| Metric | Target | Alert threshold | How to measure |
|---|---|---|---|
| Median cycle time (all stories) | ≤ 8 days | > 14 days | Jira/Linear: completion date − start date |
| 85th-percentile cycle time | ≤ 14 days | > 21 days | Vacanti scatter plot |
| Weekly throughput | 4–6 items | < 2 items | Count of Done-done transitions per week |
| Current WIP | ≤ 8 items | > 12 items | Board snapshot every Monday morning |
| Flow efficiency | ≥ 30% | < 15% | Active time (dev + test + review) / cycle time |
| Blocked item count | 0 | ≥ 3 simultaneously | Items in Blocked state > 1 business day |
| Age of oldest active item | ≤ 85th-pct cycle time | > 2× 85th-pct | Today − start date for each active item |
| Cycle time: YANG authoring | ≤ 5 days | > 10 days | Filtered by story type label |
| Cycle time: NSO template dev | ≤ 12 days | > 20 days | Filtered by story type label |
| Cycle time: TM Forum API integration | ≤ 10 days | > 18 days | Filtered by story type label |
| Cycle time: LLM-assisted task | ≤ 4 days | > 8 days | Filtered by "llm-assisted" label |

### 5.3 Cycle Time by Story Type

Different O&A work types have intrinsically different cycle time distributions.
**Never aggregate them into a single average** — the mixture obscures the signal.

```
O&A Story Type Cycle Time Distribution (illustrative, based on team calibration)

YANG authoring      [===|=====]   median 3d, 85th-pct 7d
NSO template dev    [======|==========]  median 7d, 85th-pct 14d
TM Forum API work   [====|=========]  median 5d, 85th-pct 12d
LLM-assisted tasks  [==|=====]  median 2d, 85th-pct 6d
Incident/RCA fixes  [=|==]    median 1d, 85th-pct 3d (Expedite CoS)

Legend: [  median  |  85th percentile  ]
```

### 5.4 Throughput by Week

Plot weekly throughput as a bar chart. Use a 6-week rolling average to smooth noise.

```
Week-by-week throughput example (items completed):

Wk 1:  ████ 4
Wk 2:  ████████ 8   ← sprint end spike (sign of batching)
Wk 3:  ██ 2         ← post-sprint hangover
Wk 4:  █████ 5
Wk 5:  █████ 5
Wk 6:  ███████ 7   ← sprint end spike again
Wk 7:  ██ 2
Wk 8:  ████ 4

6-week rolling average: 4.8 items/week
Useful for Monte Carlo: "25 remaining items ÷ 4.8 = ~5.2 weeks median forecast"
```

The end-of-sprint spikes are a sign of **sprint theatre** — items being rushed to Done
to hit sprint velocity, potentially skipping quality steps.

### 5.5 Cumulative Flow Diagram — Reading and Acting

Review the CFD weekly. Look for these O&A-specific signals:

| CFD pattern | What it means | Action |
|---|---|---|
| "NSO Integration Test" band widening | Lab contention or test automation gaps | Add netsim capacity; automate more tests |
| "Human Validation" (LLM review) band widening | Not enough senior engineers available for LLM output review | Pair LLM sessions; build automated lint checks for YANG/NSO |
| "Code Review" band widening | PRs not being reviewed promptly | Enforce 1-day SLA; rotate review duty; reduce PR size |
| "Blocked" band widening | Systemic external dependency | Escalate; make dependency visible to leadership |
| Flat "Done-done" band | Team not completing work | Reduce WIP; investigate zombie items; check for sprint-end batching |

---

## 6. Anti-Patterns

### 6.1 Velocity Obsession

!!! warning "Velocity obsession"
    **Symptom:** Sprint reviews open with "our velocity this sprint was 42 points"
    and the team is praised or criticised based on this number.

    **Why it's harmful:**
    - Story points are ordinal, not cardinal — adding them up is mathematically
      meaningless.
    - Velocity pressure incentivises inflated estimates, rushed work, and deferred
      testing — all catastrophic in NSO automation.
    - Velocity tells you nothing about customer value delivered or operational risk
      introduced.
    - It normalises the fiction that software work is predictably estimable.

    **What to do instead:**
    Replace velocity with throughput (count of Done-done items per week) and
    cycle time percentiles. Run Monte Carlo simulations for forecasting.
    Brief stakeholders on the change and explain why the new metrics are more honest.

### 6.2 Fake "Done"

!!! warning "Fake done"
    **Symptom:** Stories are marked Done at the end of the sprint, but they are not
    deployed. They are "done in development" or "done pending CAB approval" or
    "done but waiting for prod credentials."

    **Why it's harmful:**
    - It inflates velocity while hiding real cycle time.
    - Undeployed work is inventory — it accumulates risk (merge conflicts, config drift,
      stale assumptions about the network state).
    - In NSO automation, a service template that is "done" but not deployed means
      engineers are still provisioning manually — the entire value is unrealised.

    **What to do instead:**
    Define Done-done explicitly (deployed, monitored, runbook updated) and only
    count items as Done when they meet this definition. Track "deployed" as a
    separate board column if CAB or change windows are genuinely outside team control.

### 6.3 Sprint Theatre

!!! warning "Sprint theatre"
    **Symptom:** Sprints exist as a ceremony. Planning is pro-forma, items carry across
    sprint boundaries regularly, backlog refinement produces estimates but no shared
    understanding, and retrospectives produce the same actions every quarter.

    **Why it's harmful:**
    - Ceremony overhead (planning, refinement, review, retro) consumes 15–20% of
      team capacity without delivering the coordination benefit sprints promise.
    - Artificial sprint boundaries cause work to be split at arbitrary points,
      delivering increments that cannot actually be deployed or demonstrated.
    - The team's real workflow is continuous; the sprint overlay is a fiction that
      obscures actual flow data.

    **What to do instead:**
    Consider a Kanban or Scrumban model. Keep retrospectives (they are valuable)
    and a lightweight planning session. Drop mandatory sprint reviews if no real
    increment is deployed each sprint. Measure flow; let the data guide ceremony design.

### 6.4 The Utilisation Trap

!!! warning "100% utilisation"
    **Symptom:** Management dashboards show all engineers "fully allocated" across
    projects. Anyone not actively coding is considered underutilised.

    **Why it's harmful:**
    - Reinertsen's queueing theory: at 100% utilisation, queue length → ∞.
    - Engineers with no slack cannot review PRs promptly, cannot respond to incidents,
      cannot learn new tools (LLMs, new NSO features), and cannot improve processes.
    - In network automation, an over-utilised team will defer automated testing and
      careful YANG modelling in favour of shipping faster — creating debt that manifests
      as outages.

    **What to do instead:**
    Target 70–80% utilisation for knowledge workers. Make slack explicit and protected.
    Use slack time for: PR review, automated test improvement, YANG model refactoring,
    learning (new NSO APIs, LLM tooling), and flow metric analysis.

### 6.5 WIP as a Status Symbol

!!! warning "WIP inflation"
    **Symptom:** Engineers list many items as "In Progress" because it signals they are
    busy. Items stay In Progress for weeks without progress updates.

    **Why it's harmful:**
    - Inflated WIP destroys the accuracy of cycle time and throughput measurements.
    - Items that are actually blocked or zombie show as active, hiding systemic problems.
    - It defeats the purpose of WIP limits.

    **What to do instead:**
    Introduce an explicit **Blocked** state. Require that any item In Progress for
    more than 2× the 85th-percentile cycle time is either actively worked on or
    moved to Blocked with a named owner and expected unblock date.
    Review "aging items" in the weekly metrics review.

---

## 7. Practical Starting Point — Three Steps This Week

You do not need to redesign your process to start measuring flow.
Start here.

### Step 1 — Instrument your current board (Day 1–2)

In Jira (or whatever tool you use), ensure every work item records:

- **Start date** — the date it was moved to *In Progress* (or equivalent "committed" state).
- **Done date** — the date it was moved to *Done* (or your Done-done state).
- **Story type** — a label: `yang-authoring`, `nso-template`, `tmf-api`, `llm-assisted`,
  `incident`, `tech-debt`.

Many tools record this automatically via column transition history.
Export the last 8–12 weeks of completed items. You now have your first dataset.

### Step 2 — Build three charts (Day 3–4)

Using the exported data (a spreadsheet is sufficient to start):

1. **Cycle time scatter plot** — x = completion date, y = cycle time in days.
   Add a horizontal line at the 85th percentile.
   This is your first **Service Level Expectation**.

2. **Throughput histogram** — bar chart of items completed per week.
   Add a 6-week rolling average line.
   This is your input to Monte Carlo forecasting.

3. **WIP over time** — count of items in your "In Progress" column on each Monday
   for the last 8 weeks.
   Plot as a line. Is it trending up? Flat? Cyclical (sprint-end spikes)?

```
Tools that automate this:
  - ActionableAgile™ Analytics (Daniel Vacanti's tool, integrates with Jira)
  - Nave (Kanban metrics SaaS, Jira/GitHub/Trello)
  - Screenful (Jira/GitHub integration)
  - DIY: Python + pandas + matplotlib from Jira REST API export
```

### Step 3 — Share and discuss (Day 5)

Present the three charts at your next team retrospective or planning session.
Do not use them to judge performance.
Ask three questions:

1. **What does our cycle time distribution tell us about predictability?**
   (Are items consistently fast, or is there a long tail of slow items? Why?)

2. **What is our actual throughput?**
   (Not what we planned — what we actually delivered, counted as items.)

3. **What does our WIP level tell us?**
   (Is it higher than it should be given our throughput and cycle time?
   Little's Law will tell you the expected WIP — compare to actual.)

!!! tip "First WIP limit experiment"
    After Step 3, agree on one WIP limit for one column (start with Code Review / PR —
    it is typically the most impactful bottleneck for O&A teams).
    Set it at your current average plus one. Leave it for two weeks, then review.
    This single change will surface more impediments in two weeks than six months of
    retrospectives.

---

## 8. References

### David J. Anderson

- **Book:** *Kanban: Successful Evolutionary Change for Your Technology Business* (2010) — Blue Hole Press. ISBN 978-0984521401.
- **Book:** *Essential Kanban Condensed* (2016, with Andy Carmichael) — free PDF at [leankanban.com](https://leankanban.com).
- **Organisation:** [Lean Kanban University](https://leankanban.com) — certifications, white papers, community.
- **Key paper:** "Kanban – Successful Evolutionary Change for Technology Business" (2009 Agile Conference).

### Don Reinertsen

- **Book:** *Principles of Product Development Flow: Second Generation Lean Product Development* (2009) — Celeritas Publishing. ISBN 978-1935401001.
- **Book:** *Managing the Design Factory* (1997) — Free Press. ISBN 978-0684839929.
- **Talks:** Reinertsen's talks on cost of delay available on YouTube; search "Reinertsen cost of delay".
- **Key concept:** [Cost of Delay](https://blackswanfarming.com/cost-of-delay/) — Joshua Arnold's site for CoD in practice.

### Daniel Vacanti

- **Book:** *Actionable Agile Metrics for Predictability* (2015) — Leanpub. ISBN 978-1484842935.
- **Book:** *When Will It Be Done? Lean-Agile Forecasting to Answer Your Customers' Most Important Question* (2018) — ActionableAgile Press.
- **Tool:** [ActionableAgile™ Analytics](https://actionableagile.com) — integrates with Jira, Azure DevOps.
- **Videos:** Vacanti's YouTube channel and Lean-Agile conference talks on Monte Carlo forecasting.

### Henrik Kniberg

- **Book:** *Lean from the Trenches: Managing Large-Scale Projects with Kanban* (2011) — Pragmatic Bookshelf. ISBN 978-1934356852. Free online at [infoq.com](https://www.infoq.com/minibooks/kanban-scrum-minibook/).
- **Book:** *Scrum and XP from the Trenches* (2007) — InfoQ. Free PDF available.
- **Paper:** *Spotify Engineering Culture* (2014, with Anders Ivarsson) — search "Spotify engineering culture Kniberg" for the original whitepaper and videos.
- **Blog:** [blog.crisp.se/author/henrikkniberg](https://blog.crisp.se/author/henrikkniberg).

### Allen Holub

- **Talk:** "No Estimates" — multiple conference recordings on YouTube.
- **Talk:** "Beyond Estimates: Evidence-Based Scheduling" — Agile 2019.
- **Talk:** "Real Agility" — available on YouTube.
- **Twitter/X:** [@allenholub](https://twitter.com/allenholub) — active commentary on agile practice.
- **Website:** [holub.com](https://holub.com) — articles, workshops.

### Mary & Tom Poppendieck

- **Book:** *Lean Software Development: An Agile Toolkit* (2003) — Addison-Wesley. ISBN 978-0321150783.
- **Book:** *Implementing Lean Software Development: From Concept to Cash* (2006) — Addison-Wesley. ISBN 978-0321437389.
- **Book:** *Leading Lean Software Development: Results Are Not the Point* (2009) — Addison-Wesley. ISBN 978-0321620705.
- **Website:** [poppendieck.com](http://www.poppendieck.com).
- **Foundation:** Toyota Production System source material — *The Toyota Way* by Jeffrey Liker (2004) provides manufacturing context.

---

### Further Reading for O&A

| Topic | Resource |
|---|---|
| YANG modelling best practices | RFC 7950 (YANG 1.1); [yangcatalog.org](https://yangcatalog.org) |
| NSO development flow | Cisco NSO Developer Hub; NSO Principles of Operations |
| TM Forum APIs and flow | TM Forum Open API Table (TMF Open API); TM Forum Frameworx |
| Kanban tool for Jira | [Jira Software Kanban boards](https://www.atlassian.com/software/jira/guides/boards/overview) |
| Monte Carlo in Python | `numpy`, `pandas`, `matplotlib`; see Vacanti's worked examples |
| Flow metrics templates | [Nave](https://nave.team); [Screenful](https://screenful.com) |

---

*Last updated: see git history. Maintained by the OSS O&A team.*
*Feedback and corrections: raise a PR or open an issue in the `noa-ai-adoption` repository.*
