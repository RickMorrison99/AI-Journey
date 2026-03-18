# AI-Agentic Adoption Roadmap
## O&A Team — OSS - Orchestration and Automation

> **Status:** Living document · Owned by: O&A Engineering Lead + AI Champions  
> **Review cycle:** Quarterly (or at each stage transition) · **Last reviewed:** _see git log_  
> **Companion documents:** [Maturity Model](maturity-model.md) · [Responsible AI](responsible-ai/index.md) · [Team Norms](governance/team-norms.md)

---

## Overview

This roadmap describes the O&A team's journey from informal, individual AI experimentation to a mature, sustainable, organisation-wide AI-augmented engineering practice. It is not a project plan with Gantt charts and fixed deadlines. It is a sequenced progression — five named stages, each with clear prerequisites, concrete activities, and honest exit criteria.

The journey is built on a simple but important insight drawn from DORA research and Dave Farley's *Modern Software Engineering*: **AI adoption is an amplifier, not a foundation.** Deploy it on strong engineering practices and it accelerates everything good. Deploy it on fragile pipelines and untested code and it accelerates technical debt, undetectable regressions, and misconfigured devices.

For O&A specifically, this matters at carrier scale. AI-generated YANG modules pushed into a network configuration pipeline without validation aren't productivity — they're risk at scale. The sequence in this roadmap is designed to ensure the safety and MSD Health foundations are always one stage ahead of the AI tooling sitting on top of them.

### The Five Stages

```
  Aware  →  Experimenting  →  Practicing  →  Scaling  →  Optimizing
   (1)           (2)              (3)           (4)           (5)
```

| Stage | Core Question |
|---|---|
| **Aware** | Do we understand what AI tools can and cannot do for us? |
| **Experimenting** | Are we learning what actually works for O&A tasks specifically? |
| **Practicing** | Is AI a normal, consistent part of how we work? |
| **Scaling** | Are agentic tools embedded in workflows and driving DORA improvement? |
| **Optimizing** | Are we generating new practices and approaching DORA Elite? |

### Governing Principles

**1. MSD Health prerequisites are not optional.**  
Each stage has a minimum Modern Software Delivery Health level that must be met — or actively in progress — before advancing. This is the most important rule in this document. See [the dual-axis maturity model](maturity-model.md) for the full definition of each MSD Health level.

**2. Responsible AI gates are not paperwork.**  
Each stage has a Responsible AI gate drawn from the [five risk dimensions](responsible-ai/index.md). These gates exist because O&A operates in a domain where the blast radius of a mistake is measured in customer-affecting network outages, not broken unit tests.

**3. The jagged frontier is real.**  
Ethan Mollick's observation in *Co-Intelligence* is that AI capability is not uniformly strong or weak — it is jagged. AI may be outstanding at drafting YANG documentation and poor at interpreting a novel RFC edge case. The O&A Jagged Frontier Map (see final section) is the team's evolving evidence base for where AI is genuinely useful and where human expertise must lead.

**4. No team member gets left behind.**  
Adoption should not create a two-tier team of AI-fluent and AI-excluded team members. Reskilling, psychological safety, and peer learning are explicit activities at every stage, not afterthoughts.

### Typical Timeline Guidance

These are pace indicators, not deadlines. A team of 10–30 team members starting from the exploratory phase described above should expect:

| Stage | Typical Duration | Pacing Notes |
|---|---|---|
| **Stage 1: Aware** | 2–4 weeks | Mostly meetings and reading; short if the team is engaged |
| **Stage 2: Experimenting** | 6–12 weeks | Longer if MSD Health work is needed in parallel |
| **Stage 3: Practicing** | 3–6 months | This is where real discipline builds; don't rush it |
| **Stage 4: Scaling** | 4–8 months | Agentic tools require significant MSD Health investment first |
| **Stage 5: Optimizing** | Ongoing | Not a destination — a continuous improvement cadence |

---

## Stage Navigator

| Stage | AI Adoption Level | MSD Health Prerequisite | Key Activities | Exit Criteria | Responsible AI Gate |
|---|---|---|---|---|---|
| **1 — Aware** | L1 → L2 | None (baseline capture required) | Baseline survey · Jagged frontier mapping · TM Forum API review · Champion identification | Survey ≥80% · Baseline recorded · 2–3 use cases identified · Data policy acknowledged | 5 risk dimensions read & acknowledged · Data classification communicated · No sensitive data in public LLMs |
| **2 — Experimenting** | L2 | L2+ (basic CI, VCS, some tests) | Bounded experiments · Prompt library started · PR checklist adopted · Sprint retro AI section | ≥50% team members have used AI at work · ≥10 prompt templates · PR checklist ≥80% adoption · ≥1 experiment documented | Enterprise-grade tool instances in use · PR checklist adopted · ≥1 SAST gate in pipeline |
| **3 — Practicing** | L3 | L3 (CI/CD established, testing pyramid, TBD, DORA Medium+) | Copilot for all · Prompt library expanded · SCI tracking starts · First agentic experiment · DORA checkpoint | ≥80% weekly AI usage · DORA → High band · ≥30 prompt templates · SCI tracking live · MSD Health L3 | SCI tracking started · Agentic tools scoped in ADRs · Vendor concentration index measured |
| **4 — Scaling** | L4 | L4 (DORA High band, fitness functions, ADRs) | Agentic tools for O&A tasks · AI in pipeline · OSS model evaluation · Vendor concentration audit · Reskilling | DORA High band · ≥1 agentic workflow with ADR · OSS model evaluated · Reskilling tracked · MSD Health L4 | Vendor concentration index below threshold · Multi-provider strategy documented · OSS alternative evaluated |
| **5 — Optimizing** | L5 | L5 (DORA Elite, continuous improvement cadence) | Practice retrospectives · Community of practice contribution · Custom AI capabilities · Internal case studies · Mentoring | DORA Elite band · Continuous improvement cadence · Practices shared externally | Full responsible AI review cycle operating |

---

## Stage 1: Aware

> *"We understand what AI tools exist and what they can and can't do for us."*

### What This Stage Is About

Stage 1 is about building a shared foundation — not rushing to adopt tools. The goal is to end this stage with the whole team holding a common, realistic understanding of AI capability in the O&A context specifically, rather than the generic AI hype that floods industry media.

This is the most underrated stage on most teams' AI journeys. Teams that skip it — jumping straight to "everyone gets Copilot" — end up with inconsistent adoption, unaddressed risk exposure, and no ability to measure whether anything improved. Spending two to four focused weeks here pays dividends for every subsequent stage.

The key intellectual tool for this stage is Ethan Mollick's **jagged frontier** concept from *Co-Intelligence*: AI capability is not a uniform line. It is a jagged edge where AI is surprisingly strong in some areas (drafting YANG module documentation from a schema) and surprisingly weak in others (interpreting a novel RFC edge case or making an architectural trade-off). Mapping that frontier for O&A-specific tasks — before adopting any tools — prevents both over-reliance and under-utilisation.

### MSD Health Prerequisite

No formal MSD Health level is required to begin Stage 1. However, the baseline survey (Activity 1 below) must capture the current MSD Health state honestly. If the team discovers it is at MSD Level 1 (fragile pipelines, no automated tests, manual deployment) during Stage 1, the parallel work to reach MSD Level 2 should begin immediately — it will be needed before Stage 2 can proceed safely.

### Responsible AI Gate

Before the team proceeds to any hands-on tool use in Stage 2, all of the following must be true:

- [ ] All team members have read and acknowledged the [five responsible AI risk dimensions](responsible-ai/index.md)
- [ ] Data classification tiers have been communicated and are understood (network config data, customer data, and credentials are all Class 3 or above — they do not go into public LLM prompts under any circumstances)
- [ ] No team member is currently using a personal, unmanaged LLM account for work tasks involving sensitive O&A data

The last point is not hypothetical. At Stage 1, some team members are likely already experimenting informally. The Responsible AI gate at this stage is about surfacing that behaviour, not punishing it — and redirecting it toward safe, enterprise-managed tooling as Stage 2 begins.

### Key Activities

**1. Run the baseline assessment survey**  
Use the [baseline survey](baseline-survey.md) to capture current state across both axes: AI Adoption Depth and MSD Health. The survey should be completed by ≥80% of the team before Stage 1 is considered complete. Make it anonymous. Aggregate results and share them with the team — this is not a performance review, it is a collective starting point.

**2. Review the dual-axis maturity model as a team**  
Run a 60–90 minute session where the team reviews the [maturity model](maturity-model.md) together and places themselves on the 2D matrix. Disagreement is healthy and informative — if half the team thinks you're at MSD Level 2 and half thinks you're at MSD Level 1, that tells you something important about consistency.

**3. Complete the O&A Jagged Frontier Map**  
Run the team through the Jagged Frontier Map template (see the full template at the end of this document). The goal is not to produce a finished, evidence-backed map — that comes in Stage 2. The goal is for the team to share their *estimates* of where AI is strong and weak for O&A-specific tasks: YANG authoring, NETCONF test generation, incident timeline summarisation, root cause analysis, OpenConfig augmentation review. Heated disagreement here is a feature, not a bug. Record the estimates. They will be tested in Stage 2.

**4. Review the TM Forum Open API table as a team**  
Before anyone builds anything new, the team should have a working familiarity with [TM Forum Open APIs](tmforum/). This is Gregor Hohpe's *Architect Elevator* principle applied practically: know what the industry has already solved before building bespoke solutions. A standing DRY check — "does a TM Forum API already exist for this?" — should become a team habit starting here.

**5. Identify 2–3 candidate AI use cases for Stage 2**  
Based on the Jagged Frontier Map and team discussion, identify two or three specific, bounded AI use cases to experiment with in Stage 2. The criteria for a good Stage 2 candidate:
  - Low blast radius if the AI output is wrong (test generation, documentation, not device config generation)
  - Repeatable enough to learn from (a task done every sprint, not once a quarter)
  - Involves a workflow that already exists (AI assists existing work; doesn't create new undefined work)

Good O&A Stage 2 candidates: unit test generation for existing Python ncclient wrappers; YANG module documentation drafting; incident timeline summarisation.

Poor O&A Stage 2 candidates (save for Stage 3+): AI-assisted NETCONF device configuration push; AI-generated routing policy expressions; AI-driven change window automation.

**6. Establish the AI Champion role in each squad**  
Every squad nominates one AI Champion per the [team norms](governance/team-norms.md). The Champion is not the gatekeeper or the AI expert — they are the focal point for sharing, learning, and facilitating team retro discussions about AI. The role rotates annually. Identify the first cohort now so they are in place for Stage 2.

### Metrics Baseline

Stage 1 is the moment to establish measurement baselines — not to optimise them. Record current state, however imperfect:

**DORA Baseline** (even rough estimates are fine at this stage):
- Deployment frequency: how often does the team deploy to production?
- Lead time for changes: from commit to production, how long?
- Change failure rate: what percentage of deployments cause an incident?
- Mean time to restore: when an incident occurs, how long to recover?

DORA research (Forsgren et al., *Accelerate*) establishes clear performance bands. Most teams in the exploratory phase sit in the Low or Medium band. That's fine — the baseline is not a judgment, it is a starting line.

**SPACE-S and SPACE-E Baseline** (Forsgren et al., SPACE Framework):  
Run the first SPACE survey focused on Satisfaction and Team Member Experience dimensions. How satisfied are team members with their current tools and workflows? What parts of the work feel tedious, slow, or friction-heavy? This creates the baseline against which AI adoption's impact on developer experience will be measured — and is critical for detecting if AI tools are creating hidden stress or cognitive overload rather than reducing it.

### Exit Criteria

All of the following must be true to advance to Stage 2:

- [ ] Baseline survey completed by ≥80% of the team
- [ ] Team has placed itself on the dual-axis maturity model and the result is documented
- [ ] 2–3 candidate AI use cases identified, documented, and agreed on
- [ ] Data classification tiers communicated and acknowledged by all team members
- [ ] AI Champions identified for each squad
- [ ] DORA and SPACE baselines recorded (estimates acceptable)
- [ ] Responsible AI gate passed: five risk dimensions read, no sensitive data in public LLMs

---

## Stage 2: Experimenting

> *"We're trying AI tools in safe, low-risk contexts and learning from the results."*

### What This Stage Is About

Stage 2 is about structured learning, not structured adoption. The question is not "can we get everyone using Copilot?" — it is "what does AI actually do for O&A-specific tasks, and how do we know?" This distinction matters enormously. Teams that treat this stage as a rollout end up with surface-level metrics (tool activation rate) that tell them nothing about whether engineering outcomes are improving.

The design principle for every Stage 2 experiment is drawn from Dave Farley's feedback loop framing in *Continuous Delivery*: keep experiments **fast, cheap, and reversible**. If an AI-generated test is wrong, a failing CI build catches it before it ever gets to a device. If an AI-drafted YANG description is off, a human catches it in code review. The learning is real; the blast radius is minimal.

Stage 2 is also when the team's shared prompt library begins. Every useful prompt goes into the team repo. This is not optional hygiene — it is the mechanism by which individual discoveries become team capability. A prompt that saved one team member two hours and then lives only in their browser history is waste.

### MSD Health Prerequisite: Level 2+

Before Stage 2 experiments begin, the team needs:
- Code in version control (if not already true, fix this before anything else)
- A basic CI pipeline that runs on every pull request
- Some automated tests — even a small, fragile test suite is the foundation to build on
- PR-based code review as a consistent practice

If the team is at MSD Level 1 (fragile or absent pipelines), Stage 2 AI experimentation is not safe. The MSD improvement work should run in parallel with Stage 1 activities and be complete before Stage 2 begins. The reason is concrete: AI-generated code that is not run through a CI pipeline is just untested code with a faster authoring tool. That is not an improvement.

### Responsible AI Gate

Before hands-on tool use begins:

- [ ] Enterprise-grade, managed AI tool instances are provisioned (not personal accounts with no data protection — GitHub Copilot Business, Microsoft Azure OpenAI, or equivalent with data residency and no-training guarantees)
- [ ] The [PR checklist from team norms](governance/team-norms.md) is adopted and enforced in pull request templates
- [ ] At least one SAST gate (e.g., Bandit for Python, Semgrep) is integrated in the CI pipeline

The SAST gate is not specifically an AI concern — but its absence is a precondition for AI-assisted code being genuinely dangerous. AI-generated Python code that touches NETCONF sessions can produce real security issues: hardcoded credentials, missing TLS verification, overly broad device access. SAST catches the mechanical class of these errors automatically.

### Key Activities

**1. Start with the lowest-risk, highest-value use cases from Stage 1**

The candidate use cases identified in Stage 1 are your starting point. Run them as structured experiments: define what you're trying, define what success looks like, run it, and document what you learned. Every experiment gets a write-up — even a one-paragraph Confluence page. The act of writing it forces clarity.

**Suggested O&A starting points — lowest risk, immediate value:**

| Experiment | Why Here | What to Watch For |
|---|---|---|
| Generate Python unit tests for existing `ncclient` wrappers | Existing code = known ground truth; failures caught by CI | AI may miss edge cases around connection error handling |
| Draft YANG module documentation from existing `.yang` files | Output is text, not code; easy to review | May hallucinate RFC references; always verify |
| Summarise a long incident timeline from postmortem notes | No deployment risk; output is a draft, not an action | May omit or misorder events; human validates |
| Ask AI to explain an unfamiliar YANG module or augmentation | Pure learning tool; no output enters production | Good use of AI's broad protocol knowledge |

**2. Use AI to generate tests for existing code (not new features)**

This deserves emphasis as its own activity because it is the single safest and most valuable place to start. Generating tests for code that already exists is low-risk (the tests either pass or they don't; the CI tells you) and high-value (it improves coverage on code that was previously undertested). Generating code for new, untested features is where AI can lead teams in the wrong direction — that comes later.

For O&A specifically: take a Python module containing NETCONF session management functions, YANG parsing utilities, or Ansible inventory builders, and ask Copilot or an LLM to generate `pytest` unit tests. Review them. Run them. Fix the ones that are wrong. Document what the AI got right and wrong.

**3. Start the shared prompt template library**

The team prompt library lives in the repository under `prompts/`. The AI Champion in each squad is responsible for curating it. Every team member who discovers a useful prompt commits it. Every prompt follows a template:

```
# Prompt: [short name]
## Use case
## Context to include
## The prompt
## Example output
## Limitations / gotchas
## Added by / date
```

Starting a prompt library with only five or ten entries is fine. The habit matters more than the size.

**4. Run the first AI section in sprint retrospectives**

From Stage 2 onwards, every sprint retrospective includes a five-minute structured AI section. The [team norms](governance/team-norms.md) define the five standing questions. This is the mechanism by which individual experiments become shared team learning — and the mechanism by which problems (stress, over-reliance, quality issues) surface before they compound.

**5. Establish the PR checklist**

The pull request checklist from [team norms](governance/team-norms.md) must be adopted and tracked. The AI-relevant items cover: was this AI-assisted? (declare it, not as a stigma but as a data point), was the output validated against known ground truth?, and has SAST run clean? These items add less than 60 seconds to a PR — and they create the audit trail that responsible AI governance requires.

**6. Check TM Forum Open APIs before building any new integration**

Even manually-built integrations. If the team is considering building a new northbound API, a mediation layer, or a service catalogue integration, the first check is always: does a TM Forum Open API cover this? This DRY check becomes non-negotiable in Stage 3. Establishing the habit now costs nothing.

### O&A-Specific Experiment Ideas

| Experiment | Risk Rating | Recommended Approach |
|---|---|---|
| Generate `pytest` unit tests for existing `ncclient` wrapper functions | 🟢 Low | AI generates, team member reviews and runs via CI |
| Draft YANG leaf/list descriptions from existing `.yang` modules | 🟢 Low | AI drafts, team member verifies RFC alignment |
| Generate Ansible task boilerplate from a requirements description | 🟡 Low–Med | AI scaffolds, team member reviews idempotency |
| Ask AI to explain an unfamiliar YANG module or vendor augmentation | 🟢 Low | Pure learning tool; output doesn't enter production |
| Use AI to summarise a long network incident timeline from postmortem notes | 🟢 Low | AI drafts, team member validates completeness and sequence |
| Generate an OpenAPI spec from existing Flask or FastAPI route definitions | 🟡 Medium | AI generates, team member validates against actual behaviour |
| Draft a new YANG `augment` module with AI assistance | 🟡 Medium | Requires `pyang --lint` and `pyang --strict` CI validation gate before merge |
| Generate a Jinja2 config template from a sample device configuration | 🟡 Medium | AI generates, team member validates idempotency and device-specific edge cases |
| Generate NETCONF RPC request XML from a YANG `rpc` definition | 🟡 Medium | Useful for test fixture generation; validate against a device or simulator |
| AI-assisted root cause analysis from structured log data | 🔴 High | Not for Stage 2 — requires established log structure and human oversight framework |
| AI-generated device configuration pushed to production | 🔴 High | Not until Stage 4 at the earliest, with full validation pipeline in place |

### Metrics to Start Tracking

- **AI tool weekly active rate**: what percentage of team members used an AI tool in a work context this week? (Track trend, not just the number)
- **SPACE-S (Satisfaction)**: is AI tooling improving how team members feel about their work, or creating new friction?
- **SPACE-A (Activity)**: PR volume, test coverage delta. Use with care — activity metrics are proxy metrics. A drop in activity after AI adoption can mean team members are writing less boilerplate, which is good. It can also mean they're stuck or disengaged.
- **Prompt library growth**: number of committed prompt templates. A simple proxy for collaborative learning.

### Exit Criteria

All of the following must be true to advance to Stage 3:

- [ ] ≥50% of team members have used at least one AI tool in a work context (not just installed it)
- [ ] Shared prompt template library exists in the repo with ≥10 committed entries
- [ ] PR checklist adopted and tracked in ≥80% of PRs
- [ ] At least one AI-assisted experiment documented: what we tried, what the AI got right, what it got wrong, what we'll do differently
- [ ] No data classification violations observed (no sensitive network data or credentials submitted to public LLMs)
- [ ] MSD Health at Level 2, or Level 1 with active, documented improvement work underway
- [ ] Responsible AI gate passed

---

!!! info "Kent Beck's 3X Model and the O&A Adoption Stages"
    Kent Beck's **Explore → Expand → Extract** model maps directly to the O&A adoption journey:

    | 3X Phase | O&A Stages | Optimal Behaviour |
    |---|---|---|
    | **Explore** | Stage 1–2 | Maximise learning, tolerate waste, run experiments, accept "hit or miss" — this is normal |
    | **Expand** | Stage 3–4 | Standardise what works, reduce variance, invest in platform, grow usage deliberately |
    | **Extract** | Stage 5 | Automate, measure ROI precisely, optimise cost (SCI), harvest stable value |

    The most common dysfunction: applying **Extract** discipline (ROI tracking, strict governance) to **Explore** work, which kills learning. Or applying **Explore** looseness to **Extract** work, which wastes money. Match the governance model to the phase.

---

## Stage 3: Practicing

> *"AI tools are part of how we work — we have shared practices and are improving them."*

### What This Stage Is About

Stage 3 is the inflection point. AI moves from "thing some of us are experimenting with" to "part of how we work." This is the stage where the benefits in Forsgren et al.'s *Accelerate* research become visible in DORA metrics — specifically, lead time for changes and deployment frequency should begin to improve as AI removes friction from routine engineering tasks.

The discipline required here is consistency, not novelty. The team has prompt templates; now they need to be reused consistently. The team has a PR checklist; now it needs to be applied without exception. The team has a SAST gate; now it needs to run on every AI-assisted PR as a non-negotiable.

Sam Newman's API-first, separation-of-concerns discipline from *Building Microservices* becomes directly relevant in Stage 3. AI tools that are integrated thoughtfully — where each tool has a clear scope, bounded context, and explicit interface — are manageable and auditable. AI tools that are adopted opportunistically, bleeding across service boundaries, become a new class of architectural debt. Every AI tool adoption in Stage 3 gets an ADR.

Stage 3 is also when the team introduces the first agentic tool — in a carefully bounded, read-only context. Agentic tools (Copilot CLI, multi-step code generation assistants) can take sequences of actions rather than responding to individual prompts. This is qualitatively different from a chat assistant and requires qualitatively different oversight. Start with Copilot CLI for read-only tasks: explaining codebases, generating documentation, suggesting test cases. Do not start with agentic tools that modify files or execute commands without human review at every step.

### MSD Health Prerequisite: Level 3

Stage 3 requires:
- CI/CD pipeline established and used for every deployment (no manual deployments)
- Testing pyramid present: unit tests, integration tests, and at minimum a small suite of end-to-end or contract tests
- Trunk-based development or very short-lived feature branches (< 1 day) in practice
- DORA metrics in the Medium band or actively improving toward it

The reason the CI/CD requirement tightens here is that Stage 3 introduces AI assistance for new feature work (not just existing code), which means the feedback loop between AI-generated code and validated, deployed behaviour must be fast and reliable.

### Responsible AI Gate

- [ ] Software Carbon Intensity (SCI) tracking has started — the team knows the approximate energy cost of its AI tool usage and has a baseline ([Environmental Guidance](responsible-ai/environmental.md))
- [ ] Vendor concentration index has been measured — the team knows which providers it depends on and in what proportion ([Market Concentration Guidance](responsible-ai/market-concentration.md))
- [ ] Any agentic tools introduced have documented scope boundaries in Architecture Decision Records ([ADR template](governance/adr-template.md))

### Key Activities

**1. Roll out GitHub Copilot (or equivalent) to all team members**

Stage 3 is when the full team gets coding assistant tooling in the IDE — not just the experimenters. The rollout should be accompanied by a brief onboarding session run by the AI Champions, covering: how to review AI suggestions critically, what the prompt library contains, and how to report problems. This is not a lecture on AI safety — it is a practical hour that prevents the most common mistakes.

**2. Introduce LLM chat tools across engineering workflows**

AI chat tools (ChatGPT, Claude, Copilot Chat, or an enterprise-managed equivalent) become standard workflow tools for:
- Code review assistance: "explain what this function does, what its edge cases are, and what tests it needs"
- Incident triage: "given these syslog lines and this NETCONF error trace, what are the likely causes?"
- ADR drafting: "draft the context and alternatives sections for an ADR on YANG-based vs. flat JSON config models"
- YANG module review: "review this YANG module for RFC 7950 compliance issues and missing mandatory statements"

For every use case, the rule is: **AI drafts, human owns.** The team member reviewing the incident is responsible for the root cause determination. The team member signing off on the ADR is responsible for the decision. AI is a capable, fast first-drafter — not a decision-maker.

**3. Expand the prompt template library to cover all major O&A use cases**

By the end of Stage 3, the prompt library should have ≥30 entries covering the full width of O&A engineering work: YANG authoring and review, NETCONF/RESTCONF test generation, Ansible playbook development, incident triage and postmortem drafting, ADR drafting, OpenConfig augmentation, and CI/CD pipeline YAML generation. The AI Champions drive this, but contributions come from the whole team.

**4. Start measuring Software Carbon Intensity (SCI)**

The [environmental guidance](responsible-ai/environmental.md) defines how to track SCI for AI workloads. Stage 3 is when measurement starts — not optimisation. Holly Cummins' work on sustainable software engineering is directly applicable here: model choice is an energy decision, and right-sizing model selection to the task (using a small, fast model for code completion; reserving large frontier models for complex reasoning tasks) is both a cost and a sustainability practice.

**5. Revisit the Jagged Frontier Map with real evidence**

After 2–3 months of Stage 2 experimentation, the team has evidence about where AI is genuinely strong and weak for O&A tasks. Run a 60-minute session to update the Jagged Frontier Map. Where did the AI surprise you (positively or negatively)? The estimates from Stage 1 should now have some evidence behind them. Update the "Evidence After Stage 2" column and adjust "Recommended Usage" accordingly.

**6. Architecture review: separation of concerns**

Run a targeted review of Stage 2 and Stage 3 AI-assisted PRs specifically for boundary violations. Are AI tools being used in ways that couple previously independent components? Are AI-generated functions mixing concerns (e.g., YANG parsing logic entangled with network connection management)? This is Martin Fowler's *Evolutionary Architecture* principle in practice: AI tools can accelerate both good and bad architectural patterns. Catch the bad ones early.

**7. Introduce the first agentic tool experiment**

Copilot CLI is the recommended starting point. Scope it explicitly:
- ✅ Allowed in Stage 3: read-only queries, documentation generation, test suggestion, codebase explanation
- ❌ Not yet: automated file modification, pipeline execution, anything that interacts with network devices

Write a brief ADR for the introduction of every agentic tool. The ADR should define the scope, the oversight mechanism, and the rollback plan.

**8. DORA checkpoint**

At the midpoint and end of Stage 3, run a deliberate DORA measurement. Is lead time for changes improving? Is deployment frequency increasing? Is change failure rate holding steady or improving? If DORA metrics are not improving after three months of Stage 3 practices, something is wrong — either the AI tools are not being used effectively, or there is an MSD Health bottleneck that needs attention. Gene Kim and Jez Humble's *DevOps Handbook* is unambiguous on this: flow, feedback, and continuous learning are the mechanisms. If they're not working, identify the constraint.

### TM Forum Checkpoint

Has the team used at least one TM Forum Open API in a new integration this stage? Has any AI-generated YANG module passed `pyang --strict` validation in CI? These are not box-ticking exercises — they are indicators that the team's DRY discipline (check what exists before building) and validation discipline (AI output must be mechanically validated, not just reviewed) are working.

### Metrics

From Stage 3 onwards, all five DORA metrics are tracked per sprint alongside the full SPACE framework. AI adoption KPIs 1–5 defined in the [measurement framework](measurement/) are tracked and reviewed quarterly.

### Exit Criteria

All of the following must be true to advance to Stage 4:

- [ ] ≥80% of team members actively using AI tools weekly (tracked, not self-reported)
- [ ] DORA metrics moving toward the High band (not necessarily there yet, but trajectory is positive)
- [ ] Prompt template library has ≥30 entries, actively reused (not just committed and forgotten)
- [ ] SCI tracking is live and a baseline has been established
- [ ] Zero critical SAST findings in AI-assisted PRs that were merged without remediation
- [ ] At least one agentic tool introduced with a documented ADR and explicit scope boundaries
- [ ] Vendor concentration index measured
- [ ] MSD Health at Level 3
- [ ] Responsible AI gate passed

---

## Stage 4: Scaling

> *"AI is embedded in team workflow — we're using agentic tools and seeing measurable DORA improvement."*

### What This Stage Is About

Stage 4 is where AI tooling shifts from assisting individual team members to being embedded in the team's delivery pipeline itself. AI-assisted code review, AI-generated release notes, AI-assisted incident triage in the alerting pipeline, and agentic tools handling multi-step O&A-specific tasks (YANG refactoring, config diff summarisation, test fixture generation from schemas) are all Stage 4 capabilities.

This stage requires strong MSD Health foundations — specifically, the fitness functions and architectural discipline that ensure AI-assisted pipeline steps don't undermine the reliability of the overall system. Gregor Hohpe's framing from *The Architect Elevator* is useful here: Stage 4 is when AI adoption becomes an organisation-level concern, not just a team-level one. The O&A team's practices become reference architecture for other teams. The decisions made here — about model choices, vendor contracts, agentic scope boundaries — have wider implications.

The responsible AI concerns sharpen significantly in Stage 4. Vendor concentration is now a strategic risk: if the team's CI/CD pipeline depends on a single AI provider's API and that provider has an outage, does the pipeline stop? That is not a hypothetical question — it needs an explicit answer in an ADR. Holly Cummins' sustainability work is also directly relevant: as AI usage scales to the pipeline level, SCI is no longer a monitoring concern — it is an architecture concern.

### MSD Health Prerequisite: Level 4

Stage 4 requires:
- DORA High band across all four metrics
- Strong testing discipline: high unit test coverage, integration tests for all critical paths, contract tests for inter-service boundaries
- Fitness functions in place (automated architectural guardrails — e.g., `pyang --strict` in CI for all YANG changes, SCI budget as a pipeline gate, test coverage thresholds)
- Architectural discipline: ADRs exist for all significant decisions, SoC enforced through code review and tooling, service boundaries explicit

If the team has reached Stage 3 exit criteria but MSD Health is not yet at Level 4, the right move is to invest in MSD improvement before advancing. A Stage 4 agentic pipeline on a Level 3 MSD foundation is a compounding risk.

### Responsible AI Gate

- [ ] Vendor concentration index is measured and below the team's defined threshold (define this threshold in an ADR — a reasonable starting point is: no single AI provider accounts for >60% of production AI workloads)
- [ ] Multi-provider strategy documented: at minimum, the team has identified fallback options for its primary AI tool dependencies
- [ ] At least one OSS model alternative has been evaluated for a production use case (e.g., CodeLlama or IBM Granite for code completion; a locally-hosted model for YANG-specific tasks)
- [ ] Reskilling investment tracked per team member — every team member should be able to articulate their AI literacy growth over the past six months

### Key Activities

**1. Introduce agentic tools for complex O&A tasks**

Stage 4 agentic tool use goes beyond read-only assistance:

| Agentic Use Case | Tool | Oversight Mechanism |
|---|---|---|
| Multi-file YANG refactoring (e.g., renaming a grouping used across 20 modules) | Copilot Workspace or equivalent | Human review of every file change; `pyang --strict` CI gate |
| YANG → test fixture generation (generate `pytest` fixtures from a YANG schema) | Custom pipeline step | Fixtures reviewed before merge; CI validates against a NETCONF simulator |
| Config diff → change summary (generate a human-readable summary of a large config diff) | LLM in the pipeline | Summary is informational only; never replaces the diff in the audit trail |
| Incident triage agent (correlate syslog events, NETCONF errors, and known issues into a triage brief) | LLM in the alerting pipeline | Triage brief is advisory; on-call team member makes all decisions |

Every agentic tool use case in Stage 4 has:
- A documented ADR with scope boundaries, oversight mechanism, and rollback plan
- A human review step before any AI-generated output enters production
- An explicit definition of what the agent is *not* authorised to do

**2. AI in the CI/CD pipeline**

Stage 4 introduces AI as a pipeline participant, not just a developer tool:

- **AI-assisted code review**: automated AI pre-review of PRs surfacing complexity hotspots, missing tests, and potential security issues before the human reviewer sees the PR
- **AI-generated release notes**: structured LLM summarisation of commit messages, ADRs, and JIRA tickets into human-readable release notes
- **AI-assisted incident triage**: structured log analysis fed into an LLM to generate a first-pass triage brief for the on-call team member

These pipeline integrations must be designed with graceful degradation: if the AI component fails, the pipeline continues (possibly slower or with less context) — it does not block deployment.

**3. Custom O&A AI pipeline**

Stage 4 is where the team builds O&A-specific AI capabilities:

- YANG schema → NETCONF test fixture generation pipeline
- Config diff → readable change summary for change management
- Automated YANG lint + documentation generation in CI (runs `pyang --lint`, generates HTML docs, posts to Confluence on merge)
- Network event correlation: structured syslog + SNMP trap data fed to a context-aware LLM for pattern detection

These are not generic AI tools — they are O&A-specific workflows that encode team knowledge about protocol semantics, device idiosyncrasies, and operational requirements. They represent a compounding return on the prompt library and Jagged Frontier Map work from earlier stages.

**4. Evaluate OSS models for pipeline tasks**

Not every pipeline AI task needs a frontier model. Code completion for boilerplate generation, YANG documentation formatting, and simple log summarisation are tasks where smaller, locally-hosted or self-hosted models (CodeLlama, IBM Granite, or domain-specific fine-tunes) can perform comparably while reducing SCI and vendor concentration risk.

Run at least one structured evaluation: pick a Stage 4 use case, define evaluation criteria, test a frontier model and an OSS alternative side by side, and document the result in an ADR. The result may be "frontier model wins for this task" — that is a valid finding. The point is to have evidence, not assumptions.

**5. Vendor concentration audit**

Review the team's AI tool dependencies with the same rigour applied to any critical infrastructure dependency. Questions to answer:
- If GitHub Copilot is unavailable for a week, what breaks and what degrades?
- If the Azure OpenAI endpoint used for pipeline triage is unavailable, what is the graceful degradation behaviour?
- What is the contractual exit path from each AI vendor dependency?

Document findings in ADRs. Update exit criteria for each dependency. This is not a theoretical exercise — it is the same risk management discipline applied to network vendor lock-in, applied to AI vendors.

**6. Reskilling: structured learning for team members not yet at Stage 3 practices**

Stage 4 is when the risk of a two-tier team (AI-fluent and AI-excluded) becomes real and measurable. Track reskilling hours per team member. Identify team members who are at Stage 2 practices while the team is operating at Stage 4, and invest explicitly in bringing them forward — pair programming with AI, AI Champion mentoring, and structured learning time. The SPACE-S satisfaction metric is the leading indicator: if satisfaction scores diverge between team members, investigate.

### DORA Target

DORA High band across all four metrics by the end of Stage 4. For a telecom network automation team, High band targets (per Forsgren et al., *Accelerate*):
- Deployment frequency: multiple times per week
- Lead time for changes: between one day and one week
- Change failure rate: 0–15%
- Mean time to restore: less than one day

### Exit Criteria

All of the following must be true to advance to Stage 5:

- [ ] DORA at High band across all four metrics
- [ ] At least one agentic tool in use for a production workflow with a documented ADR
- [ ] At least one OSS model evaluated for a production use case, with findings documented
- [ ] Vendor concentration index measured and below the team-defined threshold
- [ ] Multi-provider strategy documented
- [ ] Reskilling hours tracked; no team member operating more than one stage behind the team average
- [ ] SPACE-S satisfaction score stable or improving despite increased AI tooling complexity
- [ ] MSD Health at Level 4
- [ ] Responsible AI gate passed

---

## Stage 5: Optimizing

> *"We continuously improve our AI practices, contribute to the wider organisation, and are approaching DORA Elite."*

### What This Stage Is About

Stage 5 is not a destination — it is a cadence. The team is no longer following a roadmap; it is generating new practices, validating them with evidence, retiring what doesn't work, and sharing what does. This is Dave Farley's *continuous improvement* principle operating at full maturity: the team's most important output is not just software, it is learning.

At Stage 5, the O&A team's AI practices are mature enough to be worth sharing. Other teams in the organisation are in their Stage 1 or Stage 2. The O&A team's experience with AI-assisted YANG development, NETCONF test generation, and agentic incident triage represents genuinely hard-won knowledge that doesn't need to be rediscovered by every team independently.

The Responsible AI framework is now deeply embedded — not enforced by gates, but practiced habitually. SCI is tracked and optimised. Vendor concentration is managed with the same rigour as network vendor dependencies. The reskilling investment is continuous and visible.

DORA Elite band is the target. For context, DORA Elite teams (per Forsgren et al.) deploy on demand, recover from incidents in less than one hour, have change failure rates below 5%, and have lead times measured in hours, not days. For a O&A team operating carrier-grade network automation, this level of delivery discipline represents a fundamental competitive and operational capability.

### MSD Health Prerequisite: Level 5

Stage 5 requires:
- DORA Elite band (or active trajectory toward it)
- Fitness functions enforced automatically in the pipeline — architectural guardrails are not manual review steps but automated pipeline gates
- Continuous improvement cadence: the team has a structured practice of identifying bottlenecks, running improvement experiments, and measuring results

### Key Activities

**1. Regular practice retrospectives: what can be improved, automated, or retired?**

The AI retro questions in [team norms](governance/team-norms.md) are a starting point. At Stage 5, the team runs deeper quarterly practice retrospectives:
- Which AI workflows are genuinely improving DORA metrics? Which are neutral or negative?
- Which prompt templates are stale or misleading? Retire them.
- Which agentic tools are running reliably? Which need tighter scope or better oversight?
- What has the team learned about the jagged frontier that should update the map?

**2. Contributing to TM Forum AI working groups or internal community of practice**

The team's accumulated experience — with YANG-aware AI tools, NETCONF test generation pipelines, and responsible AI practices for telecom infrastructure — is valuable beyond the O&A boundary. Stage 5 team members contribute to:
- Internal community of practice: presenting case studies, running workshops for Stage 1–2 teams
- TM Forum Open Digital Lab or AI/ML working groups: contributing O&A-specific prompts, use cases, and findings to the industry body
- Internal tooling contributions: publishing O&A-specific prompt templates, ADR templates, and pipeline integrations as reusable components for other teams

**3. Building custom AI capabilities specific to the O&A domain**

Stage 5 is where the team can invest in truly domain-specific AI capabilities:
- **YANG-aware fine-tuned model**: a model fine-tuned on the team's YANG corpus, RFC 7950, and OpenConfig schemas — dramatically better than a general model at YANG authoring and review tasks
- **Network-context RAG (Retrieval-Augmented Generation)**: a RAG pipeline over the team's network documentation, device capability databases, and operational runbooks — enabling AI-assisted triage that has access to O&A-specific context rather than relying on general training data
- **Custom fitness functions for AI output**: automated checks that AI-generated YANG, Ansible, and config templates meet O&A's specific quality standards (beyond `pyang --strict`)

These capabilities should be designed with Holly Cummins' sustainability principles in mind: right-size the model to the task, monitor SCI continuously, and prefer smaller, purpose-built models over repeatedly routing everything through frontier models.

**4. Publishing internal case studies: what moved the metrics, what didn't**

The team documents what actually improved DORA metrics and what didn't, with specifics:
- "AI-assisted test generation in Stage 2 improved our test coverage from 42% to 67% over three months — this correlated with a reduction in change failure rate from 18% to 9%"
- "We introduced AI-assisted code review in Stage 3 and saw no measurable reduction in lead time, but SPACE-S satisfaction improved — team members felt more confident in their PRs"
- "The YANG refactoring agent in Stage 4 reduced the time for a major schema refactor from 3 days to 4 hours — but we found it introduced subtle naming inconsistencies that our `pyang` gate caught twice before we tightened the prompt"

These case studies are the team's contribution to the organisation's evidence base. They are more valuable than any vendor case study because they are grounded in the O&A domain and the team's specific starting conditions.

**5. Mentoring other teams through Stages 1–3**

The AI Champions from each O&A squad are well-placed to support other teams in their Stage 1 and Stage 2 work. This is both organisationally valuable and professionally developmental. Mentoring requires explaining *why* the sequence matters — not just *what* to do — which deepens the O&A team's own understanding of the framework.

### DORA Target

DORA Elite band. For context:
- **Deployment frequency**: on demand (multiple times per day)
- **Lead time for changes**: less than one hour
- **Change failure rate**: 0–5%
- **Mean time to restore**: less than one hour

For a network automation team operating on carrier infrastructure, some of these targets require explicit discussion — "on demand" deployment has different meaning when pushing to a live network versus a SaaS application. The team should define what Elite band means for its specific operational constraints, rather than applying software SaaS benchmarks uncritically.

### Metrics Focus

At Stage 5, the metrics focus shifts from tracking adoption to tracking **sustainability and improvement rate**:
- Is the SCI trend flat or improving despite increased AI usage?
- Is SPACE-S satisfaction stable or improving as AI tooling complexity increases?
- Is the vendor concentration index being actively managed?
- Is the reskilling investment growing or being cut?
- What is the team's **continuous improvement rate** — how many improvement experiments per quarter, and what percentage produce measurable positive results?

---

## The O&A Jagged Frontier Map

> *"AI capability is not a uniform line. It is a jagged edge."* — Ethan Mollick, *Co-Intelligence*

The Jagged Frontier Map is the team's living evidence base for where AI is genuinely useful for O&A-specific tasks and where human expertise must lead. The estimates in the "AI Strength Estimate" column reflect the team's prior belief at Stage 1. The "Evidence After Stage 2" column is filled in during Stage 3 based on actual experimentation. The "Recommended Usage" column evolves with each stage.

**Instructions:**
- Fill in the "Evidence After Stage 2" column during the Stage 3 Jagged Frontier review session
- Update "Recommended Usage" based on evidence, not assumptions
- Add rows for O&A-specific tasks not listed here
- Retire rows where AI has proven consistently unreliable — remove them from recommended usage entirely

| Task Category | Specific O&A Task | AI Strength Estimate | Evidence After Stage 2 | Recommended Usage |
|---|---|---|---|---|
| Code generation | YANG module authoring (`leaf`, `list`, `grouping`, `augment`) | High | TBD | AI drafts, human validates with `pyang --lint` and `pyang --strict` |
| Code generation | `ncclient` Python session and RPC wrappers | High | TBD | AI generates from YANG schema; team member reviews error handling |
| Code generation | Ansible task and playbook scaffolding | High | TBD | AI scaffolds from requirements; team member validates idempotency |
| Code generation | Jinja2 config templates from sample device configs | Medium | TBD | AI generates; team member validates device-specific edge cases |
| Test generation | `pytest` unit tests for Python network utilities | High | TBD | AI generates; team member reviews edge cases and mocking strategy |
| Test generation | NETCONF RPC XML fixtures from YANG `rpc` definitions | Medium | TBD | AI scaffolds; team member writes device-specific interaction logic |
| Test generation | RESTCONF integration test scaffolding | Medium | TBD | AI scaffolds; team member validates against target device |
| Test generation | Contract tests for northbound APIs | Low–Medium | TBD | AI suggests structure; team member owns contract semantics |
| Documentation | YANG module documentation (descriptions, references) | High | TBD | AI drafts from schema; team member verifies RFC references |
| Documentation | Architecture Decision Records (ADRs) | Medium | TBD | AI drafts context and alternatives sections; human owns the decision |
| Documentation | Runbook drafting from existing playbooks | Medium | TBD | AI drafts; team member validates operational accuracy |
| Documentation | OpenConfig/vendor augmentation explanation | Medium | TBD | AI explains; team member validates against vendor-specific behaviour |
| Incident triage | Incident timeline summarisation from postmortem notes | High | TBD | AI summarises; human validates completeness and sequence |
| Incident triage | Structured log correlation (syslog + NETCONF errors) | Medium | TBD | AI suggests correlations; on-call team member validates |
| Incident triage | Root cause analysis | Low–Medium | TBD | Human leads; AI assists with log pattern matching and RFC lookup |
| Architecture | Service boundary decisions | Low | TBD | Human only — AI can suggest patterns, not own decisions |
| Architecture | YANG modelling trade-offs (flat vs. hierarchical) | Low–Medium | TBD | Human expert leads; AI can surface RFC precedents |
| Security | Security review of NETCONF RPCs and access control | Low | TBD | Human only — AI flags known patterns only; not a replacement for security review |
| Security | Credential and secret detection in configs | Medium | TBD | AI-assisted scanning as a supplement to SAST, not a replacement |
| Protocol knowledge | RFC 7950 / RFC 8040 compliance questions | Medium | TBD | AI is useful for common cases; novel edge cases require human expert |
| Protocol knowledge | Novel YANG RFC interpretation and edge cases | Low | TBD | Human expert required; AI may hallucinate RFC details |
| Protocol knowledge | Vendor-specific YANG deviation explanation | Low–Medium | TBD | AI provides starting point; always validate against vendor documentation |
| Pipeline / DevOps | CI/CD YAML generation (GitHub Actions, GitLab CI) | High | TBD | AI generates; team member reviews for security and correctness |
| Pipeline / DevOps | `pyang` validation pipeline configuration | Medium | TBD | AI scaffolds; team member validates strict/lint flag behaviour |

---

## References

The following works ground the principles and practices in this roadmap. Where possible, specific concepts are cited at the point of use in the document.

| Author(s) | Work | Key Concept Applied |
|---|---|---|
| **Ethan Mollick** | *Co-Intelligence: Living and Working with AI* (2024) | Jagged frontier — AI capability is uneven; map it before adopting |
| **Dave Farley** | *Modern Software Engineering* (2021) | Fast feedback loops as the foundation for safe AI adoption; continuous improvement cadence |
| **Dave Farley & Jez Humble** | *Continuous Delivery* (2010) | Pipeline discipline as the prerequisite for AI-assisted deployment |
| **Nicole Forsgren, Jez Humble & Gene Kim** | *Accelerate: The Science of Lean Software and DevOps* (2018) | DORA metrics and performance bands as the measurement framework |
| **Nicole Forsgren et al.** | SPACE Framework (2021) | Multi-dimensional developer productivity measurement beyond activity metrics |
| **Martin Fowler** | *Refactoring* (2nd ed., 2018); *Evolutionary Architecture* | SoC discipline in AI-assisted codebases; architecture fitness functions |
| **Gregor Hohpe** | *The Architect Elevator* (2020); *Enterprise Integration Patterns* | Stage 4–5 reporting framing; AI adoption as an organisational architecture concern |
| **Holly Cummins** | *Cloud Native* (2022); Sustainable Software Engineering | SCI tracking; right-sizing model selection to the task; sustainability as an engineering discipline |
| **Gene Kim & Jez Humble** | *The DevOps Handbook* (2016); *The Phoenix Project* (2013) | Three Ways (flow, feedback, learning) as the transformation model |
| **Sam Newman** | *Building Microservices* (2nd ed., 2021) | API-first design; SoC as a constraint on agentic tool scope |
| **TM Forum** | Open Digital Architecture; Open API table | DRY principle for telecom integrations — check what exists before building |
