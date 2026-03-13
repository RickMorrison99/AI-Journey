# Team Norms — How We Work With AI

> This is our living operating agreement for AI usage on the O&A team. It's not a compliance document — it's a set of shared commitments we made together and revisit regularly. If something here isn't working, raise it in retro.

---

## Our Shared Commitments

These are the things we've agreed on as a team. They inform how we work, how we review each other's work, and how we talk about AI openly.

1. **We review AI output as critically as we review each other's code.** The fact that a tool generated something doesn't make it correct, secure, or idiomatic. Our names go on the commit.

2. **We share what works — prompt templates belong in the team repo, not on individual laptops.** If a prompt saved you an hour, it can save everyone an hour. Hoarding is waste.

3. **We say when AI got it wrong, without embarrassment.** "The AI generated this and it was completely wrong because..." is one of the most valuable things you can share with the team. Silence about failures leads to repeated failures.

4. **We do not include customer data, live network configs, or credentials in AI prompts.** Ever. No exceptions. If you're unsure whether something is safe to include, assume it isn't and ask.

5. **We own the output.** If AI-generated code is merged, the author owns it — for correctness, for maintenance, for incidents. "The AI wrote it" is not a valid response in a postmortem.

6. **We don't gate people out of AI tools, and we don't pressure people into them.** Adoption should be driven by genuine usefulness. If AI doesn't help you on a given task, don't use it.

7. **We treat AI literacy as a team skill, not a personal competitive advantage.** Growing together is the goal.

---

## The AI Champion Role

### What It Is

Each squad has one **AI Champion** — an team member who takes a leadership role in the squad's AI adoption. This isn't a separate job title. It's a responsibility that sits alongside your normal engineering work, takes roughly 1–2 hours per week, and rotates annually.

The AI Champion is **not** a productivity monitor, a gatekeeper who approves AI tool usage, or an extra reporting burden with no recognition. It's a growth opportunity that builds visible AI leadership skills.

### Responsibilities

| Responsibility | Detail |
|---|---|
| **Maintains the squad prompt library** | Keeps `prompts/[squad]/` organised, reviews prompt PRs, retires outdated prompts |
| **Runs monthly AI retro questions** | Adds the five standard questions (see below) to the team retro and facilitates discussion |
| **Attends cross-squad AI Champion sync** | Monthly 45-minute sync across all squad AI Champions and the O&A engineering lead |
| **First point of contact for "should I use AI for this?"** | When someone is unsure whether a task is a good AI candidate, the AI Champion is the go-to, not management |
| **Reports squad AI adoption metrics** | Tracks the SPACE-A dimension — adoption breadth, task types, and friction points — and shares a short monthly summary |

### How to Become One

Volunteer at any time by posting in `#noa-ai-adoption` or nominating yourself (or a willing colleague) to your engineering lead. Appointments rotate annually. There's no requirement to be the most experienced AI user on the squad — curiosity and communication skills matter more than expertise.

### Why It's Worth It

AI Champions are visible to engineering management as builders of team capability. The role is logged in your development record and cited in promotion conversations as evidence of technical leadership and knowledge-sharing.

---

## PR Review Checklist for AI-Assisted Code

Add this section to the team's PR template. Authors complete it for any PR where AI tools contributed to the implementation, test generation, or spec authoring.

```markdown
## AI-Assisted Code Review Checklist
(Complete for any PR where AI tools were used)

### Engineering Principles
- [ ] DRY: Does this PR introduce code duplication that should be a shared utility?
- [ ] SoC: Does this PR respect existing service/module boundaries?
- [ ] API-first: If this is a new integration, was TM Forum Open API checked first?
- [ ] Spec: If this adds a new API endpoint, was the OpenAPI/YANG spec written before implementation?

### Quality Gates
- [ ] All AI-generated code is covered by tests
- [ ] SAST scan passed (no new high/critical findings)
- [ ] No hardcoded credentials or IP addresses
- [ ] Dependency changes reviewed (no AI-suggested packages added without security review)

### Responsible AI
- [ ] No customer data, network configs, or credentials were included in prompts
- [ ] AI-generated YANG (if any) validated with pyang/yanglint
- [ ] Agentic tool output reviewed for scope violations (did it modify things it shouldn't have?)

### For the Author
- [ ] I have reviewed all AI-generated code line by line — I own it, not the AI
- [ ] AI tool(s) used: [list them]
- [ ] Anything about this AI-assisted code that reviewers should pay extra attention to: [notes]
```

**Reviewer guidance:** If the "For the Author" section is blank on a PR that clearly used AI tooling, ask the author to complete it before approving. This isn't bureaucracy — it's the minimum due diligence that makes AI assistance safe at scale.

---

## Prompt Template Library

### Where It Lives

All shared prompt templates live in the team repository under:

```
~/noa-ai-adoption/prompts/
```

Organised by category (see below). Squad-specific prompts live in a subdirectory:

```
~/noa-ai-adoption/prompts/squads/[squad-name]/
```

### How to Contribute

1. Write your prompt using the header template below.
2. Save it with a descriptive filename: `[category]-[short-description].md`  
   Example: `yang-authoring-service-interface-module.md`
3. Open a PR to the `prompts/` directory — one prompt per PR is preferred.
4. Your squad AI Champion reviews and merges.

**Filename convention:** `[category]-[kebab-case-description].md`  
Categories: `yang-authoring`, `test-generation`, `code-review`, `incident-triage`, `documentation`, `api-client-generation`, `config-generation`

### Prompt Header Template

Every prompt file must start with this header:

```
# Prompt: [Short Name]
# Use case: [What this prompt is for]
# Tool: [GitHub Copilot / ChatGPT / Claude / etc.]
# Tested: [Yes/No] [Date last validated]
# Author: [GitHub handle]
# Notes: [Any caveats, limitations, or gotchas]
---
[PROMPT TEXT BELOW]
```

**Example:**

```
# Prompt: YANG Service Interface Scaffold
# Use case: Generates a YANG module skeleton for a new TMF-aligned service interface
# Tool: GitHub Copilot Chat / Claude
# Tested: Yes 2025-01-15
# Author: @eng-handle
# Notes: Always validate output with pyang before treating as canonical.
#        Model tends to hallucinate namespace URIs — verify against TMF registry.
---
You are a senior network automation team member specialising in YANG data modelling
aligned with TM Forum standards. Generate a YANG 1.1 module for a [SERVICE TYPE]
service interface that...
```

### Prompt Categories

| Category | What Goes Here |
|---|---|
| `yang-authoring` | YANG module scaffolding, grouping patterns, deviation authoring |
| `test-generation` | Unit test stubs, integration test scenarios, edge case generation |
| `code-review` | Review checklists, security-focused review prompts, complexity analysis |
| `incident-triage` | Log analysis, root cause hypothesis generation, timeline reconstruction |
| `documentation` | README generation, API docs from code, runbook drafting |
| `api-client-generation` | Client stub generation from OpenAPI specs, TM Forum API adapters |
| `config-generation` | Device config templates, NETCONF payload generation, Ansible task authoring |

---

## Monthly AI Retrospective Questions

The AI Champion adds these five questions to the team's regular sprint retrospective every month. They sit alongside the standard retro format — not replacing it.

1. **"What AI-assisted task saved you the most time this sprint?"**  
   Surfaces what's working. Creates permission to celebrate practical wins.

2. **"Where did AI produce output you couldn't trust? What did you do?"**  
   Normalises failure and builds collective intelligence about tool limitations.

3. **"Did you feel safe to say 'this AI output is wrong' without judgment this sprint?"**  
   *(SPACE-S — psychological safety indicator)* A direct check on team culture. If the answer is "no" or hesitant, that's a signal to address immediately.

4. **"Did we add anything to the prompt library this sprint? If not, why not?"**  
   Accountability for knowledge sharing. "We didn't have time" is valid — but hearing it repeatedly is a signal that the contribution process needs to be lighter.

5. **"Rate your cognitive load this sprint compared to last sprint (1 = much heavier, 5 = much lighter)."**  
   *(SPACE-E — efficiency/flow indicator)* Not a direct measurement of AI impact, but a lightweight trend line. Track the team average over time.

**AI Champion note:** Record the responses to questions 3 and 5 and report them as part of the monthly SPACE-A metrics. Anonymise individual ratings.

---

## Knowledge Sharing Norms

### Sharing Wins

Post AI wins in `#noa-ai-adoption` using the tag **`#ai-win`**. Keep it brief — one or two sentences, the tool used, and the task. Example:

> **#ai-win** Used Copilot Chat to generate a full pyang validation test suite for the new inventory module in ~20 minutes. Would have taken half a day manually. Prompt in the library under `test-generation/`.

### Sharing Misses

Post AI failures too. Use the tag **`#ai-miss`**. These are more valuable than wins because they save colleagues from the same mistake. Example:

> **#ai-miss** Asked Claude to generate a NETCONF edit-config payload for a Cisco ASR config. It produced syntactically valid XML but the namespace was wrong for the target NOS version. Always verify namespaces against the actual device schema.

**There is no shame in correcting AI output.** There is no shame in choosing not to use AI for a task. Both are signs of good engineering judgment.

### Choosing Not to Use AI

If you deliberately chose not to use AI on a task — because it was too sensitive, too nuanced, or because you judged manual work would be faster — that's a valid, respected choice. You don't need to justify it.

---

## What We Won't Delegate to AI

The following decisions and activities remain **human-owned**, regardless of how capable our AI tools become. This list is reviewed annually by the engineering lead and AI Champions.

| Activity | Why It Stays Human |
|---|---|
| Security architecture decisions | Accountability and liability cannot be delegated; AI does not understand business risk |
| Network topology changes affecting customer SLAs | Customer impact requires human judgment and contractual awareness |
| Incident root cause decisions that drive operational changes | An incorrect root cause cascades into wrong fixes; human review of evidence is mandatory |
| Architectural boundary decisions (where ADRs are required) | See [ADR Template](./adr-template.md) — AI may inform but not decide |
| Performance review and career development conversations | These require empathy, context, and human relationship |
| Customer-facing communications about outages or failures | Tone, accountability, and trust cannot be outsourced to a language model |

> **Note:** AI tools may *assist* in preparing for any of the above (drafting incident timelines, generating architectural options, summarising evidence) but the final judgment and communication must be human.
