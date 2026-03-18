# AI Tool Landscape
## O&A Team — OSS - Orchestration and Automation

> *"The jagged frontier means AI is superhuman on some tasks and surprisingly weak on others — often within the same domain. Map the frontier first, then choose the tool."*
> — Ethan Mollick, *Co-Intelligence*

---

## Overview

This page is the entry point for the O&A AI tool landscape. It provides a complete inventory of the four AI tool categories in scope, maps each tool's strengths and weaknesses against O&A-specific tasks (the jagged frontier), assesses TM Forum API fit, and profiles responsible AI risk per tool.

### The Guiding Principle: Right Tool for the Right Job

AI tools are not interchangeable. A frontier LLM chat interface and an IDE autocomplete tool solve fundamentally different problems — and both solve different problems from a custom pipeline running a quantised open-source model in CI. Hype cycles obscure this. Mollick's jagged frontier is the antidote: map what each tool does well and poorly *for your specific tasks*, then let that map — not the vendor pitch — drive adoption.

For the O&A team, "your specific tasks" means YANG modelling, NETCONF/RESTCONF automation, NSO service package development, TM Forum API integration, and OSS/BSS orchestration in Python and Go. That context shapes every rating and recommendation on this page.

### How the Tools Fit Together

The four tool categories form a stack, not a competition. Each layer solves a different class of problem:

| Layer | Category | Primary value | When to reach for it |
|---|---|---|---|
| **Spec / Context** | Spec files + context dir | Prevent vague outputs, codify standards | Before any AI prompt — always |
| **Inner loop / IDE** | GitHub Copilot | In-context autocomplete and inline suggestion | Writing code, YANG stubs, unit tests in the editor |
| **Chat / reasoning** | LLM Chat (ChatGPT, Claude, Gemini) | Long-form reasoning, drafting, explanation | ADRs, incident summaries, architecture trade-offs |
| **Agentic / multi-step** | Copilot CLI, Copilot Workspace, Devin | Multi-step autonomous action across files or CLI | YANG refactors, multi-file feature work, CLI command synthesis |
| **Pipeline / automated** | Custom AI pipelines | Repeatable, spec-driven generation in CI/CD | YANG → code gen, OpenAPI stubs, config diff summaries |

Everything feeds through the CI/CD pipeline. No AI output reaches production without passing the same quality gates as human-written code.

!!! tip "Start with the spec"
    Before reaching for any AI tool, write a spec file. Addy Osmani's research shows 30–40% of project time spent on specs prevents token waste, lowest-common-denominator outputs, and thrown-away code. See [Spec-Driven AI Development](spec-driven-ai.md).

### Navigation Guide

Each tool category has a dedicated playbook with prompting patterns, safe-use checklists, and worked examples for O&A tasks:

| Playbook | Path |
|---|---|
| GitHub Copilot | [`docs/tools/github-copilot.md`](github-copilot.md) |
| Copilot CLI Plugin Guide | [`docs/tools/copilot-plugin-guide.md`](copilot-plugin-guide.md) |
| Copilot CLI Plugin Roadmap | [`docs/tools/copilot-plugin-roadmap.md`](copilot-plugin-roadmap.md) |
| LLM Chat Tools | [`docs/tools/llm-chat.md`](llm-chat.md) |
| Agentic Tools | [`docs/tools/agentic-tools.md`](agentic-tools.md) |
| Custom AI Pipelines | [`docs/tools/custom-pipelines.md`](custom-pipelines.md) |

---

## The AI Tool Stack

```
╔══════════════════════════════════════════════════════════════════════════════╗
║                         O&A AI TOOL STACK                                  ║
╠══════════════════════════════════════════════════════════════════════════════╣
║                                                                              ║
║  LAYER 4 │ PIPELINE / AUTOMATED                                              ║
║  ────────┼──────────────────────────────────────────────────────────────    ║
║          │  Custom AI Pipelines                                              ║
║          │  YANG→code gen · config diff summaries · OpenAPI stubs           ║
║          │  Release notes · test fixture generation                         ║
║          │  (OSS models: CodeLlama · IBM Granite · Mistral · Llama 3.1)    ║
║                                                                              ║
║  LAYER 3 │ AGENTIC / MULTI-STEP                                              ║
║  ────────┼──────────────────────────────────────────────────────────────    ║
║          │  Copilot CLI         Copilot Workspace       Devin-class agents  ║
║          │  CLI synthesis       Multi-file refactor     End-to-end features ║
║          │  NETCONF one-liners  YANG→TMF integrations   (high oversight)    ║
║                                                                              ║
║  LAYER 2 │ CHAT / REASONING                                                  ║
║  ────────┼──────────────────────────────────────────────────────────────    ║
║          │  ChatGPT (GPT-4o)    Claude (3.5 / 3.7)      Gemini (1.5 Pro)   ║
║          │  Incident summaries · ADR drafting · YANG explanation            ║
║          │  Architecture trade-offs · Runbook drafting                      ║
║                                                                              ║
║  LAYER 1 │ INNER LOOP / IDE                                                  ║
║  ────────┼──────────────────────────────────────────────────────────────    ║
║          │  GitHub Copilot (autocomplete · inline · Copilot Chat)           ║
║          │  YANG stubs · Python/Go generation · unit tests                  ║
║                                                                              ║
╠══════════════════════════════════════════════════════════════════════════════╣
║  FOUNDATION │ CI/CD PIPELINE                                                 ║
║  ───────────┼────────────────────────────────────────────────────────────   ║
║             │  All AI output is treated as untrusted input to the pipeline  ║
║             │  pyang · pytest · go test · SAST (Semgrep/Bandit) · OPA      ║
║             │  TM Forum API conformance checks · NETCONF schema validation  ║
╚══════════════════════════════════════════════════════════════════════════════╝
```

> **Key principle (Farley/Fowler):** The CI/CD pipeline is not optional. AI-assisted code that bypasses quality gates is not AI adoption — it is technical debt accumulation at machine speed.

---

## Tool Category 1: GitHub Copilot

### Overview

GitHub Copilot is the O&A team's primary inner-loop AI tool: an IDE-integrated AI pair programmer providing autocomplete, inline suggestions, and Copilot Chat. It operates with full awareness of the open files and project context in the editor, making it the strongest tool for in-context code generation tasks. It does not reason deeply over long documents and is not suited to architectural or strategic decisions.

### O&A Use Cases — Jagged Frontier Map

Ratings reflect real-world O&A task performance, not general capability. ⭐⭐⭐ = Strong, ⭐⭐ = Medium, ⭐ = Weak — human judgement is the primary control.

| O&A Task | Strength | Notes |
|---|---|---|
| YANG module authoring (stubs, groupings, typedefs) | ⭐⭐⭐ | Copilot has strong YANG pattern recognition; always run `pyang` validation |
| Python `ncclient` wrapper generation | ⭐⭐⭐ | Excellent with open file context; prompt with the target YANG path |
| Go `gNMI` client generation | ⭐⭐⭐ | Solid proto-to-Go pattern completion |
| Unit test generation for existing Python/Go code | ⭐⭐⭐ | Best in-class for this; review edge cases and error paths manually |
| Ansible playbook and role boilerplate | ⭐⭐ | Good for structure; module-specific params need verification |
| OpenAPI / AsyncAPI spec authoring | ⭐⭐ | Useful for boilerplate; always drive from a spec-first design |
| NETCONF RPC XML construction | ⭐⭐ | Useful for known operations; validate output against YANG schema |
| NSO service package Python logic | ⭐⭐ | Context-dependent; works better with NSO API imports visible |
| Network protocol edge case handling | ⭐ | AI has limited RFC edge-case knowledge; **human review essential** |
| Security-sensitive logic (access control, credentials) | ⭐ | **Human owns this** — SAST gate is non-negotiable here |

**Where Copilot is surprisingly weak for O&A:** novel YANG deviations from standard base models, NSO reactive FASTMAP logic, complex multi-vendor service activation sequencing, and any code that reasons about network-state side effects. These are all "jagged frontier" weak spots — AI confidence does not correlate with accuracy here.

### TM Forum API Fit

Copilot can generate conformant TMF Open API client code (e.g., TMF620 Product Catalogue, TMF641 Service Ordering) when given the published OpenAPI spec as context. The workflow is:

1. Open the relevant TMF OpenAPI YAML in the IDE alongside your client stub file
2. Copilot will generate method bodies, request/response models, and error handling aligned to the spec
3. **Do not free-generate TMF clients without the spec open** — Copilot will produce plausible but non-conformant code

TMF API mapping documents (eTOM process → API) are best handled in Layer 2 (LLM Chat), not Copilot.

### Responsible AI Risk Profile

| Dimension | Rating | Detail |
|---|---|---|
| **Privacy** | 🟡 Medium | Code context (including variable names, comments, and file paths) is sent to GitHub's inference infrastructure. Use **Copilot Business or Enterprise** for contractual data isolation. Do not open files containing credentials, network topology data, or customer-identifying information while Copilot is active. |
| **Security** | 🟡 Medium | Copilot reproduces common vulnerability patterns (insecure deserialization, hardcoded secrets, SQL injection in generated ORM code). A SAST gate (Semgrep, Bandit) in CI is **mandatory**, not optional. Enable GitHub Advanced Security secret scanning. |
| **Environmental** | 🟢 Low | Per-query inference is efficient relative to frontier chat models. Copilot's continuous suggestion model consumes more aggregate energy than on-demand queries — a team of 20 active Copilot users has a non-trivial but manageable SCI footprint. |
| **Market Concentration** | 🟡 Medium | Microsoft/GitHub dependency. OpenAI API-compatible self-hosted alternatives (Continue.dev + CodeLlama, Tabby) exist and provide migration paths. Avoid deep IDE coupling to proprietary Copilot-specific features. |
| **Workforce** | 🟢 Low | Unambiguously an augmentation tool. Team Members report reduced friction on boilerplate tasks. Monitor for deskilling risk on pattern-recognition tasks over multi-year timescales. |

**Playbook:** [`docs/tools/github-copilot.md`](github-copilot.md)

---

## Tool Category 2: LLM Chat Tools (ChatGPT, Claude, Gemini)

### Overview

General-purpose frontier language models accessed via chat interface. These are the O&A team's primary tool for reasoning, drafting, explanation, and analysis tasks that require extended context or conversational back-and-forth. Unlike Copilot, they operate outside the IDE and require deliberate prompting with relevant context — they have no automatic access to the codebase. Their strength is depth of reasoning over long text; their weakness is reliability on specialised protocol and operational knowledge.

### O&A Use Cases — Jagged Frontier Map

| O&A Task | Strength | Notes |
|---|---|---|
| Incident timeline summarisation | ⭐⭐⭐ | Excellent; sanitise logs before pasting (remove IPs, hostnames, customer refs) |
| ADR drafting (context + alternatives) | ⭐⭐⭐ | Strong on structure and trade-off articulation; team member validates the decision |
| YANG module explanation ("explain this data model") | ⭐⭐⭐ | Handles large YANG files well, especially Claude and Gemini with long context |
| Runbook drafting from incident data | ⭐⭐⭐ | High value; treat output as a first draft requiring SME review |
| Network alarm root cause hypothesis generation | ⭐⭐ | Useful for structured hypothesis generation; not a substitute for domain expertise |
| RFC / standard interpretation and Q&A | ⭐⭐ | Good for well-established RFCs (8040, 6241); weaker on recent or niche standards |
| TM Forum API selection assistance | ⭐⭐ | Helpful for eTOM → API mapping guidance; verify against TMF official documentation |
| Code review pre-screening | ⭐⭐ | Useful pattern-level review; misses runtime context and O&A-specific constraints |
| Architecture trade-off analysis | ⭐⭐ | Strong framing of known patterns; human leads the final architectural decision |
| Novel protocol / security decisions | ⭐ | **Human leads** — LLM confidence on edge cases is unreliable; treat as brainstorming only |

**Where LLM chat is surprisingly weak for O&A:** real-time network state reasoning, multi-vendor NSO device NEDs, vendor-specific YANG augmentations, and precise NETCONF capability negotiation. These are structurally outside the training data distribution.

### Tool Comparison

| Dimension | ChatGPT (GPT-4o) | Claude (3.5 / 3.7) | Gemini (1.5 Pro) |
|---|---|---|---|
| Code quality (Python/Go) | ⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐ |
| Long context (large YANG files, log dumps) | ⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐ |
| Instruction following | ⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐ |
| Structured output (JSON, YAML) | ⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐ |
| Enterprise data isolation | ⭐⭐ (Plus / Enterprise) | ⭐⭐ (Claude.ai Teams) | ⭐⭐ (Workspace) |
| OSS / self-hosted alternative | Llama 3.1, Mistral | Llama 3.1 | Gemma 2 |
| Primary vendor | OpenAI / Microsoft | Anthropic / Amazon | Google |

**Recommendation for O&A:** Claude 3.5/3.7 for large YANG/log analysis and complex reasoning tasks; GPT-4o for structured code generation and API-format tasks; Gemini 1.5 Pro where Google Workspace integration matters. All three require enterprise accounts for production use.

### TM Forum API Fit

LLM chat tools are the best available tool for the reasoning half of TM Forum API work:

- Mapping business processes (eTOM L2/L3) to candidate Open APIs (TMF620, TMF641, TMF653, TMF686)
- Explaining ODA component model relationships
- Drafting API conformance test criteria from TMF CTK documentation
- Reviewing API design decisions against TMF guidelines

They are **not** reliable for generating conformant API schemas from scratch — use the official TMF Open API table and spec files as primary sources, with LLM chat as a reasoning aid.

### Responsible AI Risk Profile

| Dimension | Rating | Detail |
|---|---|---|
| **Privacy** | 🔴 High | Default consumer accounts log and may use prompts for training. **Enterprise/Teams accounts are required for any professional O&A use.** NEVER paste network device configurations, topology data, customer identifiers, or credentials into any LLM chat interface — even enterprise-tier. Treat the clipboard as a data classification boundary. |
| **Security** | 🟡 Medium | Output must be reviewed before use; these tools are not security analysis instruments without human oversight. Do not use chat LLMs to review authentication, authorisation, or cryptographic code without a qualified team member in the loop. |
| **Environmental** | 🔴 High | Frontier model inference (GPT-4o, Claude 3.7, Gemini 1.5 Pro) carries the highest SCI cost per query of any tool category. Use the **smallest capable model** per task — Haiku, GPT-4o-mini, or Gemini Flash for simple summarisation tasks. Reserve frontier models for tasks that genuinely require them. |
| **Market Concentration** | 🔴 High | Three vendors (OpenAI/Microsoft, Anthropic/Amazon, Google) dominate the frontier model market. This is a structural concentration risk (Crawford). Design prompts and workflows to be model-agnostic. Evaluate OSS alternatives (Llama 3.1, Mistral) for suitable tasks. |
| **Workforce** | 🟡 Low–Medium | Transparency about LLM-assisted work within the team is important for trust and learning. Encourage team members to share prompts and outputs — normalises AI use as a collaborative practice rather than a hidden shortcut. |

**Playbook:** [`docs/tools/llm-chat.md`](llm-chat.md)

---

## Tool Category 3: Agentic Tools (Copilot CLI, Copilot Workspace, Devin)

### Overview

Agentic tools take multi-step actions, often with some degree of autonomy, spanning CLI commands, file system operations, or full feature implementation cycles. This is the most rapidly evolving category and the one requiring the most rigorous safety controls. The spectrum runs from narrowly scoped (Copilot CLI: suggest a single shell command) to broadly autonomous (Devin-class agents: implement a feature from a GitHub issue). Power and risk scale together.

### O&A Use Cases — Jagged Frontier Map

| O&A Task | Tool | Strength | Notes |
|---|---|---|---|
| Explaining and composing shell commands | Copilot CLI | ⭐⭐⭐ | Safe, narrow scope; ideal for NETCONF/RESTCONF one-liners, Ansible ad-hoc |
| `git` workflow automation | Copilot CLI | ⭐⭐⭐ | Low risk, high value for complex git operations |
| Multi-file YANG refactoring | Copilot Workspace | ⭐⭐ | Requires scoped ADR; review every file change before commit |
| Adding a new TMF API integration (service + tests + docs) | Copilot Workspace | ⭐⭐ | Productive with tight issue specification; scope boundary required |
| Generating GitHub Actions workflows | Copilot Workspace / CLI | ⭐⭐ | Useful scaffolding; pipeline security review mandatory |
| End-to-end feature implementation from issue | Devin-class agents | ⭐ | **High oversight required**; treat all output as untrusted draft code |
| Autonomous network configuration changes | Any agentic tool | ❌ | **Never permitted** — see safety rules below |

**Where agentic tools are weak for O&A:** any task requiring live network state awareness, multi-vendor interoperability reasoning, complex NSO service activation ordering, or security-critical logic. Agentic confidence does not imply correctness on network-domain specifics.

---

> ### ⚠️ Agentic Safety Rules — Non-Negotiable
>
> These rules apply to all agentic tool use by the O&A team, without exception:
>
> 1. **Agentic tools must NEVER have write access to production network devices.** No credentials, no device SSH keys, no NETCONF sessions. Full stop.
> 2. **All agentic output is treated as untrusted code** until it has passed the full CI pipeline (linting, tests, SAST, schema validation).
> 3. **Scope boundaries must be documented in an ADR** before introducing any new agentic tool or expanding the scope of an existing one.
> 4. **Human-in-the-loop checkpoints are required** at every consequential step in a multi-step agentic workflow. Autonomous runs without review gates are not permitted.
> 5. **Prompt injection is an active threat** (OWASP LLM01). Any agentic tool that reads external data (issue text, log files, API responses) as part of its context must be treated as a potential injection surface. Validate all tool-generated commands before execution.

---

### TM Forum API Fit

Agentic tools are best positioned to accelerate the *implementation* phase of TM Forum API integration work, once the design is settled:

- Copilot Workspace can generate a multi-file integration scaffold (client, models, tests, README) from a well-specified issue referencing the TMF OpenAPI spec
- Copilot CLI can compose `curl`/`httpie` one-liners for TMF API testing and exploration
- The TM Forum CTK (Conformance Test Kit) should be the validation gate for any agentic-generated TMF integration

### Responsible AI Risk Profile

| Dimension | Rating | Detail |
|---|---|---|
| **Privacy** | 🔴 High | Agentic tools may read the local file system, shell history, environment variables, and editor state. Explicitly scope what the agent can access. Do not run agentic tools in environments where secrets, customer data, or sensitive topology information are present in the file system without clear access boundaries. |
| **Security** | 🔴 High | Prompt injection (OWASP LLM01) is a direct threat — malicious content in issue descriptions, log files, or API responses can redirect agent actions. Every generated command must be inspected before execution. Never grant agents credentials beyond the minimum required for the stated task. |
| **Environmental** | 🟡 Medium | Multi-step tasks multiply per-inference energy cost. A Devin-class task that makes 50 LLM calls consumes 50× the energy of a single query. Right-size to task: Copilot CLI for CLI tasks, Copilot Workspace for multi-file tasks, Devin-class agents only when the complexity genuinely justifies it. |
| **Market Concentration** | 🔴 High | Currently dominated by GitHub/Microsoft (Copilot CLI, Workspace) and proprietary agent vendors. OSS alternatives (OpenDevin, SWE-agent) exist but are early-stage. Avoid deep workflow coupling to proprietary agentic APIs. |
| **Workforce** | 🟡 Medium | This is the most potentially disruptive category for engineering roles. Introduce agentic tools with explicit psychological safety conversations — normalise questions about role evolution. Frame agentic tools as amplifiers of senior engineering judgment, not replacements for it. |

**Playbook:** [`docs/tools/agentic-tools.md`](agentic-tools.md)

---

## Tool Category 4: Custom AI Pipelines

### Overview

Custom AI pipelines are AI capabilities the O&A team builds into its own CI/CD and automation infrastructure — not off-the-shelf tools. This is the highest-investment, highest-control category: the team owns the prompt, the model choice, the data flow, and the output validation. Done well, this is also the category with the best responsible AI profile: measurable SCI, low vendor lock-in, full data governance, and real engineering skill development.

Custom pipelines are the right answer for tasks that are **repeatable, spec-driven, and data-sensitive** — exactly the profile of most O&A code generation tasks.

### O&A Use Cases — Jagged Frontier Map

| O&A Task | Strength | Notes |
|---|---|---|
| YANG → Python/Go data class generation in CI | ⭐⭐⭐ | High-ROI; deterministic input (YANG), validated output (pyang + pytest) |
| Automated config diff → human-readable change summary | ⭐⭐⭐ | Reduces review time for large network change sets |
| OpenAPI spec → client stub generation in pipeline | ⭐⭐⭐ | Spec-first; the spec is the contract; generation is a mechanical step |
| Test fixture generation from YANG models | ⭐⭐⭐ | Strongly recommended; reduces test authoring burden significantly |
| Release notes generation from `git log` + PR metadata | ⭐⭐ | Useful; requires structured commit conventions (Conventional Commits) |
| NETCONF alarm → incident summary generation | ⭐⭐ | Useful triage aid; human confirms severity and response |
| Novel architecture decisions in pipeline | ⭐ | Pipelines execute decisions; they don't make them |

### When to Build Custom vs Use Existing Tools

| Factor | Build custom pipeline | Use existing tool |
|---|---|---|
| **Task repeatability** | Runs many times per day/week in CI | Ad hoc or exploratory |
| **Data sensitivity** | Contains network configs, topology, customer data | Sanitised or synthetic data only |
| **Performance requirements** | Sub-second latency, high throughput | Interactive latency is acceptable |
| **Cost at scale** | Per-query API cost is prohibitive at volume | Volume is low enough for API pricing |
| **Maintenance budget** | Team can own model updates and prompt tuning | Team has no capacity for pipeline maintenance |
| **Vendor lock-in tolerance** | Low — architectural longevity matters | High — team accepts dependency |

### OSS Model Options for O&A Custom Pipelines

Prioritising low SCI footprint and no vendor lock-in, per Currie and Crawford:

| Model | Size | Best O&A use | SCI profile | Licence |
|---|---|---|---|---|
| **IBM Granite Code** | 8B / 20B | Telecom-friendly patterns; enterprise-licensed; strong Python/Go | 🟢 Low–Medium | Apache 2.0 |
| **Llama 3.1** | 8B | Fast iteration, high throughput pipelines, low cost per query | 🟢 Low | Meta (open weights) |
| **Mistral 7B** | 7B | General reasoning, instruction following, config summarisation | 🟢 Low | Apache 2.0 |
| **DeepSeek Coder** | 6.7B / 33B | Code-specific tasks, strong on structured output | 🟢–🟡 Low–Medium | MIT |
| **CodeLlama** | 34B | YANG/Python/Go generation where quality > throughput | 🟡 Medium | Meta (open weights) |

> **Model selection principle (Currie):** Use the smallest model that produces acceptable quality output for the specific task. A Llama 3.1 8B model running on-prem has a fraction of the SCI cost of a GPT-4o API call at pipeline scale. Measure, don't assume.

### TM Forum API Fit

Custom pipelines are the **optimal architecture** for TM Forum API integration at scale:

- Generate TMF-conformant client stubs from the official OpenAPI specs in the pipeline — the spec is the single source of truth
- Run TMF CTK conformance checks automatically against generated clients in CI
- Generate ODA component manifests and API exposure descriptors from service metadata
- Pipeline-driven generation ensures every TMF API integration is consistent, versioned, and testable

This aligns directly with TM Forum's own API-first and ODA principles: automation of API integration should be driven by the machine-readable specification, not by manual implementation.

### Responsible AI Risk Profile

| Dimension | Rating | Detail |
|---|---|---|
| **Privacy** | 🟢 Low (on-prem) / 🔴 High (cloud API) | Running OSS models on-prem or in the team's own infrastructure keeps network topology, configuration data, and customer information within the team's data boundary. Sending the same data to a cloud API endpoint negates this advantage entirely. Architecture decision: on-prem for sensitive pipelines. |
| **Security** | 🟡 Medium | Pipeline prompt injection is possible if the prompt is constructed from untrusted external inputs (e.g., git commit messages, issue text, alarm payloads). Validate and sanitise all dynamic prompt inputs. Implement output validation gates — do not deploy generated artefacts without schema and lint checks. |
| **Environmental** | 🟢 Controllable | This is the only tool category where the team directly controls the SCI footprint. On-prem OSS model hosting with carbon-aware scheduling, right-sized model selection, and batch rather than streaming inference are all achievable. Instrument and track SCI per pipeline stage. |
| **Market Concentration** | 🟢 Low | Building on Apache 2.0 and MIT-licensed OSS models with open-weight portability is precisely how to reduce market concentration risk (Crawford). This category is the team's primary lever for architectural independence from frontier AI vendors. |
| **Workforce** | 🟢 Low | Team Members who build and maintain custom AI pipelines develop durable, high-value skills in MLOps, prompt engineering, model evaluation, and pipeline architecture. This is additive to the team's capability profile, not substitutive. |

**Playbook:** [`docs/tools/custom-pipelines.md`](custom-pipelines.md)

---

## Master Tool Decision Matrix

Use this table as the first reference when deciding which tool to reach for. When in doubt: start with the simplest tool that can reasonably do the job, and escalate to more powerful tools only when needed.

| Task | Recommended Tool | Why | Watch out for |
|---|---|---|---|
| YANG module stub (new module or grouping) | **GitHub Copilot** | Fast inline generation with IDE context | Always run `pyang` validation; verify against base YANG model |
| Explain a YANG module or data model | **LLM Chat** | Long context, conversational Q&A | Cross-reference with RFC or vendor documentation |
| Generate unit tests for existing Python/Go | **GitHub Copilot** | IDE context produces better targeted tests | Review edge cases, error paths, and boundary conditions manually |
| Incident timeline summarisation | **LLM Chat** | Reasoning over long unstructured text | Sanitise: remove IPs, hostnames, customer refs before pasting |
| ADR drafting (context + alternatives) | **LLM Chat** | Structured reasoning, trade-off articulation | Team Member owns and validates the decision — AI drafts, human decides |
| Multi-file YANG refactoring | **Copilot Workspace** | Multi-file awareness across the repo | ADR required; scope boundary explicit; review every changed file |
| TMF API client stub generation | **Custom pipeline** | Repeatable, spec-driven, consistent output | Spec-first always; run TMF CTK conformance check |
| NETCONF RPC one-liner or exploration | **Copilot CLI** | CLI context, scoped output | Validate against YANG schema before sending to device |
| Architecture trade-off analysis | **LLM Chat** | Reasoning depth over known patterns | Human leads the decision; AI is a thinking partner, not the architect |
| Runbook drafting from incident data | **LLM Chat** | Strong at structured document generation from log data | SME review required; sanitise data first |
| Config diff → change summary | **Custom pipeline** | Repeatable, high volume, data-sensitive | Pipeline prompt injection risk if diff includes external content |
| Release notes from git log | **Custom pipeline** | Structured input → structured output; runs in CI | Requires Conventional Commits discipline to produce useful output |
| Security review of authentication logic | **Human + SAST** | Non-negotiable; AI cannot own security decisions | AI can assist pattern-finding only; SAST gate mandatory in CI |
| Novel protocol feature or RFC edge case | **Human** | Jagged frontier — AI is unreliable on specialised protocol knowledge | Do not trust AI confidence scores on RFC edge cases; escalate to domain expert |
| NSO service package reactive logic | **Human + GitHub Copilot** | NSO FASTMAP specifics are outside most AI training data | Copilot for boilerplate; human for service activation logic |
| Alarm root cause hypothesis | **LLM Chat** | Useful structured brainstorming over alarm patterns | Not a substitute for domain expertise; hypothesis requires operational validation |

---

## References

| Source | Relevance to This Page |
|---|---|
| Mollick, E. (2024). *Co-Intelligence: Living and Working with AI*. Portfolio/Penguin. | Jagged frontier concept — the foundation for all strength/weakness ratings in this document |
| Hohpe, G. (2020). *The Architect Elevator*. O'Reilly. | Platform thinking and tool selection: tools must serve architectural outcomes, not drive them |
| Crawford, K. (2021). *Atlas of AI*. Yale University Press. | Market concentration risk framing; material and political costs of AI infrastructure |
| Currie, A. et al. (2023). *Software Carbon Intensity (SCI) Specification*. Green Software Foundation. | SCI per tool; right-sizing model choice; on-prem vs cloud pipeline architecture |
| OWASP (2023). *OWASP Top 10 for Large Language Model Applications* (LLM01: Prompt Injection). | Agentic tool security rules; pipeline injection risk |
| TM Forum (2024). *Open API Table and Specifications* (TMF Open API). | TMF API fit assessments throughout this document |
| TM Forum (2024). *ODA Component Model*; *eTOM Business Process Framework*. | eTOM → API mapping; ODA component pipeline generation |
| Farley, D. (2021). *Modern Software Engineering*. Addison-Wesley. | CI/CD pipeline as non-negotiable quality gate for all AI-generated artefacts |
| Forsgren, N., Humble, J., & Kim, G. (2018). *Accelerate*. IT Revolution. | DORA metrics as the measurement baseline for AI tool adoption impact |
| Cummins, H. (2023). *Sustainable Software Engineering*. | Cognitive load and sustainable pace as adoption success criteria |

---

*Last reviewed: 2025 · Owner: O&A Platform Engineering · Next review: quarterly*
*Cross-references: [`docs/responsible-ai/`](../responsible-ai/) · [`docs/msd-foundations/`](../msd-foundations/) · [`docs/tmforum/`](../tmforum/)*
