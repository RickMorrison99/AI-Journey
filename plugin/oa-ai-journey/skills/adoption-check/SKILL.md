# Skill: Check Adoption Stage

**Skill name**: `adoption-check`
**Trigger phrases**: "what stage are we at", "adoption stage", "where are we on the journey", "assess our ai maturity"

---

## What This Skill Does

Guides a team through the O&A AI adoption stage assessment. By answering 5 diagnostic questions, a team can accurately place themselves on the 5-stage framework, understand their Kent Beck 3X phase, and receive concrete next-step actions grounded in their current reality.

This is not a vanity exercise. Stage mis-identification leads to stage-inappropriate advice: recommending production agentic workflows to a Stage 1 team, or telling a Stage 4 team to "just experiment." The assessment prevents both failure modes.

---

## The 5 Diagnostic Questions

Ask these questions one at a time. Listen for specifics — vague answers indicate the team is at Stage 1 or 2.

**Question 1 — Pipeline Maturity**
> "Do you have a CI/CD pipeline where **all changes** — including AI-generated code — go through automated tests before deployment? Can you describe what runs in that pipeline?"

Listen for: test coverage %, pipeline tools, whether AI output bypasses the pipeline.

**Question 2 — AI Tool Usage Consistency**
> "What AI tools does your team currently use, and are they used **consistently across the team**, or ad-hoc by individuals?"

Listen for: named tools (Copilot, Claude, ChatGPT), team-wide vs. personal usage, whether there are shared conventions or everyone prompts differently.

**Question 3 — Shared Conventions**
> "Do you have a **shared prompt library** or written AI conventions doc that the whole team follows? Or a context/ directory pattern for grounding AI tools in your codebase?"

Listen for: existence of a conventions doc, shared repo for prompts, spec-before-code practice.

**Question 4 — DORA Measurement**
> "Have you measured your DORA metrics in the last quarter? Specifically: deployment frequency, lead time for changes, change failure rate, and MTTR?"

Listen for: actual numbers, tooling used to measure, whether AI's impact on these metrics is tracked.

**Question 5 — ADR Practice**
> "Has your team written an Architecture Decision Record (ADR) for any AI tool or agentic workflow you've adopted?"

Listen for: ADR existence, whether ADRs include Responsible AI assessments, Shostack threat models.

---

## Stage Mapping Decision Logic

Map answers to a stage using this decision table:

| Stage | Pipeline | Consistency | Conventions | DORA | ADRs |
|-------|----------|-------------|-------------|------|------|
| **1 — Explore / Individual** | No pipeline, or pipeline bypassed | Individual, ad-hoc | None | Not measured | None |
| **2 — Team Experiments** | Pipeline exists, some AI output tested | Team aware of AI tools, inconsistent use | Informal / emerging | Partially measured | None or informal |
| **3 — Standardise** | All AI output through pipeline | Consistent team usage, shared prompts | Written conventions, spec-before-code starting | DORA baseline established | At least 1 ADR written |
| **4 — Optimise** | Pipeline catches AI regressions, metrics improving | AI embedded in workflow, prompt library maintained | Context/ directories, spec-file skill in use | DORA improving, SPACE tracked | ADR catalogue, Responsible AI sections |
| **5 — Transform** | Agentic workflows in production through pipeline | Agentic automation for routine O&A tasks | Full framework adopted, contributing to open YANG/TMF tooling | DORA elite tier, SCI tracked | ADR for every agentic workflow, threat models reviewed |

When answers are mixed, **default to the lower stage**. It is always better to be accurately at Stage 2 and improve than to claim Stage 3 and skip foundations.

---

## Kent Beck 3X Phase Reminder

After stating the stage, always add:

- **Stage 1–2** → You are in **Explore** mode (Beck 3X). *Tolerate waste. Maximise learning. Run experiments. Do not standardise yet — you do not know what works. The cost of premature standardisation is higher than the cost of inconsistency at this stage.*

- **Stage 3–4** → You are in **Expand** mode (Beck 3X). *Standardise what works. Reduce variance. Invest in the platform. Kill experiments that haven't proven value. The cost of inconsistency now exceeds the cost of standardisation.*

- **Stage 5** → You are in **Extract** mode (Beck 3X). *Automate what is standardised. Measure ROI explicitly. Track SCI. Open-source what gives you no competitive advantage. The cost of manual repetition is now the dominant waste.*

---

## AI Ceiling Reminder

Always include this at the end of the assessment:

> "**Remember the AI Ceiling**: AI amplifies existing practices — good and bad. Your MSD health (pipeline maturity, test coverage, trunk-based development) sets the ceiling on how much AI can help you. If your pipeline is broken, AI will help you produce broken code faster. Before investing in AI tools, invest in MSD foundations."

---

## Recommended Next 3 Actions

Provide exactly 3 concrete next actions per stage:

**Stage 1 → Stage 2**:
1. Pick one AI tool as a team experiment — one tool, time-boxed to 4 weeks
2. Write a 1-page retrospective after 4 weeks: what worked, what didn't
3. Read the framework's Stage 2 guide at https://github.com/RickMorrison99/AI-Journey

**Stage 2 → Stage 3**:
1. Write your first shared prompt library (start with the 5 most-used prompts)
2. Ensure all AI-generated code goes through the CI pipeline — no exceptions
3. Write your first ADR for the AI tool your team uses most

**Stage 3 → Stage 4**:
1. Establish a DORA baseline measurement this sprint
2. Introduce SPACE tracking alongside DORA (never Activity alone)
3. Run the `adoption-check` skill again in 90 days with the baseline numbers

**Stage 4 → Stage 5**:
1. Identify one routine O&A task to automate with an agentic workflow
2. Write the ADR with STRIDE threat model before building
3. Track SCI (Software Carbon Intensity) for AI inference in the pipeline

**Stage 5 (maintain)**:
1. Review all AI-related ADRs annually — Wardley positions shift
2. Track SCI trends and report in quarterly engineering review
3. Contribute one YANG module or TMF adapter back to open-source this quarter
