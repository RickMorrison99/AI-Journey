# Market Concentration — Avoiding AI Lock-In

> **Status:** Living document · Owned by: O&A Engineering Lead + AI Champions  
> **Review cycle:** Quarterly · **Last reviewed:** _see git log_  
> **Applies to:** All team members, architects, and team leads in the O&A programme  
> **Related:** [Responsible AI — Five Risk Dimensions](index.md) · [Environmental](environmental.md)

---

## The Core Rule

> **No single AI vendor dependency for critical workflows. Design for portability from day 1.**

Every AI tool adoption decision in the O&A programme must include a documented exit strategy. If the team cannot answer "how do we replace this vendor in 90 days?" for a critical AI workflow, the dependency is too deep. The answer must exist before the dependency is created, not after the tool has become load-bearing.

---

## The Cloud Lock-In Mistake, Repeating

The 2010s were characterised by a wave of telecom and enterprise technology organisations adopting cloud services with insufficient attention to portability. The pattern was consistent:

1. A cloud service solves a real problem quickly and cheaply.
2. The team integrates deeply: proprietary APIs, proprietary data formats, proprietary orchestration.
3. The service raises prices, changes terms, deprecates features, or is acquired.
4. The exit cost is prohibitive — not because leaving is technically impossible, but because the integration work would take longer and cost more than staying.

The AI market in 2024–2026 is exhibiting the same pattern, with additional risk factors:

**The pace is faster.** Cloud lock-in developed over years. AI tool adoption is happening in months. Teams are building critical workflows on AI tooling before the market has stabilised, before pricing is settled, and before the governance implications are understood.

**The market is more concentrated.** Cloud infrastructure had AWS, Azure, GCP, and a meaningful long tail of alternatives from early in the market's development. Frontier AI models are currently controlled by a very small number of organisations (see below). The alternatives are less mature and less capable, though this is changing rapidly.

**The dependencies are less visible.** A team that depends on AWS S3 knows it. A team that has built prompt workflows, fine-tuned behaviours, and tooling integrations around GPT-4's specific output characteristics may not fully recognise the depth of that dependency until they try to move.

Kate Crawford, in _Atlas of AI_ (2021), documents the structural concentration of AI infrastructure and the ways in which the "democratising" framing of AI tools obscures a profound centralisation of capability and power. The O&A team's tool choices are made in this political-economic context, and they are not neutral.

---

## The Current AI Market Landscape

As of this document's last review, the frontier AI model market is dominated by a small number of organisations. The team should review and update this section quarterly, as the market is evolving rapidly.

### Tier 1 — Frontier Model Providers

| Organisation | Key Models | Distribution | Notes |
|---|---|---|---|
| **OpenAI / Microsoft** | GPT-4o, GPT-4o-mini, o1 series | Azure OpenAI Service, api.openai.com | Microsoft integration into GitHub Copilot, Azure, Office 365 creates platform-level dependency risk |
| **Google DeepMind** | Gemini 1.5 Pro, Gemini 1.5 Flash, Gemini 2.0 | Vertex AI, Google AI Studio | Deep GCP integration; competitive with OpenAI at frontier tier |
| **Anthropic** | Claude 3.5 Sonnet, Claude 3 Opus, Claude 3 Haiku | AWS Bedrock, api.anthropic.com | Significant Amazon investment; available through AWS creates AWS ecosystem dependency |
| **Meta** | Llama 3.1, Llama 3.2, Llama 3.3 | Self-host, via Ollama, Groq, etc. | Open weights — the most significant counterweight to commercial lock-in at model level |
| **Mistral AI** | Mistral Large, Mixtral, Codestral | api.mistral.ai, self-host | EU-based; open weights for smaller models; relevant for GDPR-sensitive deployments |

### Tier 2 — Inference Infrastructure (additional concentration layer)

Even when using open-weight models, inference infrastructure creates a second layer of concentration:

| Provider | Models Hosted | Notes |
|---|---|---|
| **AWS Bedrock** | Claude, Llama 2/3, Mistral, Titan | Amazon provides the layer between team and model; changes Bedrock's model availability |
| **Azure OpenAI** | GPT-4 family, o1 family | Microsoft controls availability, versioning, and deprecation of models on their platform |
| **Google Vertex AI** | Gemini, Llama 2/3, Claude | Google provides the layer; regional availability varies |
| **Groq** | Llama 3, Mixtral (via LPU hardware) | Faster inference; proprietary hardware creates its own dependency |
| **OpenRouter** | Multi-model routing | Aggregator layer — reduces model vendor lock-in but creates aggregator dependency |
| **Ollama (self-hosted)** | Any GGUF-compatible model | Eliminates cloud inference dependency; O&A-recommended for eligible tasks |

The implication: using "open" model weights via a managed inference service still creates an infrastructure provider dependency. True portability requires self-hosted inference or use of multiple providers.

---

## Risk Taxonomy

The following taxonomy describes the specific risks of single-vendor AI dependency. For each risk, an O&A-specific scenario illustrates the concrete impact.

### 1. Pricing Power

**The risk:** Once the team's workflows are deeply integrated with a vendor's API, the vendor can raise inference costs with limited ability for the team to resist.

**Precedent:** OpenAI's pricing has changed multiple times since GPT-4's launch. GPT-4 was initially priced at $0.06/1K tokens (input); subsequent changes, tier changes, and model versioning have created a complex pricing landscape. Azure OpenAI pricing for enterprise agreements includes commitments and usage tiers that create switching costs.

**O&A scenario:** The team builds the CI/CD pipeline AI code review tooling around GPT-4o. 18 months later, the tool is load-bearing. When the provider raises enterprise tier pricing by 40%, the "switch to an alternative" option requires rewriting prompt templates, re-evaluating output quality, and retraining team members — the true exit cost becomes visible.

**Mitigation:** Abstraction layer + cost monitoring from sprint 1 + exit criteria in ADR.

---

### 2. Capability Gating

**The risk:** Features the team relies on are placed behind higher enterprise tiers, or capabilities are modified in a way that breaks existing workflows.

**O&A scenario:** A specific capability (e.g., function calling behaviour, context window size, system prompt handling) used in the team's agentic NETCONF query tool is changed in a model version update. The tool must be reworked, and the change was not announced in advance.

**Mitigation:** Version-pin API model identifiers (e.g., `gpt-4o-2024-05-13` not `gpt-4o`). Monitor deprecation notices. Test against new model versions in a non-production environment before upgrading.

---

### 3. Terms Changes

**The risk:** The vendor unilaterally changes its Terms of Service, Data Processing Agreement, or usage policies in ways that affect the team's compliance posture.

**Precedent:** Multiple AI providers have changed their terms regarding:
- Training on user inputs (opt-out mechanisms, defaults, enterprise vs. free tier differences)
- Data residency guarantees
- Acceptable use policies that affect specific use cases
- API access tiers and rate limits

**O&A scenario:** The team's enterprise LLM agreement undergoes a terms change that expands the vendor's data retention period. This may trigger a re-evaluation of what data tier (Tier 2) is permitted on that instance — potentially restricting usage overnight.

**Mitigation:** Annual contractual review (see [Privacy](privacy.md)); change monitoring on DPA and ToS; legal/compliance escalation path documented.

---

### 4. Geopolitical Risk

**The risk:** US export control policy, cross-border data restriction legislation, or geopolitical events affect access to AI services or the legality of using them.

**Current risk factors:**
- US export controls on AI chips and (potentially) AI models affecting non-US entities
- EU AI Act requirements that may restrict certain uses or require specific audit capabilities
- UK-US data sharing agreements and their effect on data residency
- Potential restrictions on US-headquartered AI services in specific markets where O&A operates or provides services

**O&A scenario:** O&A provides services to customers in a jurisdiction that introduces restrictions on using US-hosted AI services for processing data about its citizens' telecommunications. The team's AI-assisted network operations tooling needs to be replaceable with a non-US-hosted alternative quickly.

**Mitigation:** OSS model alternatives (see below); EU-headquartered AI providers (Mistral AI); self-hosted models for critical workflows; ADR exit criteria includes geopolitical scenario.

---

### 5. Deprecation

**The risk:** Models the team has built workflows around are deprecated by the vendor, requiring migration.

**Precedent:** OpenAI deprecated GPT-3.5-turbo-0301 and GPT-3.5-turbo-0613, forcing users onto newer (and differently-behaving) models. The GPT-4-0314 and GPT-4-0613 versions were deprecated. Each deprecation requires teams to re-evaluate output quality and adjust prompts.

**O&A scenario:** The model version used for the team's YANG lint helper is deprecated. The replacement model has different output formatting behaviour, causing the parser that extracts structured lint results to break. This is discovered in production when an team member's PR fails with a confusing error.

**Mitigation:** Version-pin all production API calls. Set up deprecation notice monitoring (vendor email lists, changelog RSS). Test replacement model versions before the deadline. Abstract behind a versioned internal interface.

---

## Portability Strategies

### Strategy 1 — Prefer OpenAI API-Compatible Interfaces

The OpenAI API has emerged as a de facto standard interface for LLM inference. Many tools, frameworks, and providers support it:

- **Ollama** — local model runtime, exposes OpenAI-compatible endpoint at `http://localhost:11434/v1`
- **Azure OpenAI** — uses the OpenAI API with a different base URL and authentication
- **OpenRouter** — aggregates multiple providers behind OpenAI-compatible API
- **vLLM** — self-hosted inference server with OpenAI-compatible API
- **Anthropic** — does *not* use OpenAI API format natively, but many wrappers provide compatibility

When evaluating AI tools for the O&A programme, preference OpenAI API-compatible tools. Non-compatible tools require a stronger justification (capability gap that cannot be filled by a compatible alternative).

---

### Strategy 2 — Abstract AI Calls Behind an Internal Adapter

All AI API calls in O&A automation code go through an internal adapter interface. This is the single most important portability practice — it means that swapping the underlying model or provider is a one-line configuration change, not a codebase refactor.

```python
# noa_ai/llm_client.py — The internal adapter

from abc import ABC, abstractmethod
from dataclasses import dataclass
from typing import Optional
import openai
import os


@dataclass
class LLMConfig:
    base_url: str
    api_key: str
    model: str
    max_tokens: int = 2048
    temperature: float = 0.1  # Low temperature for code/config tasks


class LLMClient(ABC):
    """Internal adapter for LLM calls. All O&A automation code uses this interface.
    Never call an LLM provider's API directly from business logic."""

    @abstractmethod
    def complete(self, system_prompt: str, user_prompt: str) -> str:
        ...


class OpenAICompatibleClient(LLMClient):
    """Supports OpenAI, Azure OpenAI, Ollama, OpenRouter, vLLM, and any
    OpenAI API-compatible provider. Change LLMConfig to switch provider."""

    def __init__(self, config: LLMConfig):
        self._client = openai.OpenAI(
            base_url=config.base_url,
            api_key=config.api_key,
        )
        self._config = config

    def complete(self, system_prompt: str, user_prompt: str) -> str:
        response = self._client.chat.completions.create(
            model=self._config.model,
            messages=[
                {"role": "system", "content": system_prompt},
                {"role": "user", "content": user_prompt},
            ],
            max_tokens=self._config.max_tokens,
            temperature=self._config.temperature,
        )
        return response.choices[0].message.content


# Configuration loaded from environment — not hardcoded
def get_llm_client() -> LLMClient:
    config = LLMConfig(
        base_url=os.environ["O&A_LLM_BASE_URL"],      # e.g., https://api.openai.com/v1
        api_key=os.environ["O&A_LLM_API_KEY"],         # or AZURE_OPENAI_API_KEY
        model=os.environ["O&A_LLM_MODEL"],             # e.g., gpt-4o-2024-05-13
    )
    return OpenAICompatibleClient(config)
```

**Switching providers is then purely configuration:**

```bash
# Using OpenAI
export O&A_LLM_BASE_URL="https://api.openai.com/v1"
export O&A_LLM_MODEL="gpt-4o-2024-05-13"

# Switching to local Ollama
export O&A_LLM_BASE_URL="http://localhost:11434/v1"
export O&A_LLM_MODEL="codellama:13b"

# Switching to Azure OpenAI
export O&A_LLM_BASE_URL="https://<resource>.openai.azure.com/openai/deployments/<deployment>/v1"
export O&A_LLM_MODEL="gpt-4o"
```

---

### Strategy 3 — Model-Agnostic Prompt Templates

Prompts written with strong assumptions about a specific model's behaviour create portability problems. Design prompts for portability:

**Principles for portable prompt design:**

1. **Be explicit, not conversational.** Prompts that rely on a model's specific training to "understand" unstated context fail on other models. State the context explicitly.

2. **Specify output format precisely.** Do not rely on a model's default formatting behaviour. If you need JSON, say "Return your response as a JSON object with keys X, Y, Z — nothing else."

3. **Avoid model-specific system prompt features.** Some models have specific tokens or formatting conventions. Avoid these in shared templates.

4. **Test on at least two models.** Before a prompt template is used in production automation, test it on the primary model and on at least one alternative (e.g., the local Ollama fallback). This catches model-specific dependencies early.

```python
# Example: portable YANG lint prompt template
YANG_LINT_PROMPT = """You are a YANG module validator for network automation.

Given a YANG module, identify issues with:
1. Missing mandatory statements (description, reference, revision)
2. Insecure default values (authentication disabled, legacy protocols)
3. Missing input validation constraints (range, pattern, length)
4. Structural problems (missing key statements, incorrect cardinality)

Return your response as a JSON object with this exact structure:
{
  "issues": [
    {
      "severity": "error|warning|info",
      "line": <line_number_or_null>,
      "rule": "<short_rule_identifier>",
      "message": "<human_readable_description>"
    }
  ],
  "summary": "<one_sentence_summary>"
}

Return only the JSON object. No additional explanation.

YANG module to review:
{yang_content}
"""
```

This prompt works identically on GPT-4o, Claude 3.5 Sonnet, Mistral Large, and local CodeLlama — because it specifies format explicitly and makes no assumptions about the model's default behaviour.

---

## OSS Model Alternatives for O&A Use Cases

The following open-source or open-weight models are evaluated alternatives to commercial frontier models for O&A-specific tasks. Evaluate these during the quarterly vendor concentration review.

### Code and Network Automation

| Model | Size | Licence | O&A Relevance | Self-Host Options |
|---|---|---|---|---|
| **Granite Code 8B / 20B / 34B** | 8B–34B | Apache 2.0 | IBM's code model, specifically designed for enterprise/infrastructure code. Telecom-friendly licensing (no usage restrictions). Strong on Python, Go, YAML. | Ollama, vLLM |
| **CodeLlama 7B / 13B / 34B** | 7B–34B | Llama 2 Community (commercial use allowed) | Meta's code-focused model. Strong on Python and code explanation. 34B competes with mid-tier commercial models on many coding tasks. | Ollama, vLLM |
| **DeepSeek Coder 7B / 33B** | 7B–33B | DeepSeek (commercial use allowed) | Strong code completion and generation. Particularly good at Python and structured data formats (YAML, JSON). | Ollama, vLLM |
| **Qwen 2.5 Coder 7B / 14B / 32B** | 7B–32B | Apache 2.0 | Strong code model from Alibaba Research. Apache 2.0 licence removes usage ambiguity. | Ollama, vLLM |
| **Starcoder2 7B / 15B** | 7B–15B | BigCode OpenRAIL-M | Trained on The Stack v2. Strong code completion across many languages. | Ollama, vLLM |

### General Purpose (for O&A reasoning tasks)

| Model | Size | Licence | Notes |
|---|---|---|---|
| **Llama 3.1 8B / 70B / 405B** | 8B–405B | Llama 3 Community (commercial use allowed) | Meta's strongest general model. 70B competes with GPT-4 class for many tasks. 8B suitable for most O&A boilerplate and documentation tasks. |
| **Llama 3.2 3B / 11B** | 3B–11B | Llama 3 Community | Smaller, multimodal. 3B is the recommended minimum for local deployment. |
| **Mistral 7B / Mixtral 8×7B / Mistral Large** | 7B–46B (MoE) | Apache 2.0 (7B, Mixtral), proprietary (Mistral Large) | EU-based. Apache 2.0 licensing for smaller models. Mixtral 8×7B is competitive with GPT-3.5 class at lower cost. |
| **Phi-3 Medium / Phi-3.5 Mini** | 3.8B–14B | MIT | Microsoft Research. Surprisingly capable small models. MIT licence is the most permissive available. |

### YANG and Network Domain — Emerging

| Source | Status | Notes |
|---|---|---|
| **TM Forum AI/ML working groups** | Active — monitor | TM Forum is working on domain-specific AI guidance for telecoms. Watch for model recommendations or fine-tuning data sets. |
| **ETSI ENI (Experiential Networked Intelligence)** | Active — monitor | ETSI ISG ENI is standardising AI-based network management. Watch for model or dataset recommendations. |
| **OpenConfig + YANG-specific fine-tuning** | Community — monitor | Community fine-tuning efforts for YANG-specific tasks using public RFC and OpenConfig training data. No production-ready model as of this writing. |

*This table is reviewed and updated quarterly. Add models to evaluation backlog via the standard ADR process.*

---

## ADR Requirement for AI Tool Adoption

**Every AI tool adoption decision must have an Architecture Decision Record (ADR) that includes documented exit criteria.**

This is not optional. AI tools that are adopted without ADRs are removed from the approved tooling registry at the next quarterly review.

### Minimum ADR Content for AI Tool Adoption

```markdown
# ADR-XXX: Adoption of [Tool Name] for [Use Case]

## Status
Proposed | Accepted | Deprecated | Superseded

## Context
[What problem does this tool solve? Why now? What alternatives were considered?]

## Decision
[What tool, from which vendor, for what purpose?]

## Consequences

### Positive
[What does the team gain?]

### Negative
[What constraints, costs, or risks does this create?]

## Lock-In Assessment

**Vendor:** [Vendor name and parent company]
**API standard:** [OpenAI-compatible / Proprietary / Other]
**Data residency:** [Region, contractual guarantee]
**Abstraction layer:** [How are calls to this tool abstracted? Link to adapter code.]
**Prompt portability:** [Are prompt templates model-agnostic? Tested on alternatives?]

## Exit Criteria

**Trigger conditions for exit:**
- [ ] Pricing increases > X% above current baseline
- [ ] Terms change affecting data residency or training on inputs
- [ ] Deprecation of model version in use with < 60 days notice
- [ ] Availability SLA drops below Y% for > Z consecutive days
- [ ] Geopolitical/regulatory restriction affecting use in O&A's operational jurisdictions
- [ ] A comparable OSS/self-hostable alternative reaches sufficient capability (define threshold)

**Exit timeline target:** [How quickly must the team be able to exit? Recommended: 90 days]

**Exit procedure:**
1. [Specific steps to migrate to alternative]
2. [Alternative tool/provider identified]
3. [Estimated effort to complete migration]

## Review Date
[Quarterly — next review: YYYY-QX]
```

---

## Vendor Concentration Index

The team measures and reports a **vendor concentration index** quarterly. This is a simple metric: the proportion of critical AI-assisted workflow minutes (or token volume) attributable to each vendor.

### Calculation

```
For each AI vendor (V):
  Concentration_V = (tokens from V) / (total tokens across all vendors) × 100

Herfindahl-Hirschman Index (HHI) = Σ (Concentration_V)²

Interpretation:
  HHI < 2500:  Low concentration — acceptable
  HHI 2500–5000: Moderate concentration — monitor and plan diversification
  HHI > 5000:  High concentration — active diversification required
```

**Example:**

| Vendor | Token % | HHI Contribution |
|---|---|---|
| OpenAI (via Azure) | 60% | 3600 |
| Ollama (local) | 30% | 900 |
| Mistral API | 10% | 100 |
| **Total HHI** | | **4600** |

A score of 4600 is in the "moderate — monitor" range. The AI Champion reports this metric quarterly and flags if HHI exceeds 5000.

---

## References and Further Reading

### Thought Leadership
- **Kate Crawford — _Atlas of AI: Power, Politics, and the Planetary Costs of Artificial Intelligence_ (2021, Yale University Press):** The essential text for understanding the structural concentration of AI infrastructure and its political-economic implications. Chapter 2 (on cloud infrastructure) and the Conclusion (on power concentration) are directly applicable to the market concentration risk dimension. Crawford's argument that "AI is neither artificial nor intelligent" reframes the team's relationship with these tools.
- **Kate Crawford — "Time to regulate AI that interprets human emotions" (Nature, 2021):** Crawford on structural power in AI systems.

### Platform and Architecture Thinking
- **Gregor Hohpe — _The Software Architect Elevator_ (O'Reilly, 2020):** Hohpe's analysis of platform dependencies and the "golden cage" of proprietary platform integration is directly applicable to AI tool adoption. The lock-in anti-patterns Hohpe describes for enterprise software platforms are repeating verbatim in AI tooling.
- **Gregor Hohpe — "The Architect's Path" and platform thinking articles** (architectelevator.com): Hohpe's writing on avoiding vendor lock-in through abstraction and portability-first design.

### Standards and Policy
- **EU AI Act (2024):** The EU AI Act introduces requirements for "high-risk" AI systems, transparency, and data governance. Telecom AI systems may be classified as high-risk under Annex III. Portability and documentation requirements in this section support AI Act compliance preparation.
- **NIST AI RMF — GOVERN 6.2:** Addresses organizational AI risk governance including vendor and supply chain risk — directly applicable to the vendor concentration risk described here.
- **TM Forum Open Digital Architecture (ODA):** TM Forum's open architecture principles include vendor neutrality and interoperability. AI tool adoption should align with ODA principles.

### Market Analysis
- **"On the Opportunities and Risks of Foundation Models" (Bommasani et al., Stanford CRFM, 2021):** The foundational paper on foundation model risks, including the homogenisation risk (everyone depending on the same few models creating systemic fragility) directly applicable to the market concentration concern.

---

*The vendor concentration index and all AI tool ADRs are reviewed at the quarterly responsible AI governance meeting. Any AI tool adoption that has not completed an ADR is flagged as a governance risk at that meeting.*
