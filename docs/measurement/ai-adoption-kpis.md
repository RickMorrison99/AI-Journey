# AI Adoption KPIs

> *"The goal is not to use AI. The goal is to deliver better network automation software, faster, more reliably, and sustainably. AI tooling is one mechanism. KPIs are the instrument panel — not the destination."*
> — O&A AI Adoption Journey Framework

---

## Purpose and Position in the Measurement Stack

AI Adoption KPIs are the top layer of the O&A measurement stack. They exist to answer a specific diagnostic question: **Is AI tooling being adopted in a way that is healthy, maturing, and causally linked to improved delivery outcomes?**

They do not replace DORA metrics or the SPACE framework. They extend them.

```
AI Adoption KPIs     ← "Is AI being adopted well?"
      ↕  maps into
SPACE Framework      ← "Are developers productive and healthy?"
      ↕  maps into
DORA Metrics         ← "Is software delivery performing well?"
```

Any AI KPI that cannot be connected to a DORA metric or SPACE dimension it is expected to influence has no place in the O&A dashboard. Every KPI in this document carries that mapping explicitly.

**Review cadence:** Monthly dashboard review; full analysis in the quarterly SPACE + DORA report.

---

## KPI Reference

---

### KPI 1: AI Tool Weekly Active Rate

**Definition:** The percentage of O&A team members who used at least one AI-assisted tool (GitHub Copilot, Copilot Chat, a team-approved agentic workflow, or an approved LLM via the team's gateway) in a given calendar week. Averaged across all weeks in the measurement period.

**How measured:**
- Primary: GitHub Copilot telemetry (active users / total licensed users per week)
- Secondary: Access logs from any team-operated AI gateway or LLM proxy

**Target:** 80% of team members at least once per week by the end of Month 6 of the adoption programme.

**DORA/SPACE mapping:**
- SPACE-A (Activity): direct input metric
- SPACE-E (Efficiency): proxy for AI tooling integration into daily workflow
- DORA Lead Time: rising active rate should correlate with improving lead time as team members use AI to accelerate development tasks

**Anti-pattern to avoid:** Equating high active rate with successful adoption. An team member who opens Copilot, receives a suggestion, and dismisses it every day will register as "active." Active rate measures presence, not value. Always interpret alongside Agentic Completion Rate (KPI 6) and AI Code Acceptance Rate (KPI 3).

---

### KPI 2: Tool Portfolio Breadth

**Definition:** The average number of distinct AI tools per team member, across the team, in a given month. "Distinct" means tools serving meaningfully different purposes — Copilot (inline generation), Copilot Chat (conversational assistant), a YANG model validation agent, and a test generation workflow count as four. Two slightly different chat interfaces to the same model count as one.

**How measured:**
- Self-reported via monthly tooling survey (2-minute form)
- Cross-referenced with team's approved tool registry

**Target:** Average of 2.5 distinct tools per team member by Month 6; 3.5 by Month 12. Breadth should increase as team members move from Assisted → Augmented → Agentic phases.

**DORA/SPACE mapping:**
- SPACE-A: volume indicator
- SPACE-E: higher breadth should correlate with reduced friction if tools are genuinely complementary
- SPACE-S: if breadth increases but satisfaction drops, the team may be experiencing tool sprawl rather than tool depth

**Anti-pattern to avoid:** Maximising breadth as a goal. A team using 6 overlapping tools without mastering any of them is less productive than a team that deeply integrates 2–3 complementary tools. Breadth is an indicator of exploration maturity, not a target to optimise for directly. Monitor alongside Prompt Template Reuse Rate (KPI 8): high breadth with low prompt reuse suggests fragmentation.

---

### KPI 3: AI Code Acceptance Rate

**Definition:** The ratio of GitHub Copilot code suggestions accepted by team members to the total number of suggestions shown, expressed as a percentage. Measured from Copilot telemetry.

```
AI Code Acceptance Rate = (Suggestions Accepted / Suggestions Shown) × 100
```

**How measured:** GitHub Copilot telemetry dashboard (available in the GitHub organisation admin panel). Export weekly; track trend over time.

**Target:** No absolute target is set for acceptance rate in isolation. Contextual targets:
- If acceptance rate rises while rework rate (SPACE-P) also rises: investigate whether team members are accepting without reviewing.
- If acceptance rate is stable but satisfaction (SPACE-S) drops: prompt iteration burden may be increasing.
- A mature team typically stabilises in the 25–40% range; rates above 60% warrant a review of review rigour.

**DORA/SPACE mapping:**
- SPACE-A: primary Activity metric — this is the quintessential Activity-only metric and must never be presented alone
- SPACE-P: must be shown alongside bug escape rate and rework rate to be meaningful
- DORA CFR: if acceptance rate rises and CFR rises, team members are shipping AI-generated code without sufficient validation

---

> ### ⚠️ MANDATORY PAIRING RULE
>
> AI Code Acceptance Rate **must never appear as a standalone metric** in any report, dashboard, or stakeholder communication. It is an Activity indicator. It tells you how much AI output team members are taking — it says nothing about whether that output is correct, maintainable, or safe.
>
> **Every presentation of AI Code Acceptance Rate must be accompanied by:**
> - YANG Model Defect Rate or Bug Escape Rate (SPACE-P)
> - AI-Assisted PR Rework Rate (SPACE-P)
> - At minimum a note on whether P metrics are stable or trending in the same direction
>
> A high acceptance rate paired with a rising rework rate is not a success signal — it is an early warning that the team is accepting AI output without adequate review.

---

### KPI 4: Test Coverage Delta

**Definition:** The change in automated test coverage percentage that can be attributed to AI-assisted test authoring, measured over the reporting period. Computed as: (test coverage at end of period − test coverage at start of period), with AI-assisted contribution estimated from PR metadata.

**How measured:**
1. Pytest or equivalent coverage report run on every CI build; coverage % stored per build
2. PRs are tagged `ai-assisted-tests` by convention when tests are primarily AI-generated
3. Coverage delta on AI-tagged test PRs is summed and reported separately from non-AI test contributions

**Note on attribution:** Perfect attribution is not possible. The goal is a directional signal: is AI tooling contributing meaningfully to test coverage growth? If the team is using Copilot to scaffold Molecule test scenarios for Ansible roles or to generate pytest stubs for NETCONF response parsing, this should show up as coverage growth.

**Target:** Test coverage should not decrease quarter-on-quarter. A target increase of 5 percentage points per quarter is appropriate for a team starting below 70% coverage. For teams already above 80%, the target shifts to coverage *quality* (branch coverage over line coverage; coverage of YANG validation logic and edge-case NETCONF responses specifically).

**DORA/SPACE mapping:**
- DORA CFR: higher test coverage should reduce change failure rate over time
- DORA Lead Time: AI-assisted test generation should reduce the time to write adequate tests, shortening the development phase
- SPACE-P: test coverage is a leading indicator of quality outcomes

**Anti-pattern to avoid:** Coverage inflation. AI tools can generate large volumes of trivial tests — tests that cover happy-path `assert result is not None` scenarios without testing meaningful YANG schema constraints, NETCONF error handling, or Ansible idempotency. High coverage from trivially generated tests gives false confidence. Review coverage quality in at least one squad per quarter: pull a random sample of AI-generated tests and assess whether they would catch a real defect.

---

### KPI 5: Agentic Delegation Depth

**Definition:** A classification of the tasks the O&A team delegates to AI agents, by complexity level. Tracks the team's progression from using AI for trivial tasks to using it for multi-step, reasoning-intensive workflows.

**Classification tiers:**

| Tier | Label | Description | O&A Examples |
|---|---|---|---|
| 1 | **Trivial** | Boilerplate generation; no reasoning required | Scaffold a YANG module header; generate a standard Ansible role directory structure; autocomplete a NETCONF RPC template |
| 2 | **Routine** | Standard patterns with moderate parameterisation; low risk of subtle error | Generate a YANG `list` with correct key types from a spec; write a Molecule test scenario for a given Ansible role; draft a RESTCONF endpoint description |
| 3 | **Complex** | Multi-step reasoning; context-dependent decisions; higher consequence if wrong | Propose a YANG model refactor for a new service requirement; generate an NSO service template from a customer service spec; design a Nornir workflow to validate BGP peering across a fleet of routers |

**How measured:**
- Self-reported via the sprint AI usage log (a lightweight per-PR or per-task tag: `ai-tier-1`, `ai-tier-2`, `ai-tier-3`)
- Reviewed and calibrated monthly — team members should calibrate their tier judgements in a 15-minute squad session monthly to prevent drift

**Target distribution over time:**

| Month | Tier 1 % | Tier 2 % | Tier 3 % |
|---|---|---|---|
| Month 1–3 | 70% | 25% | 5% |
| Month 4–6 | 50% | 40% | 10% |
| Month 7–12 | 30% | 45% | 25% |

A maturing team shifts its AI usage from boilerplate generation toward genuinely complex delegation. If the distribution is not moving toward Tier 3 over time, the team is not progressing through the adoption journey.

**DORA/SPACE mapping:**
- SPACE-E (Efficiency): Tier 1 tasks are the clearest efficiency wins
- SPACE-P (Performance): Tier 3 tasks are the highest-value but highest-risk — require careful validation
- DORA Lead Time: Tier 2 and Tier 3 delegation should reduce lead time for complex changes

**Anti-pattern to avoid:** Claiming Tier 3 status for tasks that are actually Tier 2 with complex-sounding prompts. A YANG module generated from a one-line description is Tier 1 even if the prompt was long. Tier 3 is defined by the *reasoning* required, not the prompt complexity.

---

### KPI 6: Agentic Completion Rate

**Definition:** The percentage of agentic AI tasks (Tier 2 and Tier 3) that are completed by the AI agent without requiring significant human correction to the core logic or structure. "Significant correction" means any change that alters the semantic meaning of the output — not formatting or minor naming convention fixes.

```
Agentic Completion Rate = (Tasks completed without significant correction / Total agentic tasks initiated) × 100
```

**How measured:**
- Per-PR annotation: team members note whether the AI output was used as-is, with minor edits, or with significant rework
- Tracked in the sprint AI usage log alongside Delegation Depth tier

**Target:**
- Tier 2 tasks: ≥70% completion rate by Month 6
- Tier 3 tasks: ≥40% completion rate by Month 9 (these are hard problems; 100% is not the goal)
- A rising completion rate over time is the signal — not the absolute number

**DORA/SPACE mapping:**
- SPACE-P (Performance): directly measures whether AI output is good enough to use
- SPACE-E (Efficiency): low completion rate means team members are spending time correcting AI, reducing net efficiency gain
- DORA Lead Time: high completion rate reduces the re-work loop time in development

**Anti-pattern to avoid:** Treating low completion rate as purely an AI quality problem. It is equally often a prompt quality problem. If Tier 2 completion rate is below 50%, run a prompt quality workshop before concluding that the AI tool is insufficient. Review the shared prompt library for YANG authoring and Ansible scaffolding — well-structured prompts with clear context (service description, target platform, NSO version, interface type) consistently outperform ad-hoc prompts.

---

### KPI 7: Human-in-the-Loop Rate

**Definition:** The proportion of agentic AI tasks in which a human team member intervenes to correct, redirect, or halt the agent mid-execution (as opposed to reviewing the completed output). This measures *how often the AI goes wrong in a detectable way during execution*, not after.

```
Human-in-the-Loop Rate = (Tasks requiring mid-execution intervention / Total agentic tasks) × 100
```

**How measured:**
- Annotated in the sprint AI usage log: team members flag when they had to stop an agentic workflow and redirect it before it completed
- Distinct from Agentic Completion Rate: this captures in-flight corrections, not post-output rework

**Target:** Should trend **downward** as AI quality improves and team prompting skill grows. A starting rate of 40–60% in Month 1–3 is expected for Tier 3 tasks. Target below 20% for Tier 2 by Month 6; below 30% for Tier 3 by Month 12.

**Important nuance:** A *decreasing* Human-in-the-Loop Rate is a positive signal. However, it should not approach zero — appropriate human oversight of agentic workflows is a safety requirement in network automation, where an incorrectly executed agentic task could push a malformed configuration to a production device. The goal is *informed, proportionate* intervention, not blind trust.

**DORA/SPACE mapping:**
- DORA CFR: high in-loop rate for Tier 3 tasks that reach network devices is a direct CFR risk
- SPACE-E (Efficiency): high in-loop rate is a flow disruptor — team members cannot context-switch away while a task requires monitoring
- SPACE-S (Satisfaction): frequent mid-task interruptions are cognitively taxing and erode satisfaction with AI tooling

**Anti-pattern to avoid:** Misinterpreting a *rising* Human-in-the-Loop Rate as team members "getting better at oversight." If the rate rises, investigate whether: (a) task complexity has genuinely increased (Delegation Depth shift to Tier 3), or (b) AI output quality has degraded (model changes, context window limits hit), or (c) team members have become more cautious following a post-deployment incident involving AI-generated code.

---

### KPI 8: Prompt Template Reuse Rate

**Definition:** The percentage of AI tool interactions (estimated) in which the team member used a shared team prompt template from the O&A prompt library, rather than authoring a one-off prompt from scratch.

```
Prompt Template Reuse Rate = (Interactions using a shared template / Total tracked AI interactions) × 100
```

**How measured:**
- This is inherently difficult to measure precisely. Practical approach:
  1. Track the number of prompt templates in the team library and their usage count (if the library is implemented as a shared snippet system with click-to-copy analytics, this is automatic)
  2. Supplement with self-reported data in the bi-weekly retro: "This sprint, what proportion of your AI interactions used a shared template? (None / Some (< 50%) / Most (≥ 50%) / All)"
  3. Calibrate against squad-level estimates quarterly

**Target:** ≥50% of interactions using a shared template by Month 6; ≥70% by Month 12.

**Why it matters:** The Prompt Template Reuse Rate is the team's **DRY (Don't Repeat Yourself) indicator for AI usage**. It measures whether the team is accumulating shared, reusable AI workflows — or whether every team member is reinventing the same prompts independently.

In the O&A context, the most valuable prompt templates are:
- YANG module scaffolding from a service description (with O&A-specific conventions pre-baked)
- NETCONF `<edit-config>` generation from a human-readable change description
- Ansible role generation with correct Molecule test structure
- NSO service template authoring from a customer-facing specification
- Post-incident log summarisation for MTTR reduction

A growing prompt library with high reuse rate is a knowledge management asset — it encodes team expertise in a form that benefits every team member and every new hire.

**DORA/SPACE mapping:**
- SPACE-C (Communication): the prompt library is a collaboration artefact — contributing to it is a form of knowledge sharing
- SPACE-E (Efficiency): reusing a high-quality template eliminates prompt iteration time
- SPACE-A: tracks team-level AI usage patterns

**Anti-pattern to avoid:** Mistaking prompt library size for prompt library quality. A library of 200 mediocre templates is less valuable than a library of 20 excellent ones. Run a quarterly prompt quality review: rank templates by reuse rate, retire templates with low reuse, and invest in improving the top 5 most-used templates in each squad.

---

### KPI 9: Time-to-First-AI-Use

**Definition:** For each new team member joining the O&A team, the elapsed time from their first day (day 0 of onboarding) to their first documented productive use of an AI tool — defined as an AI-assisted interaction that produces output merged into the codebase or used in a deployed artefact.

```
Time-to-First-AI-Use = (Date of first merged AI-assisted PR) − (Onboarding start date)
                        measured in working days
```

**How measured:**
- Tracked in the onboarding log maintained by the Engineering Manager
- "First merged AI-assisted PR" is identified by the `ai-assisted` PR label and confirmed by the new hire
- Supplement: first use of a shared prompt template (from prompt library) is also recorded, as this may precede the first merged PR

**Target:** ≤5 working days to first AI tool use (even a simple Tier 1 interaction); ≤10 working days to first AI-assisted merged PR.

**Why it matters:** Time-to-First-AI-Use is a direct measure of the quality and completeness of the O&A AI onboarding programme. A long time-to-first-use means the onboarding materials, tool access provisioning, and mentorship are creating friction before team members can experience the value of AI tooling. Reducing this time is one of the highest-leverage investments the team can make in sustainable adoption.

**DORA/SPACE mapping:**
- SPACE-C (Communication): onboarding quality reflects the team's ability to transfer knowledge to new members
- SPACE-E (Efficiency): long onboarding delays reduce the team's effective capacity during ramp-up
- SPACE-S (Satisfaction): a smooth onboarding experience sets the tone for an team member's relationship with AI tooling for months to come

**Anti-pattern to avoid:** Optimising this metric by making the "first AI use" bar trivially low — for example, counting a new hire's first Copilot tab-completion as a productive use. The definition is clear: output must be merged or deployed. If the team is tempted to relax this definition to improve the number, the real problem is in the onboarding programme, not the metric.

---

## Anti-Patterns Table: Metrics That Look Like Success But Aren't

The following combinations are explicitly flagged as failure signals in the O&A measurement framework. If any of these patterns appear, halt AI adoption progress reviews and investigate before continuing.

| Observed Pattern | What It Looks Like | What It Actually Means | Recommended Action |
|---|---|---|---|
| AI Acceptance Rate ↑ + Bug Escape Rate ↑ | "Team Members are using AI more and shipping more code" | Team Members are accepting AI suggestions without adequate review; defects are escaping to staging/production | Mandate AI-assisted PR review checklist; add YANG model validation step; run a rework rate deep-dive |
| Deployment Frequency ↑ + MTTR ↑ | "The team is deploying more often" | More frequent deploys are generating more incidents; the team is moving fast but breaking things | Investigate whether AI-generated changes are bypassing test depth; check CFR in same period |
| Agentic Completion Rate ↑ + Satisfaction ↓ | "AI is completing more tasks autonomously" | Team Members distrust or feel excluded from agentic workflows; verification burden is rising | Review Human-in-the-Loop Rate; run a satisfaction deep-dive focused on AI control and agency |
| Prompt Reuse Rate ↑ + YANG Defect Rate ↑ | "The team is using shared templates consistently" | The shared templates themselves contain errors or are generating subtly incorrect YANG; defects are being systematised | Audit top 5 YANG-related prompt templates; review pyang output for recent AI-generated models |
| Tool Portfolio Breadth ↑ + Efficiency Score ↓ | "Team Members are exploring a wide range of AI tools" | Tool sprawl — too many tools with overlapping functions are creating context-switching and decision fatigue | Conduct a tool rationalisation exercise; retire or limit tools with low unique-value contribution |
| Activity all ↑ + Satisfaction ↓ + MTTR ↑ | "Team output is up across the board" | Classic AI burnout pattern — high volume, declining quality, declining morale; unsustainable trajectory | Emergency SPACE review; suspend Activity-focused targets; prioritise Satisfaction and Performance recovery |
| Agentic Delegation ↑ (Tier 3) + Change Failure Rate ↑ | "Team is doing sophisticated AI delegation" | Complex AI-generated network automation changes are reaching production with insufficient validation | Gate Tier 3 agentic tasks with mandatory human review; add network integration test stage before production |
| Time-to-First-AI-Use ↓ + Onboarding Satisfaction ↓ | "New team members are using AI tools quickly" | Onboarding is pushing AI tools before team members understand the fundamentals; they're using AI to paper over gaps they haven't yet filled | Reorder onboarding: YANG/NETCONF/NSO fundamentals before AI tools; AI as accelerator, not substitute |

---

## Monthly AI KPI Dashboard — Minimum Viable View

At a minimum, the monthly dashboard should show the following (all on one page or slide):

| KPI | This Month | Last Month | Trend | Status |
|---|---|---|---|---|
| AI Tool Weekly Active Rate | | | ↑ / ↓ / → | 🟢 / 🟡 / 🔴 |
| Tool Portfolio Breadth (avg) | | | ↑ / ↓ / → | 🟢 / 🟡 / 🔴 |
| AI Code Acceptance Rate* | | | ↑ / ↓ / → | — |
| AI-Assisted PR Rework Rate* | | | ↑ / ↓ / → | 🟢 / 🟡 / 🔴 |
| Test Coverage Delta | | | ↑ / ↓ / → | 🟢 / 🟡 / 🔴 |
| Agentic Delegation — Tier 3 % | | | ↑ / ↓ / → | 🟢 / 🟡 / 🔴 |
| Agentic Completion Rate | | | ↑ / ↓ / → | 🟢 / 🟡 / 🔴 |
| Human-in-the-Loop Rate | | | ↑ / ↓ / → | 🟢 / 🟡 / 🔴 |
| Prompt Template Reuse Rate | | | ↑ / ↓ / → | 🟢 / 🟡 / 🔴 |
| Time-to-First-AI-Use (new hires) | | | ↑ / ↓ / → | 🟢 / 🟡 / 🔴 |

*AI Code Acceptance Rate and AI-Assisted PR Rework Rate are always shown on the same row to enforce the mandatory pairing rule.

**Status thresholds:**
- 🟢 On track — metric trending in the right direction or at target
- 🟡 Watch — metric flat or showing early divergence from expected trend
- 🔴 Act — metric trending in the wrong direction or anti-pattern detected (see table above)
- — Never assigned a standalone status (Activity-only metrics)

---

*This document is part of the O&A AI-Agentic Adoption Journey framework. KPI design is grounded in Forsgren et al. (2018) Accelerate, Forsgren et al. (2021) SPACE, and the DORA 2023 State of DevOps Report. All KPI definitions should be reviewed and recalibrated quarterly.*
