# Responsible AI — Five Risk Dimensions

> **Status:** Living document · Owned by: O&A Engineering Lead + AI Champions  
> **Review cycle:** Quarterly · **Last reviewed:** _see git log_  
> **Applies to:** All team members, architects, and team leads in the O&A programme

---

## Why This Is a First-Class Engineering Concern

Responsible AI is not a compliance checkbox appended to a transformation programme after the real decisions have been made. It is an **engineering discipline** with the same standing as security, reliability, or performance — and it must be wired into the team's daily work from sprint 1.

Three reasons responsible AI is non-negotiable for O&A specifically:

1. **The blast radius is real.** O&A tooling automates changes to live carrier-grade networks. An AI-assisted misconfiguration, a leaked network topology prompt, or an over-trusted AI code suggestion can cause outages affecting thousands of end customers. The stakes are higher than a typical SaaS team.

2. **Data sensitivity is extreme.** Telecom network configurations contain IP addressing schemes, routing policies, device credentials, and topology information that, in the wrong hands, maps the logical and physical structure of a national or regional network. This is not generic enterprise data — it is infrastructure intelligence.

3. **The team's practices set precedent.** As an early adopter of AI-agentic tooling within the broader organisation, O&A's decisions — about which models to use, how to gate AI-generated code, how to communicate with team members about job impacts — will be cited, copied, and scaled. Getting this right matters beyond this team.

This section of the playbook establishes **five risk dimensions**. Each has clear rules, measurable indicators, and is grounded in the work of practitioners and researchers who have studied these problems seriously.

---

## The Five Risk Dimensions

### 1. 🔒 Privacy
**Protecting data in AI workflows**

The central risk is prompt leakage: customer data, network configurations, credentials, and proprietary IP being submitted to public LLM inference endpoints that log, retain, and potentially train on inputs. Telecom network config data is among the most sensitive enterprise data that exists. A single careless prompt can expose an entire network's addressing and topology.

→ [Privacy — Full Guidance](privacy.md)

---

### 2. 🛡️ Security
**AI-generated code is untrusted code**

LLMs generate plausible-looking code that contains real vulnerabilities: hardcoded credentials, overly permissive API calls, missing error handling, insecure defaults. In O&A's context, that code runs on or against network devices. Every line of AI-generated code must pass the same SAST/DAST/SCA pipeline gates as human-written code — with no exceptions and no fast lanes.

→ [Security — Full Guidance](security.md)

---

### 3. 🌍 Environmental
**Carbon-aware AI usage**

Model inference has a measurable energy and carbon cost. A 20-team member team routing all tasks through frontier models (GPT-4 class) generates a non-trivial annual carbon footprint. Model choice is an energy decision. The team tracks Software Carbon Intensity (SCI) from sprint 1 and right-sizes model selection to the task.

→ [Environmental Costs — Full Guidance](environmental.md)

---

### 4. 🏢 Market Concentration
**Avoiding AI lock-in**

Three hyperscalers currently control most frontier model access. Organisations that build critical workflows on a single vendor's proprietary API are repeating the cloud lock-in mistakes of the 2010s. O&A designs for portability from day 1: OpenAI API-compatible interfaces, an internal adapter layer, and an ADR requirement for every AI tool adoption decision.

→ [Market Concentration — Full Guidance](market-concentration.md)

---

### 5. 👥 Global Transformation
**People first**

Team Members who are anxious about displacement will underreport AI problems, game adoption metrics, and disengage from honest feedback — making the entire programme less safe and less effective. Psychological safety is a prerequisite for honest adoption data. The programme is explicitly an **augmentation** initiative, and that must be demonstrably true, not just stated.

→ [Global Transformation — Full Guidance](global-transformation.md)

---

## Traffic Light Quick-Reference

This table is a rapid decision aid. It does **not** replace the full guidance documents — consult those for nuanced situations. When in doubt, treat as Amber and escalate to the AI Champion or Engineering Lead.

| Dimension | 🔴 Red — Must Not Do | 🟡 Amber — Proceed with Care | 🟢 Green — Encouraged |
|---|---|---|---|
| **Privacy** | Submit real customer data, live network configs (with IPs/credentials), security policies, or incident specifics to any public LLM | Submit internal architecture diagrams, anonymised config templates, or internal code structure to enterprise-licensed LLM | Submit generic code patterns, public documentation questions, or fully anonymised/sanitised examples to any LLM |
| **Security** | Merge AI-generated code that bypasses SAST/SCA gates; grant agentic tools write access to production network devices | Use AI-generated code after careful manual review in areas not covered by automated scanning (e.g., logic errors, business rule violations) | Use AI assistance with full pipeline gates active; flag and log all AI-generated code for audit trail |
| **Environmental** | Default to frontier models (GPT-4 class) for all tasks without assessing whether a smaller/local model is sufficient | Use medium/large models for complex reasoning tasks where smaller models demonstrably underperform; document the justification | Use smallest capable model for the task; prefer local/on-prem models (Ollama + CodeLlama/Granite) for repetitive tasks |
| **Market Concentration** | Adopt an AI tool that creates a critical workflow dependency on a single proprietary vendor without an ADR and documented exit criteria | Adopt vendor tools with an ADR, exit criteria, and an adapter abstraction layer in place | Prefer tools with OpenAI API-compatible interfaces; evaluate OSS model alternatives; maintain portability at the prompt-template level |
| **Transformation** | Use AI adoption metrics to assess individual team member productivity; present AI as a headcount reduction programme | Introduce AI tooling to sceptical team members without addressing displacement anxiety directly; monitor sentiment carefully | Invest reskilling budget (minimum 4h/team member/sprint in adoption phases); celebrate AI Champions as engineering career growth; run psychologically safe retros |

---

## How These Dimensions Connect to Tool Choices and Playbooks

The five dimensions are not abstract principles — they constrain and shape every practical decision in the O&A AI adoption playbook:

### Tool Selection
- **Privacy + Market Concentration** → Require enterprise-licensed LLM instances with contractual no-training-on-inputs guarantees before Tier 2 data is permitted.
- **Security** → Require that any AI coding assistant can be gated by the existing SAST/SCA pipeline before adoption.
- **Environmental** → Require that any adopted tool supports model selection or is available via Ollama-compatible endpoint.

### PR and Code Review Process
- **Security** → AI-assisted PRs are tagged; SAST gate is mandatory; dependency additions are reviewed.
- **Privacy** → PR checklist includes a prompt hygiene confirmation.
- **Transformation** → Review comments on AI-generated code are coaching opportunities, not blame vectors.

### Sprint Ceremonies
- **Environmental** → SCI estimate included in sprint review alongside DORA metrics.
- **Transformation** → Retro includes SPACE-S AI anxiety questions each sprint.
- **Market Concentration** → ADR review as part of architecture guild, not ad hoc.

### Quarterly Governance
- **Privacy** → Audit checklist reviewed against classification tiers.
- **Security** → SAST finding rate in AI-assisted PRs vs. baseline reported to Engineering Lead.
- **Environmental** → CO₂e per sprint trend reported alongside DORA in stakeholder report.
- **Market Concentration** → Vendor concentration index reviewed.
- **Transformation** → SPACE-S trend, reskilling hours, and voluntary attrition reported.

---

## Thought Leaders and Primary References

These documents draw on the following practitioners and bodies of work. Team Members are encouraged to engage with these sources directly — they are cited not for decoration but because they are the most rigorous treatments of these problems available.

| Name / Body | Domain | Key Work |
|---|---|---|
| **Timnit Gebru** | Data governance, systemic AI harms, labor | _Stochastic Parrots_ (with Bender et al.); DAIR Institute |
| **Kate Crawford** | Power, market concentration, labor displacement | _Atlas of AI_ (2021) |
| **Anne Currie** | Green software, carbon-aware computing | Green Software Foundation; _Building Green Software_ |
| **Holly Cummins** | Cloud carbon, software sustainability | Cloud carbon footprint work; conference talks |
| **OWASP** | LLM security | OWASP LLM Top 10 |
| **NIST** | AI risk management | NIST AI Risk Management Framework (AI RMF 1.0) |
| **Ethan Mollick** | Human-AI collaboration, reskilling | _Co-Intelligence_ (2024) |
| **Gene Kim** | Transformation, psychological safety | _The Phoenix Project_, _The Unicorn Project_ |
| **Gregor Hohpe** | Platform strategy, architecture | _The Software Architect Elevator_; lock-in patterns |
| **TM Forum** | Telecom AI standards | AI/ML guidelines, Privacy Guidelines |

---

*These documents are owned by the O&A engineering team. Raise issues or proposed changes via the standard PR process against this repository. All changes require review by the Engineering Lead and at least one AI Champion.*
