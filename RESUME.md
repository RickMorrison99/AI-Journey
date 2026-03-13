# O&A AI-Agentic Adoption Journey — Resume File
> **Last updated:** 2026-03-13
> **Status:** ✅ COMPLETE — 17/17 todos done

---

## How to Resume in a New Copilot Session

Paste this to Copilot when starting a new session:

```
I'm resuming the "AI-Agentic Adoption Journey" project for a telecom software team
called "OSS - Orchestration and Automation" (10–30 team members). The full plan is at
~/noa-ai-adoption/RESUME.md — please read it and pick up where we left off.
The next step is to start implementing. The 7 todos currently ready to work on are:
baseline-survey, maturity-model, msd-foundations, dora-baseline,
responsible-ai-risks, tmforum-api-first, and governance-guide.
```

---

## Project Summary

**Goal:** Create a complete AI-Agentic Adoption Framework for the O&A team that:
- Defines a dual-axis maturity model (AI adoption depth × MSD health)
- Provides tool playbooks tailored to telecom (YANG/NETCONF, Ansible, NSO, Python/Go)
- Establishes KPIs using validated frameworks (DORA + SPACE by Nicole Forsgren)
- Addresses five responsible AI risk dimensions (privacy, security, environment, market concentration, global transformation)
- Connects to TM Forum standards (eTOM, TAM, ODA, Open APIs) and enforces DRY/SoC/API-first
- Delivers a MkDocs documentation site (Confluence-ready) with stakeholder reporting

**Output:** MkDocs site at `~/noa-ai-adoption/docs/` (to be built)

---

## Guiding Thought Leaders

### Engineering & Delivery
| Thinker | Key Contribution |
|---|---|
| Dave Farley *(Modern Software Engineering, Continuous Delivery)* | Fast feedback loops, TDD, CI/CD backbone, proxy metric caution |
| Martin Fowler *(Refactoring, Evolutionary Architecture)* | Evolutionary architecture, fitness functions, refactoring culture, trunk-based dev |
| Gregor Hohpe *(The Architect Elevator, Enterprise Integration Patterns)* | Architect Elevator, API-centric, avoid lift-and-shift AI adoption |
| Holly Cummins *(Cloud Native, Sustainable Software)* | Cognitive load, sustainable pace, developer joy, sustainability first-class |
| Nicole Forsgren *(Accelerate, DORA, SPACE)* | DORA metrics + SPACE framework — the validated measurement backbone |
| Gene Kim & Jez Humble *(DevOps Handbook, Accelerate)* | AI adoption is sociotechnical — people/process failure > tooling failure |
| Ethan Mollick *(Co-Intelligence)* | Jagged frontier: map AI strengths/weaknesses; domain expertise amplification |
| Sam Newman *(Building Microservices)* | API-first, service boundaries, DRY/SoC as guards against drift |

### Responsible AI, Ethics & Sustainability
| Thinker | Key Contribution |
|---|---|
| Timnit Gebru *(Stochastic Parrots, DAIR)* | AI limitations, bias, environmental costs, danger of uncritical adoption |
| Kate Crawford *(Atlas of AI)* | Power/market concentration, material costs, labor and equity impacts |
| Anne Currie *(Green Software Foundation)* | SCI metric, carbon-aware model choice, AI carbon is measurable & manageable |

---

## 21 Core Principles

**Delivery & Engineering**
1. Fast Feedback Loops (Farley)
2. Always Releasable (Farley/Fowler)
3. Evolutionary Architecture (Fowler/Hohpe)
4. Cognitive Load as a Metric (Cummins)
5. The Architect Elevator (Hohpe)
6. Technical Excellence Non-Negotiable (Farley/Fowler)
7. Sustainable Pace (Cummins/XP)
8. Evidence-Based Measurement (Forsgren)
9. Productivity is Multi-Dimensional / SPACE (Forsgren)
10. Sociotechnical Transformation (Kim/Humble)
11. Jagged Frontier Awareness (Mollick)
12. Service Contract Integrity (Newman)

**Engineering Excellence**
13. DRY — shared prompt templates, duplication review in PRs
14. Separation of Concerns — AI scoped to single service/module, cross-boundary changes human-reviewed
15. API & Spec First — check TM Forum Open APIs before generating; spec before code
16. Model-Driven — YANG/OpenAPI/AsyncAPI are source of truth; AI generates conforming implementations

**Responsible AI**
17. Privacy by Design — no PII/network config in public LLMs
18. Security as a Gate — SAST/DAST/SCA on all AI code; OWASP LLM Top 10
19. Environmental Accountability — SCI metric tracked; right-size model to task
20. Market Concentration Awareness — no single-vendor lock-in; OSS alternatives evaluated
21. Global Transformation Responsibility — augmentation not replacement; reskilling > displacement

---

## Five Responsible AI Risk Dimensions

### 1. Privacy
- No customer data, network configs, credentials, or PII in public LLM prompts
- Enterprise-licensed instances with contractual data isolation (Copilot Business, Azure OpenAI no-training)
- Audit log review quarterly; prompt hygiene checklist in PR template
- Ref: GDPR Art. 25, TM Forum Privacy Guidelines

### 2. Security
- All AI-generated code passes SAST/DAST/SCA — no exceptions
- Agentic output treated as untrusted until pipeline validates
- OWASP LLM Top 10 reviewed quarterly; prompt injection is an ops threat
- Measure: SAST finding rate in AI PRs vs baseline
- Ref: OWASP LLM Top 10, NIST AI RMF

### 3. Environmental Costs
- Right-size model to task (smallest capable model)
- Track Software Carbon Intensity (SCI) per sprint from day 1
- Ref: Green Software Foundation SCI Spec (Anne Currie, Holly Cummins)

### 4. Market Concentration
- No single AI vendor for critical workflows
- Evaluate OSS alternatives: Llama, Mistral, CodeLlama, Granite
- Prefer OpenAI API-compatible interfaces for portability
- Document exit criteria per tool in ADRs
- Ref: Kate Crawford "Atlas of AI", Gregor Hohpe on platform strategy

### 5. Global Transformation & Workforce Impact
- Augmentation not replacement — communicate transparently
- Mandatory reskilling investment alongside tool adoption
- SPACE-S tracking for AI anxiety signals
- Psychological safety is prerequisite for honest AI feedback
- Ref: Crawford/Gebru on labor, Gene Kim on transformation, Mollick on reskilling

---

## TM Forum & Engineering Excellence

### Frameworks
| Framework | Role |
|---|---|
| eTOM | Map AI use cases to process domains (Fulfillment, Assurance, Billing, Operations) |
| TAM | Validate AI-generated components against application capability map |
| ODA | Target operating model; position AI capabilities on ODA canvas |
| TM Forum Open APIs (700+) | **Check before generating** — AI implements conformant clients/servers |
| SID | Validate AI-generated data models against telecom domain model |

### Engineering Rules (in every playbook)
- **DRY:** Shared prompt template library in team repo; PR review includes duplication check
- **SoC:** AI given explicit scope in agentic system prompts; cross-boundary = human review
- **API-first:** TM Forum lookup → internal API check → YANG/OpenAPI spec → then generate code
- **Model-driven:** YANG → AI-generated Python/Go stubs; eTOM IDs in code comments; ADRs for AI-assisted decisions

---

## 7-Phase Delivery Plan

| Phase | What Gets Built |
|---|---|
| 1 — Baseline & Maturity Model | Dual-axis model (AI × MSD) + TM Forum alignment + responsible AI posture |
| 2 — MSD & Engineering Foundations | CI/CD, TDD, DORA baseline, DRY/SoC/API-first guide |
| 3 — Responsible AI & Risk Framework | Five dimensions with rules, gates, and measurement |
| 4 — Adoption Roadmap | 5 stages (Aware → Optimizing) with MSD prereqs + responsible AI gates |
| 5 — Tool Playbooks | Copilot, Agentic, LLM Chat, Custom Pipelines (DRY/SoC/TM Forum checklist in each) |
| 6 — Measurement Framework | DORA + SPACE + AI metrics + SCI + security metrics + templates |
| 7 — Documentation Site | MkDocs site (34 pages, 8 sections), Architect Elevator stakeholder pack |

---

## All 17 Todos

### ✅ Ready to Start (no dependencies)

| ID | Title | Full Description |
|---|---|---|
| `baseline-survey` | Design baseline assessment survey | Design survey covering AI tool usage AND MSD health. AI section: tools in use, frequency, use cases, blockers, skill confidence. MSD section: CI/CD health self-assessment, testing practices, deployment frequency, trunk-based dev. Establishes Day-1 baseline for both axes of the maturity model. |
| `maturity-model` | Define dual-axis maturity model | 5-level model on two axes: (1) AI Adoption (Unaware→Experimenting→Practicing→Scaling→Optimizing), (2) MSD health (CI/CD, testing, flow). Key insight: cannot reach AI level 4 on MSD level 1. Descriptors per level for people, process, tooling, MSD prerequisites. |
| `msd-foundations` | Write MSD + engineering foundations guide | CI/CD pipeline health (Farley), testing pyramid + TDD (Farley/Fowler), trunk-based dev, DORA baseline (Forsgren), evolutionary architecture + fitness functions (Fowler/Hohpe), cognitive load (Cummins). Plus: DRY, SoC, API-first, model-driven development. AI as accelerant of each. |
| `dora-baseline` | Define DORA + SPACE framework baseline | DORA: deployment frequency, lead time, MTTR, change failure rate — baseline, Elite targets, collection approach. SPACE: O&A-specific indicators for all 5 dimensions. Forsgren governance rule: Activity metrics never in isolation. |
| `responsible-ai-risks` | Write Responsible AI risk framework | Five dimensions with rules + indicators + gates: Privacy (data classification, prompt hygiene), Security (OWASP LLM Top 10, SAST gates), Environmental (SCI metric, CO₂e tracking), Market Concentration (vendor lock-in, OSS alternatives), Global Transformation (reskilling, psychological safety). |
| `tmforum-api-first` | Write TM Forum + engineering principles guide | eTOM/TAM/ODA/Open APIs reference; spec-first workflow (YANG → AI code, OpenAPI before implementation, YANG CI gate); DRY prompt template library; SoC scope boundaries; ADR template for AI-assisted architectural decisions. |
| `governance-guide` | Write team norms, champion role, and PR checklist | AI champion role (growth opp, not surveillance); PR checklist (DRY check, SoC check, TM Forum API lookup, SAST pass, responsible AI review); psychological safety norms; prompt library practices; retro AI section. |

### ⏳ Blocked (dependencies listed)

| ID | Title | Blocked By |
|---|---|---|
| `adoption-stages` | Define adoption stages with MSD + responsible AI prerequisites | maturity-model, msd-foundations, dora-baseline, responsible-ai-risks, tmforum-api-first |
| `tool-inventory` | Catalog AI tools with O&A use cases, TM Forum fit, risk profile | baseline-survey, tmforum-api-first |
| `playbook-copilot` | GitHub Copilot playbook for O&A | tool-inventory, responsible-ai-risks |
| `playbook-agentic` | Agentic tools playbook (Copilot CLI/Workspace/Devin) | tool-inventory, responsible-ai-risks |
| `playbook-llm-chat` | LLM chat tools guide | tool-inventory, responsible-ai-risks |
| `playbook-custom` | Custom AI pipeline guide | tool-inventory, responsible-ai-risks |
| `kpi-framework` | KPI framework (DORA + SPACE + AI + SCI + security) | dora-baseline |
| `measurement-templates` | Self-reporting templates + pipeline + SCI metrics guide | kpi-framework |
| `stakeholder-pack` | Stakeholder summary (Architect Elevator format) | kpi-framework |
| `mkdocs-site` | Scaffold and populate MkDocs documentation site | ALL of the above |

---

## MkDocs Doc Site Structure (to be built at ~/noa-ai-adoption/docs/)

```
docs/
├── index.md
├── philosophy.md                       # 11 thinkers + 21 principles
├── maturity-model.md
├── adoption-roadmap.md
├── msd-foundations/
│   ├── index.md
│   ├── cicd-pipeline.md
│   ├── testing-discipline.md
│   ├── evolutionary-architecture.md
│   ├── trunk-based-dev.md
│   ├── cognitive-load.md
│   └── engineering-principles.md       # DRY, SoC, API-first, model-driven
├── tmforum/
│   ├── index.md
│   ├── etom-tam-oda.md
│   ├── open-apis.md
│   └── spec-first.md
├── tools/
│   ├── index.md                        # Jagged frontier map (Mollick)
│   ├── github-copilot.md
│   ├── agentic-tools.md
│   ├── llm-chat.md
│   └── custom-pipelines.md
├── responsible-ai/
│   ├── index.md
│   ├── privacy.md
│   ├── security.md
│   ├── environmental.md
│   ├── market-concentration.md
│   └── global-transformation.md
├── measurement/
│   ├── index.md                        # DORA + SPACE philosophy
│   ├── dora-metrics.md
│   ├── space-framework.md
│   ├── ai-adoption-kpis.md
│   ├── environmental-metrics.md
│   ├── self-reporting.md
│   └── pipeline-telemetry.md
├── governance/
│   ├── team-norms.md
│   └── adr-template.md
└── stakeholders/
    ├── architect-elevator.md
    ├── executive-summary.md
    └── quarterly-review.md
```

---

## Key Measurement Framework

### DORA (Forsgren/Humble/Kim — "Accelerate")
Target: Medium → High → **Elite**

| Metric | AI Hypothesis |
|---|---|
| Deployment Frequency | AI code review + test gen → ships more often |
| Lead Time for Changes | AI reduces authoring + review time |
| MTTR | AI-assisted incident triage + runbooks |
| Change Failure Rate | AI-generated tests + security scanning |

### SPACE (Forsgren et al. 2021)
**Never show Activity alone.** Always all five:
- **S**atisfaction & Well-being — retro surveys, eNPS pulse
- **P**erformance — bug escape rate, rework rate
- **A**ctivity — PRs, AI acceptance rate *(context only)*
- **C**ommunication — review cycle time, doc contributions
- **E**fficiency/Flow — unplanned work ratio, flow surveys

### Additional
- **SCI** (Software Carbon Intensity) — per sprint, from day 1
- **Security** — SAST finding rate in AI PRs vs baseline
- **Market concentration index** — % workflows on single vendor
- **Reskilling hours** — per team member per quarter

---

*Plan file: `~/.copilot/session-state/e6de6385-0a3a-4f42-92ae-ae2c8c99541e/plan.md`*
*Session DB: session `e6de6385-0a3a-4f42-92ae-ae2c8c99541e` (todos tracked in SQLite)*
