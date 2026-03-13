# DORA Metrics — Delivery Performance

> *"High performers using continuous delivery practices don't just deploy more often — they also have higher quality and better stability. Speed and stability are not a trade-off."*
> — Nicole Forsgren, Jez Humble, Gene Kim, *Accelerate* (2018)

---

## What DORA Is and Why It Matters

The DevOps Research and Assessment (DORA) programme, founded by Dr Nicole Forsgren, ran for seven years and surveyed more than 33,000 technology professionals across industries, company sizes, and geographies. The central finding, published in *Accelerate: The Science of Lean Software and DevOps* (IT Revolution Press, 2018), is that four software delivery metrics reliably predict organisational performance — including profitability, market share, and the ability to meet customer goals.

These four metrics are not opinions or best guesses. They are the output of structural equation modelling and predictive validity testing. Teams that score in the Elite band consistently outperform teams in the Low band across every dimension of organisational health that DORA measured.

For the O&A team, DORA metrics serve as the **delivery health baseline**. Before AI adoption can be declared successful, delivery performance must not degrade. The hypothesis is that well-integrated AI tooling improves all four metrics over time. This document defines how to measure them in the network automation context, where "deployment" looks different from a standard web application context.

---

## The Four DORA Metrics — O&A Definitions

### 1. Deployment Frequency

**Standard definition:** How often an organisation successfully releases to production.

**O&A context:** The O&A team delivers software in a network-first context. "Deployment" includes, but is not limited to:

| Deployment Type | Description | Example |
|---|---|---|
| Network automation script release | A new or updated Ansible playbook, NSO service package, or Python automation script promoted to staging or production | Ansible role update deployed to network lab, then production spine switches |
| YANG model update | A new or revised YANG data model pushed to the NSO instance or northbound API | Updated `ietf-interfaces` augmentation deployed to staging NSO |
| API change | A change to the northbound REST/NETCONF/RESTCONF interface reaching the integration environment | New RESTCONF endpoint for BGP policy management |
| Infrastructure-as-code change | Terraform, Nornir, or similar IaC changes applied to managed network infrastructure | Nornir configuration template promoted to production |
| CI/CD pipeline self-change | Updates to the O&A team's own build, test, or deployment pipelines | New Molecule test stage added to the Ansible pipeline |

**Why this matters:** Teams in network automation often artificially deflate deployment frequency by batching changes or treating "push to Git" as equivalent to deployment. For O&A, a deployment is counted only when a change successfully passes the automated test gate and is applied to a staging or production environment. A commit that sits in a branch for two weeks does not count.

**Measurement unit:** Deployments per team member per week (aggregate across team, divided by team member count for normalisation).

---

### 2. Lead Time for Changes

**Standard definition:** The time it takes to go from code committed to code successfully running in production.

**O&A context:** Lead time is measured from the moment a commit lands on the `main` branch (or is merged via PR) to the moment the resulting artifact is confirmed running in the staging environment. For network automation, the pipeline stages are typically:

```
Git Commit / PR Merge
       │
       ▼
Linting + Static Analysis
(yamllint, ansible-lint, pyang, pylint)
       │
       ▼
Unit / Integration Tests
(Molecule, pytest-netconf, mock NSO)
       │
       ▼
Artefact Build
(NSO package compilation, Ansible collection build)
       │
       ▼
Staging Deployment
(Apply to lab network or NSO staging instance)
       │
       ▼
Automated Smoke Tests
(NETCONF RPC validation, RESTCONF response checks)
       │
       ▼
✓ LEAD TIME ENDS HERE (staging confirmed healthy)
       │
       ▼  [Manual gate or automated promotion]
Production Deployment
```

**Why this matters:** Long lead times are a symptom of large batch sizes, slow test suites, manual approval bottlenecks, or fragile automation. In the O&A context, they often indicate that YANG model changes require extensive manual validation before team members trust them enough to merge.

**Measurement unit:** Median lead time in hours (use median rather than mean to resist skew from outlier large-batch releases).

---

### 3. Mean Time to Restore (MTTR)

**Standard definition:** How long it takes to restore service when an incident or outage occurs.

**O&A context:** MTTR covers the full incident lifecycle in the network automation domain:

| Incident Type | Detection Source | Restore Criterion |
|---|---|---|
| Network automation failure | CI/CD pipeline alert; NSO alarm; Ansible run failure notification | Automation script confirmed running successfully on target devices |
| Network configuration drift | NSO compliance report; configuration diff alert | Intended configuration re-applied and verified via NETCONF `<get-config>` |
| API degradation | Uptime monitor; RESTCONF health check failure; consumer team alert | API returning correct responses, confirmed by automated smoke test |
| NSO service outage | NSO process monitor; northbound API 5xx responses | NSO instance healthy; all committed services confirmed in-sync |
| Playbook regression | Post-deployment Ansible run failure on production | Rollback applied or fix deployed; network state confirmed correct |

**Measurement:** MTTR = (Incident Resolved Timestamp − Incident Detected Timestamp), averaged over all incidents in the measurement period.

**Important distinction:** Detection time is not the same as occurrence time. If a network configuration drift happened at 14:00 but was not detected until 14:45 (because the compliance check runs every hour), MTTR begins at 14:45. This is intentional — MTTR measures the team's response capability, not the detection gap. Detection gap is tracked separately as a system health metric.

**Measurement unit:** Median MTTR in minutes (for frequent low-severity incidents) or hours (for major outages).

---

### 4. Change Failure Rate

**Standard definition:** The percentage of deployments that cause a degradation in service and require remediation (rollback, hotfix, or forward-fix under incident conditions).

**O&A context:** A change is considered a failure if any of the following occur within 24 hours of deployment to staging or 72 hours of deployment to production:

- The deployment is rolled back (NSO `rollback`, Ansible dry-run and manual revert, Git revert deployed)
- A P1 or P2 incident is raised and attributed to the change
- A hotfix commit is required to stabilise the environment
- Automated post-deployment smoke tests fail and manual remediation is required
- Network devices enter an inconsistent state (NETCONF `<commit>` accepted but device reports configuration mismatch)

**Not a failure:** A deployment that triggers an automated test failure in the staging environment and is blocked *before* reaching production. The pipeline caught it. That is the system working correctly.

**Measurement unit:** `(Failed Deployments / Total Deployments) × 100`, expressed as a percentage.

---

## Performance Bands

The following bands are drawn directly from the DORA research. Teams should identify their current band per metric and set targets one band above. Attempting to jump from Low to Elite in a single quarter is a gamification risk.

| Metric | Low | Medium | High | Elite |
|---|---|---|---|---|
| **Deployment Frequency** | Fewer than once per month | Once per month to once per week | Once per week to once per day | On demand (multiple times per day) |
| **Lead Time for Changes** | More than 6 months | 1 month to 6 months | 1 day to 1 week | Less than 1 hour |
| **MTTR** | More than 1 week | 1 day to 1 week | Less than 1 day | Less than 1 hour |
| **Change Failure Rate** | 46–60% | 16–30% | 0–15% | 0–15%* |

*Elite and High share the CFR band in DORA research; Elite is differentiated by Deployment Frequency and Lead Time.

**Note for O&A:** Network automation teams often start in the Medium band for Deployment Frequency and Lead Time due to the complexity of network device testing environments and the conservatism appropriate when mistakes affect live network infrastructure. This is expected and acceptable — the goal is progressive improvement, not instant Elite status.

---

## Current O&A Baseline

*To be completed after the initial baseline survey and first two-sprint measurement cycle.*

| Metric | Current Value | Band | Measurement Date | Data Source |
|---|---|---|---|---|
| Deployment Frequency | `[TBD]` | `[TBD]` | `[TBD]` | GitHub Actions / CD pipeline |
| Lead Time for Changes | `[TBD]` | `[TBD]` | `[TBD]` | GitHub commit → deployment timestamp |
| MTTR | `[TBD]` | `[TBD]` | `[TBD]` | Incident tracking system |
| Change Failure Rate | `[TBD]` | `[TBD]` | `[TBD]` | CD pipeline + incident log |

**Instructions for baseline collection:**
1. Pull the last 90 days of deployment events from the CI/CD pipeline. Count only deployments that reached staging or production.
2. For each deployment, record the merge timestamp and the staging-confirmed timestamp. Compute median delta.
3. Pull all incidents from the incident tracking system for the same 90-day window. Filter to incidents attributed to a deployment change. Compute median resolution time.
4. Compute CFR as (incidents attributed to a deployment / total deployments) × 100.
5. Enter values in the table above and commit. This is your baseline. Do not adjust it retroactively.

---

## AI Adoption Hypotheses

For each DORA metric, the following table states the hypothesis for how AI tooling should affect it, and what evidence would confirm or refute that hypothesis.

| Metric | Hypothesis | Confirming Signal | Refuting Signal |
|---|---|---|---|
| **Deployment Frequency** | AI-assisted code generation and test authoring reduces the time to produce a deployment-ready change, enabling smaller batch sizes and more frequent deploys. | Deployment frequency increases quarter-on-quarter without a corresponding rise in CFR. | Deployment frequency rises but CFR rises proportionally — team members are shipping faster but less carefully. |
| **Lead Time for Changes** | AI-accelerated linting, test generation, and code review assistance removes bottlenecks in the pipeline, reducing median lead time. | Median lead time drops; specifically, time-in-PR-review and time-in-test-authoring decrease. | Lead time drops but rework rate rises — changes are moving through faster but requiring post-deployment fixes. |
| **MTTR** | AI-assisted root cause analysis (log summarisation, NETCONF diff analysis, Ansible run failure diagnosis) reduces time-to-diagnose, which is typically the longest phase of MTTR. | Median MTTR decreases; specifically, time-to-diagnosis phase decreases as measured in post-incident reviews. | MTTR stays flat or increases — AI suggestions during incidents introduce noise or distract from root cause. |
| **Change Failure Rate** | AI-generated tests, linting improvements, and YANG model validation catch more defects before deployment. | CFR decreases quarter-on-quarter; AI-assisted PRs have lower post-deployment failure rate than non-AI PRs. | CFR increases — team members over-trust AI-generated code and reduce manual review rigour. |

---

## Data Collection Approach

| Metric | Primary Source | Secondary Source | Collection Method |
|---|---|---|---|
| Deployment Frequency | CI/CD pipeline deployment logs (e.g., GitHub Actions, Jenkins) | NSO commit history / Ansible AWX job log | Automated: query pipeline API weekly; aggregate deployment events |
| Lead Time for Changes | GitHub PR merge timestamp (start) + pipeline deployment confirmation timestamp (end) | Git commit log | Automated: GitHub API `pulls` endpoint + deployment events API |
| MTTR | Incident tracking system (e.g., PagerDuty, Jira incident tickets, ServiceNow) | Post-incident review notes | Semi-automated: export incident log monthly; compute median resolution time |
| Change Failure Rate | CI/CD pipeline (failed post-deployment smoke tests) + incident tracking (incidents linked to deployments) | PR revert/rollback events in GitHub | Semi-automated: join deployment log with incident log on timestamp proximity |

**Tooling note:** If the team uses GitHub Actions as the primary CI/CD system, the GitHub Insights API provides deployment frequency and lead time data natively. MTTR and CFR will require a join with the external incident tracking system and should be computed in a lightweight script run monthly.

---

## Pitfalls: Goodhart's Law Applied to DORA

Each DORA metric, if targeted naively, can be gamed into meaninglessness. The following examples are based on observed failure patterns in software organisations.

### Deployment Frequency — Gaming Risk
**The trap:** A team under pressure to increase deployment frequency splits large features into artificially small deploys, or pushes trivial documentation-only commits as "deployments."

**The signal:** Deployment frequency rises sharply while lead time does not improve and team satisfaction drops (team members resent the overhead of micro-deployments).

**The guard:** Only count deployments that include a functional change (code, YANG model, configuration template). Document and commit this definition. Review it at the quarterly retro.

---

### Lead Time for Changes — Gaming Risk
**The trap:** A team shortens lead time by bypassing the test stage ("it's just a YANG annotation change, it doesn't need a full Molecule run") or by maintaining a permanently fast-lane path that bypasses quality gates.

**The signal:** Lead time drops dramatically in a single sprint; CFR rises in the subsequent sprint.

**The guard:** Lead time is only valid if the pipeline stages are stable and consistent. Track pipeline stage durations separately. If the test stage is being skipped, that is a quality process failure, not a lead time improvement.

---

### MTTR — Gaming Risk
**The trap:** Incidents are closed prematurely ("network is back up, ticket closed") before root cause is confirmed, then re-opened when the same issue recurs within hours.

**The signal:** MTTR appears excellent but incident volume is high, and repeat incidents on the same component are common.

**The guard:** MTTR tickets are only closed when: (a) the service is confirmed restored via automated health check, and (b) a post-incident note is written stating the root cause (even if preliminary). Re-opened incidents are counted as new MTTR events.

---

### Change Failure Rate — Gaming Risk
**The trap:** Incidents are not attributed to the preceding deployment, either through negligence or deliberate avoidance of accountability. "The network was already unstable" becomes a catch-all excuse.

**The signal:** CFR appears very low but post-incident reviews consistently identify deployment changes as contributing factors.

**The guard:** CFR attribution is done by the incident response team, not the deploying team. Any incident occurring within the defined window (24h staging, 72h production) is considered a candidate and must be explicitly ruled out with a written rationale.

---

## Quarterly DORA Review Template

Use this template at the end of each quarter to review DORA progress. The review should take no more than 60 minutes and should be attended by the Engineering Lead, Platform/DevOps Lead, and at least one representative team member from each squad.

---

```
O&A DORA QUARTERLY REVIEW
Quarter: [Q? YYYY]
Facilitator: [Name]
Date: [Date]

─────────────────────────────────────────────────────────────────
SECTION 1: METRIC SUMMARY
─────────────────────────────────────────────────────────────────

Metric               | Last Quarter | This Quarter | Delta | Band
─────────────────────────────────────────────────────────────────
Deployment Frequency |              |              |       |
Lead Time            |              |              |       |
MTTR                 |              |              |       |
Change Failure Rate  |              |              |       |

─────────────────────────────────────────────────────────────────
SECTION 2: AI HYPOTHESIS VALIDATION
─────────────────────────────────────────────────────────────────

For each metric, did results match the AI adoption hypothesis?

Deployment Frequency:
  Hypothesis confirmed / refuted / inconclusive?
  Evidence:
  Notes:

Lead Time for Changes:
  Hypothesis confirmed / refuted / inconclusive?
  Evidence:
  Notes:

MTTR:
  Hypothesis confirmed / refuted / inconclusive?
  Evidence:
  Notes:

Change Failure Rate:
  Hypothesis confirmed / refuted / inconclusive?
  Evidence:
  Notes:

─────────────────────────────────────────────────────────────────
SECTION 3: GOODHART'S LAW CHECK
─────────────────────────────────────────────────────────────────

Is any metric improving while a correlated metric is degrading?
  (e.g., Deployment Frequency up + CFR up = gaming risk)

Findings:

─────────────────────────────────────────────────────────────────
SECTION 4: TARGETS FOR NEXT QUARTER
─────────────────────────────────────────────────────────────────

Metric               | Current Band | Target Band | Specific Target Value
─────────────────────────────────────────────────────────────────
Deployment Frequency |              |             |
Lead Time            |              |             |
MTTR                 |              |             |
Change Failure Rate  |              |             |

─────────────────────────────────────────────────────────────────
SECTION 5: ACTIONS
─────────────────────────────────────────────────────────────────

Action                    | Owner | Due Date | Link to SPACE/AI KPI
─────────────────────────────────────────────────────────────────
                          |       |          |
                          |       |          |

─────────────────────────────────────────────────────────────────
SECTION 6: METRIC HEALTH CHECK
─────────────────────────────────────────────────────────────────

Are we still collecting each metric from the right source?
Are any data sources stale, unreliable, or disputed?

Notes:
```

---

*This document is part of the O&A AI-Agentic Adoption Journey framework. Primary source: Forsgren, Humble & Kim, "Accelerate" (2018), IT Revolution Press. DORA performance band data sourced from the 2023 State of DevOps Report.*
