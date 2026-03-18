# Skill: Generate Spec File

**Skill name**: `spec-file`
**Trigger phrases**: "write a spec", "spec file for", "spec before coding", "create spec", "spec-driven"

---

## What This Skill Does

Generates a complete Osmani-style spec file for any O&A task. The spec becomes the single source of truth for AI prompting, team alignment, and acceptance testing. It prevents prompt iteration waste, reduces AI hallucination of wrong patterns, and ensures the task definition is unambiguous before a single line of code is written.

---

## The Osmani 30-40% Rule — State This Upfront

Before generating a spec, state this explicitly to the user:

> "Addy Osmani's spec-driven AI development framework allocates 30–40% of total task time to the spec. For a one-week task, that is 1.5–2 days on the spec alone. This is not waste — every hour here prevents 3 hours of AI prompt iteration and rework. If you want to 'just start prompting,' I will push back."

If the user objects to the time investment, ask: *"How many AI prompt iterations did your last unspecced task take before the output was acceptable?"* The answer is usually the justification.

---

## Token Efficiency Note

Include this in every generated spec:

> **Token efficiency**: This spec is approximately [N] words / ~[N×1.3] tokens. A well-structured spec of this size prevents an estimated 1,500–3,000 tokens of iterative correction across implementation prompts. Include this file as context at the start of every AI session for this task.

---

## The 8-Section Spec Template

```markdown
# Spec: [Task Name]
**Version**: 1.0 | **Date**: [YYYY-MM-DD] | **Author**: [name]
**Estimated spec size**: ~[N] words / ~[N] tokens

---

## 1. Task Description
[One paragraph. What is being built, for whom, and why it matters.
No implementation details. No technology choices. Just the problem and outcome.]

---

## 2. Constraints
[Hard limits that cannot be violated. Enumerate all of them.]

- NOS/vendor versions: [e.g., IOS-XR 7.9.x, JunOS 23.2R1]
- YANG RFC compliance: [e.g., RFC 7950, ietf-interfaces@2018-02-20]
- TMF API version: [e.g., TMF641 v4.1.0]
- Python version: [e.g., 3.11.x — not "3.x"]
- NSO version: [e.g., 6.2.3]
- ncclient version: [e.g., 0.6.15]
- Test framework: [e.g., pytest 8.x with pytest-mock]
- Compute/latency budget: [e.g., <5s device response, <30s NSO commit]
- Licensing constraints: [e.g., must use only MIT/Apache-2 dependencies]
- Compliance/audit: [e.g., no external model receives device configs]

---

## 3. Success Criteria
[Numbered list. Every item is measurable, testable, and demoable. NOT "works correctly".]

1. `pyang --lint [module].yang` exits 0 with zero warnings
2. All characterisation tests pass without modification
3. `pytest -m characterisation` exits 0
4. NSO service deploy completes in under 30 seconds on staging
5. NETCONF edit-config rollback verified with `validate` → `confirmed-commit` pattern
6. [Add task-specific measurable criteria]

---

## 4. Technology Stack
[Exact versions. No "latest". No "current". Pin everything.]

| Component | Version | Source |
|-----------|---------|--------|
| Python | 3.11.x | System / pyenv |
| NSO | 6.2.3 | Cisco DevNet |
| ncclient | 0.6.15 | PyPI |
| pyang | 2.6.0 | PyPI |
| pytest | 8.x | PyPI |
| [other] | [version] | [source] |

---

## 5. Architecture Decisions
[Key decisions already made. Reference existing ADRs. Define scope boundaries.]

- **In scope**: [what this task builds or changes]
- **Out of scope**: [what is explicitly excluded — important for AI context]
- **ADR references**: [link to relevant ADRs in docs/governance/adrs/]
- **Key decision**: [e.g., "We augment ietf-interfaces rather than creating a new model — see ADR-042"]

---

## 6. What NOT To Do
[Explicit anti-patterns. These become negative constraints in every AI prompt.
Critical for preventing AI hallucination of wrong patterns.]

- Do NOT generate snake_case TM Forum field names — TMF uses camelCase exclusively
- Do NOT use `paramiko` directly — use `ncclient` with context manager
- Do NOT hardcode device credentials — use `os.environ` or vault injection
- Do NOT write directly to NSO CDB in Python — use MAAPI transactions
- Do NOT disable `hostkey_verify` in ncclient — this is a security control
- Do NOT create new YANG modules if an existing RFC or vendor model can be augmented
- Do NOT use `edit-config` on the `running` datastore — use `candidate` → `validate` → `commit`
- [Add task-specific anti-patterns]

---

## 7. Context/Resources
[Files and specs that MUST be in the AI's context before prompting.
Create a `context/` directory and download these before starting.]

| Resource | File | Source |
|----------|------|--------|
| YANG base model | `context/yang/ietf-interfaces@2018-02-20.yang` | [IETF / NOS vendor] |
| TMF OpenAPI spec | `context/tmf/TMF[XXX].swagger.json` | tmforum-apis GitHub |
| Example NETCONF RPC | `context/examples/get-config-response.xml` | Device lab capture |
| Existing service model | `context/yang/oa-[existing].yang` | This repo |
| Characterisation tests | `tests/characterisation/test_[legacy].py` | This repo |
| [other] | `context/[path]` | [source] |

---

## 8. Acceptance Tests
[Specific, runnable test cases. Not "test the happy path" — actual test names, inputs, expected outputs.]

| Test ID | Test Name | Input | Expected Output | Pass Criteria |
|---------|-----------|-------|-----------------|---------------|
| AT-01 | `test_yang_lint_clean` | `oa-[module].yang` | pyang exit 0 | No warnings |
| AT-02 | `test_netconf_get_config_returns_interface` | host=192.0.2.1, if=Gi0/0/0/0 | `<interface><name>Gi0/0/0/0</name>...` | lxml parse succeeds |
| AT-03 | `test_service_deploy_under_30s` | vpn-id=TEST-001, 2 endpoints | NSO commit success | Elapsed < 30s |
| AT-04 | `test_characterisation_suite_passes` | Unchanged legacy code | All `@pytest.mark.characterisation` pass | Exit 0 |
| [AT-N] | [test name] | [input] | [expected] | [criteria] |
```

---

## O&A-Specific Prompts Per Section

### Section 2 — Constraints
Always ask: "What NOS version? Constraints between IOS-XR 7.5 and 7.9 differ. State both minimum and tested version."

### Section 3 — Success Criteria
Push back on every vague criterion. "The service deploys" → "The service deploys in under 30 seconds and `ncs_cli` shows `commit-queue empty`."

### Section 6 — What NOT To Do
After the user fills in the task, always add the relevant O&A standard anti-patterns automatically. Do not ask — include them unconditionally.

### Section 7 — Context/Resources
Ask: "Have you downloaded the TMF OpenAPI spec and YANG models to `context/`? AI tools without this context will hallucinate field names and YANG paths."
