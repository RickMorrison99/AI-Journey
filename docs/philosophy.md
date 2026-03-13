# Philosophy & Thought Leadership

---

## Why Philosophy Matters

Engineering decisions are never value-neutral. Every choice about pipelines, APIs, testing
strategies, and AI tooling embeds assumptions about what matters, who bears risk, and what kind of
team we want to be. The OSS - Orchestration and Automation team explicitly names its values and
their intellectual sources — not to signal virtue, but so that every team member can trace a decision
back to a reasoned principle rather than habit or convenience. When we disagree, we debate ideas,
not personalities.

---

## Thought Leader Profiles

### Dave Farley — Continuous Delivery & Modern Software Engineering

**Affiliation/Role:** Co-author of *Continuous Delivery*; founder of Continuous Delivery Ltd;
YouTube educator.

**Core ideas:** Farley argues that the deployment pipeline is not an operational nicety but the
*only* legitimate path from code to production. By treating every change as a releasable candidate
and using fast, automated feedback loops to reject bad changes early, teams achieve both speed and
stability simultaneously — not as a trade-off. His concept of "engineering" software (rather than
"crafting" it) insists on empirical, hypothesis-driven development.

**Key works:** *Continuous Delivery* (with Jez Humble); *Modern Software Engineering*.

**O&A application:** Principle 1 — "deployment pipeline is the only path to production" — is a
direct operationalisation of Farley's work. Every O&A CI/CD pipeline change must pass through the
same pipeline it governs.

---

### Martin Fowler — Evolutionary Architecture, Refactoring & DRY

**Affiliation/Role:** Chief Scientist at ThoughtWorks; author and international speaker.

**Core ideas:** Fowler popularised *refactoring* as a disciplined, continuous activity rather than a
periodic rewrite. His articulation of evolutionary architecture — systems designed to accommodate
change across multiple dimensions — underpins the idea that architecture is not a one-time decision
but an ongoing practice. Fowler is also widely credited with popularising the DRY (Don't Repeat
Yourself) principle and its corollary: duplication is the root cause of most maintenance debt.

**Key works:** *Refactoring: Improving the Design of Existing Code*; *Patterns of Enterprise
Application Architecture*; bliki articles on evolutionary architecture.

**O&A application:** O&A's engineering principles (Principles 5, 8, 9) draw directly from Fowler.
AI-generated code is particularly prone to subtle duplication — Copilot reviews must check for DRY
violations.

---

### Gregor Hohpe — The Architect Elevator & Enterprise Integration Patterns

**Affiliation/Role:** Enterprise architect; former Google; author and speaker.

**Core ideas:** Hohpe's *Architect Elevator* metaphor describes the architect who can travel between
the penthouse (strategy and business) and the engine room (implementation detail), translating
coherently in both directions. Without this translation, strategy documents are ignored by
team members and implementation detail overwhelms executives. His *Enterprise Integration Patterns*
catalogue provides a rigorous vocabulary for designing message-based systems — a vocabulary that
predates and informs modern event-driven and microservice architectures.

**Key works:** *Enterprise Integration Patterns* (with Bobby Woolf); *The Software Architect
Elevator*.

**O&A application:** The [Architect's Elevator](stakeholders/architect-elevator.md) stakeholder
document is named directly after Hohpe's metaphor. O&A architects are expected to ride the elevator
— presenting the same decision in different registers for different audiences.

---

### Holly Cummins — Sustainable Software & Cognitive Load

**Affiliation/Role:** Senior Principal Software Team Member at Red Hat (Quarkus team); IBM Research
alumna; international conference speaker.

**Core ideas:** Cummins connects sustainable software engineering (reducing resource consumption)
with developer joy and cognitive load. She argues that bloated frameworks, slow feedback loops, and
over-engineered solutions impose cognitive costs that reduce both developer wellbeing and software
quality. Her work on Quarkus demonstrates that fast startup, small memory footprint, and developer
joy are engineering goals, not accidents.

**Key works:** *Enterprise Java with Quarkus*; conference talks on sustainable software and
cognitive load.

**O&A application:** Principle 6 — "manage cognitive load as a first-class concern" — reflects
Cummins' framing. When evaluating AI tools, O&A measures whether a tool reduces or increases
cognitive load on the team, not merely whether it produces output faster.

---

### Nicole Forsgren — Evidence-Based Productivity & the SPACE Framework

**Affiliation/Role:** VP Research & Strategy at GitHub; co-creator of the DORA research programme;
co-author of *Accelerate*.

**Core ideas:** Forsgren established that software delivery performance is measurable and that high
performance correlates with organisational outcomes — not just team happiness. Her DORA metrics
(deployment frequency, lead time, change failure rate, time to restore) gave the industry its first
validated, causal model of delivery performance. More recently, the SPACE framework (Satisfaction,
Performance, Activity, Communication, Efficiency) broadens measurement beyond throughput to capture
the human dimensions of developer productivity.

**Key works:** *Accelerate: The Science of Lean Software and DevOps* (with Humble and Kim); SPACE
framework paper (2021).

**O&A application:** Principles 7 and 18 encode Forsgren's insistence on measuring what matters.
O&A uses DORA baselines before and after AI adoption to avoid claiming productivity gains that are
not evidenced.

---

### Gene Kim — The Three Ways of DevOps

**Affiliation/Role:** Founder of IT Revolution; co-author of *The Phoenix Project* and *The DevOps
Handbook*; researcher and speaker.

**Core ideas:** Kim's *Three Ways* provide a systems-level framing for DevOps: (1) optimise for
flow from development to operations; (2) amplify feedback loops so problems are caught early and
close to their source; (3) foster a culture of continual experimentation and learning. He argues
that technical debt and siloed operations are not inevitable — they are the result of local
optimisation that ignores system-wide flow.

**Key works:** *The Phoenix Project* (with Behr and Spafford); *The DevOps Handbook* (with Humble,
Willis, and Forsgren); *The Unicorn Project*.

**O&A application:** O&A's adoption roadmap is structured around Kim's Three Ways. Flow metrics
(lead time, deployment frequency) are the primary signal; feedback telemetry is automated into
every pipeline; and quarterly retros are the learning cadence.

---

### Jez Humble — Continuous Delivery Practices

**Affiliation/Role:** Co-creator of DORA; co-author of *Continuous Delivery* and *Accelerate*;
lecturer at UC Berkeley.

**Core ideas:** Humble operationalised the continuous delivery pipeline in depth — covering
deployment strategies (blue/green, canary, feature flags), change failure rate as a quality proxy,
and the relationship between trunk-based development and delivery speed. He consistently emphasises
that continuous delivery is a sociotechnical practice, not a tooling choice: the pipeline enforces
discipline that must be culturally owned.

**Key works:** *Continuous Delivery* (with Farley); *Accelerate* (with Forsgren and Kim); *Lean
Enterprise* (with Molesky and O'Reilly).

**O&A application:** The [CI/CD Pipeline](msd-foundations/cicd-pipeline.md) and
[Trunk-Based Dev](msd-foundations/trunk-based-dev.md) sections are essentially Humble's
prescriptions applied to the telecom software context. Change failure rate is a mandatory DORA
metric for O&A teams.

---

### Timnit Gebru — Dataset Ethics, Model Bias & Power Concentration

**Affiliation/Role:** Founder and Executive Director, Distributed AI Research (DAIR) Institute;
former Google Brain researcher.

**Core ideas:** Gebru's research exposed the systematic biases embedded in large language model
training data and the downstream harms of deploying models without demographic auditing. Her
*Stochastic Parrots* paper (with colleagues) challenged the assumption that scale alone produces
quality or fairness. She also critiques the concentration of AI research and deployment power in a
small number of well-resourced organisations, arguing this creates accountability gaps with
real-world consequences.

**Key works:** *On the Dangers of Stochastic Parrots: Can Language Models Be Too Big?* (Bender,
Gebru et al.); *Datasheets for Datasets*.

**O&A application:** Principle 21 — vendor diversity — reflects Gebru's power-concentration
critique. O&A's AI governance process requires that every LLM integration be assessed for bias
against the demographic groups represented in its operational domain.

---

### Kate Crawford — Environmental Cost & the Infrastructure of AI

**Affiliation/Role:** Senior Principal Researcher, Microsoft Research; Research Professor, USC
Annenberg; co-founder, AI Now Institute.

**Core ideas:** Crawford's *Atlas of AI* argues that AI systems are not weightless software but
materially grounded in mines, data centres, labour pipelines, and energy grids. The environmental
cost of training and running large models is often invisible in productivity calculations. She also
critiques the extraction of value from workers whose data trains models and whose jobs are
restructured by them.

**Key works:** *Atlas of AI: Power, Politics, and the Planetary Costs of Artificial Intelligence*.

**O&A application:** Principle 20 — SCI tracking — is a direct response to Crawford's environmental
critique. O&A does not treat AI compute as "free" — the
[Environmental](responsible-ai/environmental.md) section mandates SCI measurement for every
agentic workflow introduced.

---

### Anne Currie — Green Software & the SCI Metric

**Affiliation/Role:** CEO, Container Solutions; co-founder, Green Software Foundation; author.

**Core ideas:** Currie is a leading practitioner voice for green software engineering, making the
case that reducing the carbon intensity of software is both an ethical obligation and an
engineering discipline. She co-developed the **Software Carbon Intensity (SCI)** specification,
which provides a standardised, per-unit-of-work metric for software emissions — enabling
comparisons across architectures and vendors rather than raw energy totals.

**Key works:** *Building Green Software* (with Bergstrom and McMahon); SCI specification (Green
Software Foundation).

**O&A application:** O&A uses SCI as the standard unit for measuring AI energy consumption
(Principle 20). The [Environmental](responsible-ai/environmental.md) section is built around
Currie's SCI methodology, and every new agentic tool must declare its SCI baseline before
production rollout.

---

### Ethan Mollick — AI as Co-Intelligence & the Jagged Frontier

**Affiliation/Role:** Associate Professor, Wharton School, University of Pennsylvania; author and
AI researcher.

**Core ideas:** Mollick coined the *jagged frontier* concept: AI performs exceptionally well on
tasks just inside its capability boundary and surprisingly poorly on tasks just outside it, with no
reliable external signal of which is which. This makes AI a powerful but unpredictable collaborator.
His *co-intelligence* framing argues that the most effective posture is neither full automation nor
sceptical avoidance, but genuine human-AI collaboration — where humans remain the decision-making
layer.

**Key works:** *Co-Intelligence: Living and Working with AI*.

**O&A application:** Principles 13 and 14 — "AI assists, humans decide" and "AI output is a draft,
not a deliverable" — are direct expressions of Mollick's jagged frontier insight. O&A review
processes are designed to catch the silent failures that occur when AI output crosses the frontier
undetected.

---

### Sam Newman — Microservices, Service Boundaries & API Design

**Affiliation/Role:** Independent consultant; author; international speaker on microservices and
software architecture.

**Core ideas:** Newman's *Building Microservices* is the definitive practitioner guide to
decomposing systems into independently deployable services. He emphasises that service boundaries
must align with *team* cognitive boundaries (drawing on Conway's Law) and that APIs are contracts,
not implementations. His more recent work on *monolith to microservices* migrations warns against
premature decomposition and the hidden costs of distributed systems.

**Key works:** *Building Microservices: Designing Fine-Grained Systems*; *Monolith to
Microservices*.

**O&A application:** O&A's API-first principle (Principle 10) and spec-before-code principle
(Principle 11) operationalise Newman's contract-first design discipline. The TM Forum Open API
catalogue is O&A's canonical source of contracts, consumed before any service is implemented.

---

## How These Ideas Connect

At first glance, Modern Software Delivery, Responsible AI, and TM Forum engineering excellence look
like three separate bodies of work. In O&A's framework they form a coherent whole, held together by
a single insight: **AI amplifies existing practice, good or bad**.

The maturity model introduces an *AI Ceiling* concept: a team's ability to benefit from AI tooling
is bounded by the quality of its engineering foundations. A team without automated testing will use
AI to generate more untested code, faster. A team without trunk-based development will use AI to
produce more long-lived branches. A team without SoC will use AI to entangle concerns at greater
scale. Farley, Fowler, Forsgren, Kim, and Humble provide the foundation-building playbook. The DORA
metrics give O&A an objective ceiling measurement before AI is introduced, so productivity claims
after introduction can be validated rather than assumed.

Responsible AI (Gebru, Crawford, Currie, Mollick) then addresses what happens when that amplifier
is pointed at systems that affect people. A high-performing pipeline can ship a biased model faster;
a carbon-efficient architecture still has a carbon cost; a co-intelligent team still needs to decide
who bears risk when AI output is wrong. TM Forum's Open APIs and eTOM/TAM/ODA provide the
domain-specific contract layer — ensuring that AI-generated code integrates with a standards-based
ecosystem rather than accumulating proprietary integration debt. The result is not three frameworks
bolted together, but a single engineering philosophy: **go fast, go safe, go sustainably, with
standards that outlast any individual tool or vendor.**

---

## Further Reading

| Title | Author(s) | Why relevant to O&A |
|---|---|---|
| *Continuous Delivery* | Jez Humble & Dave Farley | The foundational text for Principles 1–4; defines the pipeline model O&A follows |
| *Modern Software Engineering* | Dave Farley | Updates CD thinking for the 2020s; introduces empirical engineering mindset |
| *Accelerate* | Nicole Forsgren, Jez Humble & Gene Kim | Provides the DORA metrics evidence base; Chapters 3–5 directly inform O&A measurement |
| *The Phoenix Project* | Gene Kim, Kevin Behr & George Spafford | Narrative illustration of the Three Ways; useful onboarding read for all O&A team members |
| *Refactoring* | Martin Fowler | Catalogue of refactoring patterns; essential context for AI-assisted code review |
| *Enterprise Integration Patterns* | Gregor Hohpe & Bobby Woolf | Canonical vocabulary for messaging and integration — directly applicable to O&A's event-driven services |
| *Building Microservices* | Sam Newman | Service boundary and API design guidance; aligns with TM Forum Open API decomposition |
| *Atlas of AI* | Kate Crawford | Environmental and labour critique of AI systems; grounds O&A's responsible-AI risk assessment |
| *Co-Intelligence* | Ethan Mollick | Practical framing for human-AI collaboration; the jagged frontier concept informs all O&A AI review gates |
