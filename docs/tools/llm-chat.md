# LLM Chat Tools Playbook — O&A Team

> **Applies to:** ChatGPT (GPT-4o), Claude (3.5 / 3.7), Gemini (1.5 / 2.0)  
> **Audience:** O&A team members (10–30), Python/Go, YANG/NETCONF, Ansible, NSO, TM Forum Open APIs  
> **Last reviewed:** 2025

---

## What LLM Chat Is Good For in O&A

LLM chat tools follow the **jagged frontier** pattern (Mollick): they are not uniformly good or bad — they
excel at some tasks and fail silently on others. Know where the edge is before you rely on the output.

| Strength | Medium | Weak |
|---|---|---|
| Reasoning over long text (RFCs, specs, ADRs) | Code generation for well-scoped tasks | Real-time or live network state |
| Summarisation of incident timelines or change logs | Explaining unfamiliar YANG / library patterns | Proprietary vendor CLI edge cases |
| Q&A over documentation you paste in | Drafting runbooks from a described scenario | RFC normative edge cases without verification |
| Trade-off analysis and ADR drafting | TM Forum API selection (verify the result) | Anything requiring current topology or CDB data |
| Explaining unfamiliar technology (gNMI, gRPC-tunnel, SR policies) | | Security decisions ("is this safe?") |

**Rule of thumb:** if the task requires data you cannot paste in (live network state, real configs), use a
different tool. If the output would go directly to production without human review, use a different tool.

---

## The Privacy Rule

> **⚠️ CRITICAL — read this before your first prompt.**

### Never paste

- Real network device configurations (running, candidate, or startup)
- IP addressing schemes, subnets, VLAN assignments from live environments
- Customer topology diagrams or customer-identifying information
- Device credentials, API keys, or tokens of any kind
- NSO CDB exports or NED packages containing customer data
- Incident tickets that contain customer names, circuit IDs, or site names
- Internal hostnames, FQDNs, or management IP ranges
- Security policies, ACLs, or firewall rule sets from production

### Always use instead

- RFC 5737 documentation addresses: `192.0.2.x`, `198.51.100.x`, `203.0.113.x`
- RFC 3849 documentation IPv6 prefix: `2001:db8::/32`
- Placeholder hostnames: `router01.example.com`, `pe01.dc-north.example.com`
- Generic AS numbers: `64496`–`64511` (RFC 5398 documentation range)
- Anonymised log snippets with timestamps preserved but device names replaced

### Enterprise accounts required

| Tool | Required tier | Do NOT use |
|---|---|---|
| ChatGPT | Teams or Enterprise | Personal / free / Plus with no enterprise data agreement |
| Claude | Claude.ai Teams or API with DPA | Personal claude.ai accounts |
| Gemini | Google Workspace (Gemini for Workspace) | Personal Google accounts |

**Why this matters:** consumer-tier accounts may use your inputs for model training. Enterprise agreements
typically include a data processing addendum (DPA) and opt-out of training on customer inputs. Even with
enterprise accounts, treat every prompt as potentially logged — because it is.

---

## Tool Selection Guide

| Task | Best choice | Why |
|---|---|---|
| Large YANG file (>500 lines) or full RFC section | Claude 3.5/3.7 (200K context) or Gemini 1.5/2.0 (1M context) | GPT-4o context window is limiting for large inputs |
| Code generation, Python or Go | ChatGPT (GPT-4o) or Claude 3.5 Sonnet | Strong code benchmarks; note: Copilot in IDE is better for code with full repo context |
| Multimodal input (network diagram, architecture image) | ChatGPT (GPT-4o) or Gemini | Both accept image uploads |
| ADR drafting, trade-off reasoning | Claude 3.7 Sonnet | Strong structured reasoning |
| TM Forum API selection | Any; always verify the output | Results degrade for less-cited APIs |
| RFC / standard interpretation | Claude or GPT-4o; always verify | See anti-patterns |
| Quick summarisation | Any | Task is forgiving; use what is open |

---

## Core O&A Use Cases with Prompt Templates

### Use Case 1: Incident Timeline Summarisation

**Context:** you have exported a long incident timeline from your monitoring or ticketing system and need a
structured summary for the incident report.

**Privacy step — required before pasting:**

```text
sed -i \
  -e 's/pe01\.corp\.example\.net/pe01.example.com/g' \
  -e 's/10\.0\./192.0.2./g' \
  timeline.txt
```

Replace all real device names, IPs, and customer references before pasting.

**Prompt template:**

```
You are helping analyse a network incident for an internal post-incident review.
I will provide a sanitised timeline of events. All device names and IPs are anonymised.

Summarise the following:
1. When the incident started and was detected
2. What services or network elements were affected
3. The sequence of diagnostic steps taken, in order
4. What action resolved the incident
5. Any potential contributing factors visible in the timeline

Do NOT speculate about root cause beyond what is documented.
Do NOT add recommendations — this is a summary only.

Timeline:
[SANITISED TIMELINE]
```

**What to do with the output:** use as a first draft for Section 2 of the incident report template.
Validate every factual claim against the original timeline before publishing.

---

### Use Case 2: YANG Module Explanation

**Context:** you have inherited or received an unfamiliar YANG module and need to understand it before
writing service models or NEDs against it.

**Prompt template:**

```
You are an expert in YANG data modelling (RFC 7950) and NETCONF (RFC 6241).
I will paste a YANG module. Please:

1. Explain what network resource or function this module models
2. Describe the key data nodes (containers, lists, and leaves) and their purpose
3. Identify important constraints — must/when/unique expressions — and what they enforce
4. Note any deviations from standard YANG patterns that I should be aware of
5. Suggest what NETCONF operations (<get>, <get-config>, <edit-config>, RPC) would be
   used to interact with this data model

YANG module:
[PASTE YANG HERE]
```

**Tip:** for modules over 300 lines, use Claude or Gemini. Paste the module verbatim — pyang formatting
is fine. Follow up with: *"Which leaves would I need to set to provision a new [service type]?"*

---

### Use Case 3: ADR Drafting

**Context:** the team needs an Architectural Decision Record for a significant technical choice. Use chat
to produce a first draft quickly, then iterate in the team.

**Prompt template:**

```
Help me draft an Architectural Decision Record (ADR) for the following decision in a
telecom network automation team.

Context: [describe the situation and the problem being solved]
Decision we are considering: [state the decision clearly]
Alternatives we have considered: [list 2–4 alternatives]

Please draft:
1. A Context section explaining the problem and why a decision is needed now
2. A Decision statement (one sentence, active voice)
3. Rationale: pros and cons of the chosen option
4. A table of alternatives considered and the reason each was not chosen
5. Consequences: expected positive and negative outcomes

Format as Markdown. Use plain language — avoid marketing phrases.

Note: I will review and take ownership of this ADR. Your draft is a starting point.
```

**After the draft:** circulate to 2–3 team members before merging. The AI will not know your constraints
around vendor support contracts, existing NED licences, or team skill gaps — add those manually.

---

### Use Case 4: TM Forum API Selection Assistance

**Context:** you are designing a new integration and need to identify which TM Forum Open API to implement
against before writing code.

**Prompt template:**

```
I am building a feature for a telecom network automation system.
I need to integrate with [describe the capability in plain language].

Which TM Forum Open API (from the TM Forum Open API table) is most relevant?
For the top 1–2 matches:
- API name and TMF number
- Key resources and endpoints relevant to my use case
- Typical request/response patterns for my scenario
- Known implementation pitfalls

My use case:
[describe in plain English — what data flows in, what flows out, who calls whom]
```

> **⚠️ Mandatory follow-up:** verify the AI's API suggestion against the
> [TM Forum Open API table](https://www.tmforum.org/oda/open-apis/table/) before writing code.
> LLMs have good coverage of TMF620, TMF622, TMF639, TMF641, TMF642, and TMF645 but degrade on
> less-cited APIs. Do not assume the suggested endpoint paths are correct — download the spec YAML.

---

### Use Case 5: Code Review Pre-Screening

**Context:** before requesting a human code review, use LLM chat to catch obvious issues early. This is
a *pre-screening aid*, not a replacement for human review or SAST tooling.

**Privacy step:** remove all internal hostnames, credentials, and real IP addresses before pasting.

**Prompt template:**

```
Review this [Python / Go / YANG] code for a network automation service.

Check only for:
1. Security issues: hardcoded credentials, missing error handling, unsafe input handling,
   shell injection risks in subprocess calls
2. Correctness: obvious logic errors, off-by-one errors, incorrect API usage, missing null
   checks, incorrect NETCONF operation ordering
3. YANG-specific (if applicable): RFC 7950 compliance issues, incorrect xpath expressions,
   missing mandatory statements
4. Missing edge cases: what inputs or network states could cause this to fail silently?

Do NOT suggest style changes, naming conventions, or formatting improvements.
Focus only on correctness and security.

Code:
[SANITISED CODE]
```

**After review:** findings should be treated as hints, not verdicts. Run SAST (Bandit for Python,
gosec for Go) independently. Human reviewers own the final decision.

---

### Use Case 6: Runbook Generation

**Context:** you need a first-draft operational runbook for a known failure scenario. Chat is effective
here because the structure is predictable and the domain is well-described.

**Prompt template:**

```
Generate a network operations runbook for the following scenario in a telecom environment.
Use generic anonymised infrastructure references — not real device names or IPs.

Scenario: [describe the operational scenario, e.g., "NETCONF session failure between
NSO and a managed PE router during a scheduled maintenance window"]

Include the following sections:
1. Symptoms — what the on-call team member will observe
2. Initial diagnosis steps — ordered, numbered, with expected outputs
3. Escalation criteria — when to escalate and to whom
4. Resolution steps — ordered, numbered
5. Verification steps — how to confirm the incident is resolved
6. Rollback procedure — if the resolution made things worse

Format as a numbered step-by-step procedure suitable for an on-call team member with
intermediate NETCONF and NSO knowledge.
```

**After generation:** replace generic placeholders with your actual device naming conventions, NSO
group names, and escalation contacts. Add to the runbook repository and tag for review by a senior team member.

---

### Use Case 7: RFC / Standard Interpretation Q&A

**Context:** you need to understand a specific normative requirement in an RFC or TM Forum standard
before implementing it.

**Best practice:** paste only the relevant section, not the entire RFC. Ask specific questions.

**Prompt template:**

```
I am implementing [feature] based on [RFC XXXX / TM Forum standard name and version].
Here is the relevant section:

[PASTE SECTION — include the section number and title]

Question: [specific question about normative interpretation or implementation detail]

Please explain:
1. What this section requires (MUST statements)
2. What it permits but does not require (SHOULD / MAY statements)
3. What a correct implementation looks like in practice
4. Common implementation mistakes for this requirement
```

> **⚠️ Warning:** LLMs can misread normative language. A model may paraphrase a SHOULD as a MUST or
> omit a condition on a MAY. Always validate the AI's interpretation against the actual RFC text.
> For NETCONF, the authoritative sources are RFC 6241, RFC 6242, RFC 7950, and RFC 8526.

---

## Anti-Patterns

These are the most common misuses observed in engineering teams. Each one creates real risk.

### 1. Pasting real network configurations

**What happens:** team members paste a real router config to get a "better" answer.  
**Risk:** customer topology, addressing, and service design enters an external system.  
**Fix:** always sanitise first. A sanitised example gives 95% of the answer quality with zero exposure.

### 2. Using personal or free-tier accounts for work queries

**What happens:** an team member uses their personal ChatGPT or Claude account because it is convenient.  
**Risk:** no data processing agreement; inputs may be used for model training; violates most enterprise
security policies.  
**Fix:** use only team/enterprise accounts provisioned by IT. Bookmark the enterprise login URL.

### 3. Accepting AI RFC interpretation without reading the RFC

**What happens:** an team member asks "does RFC 6241 require X?" and implements based on the AI's yes/no.  
**Risk:** LLMs can be confidently wrong on normative details, especially for less-cited RFCs.  
**Fix:** use the AI output to locate the relevant RFC section, then read the section yourself.

### 4. Using chat output as final code without IDE-context review

**What happens:** a code snippet from chat is pasted directly into the codebase without further review.  
**Risk:** the snippet has no knowledge of your existing abstractions, error handling patterns, or
internal library APIs. It will likely introduce inconsistencies or bugs.  
**Fix:** use Copilot in the IDE for code tasks — it has repository context. Treat chat code as a sketch.

### 5. Asking the AI to make security decisions

**What happens:** an team member asks "is it safe to do X?" and proceeds if the AI says yes.  
**Risk:** the AI does not know your threat model, network exposure, or compliance requirements.  
**Fix:** security decisions require a human reviewer with context. Use the AI to enumerate concerns,
not to approve an approach.

### 6. Using chat to select TM Forum APIs without verifying the spec

**What happens:** team member implements against an API path suggested by the AI without checking the YAML.  
**Risk:** the AI may suggest an API that exists but with incorrect resource paths, or a deprecated version.  
**Fix:** download the spec YAML from tmforum.org and verify every endpoint before writing client code.

### 7. Treating chat output as peer-reviewed documentation

**What happens:** AI-generated runbook or ADR content is merged without checking factual claims.  
**Risk:** incorrect escalation paths, wrong verification commands, or missing rollback steps in production
runbooks.  
**Fix:** every AI-generated document must be reviewed and signed off by a team member before merging.

---

## The Model-Agnostic Prompt Principle

Design prompts to work across ChatGPT, Claude, and Gemini. This avoids vendor lock-in at the prompt
level and supports the market concentration strategy documented in
`docs/responsible-ai/market-concentration.md`.

**Practical guidance:**

- **Be explicit and structured.** Number your instructions. Do not rely on one model's implicit
  understanding of "do it in the usual way". State the format you want.
- **Test critical prompts on two models.** If the outputs differ dramatically, the prompt is under-specified.
  Add constraints until both models give usable output.
- **Avoid model-specific syntax.** Do not use ChatGPT's `---` separator style or Claude's `<document>`
  XML tags in your canonical prompt templates unless you are running on that model specifically.
- **Version prompts in git.** Store canonical prompt templates in `docs/prompts/`. Treat them as code —
  review changes, track authors, test before merging.

**Why this matters operationally:** if your team's workflow is locked to one model's quirks and that model
changes its behaviour (which all models do, without notice), your whole prompt library breaks. Model-agnostic
prompts are more resilient.

---

*For pipeline automation of the tasks above, see `docs/tools/custom-pipelines.md`.*  
*For responsible AI principles, see `docs/responsible-ai/`.*
