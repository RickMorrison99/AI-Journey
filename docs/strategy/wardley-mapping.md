# Wardley Mapping for AI Tool Strategy

> "A map is not the territory — but an organisation without a map is navigating blind."
> — adapted from Simon Wardley

---

## 1. Why Maps Before Tools

Most technology strategy fails before the first tool is chosen. Organisations adopt AI capabilities based on:

- **Hype** — a vendor demo, a conference keynote, or a LinkedIn post declares something transformational
- **Inertia** — "we already use Microsoft tooling, so Copilot is the obvious choice"
- **Mimicry** — a competitor announced an AI initiative, so we must have one too

None of these are strategy. They are reactions. And reactions without a map produce one predictable outcome: the wrong tool, applied to the wrong problem, at the wrong time, with the wrong investment model.

Simon Wardley's core insight is disarmingly simple: **you cannot make good strategic decisions without knowing where you are.** A Wardley Map provides that situational awareness. It plots components on two axes — visibility (how close to the user) and evolution (how mature the technology is) — and lets you reason about what to build, what to buy, what to consume, and what to watch.

For O&A (OSS Orchestration and Automation), this matters concretely. Adopting GitHub Copilot is a very different strategic decision than building a custom YANG constraint verification pipeline powered by an LLM:

- **GitHub Copilot** sits in the *Product* stage of evolution — it is repeatable, vendor-supported, off-the-shelf. The strategic move is to *subscribe and exploit*, not to build a competing internal tool.
- **LLM-assisted YANG constraint verification** sits in *Genesis* — there is no established best practice, no off-the-shelf solution, and no guarantee of success. The strategic move is to *explore with small experiments* and accept high waste as the cost of learning.

Conflating these two decisions — treating both as "AI projects" that go through the same procurement and delivery process — is exactly what a map prevents. Without the map, teams either over-invest in commodity tools (building what they should buy) or under-invest in genesis work (dismissing it as too experimental when it is precisely where differentiation lives).

This document provides O&A with:

1. An introduction to the Wardley evolution axis as applied to AI tools
2. A concrete map of O&A's current AI landscape
3. Wardley doctrine translated into O&A-specific guidance
4. A build/buy/consume decision framework
5. Signals for anticipating how the landscape will shift
6. A facilitation guide for mapping sessions within the team

---

## 2. The Evolution Axis

Wardley evolution is not a timeline. It is a description of how a component's characteristics change as it matures from novel experiment to invisible infrastructure. There are four stages.

### Genesis

**Characteristics:** Newly discovered, poorly understood, no established practice, high failure rate, high potential reward. The component exists as a concept or prototype. Nobody knows the right way to use it.

**Strategic posture:** Explore. Run time-boxed experiments. Accept waste. Prioritise learning over delivery. Do not attempt to standardise or industrialise — you do not yet know what you are standardising.

**O&A AI examples:**

- **LLM-assisted YANG constraint verification** — using an LLM to detect logical inconsistencies or missing must-statements in YANG modules before they reach CI. This capability does not yet exist as a product. Nobody has established best practice. O&A could pioneer it, but should do so in an explicit experiment mode.
- **AI-driven network intent translation** — translating high-level network intent (e.g., "ensure latency < 5ms between nodes A and B") into structured NETCONF/RESTCONF payloads via LLM reasoning. Promising but unproven at production scale in telco environments.
- **Autonomous remediation agents** — LLM-backed agents that observe NSO audit logs, classify fault patterns, and propose or apply remediation. Early research exists; production-grade implementations are rare.

### Custom-Built

**Characteristics:** The component is understood well enough to build deliberately, but each implementation is bespoke. There is competitive differentiation in doing it well. Best practices are emerging but not yet standardised. It is not yet available as a product you can simply purchase.

**Strategic posture:** Build with intent. Invest in quality. Document decisions as Architecture Decision Records (ADRs). Consider whether what you build could later be shared or open-sourced — because it will eventually commoditise regardless.

**O&A AI examples:**

- **Custom Ollama pipelines for NSO service templates** — running a self-hosted Ollama instance with a tuned system prompt and retrieval context drawn from O&A's internal YANG modules and NSO service catalogue. Nobody sells this pre-built for your environment. You build it.
- **In-house RAG over internal YANG modules** — a Retrieval Augmented Generation system where the corpus is O&A's own YANG library, change history, and internal documentation. Competitively differentiated because your data is proprietary.
- **Fine-tuned NSO model** — a small language model fine-tuned on O&A's NSO Python service package patterns, for use in code completion or review. Custom because the training data is O&A-specific.

### Product

**Characteristics:** Repeatable, well-understood, available from multiple vendors, widely adopted. The component can be purchased or subscribed to. Building your own equivalent is economically irrational — the R&D cost has already been absorbed by the market.

**Strategic posture:** Buy or subscribe. Evaluate vendors on integration, support, price, and lock-in risk. Do not build. Focus energy on how to *use* the product effectively, not on replicating it.

**O&A AI examples:**

- **GitHub Copilot** — AI-assisted code completion, available as a subscription. Multiple competing products exist (Cursor, Codeium, Tabnine). The right move is to subscribe, instrument adoption, and measure value — not to build an internal equivalent.
- **Claude / GPT-4o APIs** — frontier LLM capabilities available via API. Pay per token. Anthropic, OpenAI, and Google all offer competing products. Treat as a product-stage utility.
- **GitHub Copilot CLI** — AI-assisted terminal and git workflow tooling. Off-the-shelf, subscription-based. Install and use; do not build.
- **LLM-based code review tools** — CodeRabbit, CodiumAI, and similar. Increasingly product-stage.

### Commodity / Utility

**Characteristics:** Undifferentiated, standardised, consumed as infrastructure. Price competes to the floor. No competitive advantage comes from *how* you use it — only from *what* you build on top of it.

**Strategic posture:** Consume as utility. Never build. Treat like electricity: you do not generate your own power to run your servers. Automate provisioning and minimise operational overhead.

**O&A AI examples:**

- **Cloud LLM inference compute** — GPU inference APIs from AWS, GCP, Azure. Commodity cloud infrastructure. Never build your own inference cluster for general use.
- **Tokenisation libraries** — tiktoken, HuggingFace tokenizers. Open-source, standardised. Consume as dependency.
- **Vector database infrastructure** — pgvector, managed Pinecone, Weaviate Cloud. Increasingly commodity. Do not self-host unless data sovereignty demands it.
- **Embedding APIs** — OpenAI text-embedding-3-small, Cohere Embed. Commodity utility. Call the API.

---

## 3. An O&A AI Landscape Map

The following ASCII map positions O&A's current AI components on two axes:

- **Y-axis (vertical):** Visibility — how directly the component surfaces to the team or end-user. High = directly visible (a tool the engineer interacts with). Low = invisible infrastructure.
- **X-axis (horizontal):** Evolution — Genesis → Custom-Built → Product → Commodity

```
  VISIBILITY
  (high)
  │
  │  AI-assisted         Custom YANG ──────────►  GitHub Copilot
  │  network intent      pipeline                 (Product, visible)
  │  [Genesis]           [Custom, visible]
  │
  │
  │                      Prompt libraries ──────► (moving right)
  │                      [Custom → Product]
  │
  │
  │  Fine-tuned          Ollama                   Claude/GPT-4o API
  │  NSO model           self-hosted              [Product, infra]
  │  [Custom, infra]     [Custom, infra]
  │
  │                                               LLM inference
  │                                               compute
  │                                               [Commodity, infra]
  │
  (low)
  └──────────────────────────────────────────────────────────────►
       Genesis          Custom-Built           Product      Commodity
```

### Reading the Map

**Arrows indicate direction of travel.** Everything moves right over time. The prompt libraries node is shown mid-move from Custom toward Product — this is already happening (LangChain Hub, GitHub's prompt marketplaces).

**Vertical clustering reveals dependencies.** The visible tools (GitHub Copilot, Custom YANG pipeline) depend on infrastructure components below them (Claude API, Ollama, LLM inference compute). When the infrastructure commoditises, the visible tool cost drops.

**Genesis nodes require different governance.** AI-assisted network intent and fine-tuned NSO model work should not be subject to the same delivery commitments as GitHub Copilot rollout. They are in different strategic contexts.

---

## 4. Wardley Doctrine for O&A

Wardley's "doctrine" refers to universal good practices that apply regardless of the specific context or industry. They are not rules derived from the map — they are principles that should govern how you operate *across* all stages. Below are the doctrine points most critical to O&A's AI adoption.

### Use Appropriate Methods

**Doctrine:** Apply the management method that fits the evolutionary stage. Genesis work requires Agile/Explore. Custom work can use Agile with some structure. Product/Commodity work benefits from Lean and standardisation.

**O&A application:** Do not run YANG-AI pipeline experiments through the same delivery process as GitHub Copilot onboarding. The former needs a two-week spike and a learning review. The latter needs a licence, a rollout plan, and adoption metrics. Applying heavyweight delivery governance to genesis work kills innovation. Applying informal "we'll figure it out" governance to product rollout produces chaos.

### Remove Duplication and Bias

**Doctrine:** Identify where multiple teams are doing the same thing and consolidate. Bias toward incumbent solutions is a form of cognitive waste.

**O&A application:** If three squad teams are each independently maintaining their own system prompt for NSO service template generation, that is duplication. The platform or enabling team should own a shared prompt library. Individual teams can extend it, but the base should not be reimplemented six times.

### Think Small

**Doctrine:** Large bets in uncertain territory are how organisations lose. Prefer many small experiments over one large programme.

**O&A application:** Do not launch a six-month "AI Transformation Programme" with committed delivery milestones for genesis-stage capabilities. Instead, run four two-week spikes on four different genesis opportunities, measure learning, and invest more in whatever showed signal.

### Move Fast in Genesis

**Doctrine:** In the Genesis stage, the learning *is* the deliverable. Slow exploration is waste, not caution.

**O&A application:** When exploring LLM-assisted network intent translation, the team should run an experiment and review findings within two weeks. Waiting for a full architecture review before starting the experiment inverts the value: you need the experiment to inform the architecture, not the other way around.

### Optimise Flow in Product/Commodity

**Doctrine:** Once a component reaches Product or Commodity, the value comes from throughput and reliability, not from innovation. Optimise the pipeline.

**O&A application:** GitHub Copilot adoption should be instrumented with adoption metrics, integrated into CI/CD review workflows, and streamlined for onboarding. The question is not "should we use it?" (it's a product — the decision is buy/subscribe) but "how do we maximise the team's use of it effectively?"

### Manage Inertia

**Doctrine:** The biggest strategic risk is almost never moving too fast. It is the inertia of existing practices, tools, and mental models that prevents organisations from acting on what the map clearly shows.

**O&A application:** The statement "we've always written YANG by hand — that's how you learn the model" is inertia. It may have been true when YANG tooling was in Genesis. It is no longer true when LLM-assisted stub generation is available as a product-stage capability. Inertia masquerades as wisdom. The map makes it visible.

---

## 5. The Build vs. Buy vs. Consume Decision

### Decision Tree

```
Is the capability in Commodity stage?
  YES → Consume as API/SaaS. Never build. Optimise cost.
  NO  ↓

Is the capability in Product stage?
  YES → Buy or subscribe. Evaluate ≥3 vendors. Document lock-in risk.
         Watch for market concentration (single-vendor dependency).
  NO  ↓

Is the capability in Custom-Built stage?
  YES → Build. Document as ADR. Plan for eventual commoditisation.
         Consider open-sourcing to avoid becoming the only maintainer.
  NO  ↓

Capability is in Genesis stage.
      → Experiment. Time-box to ≤4 weeks. No production commitments.
         Success criterion = learning, not delivery.
         Review and decide: invest more, pivot, or stop.
```

### O&A AI Tool Decision Table

| Tool / Capability | Evolution Stage | Decision | Notes |
|---|---|---|---|
| GitHub Copilot | Product | **Subscribe** | Evaluate vs. Cursor, Codeium annually |
| Claude / GPT-4o API | Product | **Subscribe** | Multi-vendor where possible |
| GitHub Copilot CLI | Product | **Subscribe** | Included in Copilot Enterprise |
| Ollama self-hosted | Custom | **Build/operate** | Justified by data sovereignty |
| Custom YANG RAG pipeline | Custom | **Build** | Document as ADR; plan for commoditisation |
| Prompt libraries | Custom → Product | **Build now, buy later** | Consolidate to platform team |
| LLM inference compute | Commodity | **Consume** | AWS Bedrock / GCP Vertex / Azure OpenAI |
| Tokenisation libs | Commodity | **Consume** | pip install tiktoken |
| YANG-AI constraint verify | Genesis | **Experiment** | 4-week time-boxed spike |
| AI network intent translation | Genesis | **Experiment** | Define success criterion before starting |
| Autonomous NSO remediation | Genesis | **Experiment** | High risk; start with read-only observability |

### Lock-In Risk Assessment

For Product-stage tools, lock-in risk is real. Guidance:

- **Prefer API-first tools** over deeply integrated IDE plugins where the workflow becomes inseparable from the vendor
- **Abstract LLM calls behind an interface** (LangChain, LiteLLM, or an internal wrapper) so that swapping Claude for GPT-4o or a local Ollama model requires a configuration change, not a code rewrite
- **Retain prompt ownership** — your prompts are your IP, not the vendor's. Store them in version control, not inside a vendor's proprietary prompt management UI

---

## 6. Anticipating Evolution

The map is a snapshot. Strategy requires understanding *how the map will change*. Everything on the evolution axis moves right over time, driven by competition, standardisation, and supply-side investment. O&A must anticipate this movement.

### Exploit the Genesis Window

While LLM-assisted YANG validation, network intent translation, and NSO-specific fine-tuning remain in the Genesis/Custom stages, O&A has a window to build genuine differentiation. These capabilities, if developed now, represent:

- Faster service onboarding (competitive advantage against manual YANG authoring)
- Reduced defect escape rate from YANG constraint errors
- Institutional knowledge codified in models and pipelines — not just in people's heads

Once these capabilities reach the Product stage (and they will — multiple vendors are already moving in this direction), the window for differentiation closes. A team that mastered YANG-AI pipelines in 2024–2025 will have two years of operational experience by the time competitors can buy an off-the-shelf equivalent.

### Avoid Commodity Traps

Commodity traps occur when an organisation invests heavily in customising or building something that is about to become a commodity, rendering their investment worthless.

**Current commodity traps to avoid for O&A:**

- **Building your own LLM** — frontier model training requires $50M+ in compute. This is commodity infrastructure. Consume Llama 3.x or API access instead.
- **Building your own vector database** — pgvector, Chroma, and managed Pinecone are all converging on commodity. Use them; do not build a custom embedding store.
- **Heavily customising a product-stage IDE plugin** — if Copilot is replaced by a better product in 18 months, deep workflow customisation creates switching costs. Keep integration shallow.

### Watch for Disruption Signals

Smaller, cheaper models are disrupting the large proprietary model market. Key signals O&A should track:

| Signal | Implication for O&A |
|---|---|
| Llama 3.1 8B matches GPT-3.5 on code tasks | Ollama self-hosted pipelines become viable for more use cases |
| Claude Haiku / GPT-4o-mini price drops | Cost-per-token for API-based tools falls; economics of custom pipelines improve |
| Vendor X announces YANG-specific code model | Genesis-stage YANG pipeline investments may commoditise faster than expected |
| Open-source NSO tooling gains LLM integration | Platform team's custom RAG pipeline faces open-source competition |

SCI (Supplier Concentration Index) and vendor concentration goals in the O&A governance framework are directly served by tracking these disruptions. A team that monitors model commoditisation can rebalance vendor dependency before lock-in solidifies.

---

## 7. Mapping Your Own Landscape

### Running a 2-Hour Wardley Mapping Session

The following facilitation guide enables O&A to run a team Wardley Mapping session for their AI tool landscape. No Wardley experience is required of participants.

**Pre-session (15 mins before):**
- Print or share a blank 2x2 canvas: Y-axis labelled "Visibility (high → low)", X-axis labelled "Evolution (Genesis → Custom → Product → Commodity)"
- Prepare sticky notes (physical or Miro/FigJam equivalent) in four colours: one per evolution stage

---

**Step 1: List Your Components (20 mins)**

Prompt: *"What AI tools, pipelines, data assets, and capabilities does O&A currently use or is actively exploring?"*

Each participant writes one component per sticky note. No filtering. Include:
- Tools in active use (GitHub Copilot, Claude API)
- Tools under evaluation (Cursor, CodeRabbit)
- Internal pipelines (Ollama setup, any custom scripting)
- Data assets that enable AI (YANG module library, NSO audit logs)
- Planned investments (YANG RAG, network intent translation)

Facilitator clusters duplicates. Aim for 15–25 unique components.

**Suggested output:** A raw list of components on the canvas, not yet positioned.

---

**Step 2: Place on the Evolution Axis (25 mins)**

For each component, the group collectively decides: which evolution stage does this sit in?

Use these prompts to guide placement:
- "Could you buy this off-the-shelf from three different vendors today?" → Product
- "Is it unique to O&A's environment or data?" → Custom
- "Has anyone in the industry done this before in production?" → if no, Genesis
- "Does everyone already use this as infrastructure?" → Commodity

Place stickies on the X-axis. Expect disagreement — that is the value. Map the debate, not the consensus.

**Suggested output:** All components placed on the evolution axis.

---

**Step 3: Place on the Visibility Axis (15 mins)**

For each component, ask: "Who sees this?"

- A tool the engineer interacts with daily (Copilot, CLI) → high visibility
- An API called by a pipeline → medium visibility
- Underlying compute or tokenisation libraries → low visibility

Adjust Y position accordingly.

**Suggested output:** A full 2D map with all components positioned.

---

**Step 4: Draw Dependencies (20 mins)**

Draw arrows from higher-visibility components down to the infrastructure they depend on. For example:
- GitHub Copilot → Claude/GPT-4o API → LLM inference compute
- Custom YANG pipeline → Ollama → LLM inference compute
- YANG RAG → Vector database → Embedding API

Ask: "Are there hidden dependencies we haven't listed as components?"

**Suggested output:** A map with dependency arrows. This often reveals missing components (e.g., "we haven't listed our embedding model as a component, but it's a critical dependency").

---

**Step 5: Identify Actions (20 mins)**

For each cluster of components, apply the doctrine:

| Quadrant | Question | Typical action |
|---|---|---|
| Genesis, visible | Should we invest or stop? | Define success criterion; time-box experiment |
| Custom, visible | Are we building for differentiation? | Document ADR; plan commoditisation exit |
| Product, visible | Are we getting value? | Measure adoption; review vendor annually |
| Commodity, infra | Are we building what we should buy? | Stop custom work; switch to API |

Capture one action per component. Assign an owner and a timeframe.

**Suggested output:** An action register with owner and timeframe per component. Feed into the O&A adoption roadmap.

---

### Keeping the Map Current

A Wardley Map is a point-in-time snapshot. It becomes stale in 6–12 months in a fast-moving space like AI. Recommended cadence:

- **Quarterly:** Review component positions. Have any genesis items matured to custom? Any custom items about to commoditise?
- **Annually:** Full re-mapping session with the team
- **On major external event** (new model release, vendor acquisition, open-source breakthrough): ad-hoc review of affected nodes

The map should live in version control alongside the adoption roadmap. Changes to component positions should be treated like architectural decisions — logged and reasoned about, not silently updated.

---

## Further Reading

- Wardley, S. *Wardley Maps* (freely available at medium.com/@swardley)
- LeadingEdgeForum.com — Wardley Mapping practitioner resources
- [O&A Adoption Roadmap](../adoption-roadmap.md) — see Phases aligned to evolution stages
- [Governance: Team Norms](../governance/team-norms.md) — doctrine applied to team operating model
