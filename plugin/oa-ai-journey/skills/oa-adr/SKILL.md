# Skill: Draft O&A ADR

**Skill name**: `oa-adr`
**Trigger phrases**: "draft an ADR", "architecture decision", "adr for", "document this decision"

---

## What This Skill Does

Generates a complete Architecture Decision Record (ADR) following the O&A template, including the mandatory Responsible AI Assessment section and — for any agentic AI workflow — an automatic Shostack STRIDE threat model section. The output is ready to commit to `docs/governance/adrs/`.

ADRs in O&A are not optional formalities. An ADR is the audit trail that demonstrates responsible AI governance. Every agentic workflow **requires** one before team review.

---

## Required Inputs

Before generating the ADR, ask:

1. "What was decided? (One sentence.)"
2. "What alternatives did you consider? (List them — an ADR with no alternatives is a rubber stamp, not a decision.)"
3. "Does this involve an **agentic AI workflow**? (If yes, the STRIDE threat model section is mandatory.)"
4. "Which Responsible AI dimensions are relevant?" (see below)
5. "Who is the decision owner? (The engineer who owns the consequences.)"
6. "What is the review date? (ADRs for AI tooling should be reviewed annually as the Wardley evolution axis shifts.)"

---

## Mandatory ADR Sections

```markdown
# ADR-[NNN]: [Title — verb phrase describing the decision]

**Status**: [Proposed | Accepted | Deprecated | Superseded by ADR-NNN]
**Date**: [YYYY-MM-DD]
**Decision Owner**: [Name, role]
**Review Date**: [YYYY-MM-DD — 12 months for AI tooling, 24 months for stable patterns]

---

## Context

[What situation forced this decision? What constraints exist? What is the blast radius?
Include: team stage (O&A adoption stage 1-5), MSD maturity, relevant DORA/SPACE baseline.]

## Decision

[The decision made. Direct statement: "We will..." not "It was decided..."]

## Alternatives Considered

| Option | Pros | Cons | Reason Rejected |
|--------|------|------|-----------------|
| [Alt 1] | ... | ... | ... |
| [Alt 2] | ... | ... | ... |

## Consequences

**Positive**: [What improves as a result.]
**Negative**: [What gets harder, more complex, or more expensive.]
**Risks**: [What could go wrong, and how will it be detected.]

---

## Responsible AI Assessment

[Required for any decision involving AI tools, agentic workflows, or AI-generated outputs.]

| Dimension | Assessment |
|-----------|-----------|
| **Privacy** | [Does this involve personal data, device configs, or customer info?] |
| **Security** | [Prompt injection risk? Credential exposure? Output used in automation?] |
| **Environmental** | [SCI impact — inference energy cost. Is a smaller/local model viable?] |
| **Market Concentration** | [Single-vendor risk. Is vendor diversity maintained?] |
| **Global Transformation** | [Workforce impact. Is this decision reversible if circumstances change?] |

---

## Agentic Workflow Safety Checklist

[Include this section if and only if the decision involves an agentic AI workflow.]

- [ ] No production write access — agent operates on candidate/staging only
- [ ] All agent output goes through the deployment pipeline before applying
- [ ] Explicit scope boundary documented (what the agent CAN and CANNOT touch)
- [ ] Human checkpoint defined for all irreversible actions
- [ ] This ADR exists (meta — confirm before closing PR)

---

## Threat Model (STRIDE)

[Mandatory for agentic workflows. Use Shostack's STRIDE model.]

| Threat | Description | Mitigation |
|--------|-------------|-----------|
| **Spoofing** | [Can the agent be tricked into acting as a different identity?] | [How mitigated] |
| **Tampering** | [Can agent output be modified before it reaches the pipeline?] | [How mitigated] |
| **Repudiation** | [Can agent actions be denied? Is there an audit trail?] | [How mitigated] |
| **Information Disclosure** | [Can the agent leak device configs, credentials, or topology to external models?] | [How mitigated] |
| **Denial of Service** | [Can the agent be prompted into excessive API calls or resource exhaustion?] | [How mitigated] |
| **Elevation of Privilege** | [Can the agent be prompted into accessing systems outside its defined scope?] | [How mitigated] |
```

---

## Automatic Shostack Trigger

If the user mentions any of the following, the STRIDE section is **automatically included** — do not ask, just add it:
- "agent", "agentic", "autonomous", "automated workflow"
- "AI generates and applies", "AI commits", "AI deploys"
- "no human in the loop", "fully automated"

---

## Commit Location

ADRs are committed to: `docs/governance/adrs/ADR-[NNN]-[kebab-case-title].md`

The ADR index is maintained at: `docs/governance/adrs/README.md`

After generating the ADR, remind the user to:
1. Increment the ADR number (check existing ADRs for the next available NNN)
2. Add an entry to the ADR index README
3. Get at least one peer review before setting Status to "Accepted"
4. Set a calendar reminder for the review date

---

## ADR Quality Bar

A good ADR is rejected at review if:
- It has no alternatives (means the decision was already made before the ADR was written)
- The Responsible AI Assessment section is all "N/A" for an AI tool decision
- There is no review date
- The consequences section only lists positives
