# Privacy — Protecting Data in AI Workflows

> **Status:** Living document · Owned by: O&A Engineering Lead + AI Champions  
> **Review cycle:** Quarterly · **Last reviewed:** _see git log_  
> **Applies to:** All team members, architects, and team leads in the O&A programme  
> **Related:** [Responsible AI — Five Risk Dimensions](index.md) · [Security](security.md)

---

## The Core Rule

> **No customer data, network topology or configuration, credentials, PII, or proprietary IP in any public LLM prompt — ever.**

This rule has no exceptions, no override mechanism, and no "it was only a test environment" carve-out. If data belongs to Tier 2 or Tier 3 (defined below), it does not enter a public inference endpoint under any circumstances. Violations are treated as data security incidents, not process slip-ups.

---

## Why Telecom Is Uniquely High-Risk

Most enterprise AI privacy guidance is written with SaaS or retail data in mind: names, emails, purchase histories. O&A's data is categorically different, and the risk profile is categorically higher.

A telecom network configuration file contains:

- **IP addressing schemes** — the logical map of a network, including internal subnets, loopback addresses, management plane addressing, and inter-router links. This is the equivalent of a floor plan of a building's security infrastructure.
- **Device credentials** — NETCONF/RESTCONF usernames and passwords, SNMP community strings, SSH keys, API tokens for SDN controllers. Even where secrets are vaulted in Ansible, the vault references and variable names carry structural information.
- **Routing policies and BGP configuration** — which prefixes are accepted from which peers, traffic engineering preferences, failover logic. This data allows an adversary to model traffic flow and identify single points of failure.
- **Topology information** — which devices are connected to which, chassis types, software versions, redundancy architecture. Combined with IP addressing, this is a complete reconnaissance dataset.
- **Incident specifics** — a ticket or postmortem submitted to an LLM to assist with root cause analysis may contain all of the above in narrative form.

A prompt leak of network configuration data is not a GDPR notification event — it is a potential physical infrastructure security event. Several national-level incidents have been preceded by exactly this kind of information disclosure. Telecom network configuration data warrants treatment equivalent to classified infrastructure information in many regulatory jurisdictions.

This risk is not theoretical. Public LLM providers have been subject to data exposure incidents, employee access to prompts, and training data inclusion incidents. The contractual protections available even in enterprise tiers are not equivalent to data never leaving the boundary.

---

## Data Classification Tiers for O&A

All data and information handled by the O&A team is classified into one of three tiers for the purpose of AI usage. When in doubt, apply the more restrictive tier.

### Tier 1 — Public OK
*Can be submitted to any LLM, including public endpoints, without restriction.*

This tier covers information that is genuinely generic: it contains no O&A-specific values, no internal structure, and no information that could be combined with other data to reveal sensitive material.

**Examples:**
- Generic Python code patterns ("how do I write a decorator that retries on exception?")
- Questions about public standards ("explain the YANG `leaf-list` statement")
- Publicly available library documentation questions ("how does Nornir's `filter` API work?")
- Fully anonymised error messages where all IPs, hostnames, and device identifiers have been replaced with generic placeholders (see Prompt Hygiene Practices below)
- Questions about public RFCs, IETF drafts, or TM Forum open API specifications
- Generic questions about CI/CD patterns, testing frameworks, or language syntax
- Resume-level architecture descriptions ("I'm building a NETCONF abstraction layer — what are the common design patterns?") — provided no real topology, addressing, or vendor-specific configuration is included

**What makes something Tier 1:** A determined adversary reading every prompt submitted to this tier would learn nothing about O&A's actual network, customers, or internal systems.

---

### Tier 2 — Enterprise LLM Only
*Can be submitted to an enterprise-licensed LLM instance with contractual protections in place (see below). Must not be submitted to public endpoints.*

This tier covers internal work artefacts that reveal O&A's internal structure, code organisation, or non-sensitive configuration patterns, but do not expose customer data or live network specifics.

**Examples:**
- Internal source code structure, module organisation, import graphs
- Non-sensitive configuration templates (e.g., a Jinja2 template for interface description formatting — provided it contains no real IP addresses, credential placeholders with real values, or customer-identifying information)
- Internal architecture diagrams at a conceptual level (e.g., a block diagram of the automation pipeline) — provided device names, addresses, and topology are not included
- Test data generated for internal use that contains synthetic but structurally realistic data
- Sprint planning artefacts, internal ADRs, internal runbooks — provided these do not contain Tier 3 data
- Sanitised postmortem narratives where all specific IPs, device names, customer identifiers, and credential references have been removed and replaced with generic labels

**What makes something Tier 2:** It is not public, and it could allow an adversary to understand O&A's engineering approach, codebase structure, or internal processes — but not the live network or customer data.

**Pre-requisite:** The enterprise LLM instance must meet the contractual requirements defined below before Tier 2 data is permitted.

---

### Tier 3 — Never in LLM
*Must never be submitted to any LLM — public or enterprise — under any circumstances.*

This tier covers data that, if disclosed, could directly enable network compromise, customer harm, regulatory breach, or national infrastructure exposure.

**Examples:**
- Customer data of any kind: names, account numbers, circuit IDs, service configurations tied to a customer
- Network configurations containing real IP addresses, real hostnames, real device identifiers
- Any credentials, passwords, API keys, SSH private keys, SNMP strings, Ansible vault passwords, or Kubernetes secrets — in any format, including obfuscated or partial forms
- Security policies: ACLs, firewall rule sets, security zone definitions, authentication policies
- Incident details containing specifics: ticket numbers with customer references, postmortems naming real devices or real customer impact, outage timelines with real timestamps and real circuit details
- BGP routing tables, routing policy configurations, traffic engineering configurations
- SDN controller configurations, network slice definitions, NFVI infrastructure details
- Vendor contract details, SLA thresholds, or commercial sensitivity

**What makes something Tier 3:** Its disclosure creates direct risk — to the network, to customers, to O&A's regulatory standing, or to national infrastructure.

**There is no exception, escalation path, or "just this once" mechanism for Tier 3 data.** If an AI tool is needed to work with Tier 3 data, the architecture must change: the tool must run on-premise, on infrastructure owned and controlled by O&A, with no external API calls.

---

## Enterprise LLM Instances — Contractual Requirements

Before any Tier 2 data is permitted on an enterprise LLM instance, the following contractual protections must be in place and documented in the relevant ADR:

| Requirement | What to Verify | Where to Check |
|---|---|---|
| **No training on inputs** | The provider contractually commits that prompts and completions are not used to train or fine-tune any model | Data Processing Agreement (DPA), section on model training |
| **Data residency** | Prompts and completions are processed and stored within a defined geographic boundary consistent with applicable data regulations (typically EU for GDPR-scoped data) | DPA, regional endpoint documentation |
| **Audit logs** | The enterprise tier provides access logs showing which users submitted prompts, at what time, and — at minimum — metadata about request volume | Enterprise admin console, SIEM integration options |
| **Retention period** | Prompt and completion data is not retained beyond the session, or is retained for a defined and disclosed period with customer control over deletion | DPA, data retention policy |
| **Incident notification** | The provider commits to notifying enterprise customers of any data breach or unauthorised access to prompt data | DPA, security addendum |
| **Subprocessor list** | The provider discloses all subprocessors that may handle prompt data | DPA, subprocessor annex |

**Currently approved enterprise instances:** _(maintained separately in the internal tooling registry — link in team wiki)_

**Periodic revalidation:** These contractual positions must be re-checked annually or on any material change to the provider's terms. LLM providers have a history of unilateral terms changes (see [Market Concentration](market-concentration.md)).

---

## Prompt Hygiene Practices

When working with data that is borderline Tier 1/Tier 2, or when preparing Tier 2 data for an enterprise instance, apply the following sanitisation practices before submitting any prompt.

### Step-by-Step Prompt Sanitisation

**1. Replace real IP addresses with RFC 5737 documentation ranges or generic labels.**

```
# Before (Never submit)
interface GigabitEthernet0/0
  ip address 10.45.23.1 255.255.255.252

# After (Tier 1 safe)
interface GigabitEthernet0/0
  ip address 192.0.2.1 255.255.255.252
```

RFC 5737 documentation addresses: `192.0.2.0/24`, `198.51.100.0/24`, `203.0.113.0/24`  
RFC 3849 documentation IPv6: `2001:DB8::/32`

**2. Replace real hostnames with role-based generic names.**

```
# Before
hostname lon-pe-rtr-01.carrier.example.com

# After
hostname EDGE-ROUTER-A
```

**3. Remove or replace all credentials, keys, and tokens.**

```yaml
# Before (Never submit)
ansible_password: "{{ vault_lon_pe_rtr_01_pass }}"

# After
ansible_password: "{{ vault_ROUTER_PASSWORD }}"
```

Note: Even vault variable *names* can reveal naming conventions. Use fully generic names.

**4. Replace customer identifiers with synthetic labels.**

```
# Before
vrf definition ACME_CORP_L3VPN

# After
vrf definition CUSTOMER_A_L3VPN
```

**5. Generalise specific topology references.**

```
# Before
! BGP peer to lon-core-rtr-02 (our upstream)
neighbor 10.45.23.5 remote-as 65001

# After
! BGP peer to CORE-ROUTER (upstream)
neighbor 192.0.2.2 remote-as 65000
```

**6. Strip metadata from files before pasting.**

Configuration files often contain embedded metadata: timestamps, NMS job IDs, change ticket numbers. Remove these before submission.

**7. Write the minimum necessary context.**

Prefer narrow, focused prompts over "here is my entire config file, help me with X." The less context submitted, the lower the exposure surface.

### The Sanitisation Self-Check

Before submitting any prompt, run this mental check:

- [ ] Does this prompt contain a real IP address? → Replace it.
- [ ] Does this prompt contain a real hostname or device name? → Generalise it.
- [ ] Does this prompt contain any credential, even a vault reference with a real device name? → Remove or genericise it.
- [ ] Does this prompt contain a customer name, circuit ID, or account reference? → Replace with a synthetic label.
- [ ] Does this prompt contain information about a real incident with specifics? → This is Tier 3. Do not proceed.
- [ ] If a determined adversary read this prompt, could they learn anything about my employer's network? → If yes, sanitise further.

---

## PR Checklist Item

The following item must appear in the team's PR checklist template. It is a **mandatory item** — PRs are not merged without it being checked.

```markdown
- [ ] **Privacy (AI):** If AI assistance was used in this PR, I confirm that no Tier 2 or Tier 3
      data (real IPs, credentials, network topology, customer data, incident specifics) was
      submitted to any public LLM endpoint. Any enterprise LLM usage was via an approved
      instance listed in the tooling registry.
```

Team Members who are unsure whether something they submitted constitutes a violation should disclose it to the AI Champion immediately. The response will be supportive and non-punitive for good-faith disclosures. The goal is learning and remediation, not blame.

---

## Measurement — Quarterly Privacy Audit Checklist

The following checklist is completed by the AI Champion each quarter and reviewed with the Engineering Lead. Results are retained and form part of the responsible AI governance record.

### Q[N] O&A Responsible AI — Privacy Audit

**Period:** [Quarter start date] — [Quarter end date]  
**Completed by:** [AI Champion name]  
**Reviewed by:** [Engineering Lead name]

#### Enterprise LLM Instance Validation
- [ ] All enterprise LLM instances in use are listed in the tooling registry
- [ ] Contractual protections (no training on inputs, data residency, audit logs) re-confirmed for each instance
- [ ] No new enterprise LLM instances were adopted without an ADR in this quarter
- [ ] Subprocessor lists reviewed for material changes

#### PR and Workflow Spot-Check
- [ ] Random sample of 10 AI-assisted PRs reviewed — privacy checklist item was checked on all
- [ ] Any prompt log access available from enterprise instances reviewed for Tier 3 data indicators (spot-check)
- [ ] AI-assisted incident postmortems reviewed — no Tier 3 specifics submitted to LLM

#### Incident Review
- [ ] Any reported privacy concerns from this quarter documented and resolved
- [ ] Training refresher triggered if any near-misses or incidents occurred

#### Classification Tier Review
- [ ] Data classification tier definitions reviewed against any new data types handled this quarter
- [ ] Any new tooling or integrations assessed for privacy tier implications

**Overall status:** [ ] No issues found / [ ] Minor issues — remediated / [ ] Issues requiring escalation

**Notes:**

---

## References and Further Reading

### Regulatory
- **GDPR Article 25 — Data Protection by Design and by Default:** The principle that privacy controls must be embedded in system design, not bolted on. AI prompt design is a data processing activity subject to Article 25 obligations for O&A operating under EU data protection law.
- **GDPR Article 28 — Processor Obligations:** Governs the DPA requirements when a cloud LLM provider acts as a data processor on behalf of O&A.
- **NIS2 Directive (EU 2022/2555):** Telecom operators are designated as essential entities under NIS2. Security and privacy of systems and data are regulatory obligations, not just good practice.

### Industry Standards
- **TM Forum Privacy Guidelines (GB941):** TM Forum's framework for privacy in telecoms operations, including data classification and access control guidance. Directly applicable to O&A's context.
- **TM Forum AI/ML Guidelines (IG1230):** Includes privacy considerations for AI/ML in telecom operations.

### Academic and Thought Leadership
- **Timnit Gebru, Emily M. Bender, et al. — "On the Dangers of Stochastic Parrots: Can Language Models Be Too Big?" (FAccT 2021):** The landmark paper on data governance failures in large language model training, including the risks of training on data that was scraped without consent. Directly relevant to why "no training on inputs" is a contractual requirement.
- **Timnit Gebru — DAIR Institute:** The Distributed AI Research Institute, focused on AI that is accountable and rights-respecting. The framing of data governance as a justice issue, not just a compliance issue, is directly applicable here.
- **Kate Crawford — _Atlas of AI_ (2021):** Chapter 3 covers data collection practices and the invisibility of data subjects. Relevant to understanding whose data is at risk in AI workflows.

---

*Questions about data classification, prompt hygiene, or enterprise LLM contracting should be directed to the AI Champion. The AI Champion escalates to the Engineering Lead and Legal/Compliance as appropriate.*
