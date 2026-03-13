# Custom AI Pipelines Playbook — O&A Team

> **Applies to:** CI/CD pipelines, automation scripts, local LLM inference  
> **Audience:** O&A team members (10–30), Python/Go, YANG/NETCONF, Ansible, NSO, TM Forum Open APIs  
> **Models covered:** Ollama (local), IBM Granite Code, Llama 3.1, CodeLlama, Mistral  
> **Last reviewed:** 2025

---

## What Custom Pipelines Are

Custom AI pipelines are AI capabilities built directly into the team's CI/CD or automation workflows —
not off-the-shelf chat tools or IDE assistants. The AI component is invoked programmatically, receives
structured input, and produces structured output that is validated before use.

**Why build custom rather than use a chat tool or SaaS API:**

- **Data sensitivity:** network configurations, alarm payloads, and CDB exports cannot leave your
  infrastructure. A local pipeline never sends data to an external API.
- **Cost control:** repetitive pipeline tasks (e.g., summarising every PR diff) accumulate significant
  API costs. A local 8B model running on team hardware costs a fixed amount of electricity.
- **Model choice freedom:** you choose the model, version, and update cadence. No surprise behaviour
  changes from a vendor's silent model update.
- **Telecom-domain specificity:** prompts and post-processing logic can be tuned to YANG, NETCONF, and
  TM Forum patterns in ways that generic SaaS tools cannot be.
- **Vendor concentration:** custom pipelines on OSS models (Llama, Granite, Mistral) reduce dependence
  on hyperscaler APIs and support the strategy in `docs/responsible-ai/market-concentration.md`.
- **SCI optimisation:** a local 8B model uses roughly 100× less energy per token than a large hosted
  API model. For high-volume pipeline tasks, this is material.

---

## When to Build vs Use an Existing Tool

| Factor | Build Custom Pipeline | Use Existing Tool (Chat / Copilot) |
|---|---|---|
| Data sensitivity | High — network configs, alarms, topology | Low — generic code, documentation |
| Task repeatability | High — same pattern runs many times per day | Low — one-off or exploratory |
| Telecom domain specificity | High — YANG, NETCONF, TM Forum | Low — general software engineering |
| Cost at scale | Matters — >100 runs/day | Not critical — occasional use |
| Time to value | Acceptable: 1–3 weeks to build and test | Required: hours |
| Maintenance willingness | Yes — team owns the pipeline | No — prefer vendor-maintained |
| Model output must be validated | Yes — output feeds automation | No — human reviews output |

**If three or more rows land in the left column, build custom. Otherwise, use existing tools.**

---

## Pipeline Pattern 1: YANG → Python Dataclass Generation

### What it does

Takes a validated YANG module and generates Python dataclasses with type annotations that match the
YANG leaf types. Eliminates the manual mapping step when writing service models or test fixtures.

### When to use it

- After adding or modifying a YANG module, as a CI step that keeps Python data structures in sync
- When onboarding a new NED or vendor YANG module that the team needs to work with in Python

### Pipeline flow

```
YANG module (.yang)
      │
      ▼
pyang validation ──── fail → block PR
      │ pass
      ▼
LLM: CodeLlama or Granite (local Ollama)
      │
      ▼
Generated Python dataclasses
      │
      ▼
mypy type check ──── fail → block PR
      │ pass
      ▼
Commit generated file to repo
```

### Python implementation

```python
#!/usr/bin/env python3
"""yang_to_dataclass.py — Generate Python dataclasses from a YANG module via Ollama."""

import sys
import subprocess
import textwrap
import requests

OLLAMA_URL = "http://localhost:11434/api/generate"
MODEL = "granite-code:20b"  # or codellama:34b


def validate_yang(yang_path: str) -> bool:
    result = subprocess.run(
        ["pyang", "--strict", yang_path],
        capture_output=True,
        text=True,
    )
    if result.returncode != 0:
        print(f"pyang validation failed:\n{result.stderr}", file=sys.stderr)
    return result.returncode == 0


def build_prompt(yang_source: str) -> str:
    return textwrap.dedent(f"""
        You are a Python code generator for network automation systems.
        Convert the following YANG module into Python dataclasses.

        Rules:
        - Use @dataclass with type annotations
        - Map YANG types: string→str, uint32→int, boolean→bool, decimal64→float,
          enumeration→use Enum, list→List, container→nested dataclass
        - Use Optional[T] for nodes that are not mandatory
        - Preserve the YANG node names as Python field names (use snake_case if needed)
        - Include a module-level docstring naming the YANG module and revision
        - Do NOT include any imports other than: dataclasses, typing, enum
        - Output ONLY valid Python code — no explanation, no markdown fences

        YANG module:
        {yang_source}
    """).strip()


def generate_dataclass(yang_source: str) -> str:
    payload = {
        "model": MODEL,
        "prompt": build_prompt(yang_source),
        "stream": False,
        "options": {"temperature": 0.1, "num_predict": 2048},
    }
    response = requests.post(OLLAMA_URL, json=payload, timeout=120)
    response.raise_for_status()
    return response.json()["response"].strip()


def validate_python(code: str, output_path: str) -> bool:
    with open(output_path, "w") as f:
        f.write(code)
    result = subprocess.run(
        ["python3", "-m", "py_compile", output_path],
        capture_output=True,
        text=True,
    )
    return result.returncode == 0


def main() -> None:
    if len(sys.argv) != 3:
        print("Usage: yang_to_dataclass.py <input.yang> <output.py>", file=sys.stderr)
        sys.exit(1)

    yang_path, output_path = sys.argv[1], sys.argv[2]

    if not validate_yang(yang_path):
        sys.exit(1)

    with open(yang_path) as f:
        yang_source = f.read()

    print(f"Generating dataclasses for {yang_path} using {MODEL}...")
    code = generate_dataclass(yang_source)

    if not validate_python(code, output_path):
        print(f"Generated code failed py_compile — check {output_path}", file=sys.stderr)
        sys.exit(1)

    print(f"Written to {output_path}")


if __name__ == "__main__":
    main()
```

### GitHub Actions integration

```yaml
# .github/workflows/yang-dataclass-gen.yml
name: YANG → Dataclass Generation

on:
  pull_request:
    paths:
      - "yang/**/*.yang"

jobs:
  generate:
    runs-on: self-hosted  # requires Ollama installed on the runner
    steps:
      - uses: actions/checkout@v4

      - name: Set up Python
        uses: actions/setup-python@v5
        with:
          python-version: "3.12"

      - name: Install dependencies
        run: pip install pyang requests mypy

      - name: Generate dataclasses for changed YANG files
        run: |
          git diff --name-only origin/${{ github.base_ref }} HEAD \
            | grep '\.yang$' \
            | while read yang_file; do
                out="generated/$(basename "${yang_file%.yang}_model.py")"
                python3 scripts/yang_to_dataclass.py "$yang_file" "$out"
              done

      - name: Type-check generated files
        run: mypy generated/ --ignore-missing-imports

      - name: Commit generated files
        uses: stefanzweifel/git-auto-commit-action@v5
        with:
          commit_message: "chore: regenerate dataclasses from YANG [skip ci]"
          file_pattern: "generated/*.py"
```

---

## Pipeline Pattern 2: Config Diff → Human-Readable Summary

### What it does

Takes a `git diff` of an Ansible inventory file or YANG configuration change and generates a concise
plain-English summary of what changed and why it matters operationally.

### When to use it

- Automated PR description generation: post the summary as a PR comment so reviewers understand the
  change without reading raw YANG or Ansible YAML
- Change review notifications: enrich Slack/Teams alerts with a readable summary
- Audit trail entries: attach to change management tickets automatically

### Python implementation

```python
#!/usr/bin/env python3
"""diff_summary.py — Summarise a config diff using a local LLM via Ollama."""

import subprocess
import sys
import textwrap
import requests

OLLAMA_URL = "http://localhost:11434/api/generate"
MODEL = "llama3.1:8b"
MAX_DIFF_CHARS = 8000  # truncate very large diffs


def get_diff(base_ref: str = "HEAD~1", head_ref: str = "HEAD") -> str:
    result = subprocess.run(
        ["git", "diff", base_ref, head_ref, "--", "*.yang", "*.yml", "*.yaml", "inventory/"],
        capture_output=True,
        text=True,
        check=True,
    )
    return result.stdout[:MAX_DIFF_CHARS]


def build_prompt(diff: str) -> str:
    return textwrap.dedent(f"""
        You are reviewing a configuration change for a telecom network automation system.
        The change may involve YANG data models, Ansible inventory, or NSO service templates.

        Summarise this diff in plain English for a network team member. Structure your response as:

        **What changed:** (2–4 bullet points describing the specific changes)
        **Operational impact:** (1–2 sentences — what will behave differently after this change)
        **Review focus:** (1–2 sentences — what a reviewer should pay particular attention to)

        Be specific. Do not use generic phrases like "various improvements were made".
        If the diff is too small to assess operational impact, say so.

        Diff:
        {diff}
    """).strip()


def summarise_diff(diff: str) -> str:
    payload = {
        "model": MODEL,
        "prompt": build_prompt(diff),
        "stream": False,
        "options": {"temperature": 0.2, "num_predict": 512},
    }
    response = requests.post(OLLAMA_URL, json=payload, timeout=60)
    response.raise_for_status()
    return response.json()["response"].strip()


def post_pr_comment(summary: str, github_token: str, repo: str, pr_number: str) -> None:
    import json
    import urllib.request

    body = json.dumps({"body": f"### AI Config Change Summary\n\n{summary}\n\n---\n*Generated by local LLM — review before relying on this summary.*"})
    req = urllib.request.Request(
        f"https://api.github.com/repos/{repo}/issues/{pr_number}/comments",
        data=body.encode(),
        headers={"Authorization": f"Bearer {github_token}", "Content-Type": "application/json"},
        method="POST",
    )
    urllib.request.urlopen(req)


def main() -> None:
    diff = get_diff(
        base_ref=sys.argv[1] if len(sys.argv) > 1 else "HEAD~1",
        head_ref=sys.argv[2] if len(sys.argv) > 2 else "HEAD",
    )
    if not diff.strip():
        print("No relevant diff found.")
        return

    print(summarise_diff(diff))


if __name__ == "__main__":
    main()
```

### GitHub Actions integration

```yaml
# .github/workflows/diff-summary.yml
name: Config Diff Summary

on:
  pull_request:
    paths:
      - "yang/**"
      - "inventory/**"
      - "playbooks/**"

jobs:
  summarise:
    runs-on: self-hosted
    permissions:
      pull-requests: write
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: Install dependencies
        run: pip install requests

      - name: Generate diff summary
        id: summary
        run: |
          SUMMARY=$(python3 scripts/diff_summary.py \
            origin/${{ github.base_ref }} \
            ${{ github.sha }})
          echo "summary<<EOF" >> $GITHUB_OUTPUT
          echo "$SUMMARY" >> $GITHUB_OUTPUT
          echo "EOF" >> $GITHUB_OUTPUT

      - name: Post PR comment
        uses: actions/github-script@v7
        with:
          script: |
            github.rest.issues.createComment({
              issue_number: context.issue.number,
              owner: context.repo.owner,
              repo: context.repo.repo,
              body: `### AI Config Change Summary\n\n${{ steps.summary.outputs.summary }}\n\n---\n*Generated by local LLM — verify before relying on this summary.*`
            })
```

---

## Pipeline Pattern 3: NETCONF Alarm → Incident Summary

### What it does

Receives a NETCONF notification XML payload (alarm or event) from a network device and generates a
structured incident summary: affected device, alarm type, potential impact, and recommended first action.

### Privacy note

This pipeline runs entirely locally. No alarm data leaves your infrastructure. This is the correct
pattern for alarm payloads, which often contain device identifiers and network topology information
that must not be sent to external APIs.

### Python implementation

```python
#!/usr/bin/env python3
"""alarm_summary.py — Enrich a NETCONF alarm notification with an LLM-generated summary."""

import json
import sys
import textwrap
import xml.etree.ElementTree as ET
import requests

OLLAMA_URL = "http://localhost:11434/api/generate"
MODEL = "llama3.1:8b"

NETCONF_NOTIF_NS = "urn:ietf:params:xml:ns:netconf:notification:1.0"
IETF_ALARMS_NS = "urn:ietf:params:xml:ns:yang:ietf-alarms"


def parse_alarm(xml_payload: str) -> dict:
    """Extract key fields from a NETCONF alarm notification."""
    root = ET.fromstring(xml_payload)

    def find_text(tag: str, ns: str = IETF_ALARMS_NS) -> str:
        el = root.find(f".//{{{ns}}}{tag}")
        return el.text.strip() if el is not None and el.text else "unknown"

    return {
        "resource": find_text("resource"),
        "alarm_type_id": find_text("alarm-type-id"),
        "alarm_type_qualifier": find_text("alarm-type-qualifier"),
        "perceived_severity": find_text("perceived-severity"),
        "alarm_text": find_text("alarm-text"),
        "time_created": find_text("time-created"),
    }


def build_prompt(alarm: dict) -> str:
    return textwrap.dedent(f"""
        You are a network operations assistant. An alarm has been raised on a managed device.
        Provide a structured incident summary based only on the alarm data provided.

        Alarm data:
        - Resource: {alarm['resource']}
        - Alarm type: {alarm['alarm_type_id']} / {alarm['alarm_type_qualifier']}
        - Severity: {alarm['perceived_severity']}
        - Alarm text: {alarm['alarm_text']}
        - Time: {alarm['time_created']}

        Respond in this exact JSON format:
        {{
          "headline": "<one-sentence summary of the alarm>",
          "likely_impact": "<what network services or functions may be affected>",
          "first_action": "<the single most important first diagnostic step>",
          "escalate_if": "<condition under which the on-call team member should escalate>"
        }}

        Base your response only on the alarm data. Do not speculate beyond it.
        Output valid JSON only — no explanation, no markdown.
    """).strip()


def generate_summary(alarm: dict) -> dict:
    payload = {
        "model": MODEL,
        "prompt": build_prompt(alarm),
        "stream": False,
        "options": {"temperature": 0.1, "num_predict": 256},
    }
    response = requests.post(OLLAMA_URL, json=payload, timeout=60)
    response.raise_for_status()
    raw = response.json()["response"].strip()
    return json.loads(raw)


def enrich_alarm(xml_payload: str) -> dict:
    alarm = parse_alarm(xml_payload)
    summary = generate_summary(alarm)
    return {"alarm": alarm, "summary": summary}


def main() -> None:
    xml_payload = sys.stdin.read()
    result = enrich_alarm(xml_payload)
    print(json.dumps(result, indent=2))


if __name__ == "__main__":
    main()
```

### Integration with an incident management system

```python
# alarm_handler.py — subscribe to NETCONF notifications and forward enriched alerts
import json
import subprocess
from ncclient import manager  # type: ignore

INCIDENT_WEBHOOK = "https://your-incident-system.internal/api/alerts"


def handle_notification(notification_xml: str) -> None:
    result = subprocess.run(
        ["python3", "scripts/alarm_summary.py"],
        input=notification_xml,
        capture_output=True,
        text=True,
        timeout=90,
    )
    if result.returncode != 0:
        print(f"alarm_summary.py failed: {result.stderr}")
        return

    enriched = json.loads(result.stdout)
    # Post enriched alert to your incident management system
    # import requests; requests.post(INCIDENT_WEBHOOK, json=enriched)
    print(json.dumps(enriched, indent=2))
```

---

## Pipeline Pattern 4: OpenAPI Spec → Typed Python Client

### What it does

Takes a TM Forum Open API YAML specification (e.g., TMF639 Resource Inventory, TMF641 Service Order)
and generates a typed Python client with the key operations, error handling, and retry logic.

### When to use it

When onboarding a new TM Forum API integration and you need a first-cut client to build tests against
before the full implementation. The generated client is a starting point — review and extend it.

### Prompt template (used inside the pipeline)

```
You are generating a Python API client for a TM Forum Open API.
I will provide the OpenAPI YAML specification.

Generate a Python client class with:
1. A constructor that accepts base_url and an optional Bearer token
2. One method per GET/POST/PATCH operation in the spec, using the operationId as the method name
3. Full type annotations using dataclasses or TypedDict for request and response bodies
4. Raise a specific exception (not generic Exception) on HTTP 4xx and 5xx responses
5. A retry decorator (max 3 attempts, exponential backoff) on all methods
6. A module-level docstring naming the API, TMF number, and spec version

Use only: requests, dataclasses, typing, time, functools — no third-party libraries.
Output valid Python only — no explanation, no markdown fences.

OpenAPI YAML:
{spec_yaml}
```

### Python implementation

```python
#!/usr/bin/env python3
"""tmf_client_gen.py — Generate a typed Python client from a TM Forum OpenAPI spec."""

import sys
import textwrap
import subprocess
import requests
import yaml  # pip install pyyaml

OLLAMA_URL = "http://localhost:11434/api/generate"
MODEL = "granite-code:20b"
MAX_SPEC_CHARS = 12000  # truncate very large specs; include key paths only


def load_spec(spec_path: str) -> dict:
    with open(spec_path) as f:
        return yaml.safe_load(f)


def trim_spec(spec: dict) -> str:
    """Keep info, components/schemas, and paths — drop examples and descriptions to save tokens."""
    trimmed = {
        "info": spec.get("info", {}),
        "paths": spec.get("paths", {}),
        "components": {"schemas": spec.get("components", {}).get("schemas", {})},
    }
    serialised = yaml.dump(trimmed, default_flow_style=False)
    return serialised[:MAX_SPEC_CHARS]


def build_prompt(spec_yaml: str) -> str:
    template = textwrap.dedent("""
        You are generating a Python API client for a TM Forum Open API.
        I will provide the OpenAPI YAML specification.

        Generate a Python client class with:
        1. A constructor that accepts base_url and an optional Bearer token
        2. One method per GET/POST/PATCH operation, using operationId as the method name
        3. Full type annotations using dataclasses or TypedDict for request/response bodies
        4. Raise a specific TMFAPIError exception (not generic Exception) on HTTP 4xx/5xx
        5. A retry decorator (max 3 attempts, exponential backoff) on all methods
        6. A module-level docstring naming the API, TMF number, and spec version

        Use only: requests, dataclasses, typing, time, functools — no third-party libraries.
        Output valid Python only — no explanation, no markdown fences.

        OpenAPI YAML:
        {spec_yaml}
    """).strip()
    return template.format(spec_yaml=spec_yaml)


def generate_client(spec_yaml: str) -> str:
    payload = {
        "model": MODEL,
        "prompt": build_prompt(spec_yaml),
        "stream": False,
        "options": {"temperature": 0.1, "num_predict": 4096},
    }
    response = requests.post(OLLAMA_URL, json=payload, timeout=180)
    response.raise_for_status()
    return response.json()["response"].strip()


def validate_python(code: str, output_path: str) -> bool:
    with open(output_path, "w") as f:
        f.write(code)
    result = subprocess.run(
        ["python3", "-m", "py_compile", output_path],
        capture_output=True,
        text=True,
    )
    return result.returncode == 0


def main() -> None:
    if len(sys.argv) != 3:
        print("Usage: tmf_client_gen.py <spec.yaml> <output_client.py>", file=sys.stderr)
        sys.exit(1)

    spec_path, output_path = sys.argv[1], sys.argv[2]
    spec = load_spec(spec_path)
    spec_yaml = trim_spec(spec)

    print(f"Generating client for {spec.get('info', {}).get('title', spec_path)}...")
    code = generate_client(spec_yaml)

    if not validate_python(code, output_path):
        print(f"Generated code failed py_compile — inspect {output_path}", file=sys.stderr)
        sys.exit(1)

    print(f"Client written to {output_path}")
    print("Next steps: run mypy, review against mock server, add to test suite")


if __name__ == "__main__":
    main()
```

---

## OSS Model Setup Guide

### Ollama Setup (for local pipeline use)

Ollama provides a local inference server with an OpenAI-compatible API. Required on any runner or
developer machine that executes the pipeline scripts above.

```bash
# Install Ollama (Linux)
curl -fsSL https://ollama.ai/install.sh | sh

# Verify the service is running
ollama list

# Pull models suitable for O&A pipelines
ollama pull codellama:34b        # Best for code generation (YANG→dataclass, client gen)
ollama pull granite-code:20b     # IBM Granite — Apache 2.0, enterprise-safe licence
ollama pull llama3.1:8b          # Fast; good for summarisation (diff summary, alarms)
ollama pull mistral:7b           # Efficient general reasoning, small footprint

# Pin a specific model version for reproducibility
ollama pull llama3.1:8b-instruct-q4_K_M

# Test the API (same interface used by pipeline scripts)
curl http://localhost:11434/api/generate \
  -d '{"model":"llama3.1:8b","prompt":"Summarise RFC 6241 in one sentence.","stream":false}'
```

**Python snippet — reusable Ollama client wrapper:**

```python
# noa_pipelines/ollama_client.py
import requests
from dataclasses import dataclass


@dataclass
class OllamaConfig:
    base_url: str = "http://localhost:11434"
    model: str = "llama3.1:8b"
    temperature: float = 0.1
    num_predict: int = 1024
    timeout: int = 120


def generate(prompt: str, config: OllamaConfig | None = None) -> str:
    cfg = config or OllamaConfig()
    payload = {
        "model": cfg.model,
        "prompt": prompt,
        "stream": False,
        "options": {
            "temperature": cfg.temperature,
            "num_predict": cfg.num_predict,
        },
    }
    response = requests.post(
        f"{cfg.base_url}/api/generate",
        json=payload,
        timeout=cfg.timeout,
    )
    response.raise_for_status()
    return response.json()["response"].strip()
```

### Model Selection Guide for O&A Pipelines

| Pipeline task | Recommended model | Why | Relative SCI |
|---|---|---|---|
| YANG → dataclass generation | `granite-code:20b` | Best code quality; Apache 2.0 licence | Medium |
| YANG → dataclass (fast CI) | `codellama:13b` | Acceptable quality; faster inference | Low–Medium |
| Config diff summarisation | `llama3.1:8b` | Sufficient for prose; fast | Low |
| NETCONF alarm enrichment | `llama3.1:8b` | JSON output task; 8B is enough | Low |
| TMF client generation | `granite-code:20b` | Complex typed code; quality matters | Medium |
| RFC Q&A (offline) | `llama3.1:70b` | Better reasoning; use for important decisions | High |

### IBM Granite Code (recommended for enterprise / telecom)

IBM Granite Code models are the preferred choice for production O&A pipelines where licensing risk
is a concern.

**Why Granite for O&A:**

- **Apache 2.0 licence:** safe for commercial use and internal redistribution without legal review
- **IBM enterprise support:** available via WatsonX if the team needs SLAs and audit trails
- **Curated training data:** Granite models are trained on data with cleared licensing, reducing the
  risk that generated code reproduces copyrighted material
- **Code quality:** Granite Code 20B is competitive with CodeLlama 34B on many benchmarks at lower
  resource cost

**Using Granite via Ollama (local, no IBM account needed):**

```bash
ollama pull granite-code:20b
# Then use model="granite-code:20b" in pipeline scripts — no other changes needed
```

**Using Granite via IBM WatsonX API (for audit trail / enterprise SLA):**

```python
# watsonx_client.py — drop-in replacement for Ollama generate() function
import requests
import os


def generate_watsonx(prompt: str, model_id: str = "ibm/granite-20b-code-instruct") -> str:
    token = os.environ["WATSONX_API_KEY"]
    project_id = os.environ["WATSONX_PROJECT_ID"]
    url = "https://us-south.ml.cloud.ibm.com/ml/v1/text/generation?version=2023-05-29"
    payload = {
        "model_id": model_id,
        "input": prompt,
        "parameters": {"decoding_method": "greedy", "max_new_tokens": 1024},
        "project_id": project_id,
    }
    response = requests.post(
        url,
        json=payload,
        headers={"Authorization": f"Bearer {token}", "Content-Type": "application/json"},
        timeout=120,
    )
    response.raise_for_status()
    return response.json()["results"][0]["generated_text"].strip()
```

---

## Security for Custom Pipelines

### Pipeline prompt injection

If your pipeline reads external data (device outputs, vendor YANG modules, external notifications)
before constructing a prompt, that data can contain adversarial instructions.

**Mitigation:**

```python
def sanitise_for_prompt(raw_input: str, max_chars: int = 8000) -> str:
    """Strip characters that could act as prompt delimiters, truncate to safe length."""
    # Remove common prompt injection patterns
    dangerous_patterns = [
        "ignore previous instructions",
        "disregard the above",
        "new instruction:",
        "system:",
        "assistant:",
    ]
    cleaned = raw_input[:max_chars]
    for pattern in dangerous_patterns:
        cleaned = cleaned.replace(pattern, "[REMOVED]")
    return cleaned
```

For YANG and XML inputs, parse and re-serialise with your XML/YANG library before embedding in a
prompt. Never embed raw external input directly into a prompt string.

### Output validation gates

Never pipe LLM output directly to execution. Every pipeline must validate output before using it.

| Pipeline output type | Validation gate |
|---|---|
| Python code | `py_compile` → `mypy` → `pytest` |
| YANG module | `pyang --strict` |
| Ansible YAML | `yamllint` → `ansible-lint` |
| JSON (alarm summary) | `json.loads()` → schema validation with `jsonschema` |
| Shell commands | Block entirely — never generate shell commands via LLM |

### Secret management

Pipeline scripts must retrieve credentials from secrets management — never from LLM-generated code.

```python
# Correct: retrieve from environment (populated by GitHub Actions secrets or Vault)
import os
api_key = os.environ["WATSONX_API_KEY"]

# Incorrect: never accept credentials from LLM output
# Review all generated code for any hardcoded strings before merging
```

Add a pre-commit hook or CI step to scan generated code with `trufflehog` or `detect-secrets`
before committing it to the repository.

### Dependency risk

AI-suggested Python packages in generated code may be:

- Misspelled (typosquatting targets — e.g., `requets` instead of `requests`)
- Unnecessary (adding attack surface)
- Unlicensed for your use case

**Rule:** review every `import` statement in generated code before adding the package to
`requirements.txt`. Use `pip-audit` on your full dependency tree after adding new packages.

---

## SCI Optimisation for Custom Pipelines

Running pipelines locally on OSS models has a material environmental advantage over cloud API calls.

### Why it matters

A rough comparison for a 500-token generation:

| Approach | Approximate energy per call | Notes |
|---|---|---|
| GPT-4o API (cloud) | ~0.003–0.01 kWh | Data centre inference at scale |
| Llama 3.1 8B (local, laptop) | ~0.00003–0.0001 kWh | ~100× lower |
| Llama 3.1 70B (local, workstation) | ~0.0003–0.001 kWh | ~10× lower than cloud |

The difference is largest for high-volume repetitive tasks (e.g., summarising every PR diff, enriching
every alarm). For occasional one-off generation, the absolute numbers are small either way.

### SCI calculation for a custom pipeline

The Software Carbon Intensity (SCI) specification functional unit for a pipeline is **per pipeline run**.

```
SCI = (E × I + M) / R

Where:
  E = energy consumed per run (kWh)
      = model_tokens × hardware_TDP_kW × inference_time_hours
  I = carbon intensity of the grid (gCO₂e/kWh) — use your data centre location
  M = embodied carbon of the hardware, amortised over its useful life
  R = pipeline runs per functional unit (1 run)
```

**Practical tracking (add to your pipeline metrics):**

```python
# sci_tracker.py — append a record per pipeline run
import json
import os
import time
from pathlib import Path

SCI_LOG = Path("metrics/sci_pipeline_runs.jsonl")


def log_run(pipeline_name: str, model: str, input_tokens: int, output_tokens: int) -> None:
    SCI_LOG.parent.mkdir(exist_ok=True)
    record = {
        "ts": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
        "pipeline": pipeline_name,
        "model": model,
        "input_tokens": input_tokens,
        "output_tokens": output_tokens,
    }
    with SCI_LOG.open("a") as f:
        f.write(json.dumps(record) + "\n")
```

**Target:** for any repetitive pipeline task running >100 times per day, use the smallest model that
meets quality requirements. Run `benchmark.py` (kept in `scripts/`) to compare output quality between
model sizes before choosing.

---

## Maintenance Considerations

Custom AI pipelines require ongoing maintenance. Plan for this before committing to build.

### Prompt versioning

Prompts are code. Version them in git, review changes, and test them in CI.

```
scripts/
  prompts/
    yang_to_dataclass_v1.txt    ← current production prompt
    yang_to_dataclass_v2.txt    ← candidate under test
  tests/
    test_yang_to_dataclass.py   ← pytest: given known YANG, assert expected dataclass output
```

When updating a prompt, run the full test suite before merging. If the new prompt produces better
output on the test cases, version-bump and retire the old file.

### Model version pinning

Pin model versions in all pipeline scripts and Ollama pull commands. Unversioned model tags (e.g.,
`llama3.1:latest`) can change behaviour without warning when Ollama updates the default.

```bash
# Pin specific quantisation and version
ollama pull llama3.1:8b-instruct-q4_K_M
# Use the full tag in pipeline scripts: model="llama3.1:8b-instruct-q4_K_M"
```

Test model upgrades in a branch before merging. A model update that degrades prompt output quality
is a regression — treat it as one.

### Pipeline README requirements

Every pipeline directory must contain a `README.md` with:

- **Purpose:** what problem does this pipeline solve?
- **AI component:** which model, which prompt file, what the output is expected to look like
- **Validation gates:** what checks run before output is used
- **Update procedure:** how to change the prompt, how to upgrade the model
- **Owner:** who is responsible for keeping this pipeline working?

---

*For interactive chat-based use cases (incident summarisation, RFC Q&A, ADR drafting), see `docs/tools/llm-chat.md`.*  
*For responsible AI principles including vendor concentration and SCI policy, see `docs/responsible-ai/`.*
