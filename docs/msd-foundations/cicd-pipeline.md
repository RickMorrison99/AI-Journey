# CI/CD Pipeline Health

!!! quote "Dave Farley, *Continuous Delivery*"
    "The deployment pipeline is the central mechanism by which we practice continuous delivery.
    Every change to the production codebase is assessed using this mechanism."

---

## The Pipeline as Deployment Assembly Line

A CI/CD pipeline is not a convenience — it is the only trusted path from a developer's workstation
to a running system. Dave Farley describes it as a *deployment assembly line*: a staged sequence of
automated quality gates through which every change passes before it can cause harm.

For the O&A team, "harm" has a specific meaning. A misconfigured YANG model pushed to a live network
element via NSO can take down services. A NETCONF RPC with incorrect namespace handling can leave
a router in a partially configured state. An Ansible playbook with broken idempotency logic can run
a destructive operation twice. These failures are not caught by human review alone — they require
automated gates that run consistently, every time, on every change.

**AI-generated code must enter the pipeline. It must never bypass it.**

This is the single most important rule for AI adoption in the O&A context. An LLM that generates
a YANG module in seconds still produces output that must traverse the same commit → validate →
test → deploy stages as anything a human authored. The speed benefit of AI is realised *through*
the pipeline, not by circumventing it.

---

## Anatomy of a Healthy CD Pipeline

Farley defines three primary stages. Below is the O&A-adapted version of each:

### Stage 1 — Commit Stage (< 5 minutes)

The fast-feedback gate. Every push to the trunk triggers this stage. If it fails, the developer
fixes it immediately — it is not a background task.

**What runs:**

| Check | O&A Tooling |
|---|---|
| Static analysis / linting | `pylint` / `ruff` (Python), `golangci-lint` (Go), `ansible-lint` |
| Unit tests | `pytest` (Python), `go test` (Go) |
| YANG syntax validation | `pyang --strict` or `yanglint` |
| YANG RFC compliance | `pyang -f yang` with RFC 7950 profile |
| OpenAPI spec lint | `spectral lint` against TM Forum ruleset |
| Ansible syntax check | `ansible-playbook --syntax-check` |
| NETCONF schema check | `ncclient` schema validation stub |
| Secret scanning | `gitleaks` or `truffleHog` |

**Signals of a healthy commit stage:**

- Runs in under 5 minutes on a standard CI runner.
- Breaks on any YANG leaf type mismatch, not just syntax errors.
- Breaks on any Ansible task that references an undefined variable.
- AI-generated code that contains a hardcoded IP address fails the secret scan.

### Stage 2 — Acceptance Stage (< 30 minutes)

Slower, higher-confidence tests that require real or emulated infrastructure.

**What runs:**

| Check | O&A Tooling |
|---|---|
| Integration tests | NETCONF session tests against `netsim` or `NSO built-in` network simulator |
| API contract tests | TMF API contract validation (e.g., TMF639 Resource Inventory conformance) |
| YANG-to-device mapping test | NSO dry-run commit against simulated device |
| Ansible idempotency test | Run playbook twice; assert no changes on second run |
| Python/Go service integration | API gateway contract tests, message bus consumer tests |
| Performance smoke test | Response time < SLA threshold under nominal load |

**Signals of a healthy acceptance stage:**

- Every NETCONF RPC exercised in at least one test scenario.
- Ansible playbooks verified idempotent on a clean and a pre-configured target.
- TMF API responses validated against the published schema, not just HTTP 200.

### Stage 3 — Production Deployment

Automated or one-click deployment to production, having passed all prior gates. For O&A, this may
involve:

- NSO commit to a staging network, then production via change-window automation.
- Blue/green or canary deployment of microservices behind an API gateway.
- Config-as-code changes (YANG, Ansible) gated by a change management approval step that is
  *triggered by* the pipeline, not a separate manual process.

---

## O&A-Specific Pipeline Considerations

### YANG Validation Gate

This is the highest-priority gate for the O&A team and the one most frequently skipped in teams
that lack pipeline discipline.

```yaml
# .gitlab-ci.yml excerpt — YANG validation stage
yang-validate:
  stage: commit
  image: python:3.12-slim
  script:
    - pip install pyang
    - |
      find . -name "*.yang" | while read f; do
        echo "Validating $f"
        pyang --strict --path ./yang/modules "$f" || exit 1
      done
    - |
      # Validate against standard module set (ietf, openconfig)
      pyang --strict \
            --path ./yang/modules \
            --path ./yang/vendor/ietf \
            --path ./yang/vendor/openconfig \
            ./yang/noa/*.yang
  rules:
    - changes:
        - "**/*.yang"
        - "yang/**"
```

!!! warning "AI and YANG"
    LLMs frequently generate YANG that passes syntax checks but violates RFC 7950 constraints —
    for example, using `leaf-list` where `list` with a key is required, or missing `must`
    constraints that enforce cross-leaf invariants. The `--strict` flag on `pyang` catches many
    of these. Always add `must` and `when` constraint review to your AI-generated YANG PR checklist.

### Network Config Lint

```yaml
# Ansible lint stage
ansible-lint:
  stage: commit
  image: pipelinecomponents/ansible-lint:latest
  script:
    - ansible-lint --profile production ./playbooks/
    - ansible-lint --profile production ./roles/
  rules:
    - changes:
        - "playbooks/**"
        - "roles/**"
        - "inventory/**"
```

### NETCONF Schema Check

For services that generate NETCONF RPCs programmatically (common in O&A Python services), validate
that generated XML conforms to the target device's advertised schema:

```python
# tools/validate_netconf_rpc.py — run in CI
from ncclient import manager
from lxml import etree

def validate_rpc_against_schema(rpc_xml: str, schema_dir: str) -> None:
    """Validate a generated NETCONF RPC against the device YANG schema."""
    schema_doc = etree.parse(f"{schema_dir}/device-schema.xsd")
    xmlschema = etree.XMLSchema(schema_doc)
    rpc_doc = etree.fromstring(rpc_xml.encode())
    if not xmlschema.validate(rpc_doc):
        raise ValueError(f"RPC validation failed: {xmlschema.error_log}")
```

### Ansible Syntax Validation

```bash
# Run as part of commit stage — fast, no inventory required
find ./playbooks -name "*.yml" -exec \
  ansible-playbook --syntax-check {} \;

# Idempotency test in acceptance stage — requires netsim target
ansible-playbook -i inventories/netsim ./playbooks/configure_interfaces.yml
ansible-playbook -i inventories/netsim ./playbooks/configure_interfaces.yml
# Second run must report: "changed=0"
```

---

## AI's Role in Pipeline Authoring

AI accelerates pipeline work in several concrete ways:

### Generating Pipeline Stages

**Prompt example:**
```
You are a CI/CD team member for a telecom automation team using GitLab CI.
Generate a pipeline stage that validates YANG models using pyang with the --strict flag,
searches recursively for .yang files, includes the ietf and openconfig vendor modules from
./yang/vendor/, and fails the build if any model fails validation.
The stage must run only when .yang files change.
```

AI produces a solid first draft. A human reviews the `--path` flags, the file discovery pattern,
and the failure semantics. This is a 10-minute task that would otherwise take 30 minutes.

### Generating Test Fixtures

AI is effective at generating YANG-conforming test data for acceptance stage test fixtures:

```
Given the following YANG model leaf definitions [paste relevant YANG],
generate five pytest parametrize test cases covering: valid input, missing mandatory
leaf, wrong type for 'bandwidth', boundary value for 'vlan-id', and a value that
violates the 'must' constraint on line 42.
```

### Writing Pipeline Stages for New Service Types

When the O&A team adds a new service type (e.g., a Go-based NETCONF proxy), AI can generate the
skeletal CI stage. The team reviews and adapts — AI provides the scaffolding, humans provide the
domain knowledge.

---

## Anti-Pattern: AI Code That Bypasses the Pipeline

!!! danger "Anti-Pattern — The Shortcut That Costs Everything"
    **Symptom:** An team member uses Copilot or ChatGPT to generate a YANG change and a Python
    configuration script, tests it manually against a dev device, and pushes directly to the
    staging branch "because the pipeline takes too long."

    **Why it happens:** The pipeline has a 25-minute acceptance stage, and the team member is
    under time pressure.

    **Why it is dangerous:** The AI-generated YANG has a subtle namespace error that `pyang`
    would have caught. The Python script has no idempotency guard. Both reach staging. The
    staging-to-production promotion is automated.

    **The fix:** The pipeline stage that takes 25 minutes is the acceptance stage for a reason.
    If it is too slow, *shorten the pipeline* — do not bypass it. Use `netsim` targets instead
    of real devices in acceptance. Parallelize stages. The 25 minutes is a problem to solve
    through engineering, not to sidestep through discipline erosion.

A related anti-pattern is using AI to generate code that *conditionally* skips pipeline gates:

```python
# AI-generated code — seemingly harmless, actually dangerous
if os.getenv("SKIP_VALIDATION") == "true":
    logger.warning("Skipping YANG validation")
    return config_payload
```

This pattern appears in AI output when the prompt includes phrases like "make it faster" or
"skip the slow checks in dev". Catch it in PR review.

---

## Maturity Levels

| Level | Signal | What It Means for AI |
|---|---|---|
| **0 — No pipeline** | Changes pushed directly to devices or deployed manually | AI output has no automated quality gate. Every AI-generated artefact is a manual review burden. Do not expand AI tooling. |
| **1 — Basic CI** | Linting and unit tests on push, but not YANG/Ansible-specific | AI can generate application code with confidence. Network config artefacts remain risky. |
| **2 — Network-aware pipeline** | YANG validation, Ansible lint, and syntax checks in commit stage | AI-generated config artefacts are caught at commit stage. Acceptance stage testing remains manual or absent. |
| **3 — Full acceptance automation** | NETCONF session tests, idempotency tests, TMF contract tests in acceptance stage | AI-generated code can be trusted at the acceptance stage boundary. Deployment to staging is automated. |
| **4 — Elite** | Pipeline is the single deployment path; AI assists in pipeline authoring and test generation; mean time to restore < 1 hour | AI is a genuine accelerant. Pipeline generates its own test fixtures from YANG models. Deployment is on-demand. |

Most O&A teams of 10–30 team members start at Level 1–2. The jump from Level 2 to Level 3 — adding
real acceptance stage automation against simulated network devices — is the highest-value investment
the team can make before expanding AI-assisted development.

---

## Checklist: Is Your Pipeline AI-Ready?

### Commit Stage

- [ ] `pyang --strict` runs on every `.yang` file change
- [ ] `ansible-lint` runs on every playbook and role change
- [ ] `ansible-playbook --syntax-check` runs on every `.yml` change in `playbooks/`
- [ ] `spectral lint` runs on every OpenAPI / AsyncAPI spec change
- [ ] Unit tests run and must pass — failure blocks merge
- [ ] Secret scanning (`gitleaks` or equivalent) runs on every commit
- [ ] No `SKIP_*` environment variable bypass paths exist in validation code

### Acceptance Stage

- [ ] NETCONF session tests run against `netsim` or NSO's built-in network simulation
- [ ] At least one Ansible idempotency test exists per playbook
- [ ] TMF API responses validated against published TM Forum schema
- [ ] AI-generated code is not merged without acceptance stage passing

### Pipeline Governance

- [ ] There is no manual deployment path that bypasses the pipeline
- [ ] Pipeline failures are the team's first-class priority (not "we'll fix it later")
- [ ] AI-generated pipeline stages are reviewed by a human before merging
- [ ] The pipeline runtime is tracked; stages taking > 10 minutes in commit stage are investigated

---

*Previous: [MSD Foundations Overview ←](index.md) | Next: [Testing Discipline →](testing-discipline.md)*
