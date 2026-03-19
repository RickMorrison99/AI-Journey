# O&A AI Adoption Journey

> A living framework for the OSS - Orchestration and Automation team to adopt AI tools
> responsibly, at pace, and with lasting engineering quality.

---

## What is this?

This site is a living framework for the **OSS - Orchestration and Automation (O&A)** team to adopt
AI-assisted and AI-agentic tooling in a principled, measurable, and responsible way. It is grounded
in **Modern Software Delivery (MSD)** practices — drawing on Continuous Delivery, DORA research, and
evolutionary architecture — and is explicitly aligned with **TM Forum** standards for the telecom
software domain. The framework treats AI as an amplifier of existing engineering discipline: teams
with strong foundations get stronger; teams that skip the foundations get faster at producing
technical debt.

---

## How to Use This Site

Choose the path that fits your role right now:

| Your situation | Recommended path |
|---|---|
| 🆕 **New to the framework** | [Baseline Survey](baseline-survey.md) → [Maturity Model](maturity-model.md) → [Adoption Roadmap](adoption-roadmap.md) |
| 🔧 **Team Member** | [MSD Foundations](msd-foundations/index.md) → [Tool Playbooks](tools/index.md) → [Measurement](measurement/index.md) |
| 📊 **Stakeholder / Leader** | [Executive Summary](stakeholders/executive-summary.md) → [Quarterly Review](stakeholders/quarterly-review.md) → [Architect's Elevator](stakeholders/architect-elevator.md) |

---

## Our Foundations

The framework draws on twenty thought leaders across three domains:

| Domain | Thinkers |
|---|---|
| **Modern Software Delivery / Engineering** | Dave Farley · Martin Fowler · Gregor Hohpe · Holly Cummins · Nicole Forsgren · Gene Kim · Jez Humble · Sam Newman · Kent Beck · Matthew Skelton & Manuel Pais · Michael Feathers · Charity Majors |
| **Responsible AI / Ethics** | Timnit Gebru · Kate Crawford · Anne Currie · Ethan Mollick · Joy Buolamwini · Cathy O'Neil · Adam Shostack |
| **Strategy & Adoption** | Andrew Ng · Simon Wardley |

Full profiles, key works, and their specific relevance to O&A are in the
[Philosophy & Thought Leadership](philosophy.md) document.

---

## 22 Principles

These principles are the backbone of every decision in this framework. They are not aspirational
slogans — each one is operationalised in at least one section of this site.

1. Deployment pipeline is the only path to production
2. Fast feedback loops at every stage
3. Test behaviour not implementation
4. Trunk-based development with short-lived branches
5. Architecture enables, not constrains
6. Manage cognitive load as a first-class concern
7. Measure what matters — avoid vanity metrics
8. DRY — Don't Repeat Yourself
9. SoC — Separation of Concerns
10. API-first — design contracts before implementations
11. Spec-before-code — consume TM Forum specs before writing
12. Model-driven where possible (YANG, OpenAPI, AsyncAPI)
13. AI assists, humans decide
14. AI output is a draft, not a deliverable
15. Safety boundaries are non-negotiable
16. Never train on production secrets
17. Sanitise all prompts before sending to external models
18. Measure AI productivity with SPACE, not activity metrics alone
19. Every agentic workflow requires an ADR
20. SCI — track and reduce AI energy consumption
21. Vendor diversity — avoid single-vendor lock-in
22. Test-Driven Development — write a failing test before writing implementation code

---

## Five Responsible AI Dimensions

O&A evaluates every AI tool and workflow against five responsible-AI dimensions:

| Dimension | Summary | Reference |
|---|---|---|
| **Privacy** | No production PII or secrets in prompts; data residency requirements enforced | [Privacy](responsible-ai/privacy.md) |
| **Security** | Prompt injection controls, output sanitisation, supply-chain checks on AI dependencies | [Security](responsible-ai/security.md) |
| **Environmental** | Track Software Carbon Intensity (SCI) for every agentic workflow; prefer efficient models | [Environmental](responsible-ai/environmental.md) |
| **Market Concentration** | Maintain vendor diversity; avoid single-provider lock-in for critical AI capabilities | [Market Concentration](responsible-ai/market-concentration.md) |
| **Global Transformation** | Recognise labour and societal impacts; upskill rather than displace team members | [Global Transformation](responsible-ai/global-transformation.md) |

---

## Site Stats

**48 documents · ~21,000 lines · 20 thought leaders · 22 principles · Built with [MkDocs Material](https://squidfunk.github.io/mkdocs-material/)**
