# Andrew Ng's AI Transformation Playbook — Applied to O&A

> "AI is the new electricity. Just as electricity transformed almost every industry 100 years ago,
> AI will now transform every industry."
> — Andrew Ng

---

## 1. The Playbook Overview

Andrew Ng's *AI Transformation Playbook*, published by Landing AI, documents five steps for transforming an enterprise into an AI-capable organisation. It emerged from Ng's experience leading AI transformation at Baidu and advising Fortune 500 companies through Landing AI. It is not a theoretical framework — it is a pattern extracted from observed practice.

The five steps:

| Step | Description |
|---|---|
| 1 | Execute pilot projects to gain momentum |
| 2 | Build in-house AI capability |
| 3 | Provide broad AI training (not just technical staff) |
| 4 | Develop an AI strategy |
| 5 | Develop internal and external communications |

These steps are deliberately ordered. Organisations that jump to Step 4 (strategy) before completing Step 1 (pilots) produce strategies disconnected from operational reality. Organisations that skip Step 3 (broad training) find that AI tools adopted by senior engineers never propagate to the rest of the team.

### Mapping to O&A's Adoption Roadmap

| Ng Step | O&A Roadmap Stage | Primary activity |
|---|---|---|
| Step 1: Pilots | Stage 1 — Foundation | GitHub Copilot adoption, first prompt experiments |
| Step 2: In-house capability | Stage 2 — Integration | AI champion role, enabling team, Ollama infrastructure |
| Step 3: Broad training | Stage 2–3 — Integration to Optimisation | Team-wide prompt engineering, spec-driven development |
| Step 4: AI strategy | Stage 3 — Optimisation | Wardley-informed tooling strategy, ADR process |
| Step 5: Communications | Stage 3–4 — Optimisation to Scaling | Internal showcase, cross-team sharing |

The critical insight: Steps 1–3 are prerequisites. Do not attempt to define O&A's five-year AI strategy before the team has shipped a pilot, built some internal capability, and trained broadly. The strategy must be grounded in experience, not aspiration.

---

## 2. Step 1 — Pilot Projects

### Ng's Criteria for Good Pilots

Ng is specific about what makes a pilot worth running:

- **Meaningful enough** to demonstrate genuine business value if it succeeds
- **Scoped enough** to complete in 6–12 months
- **Measurable** — success and failure are unambiguous before the pilot starts
- **Not on the critical path** — early pilots should not carry production risk

A pilot that takes three years to show value is not a pilot — it is a programme with the word "pilot" attached to avoid accountability. A pilot without a pre-agreed success metric is not a pilot — it is a proof of concept that will be declared successful regardless of outcome.

### O&A Candidate Pilots

Three pilots are proposed for O&A, each meeting Ng's criteria:

---

**Pilot A: GitHub Copilot for YANG Stub Generation**

*Problem:* Engineers spend significant time writing YANG module boilerplate — container/list structure, leaf type declarations, description statements. This is mechanical work with low cognitive value.

*Hypothesis:* GitHub Copilot, guided by structured prompt patterns, will reduce time-to-first-compilable-YANG-stub by ≥30%.

*Success criteria (pre-agreed):*
- Time per YANG module (stub to first pyang-clean compile): measured before and after, target ≥30% reduction
- Test coverage of generated stubs: target ≥80% yang-test-tools coverage without manual remediation
- Adoption: ≥80% of engineers who trialled it continue using it after 30 days

*Duration:* 8 weeks (4-week trial with 3 engineers, 4-week wider rollout with measurement)

*Risk:* Low — GitHub Copilot is a product-stage tool. Worst case is low adoption, not production failure.

---

**Pilot B: LLM-Assisted Incident Summarisation from NSO Audit Logs**

*Problem:* During incidents, engineers spend time reconstructing the sequence of NSO operations from audit logs to determine blast radius and root cause. Logs are structured but verbose.

*Hypothesis:* An LLM pipeline that ingests a bounded NSO audit log window and generates a structured incident summary (timeline, affected services, last successful state) will reduce mean-time-to-diagnose (MTTD) by ≥25%.

*Success criteria (pre-agreed):*
- MTTD for incidents where the tool is used vs. control group (manual log review): target ≥25% reduction
- Summary accuracy: ≥90% of summaries rated "useful or better" by the responding engineer in a post-incident review
- False negatives: no more than 1 in 20 summaries missing a critical event from the log window

*Duration:* 12 weeks (4-week pipeline build, 8-week trial across 3 on-call engineers)

*Risk:* Medium — requires access to NSO audit logs and a defined log retention window. Data classification review required before pilot starts.

---

**Pilot C: AI-Generated pytest Coverage for Legacy Service Packages**

*Problem:* O&A's legacy NSO service Python packages have low or no automated test coverage. Manual test writing is time-consuming and frequently deprioritised.

*Hypothesis:* An LLM-assisted test generation workflow (using Claude API or Copilot with a structured prompt) will increase test coverage of targeted legacy packages to ≥70% without requiring proportional engineer time investment.

*Success criteria (pre-agreed):*
- Coverage delta: packages under pilot reach ≥70% line coverage (from baseline, which may be near zero)
- Bugs caught: at least one previously undetected defect identified by generated tests before the pilot concludes
- Engineer time: ≥60% reduction in time-per-test-suite compared to fully manual authoring (self-reported)

*Duration:* 10 weeks (2-week setup and prompt engineering, 8-week execution across 5 legacy packages)

*Risk:* Low-to-medium — generated tests may be shallow or assert on incorrect behaviour. Requires human review of all generated tests before merging.

---

## 3. Step 2 — Build In-House Capability

### The Dependency Trap

Ng's most pointed warning about enterprise AI transformation: **organisations that outsource their AI capability to vendors become permanently dependent.** A vendor can build you a model, a pipeline, and a dashboard. What they cannot give you is the institutional knowledge to understand, maintain, extend, or question what they built.

For O&A, this is a concrete risk. If Ollama infrastructure is operated by a central IT team with no O&A involvement, the team cannot tune it. If prompt libraries are owned by a vendor professional services engagement, the team cannot iterate on them. If the AI champion is an external consultant, the knowledge leaves when the contract ends.

### O&A In-House Capability Model

**The AI Champion Role**

One or more senior engineers within O&A who:
- Maintain awareness of the AI tool landscape (track Wardley map evolution)
- Own the prompt library and RAG pipeline documentation
- Run internal learning sessions and share findings from experiments
- Represent O&A in cross-team AI governance forums
- Are accountable for the team's AI adoption roadmap progress

This is not a full-time role in Stage 1. It becomes one by Stage 3.

**The Enabling Team Function**

Inspired by Team Topologies' enabling team model, this function:
- Maintains Ollama infrastructure and ensures model availability
- Manages API key governance (rotation, cost monitoring, rate limit alerting)
- Owns the CI/CD integration for AI-assisted review gates
- Publishes internal guides, runbooks, and evaluated prompt patterns

**Prompt Library Ownership**

Prompts are O&A's intellectual property and operational knowledge. They must be:
- Version-controlled in the O&A documentation repository
- Reviewed before being promoted to "endorsed" status
- Tagged with the model they were tested against and the date of last validation
- Owned by the enabling team but contributed to by all engineers

**Ollama Infrastructure**

Self-hosted LLM inference enables:
- Data sovereignty for YANG modules, NSO configurations, and audit logs (no data leaves the network)
- Cost predictability (no per-token billing for high-volume internal use cases)
- Model experimentation without vendor approval processes

The enabling team owns uptime, model updates, and access governance. Engineers consume it via a documented internal API endpoint.

---

## 4. Step 3 — Broad Training

### Why Broad Training Fails

Ng observes that most AI training programmes fail because they are:
- Targeted only at senior or "AI-interested" engineers
- Technical depth without practical application
- One-off events rather than continuous learning loops

The result: a small cohort of AI-literate engineers surrounded by colleagues who do not use the tools, do not trust the outputs, and revert to prior practices. Adoption stalls at the enthusiast layer.

### Ng's Tiered Training Model — Mapped to O&A

**Tier 1: All Staff — AI Awareness**

*Who:* Every member of O&A, including product owners, technical leads, and non-coding roles.

*What:*
- What AI tools can and cannot do in a network automation context
- Responsible use: when to trust output, when to verify, when to refuse
- Data classification: what O&A data must not leave the network (customer configuration, audit logs with PII)
- How to report concerns about AI tool outputs

*Format:* 90-minute session, annually refreshed. Not optional.

*O&A roles:* Squad engineers, technical leads, product owners, architects, delivery managers.

---

**Tier 2: AI Tool Users — Effective Use**

*Who:* All engineers who use AI-assisted coding tools, prompt interfaces, or LLM APIs in their day-to-day work.

*What:*
- Prompt engineering fundamentals: role, context, constraints, output format
- Spec-driven development: writing specifications that LLMs can execute accurately
- Output review: how to critically evaluate LLM-generated YANG, Python, and test code
- Chain-of-thought and step-by-step reasoning prompts for complex NSO logic

*Format:* Half-day practical workshop with O&A-specific exercises. Refreshed when major tooling changes.

*O&A roles:* All software engineers, test engineers, automation engineers.

---

**Tier 3: AI Builders — Deep Capability**

*Who:* Engineers building and maintaining AI pipelines, RAG systems, fine-tuning workflows, and evaluation frameworks.

*What:*
- Fine-tuning: when it is appropriate, dataset requirements, evaluation methodology
- RAG pipeline development: chunking strategy, embedding model selection, retrieval evaluation
- LLM evaluation frameworks: how to measure whether a model or prompt change is an improvement
- Agentic workflow design: task decomposition, tool use, failure modes, guardrails

*Format:* Ongoing learning; internal study groups, external courses (fast.ai, DeepLearning.AI short courses), conference participation.

*O&A roles:* AI champion(s), enabling team engineers, senior engineers on Genesis-stage experiments.

---

## 5. Data Pipeline Quality as the Blocker

### Ng's Most Consistent Observation

Across every enterprise AI engagement Andrew Ng has discussed publicly, one theme recurs: **the primary blocker to AI value delivery is not model quality — it is data quality.**

LLMs are powerful pattern-matchers. They amplify the signal in the data they operate on. But they also amplify the noise. An LLM given well-structured, consistent data will produce well-structured, consistent outputs. An LLM given inconsistent, undocumented, contradictory data will produce confident-sounding, inconsistent, occasionally wrong outputs.

Garbage in, garbage out — but with AI, the garbage is often harder to detect because it arrives formatted, fluent, and plausible.

### O&A Data Quality Implications

**YANG Model Hygiene**

For AI-assisted YANG work (stub generation, constraint verification, RAG retrieval), the quality of the YANG corpus matters enormously:
- Inconsistent naming conventions across modules confuse retrieval
- Missing description statements reduce the information available to the model
- Undocumented deviations from RFC standards produce incorrect completions
- Stale modules left in the repository pollute the retrieval context

*Action:* Before deploying YANG RAG pipelines, audit the corpus. Define and enforce YANG style guidelines. Remove deprecated modules or clearly mark them.

**NETCONF Telemetry Completeness**

AI-driven anomaly detection and incident summarisation depend on complete, well-structured telemetry:
- Missing operational state nodes produce blind spots
- Inconsistent timestamp formats break temporal reasoning
- Incomplete YANG coverage of vendor NE state leaves gaps that the model cannot bridge

*Action:* Map current NETCONF telemetry coverage against the YANG models for each NE type. Prioritise gaps that affect the highest-risk incident scenarios.

**NSO Audit Log Structure**

Pilot B (incident summarisation) depends entirely on audit log quality:
- Inconsistent action naming across NSO service packages
- Missing correlation identifiers between related operations
- Variable verbosity between service package versions

*Action:* Define a structured logging standard for NSO service packages. Retrofit to the highest-volume packages first.

**TM Forum API Conformance**

For AI tools operating across the broader OSS/BSS boundary, TM Forum Open API conformance determines whether the model can reason across systems:
- Non-conformant field names prevent cross-system correlation
- Missing mandatory fields create null-handling edge cases
- Undocumented extensions are invisible to models trained on TM Forum specifications

*Action:* Include TM Forum API conformance as a gate in the service package review process.

---

## 6. The Virtuous Cycle

### Ng's Model

Ng describes the virtuous cycle of enterprise AI adoption:

```
Good AI output
      ↓
More team usage
      ↓
More data (feedback, corrections, usage patterns)
      ↓
Better model/prompt refinement
      ↓
More trust
      ↓
More usage → (cycle continues)
```

The cycle is self-reinforcing — but only once it starts. Getting it started requires the first AI output to be good enough to trust. That depends on data quality.

### O&A's Virtuous Cycle

For O&A, the virtuous cycle starts with:

1. **High-quality YANG models** → LLM-assisted generation produces accurate stubs → engineers trust the output → adoption increases
2. **Structured NSO audit logs** → incident summarisation produces accurate timelines → on-call engineers rely on the tool → feedback improves prompts
3. **Maintained prompt library** → consistent quality across team → engineers share prompts → library grows → quality rises

### The Vicious Cycle

The vicious cycle starts with the opposite conditions:

```
Inconsistent data / vague prompts
      ↓
Poor AI output
      ↓
Engineer distrust ("AI doesn't work for our use case")
      ↓
Low usage
      ↓
No feedback loop
      ↓
No improvement → (cycle continues)
```

O&A's risk of entering the vicious cycle is highest at Pilot B (incident summarisation), where log quality variability is known. This is why the data quality audit precedes the pilot build, not follows it.

---

## 7. O&A Transformation Checklist

The following checklist maps Ng's playbook to O&A-specific actions. Status tracking should be maintained in the adoption roadmap. Cross-references to relevant documentation are included where the action is elaborated elsewhere.

| # | Action | Ng Step | Status | Reference |
|---|---|---|---|---|
| 1 | Define 3 candidate pilots with pre-agreed success criteria | Step 1 | ☐ | This document, §2 |
| 2 | Complete baseline survey of current AI tool usage and sentiment | Step 1 | ☐ | [baseline-survey.md](../baseline-survey.md) |
| 3 | Select and launch Pilot A (GitHub Copilot / YANG stubs) | Step 1 | ☐ | This document, §2 |
| 4 | Appoint AI champion(s) within O&A | Step 2 | ☐ | This document, §3 |
| 5 | Stand up Ollama infrastructure with documented access endpoint | Step 2 | ☐ | [adoption-roadmap.md](../adoption-roadmap.md) |
| 6 | Create v1 prompt library in version control | Step 2 | ☐ | [governance/team-norms.md](../governance/team-norms.md) |
| 7 | Deliver Tier 1 AI Awareness session to all O&A staff | Step 3 | ☐ | This document, §4 |
| 8 | Deliver Tier 2 Prompt Engineering workshop to all engineers | Step 3 | ☐ | This document, §4 |
| 9 | Audit YANG corpus quality before deploying RAG pipelines | Steps 1–2 | ☐ | This document, §5 |
| 10 | Define structured logging standard for NSO service packages | Step 2 | ☐ | This document, §5 |
| 11 | Run Wardley Mapping session to produce O&A AI landscape map | Step 4 | ☐ | [wardley-mapping.md](wardley-mapping.md) |
| 12 | Publish AI strategy as an ADR referencing Wardley map outcomes | Step 4 | ☐ | [wardley-mapping.md](wardley-mapping.md), [adoption-roadmap.md](../adoption-roadmap.md) |

---

*Review cadence: checklist reviewed at each O&A sprint retrospective until all items reach Done. Ownership of each item assigned in the adoption roadmap.*

---

## Further Reading

- Ng, A. *AI Transformation Playbook* — available at landing.ai
- Ng, A. *Machine Learning Yearning* — free at deeplearning.ai
- [O&A Adoption Roadmap](../adoption-roadmap.md)
- [Wardley Mapping for AI Tool Strategy](wardley-mapping.md)
- [Governance: Team Norms](../governance/team-norms.md)
- [Baseline Survey](../baseline-survey.md)
