# Skill: TM Forum API Lookup

**Skill name**: `tmf-api`
**Trigger phrases**: "which TMF API", "tmforum api for", "tmf open api", "which open api covers"

---

## What This Skill Does

Helps you select the correct TM Forum Open API for a given O&A domain, understand the key resources it manages, and download the right OpenAPI specification into your `context/` directory before prompting any AI tool. This skill enforces the O&A **spec-before-code** principle for TMF integrations.

Getting the wrong TMF API wastes hours of AI prompt iteration. Getting the right one — and downloading the spec first — means the AI has the correct resource names, field names, and operation patterns from the start.

---

## Decision Questions

Answer these questions to route to the correct API:

1. **What kind of resource is involved?**
   - Physical/logical network resource (router, interface, VRF, NE) → **TMF639** or **TMF652**
   - Service (L2VPN, L3VPN, CPE provisioning) → **TMF641** or **TMF645**
   - Performance threshold / alarm → **TMF648**
   - Geographic location / site → **TMF674**
   - Agreement / contract → **TMF651**
   - Rule / policy engine → **TMF630**

2. **Is this read (query/inventory) or write (order/provision)?**
   - Inventory / read → **TMF639** (Resource Inventory), **TMF645** (Service Qualification)
   - Order / provision → **TMF641** (Service Ordering), **TMF652** (Resource Ordering)

3. **Does it involve thresholds, metrics, or SLA monitoring?**
   - Yes → **TMF648** (Performance Threshold)

---

## The 8 Key TMF APIs for O&A

| API | Name | O&A Use Case |
|-----|------|-------------|
| **TMF630** | Rule Management | Policy-driven automation rules; intent-based networking policy definitions |
| **TMF639** | Resource Inventory Management | Query and manage logical/physical network resources: NEs, interfaces, VRFs, LSPs |
| **TMF641** | Service Ordering | Provision and manage service orders: L2VPN, L3VPN, SD-WAN, CPE onboarding |
| **TMF645** | Service Qualification | Check feasibility / availability of a service before ordering; coverage checks |
| **TMF648** | Performance Threshold | Define and manage performance thresholds; SLA alarm triggers; KPI monitoring |
| **TMF651** | Agreement Management | Manage customer/partner agreements and SLA contracts |
| **TMF652** | Resource Ordering | Order physical/logical resources; allocate capacity; rack-and-stack automation |
| **TMF674** | Geographic Site Management | Manage sites, addresses, and geographic locations for service and resource context |

---

## Spec-First Instruction

After identifying the correct TMF API, always output:

> "Before prompting any AI tool, download the OpenAPI specification for [TMF-XXX] to your `context/tmf/` directory.
>
> Official swagger JSON: `https://github.com/tmforum-apis/TMF[XXX]_[Name]/blob/master/TMF[XXX]_[Name]-v[version].swagger.json`
>
> Then reference this file in your spec under **Context/Resources**. This ensures the AI uses correct resource names, field names, and HTTP operation patterns."

---

## Critical Warning: Field Name Case

**This catches every O&A team member at least once.**

TM Forum Open APIs use **camelCase** field names: `serviceOrder`, `resourceRef`, `relatedParty`, `orderItem`, `serviceCharacteristic`.

AI tools trained on generic REST APIs default to **snake_case**: `service_order`, `resource_ref`, `related_party`.

**Rule**: Always validate AI-generated TMF payloads against the downloaded OpenAPI spec before committing. Add this to your `What NOT To Do` spec section:
> "Do not generate snake_case field names — TM Forum Open APIs use camelCase exclusively."

---

## Common O&A Mapping Examples

| Task | Primary API | Secondary API |
|------|------------|---------------|
| Query all managed NEs by location | TMF639 | TMF674 |
| Create an L3VPN service order | TMF641 | TMF639 (resource check) |
| Check if L2VPN can be provisioned at a site | TMF645 | TMF674 |
| Allocate a VLAN for a new service | TMF652 | TMF639 |
| Set a latency threshold alert | TMF648 | — |
| Onboard a new customer site | TMF641 + TMF674 | TMF639 |
| Retrieve SLA agreement for a service | TMF651 | TMF641 |
| Define an intent-based routing policy | TMF630 | — |

---

## After Selecting the API

1. Download the OpenAPI swagger JSON to `context/tmf/TMF[XXX].swagger.json`
2. Add the API reference to your spec under **Architecture Decisions**
3. If building a client/adapter: use the `spec-file` skill to formalise the integration spec
4. If writing YANG to map to TMF resources: cross-reference the TMF resource schema with your YANG data model — field names must align

---

## Escalation

If none of the 8 APIs clearly covers your use case, the TM Forum has 60+ APIs. Check the full catalogue at `https://www.tmforum.org/oda/open-apis/` before creating a custom model — there is likely an API that covers your domain. Document the decision in an ADR using the `oa-adr` skill.
