# Skill: Wardley Position

**Skill name**: `wardley`
**Trigger phrases**: "wardley map", "where does this fit on wardley", "evolution axis", "build or buy", "genesis custom product commodity"

---

## What This Skill Does

Helps position an AI tool, component, or capability on Simon Wardley's evolution axis. The position determines the correct strategic posture: build, buy, consume, or experiment. Getting this wrong is expensive — building something that is already a commodity, or buying something still in Genesis, both waste engineering investment.

Wardley's core insight for O&A: **everything moves right** (towards commodity) over time. Map your AI tools annually. Last year's Custom Build is this year's Product.

---

## The 4 Evolution Stages

### Genesis — Novel, Uncertain, No Best Practices
**Characteristics**: Not well understood, high experimentation value, no market leader, bespoke to your context.

**O&A examples**:
- AI-driven network intent translation (natural language → NETCONF RPC)
- LLM-assisted YANG constraint verification and conflict detection
- Multi-vendor YANG model reconciliation with LLM reasoning
- AI-generated DORA analysis with root cause correlation to code changes

**Strategic posture**: Time-box experiments (Beck 3X — Explore). No production commitments. Document learnings. Budget for failure. Do NOT standardise.

---

### Custom Build — Understood but Not Productised
**Characteristics**: Teams know what good looks like, but no off-the-shelf solution exists. Competitive advantage possible.

**O&A examples**:
- Ollama-based YANG validation pipeline running on-premises
- In-house RAG system over O&A YANG module libraries and TMF specs
- Custom Copilot CLI plugin for NSO/YANG workflows (this plugin)
- Fine-tuned model for O&A-specific NETCONF RPC generation

**Strategic posture**: Build with intent to open-source. Document every architectural decision (ADR). Plan the exit to Product when the market catches up. Watch for vendor concentration risk.

---

### Product — Understood, Productised, Market Leaders Emerging
**Characteristics**: Multiple vendors, clear leaders, purchasing decisions replace build decisions.

**O&A examples**:
- GitHub Copilot (code completion for Python, YANG, Ansible)
- Claude API / GPT-4o API (general-purpose reasoning and generation)
- Copilot CLI (this plugin host)
- Ansible Lightspeed (AI-assisted Ansible playbook generation)
- Commercial NSO AI add-ons (as they emerge)

**Strategic posture**: Consume/buy. Evaluate on capability, cost, and lock-in risk. Maintain model interoperability (vendor diversity rule). Do not rebuild what you can buy. Watch the evolution axis — Products commoditise rapidly.

---

### Commodity — Ubiquitous, Utility-Like, Undifferentiated
**Characteristics**: Infrastructure-level. Chosen on price and reliability, not capability differentiation.

**O&A examples**:
- Cloud LLM inference APIs (OpenAI, Anthropic, Google — inference as a utility)
- Tokenisation libraries (tiktoken, sentencepiece)
- Embeddings APIs
- Vector database managed services
- GPU compute for local inference

**Strategic posture**: Use as utility. No differentiation value in building. Focus on abstraction layer to avoid lock-in (commodity can still have concentration risk at scale).

---

## The 3 Positioning Questions

Ask the user these 3 questions to determine evolution stage:

**1. Is there a clear market leader?**
- No clear leader, novel space → Genesis
- Multiple competitors, no dominant leader → Custom / early Product
- One or two dominant vendors → Product
- Multiple interchangeable providers, chosen on price → Commodity

**2. Do established best practices exist?**
- No patterns yet, everyone experiments differently → Genesis
- Emerging patterns, some documentation → Custom Build
- Published playbooks, certifications, integrations → Product
- Standardised APIs, commoditised → Commodity

**3. Can it be purchased as a managed service today?**
- Not available for purchase → Genesis or Custom Build
- Available but specialised/expensive → Product
- Available at commodity pricing, multiple providers → Commodity

---

## Decision Output by Position

After positioning the tool or component, output one of these strategic recommendations:

**If Genesis**:
> "This capability is in Genesis. Time-box an experiment: 4 weeks, named engineer, clear question to answer. No production commitments. No standardisation yet (Beck 3X — Explore). Document the learning, not the output. This may move to Custom Build in 12–18 months — reassess then."

**If Custom Build**:
> "This is a Custom Build. Build it, but plan the exit. Document the architecture in an ADR. Write it to be open-sourced. Assume a Product will exist in 18–24 months that does this better — build a clean abstraction layer so you can swap it out. Watch for vendor concentration (O&A Principle 21)."

**If Product**:
> "This is a Product. Consume it, do not rebuild it. Evaluate on: capability fit, total cost, lock-in risk, and the vendor's position on the Wardley axis (is this Product about to commoditise?). Write an ADR for the adoption decision. Maintain model interoperability — do not become 100% dependent on one vendor's API shape."

**If Commodity**:
> "This is a Commodity. Use it as utility infrastructure. Choose on price, SLA, and compliance. The only risk is concentration — if you rely on a single provider for a commodity, you have created artificial lock-in. Ensure your abstraction layer can switch providers."

---

## O&A Strategic Note: The Annual Review

Everything moves right. A tool you classified as Custom Build 18 months ago may now be a Product. A Genesis experiment may have stalled (and should be killed).

**Review your Wardley positions for all AI tools annually.** Use the ADR review date (set to 12 months for AI tooling) as the trigger. At each review ask: has this moved right? Should we stop building and start buying? Should we open-source what we built?

Map your current AI tools at the start of each financial year. The map tells you where to invest and where to stop investing.
