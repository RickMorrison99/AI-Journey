# The Architect Elevator — Connecting AI Tooling to Business Outcomes

> *"The architect's job is not to sit in the ivory tower and send edicts down. It's to ride the elevator — from the engine room to the penthouse and back — and translate between the two worlds."*
> — Gregor Hohpe, *The Software Architect Elevator* (2020)

**Document type:** Stakeholder communication guide
**Audience:** Team Members, tech leads, architects, engineering managers, and executives in the O&A programme
**Purpose:** Ensure AI adoption conversations are coherent across all organisational levels — from daily tool use to board-level strategy

---

## Why This Document Exists

AI adoption programmes fail in predictable ways.

From below: team members adopt tools enthusiastically, build habits and tacit knowledge — but no one connects this to delivery metrics, so the investment becomes invisible and vulnerable to cost cuts.

From above: executives mandate AI adoption as a strategic imperative — but no one checks whether the engineering reality supports the mandate, so the rollout becomes a compliance exercise rather than a genuine capability shift.

Gregor Hohpe's **Architect Elevator** model names this problem precisely. The architects — and by extension, the AI champions, tech leads, and engineering managers in the O&A programme — must be able to ride between the **engine room** (where YANG modules are drafted, CI pipelines run, and Copilot suggestions are accepted or rejected) and the **penthouse** (where competitive positioning, regulatory risk, and capital allocation decisions are made). They must speak both languages fluently and translate between them.

This document is the translation guide.

---

## The Architect Elevator Model

### The Core Metaphor

Imagine a large organisation as a multi-storey building. The penthouse is where the CEO, CTO, and board operate: strategy, risk, competitive positioning, market narratives. The engine room is the ground floor: the IDE, the terminal, the CI log, the PR review queue. Most large organisations have a yawning gap between these two floors, filled with middle management layers that often neither speak engineering reality nor board-level strategy.

The **Architect Elevator** is the habit of deliberately travelling between all floors — not just staying at the level where you are most comfortable — and carrying information up and down in a form that each floor can act on.

### Applied to AI Adoption in the O&A Team

| Without the elevator | With the elevator |
|---|---|
| Team Members know Copilot acceptance rate is 32% — no one tells management | Management knows acceptance rate as evidence of measured, selective AI use — not uncritical automation |
| Executives set a "100% AI tool adoption" target — team members comply by accepting all suggestions | Executives set a "reduce lead time by 30%" target — team members adopt AI where it demonstrably helps |
| DORA metrics improve — no one connects them to AI investment | DORA improvements are directly attributed to specific AI practices in quarterly reports |
| A YANG `must` expression bug slips to production — it is treated as a one-off incident | The incident surfaces a jagged frontier insight: AI is weak on YANG constraint logic — this is captured in the ADR log and communicated upward as a model boundary, not a failure |

### Why This Matters for Telecom O&A

Telecom network orchestration operates at the intersection of:
- **High regulatory scrutiny** (network reliability, data privacy, national infrastructure)
- **High architectural precision** (TM Forum OB/API alignment, YANG data modelling, service boundary integrity)
- **High change risk** (a failed network configuration change has immediate operational impact)

This means the elevator ride must carry **responsible AI signals** — not just productivity signals — up to the penthouse, and must carry **engineering reality checks** — not just mandates — down to the engine room.

---

## The Five Floors

### Floor 1 — The Engine Room (Individual Team Member)

**Daily reality:** VS Code with Copilot, a YANG module open, a CI pipeline running, a PR awaiting review, a Slack message about a failing NSO integration test.

**Language of this floor:** prompts, completions, YANG, `pyang`, NSO, CI gates, PR review comments, test coverage, linting rules, acceptance/rejection decisions.

**What team members care about:**
- Does this tool make my work better or worse, right now?
- Am I slower with it than without it, especially on the things that matter (YANG `must` expressions, TM Forum API wiring)?
- Is it going to get me in trouble — with data privacy, with incorrect network config pushed to production?
- Do I have a playbook, or am I expected to figure this out myself?

**AI adoption signals at this floor:**
- Percentage of team members using AI tools at least three times per week (usage heatmap)
- SPACE-S (Satisfaction) score for AI tool experience (target: ≥ 3.5/5.0)
- Prompt template library: number of templates, weekly active uses per team member
- Self-reported time saved per day (SPACE-E proxy)
- Copilot acceptance rate and rework rate on accepted suggestions

**What to communicate to this floor:**
> "Here is the playbook — what to prompt for, what to review carefully, what not to use Copilot for (YANG `must` constraints, sensitive credential handling). Here is the data privacy rule: no customer data, no network topology data in prompts. Here is the PR checklist that includes AI-aware review steps. Tell us — via the SPACE survey and in sprint retros — what is working and what is not. Your ground-truth experience is the most important signal we have."

**The responsible AI message at this floor:**
- Privacy: classify your data before prompting — green/amber/red classification card is on Confluence
- Security: SAST gate will catch secrets; AI does not replace your security review, it prepares the first draft
- Environment: prefer smaller models for autocompletion; reserve large models for complex reasoning tasks
- Market concentration: the OSS alternatives list is maintained on the wiki — know what exists
- Global transformation: your role is expanding, not contracting; AI handles the scaffolding, you provide the engineering judgement

---

### Floor 2 — The Team Level (Tech Lead / AI Champion)

**Daily reality:** sprint planning, PR review queues, DORA dashboards, team retros, 1:1s, cognitive load conversations, backlog grooming.

**Language of this floor:** sprint velocity, DORA metrics, PR quality, review cycle time, rework rate, cognitive load, team capacity, AI Champion role, prompt library governance.

**What tech leads care about:**
- Is AI helping the team deliver more reliably, or is it introducing new fragility?
- Is it creating technical debt (accepted suggestions that no one fully understood) or reducing it?
- Are the team members energised or fatigued? Is adoption creating a two-speed team?
- Am I able to give my manager an honest account of AI's contribution this sprint?

**AI adoption signals at this floor:**
- DORA trend (week-on-week, sprint-on-sprint): particularly lead time for changes and change failure rate
- SPACE radar (all five dimensions, tracked sprint-by-sprint)
- Rework rate: percentage of AI-assisted PRs that required significant rework post-merge
- Prompt library growth rate and usage breadth (are only 2 team members using it, or all 15?)
- Review cycle time delta: are PRs with AI-generated stubs reviewed faster or slower?

**What to communicate to this floor:**
> "Here are this sprint's SPACE scores across all five dimensions — here is what shifted and what did not. Here is the DORA trend: lead time moved from 6.2 days to 5.1 days; change failure rate held at 4%. Here is what we will do differently next sprint based on the data. The floor below is telling us that YANG `must` expressions are a weak point — we are adding that to the jagged frontier map and the PR review checklist."

**The responsible AI message at this floor:**
- Privacy: team-level audit of prompts in the last sprint — any amber/red data in prompts?
- Security: SAST gate pass rate on AI-assisted PRs — same as manual? Better? Worse?
- Environment: SCI (Software Carbon Intensity) sprint-over-sprint trend — are we improving or worsening?
- Market concentration: vendor dependency tracking — what percentage of our critical workflow runs through a single provider?
- Global transformation: reskilling hours logged this sprint — is the team growing capability or just using the tool?

---

### Floor 3 — The Architecture Level (Staff/Principal Team Members, Solution Architects)

**Daily reality:** Architecture Decision Records (ADRs), TM Forum OB/API alignment, service boundary reviews, fitness functions, evolutionary architecture conversations, technical governance.

**Language of this floor:** separation of concerns (SoC), DRY principle, service boundaries, TM Forum eTOM/SID/OB/API, ADRs, fitness functions, evolutionary architecture, technical governance, API contract testing.

**What architects care about:**
- Is AI adoption creating architectural drift — coupling where there should be cohesion, duplication where there should be shared contracts?
- Are TM Forum APIs being used correctly, or is Copilot suggesting workarounds that bypass the intended alignment?
- Are we making AI-related architecture decisions transparently, with ADRs — or are they accumulating as undocumented technical debt?
- Do our fitness functions still pass? Are AI-generated changes respecting the boundaries they encode?

**AI adoption signals at this floor:**
- ADR count for AI-related decisions (target: every significant AI tooling or model boundary decision has an ADR)
- SoC violation rate in AI-assisted PRs (detected via fitness functions or architecture lint tools)
- TM Forum API adoption rate in AI-generated stubs (are AI suggestions using TMF APIs, or inventing bespoke interfaces?)
- Fitness function pass rate: overall, and specifically on AI-assisted changes
- Jagged frontier map: documented list of areas where AI is strong vs. weak for O&A-specific tasks

**What to communicate to this floor:**
> "We have written four ADRs this quarter covering our use of AI for YANG stub generation, test generation, commit message formatting, and the decision to use Copilot Business rather than an open alternative. Here is the fitness function dashboard — pass rate is 91%, up from 84% last quarter; two of the failures were in AI-assisted changes and have been root-caused and addressed. AI is operating within architectural boundaries. The one area of concern is TM Forum API alignment: Copilot occasionally suggests non-standard resource paths, which our API contract tests now catch. We have added this to the prompt library as a negative example."

**The responsible AI message at this floor:**
- Privacy: data flow ADR — what data is permitted to leave the organisation boundary via AI API calls?
- Security: supply chain ADR — what is the provenance of AI-generated code, and what is our review standard?
- Environment: model selection ADR — have we documented the decision to use a specific model size and its SCI implications?
- Market concentration: architectural dependency map — how many critical architectural paths run through a single AI vendor's API?
- Global transformation: skills architecture — are we building internal capability, or are we creating a dependency on AI for tasks we previously owned?

---

### Floor 4 — The Programme Level (Engineering Manager, Head of Engineering)

**Daily reality:** quarterly planning, headcount and budget conversations, responsible AI compliance, stakeholder reporting, risk registers, team health reviews, reskilling investment decisions.

**Language of this floor:** team health, delivery throughput, responsible AI compliance, investment vs return, risk management, DORA band progression, team member retention, capacity planning.

**What engineering managers care about:**
- Is this AI investment worth it? What is the evidence?
- Are we managing the risks — data privacy, security, over-dependence on a single vendor?
- Is the team healthy? Is AI adoption energising or burning people out?
- What do I put in the quarterly report to the CTO?

**AI adoption signals at this floor:**
- DORA band (current band and quarter-over-quarter trend: Low → Medium → High → Elite)
- SPACE-S trend: is team satisfaction with AI tools improving? Is it above 3.5/5.0?
- SCI trend: is our AI-related carbon footprint flat, improving, or growing unchecked?
- Responsible AI audit status: are all five dimensions green, amber, or red?
- Reskilling hours per team member per quarter (target: ≥ 8 hours)
- Adoption stage: which stage of the AI-Agentic Adoption Journey is the team in?

**What to communicate to this floor:**
The Quarterly Review document (`quarterly-review.md`) is the working format. The Executive Summary template (`executive-summary.md`) is the output. Key narrative frame: "We are investing in AI capability with discipline. Here is the evidence that it is working. Here are the risks we are managing. Here is what we need from you."

**The responsible AI message at this floor:**
- Privacy: GDPR compliance status — are we in scope for any data processing agreements?
- Security: supply chain risk posture — what is our exposure if a vendor has a security incident?
- Environment: ESG reporting input — what is the SCI trend, and what is the narrative for sustainability reporting?
- Market concentration: vendor concentration risk — do we have an exit plan if our primary AI tool becomes unavailable or unaffordable?
- Global transformation: reskilling investment — what is the budget, what is the return, what is the talent retention impact?

---

### Floor 5 — The Penthouse (CTO, VP Engineering, Board)

**Daily reality:** competitive positioning, regulatory environment, capital allocation, talent strategy, M&A signals, ESG reporting, analyst briefings.

**Language of this floor:** competitive advantage, risk exposure, regulatory compliance, time-to-market, ROI, talent retention, ESG, strategic dependency, market positioning.

**What executives care about:**
- Are we falling behind competitors on AI capability?
- What is our risk exposure — regulatory, reputational, operational?
- What is the return on our AI investment?
- Are we attracting and retaining the team members we need?

**AI adoption signals at this floor:**
- DORA Elite band achievement (or trajectory toward it)
- Time-to-market for new network capabilities (year-over-year)
- Responsible AI compliance status (regulatory risk surface)
- Team Member retention rate (is AI adoption a talent attractor or a source of attrition?)
- Competitive benchmark: where does our AI capability sit relative to industry peers?

**What to communicate to this floor:**
The Executive Summary (`executive-summary.md`) is the primary vehicle. One page maximum. Lead with DORA band. Follow with responsible AI compliance. Close with the ask or decision required.

**The responsible AI message at this floor:**
- Privacy: GDPR and sector-specific regulatory compliance — what is our exposure?
- Security: supply chain risk posture — does our board-level risk register include AI supply chain?
- Environment: SCI metric included in ESG reporting — what is the trend, and is it defensible?
- Market concentration: strategic dependency risk — are we locked in to a vendor whose pricing, terms, or availability we do not control?
- Global transformation: workforce transition narrative — what is our public and internal story about AI and engineering employment?

---

## Translation Guide

The same engineering reality sounds different at each floor. This table is the core translation reference for AI champions and engineering managers preparing stakeholder communications.

| Ground Truth | Floor 1 (Team Member) | Floor 2 (Tech Lead) | Floor 3 (Architect) | Floor 4 (Eng. Manager) | Floor 5 (CTO/Board) |
|---|---|---|---|---|---|
| Copilot generates YANG stubs from schema comments | "I use Copilot to draft YANG modules; `pyang` validates them before I commit" | "Test coverage on YANG-related changes is up 20%; review cycle time down 1.5 days" | "YANG fitness function pass rate improved from 78% to 94%; SoC violations stable" | "Lead time for YANG changes dropped from 5 days to 2 days; change failure rate unchanged" | "Network feature delivery speed improved 60% quarter-on-quarter" |
| AI code acceptance rate is 32% | "About 1 in 3 Copilot suggestions is useful — I'm selective, which takes discipline" | "SPACE-A (Activity) shows 32% acceptance; SPACE-P (Performance) shows 15% lower post-merge bug rate — selective use is the right posture" | "AI is operating within service boundaries; no SoC violations in AI-assisted PRs this quarter; 32% acceptance indicates team members are applying architectural judgement" | "DORA lead time improved 18%; rework rate stable at 6%; AI is adding measurable value while maintaining quality" | "Team velocity up; defect rate stable; AI investment is performing as expected" |
| A prompt template for NSO device template generation is in the library | "The NSO template prompt saves me 45 minutes per device profile" | "NSO device template velocity up 3x this sprint; no increase in rework" | "Template enforces TM Forum resource naming; ADR-007 documents the decision" | "Automation of NSO template generation contributed to 2-day reduction in provisioning lead time" | "Time-to-provision new network elements reduced; competitive capability improving" |
| SCI measurement started this quarter; baseline is 140 gCO₂e per team member per sprint | "I now check model size before choosing which AI feature to use" | "SCI baseline established: 140 gCO₂e/team member/sprint; target is 10% reduction next quarter" | "Model selection ADR (ADR-009) documents SCI-aware tooling choices; fitness function for model size added to CI" | "ESG input ready: AI tooling SCI baseline established; improvement trajectory planned for Q3" | "ESG reporting now includes AI carbon footprint; baseline established; improvement plan in place" |
| One team member finds Copilot slows them down on complex YANG `must` expressions | "Copilot is unreliable on `must` constraint logic — I turn it off for that task" | "Jagged frontier map updated: `must` expressions flagged as AI-weak zone; PR checklist updated" | "YANG constraint fitness function added to catch AI-suggested `must` expression errors; ADR-008 documents the boundary" | "Responsible AI risk register updated: YANG constraint generation excluded from AI-assisted workflow pending further evaluation" | "Quality guardrails in place; AI is deployed where it adds value and excluded where it introduces risk" |

---

## The Responsible AI Elevator Pitch

For each of the five responsible AI dimensions, the table below shows how the same underlying concern is communicated appropriately at each floor. AI champions and engineering managers should use this when preparing floor-specific briefings.

### Privacy

| Floor | Message |
|---|---|
| Floor 1 | "Use the data classification card. Green data only in prompts. No customer identifiers, no network topology data, no credentials. If in doubt, ask." |
| Floor 2 | "Sprint audit: zero amber/red data in prompts this sprint. SPACE-S survey: team members report confidence in privacy rules (4.1/5.0)." |
| Floor 3 | "Data flow ADR (ADR-003) documented. AI API boundary is outside our data trust boundary. Prompt content is not persisted beyond session under our enterprise agreement." |
| Floor 4 | "Privacy compliance status: green. No data incidents this quarter. Data Processing Agreement with Copilot Business vendor reviewed and current." |
| Floor 5 | "GDPR and sector regulatory compliance maintained. No privacy incidents. Vendor data processing agreement reviewed annually. Risk: low." |

### Security

| Floor | Message |
|---|---|
| Floor 1 | "SAST gate runs on every PR. AI-generated code goes through the same gate as hand-written code. Do not accept suggestions that handle credentials or network device secrets." |
| Floor 2 | "SAST pass rate on AI-assisted PRs: 98.7% (vs. 98.2% on manual PRs). Two AI-specific false positives investigated and resolved." |
| Floor 3 | "Supply chain security ADR (ADR-005) documents our review standard for AI-generated code. AI-generated code is treated as third-party code: reviewed, not trusted." |
| Floor 4 | "Security posture maintained. AI supply chain risk item added to risk register (residual risk: low, monitored quarterly). SAST gate coverage: 100%." |
| Floor 5 | "AI supply chain risk is on the board risk register. Mitigation: SAST gates, code review standard, vendor security review. Residual risk assessed as low." |

### Environmental (SCI)

| Floor | Message |
|---|---|
| Floor 1 | "Model sizing guide is on Confluence: use the smallest model that does the job. Copilot autocompletion is fine for stubs; only invoke large models for complex reasoning." |
| Floor 2 | "SCI sprint trend: 140 → 138 → 135 gCO₂e/team member/sprint. Heading in the right direction. Model sizing guide adoption: 80% of team members." |
| Floor 3 | "Model selection fitness function added to CI (ADR-009). Large model invocations logged and reviewed monthly. SCI metric integrated into DORA dashboard." |
| Floor 4 | "SCI trend: improving. Q2 baseline 140 gCO₂e/team member/sprint. Target: 126 by Q4. ESG reporting input prepared." |
| Floor 5 | "AI tooling carbon footprint is measured, baselined, and improving. SCI metric included in annual ESG report. Trajectory: 10% reduction per annum." |

### Market Concentration

| Floor | Message |
|---|---|
| Floor 1 | "The OSS alternatives register is on the wiki. When Copilot is unavailable or unsuitable, here are the fallbacks. Know them." |
| Floor 2 | "Vendor concentration: 74% of AI-assisted workflow runs through one provider. OSS alternatives active for test generation and commit messages. Monitoring." |
| Floor 3 | "Architectural dependency map maintained. Single-vendor critical path identified: code completion. Mitigation: OSS fallback documented in ADR-006. Review trigger: vendor pricing change > 20% or availability SLA miss." |
| Floor 4 | "Vendor concentration risk: amber. 74% of AI workflow on single vendor. Mitigation plan in place. Strategic review scheduled for Q4 if concentration exceeds 80%." |
| Floor 5 | "AI vendor concentration risk is managed. Current exposure: 74% on single provider. Mitigation: OSS alternatives maintained. Strategic review trigger defined. Risk: amber, monitored." |

### Global Transformation

| Floor | Message |
|---|---|
| Floor 1 | "Your role is expanding, not disappearing. AI handles scaffolding and boilerplate; you provide the engineering judgement, the architectural decisions, the domain knowledge. The prompt library is a skill, not a replacement for skill." |
| Floor 2 | "Reskilling: 9.2 hours/team member this sprint. SPACE-S sentiment on career impact: 3.9/5.0 (improving). Two team members completed the AI-assisted test design module." |
| Floor 3 | "Skills architecture review: AI adoption is building, not eroding, core competencies. YANG expertise still required to validate AI-generated modules. TM Forum knowledge required to catch AI misalignments." |
| Floor 4 | "Reskilling investment: [X] hours/team member/quarter against a target of 8. Retention: no AI-related departures. Talent attraction: two recent hires cited AI programme as a factor in joining." |
| Floor 5 | "Workforce transition narrative is coherent and evidence-based. Reskilling investment is funded. Retention metrics stable. AI is being positioned as a capability multiplier, not a headcount reduction lever. Talent pipeline impact: positive." |

---

## Using This Document

**For AI Champions and Tech Leads:** Use the Five Floors descriptions to calibrate your language in each communication context. Use the Translation Guide when preparing sprint reports or retrospective summaries.

**For Engineering Managers:** Use the Responsible AI Elevator Pitch section when preparing quarterly reports and responsible AI audit updates. The right message at the right floor prevents both under-reporting (hiding problems) and over-escalation (alarming executives with engineering-level detail that has already been addressed).

**For Architects:** Use the Floor 3 signals and ADR references to ensure that AI adoption decisions are being governed transparently. Every significant AI tooling or model boundary decision should have an ADR.

**For Executives:** The document you receive from the engineering manager — the Executive Summary — is the penthouse version. This document explains where it comes from and what it is built on. If you want to go deeper, ask for the Quarterly Review. If you want to go deeper still, ask for the DORA dashboard and the SPACE scores.

---

*Connected documents: `executive-summary.md` (penthouse output), `quarterly-review.md` (engine room input)*
*Measurement backbone: DORA (Forsgren, Humble, Kim — "Accelerate", 2018) + SPACE (Forsgren et al., 2021)*
*Elevator model: Hohpe, G. — "The Software Architect Elevator" (2020)*
