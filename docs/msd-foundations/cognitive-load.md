# Cognitive Load — The Real Measure of AI Success

!!! quote "Holly Cummins, *Cloud Native Spring in Action* & conference talks"
    "If AI is making your job harder, you're doing it wrong. The point is to take the
    cognitive weight off team members — not to replace one source of mental load with another."

!!! quote "Matthew Skelton & Manuel Pais, *Team Topologies*"
    "Cognitive load is the most important — and most neglected — factor in team effectiveness.
    When cognitive load exceeds capacity, quality drops, flow stops, and team members burn out."

---

## Cognitive Load in Software Teams

Cognitive load is the total mental effort required to do a piece of work. In cognitive psychology,
it is divided into three types, each of which has a direct analogue in software engineering:

| Type | Definition | O&A Software Example |
|---|---|---|
| **Intrinsic** | The inherent complexity of the task itself — the minimum mental effort required to understand the domain | Understanding YANG data modelling, NETCONF RPC semantics, eTOM process hierarchies, TMF API resource schemas |
| **Extraneous** | Unnecessary complexity introduced by poor tools, process, or environment — overhead that does not contribute to the outcome | Navigating 15 Confluence pages to find a NETCONF namespace reference; figuring out which of three Ansible variable precedence rules applies; decoding vendor CLI diff output to understand what NSO committed |
| **Germane** | Productive mental effort that builds lasting understanding and skill | Designing a YANG model that accurately represents a network resource; reasoning about service orchestration sequencing; making an architectural decision about data consistency |

**The goal of good tooling and process — including AI — is to:**

- Preserve capacity for **intrinsic** load (the domain is complex; that complexity cannot be eliminated).
- Eliminate or minimise **extraneous** load (the overhead that does not serve the outcome).
- Protect and expand space for **germane** load (the work that builds capability and delivers value).

Poorly adopted AI tools increase extraneous load. Well adopted AI tools reduce it.

---

## The Paradox: Poorly Adopted AI Increases Cognitive Load

The technology industry has a habit of presenting AI as a universal reducer of effort. For software
teams, this is empirically false unless the adoption is thoughtful. Poorly adopted AI increases
cognitive load through several mechanisms:

### 1. Context Switching Overhead

Working with an AI chat interface while writing code requires constant context switching:
formulating the prompt, interpreting the output, comparing it to the task, switching back to
the editor. Each context switch has a cognitive cost. For tasks where the team member already knows
what to write, this overhead outweighs the benefit.

**O&A example:** An experienced team member writing a `pyang` validation command knows the syntax.
Stopping to prompt an AI for the command, reading the output, and verifying it takes longer and
is more mentally taxing than writing it from memory.

### 2. Output Verification Load

AI output must be reviewed for correctness. This is non-negotiable — see [Testing Discipline](testing-discipline.md).
The cognitive cost of verifying AI output is proportional to the team member's unfamiliarity with the
domain. For code the team member understands well, verification is quick. For code in an unfamiliar
area, verification is as expensive as writing it from scratch.

**The red flag:** If an team member is spending more time reviewing AI output than they would have
spent writing the code, AI is not helping. This is a measurement the team should surface in retros.

### 3. Prompt Crafting Load

Writing effective prompts is a skill that takes time and effort. An team member who is still learning
prompt engineering spends significant cognitive effort formulating requests, interpreting why the
output is wrong, and refining. This effort is extraneous — it does not build domain knowledge.

**The mitigation:** Shared prompt libraries (see [Engineering Principles](engineering-principles.md))
reduce this overhead. Prompts that worked well are captured and reused, reducing the crafting
burden for the second, third, and tenth team member to face the same task.

### 4. Hallucination Recovery

When an LLM produces confidently wrong output — a NETCONF namespace that doesn't exist, an NSO
Python API method that was deprecated two versions ago, a TMF attribute name that is slightly
wrong — the team member must detect the error, diagnose its source, and recover. This is mentally
exhausting and particularly insidious because the error looks correct.

**O&A example:** An LLM generates an NSO Python service callback that uses
`ncs.application.Service` methods from NSO 5.x. The team is on NSO 6.x. The method signatures
changed. The code compiles, the CI passes unit tests (which mock the NSO API), and the error
only surfaces when the package is loaded into NSO. The team member must now debug an API they did
not write and may not be deeply familiar with.

---

## Well Adopted AI Reduces Cognitive Load

The contrast case is equally real. When AI is adopted well — on tasks where it genuinely reduces
extraneous load without introducing verification overhead that exceeds the saving — the effect on
the team is measurable and positive.

### Where AI Genuinely Reduces Cognitive Load for O&A Teams

| Task | Cognitive Load Reduction | Notes |
|---|---|---|
| **YANG stub generation** | High | AI generates the structural boilerplate from a description; team member focuses on constraint and semantic correctness |
| **Ansible task scaffolding** | High | AI generates task structure, module selection, and basic variable references; team member reviews for idempotency and role conventions |
| **Test fixture generation** | High | AI generates XML/JSON test instances from YANG/OpenAPI schemas; team member focuses on which cases to cover, not on XML structure |
| **Documentation drafts** | High | AI drafts service README, ADR context sections, operation runbooks; team member reviews for accuracy |
| **Incident summarisation** | High | AI summarises alert history, log excerpts, and timeline into a readable incident summary; team member focuses on root cause analysis |
| **NETCONF operation lookup** | Medium | "What is the correct NETCONF edit-config operation for deleting a list entry?" is genuinely faster via AI than via RFC search |
| **Boilerplate Python clients** | Medium | AI generates a typed Python wrapper for a known API; team member reviews error handling and retries |
| **YANG-to-Python data class generation** | Medium | AI generates Pydantic or dataclass models from YANG leaves; team member validates against the authoritative YANG model |
| **Vendor CLI to NETCONF translation** | Medium | "Convert this IOS XE CLI snippet to NETCONF XML" reduces manual translation effort |

### Where AI Tends to Increase Cognitive Load (Avoid)

| Task | Why AI Makes It Harder |
|---|---|
| **Architectural decisions** | AI suggests patterns confidently; team member must deeply evaluate each — verification cost often exceeds drafting cost |
| **Complex YANG `must` / `when` constraints** | AI generates plausible-looking constraints that are logically wrong; verification requires deep RFC knowledge |
| **NSO service template debugging** | AI may not know the team's NSO version, device NEDs, or package structure; output requires significant adaptation |
| **Multi-service orchestration logic** | AI cannot hold the full system context; cross-service reasoning is error-prone; verification is expensive |
| **Security-sensitive code (credentials, TLS, AAA)** | Verification demands are high; errors are severe; the domain is complex and version-sensitive |

---

## O&A-Specific Cognitive Load Hotspots

These are the areas where O&A team members consistently report the highest mental burden. They are
prime targets for AI-assisted load reduction — provided the team has the foundations to do it safely.

### YANG Model Authoring

YANG model authoring requires holding in mind: the RFC 7950 data model rules, the target device's
capabilities and existing YANG trees, the eTOM process the model is supporting, the downstream
Python/Go consumers, and the TMF resource schema it should align to.

**AI can reduce load by:** generating the structural YANG from a description, generating initial
`typedef` definitions for common types, generating `augment` stubs for extending standard modules.

**AI cannot replace:** the semantic correctness review, the `must` constraint logic, the decision
about whether to use `list` vs `container`, the review against the device's advertised schema.

### NETCONF Operation Lookup

The NETCONF base protocol (RFC 6241) and its extensions (RFC 5277 for notifications, RFC 6022
for YANG schema retrieval, etc.) are not intuitively navigable. Team Members regularly spend time
locating the correct operation, attribute, or namespace for a specific task.

**AI can reduce load by:** answering specific RFC questions quickly, generating correctly-namespaced
NETCONF XML from a description, explaining the difference between `edit-config` operations.

**AI cannot replace:** verification against the specific device's implementation (which may not
fully implement the RFC), testing against `netsim`.

### Writing Ansible Idempotency Tests

Idempotency testing requires understanding what state the target device should be in after the
playbook runs, running the playbook twice, and asserting that the second run reports `changed=0`.
The cognitive load is in understanding the target state and expressing it in Molecule/testinfra.

**AI can reduce load by:** generating Molecule verify tasks from the playbook's task list,
generating testinfra assertions for common network state checks.

**AI cannot replace:** the team member's judgment about which state assertions are meaningful and
which are trivially satisfied.

### Reading Vendor CLI Diff Outputs

NSO's `commit dry-run` and similar operations produce diff output in vendor CLI format — IOS XE,
Junos, EOS, etc. Reading these accurately, especially for complex interface or routing changes,
is mentally demanding for team members not deeply familiar with that vendor's CLI syntax.

**AI can reduce load by:** translating vendor CLI diff output to a human-readable description of
the change ("This commit will add a static route to 10.0.0.0/8 via 192.0.2.1 and remove the
existing static route to 10.0.0.0/16").

**AI can introduce risk if:** the translation is wrong and the team member accepts it without
cross-checking against the actual YANG data that NSO committed.

---

## Measuring Cognitive Load

### SPACE Framework Signals

The SPACE framework (Satisfaction, Performance, Activity, Communication, Efficiency) provides
dimensions for measuring developer experience. For cognitive load, the relevant dimensions are:

| SPACE Dimension | Cognitive Load Signal | How to Measure |
|---|---|---|
| **Satisfaction** | Team Members report feeling overwhelmed vs. in flow | Sprint retro question: "Rate your mental load this sprint 1–5" |
| **Performance** | Quality metrics: defect rate in AI-generated code vs. human-authored | Track origin of defects found in review or post-merge |
| **Activity** | Time spent in review vs. time spent creating | Time-boxing exercise in retro; not tracked automatically |
| **Communication** | How often team members stop to ask colleagues about AI output | Retro question: "How often did you need to ask someone to verify AI output?" |
| **Efficiency** | Flow state: uninterrupted focus time | Calendar analysis; async-first culture survey |

### Retrospective Questions for Cognitive Load

Run these questions in your sprint retrospective, quarterly at minimum:

1. **"This sprint, did AI tooling make your work mentally lighter or heavier? Why?"**
   — Surfaces specific tools and tasks where the balance is wrong.

2. **"Name one task where you spent more time reviewing AI output than you would have spent writing it."**
   — Identifies tasks where AI is being applied in the wrong direction.

3. **"Name one task where AI genuinely took mental weight off you."**
   — Identifies patterns to expand.

4. **"Was there any AI-generated code you merged that you didn't fully understand?"**
   — The safety question. Any "yes" answer requires follow-up.

5. **"Which part of the O&A stack is hardest to hold in your head? How could that change?"**
   — Identifies systemic cognitive load sources that architecture or documentation could address.

### Flow State as a Proxy

Flow state — uninterrupted, focused, high-productivity work — is the strongest proxy for healthy
cognitive load. Team Members in flow are neither bored (load too low) nor overwhelmed (load too high).

Signs AI adoption is *increasing* cognitive load:
- Team Members describe their work as "constant context switching between the AI and the editor".
- Team Members report spending time "figuring out what the AI was trying to do" rather than building features.
- Sprint velocity is unchanged or lower despite AI tool adoption.
- Defect rate in code is higher in AI-assisted work than in non-AI-assisted work.

Signs AI adoption is *reducing* cognitive load:
- Team Members describe handling more complex work than before with similar mental effort.
- Boilerplate tasks (YANG stubs, Ansible scaffolding, test fixture generation) are no longer
  sources of friction in retrospectives.
- New team members onboard faster because AI handles the "how do I write X in YANG?" questions
  while the team focuses on the "why are we modelling it this way?" questions.
- Sprint velocity increases on tasks with strong foundations (tested, specced, pipelined).

---

## Cognitive Load and Team Topology

*Team Topologies* (Skelton & Pais) argues that team cognitive load should be the primary input
into how teams are structured and what they own. For the O&A team of 10–30 team members, this has
practical implications:

### Service Ownership and Domain Depth

Each service or domain area should be owned by team members who have sufficient cognitive capacity
to understand it deeply. AI can help with breadth (generating across multiple services), but it
cannot substitute for depth (truly understanding one service's behaviour under all conditions).

**Practical implication:** Do not use AI to expand a team's service ownership beyond what they
can genuinely review and own. AI-generated code for services the team does not deeply understand
is a long-term cognitive load liability.

### Documentation as Cognitive Load Reduction

The highest-leverage documentation for cognitive load reduction in the O&A context:

1. **YANG model documentation** — Auto-generated from YANG `description` statements; team members
   update the YANG, the docs update automatically. AI can draft `description` content for new
   YANG leaves.

2. **Runbooks** — Step-by-step operational procedures for common tasks. AI can draft runbooks
   from incident history or from service architecture descriptions.

3. **Architecture decision log (ADR index)** — A single page linking all ADRs with a one-line
   summary. Reduces the cognitive cost of "why did we do it this way?".

4. **Shared prompt library** — See [Engineering Principles](engineering-principles.md). A library
   of proven prompts for common O&A tasks reduces prompt crafting load significantly.

---

## AI Adoption Success Metrics for Cognitive Load

**The primary success metric for AI adoption is not velocity. It is cognitive load.**

A team that ships 20% more code but is chronically overwhelmed has failed at AI adoption. A team
that ships the same amount of code but with noticeably less mental strain, higher quality, and
more sustainable pace has succeeded.

| Metric | Target | How to Measure |
|---|---|---|
| Sprint retro cognitive load score | ≥ 3.5 / 5.0 average (where 5 = "mentally light") | Team survey, retro question |
| "More time reviewing AI than writing" incidents | < 20% of AI-assisted tasks reported | Retro question |
| AI-generated defects as % of total defects | Declining trend; not higher than human-authored baseline | Defect tracking with origin label |
| "Didn't fully understand merged AI code" incidents | Zero | Retro safety question |
| YANG authoring time for new model (medium complexity) | Decreasing trend over quarters | Story point calibration |
| New team member time-to-first-NETCONF-commit | Decreasing trend | Onboarding tracking |

---

## Checklist: Cognitive Load and AI Adoption

### Team Awareness

- [ ] The team has discussed cognitive load types (intrinsic / extraneous / germane) and can identify each in their daily work.
- [ ] Retrospectives include a cognitive load question at least once per month.
- [ ] Team Members can name at least two tasks where AI reduces their mental load and two where it does not.

### AI Usage Patterns

- [ ] AI is not used for tasks where verification time exceeds writing time (team norm).
- [ ] The team has a shared list of "AI-appropriate tasks" for the O&A stack — maintained and updated.
- [ ] No AI-generated code is merged that the merging team member cannot explain.
- [ ] Prompt crafting overhead is addressed via a shared prompt library.

### Measurement

- [ ] Sprint retro includes the cognitive load question ("lighter or heavier?").
- [ ] Defect origin (AI-generated vs. human-authored) is tracked for at least 2 sprints to establish a baseline.
- [ ] YANG authoring time and NETCONF debugging time are tracked as leading indicators of cognitive load change.

### Structural Protections

- [ ] Service ownership is bounded by team cognitive capacity — not expanded just because AI can generate code faster.
- [ ] YANG `description` fields are maintained as the authoritative documentation source.
- [ ] Runbooks are maintained for all operational tasks that require NETCONF/NSO/Ansible knowledge.

---

*Previous: [Trunk-Based Development ←](trunk-based-dev.md) | Next: [Engineering Principles →](engineering-principles.md)*
