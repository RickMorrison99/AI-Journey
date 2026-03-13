# O&A Team AI Adoption — Baseline Assessment Survey

---

## Purpose & Instructions

This survey establishes a Day-1 baseline for the OSS - Orchestration and Automation (O&A) team before any structured AI adoption programme begins. It measures two axes simultaneously: **current AI tool usage** (what people are already doing informally) and **Modern Software Delivery (MSD) health** (the engineering practices that determine how well AI-assisted output can be validated, integrated, and shipped safely).

Your responses are **anonymous**. No individual answers will be attributed to anyone; only aggregated team-level scores will be reported. The survey takes approximately **10 minutes** to complete. Results will be used to set a measurable starting point, identify areas of focus for the adoption roadmap, and track progress at 30-, 90-, and 180-day checkpoints. Please answer based on your honest day-to-day reality, not aspirational practice.

> **How to submit:** Complete all sections and return via \[survey platform / shared form link\]. Deadline: \[DATE\].

---

## Section 1: About You

> *These questions help us understand the range of backgrounds on the team. No combination of answers is uniquely identifying.*

**1.1 — What is your current role?** *(select one)*

- [ ] Software Team Member
- [ ] Senior Software Team Member
- [ ] Staff Team Member / Principal Team Member
- [ ] Tech Lead
- [ ] Architect
- [ ] Engineering Manager
- [ ] Other: _______________

---

**1.2 — How many years have you worked in telecom software?** *(select one)*

- [ ] Less than 2 years
- [ ] 2–5 years
- [ ] 5–10 years
- [ ] 10+ years

---

**1.3 — What are your primary programming languages?** *(select all that apply)*

- [ ] Python
- [ ] Go
- [ ] Java
- [ ] C / C++
- [ ] JavaScript / TypeScript
- [ ] Rust
- [ ] Other: _______________

---

**1.4 — What is your primary engineering domain?** *(select all that apply)*

- [ ] Network automation (YANG, NETCONF, gNMI, Ansible)
- [ ] OSS / BSS systems
- [ ] Network management platforms (NMS, EMS, SDN controllers)
- [ ] CI/CD platform and developer tooling
- [ ] API design and integration
- [ ] Data pipelines / observability
- [ ] Other: _______________

---

## Section 2: AI Tool Usage Today

> *Answer based on what you are doing **right now**, not what you plan to do. There are no wrong answers.*

---

### 2A — GitHub Copilot (in-editor code completion)

**2A.1 — How often do you use GitHub Copilot?** *(select one)*

- [ ] Never — I have not tried it
- [ ] Never — I have tried it but stopped
- [ ] Occasionally (a few times a month)
- [ ] Weekly
- [ ] Daily

**2A.2 — If you use it, what do you use it for?** *(select all that apply; skip if Never)*

- [ ] Boilerplate / scaffolding code generation
- [ ] Completing repetitive patterns (loops, CRUD methods, etc.)
- [ ] Writing unit tests
- [ ] Writing docstrings / inline comments
- [ ] Understanding unfamiliar code
- [ ] Generating YANG models or network config templates
- [ ] Other: _______________

**2A.3 — If you use it, how satisfied are you with the results?** *(1 = Very dissatisfied → 5 = Very satisfied; N/A if Never)*

```
1 ○   2 ○   3 ○   4 ○   5 ○   N/A ○
```

---

### 2B — Chat-Based AI Assistants (ChatGPT, Claude, Gemini, Copilot Chat, etc.)

**2B.1 — How often do you use a chat-based AI assistant for engineering work?** *(select one)*

- [ ] Never
- [ ] Occasionally (a few times a month)
- [ ] Weekly
- [ ] Daily

**2B.2 — If you use them, what do you use them for?** *(select all that apply; skip if Never)*

- [ ] Explaining or summarising code or documentation
- [ ] Debugging and root-cause analysis
- [ ] Drafting design documents or ADRs
- [ ] Writing or improving tests
- [ ] Generating or reviewing regex / data transforms
- [ ] Understanding RFCs, standards, or TM Forum specs
- [ ] Learning new languages, frameworks, or APIs
- [ ] Writing scripts (Bash, Ansible playbooks, etc.)
- [ ] Other: _______________

**2B.3 — If you use them, how satisfied are you with the results?** *(1 = Very dissatisfied → 5 = Very satisfied; N/A if Never)*

```
1 ○   2 ○   3 ○   4 ○   5 ○   N/A ○
```

---

### 2C — Copilot CLI / Agentic AI Tools (GitHub Copilot CLI, Cursor, Codeium, Devin, etc.)

**2C.1 — How often do you use CLI-integrated or agentic AI tools?** *(select one)*

- [ ] Never — I have not tried them
- [ ] Never — I have tried them but stopped
- [ ] Occasionally (a few times a month)
- [ ] Weekly
- [ ] Daily

**2C.2 — If you use them, what do you use them for?** *(select all that apply; skip if Never)*

- [ ] Generating shell commands or pipeline steps
- [ ] Multi-step code refactoring across files
- [ ] Automated PR review or code suggestions
- [ ] Generating commit messages or PR descriptions
- [ ] End-to-end feature implementation (agentic loops)
- [ ] Other: _______________

**2C.3 — If you use them, how satisfied are you with the results?** *(1 = Very dissatisfied → 5 = Very satisfied; N/A if Never)*

```
1 ○   2 ○   3 ○   4 ○   5 ○   N/A ○
```

---

### 2D — Custom AI Scripts or Internal Pipelines

**2D.1 — How often do you build or use custom AI-powered scripts, notebooks, or internal tools?** *(select one)*

- [ ] Never
- [ ] Occasionally (a few times a month)
- [ ] Weekly
- [ ] Daily

**2D.2 — If you use them, what do they do?** *(select all that apply; skip if Never)*

- [ ] Automated log analysis / anomaly detection
- [ ] Config validation against schema or policy
- [ ] Network topology summarisation
- [ ] Alarm or event correlation
- [ ] Code generation from internal templates or specs
- [ ] Documentation generation from source code
- [ ] Other: _______________

**2D.3 — If you use them, how satisfied are you with the results?** *(1 = Very dissatisfied → 5 = Very satisfied; N/A if Never)*

```
1 ○   2 ○   3 ○   4 ○   5 ○   N/A ○
```

---

### 2E — Open Reflection

**2E.1 — What has been your biggest win from using AI tools so far?** *(freetext; write "None yet" if applicable)*

> _______________________________________________________________
> _______________________________________________________________

---

**2E.2 — What has been your biggest blocker, frustration, or concern when using AI tools?** *(freetext)*

> _______________________________________________________________
> _______________________________________________________________

---

**2E.3 — How confident are you in your ability to write effective prompts and get useful output from AI tools?**
*(1 = Not confident at all → 5 = Very confident)*

```
1 ○   2 ○   3 ○   4 ○   5 ○
```

---

**2E.4 — How confident are you in your ability to review AI-generated code for functional correctness?**
*(1 = Not confident at all → 5 = Very confident)*

```
1 ○   2 ○   3 ○   4 ○   5 ○
```

---

**2E.5 — How confident are you in your ability to review AI-generated code for security vulnerabilities?**
*(1 = Not confident at all → 5 = Very confident)*

```
1 ○   2 ○   3 ○   4 ○   5 ○
```

---

## Section 3: MSD Health Self-Assessment

> Rate each statement using the following scale. Be honest about **current reality**, not intent.
>
> | Score | Meaning |
> |-------|---------|
> | **1** | Not doing — this practice does not exist on our team |
> | **2** | Ad hoc — someone does it sometimes, inconsistently |
> | **3** | Inconsistent — we try to do it but it breaks down regularly |
> | **4** | Consistent — we do it reliably most of the time |
> | **5** | Exemplary — this is a team habit; exceptions are rare and addressed |

---

### CI/CD

| # | Statement | 1 | 2 | 3 | 4 | 5 |
|---|-----------|:-:|:-:|:-:|:-:|:-:|
| 3.1 | We have an automated CI pipeline that runs on every commit to every active branch | ○ | ○ | ○ | ○ | ○ |
| 3.2 | Our CI pipeline includes automated tests (unit, integration, or both) | ○ | ○ | ○ | ○ | ○ |
| 3.3 | We can deploy to staging or production on demand, not in scheduled batches | ○ | ○ | ○ | ○ | ○ |
| 3.4 | Our main/trunk branch is always in a deployable state | ○ | ○ | ○ | ○ | ○ |

---

### Testing Discipline

| # | Statement | 1 | 2 | 3 | 4 | 5 |
|---|-----------|:-:|:-:|:-:|:-:|:-:|
| 3.5 | We write tests before or alongside new code (TDD / BDD) | ○ | ○ | ○ | ○ | ○ |
| 3.6 | We maintain a testing pyramid: more unit tests than integration, more integration than E2E | ○ | ○ | ○ | ○ | ○ |
| 3.7 | Test coverage is tracked and actively improving over time | ○ | ○ | ○ | ○ | ○ |
| 3.8 | AI-generated code (where used) is covered by tests before it is merged | ○ | ○ | ○ | ○ | ○ |

---

### Trunk-Based Development

| # | Statement | 1 | 2 | 3 | 4 | 5 |
|---|-----------|:-:|:-:|:-:|:-:|:-:|
| 3.9 | We work in short-lived branches (merged within 1 day or we work directly on trunk) | ○ | ○ | ○ | ○ | ○ |
| 3.10 | We integrate code to main/trunk at least once per day | ○ | ○ | ○ | ○ | ○ |
| 3.11 | We use feature flags to hide incomplete work rather than long-lived feature branches | ○ | ○ | ○ | ○ | ○ |

---

### Architecture & Code Quality

| # | Statement | 1 | 2 | 3 | 4 | 5 |
|---|-----------|:-:|:-:|:-:|:-:|:-:|
| 3.12 | We follow DRY (Don't Repeat Yourself) principles consistently across the codebase | ○ | ○ | ○ | ○ | ○ |
| 3.13 | We maintain clear Separation of Concerns across services and modules | ○ | ○ | ○ | ○ | ○ |
| 3.14 | We design and agree on APIs or interfaces before beginning implementation | ○ | ○ | ○ | ○ | ○ |
| 3.15 | We reference TM Forum Open APIs before building new integration points | ○ | ○ | ○ | ○ | ○ |
| 3.16 | We write Architectural Decision Records (ADRs) for significant technical decisions | ○ | ○ | ○ | ○ | ○ |
| 3.17 | We perform regular refactoring as part of normal delivery, not only when forced | ○ | ○ | ○ | ○ | ○ |

---

## Section 4: DORA Self-Estimate

> **What is DORA?** The DORA (DevOps Research and Assessment) metrics are four evidence-based indicators of software delivery performance: Deployment Frequency, Lead Time for Changes, Mean Time to Restore (MTTR), and Change Failure Rate. High performers across these metrics consistently outperform on reliability and business outcomes.
>
> Answer for your **primary service or team** as best you can estimate. If you are unsure, choose the answer that feels closest to reality.

---

**4.1 — Deployment Frequency** — *How often does your team deploy to production?*

- [ ] Multiple times per day
- [ ] Once per day
- [ ] Once per week (or several times a week)
- [ ] Once per month (or several times a month)
- [ ] Less than once per month

---

**4.2 — Lead Time for Changes** — *From when code is committed to when it is running in production, how long does it typically take?*

- [ ] Less than 1 hour
- [ ] Less than 1 day
- [ ] Between 1 day and 1 week
- [ ] Between 1 week and 1 month
- [ ] More than 1 month

---

**4.3 — Mean Time to Restore (MTTR)** — *When an incident occurs in production, how long does it typically take to restore service?*

- [ ] Less than 1 hour
- [ ] Less than 1 day
- [ ] Less than 1 week
- [ ] More than 1 week
- [ ] We have not had incidents recently / Don't know

---

**4.4 — Change Failure Rate** — *What percentage of changes to production result in a degradation or incident requiring remediation?*

- [ ] Less than 5%
- [ ] 5–10%
- [ ] 10–15%
- [ ] Greater than 15%
- [ ] We don't currently track this

---

## Section 5: Responsible AI Readiness

> Rate each statement on your personal awareness **and** team practice.
>
> | Score | Meaning |
> |-------|---------|
> | **1** | Not aware — I have not thought about this |
> | **2** | Aware individually — I know this matters but the team has not discussed it |
> | **3** | Discussed — we have talked about it but have no formal guidance |
> | **4** | Guided — we have a shared understanding or informal rule |
> | **5** | Fully in practice — we have a documented policy and follow it consistently |

| # | Statement | 1 | 2 | 3 | 4 | 5 |
|---|-----------|:-:|:-:|:-:|:-:|:-:|
| 5.1 | I know what categories of data I must **not** share with public AI tools (customer data, credentials, proprietary configs, PII) | ○ | ○ | ○ | ○ | ○ |
| 5.2 | Our team has discussed and agreed on AI data-sharing boundaries and privacy rules | ○ | ○ | ○ | ○ | ○ |
| 5.3 | I know how to review AI-generated code specifically for security vulnerabilities (prompt injection, insecure defaults, credential leakage) | ○ | ○ | ○ | ○ | ○ |
| 5.4 | I understand that different AI model choices have meaningfully different environmental (energy/carbon) costs | ○ | ○ | ○ | ○ | ○ |
| 5.5 | I feel psychologically safe to share honest feedback about AI tools — including negative feedback — without career risk | ○ | ○ | ○ | ○ | ○ |
| 5.6 | I am confident that AI is augmenting my role, not replacing it, on this team | ○ | ○ | ○ | ○ | ○ |

---

## Section 6: Aspirations & Concerns

> These are open-ended. There are no right answers. Your perspective shapes the adoption roadmap.

---

**6.1 — Which engineering task in your day-to-day work would benefit MOST from AI assistance?**

> _______________________________________________________________
> _______________________________________________________________
> _______________________________________________________________

---

**6.2 — Which engineering task should we NEVER fully delegate to AI, and why?**

> _______________________________________________________________
> _______________________________________________________________
> _______________________________________________________________

---

**6.3 — What would make you MORE confident or comfortable using AI tools in your work?**
*(e.g., training, guardrails, policy clarity, better tooling, peer examples)*

> _______________________________________________________________
> _______________________________________________________________
> _______________________________________________________________

---

**6.4 — Any other comments, observations, or questions?**

> _______________________________________________________________
> _______________________________________________________________
> _______________________________________________________________

---

## Scoring Guide (for Survey Administrators)

> *This section is for the programme leads who aggregate and interpret results. Do not distribute to respondents before they complete the survey.*

---

### Aggregation Method

Collect all responses into a spreadsheet or survey platform with numeric values assigned to each scale answer. For all rating scales (1–5), compute the **team mean** and **standard deviation** per question. Flag any question where σ > 1.2 as an area of high disagreement worth qualitative follow-up.

---

### MSD Health Score (Section 3)

Calculate scores at three levels:

| Level | Method |
|-------|--------|
| **Overall MSD Health** | Mean of all 17 items (3.1–3.17) |
| **Category score** | Mean of items within each category |
| **Item score** | Raw mean per question |

**Category breakdown:**

| Category | Items | Max possible |
|----------|-------|:------------:|
| CI/CD | 3.1–3.4 | 5.0 |
| Testing Discipline | 3.5–3.8 | 5.0 |
| Trunk-Based Development | 3.9–3.11 | 5.0 |
| Architecture & Code Quality | 3.12–3.17 | 5.0 |

**Interpretation table:**

| Score range | Band | Meaning | Recommended action |
|:-----------:|------|---------|-------------------|
| 4.5–5.0 | 🟢 **Exemplary** | Strong foundation; ready to accelerate AI adoption | Use as reference practices; focus AI on velocity gains |
| 3.5–4.4 | 🟡 **Capable** | Solid base with exploitable gaps | Targeted improvement in weak categories before scaling AI |
| 2.5–3.4 | 🟠 **Developing** | Inconsistent practices will amplify AI risk | Prioritise MSD fundamentals in parallel with limited AI pilots |
| 1.5–2.4 | 🔴 **Foundational** | Ad hoc practices; AI will accelerate tech debt | Pause broad AI adoption; invest in CI/CD and testing first |
| 1.0–1.4 | ⛔ **Critical** | No reliable delivery foundation | MSD remediation is a prerequisite; AI adoption on hold |

---

### DORA Band (Section 4)

Map each respondent's answers to the standard DORA performance bands, then take the modal (most common) answer per question as the team estimate.

| Metric | Low | Medium | High | Elite |
|--------|-----|--------|------|-------|
| **Deployment Frequency** | Less than monthly | Monthly | Weekly | On-demand (multiple/day) |
| **Lead Time for Changes** | > 1 month | 1 week–1 month | 1 day–1 week | < 1 hour |
| **MTTR** | > 1 week | 1 day–1 week | < 1 day | < 1 hour |
| **Change Failure Rate** | > 15% | 10–15% | 5–10% | < 5% |

Score each metric 1 (Low) to 4 (Elite). **Overall DORA score** = mean across four metrics.

| DORA Score | Band | Meaning |
|:----------:|------|---------|
| 3.5–4.0 | 🟢 **Elite** | Top-quartile delivery; AI will compound advantage |
| 2.5–3.4 | 🟡 **High** | Strong delivery; AI adoption low risk |
| 1.5–2.4 | 🟠 **Medium** | Moderate delivery; address bottlenecks alongside AI pilots |
| 1.0–1.4 | 🔴 **Low** | Delivery constraints will limit AI impact; fix pipeline first |

---

### AI Readiness Score

Combine confidence signals from two sections:

| Component | Source items | Weight |
|-----------|-------------|:------:|
| Prompting confidence | 2E.3 | 1× |
| Code correctness review confidence | 2E.4 | 1× |
| Security review confidence | 2E.5 | 1× |
| Responsible AI awareness (mean) | 5.1–5.6 | 1× |
| **AI Readiness Score** | Mean of above four components | — |

| Score | Band | Meaning | Recommended action |
|:-----:|------|---------|-------------------|
| 4.0–5.0 | 🟢 **Ready** | Team can adopt AI tools with light-touch governance | Roll out tools; focus on advanced prompting and review skills |
| 3.0–3.9 | 🟡 **Progressing** | Good awareness; targeted skill gaps | Prompt engineering workshops; security review training |
| 2.0–2.9 | 🟠 **Emerging** | Awareness patchwork; inconsistent practice | Mandatory baseline training before broad tool access |
| 1.0–1.9 | 🔴 **Not Ready** | Low awareness and confidence across the board | Structured onboarding programme required before adoption |

---

### Responsible AI Readiness (Section 5)

Report the mean score for items 5.1–5.6 individually **and** as a group. Pay particular attention to:

- **5.1 + 5.2** (data governance) — a score below 3.0 on either is a hard blocker requiring policy action before any public AI tool usage expands.
- **5.5** (psychological safety) — a score below 3.0 indicates a culture risk that will distort all other survey results and adoption outcomes.
- **5.6** (role augmentation confidence) — a score below 3.0 flags change management work needed before team members will engage authentically with AI adoption.

---

### Dual-Axis Dashboard Summary (to publish after aggregation)

Produce a 2×2 summary for leadership using the two primary axes:

```
                 MSD Health Score
                 Low (1–2.5)        High (2.5–5)
               ┌──────────────────┬──────────────────┐
AI Readiness   │  Quadrant D:     │  Quadrant B:     │
High (3–5)     │  Invest in MSD   │  Accelerate      │
               │  first           │  (ideal state)   │
               ├──────────────────┼──────────────────┤
AI Readiness   │  Quadrant C:     │  Quadrant A:     │
Low (1–3)      │  Foundation      │  Train on AI;    │
               │  remediation     │  MSD is an asset │
               └──────────────────┴──────────────────┘
```

---

## Next Steps

Survey results feed directly into the O&A AI Adoption dual-axis maturity model. The **MSD Health Score** and **DORA Band** define the team's delivery foundation; the **AI Readiness Score** and **Responsible AI Readiness** define the team's capacity to adopt AI safely and effectively. Together, these four numbers place the team in one of the four quadrants above and determine the first 30-day focus area on the adoption roadmap.

Aggregate results will be shared with the full team in a read-out session within two weeks of the survey closing. Individual responses remain confidential. The same survey will be re-administered at the 90-day and 180-day marks to track progress against each axis, validate that interventions are working, and recalibrate the roadmap. If any **Responsible AI** item scores below 3.0, remediation actions (policy clarification, training, or leadership communication) will be initiated before the 30-day mark, regardless of overall readiness scores.

---

*Document version: 1.0 — Initial baseline. Owner: O&A Engineering Programme Lead. Last updated: <!-- DATE -->.*
