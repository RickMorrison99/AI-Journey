# Spec-Driven AI Development

## O&A Team — OSS - Orchestration and Automation

> *"Spending 30–40% of your project time creating a detailed spec file is not overhead — it is the work. The spec is the instruction set that turns an LLM from a probabilistic guesser into a precise collaborator."*
> — Addy Osmani, Engineering Leader, Google Chrome

> **Audience:** All O&A team members using AI tools to generate code, YANG models, OpenAPI stubs, or configuration artefacts.
> **Framework source:** Addy Osmani's spec-driven AI development methodology, extended with O&A-specific context.

---

## Overview

This document describes spec-driven AI development — a disciplined approach to prompting AI tools that treats the specification as a first-class engineering artefact. The framework is drawn from the work of **Addy Osmani**, an engineering leader at Google responsible for Chrome DevTools and Lighthouse, who has written extensively on how the shift to AI-assisted engineering changes the role of the developer from implementer to architect-of-intent.

The core claim is simple: **the quality of AI-generated output is bounded by the quality of the input specification.** Vague prompts produce vague code. Precise specifications — defining constraints, technology choices, success criteria, and what the code must not do — produce output that is usable, maintainable, and aligned with team standards.

For the O&A team, this is not an abstract principle. Our domain involves YANG models that drive real network configuration, NETCONF sessions targeting live routers, TM Forum API integrations with production BSS/OSS systems, and NSO service packages with complex rollback semantics. The blast radius of AI-generated code that silently deviates from our architecture is measured in service outages, not broken unit tests. Spec-driven development is how we get the velocity benefits of AI tools without accepting that risk.

---

## Section 1 — The Core Argument

Addy Osmani's central thesis is that AI code generation tools behave like very fast, very well-read engineers who have been given only a one-line ticket. They will produce something — they are extraordinarily capable — but without detailed instruction, what they produce reflects the average of their training data rather than the specific, opinionated, standards-aligned solution your team actually needs.

This connects directly to Ethan Mollick's concept of the **jagged frontier** from *Co-Intelligence*. Mollick observes that LLM capability is not uniformly strong or weak — it is jagged. On some tasks, AI is superhuman. On adjacent tasks, it is surprisingly poor. But the jaggedness is compounded by prompt quality: even on tasks where an LLM is nominally capable, a vague prompt produces jagged results. A precise specification flattens the frontier for the tasks you care about. It removes the ambiguity that forces the LLM to fall back on statistical averages.

> *"LLMs behave like engineers given a high-level statement — they produce a best-effort result which is often hit-or-miss if the prompt lacks specific detail."*
> — Addy Osmani

The implication for O&A engineers is that adopting AI tools without investing in specification discipline is like hiring a skilled contractor and handing them a napkin sketch instead of engineering drawings. The contractor will build something. Whether it is what you needed is largely a matter of luck.

---

## Section 2 — The Problem: What Happens Without a Spec

### Vague Prompts → Hit-or-Miss Results

When a developer asks an AI tool a vague question, the LLM does the only rational thing it can: it searches its training distribution for the most common, most popular, most average response to that class of request. This is the **lowest-common-denominator problem**. The output is technically correct in the same way that a generic stock photo of an office is technically a photograph of an office — it satisfies the literal request while missing everything that makes it actually useful.

!!! warning "Vague prompts → vague code"
    A vague prompt does not produce a wrong answer. It produces an average answer — one that works in the statistical centre of the training distribution but misses every specialisation, constraint, and standard that makes your team's codebase coherent.

### The O&A Example: NETCONF Python Client

Consider the difference between these two prompts.

**Vague prompt:**
```
Write a NETCONF Python client for our router.
```

**What this produces** — a lowest-common-denominator ncclient snippet:

```python
from ncclient import manager

def get_config(host, username, password):
    with manager.connect(
        host=host,
        port=830,
        username=username,
        password=password,
        hostkey_verify=False  # <- insecure default, will get through review silently
    ) as m:
        config = m.get_config(source='running')
        return config.data_xml
```

This code will run. It will even fetch a config. But it:

- Disables host key verification silently
- Uses `data_xml` rather than parsing to a structured type
- Has no retry logic for transient connection failures common in production NETCONF
- Uses no type hints (violates team standards)
- Has no error handling distinguishing `RPCError` from transport failures
- Has no async support, blocking the event loop in our FastAPI services
- Does not reference our internal `netconf_utils` module or connection pool
- Does not follow the session-reuse pattern required by our NSO NETCONF northbound

**Spec-driven prompt** (abbreviated — see Section 3 for full spec format):
```
Using the spec file at context/netconf-client-spec.md:
- Language: Python 3.11, strict type hints, no `Any`
- Library: ncclient 0.6.15
- Pattern: async context manager wrapping ncclient's synchronous API using asyncio.run_in_executor
- Security: hostkey_verify MUST be True; load host keys from context/known_hosts_schema.md
- Error handling: distinguish RPCError, TransportError, and TimeoutError; raise domain-specific exceptions
- Reuse: check context/netconf_utils.py for existing session pool; do not create a new pool
- Test: generate pytest fixtures using the FakeNETCONF stub in context/test_stubs.md
```

**What this produces** — code that is actually usable:

```python
import asyncio
from contextlib import asynccontextmanager
from typing import AsyncGenerator
from ncclient import manager
from ncclient.operations import RPCError
from .exceptions import NetconfRPCError, NetconfTransportError, NetconfTimeoutError
from .netconf_utils import get_session_pool

async def get_running_config(
    host: str,
    username: str,
    filter_xml: str | None = None,
) -> str:
    """Fetch running config via NETCONF. Returns raw XML string.

    Args:
        host: Target device hostname (must be in known_hosts).
        username: NETCONF username; password sourced from secrets manager.
        filter_xml: Optional subtree filter XML string.

    Raises:
        NetconfRPCError: Device returned an RPC error response.
        NetconfTransportError: SSH/TCP connection failed.
        NetconfTimeoutError: Operation exceeded configured timeout.
    """
    pool = get_session_pool()
    loop = asyncio.get_running_loop()
    try:
        return await loop.run_in_executor(
            None, pool.get_config, host, username, filter_xml
        )
    except RPCError as e:
        raise NetconfRPCError(str(e)) from e
    ...
```

The difference is not AI capability. The difference is specification quality.

---

## Section 3 — The Spec File: What to Put In It

### The Anatomy of a Spec File

A spec file is a Markdown document that answers the questions a careful senior engineer would ask before beginning an implementation. Osmani's framework identifies five essential components:

1. **Constraints** — what the implementation must not do (no `Any` types, no `hostkey_verify=False`, no direct database access from the API layer)
2. **Success criteria** — specific, testable statements of what "done" means
3. **Technology stack** — exact library names and versions, not categories
4. **Architecture patterns** — which patterns to follow; links to ADRs and existing code examples
5. **Explicit exclusions** — what is out of scope; what the LLM should not generate

Each component exists to eliminate a class of lowest-common-denominator output. Constraints prevent the most common bad defaults. Success criteria give the LLM a target to optimise toward. Stack specificity prevents library substitution. Architecture patterns connect the generated code to the existing codebase. Exclusions prevent scope creep that produces unusable, oversized outputs.

### Worked Example: TMF639 Resource Inventory Endpoint Spec

The following is a real spec file template for an O&A task — generating a TM Forum TMF639 Resource Inventory GET endpoint:

```markdown
# Spec: TMF639 Resource Inventory — GET /resource/{id}

## Task
Generate a FastAPI endpoint implementing TMF639 `GET /resource/{id}`.
Return a `Resource` object conforming to the TMF639 v4.0.0 schema.

## Technology Stack
- **Language:** Python 3.11
- **Framework:** FastAPI 0.111.x (NOT Flask, NOT Django)
- **Schema validation:** Pydantic v2 (NOT v1 — do NOT use `class Config`, use `model_config`)
- **Database layer:** SQLAlchemy 2.0 async ORM (session injected via FastAPI dependency)
- **HTTP client (if needed):** httpx (NOT requests — we are async throughout)
- **Testing:** pytest + pytest-asyncio + httpx.AsyncClient

## TMF Forum Standard Reference
- Spec: context/tmf/TMF639_Resource_Inventory_Management_v4.0.0.yaml
- The `Resource` schema is defined in that file. DO NOT invent fields.
- Required fields: `id`, `href`, `name`, `resourceStatus`, `@type`
- `resourceStatus` MUST be one of: `standby`, `alarm`, `available`, `reserved`, `unknown`, `suspended`

## Architecture Pattern
- Follow the repository pattern used in context/examples/tmf638_service_inventory.py
- Router in `src/api/v4/resource.py`
- Service layer in `src/services/resource_service.py`
- Repository in `src/repositories/resource_repository.py`
- Do NOT put database logic in the router

## Constraints
- Type hints on every function, including return types. No `Any`.
- All database operations MUST be async (`async def`, `await session.execute(...)`)
- Error responses MUST follow the TMF Error schema (see context/tmf/error_schema.md)
- 404 responses: return `{"code": "404", "reason": "Resource not found", "message": "..."}`
- No print statements. Use `structlog` for logging (see context/logging_config.py)
- No hardcoded strings for status values — use the `ResourceStatus` enum in context/enums.py

## Success Criteria
- [ ] `GET /resource/{id}` returns 200 with valid TMF639 Resource JSON for known ID
- [ ] `GET /resource/{id}` returns 404 with TMF Error schema for unknown ID
- [ ] `GET /resource/{id}` returns 422 for malformed UUID `{id}`
- [ ] All fields in the response are validated by Pydantic against the TMF639 schema
- [ ] pytest suite passes: test_resource_get_found, test_resource_get_not_found, test_resource_get_invalid_id
- [ ] No SQLAlchemy warnings in test output

## Explicit Exclusions (do NOT generate)
- POST, PUT, PATCH, DELETE endpoints — separate spec
- Pagination — separate spec (GET /resource collection endpoint)
- Authentication middleware — already implemented in context/middleware/auth.py
- Database migrations — handled by Alembic, separate workflow

## Context Files
See `context/` directory:
- `context/tmf/TMF639_Resource_Inventory_Management_v4.0.0.yaml`
- `context/examples/tmf638_service_inventory.py` (pattern reference)
- `context/enums.py` (ResourceStatus enum)
- `context/logging_config.py` (structlog setup)
- `context/middleware/auth.py` (auth — do not regenerate)
```

This spec file takes 20–40 minutes to write. It saves 2–4 hours of rework because the AI generates code that actually fits into the existing codebase.

---

## Section 4 — The Context/Resources Directory

### The Problem with Leaving Research to the LLM

Osmani's second key insight is about **context provision**: developers should not leave it to the AI to research the relevant standards, libraries, and patterns. When an LLM is asked to implement something without context, it falls back on its training data — which reflects the average of every implementation of that concept it has ever seen, weighted toward whatever was most prevalent on the internet at training time. This is not what O&A needs.

> *"Instead of relying on an agent to research on its own, developers should provide a context or resources directory containing necessary information. This prevents the LLM from defaulting to lowest-common-denominator patterns found in training data."*
> — Addy Osmani

### The `context/` Directory Pattern

Every AI-assisted O&A task should be accompanied by a `context/` or `.ai/` directory containing the files the AI needs to produce a correct, team-aligned output. Think of it as the briefing pack you hand to a contractor before they start work.

!!! info "O&A context"
    The `context/` directory is not documentation for humans. It is a machine-readable briefing pack for the AI. Write it with the same rigour you would apply to an ADR or an API spec — because it has the same downstream consequences.

### What Goes in the O&A `context/` Directory

```
context/
├── README.md                          # What this context dir is for, last updated
│
├── standards/
│   ├── coding-standards.md            # Python type hints, structlog, async patterns
│   ├── yang-style-guide.md            # O&A YANG naming conventions, revision policy
│   ├── adr-index.md                   # Links to relevant ADRs (repo pattern, error schema)
│   └── pr-checklist.md                # What reviewers will check (same as governance/team-norms.md)
│
├── tmf/
│   ├── TMF639_Resource_Inventory_Management_v4.0.0.yaml
│   ├── TMF638_Service_Inventory_Management_v4.0.0.yaml
│   ├── TMF641_Service_Ordering_v4.0.0.yaml
│   └── error_schema.md                # TM Forum standard error response format
│
├── yang/
│   ├── ietf-interfaces@2018-02-20.yang
│   ├── ietf-ip@2018-02-22.yang
│   ├── o-and-a-service-types.yang     # Our internal base YANG types
│   └── yang-patterns.md               # Preferred YANG grouping and augmentation patterns
│
├── examples/
│   ├── tmf638_service_inventory.py    # Reference implementation — repository pattern
│   ├── netconf_session_example.py     # Session pool usage, async wrapper pattern
│   ├── nso_service_template.xml       # NSO service template structure we follow
│   └── pytest_fixtures.py             # Standard test fixture patterns
│
├── enums.py                           # Shared enums — ResourceStatus, ServiceStatus, etc.
├── logging_config.py                  # structlog configuration
├── exceptions.py                      # Domain exception hierarchy
└── middleware/
    └── auth.py                        # Auth middleware — never regenerate, only reference
```

### From `context/` to MCP

The `context/` directory pattern is the manual version of a more structured approach: **Model Context Protocol (MCP)**. MCP is an open protocol (introduced by Anthropic and now supported across major AI tooling including GitHub Copilot) that allows AI tools to query structured context sources — internal documentation, code repositories, runbooks, API specifications — at prompt time rather than relying on embedded context files.

For O&A at scale, MCP represents the path from "each developer maintains their own context directory" to "the team's AI tooling automatically has access to current TM Forum API versions, current ADRs, and current coding standards." The `context/` directory approach and MCP are not in competition — the directory is the stepping stone to the protocol.

---

## Section 5 — The 30–40% Rule

### The Common Objection

The most frequent objection to spec-driven AI development is: "Why spend 30–40% of project time writing a spec when I could just start prompting and iterate?" This objection treats spec writing as overhead — time spent before "real work" begins.

Osmani's answer reframes the question. The spec writing **is** the real work. The implementation is the mechanical consequence of having done the design work properly. Without a spec:

- The first AI prompt produces something that mostly works but misses 3 constraints you didn't think to mention
- You iterate with follow-up prompts, each partially fixing the previous output
- By the 5th iteration, the code is internally inconsistent because each prompt fixed one thing while silently changing another
- You either abandon the output and start over, or you accept code you don't fully trust

!!! tip "The 30-40% rule"
    Osmani's research and practitioner reports consistently show: time invested in spec writing at the start of a task is recovered in the first iteration. The spec does not slow you down — prompt-and-iterate without a spec slows you down, invisibly, by spreading rework across the back half of the task.

### Time Budget Comparison

The following table compares spec-first vs. prompt-and-iterate for a representative O&A task: implementing a TMF639 GET endpoint with repository pattern, Pydantic v2 validation, and a pytest suite.

Assume a baseline estimate of **1 day (8 hours)** for an engineer doing this without AI.

| Phase | Prompt-and-iterate | Spec-first |
|---|---|---|
| Understand requirements | 30 min | 30 min |
| Write spec file | — | 90 min |
| Initial AI prompt | 15 min | 15 min |
| First AI output review | 45 min (likely needs revision) | 20 min (fits spec) |
| Iteration / rework rounds | 90 min (2–3 rounds typical) | 20 min (minor tweaks) |
| Integration into codebase | 45 min (mismatches with patterns) | 15 min (follows patterns) |
| Test generation and fixes | 45 min | 20 min |
| Code review (senior) | 60 min (reviewer also discovering issues) | 30 min (spec is the review checklist) |
| **Total** | **~5.5 hours** | **~4.0 hours** |
| **Reusable spec for next task** | ❌ | ✅ (spec becomes context for next endpoint) |

The spec-first approach is faster even accounting for spec writing time — and it produces a spec artefact that reduces the cost of every subsequent similar task.

---

## Section 6 — Token Efficiency

### The Token Waste Problem

Every AI inference call consumes tokens. Tokens cost money (in API-based tools) and time (in all tools). More importantly for O&A, tokens represent a proxy for energy consumption — a point we will return to.

When a prompt is vague, the LLM spends tokens doing work that the developer should have done:

- **Architectural decision tokens:** "Should I use a repository pattern or put the DB logic in the router? Training data suggests both approaches are common..." — tokens spent reaching a conclusion you should have specified.
- **Library selection tokens:** "What NETCONF library should I use? ncclient is most common, but paramiko with netconf-client is also popular..." — tokens spent selecting a library you already know.
- **Style decision tokens:** "Should I use type hints? The codebase uses them in some files but not others..." — tokens spent making a consistency call you should have codified.

> *"Being explicit with what you want and defining the architecture avoids wasting tokens — you're not leaving it to the LLM to figure things out on its own."*
> — Addy Osmani

These are not hypothetical token costs. In a frontier LLM context window, reasoning through ambiguous architectural choices can consume hundreds to thousands of tokens before any implementation begins. At scale — multiple developers, multiple prompts per day, multiple AI tool calls per prompt — this is a material cost.

### The SCI (Software Carbon Intensity) Angle

The [Responsible AI: Environmental](../responsible-ai/environmental.md) section of this framework introduces the **SCI metric** from the Green Software Foundation. SCI = (E × I) + M — where E is energy consumption per functional unit, I is carbon intensity of the grid, and M is embodied hardware carbon.

Wasted tokens are wasted energy. Every token the LLM spends resolving ambiguity you should have eliminated in the spec is a token burning compute energy. For an O&A team tracking SCI as a responsible engineering metric, spec-driven development is not just a quality practice — it is a carbon efficiency practice.

!!! info "O&A context"
    O&A's responsible AI commitment includes tracking Software Carbon Intensity per sprint. Spec-driven development is one of the highest-leverage levers for reducing SCI in AI-assisted workflows — more impactful than model selection for most tasks, because it directly reduces the number of inference calls and tokens required to produce a usable output.

### Why AI Favours Lowest-Common-Denominator Patterns

The mechanism behind token waste is worth understanding explicitly. AI models are trained on vast corpora of text and code. When a prompt is vague, the model generates a completion that maximises the probability of the next token given the distribution of training data. This is, by definition, the **most average** response — the response most consistent with the widest range of training examples.

For general-purpose code, average is sometimes fine. For O&A code, average is almost always wrong: we need async Python (not sync), Pydantic v2 (not v1), ncclient with host key verification (not the insecure quick-start example), TM Forum-aligned error responses (not ad-hoc JSON), and YANG models following our internal naming conventions (not RFC example modules). None of these are average. All of them must be specified explicitly.

---

## Section 7 — Quality Bar and Human-in-the-Loop

### The Velocity–Quality Balance

One of Osmani's most important warnings is about the **velocity trap**: AI tools dramatically increase the rate at which code is produced. This is the point of using them. But increased velocity without increased review rigour produces a codebase that is larger, more complex, and harder to maintain than the one it replaced — even if individual AI-generated functions are locally correct.

> *"In the age of AI-generated code, teams must maintain a strict quality bar. Senior team members need to balance increased velocity with the need for thorough code review, ensuring that AI-generated code is maintainable and utilising human-in-the-loop processes when necessary."*
> — Addy Osmani

This connects to Nicole Forsgren's **SPACE framework** — specifically the distinction between Activity and Quality as separate productivity dimensions. AI adoption that improves Activity (lines of code, PRs merged, features shipped) while degrading Quality (change failure rate, code maintainability, test coverage) is not productivity improvement. It is technical debt generation at AI speed.

It also connects to Dave Farley's treatment of the **deployment pipeline as quality gate**. Farley's central argument in *Continuous Delivery* is that the pipeline is not a deployment mechanism — it is a quality assurance mechanism. Every AI-generated artefact must pass the same pipeline gates as human-written code. There are no exceptions.

The [CI/CD Pipeline foundations](../msd-foundations/cicd-pipeline.md) document and the [Team Norms PR checklist](../governance/team-norms.md) codify these gates for O&A. Spec-driven development does not replace those gates — it makes them faster to pass by ensuring the code arriving at the gate was generated against the right requirements.

### The Spec Review Checklist

Before handing a spec to an AI tool, a senior team member (or the author, critically self-reviewing) should verify:

- [ ] **Stack is explicit:** Every library and version named. No categories like "use a database ORM" — name the ORM, the version, the session management pattern.
- [ ] **Constraints are negative:** The spec includes "do NOT" statements for the most common bad defaults in this domain (e.g., `hostkey_verify=False`, `Any` type, synchronous ncclient calls in async context).
- [ ] **Success criteria are testable:** Each criterion maps to a specific test case name or assertion. "Works correctly" is not a success criterion. "Returns 200 with valid TMF639 Resource JSON for a known UUID" is.
- [ ] **TMF/YANG references are explicit:** If the output must conform to a standard, the spec names the standard, the version, and the specific schema element. The standard document is in `context/`.
- [ ] **Architecture pattern is linked:** The spec references a specific existing file in the codebase as the pattern to follow. "Follow our patterns" is not enough — link the file.
- [ ] **Scope is bounded:** The spec has an "Explicit Exclusions" section. Without explicit scope limits, AI tools eagerly generate adjacent functionality that does not belong in the current task.
- [ ] **Context directory is current:** The files in `context/` referenced by the spec actually exist and are up to date. An outdated TMF schema in `context/` produces code conforming to the wrong version.
- [ ] **The spec is reviewable by a human:** A senior team member reading the spec should be able to verify the resulting code without deep AI knowledge. The spec is the requirements document; the code is the artefact to verify against it.
- [ ] **Responsible AI considerations noted:** If the task involves Tier 2 data (customer-adjacent, device configs), the spec notes which AI tool tier is appropriate (see [Privacy](../responsible-ai/privacy.md)).
- [ ] **Owner is named:** The spec identifies who is responsible for reviewing the AI output and accepting it into the codebase.

---

## Section 8 — Codifying Best Practices (MCP / Markdown Context)

### From Individual Knowledge to Machine-Readable Standards

One of the highest-leverage uses of the spec-driven approach is **codifying team standards into machine-readable context**. When an O&A engineer knows "we use structlog, not print statements, and we follow the repository pattern" — that knowledge exists in their head and in informal team norms. When it is written into a Markdown file that every AI tool prompt references, it becomes enforceable at every AI-assisted code generation event.

> *"Codifying team best practices for architecture into your context — either via a system like MCP or through Markdown files — improves the chances that the AI-generated code can actually be used by the team rather than being thrown away."*
> — Addy Osmani

The progression of codification options, from simplest to most powerful:

1. **Markdown files in `context/`** — referenced manually in spec files; works with any AI tool; maintainable by any team member
2. **`.github/copilot-instructions.md`** — read automatically by GitHub Copilot for every prompt in the repository; the lowest-friction way to enforce standards in the IDE
3. **MCP (Model Context Protocol) servers** — expose structured context (internal docs, current API specs, ADRs) to AI tools at query time; the scalable, team-wide version of the `context/` pattern

### O&A Copilot Instructions File

The following is an example `.github/copilot-instructions.md` for the O&A team. This file is read automatically by GitHub Copilot (and compatible tools) and injected into every prompt context, ensuring that AI suggestions in the IDE align with team standards without the developer having to repeat the constraints in every prompt.

```markdown
# O&A Team — GitHub Copilot Instructions

## Language and Runtime
- Python 3.11+. All functions must have type hints including return types.
- No `Any` type. No `# type: ignore` without an accompanying comment explaining why.
- Async-first: use `async def` and `await` for all I/O operations.
- Use `asyncio.run_in_executor` to wrap synchronous third-party I/O (e.g. ncclient).

## Libraries and Frameworks
- FastAPI for HTTP APIs (not Flask, not Django)
- Pydantic v2 for data validation — use `model_config`, not `class Config`
- SQLAlchemy 2.0 async ORM for database access
- ncclient 0.6.x for NETCONF — ALWAYS set `hostkey_verify=True`
- structlog for logging — never use `print()` or the standard `logging` module directly
- httpx for async HTTP client — never use `requests` in async context
- pytest + pytest-asyncio for tests

## Architecture Patterns
- Follow the repository pattern: router → service → repository → ORM model
- Never put database logic in routers or service classes
- Domain exceptions in `src/exceptions.py` — never raise raw HTTPException from service layer
- TM Forum error responses: use the TMF Error schema (see context/tmf/error_schema.md)

## YANG and Network Automation
- YANG modules must follow O&A naming convention: `o-and-a-<domain>@<date>.yang`
- Use IETF standard types from `ietf-inet-types`, `ietf-yang-types` — do not reinvent
- NETCONF filter XML must be subtree filters unless XPath is explicitly required
- NSO service templates: follow the pattern in `context/examples/nso_service_template.xml`

## TM Forum Open APIs
- All API responses must conform to the relevant TMF Open API schema (see `context/tmf/`)
- `resourceStatus` values: `standby`, `alarm`, `available`, `reserved`, `unknown`, `suspended`
- Do NOT invent new fields — reference the schema YAML for required and optional fields

## Security
- Never hardcode credentials — use environment variables or the secrets manager
- `hostkey_verify=False` is NEVER acceptable in any code targeting production
- No `shell=True` in subprocess calls

## Testing
- Every new function must have at least one test
- Use `pytest.mark.asyncio` for async tests
- Fixtures in `conftest.py` — do not duplicate fixture setup across test files
- Mock external I/O (NETCONF sessions, HTTP calls) — tests must pass without network access
```

This file alone eliminates the most common categories of unusable AI-generated output for O&A tasks — before the developer writes a single word of spec.

---

## Section 9 — Integration with O&A Workflow

### Where Spec-Driven Development Fits in the Adoption Stages

The [Adoption Roadmap](../adoption-roadmap.md) describes five stages: Aware → Experimenting → Practicing → Scaling → Optimizing. Spec-driven development practices map to the transition from **Experimenting to Practicing** — specifically the point at which individual developers move from ad-hoc prompting to a disciplined, repeatable approach to AI-assisted development.

| Stage | Spec-Driven Practice |
|---|---|
| **Aware (1)** | Understand why vague prompts produce vague results; read this document |
| **Experimenting (2)** | Try spec-first on one task; compare output quality with ad-hoc prompting |
| **Practicing (3)** | Spec files required for AI-assisted tasks; `context/` directory established per-repository; Copilot instructions committed |
| **Scaling (4)** | Team spec templates in shared repository; MCP server exposing current TMF/YANG context; spec review in PR checklist |
| **Optimizing (5)** | SCI tracking includes token efficiency metrics; spec quality reviewed retrospectively; MCP context auto-updated from published TM Forum releases |

### The O&A Spec-Driven Flow

The following ASCII diagram shows the end-to-end flow from task to production when spec-driven development is applied:

```
  ┌─────────────────────────────────────────────────────────────────┐
  │                     SPEC-DRIVEN AI FLOW                         │
  └─────────────────────────────────────────────────────────────────┘

  Task / Ticket
       │
       ▼
  ┌──────────────┐     30-40% of estimated task time
  │  Spec File   │ ◄── Constraints, success criteria, stack, exclusions
  └──────┬───────┘     Reviewed by senior team member before prompting
         │
         ▼
  ┌──────────────┐     context/ or .ai/ directory
  │ Context Dir  │ ◄── TMF specs, YANG modules, coding standards,
  └──────┬───────┘     example patterns, ADR links
         │
         ▼
  ┌──────────────┐     Copilot, Claude, ChatGPT, custom pipeline
  │  AI Prompt   │ ◄── Spec + context provided; no ambiguous intent
  └──────┬───────┘
         │
         ▼
  ┌──────────────┐     Human-in-the-loop
  │   Review     │ ◄── Verify against spec checklist (Section 7)
  └──────┬───────┘     Senior review for architecture-touching changes
         │
         ▼
  ┌──────────────┐     Commit stage: lint, type check, unit tests
  │  Pipeline    │ ◄── Integration stage: contract tests, YANG validation
  │   Gates      │     Farley's quality gate — no exceptions for AI output
  └──────┬───────┘
         │
         ▼
  ┌──────────────┐
  │  Production  │
  └──────────────┘
```

No shortcut exists in this flow. The spec is not optional. The context is not optional. The pipeline gates are not optional. The value of AI tools is realised in reduced time within each stage — not by eliminating stages.

---

## Section 10 — Quick Reference

### Spec-Driven AI Checklist

Before prompting any AI tool for O&A implementation work:

- [ ] **Write a spec file** — constraints, success criteria, stack, patterns, exclusions
- [ ] **Populate `context/`** — TMF schemas, YANG modules, example code, coding standards
- [ ] **Check `.github/copilot-instructions.md`** — is it current? Does it reflect latest ADRs?
- [ ] **Bound the scope** — explicit exclusions section in the spec; no open-ended tasks
- [ ] **Name the pattern** — link to a specific existing file the AI should follow
- [ ] **Get spec reviewed** — senior team member checks against the Spec Review Checklist in Section 7 before prompting
- [ ] **Verify AI output against spec** — every success criterion checked manually or by test
- [ ] **Pass pipeline gates** — AI output goes through the same CI/CD pipeline as human-written code

### Anti-Patterns

| Anti-pattern | Why it fails | Instead |
|---|---|---|
| **Vague task description** ("write a NETCONF client") | LLM defaults to lowest-common-denominator training data; misses team standards | Write a spec file with explicit stack, constraints, and success criteria |
| **Letting the LLM choose the library** ("use an appropriate HTTP library") | LLM will choose whatever is most popular in training data, not what the team uses | Name the exact library and version in the spec: "httpx 0.27.x — not requests" |
| **No context directory** (raw prompt, no reference files) | LLM has no way to follow team patterns; generates generic code that doesn't fit the codebase | Provide `context/` with example patterns, coding standards, and relevant API schemas |
| **Iterating without a spec** (prompt → tweak → prompt → tweak) | Each iteration fixes one constraint while silently introducing inconsistencies; output quality degrades over iterations | Write the spec first; the first prompt output should be close to final |
| **Skipping pipeline gates for AI output** ("it looked fine in the review") | AI-generated code contains subtle type errors, missing edge cases, and security defaults that automated gates catch reliably | AI output goes through the full CI/CD pipeline — lint, type check, tests, YANG validation — without exception |

### One-Line Summary

> **Osmani's framework in one sentence:** Treat AI tools as fast, capable engineers working from your spec — invest 30–40% of task time writing that spec, provide a context directory so the AI has the information it needs, and maintain the same quality gates you would apply to any engineer's output.

---

## Further Reading

- [TM Forum Spec-First Workflow](../tmforum/spec-first.md) — spec-first development at the API contract layer
- [AI Tool Landscape](index.md) — overview of O&A AI tools and where spec-driven development applies to each
- [Team Norms & PR Checklist](../governance/team-norms.md) — the quality gates that AI output must pass
- [Environmental Responsibility](../responsible-ai/environmental.md) — SCI metrics and token efficiency
- [SPACE Framework](../measurement/space-framework.md) — measuring quality alongside velocity
- [CI/CD Pipeline Foundations](../msd-foundations/cicd-pipeline.md) — Farley's pipeline as quality gate
- [Adoption Roadmap](../adoption-roadmap.md) — where spec-driven practices fit in the O&A maturity journey
