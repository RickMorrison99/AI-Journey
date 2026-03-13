# Executive Summary Template — Quarterly AI Adoption Report

> **Usage note:** This template is completed by the Engineering Manager or Head of Engineering at the end of each quarter. It is the **Floor 5 output** of the Architect Elevator — the penthouse version of a body of evidence that includes the full Quarterly Review (`quarterly-review.md`). Keep it to one to two pages when printed. Executives should be able to read it in under five minutes. Every claim must be traceable to a metric.
>
> Sections marked **[FILL IN]** require data from the current quarter's measurement cycle. Narrative guidance is provided in *italics* beneath each section.

---

## Template

---

```
O&A Team AI-Agentic Adoption — Quarterly Report
================================================
Quarter:     Q[X] [YEAR]
Prepared by: [Name], [Role]
Team:        OSS - Orchestration and Automation — [N] team members
Report date: [DD Month YYYY]
Reviewers:   [Engineering Manager], [Head of Engineering / CTO]
```

---

### Section 1: Adoption Stage

**Current stage:** Stage **[X]** — **[Stage Name]**

> "The O&A team is currently in **Stage [X]: [Stage Name]** of the AI-Agentic Adoption Journey, having advanced from Stage [X-1] during this quarter."

*Guidance: The adoption stages are: 1 — Aware, 2 — Experimenting, 3 — Practicing, 4 — Scaling, 5 — Optimising. Be honest. If the team has not advanced, say so and explain why. Stage stagnation is not a failure — it is an honest signal that more investment or a different approach is needed.*

---

### Section 2: DORA Performance

*DORA (Forsgren, Humble, Kim — "Accelerate", 2018) is the primary delivery health signal. These four metrics are the headline evidence for whether AI adoption is improving engineering performance at a systems level. Band definitions: Elite / High / Medium / Low as per the DORA State of DevOps report.*

| Metric | Last Quarter | This Quarter | Band | Trend |
|---|---|---|---|---|
| Deployment Frequency | [FILL IN] | [FILL IN] | Low / Medium / High / Elite | ↑ ↓ → |
| Lead Time for Changes | [FILL IN] | [FILL IN] | Low / Medium / High / Elite | ↑ ↓ → |
| MTTR (Mean Time to Restore) | [FILL IN] | [FILL IN] | Low / Medium / High / Elite | ↑ ↓ → |
| Change Failure Rate | [FILL IN] | [FILL IN] | Low / Medium / High / Elite | ↑ ↓ → |

**Narrative (2 sentences):**
> "AI-assisted [test generation / code review / YANG stub generation — specify what drove improvement] contributed to a **[X]%** reduction in lead time for changes this quarter. Change failure rate **[improved / held steady / increased]** at **[X]%**, indicating that AI adoption is **[not introducing / reducing / marginally increasing]** production risk."

*Guidance on honesty: Do not cherry-pick. If MTTR worsened, say so and explain it. Executives who receive only good news lose trust in the report. The goal is to be the team that gives accurate signals, not the team that protects its metrics.*

---

### Section 3: Team Health (SPACE)

*SPACE (Forsgren et al., 2021) captures developer experience across five dimensions: Satisfaction & Wellbeing, Performance, Activity, Communication & Collaboration, Efficiency & Flow. These are not productivity metrics — they are signals of sustainable engineering capability. A team with declining SPACE scores is a team heading toward burnout or attrition, regardless of what DORA shows this quarter.*

**SPACE Radar Summary** *(actual chart generated from quarterly SPACE survey data — see `quarterly-review.md` for full radar)*

| Dimension | Last Quarter | This Quarter | Change |
|---|---|---|---|
| Satisfaction & Wellbeing (S) | [X]/5.0 | [X]/5.0 | ↑ ↓ → |
| Performance (P) | [X]/5.0 | [X]/5.0 | ↑ ↓ → |
| Activity (A) | [X]/5.0 | [X]/5.0 | ↑ ↓ → |
| Communication & Collaboration (C) | [X]/5.0 | [X]/5.0 | ↑ ↓ → |
| Efficiency & Flow (E) | [X]/5.0 | [X]/5.0 | ↑ ↓ → |

**Narrative (2 sentences):**
> "Developer satisfaction with AI tools is **[score]/5.0**, **[above / at / below]** our target of 3.5. Efficiency and Flow scores indicate that cognitive load **[is being reduced / is holding steady / is increasing]** as AI adoption matures — **[specific example: e.g., YANG stub scaffolding now takes 20 minutes rather than 90 minutes]**."

*Guidance: SPACE-S (Satisfaction) is the leading indicator of retention and sustainable pace. If it is below 3.5 and declining, flag it explicitly — this is a risk signal the CTO needs to know about, even if DORA looks fine.*

---

### Section 4: Responsible AI Status

*The O&A team operates a five-dimension responsible AI framework. Each dimension is assessed quarterly. Status colours: 🟢 Compliant — all controls in place and evidenced; 🟡 In Progress — gap identified, remediation underway with a defined timeline; 🔴 Gap — material gap with no current remediation plan, requires executive attention.*

| Dimension | Status | Notes |
|---|---|---|
| Privacy | 🟢 / 🟡 / 🔴 | [FILL IN: e.g., "Data classification policy in place; zero incidents this quarter; DPA with vendor reviewed"] |
| Security | 🟢 / 🟡 / 🔴 | [FILL IN: e.g., "SAST gates on 100% of PRs; AI supply chain risk on risk register; residual risk: low"] |
| Environmental (SCI) | 🟢 / 🟡 / 🔴 | Estimated **[X] gCO₂e** per team member per sprint (baseline / improving / worsening — circle one) |
| Market Concentration | 🟢 / 🟡 / 🔴 | **[X]%** of AI-assisted workflows running on single vendor **[Vendor Name]**; OSS fallbacks: **[in place / in progress / not started]** |
| Global Transformation | 🟢 / 🟡 / 🔴 | **[X]** reskilling hours per team member this quarter (target: ≥ 8); team member sentiment on career impact: **[X]/5.0** |

*Guidance: The responsible AI section is not a compliance checkbox — it is a risk management signal. A 🔴 on any dimension means the executive needs to make a decision or allocate resource. A persistent 🟡 with no movement should be treated as a 🔴 for escalation purposes.*

---

### Section 5: AI Investment Signal

**Investment this quarter:**
> "[FILL IN: describe tools, licences, and training time — e.g., 'GitHub Copilot Business: [N] seats × [£/$/€X] per month; [X] hours of structured AI upskilling per team member; [X] hours of AI Champion time allocated to prompt library governance']"

**Estimated value delivered:**

| Value Driver | Measurement | Estimated Impact |
|---|---|---|
| Lead time reduction | DORA: [X] days → [Y] days | [Z] team member-days saved per quarter |
| Rework reduction | Post-merge rework rate: [X]% → [Y]% | [Z] team member-hours saved per quarter |
| YANG stub automation | [N] stubs auto-generated vs. manual | [Z] team member-hours saved per quarter |
| Test generation | Test coverage: [X]% → [Y]% | [Z] team member-hours saved per quarter |
| **Total estimated saving** | | **[Z] team member-hours ≈ [£/$/€X] per quarter** |

*Guidance on honest ROI estimation: Do not inflate these figures. Use conservative estimates and state your assumptions explicitly. Multiply time saved by an team member blended rate only if you have a finance-approved rate. The goal is defensible evidence of value, not a compelling narrative that cannot survive scrutiny. It is better to report "we saved approximately 80 team member-hours and we are confident in this estimate" than to report "we saved £240,000" and have it challenged.*

*If the investment cost exceeds the estimated saving this quarter, say so — and explain why the investment is still correct (capability building for future quarters, risk reduction, retention).*

---

### Section 6: Top 3 Wins This Quarter

*Each win must be specific, evidenced, and connected to a DORA or SPACE metric. Avoid vague claims like "the team found Copilot helpful." The test: could a sceptical executive challenge this claim? If so, what is your evidence?*

1. **[Win title]**
   - What happened: [FILL IN — specific description]
   - Evidence: [FILL IN — metric before/after, e.g., "YANG defect rate in production: 3.2% → 1.8%"]
   - DORA/SPACE connection: [FILL IN — e.g., "Contributed to lead time reduction from 6 days to 4.5 days"]

2. **[Win title]**
   - What happened: [FILL IN]
   - Evidence: [FILL IN]
   - DORA/SPACE connection: [FILL IN]

3. **[Win title]**
   - What happened: [FILL IN]
   - Evidence: [FILL IN]
   - DORA/SPACE connection: [FILL IN]

---

### Section 7: Top 3 Lessons / Concerns

*This section is required. Executives who receive only wins stop trusting the report. The lessons and concerns section is what distinguishes an honest engineering leadership team from a team that is managing perception. Each lesson must include what the team is doing about it.*

1. **[Lesson/Concern title]**
   - What we observed: [FILL IN — specific description of the problem or surprise]
   - Impact: [FILL IN — what did this cost us? Time, quality, morale?]
   - What we are doing about it: [FILL IN — specific action, owner, timeline]

2. **[Lesson/Concern title]**
   - What we observed: [FILL IN]
   - Impact: [FILL IN]
   - What we are doing about it: [FILL IN]

3. **[Lesson/Concern title]**
   - What we observed: [FILL IN]
   - Impact: [FILL IN]
   - What we are doing about it: [FILL IN]

---

### Section 8: Next Quarter Focus

*Three priorities. Each must be anchored to a specific adoption stage milestone, a responsible AI gate, or a DORA/SPACE improvement target. Avoid vague priorities like "continue adopting AI." The test: at the end of next quarter, will we be able to say definitively whether we achieved this or not?*

Our top 3 priorities for AI adoption in Q[X+1] [YEAR]:

1. **[Priority]**
   - Adoption stage connection: [FILL IN — e.g., "Completing Stage 3 milestone: all team members using prompt library weekly"]
   - Success metric: [FILL IN — measurable, with a target value]
   - Owner: [FILL IN]

2. **[Priority]**
   - Responsible AI gate: [FILL IN — e.g., "Closing SCI amber gap: establish monthly SCI reporting and achieve 10% reduction from baseline"]
   - Success metric: [FILL IN]
   - Owner: [FILL IN]

3. **[Priority]**
   - DORA/SPACE target: [FILL IN — e.g., "Move lead time from Medium to High band: target ≤ 1 day mean lead time for standard changes"]
   - Success metric: [FILL IN]
   - Owner: [FILL IN]

---

### Section 9: Ask / Decision Required *(complete only if applicable)*

> "We are requesting **[approval / budget allocation / executive decision / risk acceptance]** for **[specific item]** in order to **[advance to Stage [Y] / address responsible AI risk [Z] / unblock delivery capability [W]]**."

*Guidance: Be precise. "We need more AI tools" is not an ask. "We are requesting approval for [N] additional Copilot Business seats at [cost] to cover the [X] team members who joined the team in Q2, in order to maintain Stage 3 adoption standards across the full team" is an ask. If no decision is required, omit this section rather than leaving it blank.*

---
---

## Worked Example — Stage 2 → Stage 3 Transition

*The following is a completed example for a team of 18 team members that has just completed Stage 2 (Experimenting) and is entering Stage 3 (Practicing). It is representative of a real transition — imperfect, honest, with genuine tensions. Use it as a calibration reference when completing the template for your own quarter.*

---

```
O&A Team AI-Agentic Adoption — Quarterly Report
================================================
Quarter:     Q2 2025
Prepared by: Priya Chandrasekaran, Engineering Manager
Team:        OSS - Orchestration and Automation — 18 team members
Report date: 30 June 2025
Reviewers:   Damian O'Reilly (Head of Engineering), Yuki Nakamura (VP Engineering)
```

---

### Section 1: Adoption Stage

**Current stage:** Stage **3** — **Practicing**

> "The O&A team is currently in **Stage 3: Practicing** of the AI-Agentic Adoption Journey, having advanced from Stage 2 (Experimenting) during Q2 2025. The key milestone that marked this transition was the team-wide adoption of the prompt library (25 validated templates, 14 of 18 team members using it weekly) and the establishment of AI-aware PR review standards in our Definition of Done."

---

### Section 2: DORA Performance

| Metric | Last Quarter (Q1) | This Quarter (Q2) | Band | Trend |
|---|---|---|---|---|
| Deployment Frequency | 1.2 deploys/week | 1.8 deploys/week | Low → Medium | ↑ |
| Lead Time for Changes | 6.4 days | 4.9 days | Low → Medium | ↑ |
| MTTR | 3.1 hours | 2.8 hours | Medium | → |
| Change Failure Rate | 5.2% | 4.7% | Medium | ↑ |

> "AI-assisted test generation and automated YANG stub scaffolding contributed to a **23% reduction in lead time for changes** this quarter, moving the team from the Low band into the lower end of the Medium band. Change failure rate improved marginally to 4.7%, indicating that AI adoption is not introducing additional production risk — our AI-aware PR review checklist, introduced in Sprint 4, is working as intended."

---

### Section 3: Team Health (SPACE)

| Dimension | Q1 | Q2 | Change |
|---|---|---|---|
| Satisfaction & Wellbeing (S) | 3.4/5.0 | 3.8/5.0 | ↑ |
| Performance (P) | 3.6/5.0 | 3.9/5.0 | ↑ |
| Activity (A) | 3.7/5.0 | 3.8/5.0 | → |
| Communication & Collaboration (C) | 3.5/5.0 | 3.7/5.0 | ↑ |
| Efficiency & Flow (E) | 3.2/5.0 | 3.6/5.0 | ↑ |

> "Developer satisfaction with AI tools reached 3.8/5.0 this quarter, above our 3.5 threshold for the first time — team members report that the prompt library has reduced the 'blank page' problem for YANG module scaffolding. Efficiency and Flow scores improved most significantly (3.2 → 3.6), with team members citing YANG stub generation and automated test scaffolding as the primary cognitive load reducers; however, two team members noted that complex YANG `must` expression work remains slower with Copilot than without (see Section 7)."

---

### Section 4: Responsible AI Status

| Dimension | Status | Notes |
|---|---|---|
| Privacy | 🟢 Compliant | Data classification policy in place since Q1. Zero incidents in Q2. DPA with GitHub/Microsoft reviewed and current. All team members completed data handling training (18/18). |
| Security | 🟢 Compliant | SAST gates active on 100% of PRs. AI supply chain risk item on team risk register (residual risk: low). SAST pass rate on AI-assisted PRs: 98.9% vs. 98.4% on manual PRs — no regression. |
| Environmental (SCI) | 🟡 In Progress | Baseline established in Q2: **138 gCO₂e per team member per sprint**. Model sizing guide published. SCI tracking is manual this quarter; automated tooling integration targeted for Q3. Trend: not yet available (first measurement). |
| Market Concentration | 🟡 Monitoring | **76%** of AI-assisted workflows running on GitHub Copilot Business (Microsoft). OSS fallbacks active for test generation (Ollama + CodeLlama) and commit message generation. Vendor review scheduled for Q4 if concentration exceeds 80%. |
| Global Transformation | 🟢 Compliant | **9.4 hours** reskilling per team member in Q2 (target: ≥ 8 hours). ✓ Team Member sentiment on career impact: 3.9/5.0. No AI-related departures. Two new hires cited the AI programme as a factor in accepting the offer. |

---

### Section 5: AI Investment Signal

**Investment this quarter:**
> "GitHub Copilot Business: 18 seats × £19/month × 3 months = **£1,026**. Structured AI upskilling: 9.4 hours × 18 team members = 169.2 team member-hours. AI Champion role (Sanjay Mehta): approximately 15% of one senior team member's time = ~60 team member-hours per quarter. Total loaded investment: approximately **£18,400** (licences + time at £100 blended team member rate)."

**Estimated value delivered:**

| Value Driver | Measurement | Estimated Impact |
|---|---|---|
| Lead time reduction | 6.4 days → 4.9 days on ~40 changes/quarter | ~60 team member-hours saved |
| YANG stub automation | ~80 stubs auto-generated (est. 45 min saved each) | ~60 team member-hours saved |
| Test generation scaffolding | Test coverage 62% → 80%; scaffolding time halved | ~40 team member-hours saved |
| Rework reduction | Post-merge rework: 8.1% → 6.4% on ~120 PRs | ~18 team member-hours saved |
| **Total estimated saving** | | **~178 team member-hours ≈ £17,800** |

*Note: Investment and return are approximately equal this quarter. This is expected at Stage 3 — the team is building capability and habits. The ROI case strengthens as we move into Stage 4 (Scaling), where the tooling overhead is amortised across a larger workflow footprint. We are not claiming a cost-saving case yet; we are claiming a capability-building case with neutral-to-positive delivery impact.*

---

### Section 6: Top 3 Wins This Quarter

1. **Test coverage increased from 62% to 80% on O&A service modules**
   - What happened: AI-assisted test scaffolding using the `generate-unit-tests` prompt template was adopted by 12 of 18 team members. The template generates pytest boilerplate for Python NSO service modules, which team members then complete with domain-specific assertions.
   - Evidence: SonarQube coverage report: 62.1% (Q1 end) → 80.3% (Q2 end). Post-merge defect rate on covered modules: down 18% quarter-on-quarter.
   - DORA/SPACE connection: Contributed to change failure rate improvement (5.2% → 4.7%) and SPACE-P improvement (3.6 → 3.9).

2. **Prompt library reached 25 validated templates, actively used by 14/18 team members weekly**
   - What happened: AI Champion Sanjay Mehta led a fortnightly "prompt surgery" session where team members submitted, reviewed, and refined templates. The library now covers YANG stub generation, NSO service template scaffolding, TM Forum API mapping, commit message generation, and test scaffolding.
   - Evidence: Confluence page analytics: 14 unique weekly active users; 847 template views in Q2. SPACE-S AI tool satisfaction: 3.4 → 3.8.
   - DORA/SPACE connection: Prompt library adoption is the primary evidence for Stage 3 transition. SPACE-E (Efficiency) improvement (3.2 → 3.6) directly attributed in survey free text.

3. **YANG defect rate in production reduced from 3.2% to 1.8%**
   - What happened: AI-assisted YANG validation workflow (Copilot draft → `pyang` lint → YANG fitness function → peer review) was standardised as part of the Definition of Done in Sprint 4. The fitness function catches structural violations before review.
   - Evidence: Production incident log: 3 YANG-related incidents in Q1 vs. 1 in Q2. YANG fitness function dashboard: pass rate 94% (up from 78% in Q1).
   - DORA/SPACE connection: Reduction in production YANG defects contributed directly to MTTR stability and CFR improvement.

---

### Section 7: Top 3 Lessons / Concerns

1. **Copilot is unreliable on YANG `must` constraint logic — two team members found it slower them down**
   - What we observed: Two senior team members (Keiko Tanaka and Lars Bergström) reported in the SPACE survey and in Sprint 6 retro that Copilot's suggestions for YANG `must` expressions are frequently incorrect in ways that are non-obvious. Accepting and then debugging a wrong `must` expression takes longer than writing it manually.
   - Impact: These team members reduced Copilot usage for YANG constraint work. SPACE-E for the senior team member cohort was 3.3 vs. 3.8 for the broader team — a signal worth monitoring.
   - What we are doing about it: Jagged frontier map updated (YANG `must` expressions flagged as AI-weak zone). Negative example added to prompt library. PR checklist updated to require manual review of all AI-generated `must` expressions. ADR-008 drafted to formalise this boundary. No short-term fix — this is a model capability limitation.

2. **GitHub Copilot Business enterprise rollout was delayed by 3 weeks due to procurement**
   - What we observed: Enterprise licence consolidation required additional procurement approval, delaying full-team rollout from Sprint 3 to Sprint 5. During this period, 6 team members were using free-tier Copilot with rate limits, creating a two-speed team experience.
   - Impact: SPACE-C (Communication & Collaboration) was lower in Sprint 4 (3.4) as team members with full licences and team members with limited licences had different workflow experiences. Two team members in the limited-licence cohort reported in the survey that the disparity felt inequitable.
   - What we are doing about it: Licences are now standardised across all 18 team members. Procurement process improvement submitted to Head of Engineering for Q3 planning. Retrospective action: for any future tool rollout, licence provisioning must be completed before the sprint in which adoption is expected to begin.

3. **SCI measurement is manual and time-consuming — risk of it being deprioritised**
   - What we observed: Establishing the SCI baseline took approximately 6 hours of AI Champion time in Q2. The process involves manually aggregating model invocation logs from the GitHub Copilot API, which is not well-documented.
   - Impact: If SCI tracking remains manual, it will be deprioritised under delivery pressure. The Q2 baseline exists; continuous tracking does not yet.
   - What we are doing about it: Sanjay is evaluating two tooling options for automated SCI aggregation (Carbon-Aware SDK integration and a custom Copilot telemetry pipeline). Decision and implementation targeted for Q3 Sprint 2. If neither option is viable within the quarter, we will escalate a request for engineering platform support.

---

### Section 8: Next Quarter Focus

Our top 3 priorities for AI adoption in Q3 2025:

1. **Complete Stage 3 (Practicing) and prepare for Stage 4 (Scaling) entry criteria**
   - Adoption stage connection: Stage 3 full completion requires 100% of team members (18/18) using the prompt library weekly and AI-aware PR review standard in place for all PR types (currently applies to Python/YANG; not yet to Ansible playbook changes).
   - Success metric: ≥ 18/18 team members with ≥ 3 prompt library uses per week by end of Q3; Ansible prompt templates added to library (target: ≥ 5).
   - Owner: Sanjay Mehta (AI Champion), supported by all tech leads.

2. **Close SCI amber gap: implement automated SCI tracking and achieve first improvement from baseline**
   - Responsible AI gate: Move Environmental (SCI) from 🟡 to 🟢 by end of Q3.
   - Success metric: Automated SCI reporting in place by Sprint 2; Q3 end SCI ≤ 124 gCO₂e/team member/sprint (10% reduction from Q2 baseline of 138).
   - Owner: Sanjay Mehta (tooling), Priya Chandrasekaran (escalation if platform support required).

3. **Move lead time for changes from Medium band toward High band**
   - DORA target: Lead time for standard changes (non-emergency) ≤ 2 days mean by Q3 end (current: 4.9 days). This requires further automation of NSO integration test setup, which is currently the longest stage in the lead time measurement.
   - Success metric: DORA lead time ≤ 2 days for standard changes by Sprint 12 (Q3 end); CI/CD pipeline stage breakdown published so we can identify the next bottleneck.
   - Owner: Lars Bergström (pipeline optimisation), Keiko Tanaka (test automation lead).

---

### Section 9: Ask / Decision Required

> "We are requesting **approval for 3 additional GitHub Copilot Business seats** (cost: £57/month, £171/quarter) to cover the 3 team members who joined the O&A team in May 2025 and who are currently unprovisioned. Without these seats, these team members cannot participate in Stage 3 adoption activities, creating a two-speed team risk that we experienced in Q2 and do not wish to repeat."
>
> "We are also requesting **guidance on whether SCI tooling development should be resourced from the O&A team's own backlog or submitted as a request to the Engineering Platform team.** The current estimate is 3–5 team member-days of effort. If this sits in the O&A backlog, it will compete with delivery commitments; if it is a platform team request, we need to know the queue time."

---

*Connected documents: `architect-elevator.md` (communication framework), `quarterly-review.md` (working document and data source for this summary)*
*Measurement backbone: DORA (Forsgren, Humble, Kim — "Accelerate", 2018) + SPACE (Forsgren et al., 2021)*
*Responsible AI framework: Privacy · Security · Environmental (SCI) · Market Concentration · Global Transformation*
