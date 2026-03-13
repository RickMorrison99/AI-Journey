# Self-Reporting Template — Sprint & Quarterly

> *"The data we collect about ourselves is for us. The moment it is used against us, we stop telling the truth."*
> — Nicole Forsgren, *Accelerate* (2018), on the conditions required for valid self-reported measurement

---

## Purpose & Frequency

Self-reporting fills the gap that automated telemetry cannot: **how team members actually experience their work.** The SPACE framework's Satisfaction, Efficiency, and Flow dimensions are only accessible through self-report. No CI/CD pipeline can tell you whether an team member felt trusted, frustrated, or in deep focus last sprint.

| Form | Who Completes | Cadence | Time Budget |
|---|---|---|---|
| Sprint Self-Report | Every team member | End of each sprint | ≤ 10 minutes |
| Sprint Team Aggregation | Team lead / AI Champion | Within 2 days of sprint end | 20–30 minutes |
| Quarterly Team Review | Team lead + Engineering Manager | End of each quarter | 60–90 minutes |

**Data governance — read this before collecting anything:**

!!! warning "This data is for team improvement. Never for individual performance review."
    Nicole Forsgren's research is unambiguous: when team members believe self-reported data will be used to evaluate their performance, they optimise their answers rather than report honestly. The entire signal evaporates.

    - Sprint self-reports are **anonymous by default**. Team Members should not be asked to identify themselves.
    - Team leads see **aggregated scores only**, never individual responses.
    - No team member will ever be asked in a 1:1 or performance review why their satisfaction score was low.
    - Quarterly reviews go to the Engineering Manager as a **team health snapshot**, not as an assessment of any individual.

    If this governance commitment cannot be made and maintained, **do not collect this data.** Unreliable self-report data is worse than no data.

---

## Sprint Self-Report (Team Member)

Copy the form below into a Confluence page, a Google Form, or a simple survey tool. All questions are optional except those marked **[required]**. Target: ≤ 10 minutes to complete.

---

### Sprint Details

| Field | Response |
|---|---|
| Sprint number / end date | *(e.g., Sprint 24 · 2025-07-18)* |
| Primary O&A domain this sprint | *(e.g., YANG modelling / NSO service packages / Ansible automation / CI/CD pipeline / cross-cutting)* |

---

### Section A — Satisfaction & Well-being (SPACE-S)

> These questions map to the **Satisfaction** dimension of the SPACE framework. They capture how AI tools are affecting your experience of work — not just what you produced.

**A1. Overall satisfaction with AI tools this sprint** **[required]**

| Score | Label |
|---|---|
| 1 | Very Dissatisfied |
| 2 | Dissatisfied |
| 3 | Neutral |
| 4 | Satisfied |
| 5 | Very Satisfied |
| — | Did not use AI tools this sprint |

*Select one.*

---

**A2. Did AI tools affect your cognitive load this sprint?**

- [ ] Much less load — AI handled repetitive or boilerplate work
- [ ] Slightly less load
- [ ] Same as without AI
- [ ] Slightly more load — I spent time reviewing and correcting AI output
- [ ] Much more load — AI output was unreliable and added significant overhead
- [ ] Not applicable / did not use AI

---

**A3. Did you feel safe to flag when AI output was wrong or unusable?** **[required]**

- [ ] Yes — I flagged issues and it was treated as normal engineering practice
- [ ] Sometimes — I flagged it but felt it might be perceived negatively
- [ ] No — I felt pressure to accept or work around AI output without raising concerns
- [ ] Not applicable / no AI output issues this sprint

*If "Sometimes" or "No": please raise this with the AI Champion directly. Psychological safety to challenge AI output is a hard requirement, not a nice-to-have.*

---

**A4. AI tool frustrations worth sharing?** *(optional freetext)*

> e.g., Copilot suggested YANG node names that violated our naming conventions; ChatGPT hallucinated an NSO API method that does not exist; Copilot Workspace ignored service/module boundaries.

---

### Section B — Performance (SPACE-P)

> These questions capture **output quality** — specifically, whether AI tooling is helping or hurting the quality of what reaches review and production.

**B1. Did you find and fix any AI-generated bugs or issues in PRs this sprint?**

- [ ] No
- [ ] Yes — approximately **___** issues *(enter a number)*

*This is a quality signal, not a criticism. AI tools produce bugs. Catching them is correct behaviour.*

---

**B2. Did AI-assisted code require more rework after initial review than your non-AI code typically does?**

- [ ] No — quality was similar or better
- [ ] Yes — AI-assisted code needed more significant revision
- [ ] Not applicable / no AI-assisted code this sprint

---

**B3. Did AI help you catch a bug or design issue you might otherwise have missed?**

- [ ] Yes *(optional: describe briefly below)*
- [ ] No
- [ ] Not sure

*Freetext (optional):*

---

### Section C — Activity (SPACE-A)

> **Reminder:** The numbers in this section are **context for understanding trends, not performance metrics.** A high AI-assisted percentage is not better than a low one. A low percentage is not a sign of resistance. These numbers help the team understand *how* work is being done — nothing more.

**C1. Approximately what percentage of code in your PRs this sprint involved AI assistance in authoring?**

- [ ] 0% — no AI-assisted code
- [ ] 1–25%
- [ ] 26–50%
- [ ] 51–75%
- [ ] 76–100%

*"AI-assisted authoring" means you accepted, adapted, or substantially used an AI suggestion. Prompting and discarding does not count.*

---

**C2. Which AI tools did you use this sprint?** *(select all that apply)*

- [ ] GitHub Copilot (inline / autocomplete)
- [ ] GitHub Copilot Chat
- [ ] GitHub Copilot CLI
- [ ] GitHub Copilot Workspace
- [ ] ChatGPT / Claude / Gemini (browser or API)
- [ ] Team-operated AI gateway or LLM proxy
- [ ] Custom O&A pipeline with LLM component
- [ ] Local model (e.g., Ollama)
- [ ] None

---

**C3. Did you add a new prompt or workflow to the team prompt template library this sprint?**

- [ ] Yes *(optional: brief description below)*
- [ ] No — I used existing templates
- [ ] No — I created prompts but didn't think they were reusable
- [ ] No prompt library exists yet / I wasn't aware of it

*Freetext (optional):*

---

### Section D — Efficiency & Flow (SPACE-E)

> These questions measure whether AI tooling is supporting or disrupting your ability to do focused, productive work.

**D1. Rate your overall flow state this sprint** **[required]**

| Score | Label |
|---|---|
| 1 | Constantly interrupted — almost no sustained focus |
| 2 | Frequently interrupted — brief periods of focus only |
| 3 | Mixed — some focused periods, some fragmented |
| 4 | Mostly focused — interruptions were manageable |
| 5 | Deep focus most of the time — low interruption, high absorption |

*Select one.*

---

**D2. Roughly what proportion of your sprint was unplanned work?**

- [ ] None — I worked entirely to the sprint plan
- [ ] < 10% — minor unplanned items
- [ ] 10–25% — noticeable unplanned work
- [ ] 25–50% — approximately half unplanned
- [ ] > 50% — sprint plan was largely disrupted

---

**D3. Did AI tools help you get unstuck or unblocked faster this sprint?**

- [ ] Yes — AI noticeably reduced time spent stuck on a problem
- [ ] Sometimes — AI helped in places, not in others
- [ ] No — AI tools were not helpful for unblocking
- [ ] Did not use AI for this purpose

---

### Section E — AI-Specific (O&A Context)

> These two questions are the highest-value freetext in the form. The answers directly shape which AI-assisted workflows the team invests in and which it retires.

**E1. Which O&A task benefited MOST from AI assistance this sprint?** *(optional freetext)*

> Examples: generating YANG leaf boilerplate; drafting Ansible task descriptions; writing pytest fixtures for NSO service tests; explaining a NETCONF error trace; suggesting BGP policy refactors.

---

**E2. Which O&A task did AI struggle with most?** *(optional freetext)*

> Examples: generating valid YANG must-expressions; understanding NSO CDB transaction semantics; producing Ansible tasks that respected our inventory structure; suggesting safe changes to NETCONF datastores.

---

**E3. Did AI tools appear to respect service and module boundaries in your workflow this sprint?**

- [ ] Yes — suggestions were appropriately scoped to the module/service I was working in
- [ ] Mostly — occasional suggestions crossed boundaries but were easy to dismiss
- [ ] Sometimes violated — AI suggested changes that crossed service/module boundaries in ways that required care
- [ ] Frequently violated — AI-generated code routinely ignored boundaries and required significant correction
- [ ] Not applicable

*Service boundary awareness matters for O&A because AI tools trained on general code often suggest patterns that are correct in isolation but violate NSO service encapsulation or YANG module structure.*

---

*Thank you. Submit when complete. Your responses are anonymous and go directly to the sprint aggregation.*

---

## Sprint Team Aggregation View (Team Lead / AI Champion)

Complete this within two business days of sprint end. Use the aggregated team member responses to fill in each table. Do not identify individual team members in any field.

### SPACE Aggregation Table

For each dimension, compute the mean score from team member responses and note the trend vs the previous sprint.

| SPACE Dimension | Key Question(s) This Sprint | Aggregated Score | Trend | Action Threshold |
|---|---|---|---|---|
| **S — Satisfaction** | A1 mean satisfaction rating | ___ / 5 | ↑ ↓ → | < 3.0 → investigate this sprint |
| **P — Performance** | % reporting AI-gen bugs found; % reporting excess rework | ___% bugs found; ___% rework | ↑ ↓ → | AI rework > 30% → review prompt hygiene |
| **A — Activity** | Mean AI-assisted code %; active tool count | ___% code; ___ tools avg | ↑ ↓ → | < 20% active rate → adoption stall signal |
| **C — Communication** | *(collected via team retro, not sprint form)* | — | — | — |
| **E — Efficiency** | D1 mean flow score; D3 "helped unblock" % | ___ / 5 flow; ___% unblocked | ↑ ↓ → | Flow < 3.0 two sprints running → escalate |

**Trend key:** ↑ Improving &nbsp;·&nbsp; ↓ Worsening &nbsp;·&nbsp; → Stable (within ±0.2 of prior sprint)

---

### AI Adoption KPI Tracker

Fill in at each sprint and retain the history. This table is the longitudinal record.

| KPI | This Sprint | Last Sprint | Δ | Note |
|---|---|---|---|---|
| Active AI users (% of team) | ___% | ___% | | |
| Tool portfolio breadth (avg per team member) | ___ | ___ | | |
| Prompt library additions this sprint | ___ | ___ | | |
| SPACE-A avg (% code AI-assisted) | ___% | ___% | | |
| Team Members reporting flow score ≥ 4 | ___% | ___% | | |
| Team Members reporting safe-to-flag (A3 = "Yes") | ___% | ___% | | |

---

### Security & Quality Signal

| Signal | This Sprint | Last Sprint | Δ |
|---|---|---|---|
| SAST findings in AI-labelled PRs | ___ | ___ | |
| SAST findings in non-AI PRs (baseline) | ___ | ___ | |
| AI-gen findings / total findings ratio | ___% | ___% | |
| Team Members reporting AI-gen bugs in PRs (B1) | ___ | ___ | |

*If the AI-gen / total ratio is rising, investigate prompt hygiene and code review practices before attributing to AI tooling maturity.*

---

### Responsible AI Incidents

| Field | This Sprint |
|---|---|
| Any responsible AI incidents this sprint? | Yes / No |
| If Yes — brief description | |
| Incident type | Hallucinated API / Boundary violation / Data exposure risk / Vendor outage impact / Other |
| Mitigating action taken | |
| Escalation required? | Yes / No |

*A "responsible AI incident" is any event where AI output caused, or nearly caused, a production issue, a security concern, or a violation of team engineering standards. Near-misses count and are valuable. Report them.*

---

## Quarterly Team Review Template (Team Lead + Engineering Manager)

Complete at the end of each quarter. This document is the primary artefact for the quarterly measurement review. Retain all versions — longitudinal comparison across quarters is where the most useful signals appear.

**Quarter:** Q___ · _____ to _____
**Team size (team members):** ___
**AI Champion:** ___
**Engineering Manager:** ___

---

### 1. DORA Metrics — Delivery Performance

*Reference [`dora-metrics.md`](./dora-metrics.md) for O&A-specific metric definitions.*

| DORA Metric | Current Band | Last Quarter Band | Trend | AI Adoption Hypothesis Holding? |
|---|---|---|---|---|
| Deployment Frequency | Elite / High / Medium / Low | | ↑ ↓ → | Yes / No / Inconclusive |
| Lead Time for Changes | Elite / High / Medium / Low | | ↑ ↓ → | Yes / No / Inconclusive |
| Change Failure Rate | Elite / High / Medium / Low | | ↑ ↓ → | Yes / No / Inconclusive |
| MTTR | Elite / High / Medium / Low | | ↑ ↓ → | Yes / No / Inconclusive |

**DORA narrative:** *(2–4 sentences. What is the delivery performance story this quarter? Did AI tooling appear to help, hurt, or have no detectable effect? Be honest — "inconclusive" is a valid and useful finding.)*

---

### 2. SPACE Radar — Five-Dimension Summary

Score each dimension 1–5 based on the sprint aggregations across the quarter (mean of sprint means).

| SPACE Dimension | Q___ Score | Q___ Score (prior) | Δ | Notable Pattern |
|---|---|---|---|---|
| S — Satisfaction | ___ / 5 | ___ / 5 | | |
| P — Performance | ___ / 5 | ___ / 5 | | |
| A — Activity | ___ / 5 | ___ / 5 | | |
| C — Communication & Collaboration | ___ / 5 | ___ / 5 | | |
| E — Efficiency & Flow | ___ / 5 | ___ / 5 | | |

**Radar interpretation:** *(Which dimensions improved? Which are lagging? Is there a pattern — e.g., Activity rising while Satisfaction falling, which is an early burnout signal?)*

---

### 3. AI Adoption Progress

*Reference [`ai-adoption-kpis.md`](./ai-adoption-kpis.md) for stage definitions.*

**Current adoption stage:** Assisted / Augmented / Agentic *(circle one)*

**Evidence for this stage assessment:**

| Evidence Type | Observation |
|---|---|
| Tool breadth average | ___ tools/team member (target for this stage: ___) |
| Agentic workflow usage | ___% of team members using at least one agentic workflow |
| Prompt library size | ___ reusable prompts in team library |
| AI-assisted PRs % | ___% of merged PRs this quarter had AI contribution |
| SPACE-A trend | |
| Qualitative indicator | *(e.g., "Team Members are self-directing to new AI use cases without prompting from leadership")* |

**Is the team ready to advance to the next stage?** Yes / Not yet / Assessment needed

**Blockers to advancing:** *(if applicable)*

---

### 4. Responsible AI — Sustainability & Risk

| Metric | This Quarter | Last Quarter | Trend | Target |
|---|---|---|---|---|
| Responsible AI incidents | ___ | ___ | ↑ ↓ → | 0 severity-2+; declining severity-1 |
| SCI estimate (CO₂e / team member / sprint) | ___ g | ___ g | ↑ ↓ → | Flat or improving |
| Vendor concentration index | ___% single-vendor | ___% | ↑ ↓ → | < 70% any single vendor |
| Reskilling hours invested this quarter | ___ hrs total | ___ hrs | | ≥ 4 hrs/team member/quarter |
| Team Members with AI-safety awareness training current | ___% | ___% | | 100% |

**SCI trend narrative:** *(Is the team's AI carbon footprint growing with adoption, or is model efficiency / local model usage keeping it flat? What is the primary driver?)*

**Vendor concentration narrative:** *(If > 70% of AI workflow depends on a single vendor, what is the continuity risk? Is there a mitigation plan?)*

---

### 5. Wins — Three Best AI-Assisted Outcomes This Quarter

Document three concrete outcomes where AI tooling delivered measurable or clearly observable value. Be specific — vague wins are not useful longitudinal data.

**Win 1:**

| Field | Detail |
|---|---|
| What was the task or problem? | |
| Which AI tool / workflow was used? | |
| What was the outcome? | |
| Can this be attributed to AI with confidence? | High / Medium / Low confidence |
| Is this replicable as a team practice? | Yes / No / With modification |

**Win 2:**

| Field | Detail |
|---|---|
| What was the task or problem? | |
| Which AI tool / workflow was used? | |
| What was the outcome? | |
| Can this be attributed to AI with confidence? | High / Medium / Low confidence |
| Is this replicable as a team practice? | Yes / No / With modification |

**Win 3:**

| Field | Detail |
|---|---|
| What was the task or problem? | |
| Which AI tool / workflow was used? | |
| What was the outcome? | |
| Can this be attributed to AI with confidence? | High / Medium / Low confidence |
| Is this replicable as a team practice? | Yes / No / With modification |

---

### 6. Lessons — Three Biggest AI-Assisted Failures or Surprises This Quarter

!!! warning "This section is required, not optional."
    Teams that only document wins are not learning. The most valuable improvement signal in this entire document lives here. If your team cannot identify three AI-related failures or surprises in a quarter, one of two things is true: AI tooling had no meaningful impact on the team's work, or the team is not yet honest enough with itself to use this framework effectively.

    A "failure" does not require a production incident. A prompt that wasted an afternoon, an AI-generated YANG model that passed CI but failed in integration, a Copilot suggestion that introduced a subtle namespace collision — these are all valuable lessons.

**Lesson 1:**

| Field | Detail |
|---|---|
| What happened? | |
| Which AI tool / workflow was involved? | |
| What was the impact? | |
| What did we learn? | |
| What practice change resulted (or should result)? | |

**Lesson 2:**

| Field | Detail |
|---|---|
| What happened? | |
| Which AI tool / workflow was involved? | |
| What was the impact? | |
| What did we learn? | |
| What practice change resulted (or should result)? | |

**Lesson 3:**

| Field | Detail |
|---|---|
| What happened? | |
| Which AI tool / workflow was involved? | |
| What was the impact? | |
| What did we learn? | |
| What practice change resulted (or should result)? | |

---

### 7. Next Quarter Focus — Top Three Practices to Improve or Introduce

Based on this quarter's data, identify the three highest-leverage changes for next quarter. Each item should connect to a specific DORA or SPACE signal.

| Priority | Practice to Improve or Introduce | Driven by Which Signal? | Owner | Success Indicator |
|---|---|---|---|---|
| 1 | | | | |
| 2 | | | | |
| 3 | | | | |

---

### 8. Architect Elevator — Executive Summary

*Two sentences maximum. Connect team-level measurement to business outcomes. This is the summary that goes to senior leadership or is used in architecture reviews. Write it last, after completing sections 1–7.*

> **Q___ summary:**
> *(Example: "The O&A team delivered at High DORA-band performance this quarter, with lead time improving 23% as AI-assisted YANG boilerplate generation reduced authoring time; Change Failure Rate held steady, confirming that acceleration did not come at the cost of reliability. For Q___, the team is focused on maturing prompt library discipline and introducing agentic test generation to address the remaining lead-time bottleneck in NSO service package validation.")*

---

## Revision History

| Version | Date | Author | Summary of Changes |
|---|---|---|---|
| 1.0 | 2025-07 | O&A AI Champion | Initial release |
