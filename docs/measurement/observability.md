# Observability-Driven Development for AI Systems

> **Status:** Living document · Owned by: O&A Engineering Team  
> **Framework:** Charity Majors — Observability Engineering  
> **Applies to:** All AI/ML pipelines deployed or evaluated by O&A  
> **Cross-reference:** `docs/measurement/dora-metrics.md` · `docs/measurement/space-framework.md`

---

## 1. Observability vs. Monitoring

**Monitoring** is the practice of deciding in advance what might go wrong, instrumenting for
those things, and building dashboards to watch them. Monitoring is predictive: you know the
failure mode you're watching for, and you build a threshold or alert to catch it.

**Observability** is different. Charity Majors' definition: *a system is observable if you can
understand its current state by examining its outputs — events, traces, logs — without deploying
new instrumentation*. Observability is exploratory: you can ask any question about system state
after the fact, including questions you didn't think to ask at design time.

For conventional software, monitoring is often sufficient. The failure modes are known: service
down, latency spike, error rate breach. Dashboards catch them.

For AI systems in production, **monitoring is insufficient**. AI failures are often novel,
gradual, and invisible to threshold-based alerting:

- A model's output quality degrades by 3% per month — no threshold breaches, but consistent
  quality loss
- A prompt template change causes subtle semantic drift that affects one category of inputs —
  no errors logged, but wrong outputs produced
- An API provider silently updates the model version — behaviour changes without a deployment
  event in your own system
- Context window saturation causes input truncation — the model responds successfully, but to
  a shorter, different question than you asked

Monitoring tells you *that* something is wrong when it crosses a threshold. Observability lets
you understand *what* is wrong and *why*, including in cases where no threshold was breached.

### The Implications for O&A

O&A operates AI pipelines in a complex, high-stakes environment: network automation, YANG
model generation, NETCONF operations, fault classification. The failure modes in this environment
include:

- AI-generated NETCONF operations that are syntactically valid but semantically incorrect for
  a specific device configuration
- Fault classification models that degrade on a new NOS version that was not in the training
  data
- AI-assisted YANG stubs that were accepted during a period when the model was performing well
  but whose quality has since drifted

None of these failure modes have obvious thresholds. All of them require the ability to ask
retrospective questions about AI pipeline behaviour — which is the definition of observability.

---

## 2. Why AI Pipelines Need Observability

### AI-Specific Failure Modes That Monitoring Misses

#### Prompt Drift

Prompt templates evolve over time. Version 1.4 of a prompt template may produce subtly different
outputs than version 1.2, particularly when the model version also changes. Without structured
event logging that captures prompt template version per request, there is no way to correlate
output quality changes with prompt changes retrospectively.

Prompt drift is not an error — no exception is raised, no threshold is breached. It manifests
as gradually changing output characteristics that are only detectable by comparing outputs
across prompt template versions at scale.

#### Context Window Saturation

AI models have a maximum context window. When input exceeds this limit, one of two things
happens: the request fails (detectable), or the pipeline silently truncates the input before
sending it to the model (not detectable without explicit logging).

Silent truncation is the more dangerous case. The model receives a shorter version of the
input, produces a response to that shorter input, and the pipeline records a successful
completion. Without logging the input token count per request, context window saturation is
invisible.

#### Model Version Changes

API providers (including enterprise-grade providers) update model versions, sometimes without
explicit versioning in the API response. A YANG stub generation pipeline that called
`granite-code-8b` in November 2024 may be calling a different model in March 2025 if the
provider has updated the endpoint. Without logging the model version per request, this change
is undetectable.

Model version changes may improve or degrade output quality. Either way, they are a change
that should be observable in your system's event stream.

#### Hallucination Clustering

AI hallucinations — factually incorrect or invented outputs — are not uniformly distributed
across input space. They tend to cluster around specific input characteristics: unfamiliar
device types, edge-case YANG patterns, NOS versions with limited training data coverage.

Aggregate hallucination rates (if measured at all) mask this clustering. Observability — with
high-cardinality event fields — lets you ask: "For which input characteristics is the
rejection rate highest?" and "Are the inputs where humans most frequently override the AI
concentrated in a specific domain?"

---

## 3. High-Cardinality Events for O&A AI Pipelines

### Majors' Key Concept: High-Cardinality Fields

Majors' observability framework centres on **high-cardinality fields**: event attributes that
can take many distinct values (user ID, request ID, session ID, specific input characteristics).
High-cardinality fields are what make observability powerful. They allow you to slice event data
by any combination of attributes and ask arbitrary questions about system behaviour.

Traditional monitoring discards high-cardinality data because it's expensive to pre-aggregate.
Observability preserves it, so you can answer questions you didn't anticipate at instrumentation
time.

For O&A AI pipelines, high-cardinality fields include: `pipeline_id`, `model_version`,
`prompt_template_version`, `input_type`, `target_device_type`, `nos_version`. These are the
fields that let you ask: "Did output quality change after the model version was updated?" or
"Is the rejection rate higher for a specific device type?"

### Structured Event Schema for O&A AI Operations

Every O&A AI pipeline invocation must emit a structured event conforming to this schema:

```json
{
  "timestamp": "ISO8601",
  "pipeline_id": "yang-stub-gen-v2",
  "model": "granite-code-8b",
  "model_version": "2024-11-01",
  "input_type": "yang_module",
  "input_size_tokens": 1847,
  "output_size_tokens": 412,
  "latency_ms": 3200,
  "prompt_template_version": "v1.4",
  "completion_status": "success|truncated|error",
  "human_reviewed": true,
  "review_outcome": "accepted|modified|rejected",
  "modification_category": "correctness|style|safety|null",
  "sci_energy_wh": 0.0024,
  "triggered_by": "ci|manual|scheduled"
}
```

### Field Definitions and Rationale

| Field | Type | Rationale |
|---|---|---|
| `timestamp` | ISO 8601 string | Enables time-series analysis and correlation with operational events |
| `pipeline_id` | string | Identifies which AI pipeline produced the event; enables per-pipeline analysis |
| `model` | string | The model identifier as sent to the API |
| `model_version` | string | The model version as returned in the API response; detects silent model updates |
| `input_type` | enum | What kind of input was provided; enables disaggregation by input category |
| `input_size_tokens` | integer | Enables context window saturation detection and cost analysis |
| `output_size_tokens` | integer | Enables output length trend analysis and truncation detection |
| `latency_ms` | integer | Primary latency signal; enables p50/p95/p99 calculation per pipeline |
| `prompt_template_version` | string | Enables correlation of output quality changes with prompt changes |
| `completion_status` | enum | Distinguishes successful completions from truncated and error cases |
| `human_reviewed` | boolean | Tracks whether this output was subject to human review |
| `review_outcome` | enum | The result of human review; the primary AI quality signal |
| `modification_category` | enum | If modified, categorises why; surfaces systematic quality issues |
| `sci_energy_wh` | float | Software Carbon Intensity energy measurement; feeds environmental reporting |
| `triggered_by` | enum | Pipeline invocation context; enables comparison of CI vs. manual vs. scheduled quality |

### Schema Extension for Network Operations

For AI pipelines that produce NETCONF operations or network configuration changes, extend the
schema with:

```json
{
  "target_device_type": "nokia-sr-os",
  "nos_version": "23.10.R1",
  "yang_model_coverage": "full|partial|none",
  "validation_result": "passed|failed|skipped",
  "deployment_outcome": "deployed|rolled_back|pending|not_deployed"
}
```

---

## 4. The Four Signals for AI Systems

Google's SRE golden signals — latency, traffic, errors, saturation — provide a foundation for
service observability. For AI systems, these signals must be extended to capture AI-specific
quality dimensions.

### Signal 1: Latency

Track p50, p95, and p99 latency **per pipeline** and **per model**. Aggregate latency figures
hide per-pipeline degradation.

Key questions latency data should answer:
- Is p99 latency within the operational budget for this pipeline?
- Has latency changed following a model version update?
- Is latency consistent across triggered-by contexts (CI vs. manual vs. scheduled)?

**Alert condition:** p99 latency exceeds 2× baseline for a given pipeline over a rolling
24-hour window.

### Signal 2: Acceptance Rate

The proportion of AI outputs that are used without modification by the human reviewer.

```
acceptance_rate = count(review_outcome == "accepted") / count(human_reviewed == true)
```

Acceptance rate is the primary signal for AI output quality. A declining acceptance rate
indicates degrading model performance, prompt drift, or scope creep (the AI is being asked to
do things it was not designed to do).

Track acceptance rate **per pipeline**, **per model version**, and **per prompt template
version**. This is the high-cardinality disaggregation that makes the signal meaningful.

### Signal 3: Intervention Rate

The proportion of AI outputs that require human modification or rejection.

```
intervention_rate = count(review_outcome in ["modified", "rejected"]) / count(human_reviewed == true)
```

**Critical note from Forsgren's SPACE framework:** The intervention rate must **never** be used
as a productivity metric for individual engineers. An engineer who frequently modifies AI
output may be doing so because they are working on genuinely difficult problems, or because
they are applying higher quality standards. Using intervention rate as a proxy for productivity
would create an incentive to accept low-quality AI output, which is the opposite of the
intended effect.

Intervention rate is a **quality signal for the AI pipeline**, not a performance signal for
the engineer. This distinction must be explicit in any reporting that includes this metric.

### Signal 4: Drift Score

A measure of semantic similarity between AI outputs over time for equivalent or similar inputs.
A stable, high-quality model should produce outputs that are semantically consistent for similar
inputs over time. Declining semantic similarity indicates model version changes, prompt drift,
or distribution shift in the input data.

Drift score calculation options (in order of implementation cost):
1. **Embedding cosine similarity** — embed outputs and compare against a baseline corpus
2. **ROUGE/BLEU scores** — compute n-gram overlap against reference outputs
3. **Human spot-check rate** — periodically sample equivalent inputs and compare outputs
   manually

For O&A's current scale, option 3 (human spot-check) is the minimum viable implementation.
Automate options 1 or 2 as pipeline maturity increases.

**Alert condition:** Drift score drops below threshold following a model version change event.

---

## 5. Observability for AI-Assisted NETCONF and Network Automation

AI-assisted network operations require additional observability dimensions beyond general AI
pipeline monitoring. Network operations are consequential, irreversible (or costly to reverse),
and occur in a safety-critical environment. The observability bar is correspondingly higher.

### NETCONF Operation Logging Requirements

Every AI-suggested NETCONF RPC must log the following before the operation is submitted for
human review:

| Field | Required | Description |
|---|---|---|
| `model` | Yes | Model that generated the RPC |
| `prompt_template_version` | Yes | Prompt template version used for generation |
| `target_device_type` | Yes | Device type the RPC targets |
| `nos_version` | Yes | NOS version of the target device |
| `yang_model_coverage` | Yes | Whether the YANG model for the target device is full, partial, or absent |
| `validation_result` | Yes | Result of YANG schema validation on the generated RPC |
| `deployment_outcome` | Yes | Whether the RPC was ultimately deployed, rolled back, or not deployed |
| `human_reviewed` | Yes | Must be `true` — no AI-generated NETCONF RPC may be deployed without review |
| `review_outcome` | Yes | Whether the reviewed RPC was accepted, modified, or rejected |

This logging requirement applies to all NETCONF operations regardless of whether they are
submitted to production or a lab environment. Lab behaviour is the baseline for production
risk assessment.

### AI-Assisted Config Diff Logging Requirements

Every AI-assisted configuration diff analysis must log:

| Field | Required | Description |
|---|---|---|
| `input_diff_size_lines` | Yes | Size of the diff provided to the AI for analysis |
| `model` | Yes | Model used for analysis |
| `generated_summary` | No | The summary generated (for audit purposes; handle PII/sensitive data appropriately) |
| `summary_used` | Yes | Whether the generated summary was included in the PR description |
| `modification_applied` | Yes | Whether the engineer modified the summary before use |

This data enables retrospective analysis of whether AI-generated summaries accurately
characterise the changes they describe — a quality dimension that is difficult to monitor
through any other mechanism.

---

## 6. Production as the Only True Test

### Majors' Principle

Charity Majors is direct on this point: *you cannot know how a system behaves in production by
testing it in staging*. Production has characteristics that no pre-production environment
faithfully replicates: real traffic patterns, real user behaviour, real failure combinations,
real scale, and the full distribution of real inputs.

For AI pipelines, this principle is even more important. A YANG stub generation pipeline that
produces correct outputs for the 200 test cases in your CI suite may still produce subtly
incorrect outputs for the full distribution of real YANG modules in production — particularly
for edge cases, legacy device types, or NOS versions with limited training data coverage.

**CI catches correctness for known cases. Production observability catches behaviour for
the full input distribution.**

### The O&A Implications

- An AI pipeline that generates valid YANG in CI may still produce semantically incorrect
  models for real device configurations that CI does not cover
- A fault classification model that achieves 94% accuracy on the test set may systematically
  misclassify faults from a specific geographic region that is under-represented in both the
  training and test data
- A prompt template that works well in manual testing may saturate the context window when
  applied to the longest real YANG modules in the production dataset

None of these failures are detectable without production observability. All of them are
detectable with it, if the right events are logged.

### Ship Observability on Day One

The practical corollary: **instrument AI pipelines for observability before they handle
production traffic, not after**. Retrofitting observability onto a production pipeline is
significantly harder than building it in from the start:

- Log schema changes require re-processing historical data
- Gaps in historical data make baseline establishment impossible
- Production incidents that occur before observability is in place cannot be investigated
  retrospectively

Even a simple, low-volume AI pipeline in its first week of production use should emit the
standard event schema. The cost of instrumentation is low; the cost of missing the data from
the first few weeks of production behaviour is high.

---

## 7. Connecting to DORA and SPACE

### DORA Change Failure Rate

AI-generated changes that require rollback should be tracked as a **separate cohort** within
the DORA Change Failure Rate metric. This is not to penalise AI use — it is to calibrate
confidence in AI pipeline output.

If AI-generated NETCONF changes have a higher rollback rate than human-authored changes, that
is a signal that the AI pipeline needs additional validation gates, not that AI should be
abandoned. The data enables the right response; without the data, the response is guesswork.

**Implementation:** Tag all PRs containing AI-generated network operations with a consistent
label (e.g., `ai-assisted`). DORA metrics tooling should report Change Failure Rate broken
down by this label.

Do not aggregate AI-generated and human-authored changes into a single Change Failure Rate
metric — the aggregate hides the signal.

### SPACE Quality Dimension

Forsgren's SPACE framework includes quality as a key dimension of developer experience and
productivity. For O&A, AI-assisted quality is not self-reported — it is measured directly
through observability data.

The `review_outcome` and `modification_category` fields in the standard event schema are the
source of truth for AI-assisted quality metrics. Self-reported acceptance rates (surveys, team
estimates) are supplementary at best.

**Key principle:** Observability data, not self-reported estimates, is the authoritative source
for AI quality metrics in O&A's measurement framework.

### Cross-References

- For DORA metric definitions and measurement approach: `docs/measurement/dora-metrics.md`
- For SPACE framework application to O&A: `docs/measurement/space-framework.md`
- For the full AI KPI framework, including acceptance rate targets: `docs/measurement/ai-adoption-kpis.md`

---

## 8. O&A Observability Stack Recommendation

### Principles

1. **Don't add a new stack.** Use whatever log aggregation O&A already operates. The value of
   observability comes from the data, not the tooling. Structured JSON logs in an existing ELK
   or Loki instance are vastly preferable to a purpose-built AI observability platform that
   requires a new operational dependency.

2. **Structured JSON from day one.** Unstructured log lines cannot be queried at high cardinality.
   All AI pipeline events must be structured JSON.

3. **One standard schema, many pipelines.** All O&A AI pipelines emit events conforming to the
   schema in Section 3. Divergence from the schema must be justified and documented.

### Minimum Viable Observability Stack

| Component | Recommended | Notes |
|---|---|---|
| **Structured logging** | Python `structlog` | Drop-in replacement for stdlib `logging`; produces structured JSON natively |
| **Log aggregation** | Existing O&A stack (ELK, Loki, Splunk) | Do not introduce a new stack; integrate with what exists |
| **Event schema enforcement** | `ai_event_logger.py` wrapper | Ensures all pipelines emit conformant events without per-pipeline implementation overhead |
| **Dashboards** | Simple queries against existing stack | Acceptance rate, latency percentiles, drift indicators — buildable in Kibana, Grafana, or equivalent |
| **Alerting** | Existing alerting infrastructure | P99 latency breach, acceptance rate drop below threshold, model version change detection |

### `ai_event_logger.py` — Standard Event Logger

The following Python utility wraps any AI pipeline call and emits a conformant structured event.
All O&A AI pipelines should use this wrapper rather than implementing event emission directly.

```python
import time
import structlog
from dataclasses import dataclass, asdict
from typing import Optional
from datetime import datetime, timezone

log = structlog.get_logger()


@dataclass
class AIEvent:
    pipeline_id: str
    model: str
    input_type: str
    triggered_by: str
    model_version: Optional[str] = None
    prompt_template_version: Optional[str] = None
    input_size_tokens: Optional[int] = None
    output_size_tokens: Optional[int] = None
    latency_ms: Optional[int] = None
    completion_status: Optional[str] = None
    human_reviewed: bool = False
    review_outcome: Optional[str] = None
    modification_category: Optional[str] = None
    sci_energy_wh: Optional[float] = None


def emit_ai_event(event: AIEvent) -> None:
    """Emit a structured AI pipeline event conforming to the O&A observability schema."""
    log.info(
        "ai_pipeline_event",
        timestamp=datetime.now(timezone.utc).isoformat(),
        **asdict(event),
    )


class AIEventLogger:
    """Context manager that wraps an AI pipeline call and emits a structured event."""

    def __init__(self, pipeline_id: str, model: str, input_type: str,
                 triggered_by: str = "manual", **kwargs):
        self.event = AIEvent(
            pipeline_id=pipeline_id,
            model=model,
            input_type=input_type,
            triggered_by=triggered_by,
            **kwargs,
        )
        self._start: float = 0.0

    def __enter__(self):
        self._start = time.monotonic()
        return self.event

    def __exit__(self, exc_type, exc_val, exc_tb):
        elapsed_ms = int((time.monotonic() - self._start) * 1000)
        self.event.latency_ms = elapsed_ms
        if exc_type is not None:
            self.event.completion_status = "error"
        elif self.event.completion_status is None:
            self.event.completion_status = "success"
        emit_ai_event(self.event)
        return False  # do not suppress exceptions
```

### Usage Example

```python
from ai_event_logger import AIEventLogger

with AIEventLogger(
    pipeline_id="yang-stub-gen-v2",
    model="granite-code-8b",
    model_version="2024-11-01",
    input_type="yang_module",
    prompt_template_version="v1.4",
    input_size_tokens=len(tokens),
    triggered_by="ci",
) as event:
    result = model_client.generate(prompt)
    event.output_size_tokens = count_tokens(result)

# After human review (update the event or emit a review event):
emit_review_outcome(
    pipeline_id="yang-stub-gen-v2",
    review_outcome="modified",
    modification_category="correctness",
)
```

### What the Stack Does Not Cover

This minimum viable stack does not include:
- **Distributed tracing** — relevant if AI pipelines span multiple services; add when needed
- **Real-time drift detection** — the drift score (Section 4) requires embedding infrastructure;
  implement in Phase 2
- **Model performance regression testing** — automated quality regression against a golden test
  set; implement as pipeline maturity increases

Build these capabilities incrementally. Ship the minimum viable stack first.

---

## References and Further Reading

- **Charity Majors, Liz Fong-Jones, George Miranda — *Observability Engineering* (2022):**
  O'Reilly. The definitive reference for observability practice. Chapters 1–4 (core concepts)
  and Chapter 11 (AI/ML systems) are most directly applicable.
- **Charity Majors — *The Observability Primer* (Honeycomb):**
  [https://www.honeycomb.io/resources/observability-primer](https://www.honeycomb.io/resources/observability-primer) — A concise introduction to
  observability concepts including high-cardinality events.
- **Google SRE Book — Chapter 6 (Monitoring Distributed Systems):**
  [https://sre.google/sre-book/monitoring-distributed-systems/](https://sre.google/sre-book/monitoring-distributed-systems/) — The golden signals and their
  rationale; the foundation that AI-specific signals extend.
- **Nicole Forsgren, Jez Humble, Gene Kim — *Accelerate* (2018):** The DORA metrics framework
  and their connection to software delivery performance.
- **Nicole Forsgren et al. — SPACE Framework (2021):** The framework that contextualises
  intervention rate as a quality signal, not a productivity metric.
- **`structlog` documentation:** [https://www.structlog.org/](https://www.structlog.org/) — The recommended structured logging
  library for O&A AI pipelines.

---

*Questions about AI pipeline observability or the standard event schema should be raised with
the AI Champion. Contributions to `ai_event_logger.py` follow the standard PR process.*
