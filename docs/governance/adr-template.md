# ADR Template — Architectural Decision Records for AI-Assisted Decisions

> **What is an ADR?** An Architectural Decision Record is a short document that captures a significant technical decision: the context that led to it, the choice made, and the consequences expected. ADRs are written once, stored in version control, and referenced forever.

For the O&A team, ADRs are how we maintain accountability for architectural choices — including, critically, choices where AI tools played a role in the analysis or recommendation.

---

## Why AI-Assisted Decisions Especially Need ADRs

AI tools can produce architectural suggestions that are fluent, plausible, and wrong. A large language model does not know your network topology, your SLA commitments, your team's operational maturity, or the specific behaviour of your vendor's NOS implementation. It pattern-matches against training data.

When AI assists in an architectural decision, the risk of **plausible-but-incorrect reasoning** is real. The ADR forces us to:

- State what we actually decided (not what the AI suggested)
- Document how AI input was validated by humans
- Record who is accountable for the decision
- Create a clear audit trail if the decision needs to be revisited

An ADR is not overhead — it is the minimum documentation that makes AI-assisted architecture safe at scale.

---

## When to Write an ADR

Write an ADR whenever **any** of the following apply:

- [ ] You are adopting a new AI tool for engineering workflows (new tool ADR)
- [ ] An AI-assisted analysis influenced a decision about service boundaries, APIs, or data models
- [ ] AI-generated YANG or OpenAPI specs are being treated as the **canonical** spec (not just a draft)
- [ ] An agentic workflow will have **write access** to infrastructure, pipelines, or configuration repositories
- [ ] You are committing to a specific AI vendor or model for a critical workflow (vendor lock-in ADR)
- [ ] The decision would be difficult or costly to reverse within a single sprint

**If you are unsure:** raise it in the architecture sync. A short ADR written now is far cheaper than a painful post-incident explanation later.

---

## Standard ADR Template for O&A

Copy this template to `docs/decisions/ADR-XXXX-short-title.md` and fill in every section. Placeholder text is in square brackets.

```markdown
# ADR-[NUMBER]: [Short Decision Title]

**Date:** YYYY-MM-DD  
**Status:** Proposed | Accepted | Deprecated | Superseded by ADR-XXX  
**Deciders:** [Names/roles — at least two team members and the engineering lead for significant decisions]  
**AI Tools Involved:** [List any AI tools that assisted in drafting this decision, or "None"]

## Context
[What is the situation, problem, or requirement driving this decision?
What constraints exist? What is the current state?
Be specific: include team size, affected systems, relevant TM Forum processes, and any time/cost pressures.]

## Decision
[What is the decision that was made? State it clearly in 1–3 sentences.
This should be unambiguous — someone reading this in 18 months should know exactly what was decided.]

## Rationale
[Why was this decision made? What alternatives were considered?
If AI tools assisted in this analysis, note: (a) what the AI suggested, (b) how that suggestion was validated
or challenged by humans, and (c) how the final decision differs from or aligns with the AI recommendation.]

## Consequences

### Positive
- [Expected benefits — be specific and, where possible, measurable]

### Negative / Trade-offs
- [Known downsides, risks, or technical debt introduced]
- [Be honest — an ADR that only lists positives is not credible]

### Neutral
- [Things that change as a result of this decision but are neither benefits nor drawbacks]

## Alternatives Considered

| Alternative | Why Not Chosen |
|---|---|
| [Option A] | [Reason] |
| [Option B] | [Reason] |

## TM Forum Alignment
[Which eTOM process, TAM capability, ODA component, or Open API does this decision relate to?
If this decision deviates from TM Forum guidance, explain why.]

## Responsible AI Assessment
*(Complete this section if AI tools are involved in implementation or ongoing operation.)*

| Dimension | Assessment |
|---|---|
| **Privacy impact** | Low / Medium / High — [explanation] |
| **Security considerations** | [Any security gates, penetration testing, or review required?] |
| **Vendor lock-in risk** | [Which vendor? What is the exit path? What is the estimated migration cost?] |
| **Environmental impact** | [Model size choice rationale; SCI estimate if compute cost is significant] |

## Exit Criteria
*(Required for AI tool ADRs. Optional but recommended for all others.)*

[What would cause us to reconsider or reverse this decision?
What metrics, events, or thresholds would indicate this decision was wrong?
Example: "If the false-positive rate on AI-generated YANG validation exceeds 15% over two consecutive sprints, we will revisit this decision."]

## References
- [Links to relevant TM Forum specs, Open API definitions, IETF RFCs, vendor docs, or research papers]
- [Links to related ADRs]
- [Links to the GitHub issue, Jira ticket, or architecture sync notes that prompted this ADR]
```

---

## Filing Convention

| Convention | Detail |
|---|---|
| **Location** | `docs/decisions/ADR-XXXX-short-title.md` |
| **Numbering** | Four-digit sequential number, zero-padded: `ADR-0001`, `ADR-0002`, ... |
| **Filename** | Lowercase kebab-case title: `ADR-0001-adopt-github-copilot-business.md` |
| **One decision per file** | Do not combine multiple decisions into a single ADR |

---

## ADR Review Process

```
Author drafts ADR (status: Proposed)
        ↓
Shared in #noa-architecture Slack channel for async comments (48-hour window)
        ↓
Reviewed at next architecture sync (bi-weekly)
        ↓
Deciders listed in the ADR sign off (status: Accepted)
        ↓
Merged to main branch → communicated to full O&A team in #noa-engineering
```

ADRs are **never deleted**. If a decision is reversed, the original ADR is marked `Deprecated` or `Superseded by ADR-XXXX`, and a new ADR is written for the replacement decision. The history is the point.

---

## Worked Example

The following is a complete, filled-in ADR for the O&A team's adoption of GitHub Copilot Business. Every section is populated with realistic content to serve as a reference for future ADRs.

---

```markdown
# ADR-0001: Adopt GitHub Copilot Business for the O&A Engineering Team

**Date:** 2025-02-10  
**Status:** Accepted  
**Deciders:** Sarah Chen (Engineering Lead), Marcus Obi (Staff Team Member), Priya Nair (AI Champion — Core Automation Squad), David Lim (Security Team Member)  
**AI Tools Involved:** GitHub Copilot Chat (used to generate a comparison of Copilot Business vs. Copilot Enterprise capabilities); comparison was reviewed and validated by Marcus Obi against published GitHub documentation before being included in this ADR.

## Context

The O&A team (currently 18 team members across three squads) is undertaking a structured AI-agentic adoption journey. A key phase of that journey is establishing a baseline AI coding assistant for all team members.

Team Members have been using free-tier and individually-licensed AI coding tools inconsistently over the past eight months. This has resulted in: no shared prompt library, no centralised telemetry on adoption, and no enforceable data-handling policy for what is included in AI prompts (a concern raised by InfoSec in Q3 2024).

The team codes primarily in Python, Go, and YANG, operating against a TM Forum ODA-aligned microservices architecture. A significant portion of work involves NETCONF/RESTCONF automation, OpenAPI-aligned TMF API development, and CI/CD pipeline engineering.

GitHub is the team's existing SCM platform (GitHub Enterprise Cloud). A centralised licensing model is therefore operationally straightforward.

## Decision

The O&A team will adopt **GitHub Copilot Business** as the standard AI coding assistant for all team members, effective from the start of Sprint 24. Individual use of other AI tools is not prohibited but remains subject to the data handling norms in `docs/governance/team-norms.md`.

## Rationale

GitHub Copilot Business was chosen over Copilot Enterprise and third-party alternatives (Cursor, Amazon Q Developer, Tabnine) for the following reasons:

1. **GitHub Enterprise integration:** Copilot Business integrates directly with our existing GitHub Enterprise Cloud organisation. No additional SSO configuration, no new vendor relationship, and billing consolidates under our existing GitHub agreement.

2. **Data handling policy:** Copilot Business provides explicit contractual commitments that code snippets are not used to train models, which satisfies the InfoSec requirement raised in Q3 2024.

3. **Cost:** Copilot Business ($19/user/month) fits within the approved tooling budget for FY2025. Copilot Enterprise ($39/user/month) was assessed but the additional features (repository-aware chat, custom models) were judged premature given the team's current adoption maturity level.

4. **Team-wide standardisation:** A single licensed tool with central admin visibility enables the SPACE-A adoption metrics we have committed to tracking.

**AI input validation note:** Copilot Chat was used to draft the initial feature comparison table between Copilot Business and Copilot Enterprise. Marcus Obi independently verified every capability claim against GitHub's published documentation (https://docs.github.com/en/copilot). Two inaccuracies were identified and corrected: the AI overstated the custom model fine-tuning availability in Copilot Business and understated the knowledge base feature scope in Copilot Enterprise. The corrected comparison informed the cost-benefit assessment above.

## Consequences

### Positive
- All 18 team members have access to a consistent, policy-compliant AI coding assistant from day one of adoption
- Central admin dashboard provides adoption telemetry (number of active users, suggestions accepted) without requiring manual tracking
- Contractual data handling commitments satisfy InfoSec Q3 2024 requirement
- IDE integration (VS Code, JetBrains, Neovim) covers all editors currently used by the team
- No new vendor contract required — extends existing GitHub Enterprise agreement

### Negative / Trade-offs
- Copilot Business has no awareness of the team's internal repositories beyond what is open in the IDE at the time — it cannot answer questions about our specific service architecture without relevant files in context. This is a known limitation we will work around with prompt engineering discipline.
- The tool is GitHub-vendor-specific. Switching to an alternative assistant in future will require re-training team habits and potentially rebuilding prompt templates (estimated 2–4 sprint overhead).
- Copilot suggestions are based on public code; YANG and NETCONF-specific suggestions are weaker than general Python/Go suggestions. Team Members should not treat YANG output as authoritative without pyang/yanglint validation.
- Monthly cost of £19/user adds ~£4,104/year at current team size. Requires re-approval if headcount grows beyond 30.

### Neutral
- Existing Copilot Free tier users will be migrated to the Business tier — no capability regression
- Team members using individually-licensed Copilot Pro accounts will be transitioned to the team licence

## Alternatives Considered

| Alternative | Why Not Chosen |
|---|---|
| GitHub Copilot Enterprise | Premature for current adoption maturity; 2× the cost with features (knowledge bases, custom models) the team is not yet positioned to use effectively |
| Amazon Q Developer | Strong AWS-native tooling but O&A infrastructure is cloud-agnostic with significant on-premises NOS estate; Q Developer's primary value is AWS service awareness, which is limited relevance here |
| Cursor | Strong IDE experience but requires a separate vendor relationship, separate SSO, no GitHub Enterprise admin integration, and does not provide the same contractual data handling guarantees |
| Tabnine Enterprise | Self-hosted option is appealing from a data privacy perspective but requires infrastructure the team does not currently have; revisit if data sovereignty requirements escalate |
| No standard tool (maintain status quo) | Rejected: inconsistent tool usage, no policy enforcement, no shared telemetry, and no progress on the AI adoption journey goal |

## TM Forum Alignment

This decision does not directly relate to a specific TM Forum Open API or ODA component. It is an internal engineering tooling decision. However, it supports the O&A team's ability to accelerate delivery against the following:

- **eTOM 1.4.x (Service Configuration & Activation):** Copilot assists in authoring YANG modules and NETCONF payloads that drive automated service activation workflows.
- **ODA Component: Service Orchestration & Control:** Improved velocity in Python/Go automation reduces the cycle time between ODA component specification and working implementation.

No deviation from TM Forum guidance is introduced by this decision.

## Responsible AI Assessment

| Dimension | Assessment |
|---|---|
| **Privacy impact** | **Low.** GitHub Copilot Business does not use customer code to train models per the contractual terms. Team Members are required by `team-norms.md` not to include customer data, network configs, or credentials in prompts. No personal data is expected to flow through the tool in normal operation. |
| **Security considerations** | SAST scanning remains mandatory for all AI-generated code (existing gate, unchanged). The team's PR checklist (`team-norms.md`) requires SAST pass before merge. InfoSec to review the GitHub Copilot Business data processing agreement annually. |
| **Vendor lock-in risk** | **Medium.** GitHub Copilot is GitHub-specific. Prompt templates stored in `noa-ai-adoption/prompts/` are tool-agnostic where possible (plain text with header metadata). Migration path: export prompts, retrain team on new tool, estimated 2–4 sprint overhead. Exit trigger: see Exit Criteria below. |
| **Environmental impact** | Low relative concern — we are consuming a SaaS model, not training one. GitHub does not publish per-request energy consumption. We have chosen not to self-host a model, which would have a materially higher infrastructure footprint at our scale. |

## Exit Criteria

We will reconsider or reverse this decision if **any** of the following occur:

- GitHub changes Copilot Business data handling terms in a way that no longer satisfies InfoSec requirements
- The team's SAST tooling identifies a pattern of high/critical findings in AI-generated code at a rate >10% higher than in non-AI-assisted PRs over a rolling 90-day period
- Team satisfaction with the tool (measured in quarterly developer survey) falls below 3.0/5.0 for two consecutive quarters
- A credible alternative tool is identified that offers equivalent capability at <50% of the cost, or materially superior YANG/NETCONF support, and migration cost is assessed as <4 sprints

## References

- [GitHub Copilot Business — Feature Comparison](https://docs.github.com/en/copilot/about-github-copilot/subscription-plans-for-github-copilot)
- [GitHub Copilot Business — Data Privacy](https://docs.github.com/en/copilot/responsible-use-of-github-copilot-features/responsible-use-of-github-copilot)
- [O&A Team Norms — AI Usage](../governance/team-norms.md)
- [O&A Responsible AI Principles](../responsible-ai/principles.md)
- [InfoSec Q3 2024 Review — AI Tool Data Handling Requirements] *(internal link)*
- [SPACE Framework — Adoption dimension](https://queue.acm.org/detail.cfm?id=3454124)
```

---

*Last updated: 2025-02-10 · Owner: O&A Engineering Lead · Review cycle: Annually or when AI tool landscape changes significantly*
