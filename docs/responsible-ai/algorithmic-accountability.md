# Algorithmic Accountability

> **Status:** Living document · Owned by: O&A Engineering Team  
> **Frameworks:** Joy Buolamwini (Algorithmic Justice League) · Cathy O'Neil (*Weapons of Math Destruction*)  
> **Applies to:** All AI/ML models and AI-assisted decision systems deployed or evaluated by O&A

---

## 1. Why Network Automation Needs Algorithmic Accountability

AI in network automation is not neutral. When an AI system prioritises fault queues, allocates
resources, makes recommendations about network changes, or classifies incidents, it makes
**consequential decisions**. Those decisions have winners and losers — customers whose faults
are elevated or deprioritised, network domains that receive investment or neglect, engineers
whose work is shaped by what the AI considers important.

The dominant framing for AI adoption in engineering is capability: *what can the model do?*
Algorithmic accountability adds the essential second question: *who is affected, and how could
this go wrong?*

Joy Buolamwini and Cathy O'Neil provide the two frameworks O&A needs to answer that question
systematically.

**Buolamwini** — through the Algorithmic Justice League (AJL) — provides the tools for auditing
AI systems for bias and disparate impact. Her concept of the *coded gaze* names the mechanism:
AI systems inherit the assumptions, biases, and blind spots of their creators and their training
data. For O&A, that means: if a model is trained on skewed data, it will produce skewed outputs —
and those outputs will affect real customers, real services, and real engineers.

**O'Neil** — through the *Weapons of Math Destruction* (WMD) framework — provides the test for
when an algorithm crosses from a useful tool into a harmful one. The three conditions are opacity,
scale, and damage. Applied to network automation, the test asks: could this model's failures cause
harm at scale, invisibly, to people who cannot appeal its decisions?

Together, these frameworks provide O&A with a practical, principled approach to deploying AI
systems that are not only capable, but accountable.

---

## 2. Buolamwini — The Coded Gaze and Bias Auditing

### The Coded Gaze

Buolamwini's foundational concept: AI systems do not arise from neutral, objective data. They
reflect the **coded gaze** — the perspective, priorities, and blind spots of the people who built
them and the data they trained on. Her landmark research demonstrated that commercial facial
recognition systems performed significantly worse on darker-skinned faces and women, not because
of malicious intent, but because the training data over-represented lighter-skinned male faces.

The lesson is structural, not personal: biased training data produces biased models regardless
of the intentions of the developers. The remedy is not good intentions; it is **systematic
auditing**.

For O&A, the coded gaze manifests differently than in facial recognition, but the mechanism is
identical. If fault prediction models are trained on incident data that over-represents certain
network segments — core infrastructure vs. edge, enterprise customers vs. residential, recently
modernised elements vs. legacy equipment — the model will **systematically misperform** on
under-represented segments. That misperformance is invisible unless you disaggregate your
performance metrics and look for it explicitly.

### Buolamwini's AJL Audit Framework Applied to O&A

Buolamwini's Algorithmic Justice League has developed a structured audit approach for AI systems.
Three principles are directly applicable to O&A:

#### Disaggregate Performance Metrics

Never report model accuracy as a single number. A model that achieves 92% accuracy overall may
achieve 97% accuracy on core infrastructure faults and 74% accuracy on residential edge faults.
The aggregate number hides the disparity that matters most.

**O&A requirement:** All AI performance reports must include disaggregated metrics broken down by
at least the dimensions specified in Section 5.

#### Test for Disparate Impact

After disaggregating metrics, test whether the performance differences are statistically
significant and operationally meaningful. A difference of 2% may be noise; a difference of 15%
in fault classification accuracy between enterprise and residential segments is a systematic
failure that will compound over time.

**O&A requirement:** Any AI model affecting incident prioritisation or resource allocation must
include an explicit disparate impact assessment before deployment.

#### Interrogate the Training Data

For every model proposed for O&A use, the following questions must be answered in the ADR:

- **What time period does the training data cover?** A model trained on data from 2019–2022 may
  not reflect the current network topology, NOS versions, or customer mix.
- **What incidents are represented?** Were only formally ticketed incidents included? This
  systematically excludes informally resolved issues, biasing the model toward documented rather
  than actual failure patterns.
- **What was excluded, and why?** Exclusions are often invisible in model documentation but
  critical to understanding bias.
- **What biases does the collection method introduce?** If data was collected by senior engineers,
  it may over-represent the failure categories that senior engineers recognise and under-represent
  novel or unfamiliar failure modes.

### O&A Worked Example: Fault-Prioritisation Model

Consider a proposed AI fault-prioritisation model trained on three years of historical incident
data. Before deployment, the following questions must be asked:

| Question | Why It Matters |
|---|---|
| Which network domains are represented in the training data? | Edge and access network faults may be under-represented if they were historically resolved informally without ticketing |
| What is the ratio of enterprise to residential incidents in the training set? | Enterprise incidents are typically better documented; a model trained on this data will be more accurate for enterprise faults |
| Were incidents from network modernisation periods included? | Post-modernisation networks behave differently; a model that does not include this transition period may misclassify modern-network faults |
| Who labelled the ground truth (i.e., which faults were "high priority")? | If labelling was done by senior engineers with specific domain expertise, the model inherits their perspective, including their blind spots |
| What was the SLA landscape during the training period? | SLA changes over three years mean that priority classifications in 2021 may not be appropriate for 2024 |
| Were any systematic exclusions applied to the data? | Filtering out "low-confidence" incidents may exclude exactly the failure modes the model most needs to learn |
| Does the model's accuracy vary by incident type, domain, or customer segment? | If not measured, it is unknown — and unknown disparate impact is still disparate impact |

Answering these questions before deployment is the minimum required for algorithmic accountability.
Leaving them unanswered is not a neutral decision — it is a decision to deploy a potentially biased
model without understanding its failure modes.

---

## 3. O'Neil — Weapons of Math Destruction

### The Three Conditions

Cathy O'Neil's *Weapons of Math Destruction* (2016) defines an algorithm that causes serious harm
as a WMD. The three conditions that transform a useful model into a weapon are:

**Opacity** — The model's decisions cannot be explained or audited. Stakeholders cannot understand
why the model produced a particular output, cannot challenge it, and cannot identify when it is
wrong. Opacity is the condition that allows the other two conditions to cause unchecked harm.

**Scale** — The model affects many people, many customers, or large parts of the system. A model
that makes one decision for one person once is low scale. A model that makes thousands of
decisions per day affecting every customer in a region is high scale. Scale amplifies both the
benefits and the harms of a model.

**Damage** — The model causes real, material harm: SLA breaches, service degradation, unfair
prioritisation, financial loss, or operational failure. A model that makes suboptimal
recommendations that are always reviewed by a human before action has low damage potential.
A model that drives automated action without human review has high damage potential.

O'Neil's insight is that these three conditions interact multiplicatively. A highly opaque model
affecting few people causing minor inconvenience is not a WMD. An opaque model operating at
massive scale causing significant harm is.

### The WMD Test Applied to O&A AI Use Cases

#### Use Case 1: AI-Assisted Fault Prioritisation

| WMD Dimension | Assessment | Rationale |
|---|---|---|
| **Opacity** | HIGH | Fault-ranking models are typically black-box classifiers. The reason a fault is ranked #3 vs. #7 is not explainable to the NOC engineer or the affected customer. |
| **Scale** | HIGH | Fault prioritisation affects every fault across the entire customer base. A systematic mis-ranking affects potentially thousands of customers simultaneously. |
| **Damage** | HIGH | Deprioritised faults translate directly to SLA breaches, extended outages, and service degradation for real customers. Enterprise customers may face contractual penalties; residential customers may lose essential services. |
| **WMD Risk** | 🔴 HIGH | All three conditions are present. This use case requires the full pre-deployment accountability checklist, mandatory disaggregated metrics, human review of all AI rankings, and an explicit appeal mechanism. |

#### Use Case 2: AI-Assisted YANG Stub Generation

| WMD Dimension | Assessment | Rationale |
|---|---|---|
| **Opacity** | LOW | The AI output is readable source code. An engineer reviewing the PR can read, understand, and critique every line of the generated stub. The decision logic is inspectable. |
| **Scale** | LOW | Each generated stub is reviewed by one engineer in a single PR. The model affects one team member's workflow at a time. |
| **Damage** | LOW | Incorrect YANG stubs are caught in PR review, schema validation, and CI pipeline checks before they reach production. The feedback loop is short and the review is mandatory. |
| **WMD Risk** | 🟢 LOW | None of the three conditions are present at meaningful levels. Standard code review and CI validation are sufficient controls. No additional accountability overhead is required. |

#### Use Case 3: AI-Assisted Resource Allocation

| WMD Dimension | Assessment | Rationale |
|---|---|---|
| **Opacity** | MEDIUM | Resource allocation recommendations are partially explainable (e.g., "based on utilisation trend") but the weighting and interaction of multiple factors is not fully transparent. |
| **Scale** | HIGH | Resource allocation decisions affect network capacity across entire domains. Systematic under-allocation to a segment affects all customers in that segment. |
| **Damage** | MEDIUM | Suboptimal resource allocation causes degraded performance and potential SLA impact, but the effects are typically gradual rather than immediate, and are partially detectable through monitoring. |
| **WMD Risk** | 🟡 MEDIUM | Scale is high; opacity is partial; damage is real but detectable. Requires disaggregated performance monitoring, a human review gate before acting on recommendations, and explicit scope boundary in the ADR. |

### The WMD Test as a Design Gate

The WMD test is not applied retrospectively. It is applied **before deployment**, as part of the
ADR process. Any AI use case that scores HIGH on two or more dimensions requires additional
accountability controls before it may proceed.

---

## 4. The Accountability Framework for O&A

### Combining Buolamwini and O'Neil

Buolamwini provides the *detection* toolkit: how to find bias and disparate impact in AI systems.
O'Neil provides the *risk classification* framework: how to assess whether a given AI system
poses serious harm risk. Together, they form a practical governance framework for O&A.

The framework is applied at two points:
1. **Pre-deployment** — the checklist below is completed and signed off as part of the ADR
2. **Ongoing** — disaggregated metrics and disparate impact monitoring are maintained in production

### Pre-Deployment Accountability Checklist

Every AI model or AI-assisted decision system deployed by O&A must complete this checklist before
going into production. The checklist must be included in the ADR. Incomplete checklists are
grounds to reject the ADR.

| # | Checklist Item | Owner | Status |
|---|---|---|---|
| 1 | **Training data audit:** Has the training data been audited for coverage gaps, exclusions, and sampling biases? Is the audit documented? | AI Champion | ☐ |
| 2 | **Disaggregated metrics:** Are performance metrics broken down by the relevant dimensions from Section 5? Are any dimensions unavailable, and why? | Senior team member | ☐ |
| 3 | **Explainability:** Is the model's decision logic explainable to the stakeholders affected by its decisions? If not, is opacity acknowledged as a risk? | AI Champion | ☐ |
| 4 | **WMD test:** Has the three-condition WMD test (opacity, scale, damage) been applied? What is the risk level, and what controls does that level require? | Senior team member | ☐ |
| 5 | **Human review gate:** Is there a mandatory human review step before the model's outputs drive consequential actions? If not, why is automation safe? | Product Owner | ☐ |
| 6 | **Appeal and override mechanism:** Is there a mechanism for affected stakeholders (NOC engineers, customers via service desk) to flag or override AI decisions? | Product Owner | ☐ |
| 7 | **Scope boundary:** Is the model's scope explicitly bounded in the ADR? Does the scope include what decisions the model may *not* make? | AI Champion | ☐ |
| 8 | **Ongoing monitoring plan:** Is there a plan to monitor for disparate impact over time, not just at initial deployment? Who is responsible? How often? | Senior team member | ☐ |
| 9 | **Accountability assignment:** Who is responsible for the model's outcomes in production? Is this clearly documented and accepted? | Engineering Lead | ☐ |
| 10 | **Rollback plan:** What is the procedure for disabling or reverting the model if harm is detected? Has it been tested? What is the recovery time? | AI Champion | ☐ |

---

## 5. Disaggregated Metrics for O&A

Reporting AI model performance as a single aggregate metric is insufficient for algorithmic
accountability. The following dimensions must be used to disaggregate metrics for all O&A AI
systems that affect operational decisions.

### Recommended Disaggregation Dimensions

| Dimension | Why It Matters | Example Metric |
|---|---|---|
| **Network domain** (core, access, edge, cloud) | Performance may vary significantly across domains due to different equipment types, NOS versions, and data quality | Fault classification accuracy per domain |
| **Customer segment** (enterprise, residential, public sector) | Enterprise faults may be better documented; residential faults may be systematically deprioritised | Fault resolution time by segment under AI prioritisation |
| **Geographic region** | Regional networks may have different infrastructure vintages, configurations, and failure modes | False positive rate per region |
| **Time window** (business hours, overnight, weekends) | Traffic patterns, staffing, and fault types vary by time; models may perform differently in low-traffic periods | Prioritisation accuracy by time window |
| **Incident severity** (P1, P2, P3, P4) | Model performance on critical incidents (P1) is most consequential and should be tracked separately | P1 recall rate (proportion of true P1s correctly classified) |
| **NOS version** | Newer NOS versions may produce different telemetry patterns that the model was not trained on | Classification accuracy by NOS version |
| **Infrastructure vintage** | Legacy equipment may produce anomalous patterns not well-represented in training data | Error rate for pre-2018 vs. post-2018 equipment |

### Metric Disaggregation Reporting Requirements

- Disaggregated metrics must be included in all AI governance reports
- Any dimension showing a performance gap of ≥10 percentage points relative to the aggregate
  baseline must be flagged and investigated
- Dimensions for which data is unavailable must be documented as known gaps, not silently omitted
- Disaggregation results must be reviewed at least quarterly and after any model update

---

## 6. Bias Sources in O&A Training Data

Understanding where bias enters O&A training data is prerequisite to auditing for it. The
following eight bias sources are specific to telecom network automation contexts.

### 1. Documented vs. Actual Failures

Historical incident data captures faults that were formally ticketed and documented. Faults
resolved informally — particularly by experienced engineers who "just fixed it" without raising a
ticket — are absent from the record. Training data therefore over-represents failures that match
existing detection and documentation processes, and under-represents novel or unfamiliar failure
modes.

*Mitigation:* Supplement ticketed incident data with network telemetry data that is collected
independently of the ticketing process.

### 2. SLA-Biased Documentation Quality

Incidents affecting contractually monitored customers receive more thorough documentation, faster
escalation, and richer resolution notes than incidents affecting non-SLA customers. Training on
this data produces models that perform better on SLA-relevant fault patterns — which may reinforce
existing customer tier inequalities.

*Mitigation:* Audit training data for documentation quality by customer segment. Weight sampling
to correct for under-documentation in non-SLA segments.

### 3. YANG Model Coverage Bias

AI tools trained on YANG models will perform better for recently modernised network elements
where YANG coverage is comprehensive, and worse for legacy equipment where YANG models are
incomplete, out of date, or absent. This creates a systematic performance gap that mirrors the
network modernisation investment pattern — well-funded domains perform better.

*Mitigation:* Document YANG coverage as part of model scope. Exclude or flag outputs for
network elements with incomplete YANG coverage.

### 4. Senior Engineer Classification Bias

When training data relies on human-labelled ground truth — "this fault was correctly prioritised
as P2" — the labels reflect the judgement of whoever did the labelling. If labelling was done
primarily by senior engineers, the model inherits their classification heuristics, including
domain expertise that may not generalise, and potentially their unconscious biases about which
types of faults "deserve" high priority.

*Mitigation:* Use multi-labeller agreement protocols. Document labeller demographics (seniority,
domain specialism). Track inter-labeller disagreement as a data quality metric.

### 5. Operational Period Bias

A model trained on data from a specific operational period inherits the characteristics of that
period: the network topology, the vendor mix, the traffic patterns, the SLA structure, and the
incident response processes of that time. If the operational environment has changed significantly
— through network modernisation, organisational change, or customer base evolution — the model
may be systematically wrong for the current environment.

*Mitigation:* Include training data vintage in all model documentation. Establish a maximum
allowable training data age policy (recommended: 18 months for rapidly evolving environments).

### 6. Geographic Representation Bias

If training data is collected from some geographic regions more thoroughly than others — due to
NOC staffing, monitoring coverage, or data pipeline completeness — the model will perform better
in well-instrumented regions. Regions with lower data quality are typically regions with older
infrastructure and, often, less economically influential customer bases.

*Mitigation:* Audit training data for geographic representation. Report model performance by
region in disaggregated metrics.

### 7. Survivorship Bias in Resolved Incidents

Training data typically includes incidents that were resolved. Incidents that were open for
extended periods, never resolved, or resolved unsatisfactorily may be excluded or under-weighted.
The model therefore learns what resolution looks like for typical cases, but may be poor at
recognising atypical cases — which are often the most consequential ones.

*Mitigation:* Explicitly include long-duration and unresolved incidents in training data review.
Audit whether the model's performance degrades for complex or atypical incidents.

### 8. Automation-Era Representation Bias

As O&A increasingly automates network operations, the incidents that reach human review will
change character — automated processes handle the routine cases, leaving humans (and the incident
record) with the unusual, complex, and ambiguous ones. A model trained on pre-automation incident
data will not reflect this shift. Training data collected in a partially automated environment
may over-represent failure modes of the automation systems themselves.

*Mitigation:* Segment training data by operational era (pre-automation, transitional,
post-automation). Retrain models as the automation environment matures.

---

## 7. Accountability Ownership

Algorithmic accountability is not a single person's responsibility. The following RACI table
assigns clear ownership for each accountability activity.

### RACI Table

| Activity | AI Champion | Senior Team Member | Product Owner | All Team Members | Engineering Lead |
|---|---|---|---|---|---|
| **Pre-deployment checklist completion** | Accountable | Responsible (items 2, 4, 8) | Consulted (items 5, 6, 7) | Informed | Signs off |
| **WMD test application** | Facilitates | Responsible | Consulted | Informed | Reviews |
| **Training data audit** | Accountable | Responsible | Consulted | Informed | — |
| **Disaggregated metrics design** | Accountable | Responsible | Consulted | Informed | — |
| **Disaggregated metrics review (ongoing)** | Accountable | Responsible | Informed | Informed | Quarterly review |
| **Disparate impact monitoring** | Accountable | Responsible | Informed | Informed | Escalation point |
| **ADR scope boundary definition** | Responsible | Consulted | Accountable | Informed | — |
| **Appeal and override mechanism design** | Consulted | Consulted | Accountable | Informed | — |
| **Rollback plan ownership** | Accountable | Responsible | Informed | Informed | Informed |
| **Accountability requirements communication** | Responsible | Responsible | Informed | Informed | Informed |

### Accountability Principles

**No accountability without auditability.** A model that cannot be audited cannot be held
accountable. If a model's outputs cannot be examined, traced, and evaluated against its
stated purpose, it should not be deployed in a consequential context.

**Accountability follows scope.** The person or team that defines what a model is allowed to do
bears accountability for the consequences of that scope. Scope creep — where a model begins making
decisions outside its original ADR boundary — is an accountability failure.

**Accountability is prospective, not just retrospective.** The checklist, WMD test, and training
data audit are not post-hoc exercises. They are design activities. Accountability governance
begins when the ADR is written, not when something goes wrong.

**Affected parties have standing.** NOC engineers, service desk staff, and (through appropriate
channels) customers affected by AI-driven decisions have standing to raise concerns about
algorithmic accountability. The appeal mechanism exists for them, and its accessibility matters.

---

## References and Further Reading

- **Joy Buolamwini — *Unmasking AI* (2023):** Buolamwini's full account of the coded gaze, bias
  in AI systems, and the case for algorithmic accountability. Essential reading for anyone
  deploying AI in a consequential context.
- **Algorithmic Justice League (AJL):** [https://www.ajl.org/](https://www.ajl.org/) — Buolamwini's
  organisation, providing audit tools, research, and advocacy resources.
- **Cathy O'Neil — *Weapons of Math Destruction* (2016):** The definitive account of how opaque,
  large-scale algorithms cause harm. Chapter 1 (Bomb Parts) and Chapter 8 (Collateral Damage)
  are particularly relevant to infrastructure and public-impact AI.
- **O'Neil Risk Consulting and Algorithmic Auditing (ORCAA):** [https://orcaarisk.com/](https://orcaarisk.com/) — O'Neil's
  auditing practice, with case studies relevant to infrastructure-adjacent AI.
- **NIST AI RMF — Govern and Map functions:** Directly applicable to the accountability framework
  in this document. MAP 5 (Impacts) and GOVERN 6 (Policies and Procedures) are the most relevant.
- **EU AI Act — High-Risk AI Systems (Annex III):** Network infrastructure management systems
  may fall under high-risk classification under the EU AI Act. Legal advice should be sought on
  applicability.
- **ACM FAccT Conference Proceedings:** Annual conference on Fairness, Accountability, and
  Transparency in AI systems. Current research on disaggregated metrics and disparate impact
  assessment.

---

*Algorithmic accountability questions and concerns should be raised with the AI Champion.
Any deployment decision where the pre-deployment checklist cannot be fully completed should
be escalated to the Engineering Lead before proceeding.*
