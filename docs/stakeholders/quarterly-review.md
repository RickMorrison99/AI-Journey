# Quarterly Review — Engineering Team Format

> **Usage note:** This is the internal working document for the O&A team's quarterly AI adoption review meeting. It is **Floor 2–3 of the Architect Elevator** — the evidence layer that feeds the Executive Summary (`executive-summary.md`). It should be completed collaboratively by the Engineering Manager, AI Champion, and Tech Leads in the week before the review meeting, and then worked through as a team in a 90–120 minute quarterly retrospective.
>
> It is intentionally more granular and candid than the Executive Summary. Things that appear as a single bullet in the exec summary may fill an entire section here. That is correct — this is where the engineering team does the honest accounting.
>
> Sections marked **[FILL IN]** require data from the measurement cycle. Narrative guidance is provided in *italics*.

---

## Meeting Logistics

```
O&A Team — Quarterly AI Adoption Review
========================================
Quarter:       Q[X] [YEAR]
Meeting date:  [DD Month YYYY]
Duration:      90–120 minutes
Facilitator:   [AI Champion name]
Scribe:        [Name]
Attendees:     [Engineering Manager], [Tech Leads], [AI Champion], [all O&A team members — encouraged]
Pre-read:      Complete Sections 1–10 before the meeting. Section 11 is completed together.
```

---

## Section 1: Retrospective on Last Quarter's Goals

*Look back before looking forward. Take each of last quarter's top 3 goals and assess it honestly. The purpose is not to celebrate wins or assign blame — it is to learn what our prediction accuracy is, so we can make better commitments next quarter.*

*Guidance: Pull last quarter's Section 11 from the previous Quarterly Review document. Copy the three goals here and assess each one.*

### Goal 1: [FILL IN — copy from last quarter's Section 11]

- **Target:** [What we said we would achieve, with the specific success metric]
- **Outcome:** ✅ Achieved / ⚠️ Partially Achieved / ❌ Not Achieved
- **Evidence:** [FILL IN — what data do we have? Metric before/after]
- **What drove the outcome:** [FILL IN — what worked? What got in the way?]
- **What we are carrying forward:** [FILL IN — any incomplete work, or a refined version of this goal for next quarter?]

### Goal 2: [FILL IN]

- **Target:** [FILL IN]
- **Outcome:** ✅ / ⚠️ / ❌
- **Evidence:** [FILL IN]
- **What drove the outcome:** [FILL IN]
- **What we are carrying forward:** [FILL IN]

### Goal 3: [FILL IN]

- **Target:** [FILL IN]
- **Outcome:** ✅ / ⚠️ / ❌
- **Evidence:** [FILL IN]
- **What drove the outcome:** [FILL IN]
- **What we are carrying forward:** [FILL IN]

**Goal achievement summary:**

| Goals achieved | Goals partially achieved | Goals not achieved | Prediction accuracy |
|---|---|---|---|
| [N] / 3 | [N] / 3 | [N] / 3 | [X]% |

*Guidance: If prediction accuracy is consistently below 67% (2 of 3 goals), discuss why — are goals too ambitious? Are there systemic blockers? Is the measurement cadence right? This is a useful calibration signal.*

---

## Section 2: DORA 4-Up

*The DORA four key metrics (Forsgren, Humble, Kim — "Accelerate", 2018) are the primary delivery health signal for the team. Track them at the sprint level where possible; aggregate to quarterly for reporting. The goal is not to hit a number — it is to understand the trend and what is driving it.*

### Current Band and Trend

| Metric | Q-2 | Q-1 | This Quarter | Band | Quarter Trend | Annual Trend |
|---|---|---|---|---|---|---|
| Deployment Frequency | [FILL IN] | [FILL IN] | [FILL IN] | Low/Med/High/Elite | ↑ ↓ → | ↑ ↓ → |
| Lead Time for Changes | [FILL IN] | [FILL IN] | [FILL IN] | Low/Med/High/Elite | ↑ ↓ → | ↑ ↓ → |
| MTTR | [FILL IN] | [FILL IN] | [FILL IN] | Low/Med/High/Elite | ↑ ↓ → | ↑ ↓ → |
| Change Failure Rate | [FILL IN] | [FILL IN] | [FILL IN] | Low/Med/High/Elite | ↑ ↓ → | ↑ ↓ → |

*Band definitions (DORA State of DevOps 2023): Elite — deploys on demand, lead time < 1 hour, MTTR < 1 hour, CFR < 5%. High — deploys weekly–monthly, lead time < 1 day, MTTR < 1 day, CFR 5–10%. Medium — deploys weekly–monthly, lead time 1 day–1 week, MTTR < 1 week, CFR 10–15%. Low — deploys monthly or less, lead time > 1 week, MTTR > 1 week, CFR > 15%.*

### Sprint-Level Trend Chart

*[Insert sprint-level DORA trend chart here — generated from your pipeline/deployment telemetry. A simple table of weekly or sprint-by-sprint values is acceptable if chart tooling is not available.]*

| Sprint | Deployment Freq | Lead Time | MTTR | CFR | Notes |
|---|---|---|---|---|---|
| Sprint [N-5] | | | | | |
| Sprint [N-4] | | | | | |
| Sprint [N-3] | | | | | |
| Sprint [N-2] | | | | | |
| Sprint [N-1] | | | | | |
| Sprint [N] | | | | | |

### What Drove the Change (or Lack of Change)?

*Guidance: DORA metrics do not change themselves. Something drove the movement (or the stagnation). Be specific. Attribution to AI adoption should be argued, not assumed — what is the evidence that AI was the cause, rather than a coincident change in team size, deployment process, or incident response?*

- **Lead time:** [FILL IN — e.g., "Reduction driven by YANG stub automation (confirmed in team survey: 11/18 team members cited it); partially offset by 2-week CI infrastructure outage in Sprint 9"]
- **Change failure rate:** [FILL IN]
- **Deployment frequency:** [FILL IN]
- **MTTR:** [FILL IN]

### DORA Narrative for Section 2 of Executive Summary

*Draft the 2-sentence DORA narrative here, then copy it into the executive-summary.md:*

> "[FILL IN]"

---

## Section 3: SPACE Radar

*SPACE (Forsgren et al., 2021) captures developer experience across five dimensions. Run the SPACE survey at the end of each sprint (short-form, 3–5 questions) and aggregate to quarterly. The radar chart shows all five dimensions simultaneously — a shape that is growing in all directions indicates healthy adoption. A shape that is large on Activity but small on Satisfaction is a warning sign: the team is doing more but enjoying it less.*

### Quarterly SPACE Scores

| Dimension | Q-1 Score | Q Score | Change | Sprint High | Sprint Low |
|---|---|---|---|---|---|
| Satisfaction & Wellbeing (S) | [X]/5.0 | [X]/5.0 | ↑ ↓ → | Sprint [N] ([X]) | Sprint [N] ([X]) |
| Performance (P) | [X]/5.0 | [X]/5.0 | ↑ ↓ → | | |
| Activity (A) | [X]/5.0 | [X]/5.0 | ↑ ↓ → | | |
| Communication & Collaboration (C) | [X]/5.0 | [X]/5.0 | ↑ ↓ → | | |
| Efficiency & Flow (E) | [X]/5.0 | [X]/5.0 | ↑ ↓ → | | |

*[Insert SPACE radar chart here — generated from survey data. If chart tooling is unavailable, the table above is sufficient for the team meeting; the executive summary uses a simplified version.]*

### What Changed and What the Data Is Telling Us

*Guidance: Look for divergence between dimensions. If Satisfaction is high but Efficiency is low, team members like using AI tools but they are not actually saving time — investigate. If Activity is high but Performance is low, the team is doing more AI-assisted work but quality is not improving — investigate the rework rate.*

- **Satisfaction & Wellbeing (S):** [FILL IN — what is the team saying about AI tools? Is enthusiasm growing, stable, or declining?]
- **Performance (P):** [FILL IN — are defect rates, rework rates, and review quality moving in the right direction?]
- **Activity (A):** [FILL IN — is AI tool usage increasing? Are the right team members (not just the enthusiasts) using the tools?]
- **Communication & Collaboration (C):** [FILL IN — is AI adoption affecting how the team reviews code? Are there new norms around AI-generated content?]
- **Efficiency & Flow (E):** [FILL IN — are team members reporting that AI reduces cognitive load? Or that it adds overhead (prompt management, suggestion review, context switching)?]

### Key Insight from SPACE This Quarter

> "[FILL IN — the single most important thing the SPACE data is telling us about AI adoption this quarter. One to two sentences.]"

---

## Section 4: AI Adoption Stage Review

*The AI-Agentic Adoption Journey has five stages: 1 — Aware, 2 — Experimenting, 3 — Practicing, 4 — Scaling, 5 — Optimising. At the start of the quarter, the team set an expectation for which stage it would be in by quarter end. This section assesses whether that expectation was met and what the evidence is.*

### Stage Assessment

| Question | Answer |
|---|---|
| Stage we expected to be in at quarter end | Stage [X]: [Name] |
| Stage we are actually in at quarter end | Stage [X]: [Name] |
| Did we advance? | Yes / No / Partially |

### Evidence for Current Stage

*Guidance: Stage claims must be evidenced. "We think we are in Stage 3" is not sufficient. What specific behaviours and metrics demonstrate Stage 3 adoption? Below are example evidence types for each stage — select the ones relevant to your current stage and fill in the data.*

| Stage 3 Evidence Type (example) | Target | Actual | Met? |
|---|---|---|---|
| % of team members using prompt library weekly | ≥ 80% | [FILL IN]% | ✅ / ❌ |
| AI-aware PR review standard in Definition of Done | Yes | [FILL IN] | ✅ / ❌ |
| Jagged frontier map updated this quarter | Yes | [FILL IN] | ✅ / ❌ |
| At least 1 AI Champion running prompt surgery sessions | Yes | [FILL IN] | ✅ / ❌ |
| DORA lead time improving (not regressing) | Improving | [FILL IN] | ✅ / ❌ |

*Replace with the evidence criteria for your actual current and target stage.*

### Blockers to Stage Advancement

*[FILL IN — what is preventing or slowing progress to the next stage? Be specific. Is it tooling? Process? Culture? Resourcing? A specific technical challenge (e.g., the YANG `must` expression limitation)?]*

---

## Section 5: Responsible AI Audit

*Go through each of the five dimensions in turn. This is the working audit — more detailed than the traffic light table in the executive summary. The purpose is to surface near-misses, emerging risks, and areas where the current approach needs to be revisited.*

*Guidance: "Near-miss" means something that could have been a compliance issue but was caught. Near-misses are valuable signals — they tell you where the guardrails are being tested. Record them here even if they were caught.*

### Privacy

- **Current status:** 🟢 Compliant / 🟡 In Progress / 🔴 Gap
- **Controls in place:** [FILL IN — data classification policy, prompt review process, DPA status]
- **Evidence of compliance:** [FILL IN — e.g., "Zero incidents in SPACE privacy confidence question: 4.2/5.0"]
- **Near-misses this quarter:** [FILL IN — e.g., "One team member inadvertently included a device hostname in a prompt; caught by peer in PR review; no data exfiltrated; playbook updated"]
- **Gaps or concerns:** [FILL IN]
- **Actions for next quarter:** [FILL IN]

### Security

- **Current status:** 🟢 / 🟡 / 🔴
- **Controls in place:** [FILL IN — SAST gate status, code review standard for AI-generated code, supply chain ADR]
- **Evidence of compliance:** [FILL IN — e.g., "SAST pass rate: 98.9% on AI-assisted PRs vs. 98.4% on manual PRs"]
- **Near-misses this quarter:** [FILL IN]
- **Gaps or concerns:** [FILL IN]
- **Actions for next quarter:** [FILL IN]

### Environmental (SCI)

- **Current status:** 🟢 / 🟡 / 🔴
- **SCI baseline:** [FILL IN] gCO₂e per team member per sprint *(established: [Quarter/Year])*
- **This quarter's SCI:** [FILL IN] gCO₂e per team member per sprint
- **Quarter-on-quarter trend:** Improving / Flat / Worsening / Baseline only (first measurement)
- **Model sizing guide adoption:** [FILL IN]% of team members following it (measured via survey)
- **Large model invocations this quarter:** [FILL IN] (from API telemetry or manual log review)
- **Gaps or concerns:** [FILL IN — e.g., "SCI measurement is still manual; risk of deprioritisation under delivery pressure"]
- **Actions for next quarter:** [FILL IN]

### Market Concentration

- **Current status:** 🟢 / 🟡 / 🔴
- **Primary vendor:** [FILL IN — vendor name, tool]
- **Concentration level:** [FILL IN]% of AI-assisted workflows running on primary vendor
- **OSS/alternative fallbacks active:** [FILL IN — list tools and what they cover]
- **Dependency map:** [FILL IN — which critical workflows have no fallback?]
- **Vendor risk events this quarter:** [FILL IN — any outages, pricing changes, terms changes, or security incidents at vendor?]
- **Review trigger status:** [FILL IN — what concentration level triggers a strategic review? Are we approaching it?]
- **Actions for next quarter:** [FILL IN]

### Global Transformation

- **Current status:** 🟢 / 🟡 / 🔴
- **Reskilling hours this quarter:** [FILL IN] hours per team member (target: ≥ 8)
- **Reskilling activities completed:** [FILL IN — list modules, workshops, or certifications completed]
- **Team Member sentiment on career impact (SPACE-S sub-question):** [FILL IN]/5.0
- **Retention:** [FILL IN — any departures linked to AI adoption concerns? Any hires attracted by AI programme?]
- **Skills architecture:** [FILL IN — are we building internal capability or growing dependency on AI for previously-owned skills?]
- **Actions for next quarter:** [FILL IN]

---

## Section 6: Prompt Library Health

*The prompt library is the primary vehicle for capturing and sharing AI adoption knowledge within the team. It is the difference between "individuals who are good at Copilot" and "a team with a shared AI capability." A healthy prompt library is actively used, regularly updated, and covers the team's real workflow — not just the easiest cases.*

### Inventory

| Category | Templates | Weekly Active Uses (avg.) | Last Updated | Notes |
|---|---|---|---|---|
| YANG modelling | [N] | [N] | [Date] | |
| NSO service templates | [N] | [N] | [Date] | |
| TM Forum API mapping | [N] | [N] | [Date] | |
| Test generation (pytest) | [N] | [N] | [Date] | |
| Commit messages | [N] | [N] | [Date] | |
| Code review comments | [N] | [N] | [Date] | |
| Ansible playbooks | [N] | [N] | [Date] | |
| Other | [N] | [N] | [Date] | |
| **Total** | **[N]** | **[N]** | | |

### Usage Breadth

- Team Members using the library at least once per week: **[N] / [total team members]**
- Team Members who have contributed at least one template: **[N] / [total team members]**
- Most-used template this quarter: **[FILL IN]** ([N] uses)
- Least-used template (candidate for removal or revision): **[FILL IN]**

### What Is Missing?

*Guidance: Ask the team in the review meeting: "What do you wish was in the library? What did you prompt for this quarter that wasn't covered?" Capture the top 3 gaps.*

1. [FILL IN — missing template or category]
2. [FILL IN]
3. [FILL IN]

### Negative Examples Catalogue

*Negative examples are as important as positive ones — they teach the team where not to use AI, or how not to prompt. How many do we have?*

- Negative examples in library: **[N]**
- New negative examples added this quarter: **[N]**
- Examples: [FILL IN — briefly describe the scenarios covered by negative examples]

### Prompt Library Health Score

*A simple self-assessment: score each dimension 1–5.*

| Dimension | Score | Notes |
|---|---|---|
| Coverage (does it cover our actual workflow?) | [1–5] | |
| Freshness (is it up to date with current tools and versions?) | [1–5] | |
| Usage breadth (is it used by the whole team, not just champions?) | [1–5] | |
| Negative examples (does it teach what not to do, not just what to do?) | [1–5] | |
| **Overall health** | **[avg]/5** | |

---

## Section 7: Jagged Frontier Update

*The "jagged frontier" (Mollick, 2024) describes the uneven boundary of AI capability: AI is superhuman at some tasks (boilerplate generation, syntax completion, test scaffolding) and surprisingly weak at others (complex constraint logic, novel domain reasoning, tasks requiring deep contextual understanding). Knowing where the frontier is for our specific O&A workflow is one of the most valuable forms of team knowledge we can build.*

*This section is updated quarterly based on team experience. It is a living document of what the team has learned about where AI adds value and where it does not — for this team, on these tasks, with these tools.*

### The O&A Jagged Frontier Map

*Update this map each quarter. Entries should be based on evidence from team experience, not assumption. Note the sprint or incident that generated the evidence.*

#### AI Strong Zones — Use Confidently

| Task | AI Tool | Evidence | Confidence |
|---|---|---|---|
| YANG module stub generation from schema comments | Copilot | Sprint [N]: 80 stubs generated, 94% fitness function pass rate | High |
| pytest boilerplate scaffolding for NSO service modules | Copilot | Sprint [N]: test coverage 62% → 80%, rework rate unchanged | High |
| Git commit message generation | Copilot | [Evidence] | [High/Medium] |
| [FILL IN] | [Tool] | [Evidence] | [Confidence] |

#### AI Adequate Zones — Use with Careful Review

| Task | AI Tool | Caution | Evidence |
|---|---|---|---|
| TM Forum API resource path suggestions | Copilot | Occasionally suggests non-standard paths; API contract tests catch these | Sprint [N]: [N] false paths caught by contract tests |
| NSO device template generation | Copilot | Works well for common device types; unreliable for vendor-specific extensions | [Evidence] |
| [FILL IN] | [Tool] | [Caution] | [Evidence] |

#### AI Weak Zones — Avoid or Use Only as First Draft with Expert Review

| Task | AI Tool | Why AI Struggles | Evidence | Recommended Approach |
|---|---|---|---|---|
| YANG `must` constraint logic | Copilot | Syntactically plausible suggestions that are semantically incorrect; non-obvious failures | Sprint [N]: 2 team members report slower with AI than without; 1 near-miss in PR review | Write manually; use AI only for initial shape, then expert review required |
| Complex network topology reasoning | Copilot | Lacks the operational context of the live network; suggestions can be architecturally inconsistent | [Evidence] | [Approach] |
| [FILL IN] | [Tool] | [Why] | [Evidence] | [Approach] |

### What Changed This Quarter?

*Guidance: Did any tasks move between zones? Did we discover new strong zones or new weak zones? What prompted the update?*

- **Moved from Adequate → Strong:** [FILL IN or "None this quarter"]
- **Moved from Adequate → Weak:** [FILL IN or "None this quarter"]
- **New entries added:** [FILL IN]
- **Entries removed (AI no longer used for this):** [FILL IN or "None"]

### Frontier Insight of the Quarter

> "[FILL IN — the single most surprising or valuable thing the team learned about AI capability or limitation this quarter. One to two sentences. This is the learning that most deserves to be shared across teams.]"

---

## Section 8: SCI Trend

*The Software Carbon Intensity (SCI) metric (Green Software Foundation specification) measures the carbon emissions of our AI tool usage per unit of engineering output. For the O&A team, the unit is "per team member per sprint." The goal is not zero emissions — it is a downward trend over time, demonstrating that we are making responsible choices about model size and invocation frequency.*

### SCI Data

| Quarter | SCI (gCO₂e/team member/sprint) | Measurement Method | Confidence |
|---|---|---|---|
| [Q-2] | [FILL IN or "Not measured"] | Manual / Automated | Low/Medium/High |
| [Q-1] | [FILL IN] | Manual / Automated | |
| [This quarter] | [FILL IN] | Manual / Automated | |

### SCI Trend Analysis

- **Trend:** Improving / Flat / Worsening / Baseline only (first measurement)
- **Primary driver of change (or stagnation):** [FILL IN — e.g., "Model sizing guide adoption reduced large model invocations by 30%; offset by 20% growth in overall AI usage"]
- **Biggest SCI contributor this quarter:** [FILL IN — which tool or usage pattern is generating the most emissions?]
- **Target for next quarter:** [FILL IN] gCO₂e/team member/sprint (or "establish baseline")

### SCI Actions

| Action | Owner | Target Sprint | Status |
|---|---|---|---|
| [FILL IN — e.g., "Automate SCI aggregation from Copilot API telemetry"] | [Name] | Sprint [N] | Pending / In Progress / Done |
| [FILL IN] | [Name] | Sprint [N] | |

---

## Section 9: Vendor Concentration Check

*Vendor concentration risk is the risk that the team becomes so dependent on a single AI vendor that a pricing change, terms change, availability failure, or strategic exit by that vendor would materially disrupt our engineering capability. This section performs a quarterly check.*

### Concentration Assessment

| Vendor | Tools | % of AI-Assisted Workflow | Critical Workflows Covered | Fallback Available? |
|---|---|---|---|---|
| [Primary vendor — e.g., Microsoft/GitHub] | [e.g., Copilot Business] | [FILL IN]% | [FILL IN — which workflows] | [Yes/Partial/No] |
| [Secondary vendor] | [Tools] | [FILL IN]% | [FILL IN] | [N/A] |
| OSS / Self-hosted | [Tools] | [FILL IN]% | [FILL IN] | [N/A] |

### Risk Assessment

- **Concentration level:** [FILL IN]% on primary vendor
- **Risk rating:** 🟢 Low (<50% single vendor) / 🟡 Medium (50–75%) / 🔴 High (>75%)
- **Critical path without primary vendor:** [FILL IN — if primary vendor was unavailable tomorrow, what would we not be able to do?]
- **Fallback readiness:** [FILL IN — are OSS/alternative tools installed, tested, and known to the team? Or are they on a list that no one has actually used?]

### Vendor Events This Quarter

*Document any vendor events that affected concentration risk assessment:*

- Pricing changes: [FILL IN or "None"]
- Terms of service changes: [FILL IN or "None"]
- Availability incidents: [FILL IN or "None"]
- Security or privacy incidents at vendor: [FILL IN or "None"]
- Competitive landscape changes: [FILL IN or "None"]

### Concentration Actions

*If risk rating is 🟡 or 🔴, what are we doing about it?*

| Action | Owner | Target Quarter | Trigger |
|---|---|---|---|
| [FILL IN — e.g., "Complete OSS fallback readiness drill: run full sprint with no Copilot access"] | [Name] | Q[X] | Concentration exceeds 80% |
| [FILL IN] | [Name] | Q[X] | |

---

## Section 10: Team Voice

*This section surfaces representative quotes from the SPACE Satisfaction & Wellbeing survey's free-text questions. All quotes are anonymous. The purpose is to make sure the team's actual experience — including discomfort, frustration, and enthusiasm — is heard at the review meeting, not just the aggregated scores.*

*Guidance: The AI Champion or Engineering Manager selects 6–10 representative quotes before the meeting. "Representative" means a spread: not just the positive ones. If 3 team members are frustrated and 15 are enthusiastic, show 2–3 frustration quotes and 4–5 enthusiasm quotes. Editing for anonymity (removing names, project references) is permitted; editing for sentiment is not.*

### This Quarter's Quotes

*[FILL IN — paste anonymised free-text responses from SPACE-S survey here. Aim for 6–10 quotes, covering the range of experience.]*

**Positive or energised:**
> "[FILL IN — quote from a survey response expressing enthusiasm, relief, or appreciation for AI tools]"

> "[FILL IN]"

> "[FILL IN]"

**Neutral or uncertain:**
> "[FILL IN — quote expressing uncertainty about AI's value, or a wait-and-see attitude]"

> "[FILL IN]"

**Concerned or fatigued:**
> "[FILL IN — quote expressing frustration, concern about tool quality, or AI-related fatigue]"

> "[FILL IN]"

### What the Team Voice Is Telling Us

*Guidance: After reading the quotes as a group in the review meeting, discuss: What is the dominant emotional register? Is it changing? Is there a specific concern appearing repeatedly? Is there a specific source of energy the team wants more of?*

- **Dominant theme:** [FILL IN — one sentence summary of the overall team voice this quarter]
- **Biggest concern expressed:** [FILL IN — the most frequent or most serious concern in the free text]
- **Biggest source of energy:** [FILL IN — what is the team most enthusiastic about?]
- **Any signal that requires a direct response?** [FILL IN — if a concern is serious enough that the team needs to know it has been heard and acted on, note it here and track it in Section 11]

---

## Section 11: Next Quarter Goals

*This section is completed together in the review meeting. Take what you have learned in Sections 1–10 and translate it into three concrete goals for the next quarter. Each goal must have an owner, a success metric, a deadline, and a connection to the adoption journey (stage milestone, responsible AI gate, or DORA/SPACE improvement).*

*Guidance: Three goals. Not five, not seven. Three. If you have more than three things that feel equally important, apply the following test: which three, if achieved, would most advance the team's AI adoption journey? Which three would you be most confident explaining to the Head of Engineering in next quarter's review?*

### Goal 1

- **Title:** [FILL IN — short, memorable name for this goal]
- **Description:** [FILL IN — 2–3 sentences describing what we will do and why]
- **Owner:** [FILL IN — single named person; not "the team"]
- **Success metric:** [FILL IN — specific, measurable, with a target value: e.g., "≥ 80% of team members using prompt library weekly, measured by Confluence analytics"]
- **Connection to adoption journey:**
  - Stage milestone: [FILL IN or N/A]
  - Responsible AI gate: [FILL IN or N/A]
  - DORA target: [FILL IN or N/A]
  - SPACE target: [FILL IN or N/A]
- **Key risks:** [FILL IN — what could prevent us from achieving this goal? What is the mitigation?]
- **Review checkpoint:** Sprint [N] (mid-quarter) — at this point we expect to see [FILL IN interim evidence]

### Goal 2

- **Title:** [FILL IN]
- **Description:** [FILL IN]
- **Owner:** [FILL IN]
- **Success metric:** [FILL IN]
- **Connection to adoption journey:**
  - Stage milestone: [FILL IN or N/A]
  - Responsible AI gate: [FILL IN or N/A]
  - DORA target: [FILL IN or N/A]
  - SPACE target: [FILL IN or N/A]
- **Key risks:** [FILL IN]
- **Review checkpoint:** Sprint [N] — [FILL IN]

### Goal 3

- **Title:** [FILL IN]
- **Description:** [FILL IN]
- **Owner:** [FILL IN]
- **Success metric:** [FILL IN]
- **Connection to adoption journey:**
  - Stage milestone: [FILL IN or N/A]
  - Responsible AI gate: [FILL IN or N/A]
  - DORA target: [FILL IN or N/A]
  - SPACE target: [FILL IN or N/A]
- **Key risks:** [FILL IN]
- **Review checkpoint:** Sprint [N] — [FILL IN]

### Goal Summary Card

*Extract and post this card to the team's Confluence space and sprint board after the meeting.*

```
O&A AI Adoption — Q[X+1] [YEAR] Goals
======================================
Goal 1: [Title] — Owner: [Name] — Metric: [FILL IN]
Goal 2: [Title] — Owner: [Name] — Metric: [FILL IN]
Goal 3: [Title] — Owner: [Name] — Metric: [FILL IN]
```

---

## Meeting Facilitation Notes

*For the AI Champion or Engineering Manager running the quarterly review meeting.*

### Suggested Agenda (90 minutes)

| Time | Section | Facilitator note |
|---|---|---|
| 0:00–0:10 | Opening | Recall last quarter's goals (Section 1). Read them aloud. Don't rush to judgement — just recall what we said we'd do. |
| 0:10–0:25 | DORA 4-up (Section 2) | Walk through the trend table. Ask: "What do we think drove this? Is there anything surprising?" Don't just report numbers — discuss causation. |
| 0:25–0:40 | SPACE Radar (Section 3) | Show the radar. Ask: "Which dimension feels most accurate to your experience? Which feels least accurate?" The discussion is as important as the scores. |
| 0:40–0:55 | Jagged Frontier (Section 7) + Team Voice (Section 10) | Read the team voice quotes aloud before discussing the frontier. The quotes give context for why certain zones are weak or strong. |
| 0:55–1:10 | Responsible AI Audit (Section 5) + Vendor Check (Section 9) | Keep this brisk — highlight the reds and ambers, confirm the greens, surface near-misses. Don't spend time on what is working fine. |
| 1:10–1:30 | Next Quarter Goals (Section 11) | This is the most important 20 minutes. Come in with two or three candidate goals. Debate, refine, and commit. Close with the Goal Summary Card. |

### Facilitation Principles

1. **Separate facts from interpretations.** When presenting DORA or SPACE data, first state the fact ("lead time went from 6.4 to 4.9 days"), then invite interpretation ("what drove this?"). Don't conflate the two.

2. **Protect the team voice section.** The anonymous quotes in Section 10 must be read without editorialising. Resist the urge to explain or defend them. Just read them. Let them land. Then discuss.

3. **The lessons are as important as the wins.** If the meeting spends 20 minutes on wins and 2 minutes on lessons, it has failed its purpose. Aim for rough parity.

4. **Goals must be committed, not listed.** A goal is not a goal until it has an owner, a metric, and a date. "We should improve SCI tracking" is a wish. "Sanjay will have automated SCI reporting in place by Sprint 2, confirmed by first automated measurement" is a goal.

5. **The AI Champion's job is to keep the meeting honest.** If the team is avoiding a difficult finding, the AI Champion names it. If the goals are too vague, the AI Champion pushes back. The quarterly review is only valuable if it surfaces reality.

---

*Connected documents: `executive-summary.md` (penthouse output derived from this document), `architect-elevator.md` (communication framework)*
*Measurement backbone: DORA (Forsgren, Humble, Kim — "Accelerate", 2018) + SPACE (Forsgren et al., 2021)*
*Responsible AI framework: Privacy · Security · Environmental (SCI) · Market Concentration · Global Transformation*
*SCI specification: Green Software Foundation — Software Carbon Intensity Specification v1.0*
