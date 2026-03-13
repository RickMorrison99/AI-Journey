# AI-Agentic Adoption Maturity Model
## O&A Team — OSS - Orchestration and Automation

---

## Overview

AI adoption does not happen in a vacuum. It happens on top of whatever software delivery foundation already exists — and it amplifies that foundation, good or bad. A team with disciplined testing, trunk-based development, and fast feedback loops will see AI accelerate every one of those strengths. A team with manual deployments, fragile pipelines, and untested code will see AI accelerate technical debt, incorrect configuration generation, and undetectable regressions.

This model defines two independent but tightly coupled axes. **Axis 1** describes how deeply a team has integrated AI into its daily engineering workflow. **Axis 2** describes the health of the team's Modern Software Delivery (MSD) practices — the engineering foundation that determines how safely and effectively AI adoption can grow. The critical insight, drawn from Dave Farley's *Modern Software Engineering* and reinforced by DORA research, is that **MSD Health is not optional**: it is the load-bearing structure on which AI Adoption is built.

For the O&A team — working in YANG modelling, network config generation, automated test authoring for NETCONF/RESTCONF interfaces, and incident triage across multi-vendor platforms — the stakes are high. AI-generated configuration pushed into a production network without a verified, automated validation pipeline is not productivity; it is risk at scale. This model exists to make those risks explicit and to define a safe, sequenced path to genuine AI-augmented engineering.

> **Core principle:** You cannot sustainably reach AI Adoption Level 4 on an MSD Health Level 1 foundation.  
> AI amplifies what is already there — good or bad.

---

## 2D Maturity Matrix

The matrix below shows the intersection of MSD Health (rows) and AI Adoption Depth (columns). Cells marked **✓** are sustainable operating positions. Cells marked **⚠** are unstable — technically reachable in the short term but producing compounding dysfunction. Cells marked **✗** are effectively unreachable without first advancing MSD Health.

```
                        ┌─────────────────── AI ADOPTION DEPTH ───────────────────────┐
                        │ L1: Unaware │ L2: Experimenting │ L3: Practicing │ L4: Scaling │ L5: Optimizing │
┌───────────────────────┼─────────────┼───────────────────┼────────────────┼─────────────┼────────────────┤
│ MSD L5: Optimizing    │     ✓       │        ✓          │       ✓        │      ✓      │       ✓        │
│ MSD L4: Managed       │     ✓       │        ✓          │       ✓        │      ✓      │       ⚠        │
│ MSD L3: Defined       │     ✓       │        ✓          │       ✓        │      ⚠      │       ✗        │
│ MSD L2: Repeatable    │     ✓       │        ✓          │       ⚠        │      ✗      │       ✗        │
│ MSD L1: Fragile       │     ✓       │        ⚠          │       ✗        │      ✗      │       ✗        │
└───────────────────────┴─────────────┴───────────────────┴────────────────┴─────────────┴────────────────┘

  ✓  Sustainable operating position
  ⚠  Unstable — produces compounding technical and delivery risk
  ✗  Effectively unreachable without advancing MSD Health first
```

| Symbol | Meaning |
|--------|---------|
| ✓ | Sustainable — AI investment pays off here |
| ⚠ | Unstable — short-term gains mask accumulating risk |
| ✗ | Unreachable without MSD Health improvement first |

---

## Axis 1: AI Adoption Depth

### Level 1 — Unaware
**"AI is something others do."**

#### People
Team Members are aware that AI tools exist in the industry but have not personally adopted any in their workflow. Skills are entirely traditional: manual YANG authoring, handwritten test scaffolding, copy-paste config templating. No internal discussion of AI tooling has occurred in team rituals. Leadership has not signalled AI as a priority.

#### Process
No AI touchpoints exist in any defined workflow. All code review, documentation, config generation, and test authoring is performed without AI assistance. There is no policy on AI tool use — neither permissive nor restrictive.

#### Tooling
Standard IDE (e.g., VS Code, PyCharm) without AI extensions. No LLM access provisioned. No internal experimentation platforms.

#### Telecom-Specific Signals (O&A Context)
- YANG modules authored entirely by hand with no suggestion tooling
- NETCONF/RESTCONF test cases written from scratch per feature
- Incident triage relies entirely on operator familiarity and tribal knowledge
- Network config templates maintained as static Jinja2 or textfsm files with no generation assistance
- No AI-assisted review of OpenConfig or vendor-specific augmentations

#### Entry Criteria
Default starting state. No deliberate criteria required.

#### Exit Criteria / Next Step → Level 2
- At least 2–3 team members have access to a provisioned LLM tool (GitHub Copilot, ChatGPT, internal instance)
- At least one team retrospective or demo has featured an AI-assisted workflow
- No formal process change required yet — individual experimentation is sufficient

---

### Level 2 — Experimenting
**"A few of us are trying things."**

#### People
A small cohort (typically 2–5 team members) are actively experimenting with AI tools on an individual basis. Results are shared informally — in Slack, over coffee, occasionally in a demo. There is no shared prompt library, no agreed conventions, and no expectation of consistency. Senior team members may be skeptical; junior team members may be enthusiastic but unsupported. Skills in prompt construction are nascent and idiosyncratic.

#### Process
AI use is entirely ad hoc and outside any defined process. Team Members may use AI to draft a YANG leaf description, generate a Python stub, or ask for help debugging a NETCONF session — but these acts are invisible to the team workflow and produce no shared artefacts. Output is not systematically reviewed or validated.

#### Tooling
Individual LLM subscriptions or team-wide access to a tool like GitHub Copilot. Possible use of web-based ChatGPT or Claude for one-off questions. No integration with CI/CD or internal knowledge bases. Tooling choices are personal preference.

#### Telecom-Specific Signals (O&A Context)
- An team member uses Copilot to stub out a `ncclient` Python test but does not run it through the team's test framework
- YANG snippets generated by ChatGPT and pasted in without deviation from team conventions
- Incident postmortems occasionally drafted with LLM assistance but not peer-reviewed
- Ad hoc use of AI to explain vendor-specific CLI differences or translate between IOS-XR and Junos config idioms
- No repeatability: what one team member does with AI, another does manually

#### Entry Criteria
- Provisioned LLM access for interested team members
- At least informal permission (explicit or implied) from team lead to experiment
- No MSD Health prerequisite beyond Level 1

#### Exit Criteria / Next Step → Level 3
- Team has agreed on at least one shared workflow where AI is consistently applied (e.g., "we always use AI to draft test docstrings")
- A shared prompt library or prompt conventions doc exists, even if lightweight
- At least one retrospective has discussed AI tool output quality and failure modes
- MSD Health must be at Level 2 or above before advancing

---

### Level 3 — Practicing
**"AI is part of how we work."**

#### People
AI-assisted workflows are normalized across the majority of the team (typically 60–80% of team members). There is a shared understanding of where AI adds value and where it misleads. Team Members can articulate failure modes: hallucinated YANG syntax, incorrect RFC reference, untestable generated code. A designated "AI practice lead" or informal champion exists. New joiners are onboarded into AI-assisted workflows explicitly.

#### Process
AI use is embedded in several defined team workflows. Defined touchpoints might include: AI-assisted first-draft generation of YANG modules, AI-augmented test case scaffolding, LLM-assisted PR review commentary, AI-drafted ADR (Architecture Decision Record) templates. Outputs are treated as drafts requiring human review, not final artefacts. A lightweight prompt library exists and is version-controlled.

#### Tooling
- GitHub Copilot or equivalent IDE integration standardised across team
- Shared prompt library in version control (e.g., `prompts/` directory in team repo)
- LLM access integrated into developer workflow but not yet into CI/CD pipeline
- Possibly experimenting with local/private LLM instances for sensitive network config data

#### Telecom-Specific Signals (O&A Context)
- YANG module stubs generated by AI, reviewed against `pyang` lint and team conventions before commit
- Test scaffolding for gNMI/NETCONF operations generated by AI, then filled in and validated by team member
- AI-assisted translation of vendor-specific feature descriptions into RFC-aligned YANG augmentations
- Postmortem first drafts generated from structured incident data using a team-standard prompt
- Team Members routinely ask AI to explain unfamiliar YANG patterns (e.g., `when` and `must` constraints) and validate the answers before applying
- Prompt library includes reusable prompts for: YANG leaf generation, test stub creation, config diff explanation, ADR first drafts

#### Entry Criteria
- MSD Health Level 2 minimum (basic CI, some automated testing)
- Shared prompt library established
- At least one AI-assisted workflow is defined, documented, and used consistently
- Team retrospectives include AI workflow discussion at least monthly

#### Exit Criteria / Next Step → Level 4
- AI tooling integrated into at least one CI/CD stage (e.g., automated docstring generation check, AI-assisted PR description generation)
- Team has evaluated and adopted at least one AI agent or multi-step automation (not just completion/chat)
- Prompt library actively maintained with versioning and review
- MSD Health must be at Level 3 or above before scaling

---

### Level 4 — Scaling
**"AI is embedded in our team workflow."**

#### People
AI-assisted engineering is the team default, not the exception. All team members — regardless of experience level — participate in AI-augmented workflows. There is explicit investment in AI skill development: prompt engineering, chain-of-thought structuring, agent orchestration. The team distinguishes between AI for generation, AI for verification, and AI for exploration. Team Members actively contribute to improving shared prompts and tooling configurations. Leadership tracks AI adoption metrics.

#### Process
AI is integrated into the Software Delivery Lifecycle (SDLC) at multiple stages: story refinement (AI-assisted acceptance criteria drafting), implementation (AI pair programming with structured review), testing (AI-generated test cases validated against coverage targets), and operations (AI-assisted log analysis and incident triage workflows). Agentic tools may handle defined, bounded subtasks autonomously (e.g., auto-generating pyang-validated YANG from a structured feature specification). All AI-generated artefacts flow through the standard CI/CD pipeline — there are no AI bypass paths.

#### Tooling
- IDE AI integration (Copilot, Cursor, or equivalent) standardised
- CI/CD pipeline includes AI-assisted stages: automated PR description generation, AI-assisted test coverage gap analysis, LLM-powered lint commentary
- Agentic tools (e.g., GitHub Copilot Workspace, custom LangChain/LlamaIndex agents) used for bounded, supervised automation tasks
- Internal LLM deployment or enterprise-grade private API for sensitive network topology and configuration data
- Prompt library versioned, reviewed, and integrated into team onboarding

#### Telecom-Specific Signals (O&A Context)
- Agentic workflow: team member provides a feature spec → agent drafts YANG module → `pyang` validation runs in CI → team member reviews and approves
- AI generates NETCONF/gNMI test suites from YANG schema definitions; tests run in CI against a simulated topology (e.g., Containerlab)
- Incident triage assistant ingests structured alarm data and suggests RCA hypotheses with supporting evidence from past postmortems
- AI-assisted config drift detection: LLM compares intended state (YANG/NETCONF) against observed device state and flags deviations with natural-language explanation
- ADRs drafted using AI with explicit reference to team architectural principles; all ADRs version-controlled
- Story refinement: AI generates acceptance criteria from feature description; PO and lead team member review before sprint commitment

#### Entry Criteria
- MSD Health Level 3 minimum (CI/CD established, testing pyramid, trunk-based development attempted)
- At least one agentic or multi-step AI workflow in production use
- AI tooling integrated into CI/CD pipeline at one or more stages
- Prompt library formally maintained with ownership assigned

#### Exit Criteria / Next Step → Level 5
- Team runs regular AI workflow retrospectives producing measurable improvements to prompts, agents, or tooling
- AI adoption metrics tracked and reviewed (e.g., AI-assisted PR ratio, time saved in test authoring, incident triage MTTR)
- At least one AI workflow has been measured, found ineffective, and deliberately removed or redesigned
- MSD Health must be at Level 4 or above

---

### Level 5 — Optimizing
**"We continuously improve our AI practices."**

#### People
The team treats AI tooling as a first-class engineering system subject to the same improvement disciplines applied to any other system: measurement, experimentation, feedback loops, and deliberate retirement of ineffective practices. Team Members are fluent in evaluating LLM output quality, constructing evaluation harnesses for AI-assisted workflows, and contributing to internal AI capability building across the broader organisation. The team actively publishes learnings (internal blog posts, lunch-and-learns, contributions to org-wide AI guilds).

#### Process
AI workflows are subject to continuous improvement using PDSA (Plan-Do-Study-Act) or equivalent cycles. The team maintains an AI workflow improvement backlog. Experiments are time-boxed and measured. Ineffective AI integrations are retired without ceremony. AI is used not just for implementation but for process design: AI-assisted retrospective facilitation, AI-powered delivery metrics analysis, AI-assisted capacity planning for architecture changes.

#### Tooling
- Full agentic pipeline for defined workflow categories (YANG authoring, test generation, incident triage)
- AI evaluation harnesses: automated checks of AI output quality against ground-truth test cases
- Custom fine-tuned or RAG-augmented models trained on internal YANG schemas, ADR corpus, and past incident data
- Contribution to or consumption of open-source AI tooling for network automation (e.g., network-specific LLM benchmarks)
- AI observability: tracing, logging, and cost tracking for all AI pipeline stages

#### Telecom-Specific Signals (O&A Context)
- RAG-augmented assistant trained on team's full YANG corpus, past ADRs, and vendor documentation provides accurate, citation-linked answers to architecture questions
- Automated evaluation harness runs weekly against a curated set of YANG generation test cases; prompt degradation detected and corrected proactively
- Incident triage AI system tracks its own accuracy (predicted RCA vs. actual RCA after postmortem) and surfaces improvement opportunities
- Team publishes internal case study: "How we reduced YANG module authoring cycle time by 40% using AI-assisted review pipelines"
- AI adoption metrics reviewed at quarterly engineering health review alongside DORA metrics

#### Entry Criteria
- MSD Health Level 4 minimum (DORA High band, strong testing, architectural discipline)
- AI workflow improvement backlog exists and is actively groomed
- At least one AI evaluation harness in operation
- Team has demonstrated ability to retire or redesign an ineffective AI workflow

#### Exit Criteria
- Sustained DORA Elite band with AI contributing measurably to delivery velocity
- Active contribution to broader organisational AI capability
- AI and MSD improvement cycles unified into a single continuous improvement practice

---

## Axis 2: MSD Health

### Level 1 — Fragile
**"Manual, ad hoc, low confidence in the pipeline."**

#### CI/CD
No meaningful CI/CD pipeline exists, or the pipeline exists on paper but is routinely bypassed. Builds are triggered manually or by convention. Deployments to test/staging environments are manual and infrequent. "It works on my machine" is a common phrase.

#### Testing Discipline
Testing is manual and performed by a QA individual or not at all. Automated tests are absent or cover less than 20% of the codebase in any meaningful way. Test results are not treated as blocking signals. No testing pyramid — integration and end-to-end tests may exist in isolation but unit tests do not.

#### Trunk-Based Development
Long-lived feature branches (weeks to months). Merge conflicts are frequent and painful. `main` or `master` is not in a releasable state at any given time. No pull request discipline; large, infrequent merges.

#### Architecture Practices
No ADRs. No defined architectural principles. Code duplication is widespread. Separation of concerns is absent or accidental. API contracts between services are informal or undocumented. Technical debt is acknowledged but not managed.

#### DORA Band
**Low** — infrequent deployments (monthly or less), high change failure rate (>30%), slow recovery from incidents (days).

#### Observable Signals in O&A Context
- YANG modules committed directly to `main` without review or automated validation (`pyang`, `yanglint`)
- NETCONF/gNMI integration tests run manually by one or two team members who "know how to do it"
- Config generation scripts live on individual laptops; no version control discipline
- Incidents resolved by one expert who SSH'd directly into the device; no documented runbooks
- No separation between dev, test, and production network topology environments

#### AI Ceiling
**Level 2 (Experimenting) only.**  
Advancing beyond Level 2 on a Fragile foundation accelerates dysfunction. See [The AI Ceiling Rule](#the-ai-ceiling-rule).

---

### Level 2 — Repeatable
**"Basic CI, some testing, inconsistent practices."**

#### CI/CD
A basic CI pipeline exists (e.g., GitHub Actions, GitLab CI, Jenkins) and runs on every pull request. The pipeline includes build and some automated tests. However, it is slow (>20 minutes), flaky, or inconsistently maintained. CD is manual: a human triggers deployments after CI passes. Pipeline failures are sometimes ignored or bypassed.

#### Testing Discipline
Unit tests exist for some modules but coverage is uneven (20–50%). A testing philosophy has been discussed but not formalised. Integration tests exist but are slow and non-deterministic. No agreed testing pyramid. TDD is practiced by some team members individually but not as a team norm.

#### Trunk-Based Development
PR-based workflow with short-lived branches (days), but merging to `main` is not yet daily. Feature flags are unknown or unused. Some attempt at branch hygiene but inconsistent.

#### Architecture Practices
Some ADRs exist but are inconsistently maintained. API contracts between services are partially documented (e.g., OpenAPI specs for some services). DRY and SoC are understood in principle but not enforced. Code review exists but quality is inconsistent.

#### DORA Band
**Low to Medium** — deployments weekly to monthly, change failure rate 15–30%, mean time to restore hours to days.

#### Observable Signals in O&A Context
- `pyang` validation runs in CI but other YANG quality checks are absent
- Some `ncclient`/`nornir` integration tests exist but run only on developer request, not automatically
- Config generation code is in a shared repo but not covered by tests
- Incident runbooks exist for the most common failure modes but are outdated
- YANG module review is done in PRs but reviewers lack automated tooling support

#### AI Ceiling
**Level 3 (Practicing).**

---

### Level 3 — Defined
**"CI/CD established, testing pyramid, trunk-based development attempted."**

#### CI/CD
CI/CD pipeline is reliable, fast (<10 minutes for unit/integration test suite), and consistently enforced — no merge to `main` without green pipeline. CD pipeline exists for at least test/staging environments; production deployment is partially automated (human approval gate only). Pipeline is treated as a first-class engineering asset: failures are fixed immediately, flakiness is tracked and resolved.

#### Testing Discipline
Testing pyramid is understood and practiced: substantial unit test coverage (>60%), integration tests for key interfaces, limited end-to-end tests. TDD is practiced by most team members for new code. Test quality is reviewed in PRs. Mutation testing or coverage thresholds enforced in CI.

#### Trunk-Based Development
Trunk-based development (or near-trunk with branches <24–48 hours) is the team norm. Feature flags used for in-progress work. `main` is releasable at any time. PRs are small and focused.

#### Architecture Practices
ADRs are consistently authored and stored in version control. API-first design is practised for new services. YANG module design follows documented team conventions. Dependency inversion and SoC are enforced in code review. Technical debt is tracked in the backlog.

#### DORA Band
**Medium** — deployments multiple times per week, change failure rate <15%, mean time to restore <1 day.

#### Observable Signals in O&A Context
- Full YANG validation pipeline in CI: `pyang`, schema-based linting, diff against previous version
- NETCONF/gNMI integration tests run against a Containerlab simulated topology in CI on every PR
- Config generation pipeline is fully version-controlled, tested, and produces auditable artefacts
- Network topology as code: intent expressed in YANG/NETCONF, reconciled against device state in a test pipeline
- ADRs exist for all major architectural decisions: choice of YANG data store, gNMI vs. RESTCONF, streaming telemetry pipeline design

#### AI Ceiling
**Level 4 (Scaling).**

---

### Level 4 — Managed
**"DORA High band, strong testing, architectural discipline."**

#### CI/CD
Fully automated deployment pipeline to production with automated rollback on failure. Deployment frequency is daily or on-demand. Pipeline includes security scanning, dependency analysis, contract testing, and observability validation. Team Members feel confident deploying at any time.

#### Testing Discipline
Testing pyramid is well-balanced and enforced. >80% meaningful unit test coverage. Contract tests for all service interfaces. Chaos/fault injection testing for critical network automation paths. Property-based testing for YANG constraint validation. Test suite is fast (<5 minutes to meaningful feedback).

#### Trunk-Based Development
True trunk-based development. All changes merge to `main` within hours. Feature flags are a standard part of the development toolkit. Branch protection rules enforced. Continuous integration is genuinely continuous.

#### Architecture Practices
Evolutionary architecture with fitness functions. Architecture fitness functions run in CI (e.g., dependency direction checks, YANG schema compatibility checks, API contract drift detection). Architectural principles are codified, measurable, and automated where possible. ADRs are reviewed at defined intervals for continued relevance.

#### DORA Band
**High** — deployments on demand (multiple times per day), change failure rate <10%, mean time to restore <1 hour.

#### Observable Signals in O&A Context
- Canary deployments of config generation changes with automated rollback on NETCONF session error rate increase
- Fitness functions enforce YANG backward compatibility: breaking changes detected and blocked in CI
- Contract testing between config orchestrator and southbound device adapters runs on every PR
- Streaming telemetry pipeline validated against defined SLOs in CI using synthetic test traffic
- Architectural drift detected automatically: any new YANG module that violates team modelling conventions is flagged before merge

#### AI Ceiling
**Level 5 (Optimizing).**

---

### Level 5 — Optimizing
**"DORA Elite band, continuous improvement culture, fitness functions."**

#### CI/CD
Deployment pipeline is a competitive advantage: fully observable, self-healing where possible, and continuously improved. Deployment frequency is multiple times per day. Every stage of the pipeline is instrumented and its performance tracked over time. The team experiments with pipeline improvements using the same engineering discipline applied to product features.

#### Testing Discipline
Testing is comprehensive, intelligent, and efficient. AI-assisted test generation is validated by an evaluation harness. Mutation testing scores tracked over time. Tests are continuously reviewed for value: low-value tests are retired. Testing strategy is an active area of team learning and investment.

#### Trunk-Based Development
Trunk-based development is second nature. Feature flags are managed through a dedicated platform. Experimentation (A/B testing, progressive rollout) is a standard tool. The concept of a "release branch" is essentially obsolete.

#### Architecture Practices
Architecture is treated as a continuous hypothesis: fitness functions provide ongoing empirical evidence of architectural health. Architecture reviews are collaborative, data-driven, and forward-looking. The team contributes to organisation-wide architectural standards. Technical debt is proactively managed with measurable targets.

#### DORA Band
**Elite** — on-demand deployments, change failure rate <5%, mean time to restore <1 hour, lead time for changes <1 day.

#### Observable Signals in O&A Context
- Full network-as-code lifecycle: intent → YANG model → validated config → automated deployment → telemetry-verified convergence
- Architectural fitness functions cover: YANG schema compatibility, RFC compliance drift, vendor abstraction layer boundary integrity, streaming telemetry completeness
- Deployment pipeline self-reports health metrics; degradation triggers automated investigation workflow
- Team publishes internal engineering blog on pipeline and AI tooling improvements
- DORA metrics tracked alongside AI adoption metrics in a unified engineering health dashboard

#### AI Ceiling
**Level 5 fully achievable.**

---

## The AI Ceiling Rule

The ceiling rule is not a bureaucratic gate. It is an empirical observation: **AI tools applied to a weak foundation do not fix the foundation — they obscure the damage and accelerate its accumulation.**

### Ceiling Table

| MSD Health Level | MSD Health Name | AI Adoption Ceiling | Notes |
|-----------------|----------------|---------------------|-------|
| Level 1 | Fragile | **Level 2** (Experimenting) | Going beyond L2 actively accelerates dysfunction |
| Level 2 | Repeatable | **Level 3** (Practicing) | Scaling without CI discipline produces untested AI artefacts at scale |
| Level 3 | Defined | **Level 4** (Scaling) | Agentic workflows require reliable pipelines to be safe |
| Level 4 | Managed | **Level 5** (Optimizing) | Optimising AI practices requires a foundation that can absorb and measure change |
| Level 5 | Optimizing | **Level 5** (Optimizing) | No ceiling — both axes at maximum |

### Why the Ceiling Exists: Concrete Failure Modes

#### Attempting AI Adoption L3+ on MSD Health L1 (Fragile Foundation)

**What happens:** Team Members begin using AI to generate YANG modules, config templates, and test scaffolding at volume. But without automated validation in CI, the generated artefacts are never systematically checked. A YANG module generated by an LLM may contain syntactically valid but semantically incorrect `must` expressions. Without `pyang` running in an automated pipeline, this module ships.

**O&A example:** An team member uses Copilot to generate a YANG augmentation for a vendor-specific BGP feature. The generated `when` constraint references a node path that does not exist in the base model. Without automated YANG validation in CI, this passes code review (reviewers trust the AI output) and is deployed. The config management system silently ignores the augmentation, causing a configuration drift that manifests as a BGP session instability six weeks later during a maintenance window.

**Why AI made it worse:** Without AI, this module would have been handwritten slowly and reviewed carefully. With AI, the same incorrect module was produced in two minutes, reviewed in thirty seconds, and committed with high confidence.

---

#### Attempting AI Adoption L4+ on MSD Health L2 (Repeatable Foundation)

**What happens:** Agentic tools are introduced that can autonomously generate and commit code for bounded tasks. But on a Repeatable foundation, the test coverage is uneven (20–50%), and the CI pipeline is flaky and sometimes bypassed. The agent's output is not reliably caught by automated tests because the tests don't exist for many code paths.

**O&A example:** A GitHub Copilot Workspace agent is tasked with generating a set of `ncclient` integration tests from a YANG schema diff. The agent produces 40 test functions. CI runs, 30 pass, 10 are skipped due to missing test fixtures. The 10 skipped tests covered the `edit-config` rollback scenarios. Three months later, a failed config push does not roll back correctly because the rollback code path was never tested — and the AI-generated tests that would have caught this were silently skipped.

**Why AI made it worse:** The volume of AI-generated test code created false confidence. The team believed the feature was well-tested because the AI had generated "comprehensive tests." The skipped tests were invisible in the noise.

---

#### Attempting AI Adoption L5 on MSD Health L3 (Defined Foundation)

**What happens:** The team invests in RAG-augmented assistants and AI evaluation harnesses on a foundation where deployment is still partially manual and architectural fitness functions don't yet exist. The AI system optimises for local metrics (e.g., prompt quality scores) while the underlying architecture drifts.

**O&A example:** A RAG assistant is trained on the team's YANG corpus and provides excellent schema advice. But because fitness functions are absent, the underlying YANG corpus itself drifts from RFC alignment over time. The assistant becomes an expert at replicating the team's architectural drift at scale, confidently suggesting patterns that are internally consistent but RFC non-compliant.

---

#### The General Pattern

The failure mode in every case follows the same structure:

1. AI increases the **volume and velocity** of output
2. Weak MSD foundations cannot **validate or gate** that output reliably
3. Defects are produced **faster** and with **higher confidence** (because the AI generated it, so it must be right)
4. Problems surface **later**, in **more complex** contexts, and are **harder to trace** to their origin

Dave Farley's framing is apt: if your feedback loops are slow and unreliable, you cannot learn. AI without fast, reliable feedback loops is not intelligence augmentation — it is confidence inflation.

---

## Where is the O&A Team Today?

> **This section is a template to be completed after the baseline assessment survey.**  
> Use the Self-Assessment Worksheet below to gather initial data, then validate with the team lead and engineering manager.

| Dimension | Current State | Source |
|-----------|--------------|--------|
| **AI Adoption Level** | `[TBD — from baseline survey]` | Team self-assessment |
| **AI Adoption Level Name** | `[TBD]` | |
| **MSD Health Level** | `[TBD — from baseline survey]` | Team self-assessment + pipeline review |
| **MSD Health Level Name** | `[TBD]` | |
| **AI Ceiling (given current MSD)** | `[TBD — derived from ceiling table]` | |
| **Is team operating within ceiling?** | `[TBD]` | |

### Targets

| Horizon | AI Adoption Target | MSD Health Target | Key Milestones |
|---------|--------------------|-------------------|----------------|
| **6 months** | `[TBD]` | `[TBD]` | `[TBD — e.g., YANG validation pipeline in CI, shared prompt library v1]` |
| **12 months** | `[TBD]` | `[TBD]` | `[TBD — e.g., agentic test generation in CI, trunk-based development adopted]` |

### Notes for Baseline Assessors

When conducting the baseline survey, prioritise honest self-assessment over aspirational scoring. It is significantly better to begin at Level 1/2 and progress than to begin at Level 3/4 and discover the foundation is missing. The most useful question to ask for each criterion is: *"Can we demonstrate this with evidence, or are we assuming it?"*

---

## Self-Assessment Worksheet

Use this worksheet to get a rough placement on both axes. Score each statement: **0** (not true), **1** (partially true), **2** (consistently true).

### Axis 1: AI Adoption Depth — 5 Questions

| # | Statement | Score (0–2) |
|---|-----------|-------------|
| A1 | Most team members on the team use an AI coding assistant (e.g., GitHub Copilot) as part of their daily workflow, not just occasionally | |
| A2 | We have a shared, version-controlled prompt library that is actively used and maintained by the team | |
| A3 | At least one AI-assisted workflow (e.g., YANG stub generation, test scaffolding, incident triage drafting) is defined, documented, and consistently followed | |
| A4 | AI tooling is integrated into our CI/CD pipeline at one or more stages (not just in individual IDEs) | |
| A5 | We regularly review the quality and effectiveness of our AI-assisted outputs — including deliberately removing or redesigning workflows that don't deliver value | |

**Axis 1 Score: \_\_ / 10**

| Score Range | Approximate Level |
|-------------|------------------|
| 0–2 | Level 1 — Unaware |
| 3–4 | Level 2 — Experimenting |
| 5–6 | Level 3 — Practicing |
| 7–8 | Level 4 — Scaling |
| 9–10 | Level 5 — Optimizing |

---

### Axis 2: MSD Health — 5 Questions

| # | Statement | Score (0–2) |
|---|-----------|-------------|
| M1 | Our CI pipeline runs on every pull request, completes in under 10 minutes, and failures block merges — no exceptions | |
| M2 | We have a functioning testing pyramid: substantial unit tests (>60% meaningful coverage), integration tests for key interfaces, and limited end-to-end tests for critical paths | |
| M3 | We practice trunk-based development (or near-trunk with branches <48 hours); `main` is releasable at any time | |
| M4 | Architectural decisions are recorded as ADRs in version control, and we have documented conventions for YANG modelling, API design, and service boundaries | |
| M5 | Our DORA metrics place us in the Medium band or above: deployments at least weekly, change failure rate <15%, mean time to restore <1 day | |

**Axis 2 Score: \_\_ / 10**

| Score Range | Approximate Level |
|-------------|------------------|
| 0–2 | Level 1 — Fragile |
| 3–4 | Level 2 — Repeatable |
| 5–6 | Level 3 — Defined |
| 7–8 | Level 4 — Managed |
| 9–10 | Level 5 — Optimizing |

---

### Reading Your Result

1. Look up your **Axis 2 (MSD Health) score** and find your level
2. Look up the corresponding **AI Ceiling** in the [ceiling table](#ceiling-table)
3. Compare your **Axis 1 (AI Adoption) score** against that ceiling
4. If your AI Adoption level **exceeds your AI Ceiling**, your immediate priority is MSD Health investment, not further AI adoption

> **Example:** Axis 1 score = 6 (Practicing), Axis 2 score = 3 (Repeatable).  
> AI Ceiling at MSD Level 2 = AI Level 3.  
> Team is operating at their ceiling — next investment must be MSD Health, not AI tooling.

---

## References

The theoretical and empirical foundations of this model draw on the following works:

| Author(s) | Work | Key Contribution to This Model |
|-----------|------|-------------------------------|
| **Dave Farley** | *Modern Software Engineering* (2021) | Core MSD principles: fast feedback, learning, managing complexity; "engineering" vs. "craft" distinction; the role of empiricism in software delivery |
| **Dave Farley** | *Continuous Delivery* (with Jez Humble, 2010) | Deployment pipeline as engineering discipline; the relationship between test automation and delivery confidence |
| **Martin Fowler** | *Evolutionary Architecture* principles; *Refactoring* (1999, 2018); [martinfowler.com](https://martinfowler.com) | Fitness functions, incremental improvement, the cost of deferred architectural decisions, strangler fig pattern |
| **Nicole Forsgren, Jez Humble, Gene Kim** | *Accelerate: The Science of Lean Software and DevOps* (2018) | DORA metrics and bands; empirical evidence linking engineering practices to delivery performance and organisational outcomes |
| **Gene Kim, Jez Humble, Patrick Debois, John Willis** | *The DevOps Handbook* (2016, 2nd ed. 2021) | Three Ways of DevOps; feedback loops; continuous learning and experimentation culture |
| **Gregor Hohpe** | *The Software Architect Elevator* (2020); [architectelevator.com](https://architectelevator.com) | Architecture as communication; connecting technical practice to organisational strategy; the dangers of architecture without grounding in delivery reality |
| **Michael Cummins** | *Enterprise Cloud Strategy* and platform engineering principles | Cloud-native delivery patterns; platform as product; reducing cognitive load for engineering teams |
| **Ethan Mollick** | *Co-Intelligence: Living and Working with AI* (2024) | AI as collaborator and amplifier; "always invite AI to the table" heuristic; the importance of human judgment in AI-augmented work; AI adoption as a human and organisational challenge, not just a technical one |
| **Sam Newman** | *Building Microservices* (2015, 2nd ed. 2021); *Monolith to Microservices* (2019) | Service decomposition, API-first design, independent deployability; the relationship between architecture and team autonomy |

---

*Document version: 1.0 — Draft for baseline review*  
*Owner: O&A Engineering Practice Lead*  
*Last updated: [date of first publication]*  
*Review cycle: Quarterly, or following completion of each 6-month journey phase*
