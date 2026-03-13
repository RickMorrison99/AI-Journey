# Evolutionary Architecture & Fitness Functions

!!! quote "Neal Ford, Rebecca Parsons & Patrick Kua, *Building Evolutionary Architectures*"
    "An evolutionary architecture supports guided, incremental change as a first principle across
    multiple dimensions."

!!! quote "Gregor Hohpe, *The Software Architect Elevator*"
    "Architecture is not about predicting the future. It is about preserving optionality while
    delivering value today."

---

## Architecture for Change, Not for Prediction

Traditional architecture practice attempts to predict the future: define the system's structure
upfront, anticipate requirements, and build toward a stable endpoint. This approach fails in
any environment where requirements change — and in telecom automation, requirements change
constantly. New TM Forum releases, new network device generations, evolving NSO package APIs,
shifting orchestration patterns, and now AI tooling that changes how code is produced.

Evolutionary architecture inverts this approach. Instead of designing for a predicted future,
it designs for *changeability* — preserving the team's ability to make decisions when they have
more information, rather than locking in decisions when they have the least.

For the O&A team, this means:

- **YANG models** can be extended without breaking existing consumers.
- **Service boundaries** can be redrawn as understanding improves.
- **API contracts** change through versioning, not silent mutation.
- **Architectural decisions** are recorded, not assumed to be self-evident.

AI changes this landscape in a specific way: it makes architectural decisions *faster and more
frequent*. An LLM can suggest a service decomposition, a new interface pattern, or a data model
restructure in seconds. Without an evolutionary architecture approach, the team cannot tell whether
these suggestions are improvements or hidden regressions — they look equally coherent on the surface.

---

## Fitness Functions — Architecture as Automated Test

The most powerful concept in *Building Evolutionary Architectures* is the fitness function:
an automated check that verifies an architectural property. Fitness functions make architectural
rules as concrete and enforceable as unit tests.

A fitness function answers the question: *"Does our system still conform to the architectural
constraints we care about?"* It runs in CI. It fails loudly when violated. It is owned by the
team, not by a separate architecture board.

### What Makes a Good Fitness Function?

| Property | Description |
|---|---|
| **Automated** | Runs without human intervention — in CI, as part of the pipeline |
| **Objective** | Pass/fail — not a matter of interpretation |
| **Targeted** | Checks one architectural property at a time |
| **Fast enough** | Runs in the commit or acceptance stage; does not require production deployment |
| **Actionable** | Failure output tells the team member exactly what to fix |

### O&A-Specific Fitness Functions

The following fitness functions are recommended for the O&A team. Each maps to a real architectural
risk that AI adoption can introduce or accelerate.

---

#### FF-01: YANG RFC Compliance Check

**Property:** All O&A YANG models conform to RFC 7950 and the team's YANG style guide.

**Why it matters:** AI-generated YANG frequently drifts from RFC constraints. Common violations
include missing `namespace` uniqueness, incorrect `prefix` resolution, `must` expressions that
reference non-existent nodes, and `typedef` definitions that shadow standard types.

```yaml
# .gitlab-ci.yml
yang-rfc-compliance:
  stage: commit
  script:
    - |
      # pyang --strict enforces RFC 7950 compliance
      find ./yang/noa -name "*.yang" | while read f; do
        pyang --strict \
              --max-line-length 120 \
              --path ./yang/modules:./yang/vendor/ietf:./yang/vendor/openconfig \
              "$f" 2>&1 | tee -a yang-errors.log
      done
      if grep -q "error:" yang-errors.log; then
        echo "YANG RFC compliance fitness function FAILED"
        cat yang-errors.log
        exit 1
      fi
```

---

#### FF-02: TMF API Conformance Test

**Property:** All O&A REST APIs that implement a TM Forum API specification conform to the
published schema for that specification.

**Why it matters:** AI tools tend to generate "TMF-like" APIs that differ subtly from the
published spec — wrong field names, missing mandatory attributes, incorrect `@type` discriminators,
or response structures that omit required links. These violations break TMF ecosystem interoperability.

```python
# tests/fitness/test_tmf_conformance.py
import pytest
import jsonschema
import httpx
from pathlib import Path
import json

TMF_SCHEMAS = {
    "tmf639": Path("./schemas/tmf/TMF639-ResourceInventory-v4.0.0.schema.json"),
    "tmf641": Path("./schemas/tmf/TMF641-ServiceOrdering-v4.0.0.schema.json"),
    "tmf652": Path("./schemas/tmf/TMF652-ResourceOrderManagement-v4.0.0.schema.json"),
}

@pytest.fixture(scope="module")
def api_base_url():
    return "http://localhost:8080"  # O&A API gateway in acceptance environment

@pytest.mark.parametrize("endpoint,schema_key,payload", [
    (
        "/resourceInventoryManagement/v4/resource",
        "tmf639",
        {"name": "Router-A", "@type": "LogicalResource", "@baseType": "Resource"},
    ),
    (
        "/serviceOrderManagement/v4/serviceOrder",
        "tmf641",
        {
            "externalId": "so-test-001",
            "@type": "ServiceOrder",
            "serviceOrderItem": [
                {
                    "id": "1",
                    "action": "add",
                    "service": {"name": "L3VPN-test", "@type": "Service"},
                }
            ],
        },
    ),
])
def test_api_response_conforms_to_tmf_schema(
    api_base_url, endpoint, schema_key, payload
):
    """O&A API response bodies conform to the published TM Forum schema."""
    schema = json.loads(TMF_SCHEMAS[schema_key].read_text())
    response = httpx.post(f"{api_base_url}{endpoint}", json=payload)
    assert response.status_code in (200, 201), (
        f"Expected 2xx, got {response.status_code}: {response.text}"
    )
    try:
        jsonschema.validate(instance=response.json(), schema=schema)
    except jsonschema.ValidationError as e:
        pytest.fail(
            f"TMF schema conformance fitness function FAILED for {schema_key}:\n{e.message}"
        )
```

---

#### FF-03: No Hardcoded Network Element IPs in Application Code

**Property:** No Python, Go, or configuration file in `./services/` or `./orchestration/`
contains a hardcoded IPv4 or IPv6 address.

**Why it matters:** AI tools frequently inline example IP addresses from the prompt context
or from similar code in training data. Hardcoded addresses are both a security risk (potential
PII / infrastructure exposure) and a portability failure (breaks on every environment change).
All device addresses must come from the inventory service (TMF639) or from environment-injected
configuration.

```python
# tests/fitness/test_no_hardcoded_ips.py
import re
import pytest
from pathlib import Path

# Regex for IPv4 and IPv6 addresses
IPV4_RE = re.compile(r'\b(?:(?:25[0-5]|2[0-4]\d|[01]?\d\d?)\.){3}(?:25[0-5]|2[0-4]\d|[01]?\d\d?)\b')
IPV6_RE = re.compile(r'\b(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}\b')

# Allowed IPs: localhost, test ranges, documentation ranges only
ALLOWED_IPS = {
    "127.0.0.1", "0.0.0.0", "255.255.255.255",
    # RFC 5737 documentation ranges
    "192.0.2.", "198.51.100.", "203.0.113.",
    # RFC 3849 IPv6 documentation
    "2001:db8",
}

SCAN_DIRS = ["./services", "./orchestration", "./yang"]
EXCLUDE_DIRS = {".git", "__pycache__", ".pytest_cache", "tests/fixtures"}
SCAN_EXTENSIONS = {".py", ".go", ".yaml", ".yml", ".json"}

def collect_source_files():
    files = []
    for scan_dir in SCAN_DIRS:
        for path in Path(scan_dir).rglob("*"):
            if any(ex in path.parts for ex in EXCLUDE_DIRS):
                continue
            if path.suffix in SCAN_EXTENSIONS:
                files.append(path)
    return files

@pytest.mark.parametrize("source_file", collect_source_files())
def test_no_hardcoded_ip_addresses(source_file):
    """No production service code contains hardcoded IP addresses."""
    content = source_file.read_text(errors="replace")
    violations = []

    for match in IPV4_RE.finditer(content):
        ip = match.group()
        if not any(ip.startswith(allowed) for allowed in ALLOWED_IPS):
            line_num = content[:match.start()].count('\n') + 1
            violations.append(f"Line {line_num}: {ip}")

    assert not violations, (
        f"Hardcoded IP fitness function FAILED in {source_file}:\n"
        + "\n".join(violations)
        + "\nUse the inventory service (TMF639) or environment configuration instead."
    )
```

---

#### FF-04: No Direct Cross-Service Database Access

**Property:** No service in `./services/` imports or references the data model of another service's
internal persistence layer.

**Why it matters:** AI tools, when given a task spanning multiple services, will often suggest the
most direct path — which may be a direct database query across service boundaries. This introduces
coupling that makes each service harder to change independently.

```python
# tests/fitness/test_no_cross_service_db_access.py
"""
Each service must only access its own data models.
Service A must not import from service B's 'models' or 'db' modules.
"""
import ast
import pytest
from pathlib import Path

SERVICES_DIR = Path("./services")

def get_service_names():
    return [d.name for d in SERVICES_DIR.iterdir() if d.is_dir()]

def get_python_imports(file_path: Path) -> list[str]:
    try:
        tree = ast.parse(file_path.read_text())
    except SyntaxError:
        return []
    imports = []
    for node in ast.walk(tree):
        if isinstance(node, ast.ImportFrom) and node.module:
            imports.append(node.module)
        elif isinstance(node, ast.Import):
            for alias in node.names:
                imports.append(alias.name)
    return imports

@pytest.mark.parametrize("service_name", get_service_names())
def test_service_does_not_import_sibling_service_db(service_name):
    """Services do not import from sibling service database or model modules."""
    service_path = SERVICES_DIR / service_name
    other_services = [s for s in get_service_names() if s != service_name]

    violations = []
    for py_file in service_path.rglob("*.py"):
        imports = get_python_imports(py_file)
        for imp in imports:
            for other in other_services:
                if f"services.{other}.models" in imp or f"services.{other}.db" in imp:
                    violations.append(f"{py_file}: imports {imp}")

    assert not violations, (
        f"Cross-service DB access fitness function FAILED for service '{service_name}':\n"
        + "\n".join(violations)
        + "\nAccess other service data through its published API, not its internal models."
    )
```

---

#### FF-05: All Operational APIs Are Spec-First (OpenAPI / AsyncAPI Present)

**Property:** Every HTTP API endpoint in `./services/` has a corresponding OpenAPI or AsyncAPI
spec in `./specs/`.

```bash
# tests/fitness/check_spec_coverage.sh
#!/usr/bin/env bash
set -euo pipefail

MISSING=0
for service_dir in ./services/*/; do
  service=$(basename "$service_dir")
  if [ ! -f "./specs/${service}.openapi.yaml" ] && [ ! -f "./specs/${service}.asyncapi.yaml" ]; then
    echo "FITNESS FUNCTION FAILED: No spec found for service '${service}'"
    echo "  Expected: ./specs/${service}.openapi.yaml or ./specs/${service}.asyncapi.yaml"
    MISSING=1
  fi
done

if [ $MISSING -eq 1 ]; then
  echo ""
  echo "All O&A services must have an OpenAPI or AsyncAPI spec before implementation."
  echo "Use AI to draft the spec from the service description, then validate with Spectral."
  exit 1
fi

echo "Spec coverage fitness function PASSED — all services have specs."
```

---

## Architectural Decision Records (ADRs)

An ADR is a short document that records a significant architectural decision: the context that
drove it, the decision made, the consequences (positive and negative), and the alternatives
considered.

ADRs serve two purposes in an AI-assisted team:

1. **Human accountability for AI-assisted decisions** — when an LLM suggests an architectural
   pattern (e.g., "use a saga pattern for distributed service orchestration"), the ADR records
   that a human evaluated it, understood the trade-offs, and accepted responsibility for the
   decision.

2. **Context for future AI prompts** — ADRs in the repository become context that can be fed
   to AI tools when making related decisions: *"Given these existing ADRs [paste], should we
   use the same pattern for the new Resource Facing Service?"*

### O&A ADR Template

```markdown
# ADR-NNN: [Decision Title]

**Date:** YYYY-MM-DD
**Status:** Proposed | Accepted | Deprecated | Superseded by ADR-NNN
**Deciders:** [Names or roles — who reviewed and accepted this]
**AI Assistance:** [Yes/No — was AI used to draft or analyse this decision?]

---

## Context

What is the situation that requires a decision? What forces are at play?
Include O&A-specific context: which services are affected, which TM Forum
processes (eTOM IDs), which network device types.

## Decision

What is the architectural decision being made? State it clearly and unambiguously.

## Consequences

**Positive:**
- ...

**Negative / Trade-offs:**
- ...

**Neutral / Notes:**
- ...

## Alternatives Considered

| Alternative | Reason Not Chosen |
|---|---|
| ... | ... |

## Fitness Function Impact

Does this decision require a new fitness function, or does it change an existing one?
If yes, link to the fitness function test file.
```

### Example ADR — NETCONF Session Pooling

```markdown
# ADR-012: NETCONF Session Pooling via ncclient Connection Pool

**Date:** 2024-11-15
**Status:** Accepted
**Deciders:** Lead Team Member, Platform Architect
**AI Assistance:** Yes — AI drafted alternatives analysis; human reviewed and decided

## Context

The O&A provisioning service opens a new NETCONF session per provisioning request.
Under load testing (50 concurrent requests), this causes session establishment latency
to dominate response time (avg 1.8s for session setup vs 0.3s for the RPC itself).
ncclient does not natively support connection pooling.

## Decision

Implement a NETCONF session pool using a thread-safe queue of ncclient Manager objects.
Pool size: configurable, default 10. Idle sessions kept alive with a keepalive thread.
Session health checked before returning from pool; unhealthy sessions replaced.

## Consequences

**Positive:**
- Session establishment overhead eliminated for steady-state traffic
- Provisioning response time under load reduced from ~2.1s to ~0.4s

**Negative / Trade-offs:**
- Pool management adds ~200 lines of infrastructure code
- Session state (e.g., locked datastores) can leak between requests if not cleared properly
  — mitigated by always calling discard-changes and unlock before returning to pool

## Alternatives Considered

| Alternative | Reason Not Chosen |
|---|---|
| Persistent per-device sessions (not pooled) | Scales poorly — one thread per device |
| Async NETCONF (asyncio + asyncssh) | Requires rewrite of all ncclient usage; deferred to next quarter |
| Vendor-managed session pooling via NSO | Introduces NSO as mandatory dependency for all NETCONF operations |

## Fitness Function Impact

New fitness function FF-06 added: "NETCONF session pool must release sessions within 5s
of request completion" — verified by integration test with pool exhaustion scenario.
```

---

## How AI Changes Architectural Risk

AI tools introduce three specific architectural risks that the O&A team should monitor:

### Risk 1: Plausible-Looking Anti-Patterns

An LLM asked to "connect service A to service B" will often suggest the simplest implementation —
direct HTTP call, shared database, or an in-process import. These are architecturally problematic
(tight coupling, shared mutable state, SoC violation) but look reasonable in isolation.

**Mitigation:** Fitness functions FF-04 (no cross-service DB) catch many of these automatically.
ADRs on service interaction patterns provide the context for future AI-assisted decisions.

### Risk 2: Premature Complexity

LLMs trained on large open-source codebases have seen many enterprise patterns — CQRS, event
sourcing, saga orchestration. They will suggest these patterns for problems that don't require them,
producing architecturally correct but unnecessarily complex solutions.

**Mitigation:** Architecture review gate for AI-suggested refactors that introduce new patterns.
The question to ask: *"What is the simplest architecture that keeps this option open?"*

### Risk 3: Specification Drift

AI tools generate code from prompts, not from the team's YANG models or OpenAPI specs. Without
spec-first discipline, AI can produce implementations that are internally consistent but diverge
from the canonical specification. Over time, the spec and the code describe different systems.

**Mitigation:** Fitness function FF-05 (all services have specs). CI gate that rejects code
not generated from (or validated against) the spec. YANG as the canonical schema source.

---

## AI's Role in Evolutionary Architecture

When the foundations are in place, AI accelerates architectural work:

### Drafting ADRs

```
Prompt: "We are deciding whether to adopt RESTCONF as an alternative to NETCONF for
device configuration in our O&A platform. Here are our existing ADRs for context
[paste ADR-001 through ADR-011]. Draft an ADR using our template covering:
context (why we're considering this), the decision (adopt / defer / reject), consequences,
and at least three alternatives. Flag any TM Forum compliance implications."
```

AI produces a comprehensive first draft. A human reviews the technical accuracy, adds O&A-specific
context the LLM cannot know, and signs off as the decision owner.

### Running Conformance Checks

AI assists in writing the fitness function tests themselves. Given a fitness function description
in plain language, AI generates the test implementation. The team reviews and adapts.

### Suggesting Refactors Within Constraints

When the team needs to refactor a service, the system prompt for the AI session should include
the relevant architectural constraints:

```
System prompt: "You are a senior team member on the O&A team. The following constraints apply
to all code you produce:
1. Services may not directly import from sibling service modules.
2. All inter-service communication is via REST (TMF-compliant APIs) or async messaging.
3. YANG models are the canonical schema — do not define data structures that duplicate them.
4. No hardcoded IP addresses.
ADRs in effect: [paste relevant ADRs]
Fitness functions in effect: [paste fitness function descriptions]"
```

---

## Checklist: Evolutionary Architecture Foundations

### Fitness Functions

- [ ] YANG RFC compliance check runs in commit stage.
- [ ] TMF API conformance test runs in acceptance stage.
- [ ] No-hardcoded-IP fitness function runs in commit stage.
- [ ] No-cross-service-DB-access fitness function runs in commit stage.
- [ ] All services have corresponding API specs (fitness function or manual check).

### ADRs

- [ ] ADR template is in the repository and linked from the team wiki.
- [ ] ADRs are written for all significant architectural decisions (not just initial ones).
- [ ] ADRs include an "AI Assistance" field — transparency about AI-drafted decisions.
- [ ] AI-suggested architectural patterns are captured in ADRs with human sign-off.
- [ ] ADRs are referenced in AI session system prompts when working in affected areas.

### Governance

- [ ] AI-suggested refactors that touch service boundaries require architecture review.
- [ ] New architectural patterns (saga, CQRS, event sourcing) require an ADR before implementation.
- [ ] Fitness function failures are treated as first-class build failures, not warnings.
- [ ] The team reviews fitness function coverage quarterly — are the right properties being checked?

---

*Previous: [Testing Discipline ←](testing-discipline.md) | Next: [Trunk-Based Development →](trunk-based-dev.md)*
