# Measurement Philosophy

> *"Measure what matters, and only what matters."*
> — Nicole Forsgren, co-author of *Accelerate* and lead researcher, DORA

---

## Why Measurement Discipline Matters for AI Adoption

Adopting AI tooling inside an engineering team is easy to *feel* rather than *see*. Team Members report that Copilot "saves them time." Dashboards show more PRs merged per sprint. Leaders celebrate rising AI acceptance rates. And then, six months later, production incidents are up, onboarding takes longer than before, and the team feels oddly more exhausted than when they started.

This happens because measuring AI adoption incorrectly is worse than not measuring it at all. Bad metrics create incentives that drive exactly the wrong behaviours. The O&A team's measurement framework is designed to prevent this failure mode before it takes root.

---

## The Two Validated Frameworks at the Core

The O&A measurement framework does not invent new metrics. Instead, it builds on two bodies of research that have survived peer review, replication, and real-world scrutiny at scale:

### 1. DORA — Delivery Performance
**Source:** Forsgren, N., Humble, J., & Kim, G. (2018). *Accelerate: The Science of Lean Software and DevOps*. IT Revolution Press.

The DevOps Research and Assessment (DORA) programme produced four software delivery metrics — Deployment Frequency, Lead Time for Changes, Mean Time to Restore (MTTR), and Change Failure Rate — that are statistically linked to organisational performance outcomes. This is not opinion; it is the result of seven years of research across 33,000+ technology professionals.

DORA answers the question: **Is the team delivering software effectively?**

→ See [`dora-metrics.md`](./dora-metrics.md) for full detail.

### 2. SPACE — Developer Productivity
**Source:** Forsgren, N., Storey, M.-A., Maddila, C., Zimmermann, T., Houck, B., & Butler, J. (2021). "The SPACE of Developer Productivity." *ACM Queue*, 19(1).

The SPACE framework was published specifically to counter the industry habit of measuring developer productivity through Activity proxies (lines of code, commits, PRs). It defines five orthogonal dimensions — Satisfaction & Well-being, Performance, Activity, Communication & Collaboration, and Efficiency & Flow — and insists that no single dimension can substitute for the whole.

SPACE answers the question: **Are developers working in a healthy, sustainable, productive way?**

→ See [`space-framework.md`](./space-framework.md) for full detail.

---

## Why We Don't Invent New Metrics

Dave Farley, in *Modern Software Engineering* (2022), warns that proxy metrics — numbers that stand in for the outcomes you actually care about — corrupt over time. The moment a metric becomes a target, team members (rationally, sensibly) optimise for the metric rather than the underlying value it was meant to represent. This is Goodhart's Law:

> *"When a measure becomes a target, it ceases to be a good measure."*
> — Charles Goodhart (popularised by Marilyn Strathern)

Every metric the O&A team tracks can be traced back to a peer-reviewed framework with an explicit rationale. If a proposed metric cannot be mapped to DORA, SPACE, or the AI-specific adoption layer (which itself maps *back* into DORA/SPACE), it does not belong in the dashboard.

---

## The Layering Model

The O&A measurement stack is explicitly layered. Each layer answers a different question, and no layer is sufficient on its own:

```
┌─────────────────────────────────────────────────────┐
│           AI-SPECIFIC ADOPTION KPIs                 │
│  (Tool active rate, agentic depth, prompt reuse…)   │
│  Question: Is AI adoption healthy and maturing?     │
│  Maps back into DORA + SPACE — never standalone     │
├─────────────────────────────────────────────────────┤
│           SPACE FRAMEWORK                           │
│  (Satisfaction, Performance, Activity,              │
│   Communication, Efficiency)                        │
│  Question: Are developers productive and healthy?   │
├─────────────────────────────────────────────────────┤
│           DORA METRICS                              │
│  (Deployment Frequency, Lead Time, MTTR, CFR)       │
│  Question: Is software delivery performing well?    │
└─────────────────────────────────────────────────────┘
```

**Reading the layers from the bottom up:**

1. **DORA is the foundation.** If delivery performance is degrading, nothing in the layers above can compensate. A spike in AI acceptance rate means nothing if Change Failure Rate is climbing.
2. **SPACE sits in the middle.** It explains *why* DORA metrics move — whether changes in delivery performance are driven by sustainable productivity improvements or by activity gaming and burnout.
3. **AI KPIs sit at the top.** They are diagnostic: they tell us whether AI tooling is being adopted, used meaningfully, and integrated into real workflows. They must always be interpreted in light of DORA and SPACE signals below.

---

## Anti-Patterns to Avoid

The following measurement patterns are explicitly prohibited in O&A reporting. Each one has been observed in real teams and has caused measurable harm.

### Anti-Pattern 1: The Activity Trap
Reporting AI adoption success using only Activity-layer metrics:
- ✗ "AI acceptance rate is up 40% — adoption is succeeding."
- ✗ "We merged 20% more PRs this sprint — AI is working."
- ✗ "Lines of code per team member increased — productivity is up."

Activity metrics are *inputs*, not *outcomes*. An team member can accept every Copilot suggestion, merge more PRs than ever, and write twice as much code — while simultaneously introducing more bugs, increasing technical debt, and burning out within six months.

**The fix:** Always show Activity (SPACE-A) alongside Performance (SPACE-P) and Satisfaction (SPACE-S).

### Anti-Pattern 2: The Vanity Dashboard
A dashboard full of green metrics that are easy to game and disconnected from delivery outcomes. If every number is green and the team feels worse than before, the dashboard is measuring the wrong things.

### Anti-Pattern 3: The Survey Skip
Satisfaction and Well-being (SPACE-S) are the most commonly dropped dimension because they are "soft" and harder to automate. They are also the leading indicator for burnout, attrition, and the "quiet quitting" of AI tools that looked great in month three and sat unused by month nine.

**The fix:** Bi-weekly retro questions are non-negotiable. See the SPACE framework document for the exact question set.

### Anti-Pattern 4: Metric Accumulation
Adding new metrics continuously without retiring old ones. Within two quarters a team can accumulate 40+ tracked metrics, none of which anyone reads or acts on. Every metric must have an *owner*, a *review cadence*, and a *sunset condition*.

---

## Complete Metrics Overview

The following table lists every metric tracked in the O&A measurement framework. Use this table to navigate to the relevant document for detail.

| Metric | Category | Framework | Document |
|---|---|---|---|
| Deployment Frequency | Delivery | DORA | [dora-metrics.md](./dora-metrics.md) |
| Lead Time for Changes | Delivery | DORA | [dora-metrics.md](./dora-metrics.md) |
| Mean Time to Restore (MTTR) | Delivery | DORA | [dora-metrics.md](./dora-metrics.md) |
| Change Failure Rate | Delivery | DORA | [dora-metrics.md](./dora-metrics.md) |
| Satisfaction & Well-being Score | Developer | SPACE-S | [space-framework.md](./space-framework.md) |
| Bug Escape Rate | Developer | SPACE-P | [space-framework.md](./space-framework.md) |
| Rework Rate (AI-assisted PRs) | Developer | SPACE-P | [space-framework.md](./space-framework.md) |
| YANG Model Defect Rate | Developer | SPACE-P | [space-framework.md](./space-framework.md) |
| PRs Merged per Sprint | Developer | SPACE-A | [space-framework.md](./space-framework.md) |
| AI Code Acceptance Rate | Developer | SPACE-A | [space-framework.md](./space-framework.md) |
| PR Review Cycle Time | Developer | SPACE-C | [space-framework.md](./space-framework.md) |
| Documentation Contribution Rate | Developer | SPACE-C | [space-framework.md](./space-framework.md) |
| Unplanned Work Ratio | Developer | SPACE-E | [space-framework.md](./space-framework.md) |
| WIP per Team Member | Developer | SPACE-E | [space-framework.md](./space-framework.md) |
| AI Tool Weekly Active Rate | AI Adoption | AI KPI | [ai-adoption-kpis.md](./ai-adoption-kpis.md) |
| Tool Portfolio Breadth | AI Adoption | AI KPI | [ai-adoption-kpis.md](./ai-adoption-kpis.md) |
| AI Code Acceptance Rate | AI Adoption | AI KPI | [ai-adoption-kpis.md](./ai-adoption-kpis.md) |
| Test Coverage Delta | AI Adoption | AI KPI | [ai-adoption-kpis.md](./ai-adoption-kpis.md) |
| Agentic Delegation Depth | AI Adoption | AI KPI | [ai-adoption-kpis.md](./ai-adoption-kpis.md) |
| Agentic Completion Rate | AI Adoption | AI KPI | [ai-adoption-kpis.md](./ai-adoption-kpis.md) |
| Human-in-the-Loop Rate | AI Adoption | AI KPI | [ai-adoption-kpis.md](./ai-adoption-kpis.md) |
| Prompt Template Reuse Rate | AI Adoption | AI KPI | [ai-adoption-kpis.md](./ai-adoption-kpis.md) |
| Time-to-First-AI-Use | AI Adoption | AI KPI | [ai-adoption-kpis.md](./ai-adoption-kpis.md) |

---

## Review Cadence

| Frequency | Activity |
|---|---|
| Bi-weekly (each sprint retro) | SPACE-S pulse survey (5 questions); WIP and unplanned work review |
| Monthly | AI KPI dashboard review; flag any Activity/Performance divergence |
| Quarterly | Full DORA review; full SPACE radar report; AI adoption maturity assessment; retire or adjust any metric not generating action |
| Annually | Benchmark O&A DORA bands against industry; recalibrate targets |

---

## Document Ownership

| Document | Owner | Last Reviewed |
|---|---|---|
| `index.md` (this file) | Engineering Lead | — |
| `dora-metrics.md` | Platform/DevOps Lead | — |
| `space-framework.md` | Engineering Manager | — |
| `ai-adoption-kpis.md` | AI Adoption Lead | — |

---

*This document is part of the O&A AI-Agentic Adoption Journey framework. All measurement decisions should be validated against the primary sources cited before modification.*
