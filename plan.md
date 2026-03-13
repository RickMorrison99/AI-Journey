# AI-Agentic Adoption Journey
### Team: OSS - Orchestration and Automation (Telecom SW Dev)

---

## Problem Statement

The OSS - Orchestration and Automation team (10–30 team members) is in an exploratory phase with AI tools — a few individuals are informally experimenting with GitHub Copilot and ChatGPT, but there is no structured adoption approach, no shared practices, and no way to measure progress or value.

This project creates a complete AI-Agentic Adoption Framework that:
- Defines a maturity model and adoption stages for the team
- Provides playbooks and guides for each AI tool category
- Establishes KPIs and measurement practices to track adoption and impact
- Grounds AI adoption in **Modern Software Delivery** principles so AI amplifies good engineering — not shortcuts around it
- Produces stakeholder-ready reporting artifacts
- Lives in a structured doc site (MkDocs / Confluence-ready)

---

## Guiding Philosophy: Modern Software Delivery First

> *"AI tools are an accelerant. What they accelerate depends entirely on the engineering foundation beneath them."*

The framework is grounded in Modern Software Delivery (MSD) thinking from leading practitioners:

### Engineering & Delivery

| Thinker | Key Contribution to This Framework |
|---|---|
| **Dave Farley** *(Modern Software Engineering, Continuous Delivery)* | Fast feedback loops, TDD as discipline, CI/CD pipeline as the backbone, "always releasable" as the bar; proxy metric caution |
| **Martin Fowler** *(Refactoring, Evolutionary Architecture, CI)* | Evolutionary architecture with fitness functions, refactoring culture, trunk-based development, testing pyramid |
| **Gregor Hohpe** *(The Architect Elevator, Enterprise Integration Patterns)* | Architect elevator: AI literacy must span from engine room to penthouse; platform thinking; API-centric architecture; avoiding "lift-and-shift" AI adoption |
| **Holly Cummins** *(Cloud Native, Sustainable Software, Developer Experience)* | Cognitive load reduction, sustainable pace, developer joy as a metric, cloud-native patterns; sustainability as a first-class concern |
| **Nicole Forsgren** *(Accelerate, DORA, SPACE Framework)* | The measurement backbone: DORA metrics as the validated evidence base for engineering performance; SPACE framework for holistic developer productivity; caution against single-dimension metrics |
| **Gene Kim & Jez Humble** *(DevOps Handbook, Phoenix Project, Accelerate)* | DevOps transformation patterns and change management; value stream thinking; AI adoption is fundamentally a sociotechnical transformation, not a tooling exercise |
| **Ethan Mollick** *(Co-Intelligence, One Useful Thing)* | The "jagged frontier" of AI capability — AI is superhuman in some areas, surprisingly weak in others; treat AI as a talented new colleague, not a search engine; domain expertise amplification over replacement |
| **Sam Newman** *(Building Microservices, Monolith to Microservices)* | API-first design, strong service boundaries; AI-generated code must respect service contracts; SOC and DRY as guards against AI-introduced architectural drift |

### Responsible AI, Ethics & Sustainability

| Thinker | Key Contribution to This Framework |
|---|---|
| **Timnit Gebru** *(Stochastic Parrots, DAIR Institute)* | AI limitations and documented harms; bias and representational failures in LLMs; environmental cost of large-scale model training; the danger of uncritical "move fast" AI adoption in professional contexts |
| **Kate Crawford** *(Atlas of AI)* | Power and market concentration; material and environmental costs of AI infrastructure; labor and global equity impacts; AI is never "just a tool" — it embeds political and economic choices |
| **Anne Currie** *(Green Software Foundation, Sustainable Software)* | Software Carbon Intensity (SCI) metric; carbon-aware and energy-efficient AI usage; right-sizing model choice to task; operational AI has a measurable and manageable carbon footprint |

### Core Principles Woven Into This Framework

**Delivery & Engineering**
1. **Fast Feedback Loops** (Farley) — AI tools evaluated by whether they shorten or lengthen feedback cycles
2. **Always Releasable** (Farley/Fowler) — AI-assisted code must meet the same CI/CD quality gates; no bypassing the pipeline
3. **Evolutionary Architecture** (Fowler/Hohpe) — AI adoption itself follows fitness functions; AI-assisted architectural decisions are logged as ADRs
4. **Cognitive Load as a Metric** (Cummins) — AI adoption is successful when it *reduces* cognitive load, not just increases output
5. **The Architect Elevator** (Hohpe) — Adoption strategy connects ground-level tooling to architectural and business outcomes
6. **Technical Excellence is Non-Negotiable** (Farley/Fowler) — AI accelerates good practices (TDD, clean code, refactoring); it doesn't replace them
7. **Sustainable Pace** (Cummins/XP) — Adoption measured by sustained improvement, not a spike
8. **Evidence-Based Measurement** (Forsgren) — DORA + SPACE as the validated frameworks; resist vanity metrics
9. **Productivity is Multi-Dimensional** (Forsgren/SPACE) — All five SPACE dimensions must be tracked together
10. **Sociotechnical Transformation** (Kim/Humble) — AI adoption succeeds or fails at the people-and-process layer, not the tooling layer
11. **Jagged Frontier Awareness** (Mollick) — Map where AI capability is strong vs weak for O&A-specific tasks before trusting it for any given job
12. **Service Contract Integrity** (Newman) — AI-generated code must not violate API contracts or service boundaries; automated contract tests are mandatory

**Engineering Excellence**
13. **DRY (Don't Repeat Yourself)** — Reusable prompt templates, shared AI patterns, and generated code reviewed for duplication; AI must not make codebases *more* repetitive
14. **Separation of Concerns (SoC)** — AI tools must work within, not across, service and module boundaries; AI-suggested refactors reviewed for boundary violations
15. **API & Spec First** (Hohpe/Newman) — Consume or extend existing TM Forum Open APIs and YANG/OpenAPI specs *before* generating new code; AI assists in spec authoring, not spec bypassing
16. **Model-Driven where possible** — YANG models, OpenAPI/AsyncAPI specs and eTOM/TAM process models are the source of truth; AI generates conforming implementations from specs

**Responsible AI**
17. **Privacy by Design** — No PII, customer data, or network config in public LLMs; data minimization in any AI pipeline
18. **Security as a Gate, not a Suggestion** (Gebru/OWASP) — AI-generated code passes the same SAST/DAST/supply-chain gates; prompt injection and model poisoning are operational threats
19. **Environmental Accountability** (Currie/Cummins) — Model choice is an energy/carbon decision; SCI metric tracked alongside engineering metrics
20. **Market Concentration Awareness** (Crawford) — Avoid single-vendor lock-in; open-source model alternatives evaluated; multi-provider strategy preferred
21. **Global Transformation Responsibility** (Crawford/Gebru) — AI adoption communicates transparently with the team about workforce impact; reskilling > replacement mindset

---

## Scope

**In scope:**
- GitHub Copilot (coding assistant)
- Agentic tools (Copilot CLI, Copilot Workspace, Devin, etc.)
- LLM chat tools (ChatGPT, Claude, Gemini) for engineering workflows
- Custom AI pipelines / internal tooling
- Telecom-specific use cases (network automation, YANG/NETCONF, config gen, test gen, incident response)

**Out of scope (for now):**
- Procurement / licensing decisions
- MLOps / model training
- Customer-facing AI features

---

## Responsible AI — Five Risk Dimensions

These are first-class concerns in the framework, not appendix items. Each has a governance rule, a measurement indicator, and a playbook note.

### 1. Privacy
- **Risks**: PII exposure via LLM prompts, network topology/config data leaking into cloud models, training data contamination, prompt history logging by vendors
- **Rules**: No customer data, network configs, credentials, or PII in any public LLM prompt; use enterprise-licensed instances with contractual data isolation (e.g., GitHub Copilot Business, Azure OpenAI with no-training agreements)
- **Measurement**: Audit log review (quarterly), prompt hygiene checklist in PR template, data classification policy adherence
- **Reference**: GDPR Article 25 (Privacy by Design), TM Forum Privacy Guidelines

### 2. Security
- **Risks**: AI-generated code with subtle vulnerabilities (SQL injection, insecure deserialization, hardcoded secrets), supply chain attacks via AI-suggested dependencies, prompt injection in agentic systems, data exfiltration via LLM context windows
- **Rules**: All AI-generated code passes the same SAST/DAST/SCA gates as human code — no exceptions; agentic tool outputs treated as untrusted until pipeline validates; OWASP LLM Top 10 reviewed quarterly
- **Measurement**: SAST finding rate in AI-assisted PRs vs baseline, dependency vulnerability rate, security review cycle time
- **Reference**: OWASP LLM Top 10, NIST AI Risk Management Framework

### 3. Environmental Costs
- **Risks**: Unconstrained LLM usage has significant energy and carbon costs; large frontier models (GPT-4, Claude) use orders of magnitude more energy than smaller/local models for equivalent tasks; the O&A team's aggregate inference cost is measurable and manageable
- **Rules**: Right-size model to task — use the smallest capable model; prefer local/on-premise models for repetitive tasks; track Software Carbon Intensity (SCI) for AI workloads; include AI carbon footprint in quarterly review
- **Measurement**: SCI score (Green Software Foundation standard), estimated CO₂e per sprint from AI tool usage, model size distribution across team usage
- **Reference**: Green Software Foundation SCI Specification, Anne Currie's sustainable software principles, Holly Cummins' cloud carbon work

### 4. Market Concentration
- **Risks**: Over-dependence on 1–2 hyperscaler AI vendors creates strategic risk (pricing power, capability gating, terms changes, geopolitical risk); "lift-and-shift" to AI tools mirrors the same cloud lock-in mistakes of the 2010s
- **Rules**: No single AI vendor dependency for critical workflows; evaluate open-source alternatives (Llama, Mistral, CodeLlama, Granite) for each use case; architecture decisions record vendor choices and exit criteria; prefer open standards (OpenAI API-compatible interfaces) for portability
- **Measurement**: Vendor concentration index (% of team's AI workflows running on a single provider), OSS model adoption %, documented exit path per tool
- **Reference**: Kate Crawford "Atlas of AI", Gregor Hohpe on platform strategy and avoiding lock-in

### 5. Global Transformation & Workforce Impact
- **Risks**: Team anxiety about job displacement; uneven AI adoption creating two-tier workforce; deskilling in areas delegated too fully to AI; global telecom workforce displacement without reskilling investment
- **Rules**: Transparent communication about AI adoption goals — augmentation not replacement; mandatory reskilling investment alongside tool adoption; "AI champion" role is a growth opportunity, not surveillance; psychological safety is prerequisite for honest feedback on AI tools
- **Measurement**: SPACE-S (Satisfaction) tracking for AI anxiety signals, reskilling hours invested per team member, voluntary attrition rate during adoption, team retrospective sentiment
- **Reference**: Kate Crawford/Timnit Gebru on labor and power, Gene Kim on psychological safety in transformation, Ethan Mollick on reskilling and domain expertise

---

## TM Forum & Engineering Excellence

The O&A team operates in the telecom domain. The framework explicitly connects to TM Forum standards and enforces core software engineering principles as guards against AI-introduced technical debt.

### TM Forum Frameworks (API & Spec First)

| Framework | Role in AI Adoption |
|---|---|
| **eTOM** *(Business Process Framework)* | AI use cases map to eTOM process domains (Fulfillment, Assurance, Billing, Operations); prevents AI from solving problems the wrong way in the wrong process |
| **TAM** *(Application Framework)* | AI-generated components validated against TAM application capability map; prevents architectural sprawl |
| **ODA** *(Open Digital Architecture)* | Target operating model for telecom; AI tools and pipelines designed as ODA-compliant components; canvas used to position AI capabilities |
| **TM Forum Open APIs** *(700+ TMF REST APIs)* | **Consume before generating**: check if a TM Forum Open API already solves the problem before asking AI to write a new integration; AI assists in implementing conformant TMF API clients/servers |
| **SID** *(Shared Information/Data Model)* | AI-generated data models validated against SID to ensure telecom domain alignment |

### Engineering Principles (Enforced in All Playbooks)

These are non-negotiable in every AI-assisted workflow:

**DRY (Don't Repeat Yourself)**
- Shared prompt template library maintained in team repo — team members don't reinvent prompts
- AI-generated code reviewed specifically for duplication; LLMs tend to inline logic rather than reuse
- Common AI patterns (test fixtures, config stubs, YANG template helpers) extracted into shared libraries

**Separation of Concerns (SoC)**
- AI tools work within a single service/module context; cross-boundary changes always human-reviewed
- AI-suggested refactors reviewed by architect for SoC violations before merge
- Agentic tools given explicit scope boundaries in their system prompts (e.g., "do not modify the service interface layer")

**API & Spec First**
- Before asking AI to generate an integration: check TM Forum Open APIs, existing internal APIs, YANG modules
- OpenAPI / AsyncAPI specs authored *before* implementation code — AI generates conforming code from spec, not the reverse
- YANG model validation is a CI gate; AI-generated YANG reviewed against RFC compliance

**Model-Driven Development**
- YANG → Python/Go stubs generated (with AI assistance) from validated models
- eTOM process IDs referenced in code comments for traceability
- ADRs (Architectural Decision Records) generated with AI assistance but owned by humans

---

## Approach: 7-Phase Delivery

### Phase 1 — Baseline & Maturity Model
Assess MSD foundations *and* AI tool usage today. The maturity model has two axes: (1) AI Adoption depth, (2) MSD health. Also captures TM Forum alignment and current responsible AI posture. You can't reach AI maturity level 4 on an MSD level 1 foundation.

### Phase 2 — MSD & Engineering Foundations Guide
MSD baseline the team should achieve/maintain. Covers: CI/CD pipeline, testing pyramid, trunk-based development, DORA baseline, evolutionary architecture, and TM Forum API/spec-first practices. DRY, SoC, and API-first enforced here.

### Phase 3 — Responsible AI & Risk Framework
Five risk dimensions (privacy, security, environment, market concentration, global transformation) documented with rules, measurement indicators, and governance gates. Grounded in Gebru, Crawford, Currie, and OWASP/NIST frameworks.

### Phase 4 — Adoption Roadmap
Adoption stages (Aware → Experimenting → Practicing → Scaling → Optimizing) with MSD prerequisites, responsible AI gates, and TM Forum alignment checks per stage.

### Phase 5 — Tool Playbooks
Hands-on guides for each tool category, tailored to O&A workflows. Each playbook includes: CD pipeline fit, DRY/SoC/API-first checklist, TM Forum API lookup step, and responsible AI rules per tool.

### Phase 6 — Measurement Framework
DORA + SPACE as the validated backbone. AI metrics layered on top. Environmental (SCI), security, and privacy metrics included. Templates for self-reporting and pipeline telemetry.

### Phase 7 — Documentation Site
Full MkDocs site. "Architect Elevator" bridges ground-floor tooling to exec outcomes. Stakeholder pack connects AI investment to DORA movement, SCI, and workforce indicators.

---

## Todos

| ID | Title |
|----|-------|
| baseline-survey | Design baseline assessment survey (AI + MSD + TM Forum + responsible AI posture) |
| maturity-model | Define dual-axis maturity model (AI adoption × MSD health) |
| msd-foundations | Write MSD + engineering foundations guide (DRY, SoC, API-first, TM Forum) |
| dora-baseline | Define DORA + SPACE baseline and collection approach |
| responsible-ai-risks | Write Responsible AI risk framework (privacy, security, environment, market, transformation) |
| tmforum-api-first | Write TM Forum integration guide (eTOM, TAM, ODA, Open APIs, YANG/spec-first) |
| adoption-stages | Define adoption stages with MSD + responsible AI prerequisites |
| tool-inventory | Catalog AI tools in scope with use cases, TM Forum fit, and risk profile |
| playbook-copilot | Write GitHub Copilot playbook for O&A workflows |
| playbook-agentic | Write agentic tools playbook (Copilot CLI/Workspace/Devin) |
| playbook-llm-chat | Write LLM chat tools guide for engineering tasks |
| playbook-custom | Write custom AI pipeline guide |
| kpi-framework | Define KPI framework (DORA + SPACE + AI + SCI + security) |
| measurement-templates | Create self-reporting templates + pipeline + SCI metrics guide |
| governance-guide | Write team norms, AI champion role, and PR checklist |
| stakeholder-pack | Create stakeholder summary / exec reporting (Architect Elevator format) |
| mkdocs-site | Scaffold MkDocs site structure with all content |

---

## Key Metrics to Track

> *"Measure what matters, and only what matters. Measuring the wrong things — or too many things — is worse than measuring nothing."* — Nicole Forsgren

The measurement framework uses two validated research frameworks by Forsgren as its spine:

### DORA Metrics — Delivery Performance
*(Forsgren/Humble/Kim "Accelerate" — the research-validated indicators of high-performing teams)*

| Metric | What It Measures | AI Adoption Hypothesis |
|---|---|---|
| **Deployment Frequency** | How often code ships to production/staging | AI-assisted code review + test gen increases frequency |
| **Lead Time for Changes** | Commit → deployable artifact | AI reduces authoring and review time |
| **Mean Time to Restore (MTTR)** | Recovery time from incidents | AI-assisted incident triage and runbook generation reduces MTTR |
| **Change Failure Rate** | % of deployments causing incidents | AI-generated tests + security scanning reduces failures |

> Target: Use AI adoption as an instrument to move O&A team from **Medium → High → Elite** DORA performance bands.

### SPACE Framework — Developer Productivity
*(Forsgren et al., "The SPACE of Developer Productivity", 2021 — specifically designed to avoid single-metric traps)*

| Dimension | Definition | How Measured for O&A |
|---|---|---|
| **S**atisfaction & Well-being | Developer happiness, burnout risk, tool satisfaction | Sprint retro surveys, eNPS-style pulse |
| **P**erformance | Outcomes and quality of work (not output volume) | Bug escape rate, rework rate, DORA quality metrics |
| **A**ctivity | Volume of engineering actions | PRs, commits, AI acceptance rate (context only — never standalone) |
| **C**ommunication & Collaboration | Knowledge sharing, review quality, onboarding | PR review cycle time, doc contributions, pairing frequency |
| **E**fficiency & Flow | Ability to complete work with minimal interruption | Unplanned work ratio, flow state survey, context-switch frequency |

> **Forsgren's key warning (woven into governance):** Activity metrics (like lines of code or AI acceptance rate) must *never* be used in isolation. They only have meaning in the context of Performance and Satisfaction dimensions.

### AI Adoption Metrics
*(Layered on top of DORA + SPACE — not a replacement)*
- % of team members actively using at least one AI tool weekly
- Tool breadth per team member (depth of portfolio)
- AI code acceptance rate (Copilot telemetry — A dimension of SPACE)
- Test coverage delta attributed to AI-generated tests
- Agentic task delegation depth (trivial → complex classification)
- Agentic task completion rate without human correction
- Human-in-the-loop intervention rate over time

---

## MkDocs Site Structure

```
docs/
├── index.md                            # Overview & quick start
├── philosophy.md                       # All thinkers + 21 core principles
├── maturity-model.md                   # Dual-axis maturity model (AI × MSD)
├── adoption-roadmap.md                 # Stages + prerequisites + entry/exit criteria
├── msd-foundations/
│   ├── index.md                        # Why MSD foundations matter for AI adoption
│   ├── cicd-pipeline.md                # CI/CD pipeline health (Farley)
│   ├── testing-discipline.md           # Testing pyramid, TDD, AI-generated tests (Farley/Fowler)
│   ├── evolutionary-architecture.md    # Fitness functions, ADRs (Fowler/Hohpe)
│   ├── trunk-based-dev.md              # Trunk-based dev + AI commit hygiene
│   ├── cognitive-load.md               # Cognitive load as success metric (Cummins)
│   └── engineering-principles.md       # DRY, SoC, API-first, model-driven (Newman/Hohpe)
├── tmforum/
│   ├── index.md                        # TM Forum in the AI context
│   ├── etom-tam-oda.md                 # eTOM, TAM, ODA reference for O&A team
│   ├── open-apis.md                    # TM Forum Open APIs — lookup before generating
│   └── spec-first.md                   # YANG, OpenAPI, AsyncAPI spec-first workflow with AI
├── tools/
│   ├── index.md                        # Tool landscape + jagged frontier map (Mollick)
│   ├── github-copilot.md               # Copilot playbook
│   ├── agentic-tools.md                # Agentic tools playbook
│   ├── llm-chat.md                     # LLM chat guide
│   └── custom-pipelines.md             # Custom AI pipeline guide
├── responsible-ai/
│   ├── index.md                        # Five risk dimensions overview
│   ├── privacy.md                      # Privacy rules, data classification, prompt hygiene
│   ├── security.md                     # OWASP LLM Top 10, SAST gates, agentic security
│   ├── environmental.md                # SCI metric, carbon-aware model choice (Currie/Cummins)
│   ├── market-concentration.md         # Vendor lock-in risks, OSS alternatives, exit criteria
│   └── global-transformation.md        # Workforce impact, reskilling, psychological safety
├── measurement/
│   ├── index.md                        # Measurement philosophy (Forsgren: DORA + SPACE)
│   ├── dora-metrics.md                 # DORA definitions, targets, collection, performance bands
│   ├── space-framework.md              # SPACE dimensions, O&A-specific indicators, anti-patterns
│   ├── ai-adoption-kpis.md             # AI-specific KPIs (layered on DORA+SPACE)
│   ├── environmental-metrics.md        # SCI, CO₂e per sprint, model size distribution
│   ├── self-reporting.md               # Team Member self-reporting template (SPACE-aligned)
│   └── pipeline-telemetry.md           # Automated metrics from CI/CD + GitHub
├── governance/
│   ├── team-norms.md                   # Team agreements, champion role, PR checklist
│   └── adr-template.md                 # ADR template for AI-related architectural decisions
└── stakeholders/
    ├── architect-elevator.md           # Hohpe-style bridge: ground floor → penthouse
    ├── executive-summary.md            # Exec-ready summary (DORA + SCI + AI progress)
    └── quarterly-review.md             # Quarterly review template
```

---

## Notes & Considerations

- **MSD as prerequisite**: If CI/CD or testing discipline is poor, AI accelerates the mess. Farley is explicit — fix the pipeline first.
- **DORA as the north star**: AI should move O&A toward Elite performance bands. If it doesn't show up in DORA, it isn't delivering.
- **SPACE prevents perverse incentives**: Never present AI acceptance rate or commit volume as standalone wins (Forsgren). Always show all five SPACE dimensions together.
- **Ethan Mollick's jagged frontier**: Map the O&A-specific capability map early. AI is surprisingly strong at YANG boilerplate, test generation, and incident summary. It's weaker at novel architecture decisions and domain-specific protocol nuance. Don't delegate blindly.
- **Gene Kim on transformation**: The majority of AI adoption failures are sociotechnical, not technical. Psychological safety, transparent communication, and visible leadership commitment matter more than the tools.
- **TM Forum is the telecom contract**: Before generating any integration code, check TM Forum Open APIs. The spec is the source of truth; AI implements the spec, it doesn't replace it.
- **DRY and SoC are AI-specific risks**: LLMs tend to produce verbose, inlined, repetitive code. Every PR review must include an explicit DRY and SoC check. Build this into the PR template.
- **Environmental costs are non-trivial**: A team of 20 team members using GPT-4-class models heavily for a year has a measurable carbon footprint. Track it with SCI from sprint 1 (Currie).
- **Market concentration is a strategy risk**: The Big 3 (OpenAI/Microsoft, Google, Anthropic/Amazon) are in a land-grab. Telecom companies that build critical workflows on a single vendor's proprietary AI are replicating the worst cloud lock-in patterns. Design for portability from day 1 (Crawford/Hohpe).
- **Workforce transparency is non-negotiable**: Team Members who are anxious about AI will underreport problems and game metrics. Psychological safety surveys alongside SPACE-S are essential (Kim/Crawford/Gebru).
