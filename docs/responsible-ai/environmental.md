# Environmental Costs — Carbon-Aware AI Usage

> **Status:** Living document · Owned by: O&A Engineering Lead + AI Champions  
> **Review cycle:** Quarterly · **Last reviewed:** _see git log_  
> **Applies to:** All team members, architects, and team leads in the O&A programme  
> **Related:** [Responsible AI — Five Risk Dimensions](index.md) · [Market Concentration](market-concentration.md)

---

## The Core Rule

> **Model choice is an energy and carbon decision. Right-size to the task. Track Software Carbon Intensity (SCI) from sprint 1.**

The environmental cost of AI inference is not a rounding error. It is a measurable, real-world impact that a team of 20 team members can influence through deliberate model selection. The discipline of measuring and optimising that impact is part of responsible engineering practice — and it is a practice the O&A team adopts from day 1, not deferred to "when we scale."

---

## Why This Matters for a 20-Team Member Team

There is a widespread assumption that individual developer AI usage is too small to measure or influence. This assumption is wrong, and it obscures the aggregate effect.

### The Scale of the Problem

A frontier model like GPT-4 (or equivalents at that capability tier) consumes orders of magnitude more energy per token than smaller models:

- A frontier model inference call may consume **~0.001–0.01 kWh per 1,000 tokens**, depending on the provider's infrastructure and load.
- A small local model (7B–13B parameter) running on a developer workstation or small GPU server may consume **~0.00001–0.0001 kWh per 1,000 tokens** — 10–100x less.
- The gap widens further when training is considered, but even inference at scale is significant.

For a team of 20 team members using AI assistance actively:

- **Assumption:** 20 team members, each submitting ~50 requests/day averaging 2,000 tokens (prompt + completion), 200 working days/year.
- **Volume:** 20 × 50 × 2,000 × 200 = **400,000,000 tokens/year** = 400M tokens
- **Frontier model energy estimate:** 400M tokens × 0.005 kWh/1,000 tokens = **2,000 kWh/year**
- **At UK grid average (~200 gCO₂e/kWh):** approximately **400 kg CO₂e/year** from inference alone
- **If using local models (10x more efficient):** approximately **40 kg CO₂e/year**

The 360 kg CO₂e difference is not decisive in isolation — but it represents the O&A team's *controllable* contribution. It is also directionally significant: if the broader telecom industry follows O&A's practices, the aggregate impact scales with adoption.

Additionally, the **embodied carbon** of the hardware running frontier models — the manufacturing energy for data centre GPUs — is substantial and is allocated across the users of those models. Reducing inference demand reduces the demand signal for manufacturing more inference hardware.

Anne Currie (Green Software Foundation) frames this precisely: *"Every API call is a vote for a particular infrastructure investment."* The team's model choices shape what gets built next.

---

## SCI — Software Carbon Intensity

The **Software Carbon Intensity (SCI)** metric, defined by the Green Software Foundation's SCI Specification, provides a standardised way to measure the carbon impact of software.

### The Formula

```
SCI = (E × I) + M
      ─────────────
            R
```

Where:

| Symbol | Meaning |
|---|---|
| **E** | Energy consumed by the software component (kWh) |
| **I** | Location-based marginal carbon intensity of the grid at the time of consumption (gCO₂e/kWh) |
| **M** | Embodied carbon: the carbon cost of manufacturing, transporting, and eventually disposing of the hardware running the software |
| **R** | Functional unit — the unit by which the score is normalised, enabling comparison over time |

### Applying SCI to AI Tool Usage

**Functional unit for O&A AI usage:** *per team member per sprint*

This normalisation makes the metric comparable across sprints of different lengths, team size changes, and changes in AI tool adoption depth.

**Component 1: Energy (E)**

For cloud-hosted LLM providers, direct energy measurement is not available. Use estimation:

```
E_ai = (tokens_submitted + tokens_received) × energy_per_1000_tokens
```

| Model tier | Estimated energy (kWh per 1,000 tokens) | Notes |
|---|---|---|
| Frontier (GPT-4 class, Claude 3 Opus class) | 0.003 – 0.010 | Wide range; use 0.005 as working estimate |
| Mid-tier (GPT-4o, Claude 3 Sonnet, Mistral Large) | 0.001 – 0.003 | Use 0.002 as working estimate |
| Small cloud (GPT-4o-mini, Claude 3 Haiku, Mistral 7B via API) | 0.0002 – 0.001 | Use 0.0005 as working estimate |
| Local (Ollama + Llama 3.1 8B, CodeLlama 7B, Granite 3B, on developer hardware) | 0.00005 – 0.0002 | Highly variable by hardware; measure directly if possible |

*These are estimates based on published research (Luccioni et al. 2023, Patterson et al. 2021) and Green Software Foundation tooling. Refine as better data becomes available.*

**Component 2: Carbon Intensity (I)**

Use the **marginal** carbon intensity of the grid where inference occurs — not the average. For cloud providers:

- **US East (Virginia) — typical for OpenAI, Anthropic:** ~300–500 gCO₂e/kWh (PJM grid, high coal/gas mix at peak)
- **EU West (Ireland/Amsterdam) — Azure, GCP EU regions):** ~200–350 gCO₂e/kWh
- **Nordic (GCP Finland, Azure Sweden):** ~50–150 gCO₂e/kWh (high hydro/nuclear)
- **UK:** ~150–250 gCO₂e/kWh (mix, improving)

For teams without access to real-time grid data: use [electricitymap.org](https://electricitymap.org) (free tier available) to get a working estimate for the region of your primary LLM provider's data centre.

**Component 3: Embodied Carbon (M)**

For cloud-hosted inference, approximate M per team member per sprint at approximately **10–20%** of the operational energy carbon cost. This reflects the amortised hardware manufacturing carbon allocated to the team's usage fraction.

For self-hosted models: M is more significant relative to E, especially if dedicated GPU hardware is purchased. Use the manufacturer's PCF (Product Carbon Footprint) document divided by the hardware's expected operational lifetime and the team's utilisation fraction.

**Practical Estimation Worksheet**

```
Sprint SCI Estimate (per team member)
===================================
1. Log total tokens used this sprint (from API usage dashboard or AI tool logs):
   - Frontier model tokens:       _______ tokens
   - Mid-tier model tokens:       _______ tokens
   - Small model tokens:          _______ tokens
   - Local model tokens:          _______ tokens

2. Calculate energy:
   E_frontier = (_______ / 1000) × 0.005 = _______ kWh
   E_midtier  = (_______ / 1000) × 0.002 = _______ kWh
   E_small    = (_______ / 1000) × 0.0005 = _______ kWh
   E_local    = (_______ / 1000) × 0.0001 = _______ kWh
   E_total    = _______ kWh

3. Apply carbon intensity (I) for primary provider region:
   Region: _____________  I = _______ gCO₂e/kWh
   Operational carbon = E_total × I = _______ gCO₂e

4. Add embodied carbon (M) = operational carbon × 0.15 = _______ gCO₂e

5. Total = operational + embodied = _______ gCO₂e per team member this sprint

6. SCI = Total / 1 (functional unit is per team member per sprint) = _______ gCO₂e/team member/sprint
```

Track this number each sprint. The trend is more important than the absolute value. A rising SCI without a corresponding increase in productivity is a signal to right-size model choices.

---

## Model Sizing Guide for O&A Tasks

The following guide maps common O&A engineering tasks to the appropriate model tier. This is a **starting point**, not a rigid rule — if a smaller model demonstrably underperforms for your specific task, escalate to the next tier and document why in your PR notes.

### Use Small / Local Models (≤ 13B parameters, or GPT-4o-mini / Claude 3 Haiku equivalent)

These tasks have well-defined, bounded outputs that smaller models handle reliably:

| Task | Suggested Model | Notes |
|---|---|---|
| YANG module boilerplate generation | Granite Code 3B/8B (local), CodeLlama 7B (local) | YANG syntax is structured; small models handle it well once they have a few examples |
| YANG stub from an RFC text | GPT-4o-mini, Granite Code 8B | Extraction task — bounded, structured |
| Jinja2 template generation for interface configs | CodeLlama 7B (local), GPT-4o-mini | Repetitive, pattern-based |
| Unit test scaffolding (pytest, unittest) | Copilot (built-in), GPT-4o-mini | Test scaffolding from function signatures is a pattern-match task |
| Docstring and inline comment generation | Smallest available model | Documentation is highly predictable from code context |
| Variable renaming and code formatting suggestions | Copilot (built-in), local model | Structural, not reasoning-intensive |
| Ansible task boilerplate | CodeLlama 7B (local), GPT-4o-mini | Module documentation is well-represented in training data |
| Converting between NETCONF XML and equivalent JSON/YANG-compatible formats | GPT-4o-mini, local model | Format conversion, well-bounded |
| Writing basic Nornir/Napalm task skeletons | CodeLlama 13B (local), GPT-4o-mini | Pattern-based; framework APIs are well-represented |

### Use Medium Models (GPT-4o, Claude 3.5 Sonnet, Mistral Large equivalent)

These tasks benefit from stronger reasoning but do not require frontier model capability:

| Task | Suggested Model | Notes |
|---|---|---|
| Debugging complex Python network automation logic | GPT-4o, Claude 3.5 Sonnet | Requires multi-step reasoning across code context |
| Reviewing YANG module design for correctness and interoperability | GPT-4o, Claude 3.5 Sonnet | YANG semantics require nuanced understanding |
| Explaining a multi-step CI/CD pipeline failure | GPT-4o | Diagnostic reasoning across multiple log sources |
| Writing integration tests for NETCONF operations | GPT-4o-mini to GPT-4o | Depends on complexity of the operation being tested |
| Reviewing Ansible playbook logic for idempotency | GPT-4o | Idempotency reasoning requires multi-step analysis |
| Generating complex Jinja2 templates with conditionals and loops | GPT-4o-mini | Often sufficient; escalate to GPT-4o if output quality is poor |
| Translating vendor-specific CLI config to vendor-neutral YANG | GPT-4o | Requires model knowledge of both vendor CLI and YANG data models |

### Use Frontier Models (GPT-4 class, Claude 3 Opus, Gemini 1.5 Pro equivalent)

Reserve these for tasks that demonstrably require their capability. **Document the justification in your PR notes.**

| Task | Suggested Model | Justification Required? |
|---|---|---|
| Complex architectural review (e.g., reviewing an ADR for a new automation platform) | GPT-4 class | Yes — note why GPT-4o was insufficient |
| Incident root cause analysis across multiple complex system interactions | GPT-4 class | Yes |
| Novel YANG augment design for a new network function | GPT-4 class | Often GPT-4o is sufficient — escalate only if needed |
| Multi-vendor interoperability analysis (e.g., BGP policy compatibility) | GPT-4 class | Yes |
| Security review of a complex automation workflow | GPT-4 class | Yes — and note that human review is still mandatory |

**Default escalation path:** Start with local/small. If the output quality is insufficient for your purpose after two attempts with prompt refinement, escalate to the next tier.

---

## Local and On-Premise Model Options

Running models locally eliminates cloud inference costs, reduces privacy surface (Tier 2 data can be used more freely with a local model that has no outbound connectivity), and substantially reduces carbon footprint.

### Ollama — Recommended for Developer Workstations

[Ollama](https://ollama.ai) provides a simple, Docker-compatible local model runtime. It exposes an OpenAI-compatible API endpoint, meaning it works with any tool that supports the OpenAI API (VS Code Copilot alternatives, Continue.dev, Open WebUI, etc.).

```bash
# Install and run a local model
ollama pull codellama:13b
ollama pull granite-code:8b
ollama run codellama:13b

# Ollama exposes OpenAI-compatible API at http://localhost:11434
# Configure your AI tool to use: base_url=http://localhost:11434/v1
```

**Hardware requirements:**

| Model | VRAM Required | CPU-only? | Notes |
|---|---|---|---|
| Llama 3.2 3B | 2–3 GB | Yes (slow) | Smallest useful general model |
| Granite Code 3B | 2–3 GB | Yes (slow) | IBM Granite — strong on code, Apache 2.0 licence |
| CodeLlama 7B | 4–6 GB | Marginal | Good for YANG and Python code tasks |
| Granite Code 8B | 5–7 GB | Marginal | Recommended minimum for O&A code tasks |
| CodeLlama 13B | 8–12 GB | No (too slow) | GPU recommended; strong on complex code |
| Llama 3.1 8B | 5–7 GB | Marginal | Strong general model at this size |

Developers with modern workstations (16 GB RAM, dedicated GPU with 8 GB VRAM) can run 13B models locally with acceptable latency for coding assistance tasks.

### Shared On-Premise Inference Server

For tasks requiring more capable local models (e.g., 34B+ parameter models), consider a shared team inference server:

- **Hardware:** A single GPU server with 2× NVIDIA A100 40GB or 4× RTX 4090 24GB is sufficient for a 20-team member team at typical coding assistance usage levels
- **Software:** [Ollama](https://ollama.ai) or [vLLM](https://vllm.ai) on the server; team members configure their tools to point to the shared endpoint
- **Models:** CodeLlama 34B, DeepSeek Coder 33B, Granite Code 20B
- **Security:** The inference server is on the internal network, not internet-accessible. Tier 2 data can be used with confidence (no external data transmission).
- **Carbon:** One shared GPU server running continuously consumes ~1–3 kWh/day at typical team utilisation — substantially less than routing equivalent load to cloud frontier models.

**ADR required** before procuring shared on-premise inference hardware. Include: model selection rationale, energy consumption estimate, hardware lifecycle and disposal plan.

---

## Carbon-Aware Scheduling

For **non-urgent batch AI tasks** — generating documentation, running analysis across a large codebase, generating test suites for existing code — schedule execution during periods of lower grid carbon intensity.

### What Qualifies as Non-Urgent Batch

- Generating documentation for an entire module
- Running a code quality analysis pass across a sprint's commits
- Generating a comprehensive test suite for a legacy component
- Running a large-scale prompt comparison (evaluating prompt quality)
- Scheduled model fine-tuning (if ever pursued)

### Carbon-Aware Scheduling Tools

- **[electricitymap.org API](https://static.electricitymap.org/api/docs/index.html):** Provides real-time and forecast carbon intensity by grid region. Free tier supports basic usage.
- **[carbon-aware-sdk](https://github.com/Green-Software-Foundation/carbon-aware-sdk):** Green Software Foundation SDK for scheduling jobs during low-carbon windows. Integrates with CI/CD pipelines.
- **UK National Grid ESO:** Publishes 48-hour ahead carbon intensity forecasts via API for UK grid consumers.

### Practical Approach

For most O&A tasks, carbon-aware scheduling means:
1. Check the forecast for the next 24–48 hours before scheduling a large batch job.
2. If there is a window with ≥20% lower carbon intensity than the current period within 24 hours, defer the batch to that window.
3. Do not defer if the task is blocking a sprint ceremony or a production deployment.

This is a low-friction practice: it takes approximately 2 minutes to check the forecast and schedule accordingly, and it reinforces the habit of thinking about computational carbon as a real cost.

---

## Measurement

### Metrics to Track

| Metric | Measurement Method | Frequency |
|---|---|---|
| **Estimated CO₂e per team member per sprint (SCI)** | Per the estimation worksheet above; input data from AI tool API usage logs | Per sprint |
| **Model size distribution** | Percentage of token usage by model tier (frontier / mid / small / local) | Per sprint |
| **SCI trend over time** | Plot SCI over successive sprints; target flat or declining trend as usage matures | Quarterly review |
| **Local model adoption rate** | % of total tokens served by local/on-premise models | Per sprint |
| **Frontier model usage with documented justification** | % of frontier model usage where PR notes include justification | Quarterly |

### Quarterly Reporting

The SCI metric and model distribution data are included in the quarterly stakeholder report alongside DORA metrics. The format is:

```
O&A Responsible AI — Environmental Report — Q[N]
================================================
SCI (gCO₂e/team member/sprint):
  Q[N-2]: ___
  Q[N-1]: ___
  Q[N]:   ___    (trend: ↑ / → / ↓)

Model tier distribution this quarter:
  Frontier:  ___% of tokens
  Mid-tier:  ___% of tokens
  Small:     ___% of tokens
  Local:     ___% of tokens

Total estimated team CO₂e this quarter: ___ kg CO₂e

Notable actions:
  - [Any model downgrades, tooling changes, carbon-aware scheduling events]

Next quarter targets:
  - [Specific, measurable]
```

Including SCI alongside DORA metrics in the stakeholder report serves two purposes: it normalises environmental cost as an engineering concern with equal standing to delivery metrics, and it creates accountability for the trend over time.

---

## References and Further Reading

### Green Software Foundation
- **SCI Specification v1.0:** [https://sci.greensoftware.foundation/](https://sci.greensoftware.foundation/) — The authoritative specification for the SCI metric. Read the full spec — it is concise and directly applicable.
- **Green Software Patterns:** [https://patterns.greensoftware.foundation/](https://patterns.greensoftware.foundation/) — A catalogue of software patterns for reducing carbon impact, including cloud and AI patterns.

### Anne Currie
- **_Building Green Software_ (O'Reilly, 2024)** — Currie, McMahon, Hocking. The most practical book on green software engineering available. Chapter on AI/ML environmental impact is directly applicable to O&A's context. Currie's framing of "every API call is a vote for infrastructure investment" is the team's guiding principle for this dimension.
- **Green Software Foundation — Leadership:** Anne Currie co-founded the GSF and is the primary author of the green software principles framework. Her conference talks (available on YouTube: "Green Software: It's Not What You Think") provide practical context.

### Holly Cummins
- **Cloud carbon footprint work:** Holly Cummins' writing and talks on measuring and reducing cloud software carbon impact provide practical guidance on the estimation techniques used in the SCI worksheet above. Her work emphasises that estimates, even rough ones, are better than ignoring the question.
- **"The Cloud is Not Carbon-Free"** — Cummins' talks on the carbon reality of cloud infrastructure, including the embodied carbon component often omitted from energy-only calculations.

### Academic Research
- **Luccioni, Viguier, Ligozat — "Estimating the Carbon Footprint of BLOOM, a 176B Parameter Language Model" (2023):** The methodology paper behind many of the energy-per-token estimates used in this document.
- **Patterson et al. — "Carbon Emissions and Large Neural Network Training" (Google, 2021):** Foundational paper on the training carbon cost of large language models. The inference vs. training cost comparison is relevant to the team's focus on inference efficiency.
- **Strubell, Ganesh, McCallum — "Energy and Policy Considerations for Deep Learning in NLP" (2019):** The paper that first made the energy cost of NLP training widely visible in the research community.

### Tools
- **[electricitymap.org](https://electricitymap.org):** Real-time and forecast marginal carbon intensity by grid region.
- **[Cloud Carbon Footprint](https://www.cloudcarbonfootprint.org/):** Open-source tool for estimating cloud provider carbon emissions from usage data. Supports AWS, Azure, GCP.
- **[CodeCarbon](https://codecarbon.io/):** Python library for tracking carbon emissions from code execution. Useful for benchmarking local model inference.

---

*Questions about SCI measurement, model selection, or environmental reporting should be directed to the AI Champion. The AI Champion is responsible for collating sprint-level SCI data and producing the quarterly environmental report.*
