# SPACE Framework — Developer Productivity

> *"Productivity is not just about the amount of output. It is about doing the right work, in a sustainable way, with the right quality, while maintaining the well-being of the people doing it."*
> — Forsgren et al., "The SPACE of Developer Productivity" (2021)

---

## What SPACE Is

The SPACE framework was published in 2021 by Nicole Forsgren, Margaret-Anne Storey, Chandra Maddila, Thomas Zimmermann, Brian Houck, and Jenna Butler in *ACM Queue* (Volume 19, Issue 1). It is the product of research conducted across Microsoft, GitHub, and academia, combining empirical data from large engineering organisations with developer survey research.

SPACE is not a replacement for DORA. Where DORA measures the health of the software delivery system, SPACE measures the health and productivity of the developers working within it. Together they form a complete picture: DORA tells you whether the pipeline is working, SPACE tells you whether the people running it are doing well.

The five dimensions of SPACE are:

| Dimension | Letter | Core Question |
|---|---|---|
| Satisfaction & Well-being | **S** | Are developers fulfilled, healthy, and not burning out? |
| Performance | **P** | Is the work producing the right outcomes and quality? |
| Activity | **A** | How much work is being done? |
| Communication & Collaboration | **C** | How well do people and teams work together? |
| Efficiency & Flow | **E** | Can developers work without interruption and waste? |

**Critical principle:** No single SPACE dimension is a valid standalone measure of developer productivity. Forsgren is explicit in the paper: measuring one dimension in isolation — especially Activity — is actively harmful, because it creates incentives that improve the measured dimension while degrading the others.

---

## Why SPACE Was Created: The Activity Trap

Before SPACE, the most common "developer productivity" metrics in industry were Activity metrics: lines of code written, commits per day, PRs merged per sprint. These are seductive because they are objective, easy to collect, and always trending upward when developers are working.

They are also misleading in isolation. A developer can:
- Write more code (Activity ↑) while introducing more bugs (Performance ↓)
- Merge more PRs (Activity ↑) while making other developers spend more time in review (Communication ↓)
- Work longer hours to hit output targets (Activity ↑) while heading toward burnout (Satisfaction ↓)

**AI makes this problem dramatically worse.** With AI code generation tools, an team member can produce three times the volume of code in the same time. If the team measures productivity through Activity metrics, AI adoption will look spectacularly successful — while the actual quality, maintainability, and sustainability of the work may be declining. This is why SPACE is non-negotiable in the O&A measurement framework: it is the instrument that prevents AI adoption from being declared successful based on output volume alone.

---

## The Five SPACE Dimensions — O&A Indicators

---

### S — Satisfaction & Well-being

**Definition:** The degree to which developers find their work meaningful, feel supported by their tools and environment, and are not at risk of burnout. Well-being also encompasses physical and cognitive health signals — whether team members are working sustainable hours, experiencing flow states, and feel agency over their work.

This is not a "soft" metric. Forsgren's research shows that developer satisfaction is a leading indicator of retention, code quality, and DORA performance. Teams with low satisfaction scores consistently produce more defects and have higher MTTR. If satisfaction is declining while Activity metrics are rising, something is wrong.

**O&A-specific indicators:**

| Indicator | Description | Collection Method |
|---|---|---|
| Sprint retro AI sentiment score | Aggregate sentiment from retro AI-related discussion: is AI tooling helping or creating friction? | Structured retro question; scored 1–5 |
| eNPS-style AI tooling pulse | "On a scale of 0–10, how likely are you to recommend our current AI tooling setup to a colleague on another team?" | Bi-weekly anonymous survey |
| Reported flow state frequency | "How many deep-focus sessions (90+ minutes uninterrupted) did you have this week?" | Weekly self-report |
| Overtime and after-hours work rate | Hours worked outside core hours per team member per week | Time tracking or self-report; flag if >2hrs/week consistently |
| Sense of purpose score | "Does the work you're doing with AI tooling feel meaningful and impactful to you?" (1–5) | Bi-weekly pulse |

**Bi-weekly retro question set (5 questions — use consistently every sprint):**

1. *"This sprint, did AI tooling make your work feel easier, harder, or about the same? (Easier / Harder / About the same)"*
2. *"How often did you experience frustration with AI-generated output that required significant correction? (Never / Occasionally / Frequently / Always)"*
3. *"Did you feel you had enough uninterrupted time for deep work this sprint? (Yes / Somewhat / No)"*
4. *"On a scale of 1–5, how confident do you feel in the quality of the code you shipped this sprint?"*
5. *"Is there anything about the current AI tooling setup that is costing you more time than it saves? (Free text)"*

**AI risk:** AI tools can initially improve satisfaction (novelty, speed, reduced boilerplate). Satisfaction commonly dips at the three-to-six-month mark when the novelty fades and the verification burden of AI-generated code becomes apparent. If question 2 above trends upward — team members spending more time correcting AI output — satisfaction will follow it down. Watch this signal closely during the scaling phase.

---

### P — Performance

**Definition:** The quality and impact of the outcomes produced by engineering work. Performance is measured through the *results* of work — defects, rework, system reliability — not through the *volume* of work. A developer who writes 500 lines of code with two bugs performs better than a developer who writes 2,000 lines with forty bugs.

This is the dimension most threatened by AI adoption if Activity metrics are allowed to dominate reporting.

**O&A-specific indicators:**

| Indicator | Description | Collection Method |
|---|---|---|
| Bug escape rate | % of defects that reach staging/production vs. caught in development | CI/CD pipeline + incident log |
| Rework rate on AI-assisted PRs | % of AI-assisted PRs that require a follow-up fix within 5 working days of merge | GitHub PR labels ("ai-assisted") + PR history |
| YANG model defect rate | Number of YANG schema errors or validation failures per 100 lines of model code shipped | pyang output in CI pipeline |
| Network config error rate post-deployment | Number of network device configuration inconsistencies detected per deployment | NSO compliance check post-deployment |
| Customer-reported incidents | Incidents reported by consumers of the O&A APIs or automation services per month | Incident tracking system, tagged by source |
| Test coverage of AI-generated code | % of AI-assisted code covered by automated tests at time of merge | Pytest coverage report in CI |

**Collection sources:** CI/CD pipeline (pyang errors, pytest coverage, Molecule test results), incident tracking system (linked to deployment events), GitHub PR metadata (labels, linked issues, follow-up PRs).

**AI risk:** AI-generated code can appear to pass tests while introducing subtle semantic errors in network logic — for example, a YANG model that is syntactically valid but encodes the wrong path for a NETCONF `<edit-config>` operation. Performance metrics can therefore look healthy in the short term (tests pass, pipeline is green) while technical debt accumulates in the form of difficult-to-detect network configuration errors. Invest in integration tests against real or realistic NSO/device environments rather than relying on unit tests alone.

---

### A — Activity

**Definition:** The volume of engineering actions taken — code written, commits made, reviews completed, documentation updated. Activity metrics are useful as supporting context but have no meaning in isolation.

**O&A-specific indicators:**

| Indicator | Description | Collection Method |
|---|---|---|
| PRs merged per sprint | Total PRs merged, per team member, per sprint | GitHub API |
| Commits per team member per week | Raw commit volume | GitHub API |
| AI code acceptance rate | Copilot suggestions accepted / total suggestions shown | GitHub Copilot telemetry dashboard |
| YANG files authored or modified | Count of YANG model files touched per sprint | Git diff, file-type filter |
| Test files created or extended | Count of new or modified test files per sprint | Git diff, path filter (tests/, molecule/) |
| Automation scripts deployed | Count of Ansible roles, NSO packages, Nornir scripts deployed to staging/production | CI/CD deployment log |

---

> ### ⚠️ CRITICAL WARNING: Activity Metrics Must Never Stand Alone
>
> The Forsgren et al. (2021) paper is unambiguous: **Activity metrics, presented in isolation, are not a measure of developer productivity.** They are a measure of how busy developers are.
>
> A team can simultaneously:
> - Increase AI code acceptance rate (**A ↑**)
> - Increase PR merge volume (**A ↑**)
> - Increase bug escape rate (**P ↓**)
> - Decrease developer satisfaction (**S ↓**)
> - Decrease documentation quality (**C ↓**)
>
> If the O&A team reports AI adoption progress using Activity metrics alone, leadership will believe adoption is succeeding while the team is accumulating technical debt and burning out.
>
> **Rule:** Every Activity metric shown in a report or dashboard must be accompanied by at least one Performance metric and one Satisfaction metric on the same slide or view. This is not optional.

---

### C — Communication & Collaboration

**Definition:** How effectively people work together, share knowledge, and reduce friction at handoff points. In engineering teams, this includes code review quality, documentation practices, cross-team knowledge sharing, and how efficiently new team members are brought up to speed.

Collaboration quality is particularly important for AI adoption because AI tools can either accelerate knowledge sharing (AI-generated documentation, automated PR summaries, shared prompt libraries) or inhibit it (team members stop writing clear commit messages because "AI will explain it", documentation is never written because "AI can generate it on demand").

**O&A-specific indicators:**

| Indicator | Description | Collection Method |
|---|---|---|
| PR review cycle time | Median time from PR opened to first substantive review comment | GitHub PR analytics |
| Review comment quality (signal-to-noise) | Ratio of actionable review comments to total comments (filtering out style nitpicks) | Manual audit quarterly; optional: PR comment sentiment tagging |
| Documentation contribution rate | % of PRs that include a documentation update (README, YANG model description, runbook) when relevant | GitHub PR checklist compliance |
| Shared prompt template contribution rate | Number of new or updated prompts committed to the team prompt library per sprint | Git history on `prompts/` directory |
| Cross-squad knowledge sharing events | Brown bags, show-and-tells, or written retrospectives shared with the wider team per quarter | Engineering calendar + Confluence/wiki page count |
| Onboarding time for new team members | Time from day 1 to first merged PR and first AI-assisted task, for each new hire | Onboarding tracking log |

**Collection sources:** GitHub PR analytics (review time, comment count), documentation site contribution history, prompt library Git history, onboarding tracking log maintained by Engineering Manager.

**AI opportunity:** This is where AI tooling has some of the highest-leverage opportunities for the O&A team with the lowest risk of quality degradation:

- **AI-generated PR summaries** (Copilot PR summary feature, or custom prompt): reduces time reviewers spend understanding a change, improves review quality.
- **AI-assisted documentation:** Copilot can draft YANG model descriptions, Ansible role READMEs, and NSO package documentation from code context, which team members then review and refine. This changes documentation from a painful afterthought to a fast iteration task.
- **AI-generated onboarding guides:** A well-prompted AI can convert a new team member's questions into a drafted FAQ or runbook entry, reducing the time senior team members spend on repetitive explanations.
- **Prompt library curation:** The team's shared prompt library (for NETCONF query generation, YANG model authoring, Ansible playbook scaffolding) is a collaboration artefact — it encodes team knowledge and reduces the variance in AI usage quality across team members.

---

### E — Efficiency & Flow

**Definition:** The ability to complete work with minimal waste, interruption, and context-switching. Flow state — the condition of deep, uninterrupted focus described by Mihaly Csikszentmihalyi — is associated with higher output quality, greater satisfaction, and faster task completion. Anything that fragments attention or forces team members to switch contexts unnecessarily is an efficiency risk.

In the O&A context, flow is threatened by: excessive meeting load, interrupt-driven on-call rotations, poorly managed WIP, and — critically — the friction cost of AI tooling itself, which can introduce context-switching through constant prompt iteration and output verification loops.

**O&A-specific indicators:**

| Indicator | Description | Collection Method |
|---|---|---|
| Unplanned work ratio | % of sprint capacity consumed by unplanned tasks (incidents, urgent requests, blocking questions) | Sprint tracking system (Jira, Linear) |
| Context-switch frequency | Self-reported: "How many times did you have to switch context between unrelated tasks today?" | Weekly self-report template |
| WIP per team member | Number of active in-progress tickets per team member at any point during the sprint | Sprint board snapshot (weekly) |
| Time in meetings vs. deep work | Hours per week in synchronous meetings vs. available for asynchronous deep work (self-reported) | Weekly self-report template |
| AI prompt iteration time | Time spent iterating prompts to get a usable output (self-reported) | Periodic sampling — not every sprint |
| Pipeline wait time | Median time an team member spends waiting for CI/CD feedback after a push | CI/CD timing data; pipeline stage durations |

**Collection sources:** Sprint tracking system for unplanned work ratio and WIP; self-reporting template for context-switch and meeting time; CI/CD pipeline for wait time.

**AI opportunity:** AI tools reduce efficiency costs by handling boilerplate that previously required manual cognitive effort:

- Generating YANG model boilerplate from a brief description
- Scaffolding Ansible roles with standard directory structure and default variable patterns
- Drafting NETCONF RPC calls from a natural language description of the operation
- Summarising long incident histories before an team member joins a bridge call

Each of these use cases removes a "gear-shift" that previously required the team member to break focus, look something up, or wait for a colleague to respond.

**AI risk:** Conversely, poor AI workflow integration creates new efficiency costs. An team member who has to craft a prompt, evaluate output, re-prompt, evaluate again, and finally hand-edit the result may spend more time than they would have spent writing the original code. Watch the AI prompt iteration time indicator during the first three months of adoption — if it is high, the team needs better prompt templates, not more AI tools.

---

## Combining the Five Dimensions: Quarterly Productivity Report

The SPACE framework is not useful if each dimension is reported separately in different documents or meetings. The power of the framework is in seeing all five dimensions together, at the same time, so that tradeoffs and imbalances are visible.

### Quarterly Report Structure

```
O&A QUARTERLY PRODUCTIVITY REPORT
Quarter: [Q? YYYY]     Team Size: [N team members]

─────────────────────────────────────────────────────────────────
SECTION 1: SPACE RADAR SUMMARY
─────────────────────────────────────────────────────────────────
[Radar chart — see visualisation guidance below]

Dimension scores (0–5 scale, 5 = excellent):
  S — Satisfaction & Well-being:  [score]  (trend vs last quarter: ↑ / ↓ / →)
  P — Performance:                [score]  (trend: ↑ / ↓ / →)
  A — Activity:                   [score]  (trend: ↑ / ↓ / →)
  C — Communication:              [score]  (trend: ↑ / ↓ / →)
  E — Efficiency & Flow:          [score]  (trend: ↑ / ↓ / →)

Notable dimension divergences (any pair where one is ↑ and the other ↓):
  [e.g., Activity ↑ + Performance ↓ = quality risk; investigate]

─────────────────────────────────────────────────────────────────
SECTION 2: DIMENSION DETAIL
─────────────────────────────────────────────────────────────────

S — SATISFACTION & WELL-BEING
  eNPS AI tooling score:          [0–10]   Target: ≥7
  Flow state sessions/week:       [avg]    Target: ≥3
  Overtime rate:                  [hrs]    Target: <2hrs/week
  Retro friction report (Q5):     [themes from free-text]
  Narrative: [2–3 sentences]

P — PERFORMANCE
  Bug escape rate:                [%]      Target: <[baseline × 0.8]
  AI-assisted PR rework rate:     [%]      Target: <10%
  YANG defect rate:               [n/100 lines] Target: <[baseline]
  Config error rate post-deploy:  [n/deploy]    Target: <[baseline]
  Narrative: [2–3 sentences]

A — ACTIVITY
  ⚠️  Shown alongside P and S — not interpreted in isolation.
  PRs merged/team member/sprint:     [n]
  AI acceptance rate:             [%]
  YANG files modified/sprint:     [n]
  Test files created/sprint:      [n]
  Narrative: [Note any A↑/P↓ divergence]

C — COMMUNICATION & COLLABORATION
  PR review cycle time:           [hrs]    Target: <24hrs
  Documentation contribution:     [%PRs]   Target: >70%
  Prompt library contributions:   [n]      Target: ≥2/sprint/squad
  Onboarding time (if applicable):[days]   Target: <10 days to first merge
  Narrative: [2–3 sentences]

E — EFFICIENCY & FLOW
  Unplanned work ratio:           [%]      Target: <20% of sprint capacity
  WIP per team member (avg):         [n]      Target: ≤3
  Pipeline wait time (median):    [mins]   Target: <15 mins
  Meeting load (hrs/week):        [hrs]    Target: <8hrs/week
  Narrative: [2–3 sentences]

─────────────────────────────────────────────────────────────────
SECTION 3: AI ADOPTION CONTEXT
─────────────────────────────────────────────────────────────────
(Link to AI KPI dashboard — see ai-adoption-kpis.md)

Key AI signals this quarter:
  Weekly active AI tool rate:     [%]
  Agentic completion rate:        [%]
  Human-in-the-loop rate:         [%]
  Prompt reuse rate:              [%]

Do AI KPI trends align with SPACE signals?
  [Y/N + narrative. E.g.: "High acceptance rate (A) but rework
   rate rising (P) — team members accepting AI output without
   sufficient review. Recommended action: add AI-assisted
   PR review checklist."]

─────────────────────────────────────────────────────────────────
SECTION 4: ACTIONS AND OWNERS
─────────────────────────────────────────────────────────────────
Action                     | Dimension | Owner | Due
─────────────────────────────────────────────────────────────────
                           |           |       |
                           |           |       |
```

---

## Radar Chart Recommendation

Visualising all five SPACE dimensions as a radar chart (spider/web chart) is strongly recommended for quarterly reporting. The visual format makes dimension imbalances immediately apparent and is resistant to single-dimension gaming — it is very hard to make a radar chart "look good" when one dimension is collapsing.

**Scoring guidance (0–5 scale):**

| Score | Meaning |
|---|---|
| 5 | Excellent — dimension is healthy, trending positively, no concerns |
| 4 | Good — minor issues present but not systemic |
| 3 | Moderate — one or more indicators are concerning; action being taken |
| 2 | Poor — multiple indicators degraded; active intervention required |
| 1 | Critical — dimension is a team health risk; escalate |
| 0 | Untracked — dimension is not yet being measured (time-bound, not permanent) |

**Tool options:** Excalidraw (embedded in Confluence), Python matplotlib/plotly (generate from quarterly data script), or any charting tool that supports radar/spider charts. The chart should be generated from the metric data — do not score it subjectively.

**What to look for in the radar shape:**

- **Balanced pentagon:** All dimensions roughly equal. Healthy — check whether scores are all high (excellent) or all middling (systemic issue).
- **Spike in A, dip in P/S:** Classic AI adoption warning sign. Activity is inflating from AI tools; quality and satisfaction are suffering.
- **Dip in E, dip in S:** Burnout risk. Efficiency problems (too many interruptions, high WIP) are eroding well-being.
- **Dip in C alone:** Collaboration bottleneck. Review cycle time or documentation quality may be degraded. Often caused by team growth outpacing communication practices.

---

*This document is part of the O&A AI-Agentic Adoption Journey framework. Primary source: Forsgren, Storey, Maddila, Zimmermann, Houck & Butler, "The SPACE of Developer Productivity," ACM Queue Vol. 19 No. 1 (2021). Available at https://queue.acm.org/detail.cfm?id=3454124.*
