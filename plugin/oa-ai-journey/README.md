# oa-ai-journey — O&A AI Adoption Journey Copilot Plugin

> AI-agentic adoption framework for the **OSS - Orchestration and Automation (O&A)** team, grounded in Modern Software Delivery, TM Forum standards, and Responsible AI governance.

---

## Installation

```bash
gh copilot plugin install RickMorrison99/AI-Journey#plugin/oa-ai-journey
```

---

## What's Included

| Type | Name | Purpose |
|------|------|---------|
| **Agent** | `oa-journey` | Main framework guide — stages, principles, maturity model, governance |
| **Agent** | `oa-spec` | Spec-writer — Osmani 30-40% rule, 8-section spec template |
| **Agent** | `oa-legacy` | Legacy modernisation — Feathers seam-based approach, characterisation tests |
| **Skill** | `yang-stub` | Generate YANG 1.1 module stubs following O&A conventions |
| **Skill** | `netconf-client` | Generate ncclient Python code with O&A safety patterns |
| **Skill** | `tmf-api` | Identify the correct TM Forum Open API for your domain |
| **Skill** | `oa-adr` | Draft Architecture Decision Records with Shostack STRIDE threat models |
| **Skill** | `char-test` | Write characterisation tests for legacy O&A code (Feathers pattern) |
| **Skill** | `adoption-check` | Assess your team's current O&A adoption stage (1–5) |
| **Skill** | `spec-file` | Generate complete Osmani-style spec files |
| **Skill** | `wardley` | Position AI tools on Wardley's Genesis→Commodity evolution axis |
| **Hook** | `oa-security-check` | Pre-commit: block hardcoded credentials, CDB refs, real device IPs |
| **Hook** | `yang-validate` | Pre-commit: run `pyang --lint` on staged YANG files (non-blocking) |
| **Hook** | `oa-journey-reminder` | Post-checkout: print current stage, Beck 3X phase, random principle |
| **MCP** | `oa-docs` | Framework documentation — 48 docs via filesystem server |
| **MCP** | `tmforum-apis` | TM Forum Open API specs via fetch server |

---

## Quick Start

### Ask the journey guide where your team stands

```
@oa-journey What stage are we at? We use Copilot individually but have no shared conventions,
and our pipeline doesn't test AI-generated code yet.
```

### Write a spec before starting a new NETCONF task

```
@oa-spec I need to build a Python client that retrieves VRF configuration from IOS-XR 7.9 devices
and maps it to a TMF639 ResourceInventory representation.
```

### Get characterisation tests before touching legacy NSO code

```
@oa-legacy I need to refactor this NSO service callback that was written 3 years ago with no tests.
Here's the code: [paste code]
```

### Generate a YANG stub for a new service model

```
/yang-stub Generate a YANG stub for an MPLS TE tunnel service targeting Cisco IOS-XR,
relevant TM Forum domain is connectivity management (TMF641).
```

### Identify the right TM Forum API

```
/tmf-api Which TMF Open API covers physical network resource inventory and capacity management?
```

### Draft an ADR for a new agentic workflow

```
/oa-adr We're building an agent that reads NSO alarms and automatically raises TM Forum
service trouble tickets. Draft the ADR.
```

---

## Set Your Stage

After running `adoption-check`, save your stage so the post-checkout reminder works:

```bash
echo '2' > ~/.oa-journey-stage   # replace 2 with your assessed stage (1–5)
```

---

## Framework Documentation

Full framework at **https://github.com/RickMorrison99/AI-Journey**

- `docs/foundations/` — MSD principles, DORA, SPACE, Kent Beck 3X
- `docs/tools/` — AI tool assessments on the Wardley axis
- `docs/governance/` — ADR templates, Responsible AI framework, Shostack threat models
- `docs/tmforum/` — TM Forum API integration guides
- `docs/yang/` — YANG/NETCONF patterns and NSO conventions
- `docs/measurement/` — DORA + SPACE measurement guides, SCI tracking

---

## License

MIT — O&A Platform Team
