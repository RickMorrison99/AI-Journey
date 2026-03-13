# Global Transformation — People First

> **Status:** Living document · Owned by: O&A Engineering Lead + AI Champions  
> **Review cycle:** Quarterly · **Last reviewed:** _see git log_  
> **Applies to:** Engineering Lead, AI Champions, and all team members in the O&A programme  
> **Related:** [Responsible AI — Five Risk Dimensions](index.md)

---

## The Core Rule

> **This is an augmentation programme, not a replacement programme — and that must be demonstrably true, not just stated.**

The word "augmentation" is easy to say and frequently said. What makes it true — or exposes it as a comfortable fiction — is whether the team's actual practices, metrics, and investment decisions reflect augmentation or quietly optimise for headcount reduction.

This section defines what "demonstrably true" means in practice: the commitments, the measurements, and the signals that would indicate the commitment is being honoured or broken.

---

## The Trust Problem

Team Members who are anxious about displacement will not give honest feedback about AI tools.

This is not a speculation about human psychology. It is a documented pattern in technology transformation programmes. When team members believe that admitting AI limitations or problems will be interpreted as resistance, or that reporting that "the AI got it wrong" could be used to justify keeping the AI instead of the team member, they adjust their behaviour:

- They **underreport failures** in AI output — flagging and fixing in silence rather than raising the issue.
- They **overstate productivity gains** in adoption surveys — because they correctly read the incentive structure.
- They **disengage from honest retrospective participation** — giving safe, positive answers rather than surfacing real concerns.
- They **hide the human effort** that goes into making AI output usable — the prompt engineering, the verification, the correction — making the AI look more capable than it is.

The result is an adoption programme that appears to be succeeding based on metrics that are systematically skewed by fear. The real problems — security oversights, quality degradation, deskilling in critical areas — accumulate undetected until they manifest as an incident.

**Psychological safety is not a "nice to have" in an AI adoption programme. It is the prerequisite for the programme's safety and integrity.**

Gene Kim, in _The Unicorn Project_ and in his research contributions to the State of DevOps reports, documents the same dynamic in DevOps transformations: organisations that optimised for metrics while ignoring psychological safety produced metrics that looked good and software that was fragile. The AI adoption context amplifies this dynamic because the stakes of undetected failure are higher — in O&A's case, running on carrier-grade networks.

---

## Workforce Risks

The O&A team exists within a broader industry context. The responsible AI practices established here are not just about this team's wellbeing — they are about the practices that a 20–30 person early-adopter team sets as precedent for a much larger organisational and industry transformation.

### Risk 1 — Deskilling

AI assistance, applied without deliberate countermeasures, degrades the human expertise it augments. The mechanism is simple: if you stop practising a skill because AI handles it, you lose that skill. In O&A's context, the skills at risk include:

**Network protocol knowledge.** An team member who uses AI to generate NETCONF RPCs without understanding NETCONF semantics is more capable in the short term. In the medium term, they cannot debug unexpected device behaviour, cannot review AI output critically, and cannot respond effectively to an incident where the AI tool is unavailable or wrong.

**Security reasoning.** Security judgement is a skill built through practice: reading code for vulnerabilities, understanding attack patterns, reasoning about threat models. If AI performs all security scanning and the team member merely approves, the team member's security reasoning atrophies — and with it, the ability to catch what the tools miss.

**Architectural judgement.** Architecture decisions require experience, context, and the ability to reason about second- and third-order consequences. AI tools can generate plausible architectural options — they cannot reason about organisational constraints, operational reality, or the lessons from past decisions that live in experienced team members' heads.

**The deskilling risk is not hypothetical.** Research on GPS navigation and cognitive mapping, autocorrect and spelling ability, and calculator use and arithmetic fluency all demonstrate the same pattern: when tools automate cognitive tasks, the underlying human capability declines with disuse. See the [Preserving Critical Human Skills](#preserving-critical-human-skills) section for the O&A-specific list.

---

### Risk 2 — Two-Tier Workforce

In any technology transformation, there is a period where some team members have adopted new tools and practices and others have not. If this gap is not actively managed, it becomes self-reinforcing:

- Early adopters are seen as more productive (even if the differential is partly measurement artefact).
- Late adopters become anxious about their position, which makes adoption harder.
- Early adopters become informal gatekeepers to the new practices, which can create exclusion dynamics.
- The gap between "AI-native" and "non-AI-native" team members becomes a proxy for seniority or value assessment, even when it is not.

The O&A team's responsibility is to actively prevent this dynamic. Reskilling investment must be universal, not optional. The AI Champion role must be a rotating or expanding position, not a permanent designation for a small cohort. Retrospective discussion of AI tools must be inclusive — it must be a space where "I'm not comfortable with this yet" is as welcome as "here's a great prompt I found."

---

### Risk 3 — Broader Industry Displacement

The O&A team does not operate in isolation. The practices established here contribute to an industry-wide transformation in which AI tooling is changing the economics of telecom network operations and software development at scale.

Timnit Gebru and Kate Crawford have documented the labour displacement dynamics of AI adoption at scale: the benefits of AI productivity gains accrue disproportionately to capital holders, while the costs — disrupted careers, required retraining, economic uncertainty — are borne disproportionately by workers. This is not a criticism of the O&A programme specifically. It is context that the team's leadership should carry explicitly.

The O&A team's practices — especially around reskilling investment, transparent communication, and psychological safety — either contribute to a more equitable industry transformation or to a less equitable one. Early adopters have more influence over the trajectory than they may realise.

Ethan Mollick, in _Co-Intelligence_ (2024), documents the research on AI and labour: the finding that AI assistance disproportionately benefits lower-skill workers (by raising their floor) while the highest-skill workers gain less — but may be at greater long-term displacement risk in domains where AI eventually exceeds human capability. In O&A's context, the team members most at risk from long-term displacement are those whose primary value is in routine, pattern-based work rather than judgement, creativity, and cross-domain reasoning. Reskilling investment should flow toward building the latter.

---

## Reskilling Commitments

The following commitments are binding, not aspirational. They are reported quarterly and reviewed by the Engineering Lead.

### Minimum Investment: 4 Hours per Team Member per Sprint (Adoption Phases 1–3)

During the active adoption phases of the AI programme (typically the first 12–18 months), every team member in the O&A team has a minimum of **4 hours per sprint** allocated to AI-related reskilling. This time is:

- **Protected time** — it cannot be moved to sprint delivery without explicit Engineering Lead approval.
- **Reported** — each team member logs reskilling activities; the AI Champion aggregates this for quarterly reporting.
- **Diverse in form** — it includes formal learning, peer learning sessions, hands-on experimentation, AI Champion office hours, and retrospective-based learning.

**What counts as reskilling time:**

| Activity | Counts? | Notes |
|---|---|---|
| Structured learning (courses, workshops, reading) on AI tools or responsible AI | Yes | |
| AI Champion-led team sessions | Yes | |
| Paired AI exploration with a colleague | Yes | |
| Experimenting with a new AI tool on a time-boxed task | Yes | |
| Reading the OWASP LLM Top 10 or this responsible AI documentation | Yes | |
| Informal use of AI tools on day-to-day tasks | **No** | This is delivery, not reskilling |
| Attending a conference talk on AI | Yes (max 2h per event) | |
| Writing an ADR for an AI tool adoption | **Partial** — the engineering/research time counts, not the writing time | |

### Reskilling Focus Areas by Role

| Role | Priority Reskilling Areas |
|---|---|
| **All team members** | Prompt engineering fundamentals, AI security (OWASP LLM Top 10), privacy tier classification, responsible AI principles |
| **Junior / mid team members** | Maintaining foundational skills (protocol knowledge, security reasoning, architecture fundamentals) — the deskilling risk is highest here |
| **Senior team members / architects** | AI-augmented architectural review, evaluating AI tool quality, AI programme governance, mentoring others |
| **AI Champions** | Advanced prompt engineering, LLM evaluation methodology, responsible AI governance, reskilling facilitation, SCI measurement |

---

## The AI Champion Role

The AI Champion role is a **growth opportunity and a visible career development path**, not a surveillance function or a productivity measurement tool. This distinction must be maintained actively.

### What AI Champions Do

- **Enable and teach** — run team learning sessions, maintain the responsible AI documentation, answer questions
- **Evaluate tools** — lead tool evaluations, write ADRs, assess security and privacy implications
- **Facilitate honest retrospectives** — run the SPACE-S AI retrospective questions; create space for honest feedback
- **Measure responsibly** — track SCI, vendor concentration, reskilling hours; report findings honestly including negative ones
- **Advocate for team members** — when adoption pressure conflicts with team member wellbeing or programme integrity, the AI Champion raises this with the Engineering Lead
- **Connect to the broader community** — track responsible AI developments, bring relevant external thinking into the team

### What AI Champions Do NOT Do

- Measure individual team member AI usage or productivity
- Report on which team members are "adopting" vs. "resisting"
- Use reskilling data to assess individual performance
- Bypass the Engineering Lead to report concerns about individual team members to management

### Recognising AI Champions

AI Champion contributions are:
- Recognised in performance reviews as a meaningful engineering contribution
- Included in the team's public engineering portfolio where appropriate
- A stepping stone to technical leadership roles — the skills (evaluation, governance, facilitation) are high-value leadership skills

**The AI Champion role should be seen by team members as something to aspire to, not something to avoid.**

---

## Communication Framework

Leadership must communicate clearly and consistently on the following points. Ambiguity on any of these creates anxiety that undermines programme integrity.

### What Must Be Said Clearly (and Repeatedly)

| Topic | What to Say | What Not to Say |
|---|---|---|
| **Programme intent** | "This is an augmentation programme. We are investing in making every team member more capable. We are not planning to reduce headcount as a result of AI adoption." | "We'll see how things go." / "AI might change what we need." |
| **Metrics use** | "AI adoption metrics are used to understand tool effectiveness and identify where team members need support. They are not used to evaluate individual performance." | Nothing (silence on this is interpreted as confirmation of the worst-case interpretation) |
| **Timeline** | "Here is the current plan for AI tool rollout, with dates. Here is what we know is uncertain." | "We're moving fast and things will evolve." |
| **Job security** | "No team member in this team will lose their role as a direct result of AI adoption. If the organisation's resourcing changes, that will be communicated through the standard process, not via AI programme decisions." | "No one can guarantee job security in any technology company." (True but unhelpful — it signals that the guarantee is not being given) |
| **What will change** | "The nature of some tasks will change. Some repetitive work will be automated. The expectation is that the time freed up is used for higher-value work — and we will define what that higher-value work is together." | Silence on what will change (silence is worse than an honest answer) |
| **Feedback** | "We want honest feedback about AI tools, including negative feedback. If a tool is causing problems, we need to know. Reporting problems is the right thing to do." | "We're looking for champions, not sceptics." |

### Communication Cadence

| Frequency | Format | Content |
|---|---|---|
| Every sprint | Retro | SPACE-S AI questions (see below); AI tool discussion in open format |
| Monthly | Engineering Lead address (informal) | Programme progress, any changes to plans, appreciation for feedback |
| Quarterly | Team review | Responsible AI metrics report including transformation indicators; honest assessment of what is and isn't working |
| Ad hoc | 1:1 | Individual concerns; engineering lead proactively creates space for these conversations |

---

## Psychological Safety Indicators

The following five retro questions are used **every sprint** to track the psychological safety dimension of AI adoption. These are SPACE-S (Satisfaction, Performance, Activity, Communication and Collaboration, Efficiency, and Safety) questions adapted for AI adoption.

### The Five SPACE-S AI Retro Questions

These questions are asked in the retrospective using anonymous response collection (e.g., sticky notes, anonymous digital tools). The aggregated responses are tracked by the AI Champion and included in quarterly reporting.

---

**Question 1 — Safety**

> *"If I discovered that an AI tool had produced incorrect or unsafe output in my work this sprint, I feel comfortable raising this without fear of it reflecting badly on me."*

*Scale: Strongly agree / Agree / Neutral / Disagree / Strongly disagree*

**Why this matters:** This is the primary psychological safety indicator. A declining score here is an early warning signal that fear is driving behaviour. If team members don't feel safe raising AI errors, errors accumulate silently.

**Target:** ≥80% Agree or Strongly Agree. Any sprint where this falls below 70% triggers a team discussion at the next retrospective.

---

**Question 2 — Autonomy**

> *"I feel in control of how I use AI tools in my work — I decide when to use them and when not to, without feeling pressure to use them in ways I'm not comfortable with."*

*Scale: Strongly agree / Agree / Neutral / Disagree / Strongly disagree*

**Why this matters:** Autonomy is a predictor of intrinsic motivation and psychological wellbeing. Team Members who feel coerced into AI adoption patterns they don't trust will either comply resentfully (with reduced quality) or comply with hidden resistance (gaming metrics). Neither serves the programme.

**Target:** ≥75% Agree or Strongly Agree.

---

**Question 3 — Honest Assessment**

> *"When I think AI output is not good enough, I reject or substantially revise it — and I don't feel like that makes me a poor AI adopter."*

*Scale: Strongly agree / Agree / Neutral / Disagree / Strongly disagree*

**Why this matters:** This question detects the overreliance pressure described in the Security dimension. If team members feel that rejecting AI output is a failing rather than good engineering practice, the quality of AI-assisted work will degrade over time.

**Target:** ≥80% Agree or Strongly Agree.

---

**Question 4 — Skill Confidence**

> *"I feel that my core engineering skills (network knowledge, security reasoning, architecture judgement) are being maintained or growing, not eroding, through AI adoption."*

*Scale: Strongly agree / Agree / Neutral / Disagree / Strongly disagree*

**Why this matters:** This is the deskilling early-warning question. If team members are perceiving skill erosion, it will become real skill erosion within a few quarters. Early detection allows the team to adjust reskilling investment and task distribution.

**Target:** ≥70% Agree or Strongly Agree. A declining trend is a signal to review task distribution — are team members still doing the deep technical work that builds and maintains expertise?

---

**Question 5 — Voice**

> *"In the last sprint, I had at least one conversation — with a colleague, the AI Champion, or the Engineering Lead — where I could honestly discuss AI tool concerns or problems without it feeling like a career risk."*

*Scale: Yes, definitely / Mostly yes / Not really / Definitely not*

**Why this matters:** Voice — the ability to raise concerns — is the operational indicator of psychological safety. This question moves from attitude (the previous four) to behaviour: did the conditions for honest voice actually exist in the last sprint?

**Target:** ≥80% Yes or Mostly Yes.

---

### Using the Retro Data

Retro question data is:

1. Aggregated (never individual-level) by the AI Champion
2. Trended across sprints — absolute scores matter less than trends
3. Included in the quarterly responsible AI report
4. Used to trigger action when thresholds are crossed — not just noted

**Response to declining SPACE-S scores:**
- A single-sprint dip: note and watch
- Two consecutive sprints below threshold: AI Champion initiates a focused retro conversation on the specific question
- Three consecutive sprints below threshold or any score below 60%: Engineering Lead is directly engaged; programme adjustments are made before continuing to expand AI tool adoption

---

## Preserving Critical Human Skills

The following skills must never be fully delegated to AI in the O&A context. They are listed here explicitly because they are the skills most at risk of atrophiation as AI tools mature — and they are the skills that represent the team's irreducible expertise.

### Skills That Must Never Be Fully Delegated to AI

| Skill | Why It Cannot Be Delegated | How to Actively Maintain |
|---|---|---|
| **Security review of network automation code** | AI tools generate plausible-looking code with real vulnerabilities. Only a human with security knowledge can evaluate whether a piece of network automation code is safe to run against live devices. | Security review is always human-led. AI may assist but cannot conclude. Team Members rotate through security review responsibilities. |
| **Architectural judgment on automation design** | Architecture requires reasoning about organisational constraints, operational history, and second-order consequences. AI tools produce architecturally plausible options that may be locally optimal and globally wrong. | Architecture decisions require a human author and human reviewers. AI input is treated as one input among many, not as a recommendation to be accepted. |
| **Network protocol expertise** | BGP, OSPF, NETCONF, YANG semantics, vendor-specific implementation details. This knowledge is required to review AI-generated network configs and code critically. An team member who cannot read a NETCONF RPC with understanding cannot safely approve one. | Deliberate practice: team members author network config PRs without AI assistance at regular intervals. Protocol review included in senior team member mentorship scope. |
| **Customer impact assessment** | The judgment about whether a network change affects customers — in what ways, with what severity, with what notice requirements — requires human judgment, customer knowledge, and accountability. AI cannot be accountable for a customer-impacting decision. | Human sign-off required on any automation that may affect live customer services. Customer impact reasoning is documented in PRs by humans. |
| **Incident command and root cause analysis** | During an incident, the ability to reason under pressure, coordinate across teams, and make decisions with incomplete information is irreducibly human. AI tools may assist with data gathering and pattern matching, but command cannot be delegated. | Regular incident simulations (game days) that include scenarios where AI tools are unavailable or provide wrong information. |
| **Ethics and responsible AI judgment** | The assessments in this document — whether a prompt contains Tier 3 data, whether a security finding is acceptable, whether a workforce practice is fair — require human judgment and human accountability. AI cannot be accountable for ethical decisions. | This document exists because of this reason. Responsible AI is a human practice. |

### Protecting These Skills in Practice

**Task rotation:** On a monthly basis, the AI Champion reviews whether any of the above skill areas has been predominantly handled by AI tools for any team member. If an team member has not performed security review, written network config, or done meaningful architecture work in a quarter without AI assistance, the AI Champion raises this in their 1:1 with the engineering lead.

**Deliberate practice sprints:** Once per quarter, the team runs a "skills maintenance" mini-sprint where team members work on tasks in the above categories using traditional methods — no AI assistance. This is not presented as a test or evaluation. It is presented as a deliberate practice activity, like fire drills.

**Review weighting:** Code review for network operations code that was generated without AI assistance is valued equally to AI-assisted code in the team's engineering culture. There is no status differential between "AI-native" and "hand-crafted" approaches.

---

## Measurement

### Transformation Metrics

| Metric | Measurement Method | Target | Frequency |
|---|---|---|---|
| **SPACE-S score per question** | Anonymous retro survey (5 questions) | ≥75% positive on each question | Per sprint |
| **SPACE-S trend** | Plot over time | Stable or improving | Quarterly |
| **Reskilling hours per team member per quarter** | AI Champion log aggregation | ≥8h/team member/sprint average (Phase 1–3) | Quarterly |
| **Reskilling activity diversity** | Distribution across formal, peer, and experimentation | At least 2 of 3 types per team member per quarter | Quarterly |
| **Voluntary attrition rate — O&A team** | HR data | Stable or below organisational average | Quarterly |
| **Retro sentiment analysis** | Qualitative analysis of open retro comments for AI-related themes | Positive themes ≥ neutral/negative | Quarterly |
| **Critical skills maintenance** | AI Champion task rotation review | No team member with >1 quarter gap in any critical skill area | Quarterly |
| **AI Champion role fill rate** | Number of team members expressing interest in AI Champion rotation | At least 2 team members willing to take on role at any time | Quarterly |

### Reporting

Transformation metrics are included in the quarterly responsible AI governance report. Unlike delivery metrics (DORA, velocity), transformation metrics are not shared with stakeholders above the Engineering Lead without the team's consent. Their purpose is programme improvement, not performance management.

The Engineering Lead reviews transformation metrics alongside responsible AI metrics to assess overall programme health. A programme with strong delivery metrics but declining SPACE-S scores is a programme accumulating hidden risk.

---

## References and Further Reading

### Labor and Power
- **Kate Crawford — _Atlas of AI: Power, Politics, and the Planetary Costs of Artificial Intelligence_ (2021):** Chapter 7 ("State") on AI and labour power, and the Conclusion on structural concentration and worker impact. Crawford's analysis of how AI systems shift power from workers to capital holders is essential context for the O&A programme's design choices.
- **Timnit Gebru — DAIR Institute and "Stochastic Parrots" (with Bender et al., 2021):** Gebru on the labour invisibility in AI systems — the human labellers, annotators, and moderators whose work makes AI systems function and whose contributions are systematically erased from the "AI" framing. Relevant to the O&A team's responsibility to acknowledge the full human labour in AI systems they use.
- **Gebru, Bender, et al. — "On the Dangers of Stochastic Parrots" (2021):** The paper that cost Timnit Gebru her position at Google. Its argument that large language model development should be slowed to address labour and power implications directly frames the programme-level choices in this document.

### Transformation and Psychological Safety
- **Gene Kim — _The Unicorn Project_ (2019):** Kim's analysis of the cultural conditions required for successful technology transformation. The Five Ideals (especially Locality and Simplicity, and Psychological Safety) map directly to the O&A programme's design. Kim's consistent finding that metrics without safety produce metric gaming rather than genuine improvement is central to this document.
- **Gene Kim, Jez Humble, Patrick Debois, John Willis — _The DevOps Handbook_ (2016):** The research basis for the psychological safety findings cited in the transformation risk section. The three-way flow model and its cultural prerequisites are applicable to AI adoption as a transformation programme.
- **State of DevOps Report (Puppet / DORA, annual):** The longitudinal data on psychological safety and team performance that informs this document's approach to SPACE-S measurement.

### Human-AI Collaboration and Reskilling
- **Ethan Mollick — _Co-Intelligence: Living and Working with AI_ (2024):** Mollick's research-grounded analysis of human-AI collaboration, including the finding that AI assistance benefits lower-skill workers more than higher-skill workers in the short term, and the implications for deskilling and reskilling strategy. His concept of "domain expertise amplification" — that AI is most powerful when operated by genuine domain experts — directly informs the preserving critical human skills section.
- **Ethan Mollick — "Centaurs and Cyborgs on the Jagged Frontier" (2023):** The empirical research paper on AI assistance in knowledge work that introduced the "jagged frontier" concept: AI is variably capable across task types in ways that are not intuitive. Directly relevant to right-sizing AI assistance in O&A.
- **Erik Brynjolfsson, Danielle Li, Lindsey Raymond — "Generative AI at Work" (NBER, 2023):** Empirical study showing AI assistance raises the productivity floor (benefits lower-skill workers most) and that customer satisfaction improved with AI assistance — with implications for how reskilling investment is allocated.

---

*Questions about reskilling, career development in AI Champion roles, or concerns about the programme's impact on your work should be raised with the AI Champion or Engineering Lead. All concerns are treated with confidentiality and without prejudice.*
