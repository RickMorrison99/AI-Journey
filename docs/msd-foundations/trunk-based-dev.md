# Trunk-Based Development & AI Commit Hygiene

!!! quote "Dave Farley, *Continuous Delivery*"
    "The longer a branch lives, the more it diverges, and the harder integration becomes.
    The goal is to integrate continuously — ideally multiple times per day."

!!! quote "Dave Farley, *Modern Software Engineering*"
    "Short feedback loops are the most important property of an effective software delivery
    process. Everything else flows from that."

---

## Why Trunk-Based Development Matters for AI Adoption

Trunk-based development (TBD) is the practice of committing to a shared mainline — trunk — either
directly or via very short-lived branches (merged within hours, at most one working day). It is the
branching strategy that underlies every high-performing software delivery team studied by the DORA
research programme.

For AI-assisted development specifically, TBD solves a problem that becomes acute quickly: **AI
generates code faster than humans can review it, and long-lived branches become unmanageable.**

Consider what happens when an team member uses AI assistance with a long-lived feature branch:

1. Day 1: AI generates a skeleton — 400 lines across 8 files.
2. Day 3: Team Member refines, asks AI to add error handling — 200 more lines.
3. Day 5: Trunk has moved on. Merge conflict is complex and AI-generated context is stale.
4. Day 7: PR is opened. Reviewer faces 600 lines of AI-assisted code, much of it unfamiliar.
   The review is cursory: "AI wrote it, looks reasonable, LGTM."
5. Day 8: The code ships with a subtle NETCONF idempotency bug that only appears under load.

TBD prevents this failure mode by enforcing a rhythm of small, frequent, reviewable integrations.
When each AI-assisted chunk is integrated and reviewed daily (or more frequently), the cognitive
load of each review is manageable, feedback is fast, and drift is impossible.

---

## The Right Branch Strategy for the O&A Team

For a team of 10–30 team members working on O&A platform services, the recommended approach is:

### Option A — Direct Trunk Commits with Feature Flags (Preferred)

Team Members commit directly to trunk. Features that are not ready for production are hidden behind
feature flags. The pipeline validates every commit to trunk.

**Advantages:**
- Zero merge conflict overhead.
- Every commit is reviewed (via pair programming or async review of small diffs).
- AI-generated code is integrated continuously, not batched.
- CI runs on every commit, catching AI-generated issues immediately.

**Requirements:**
- Feature flag infrastructure (LaunchDarkly, Unleash, simple environment config, or YAML config).
- Culture of committing small, complete increments rather than large features.
- Pairing or mob programming to replace PR-based review.

### Option B — Short-Lived Feature Branches (< 1 Working Day)

Team Members work on a branch for up to one day, then merge to trunk via PR. Branches are deleted
after merge. No branch lives longer than one day.

**Advantages:**
- PR review is preserved as a quality gate.
- Familiar workflow for most team members.

**Requirements:**
- Branches must be kept short. A branch that lasts 2+ days is a branching discipline failure.
- PRs must be small (see PR size discipline below).
- Stale branches must be deleted promptly — branch hygiene tooling helps (`git fetch --prune`).

### What O&A Teams Should Avoid

| Anti-Pattern | Why It Fails with AI |
|---|---|
| **Long-lived feature branches (> 2 days)** | AI-generated code accumulates; merge conflicts are complex; review becomes a formality |
| **"AI experiment" branches** | An team member spends a week exploring AI-generated solutions on a branch, then opens a 2,000-line PR — unreviable |
| **Per-team member branches** | Each team member's AI-assisted work diverges independently; integration pain grows non-linearly |
| **Release branches** | Config-as-code (YANG, Ansible) on release branches creates environments that diverge from trunk — AI may generate for trunk state, not branch state |

---

## AI Commit Hygiene

Commit hygiene is the discipline of making each commit a small, coherent, reviewable unit. It is
important for all code, but critical for AI-generated code, which tends toward large, sprawling
outputs.

### Principle 1: Small, Focused Commits

Each commit should represent one logical change. For AI-assisted work, this means resisting the
temptation to accept a large AI-generated output as a single commit.

**Instead of:**
```
commit a1b2c3d
Author: team member@noa.team
Date:   Mon Nov 18

    Add NETCONF provisioning service (AI-generated)

 services/netconf-provisioner/main.py         | 312 +++++++++++++++++++
 services/netconf-provisioner/session.py      | 187 +++++++++++
 services/netconf-provisioner/rpc_builder.py  | 143 +++++++++
 tests/unit/test_rpc_builder.py               |  89 +++++
 tests/integration/test_provisioner.py        | 156 ++++++++++
 .gitlab-ci.yml                               |  23 ++
 6 files changed, 910 insertions(+)
```

**Do this:**
```
commit a1b2c3d — "Add NETCONF session manager with connection pool"
commit b2c3d4e — "Add RPC builder for edit-config operations"
commit c3d4e5f — "Add unit tests for RPC builder"
commit d4e5f6g — "Add provisioner service main entry point"
commit e5f6g7h — "Add integration test for NETCONF session against netsim"
commit f6g7h8i — "Add CI stage for NETCONF integration tests"
```

Each commit is independently understandable and reviewable. If commit `b2c3d4e` introduces a
NETCONF namespace bug, it can be identified and reverted without touching the session manager
or the tests.

### Principle 2: AI-Generated Code Is Reviewed Before Merge

The rule is simple: **no "AI wrote it, LGTM" merges.**

AI-generated code receives the same (or higher) scrutiny as human-authored code. The review focuses
on the things AI gets wrong:

| Review Focus | What to Check |
|---|---|
| **NETCONF operation semantics** | Is `merge` / `replace` / `create` / `delete` correct for this use case? |
| **YANG namespace handling** | Are namespace prefixes consistent and correct throughout the XML? |
| **Idempotency** | Will running this twice produce the same result? Is it safe to retry? |
| **Error handling** | Are all error response types from NETCONF / NSO / TMF APIs handled? |
| **Hardcoded values** | Any IP addresses, device names, credentials, or environment-specific strings? |
| **Principle adherence** | DRY — does this duplicate existing utilities? SoC — does this cross a boundary? |
| **Test coverage** | Are the tests specific and meaningful, or are they generated rubber-stamps? |

### Principle 3: Commit Messages Identify AI Assistance

Transparent commit messages help the team understand the provenance of changes and calibrate
review effort appropriately:

```
# Good — identifies AI assistance, scopes the change, explains the intent
Add yanglint integration test for noa-interface YANG model

Generated initial test structure with GitHub Copilot; reviewed and
extended with boundary cases for must constraints and pattern validation.

Tests cover: valid instance, missing mandatory leaf, bandwidth out of range,
description pattern violation.

# Good — AI-generated but explicitly reviewed
Refactor NETCONF session pool to use asyncio

AI-suggested refactor from synchronous ncclient pool to asyncio-based
implementation. Full review against ADR-012 (session pooling decision).
Integration tests passing against netsim.

# Bad — "LGTM" on AI output
Add netconf service (copilot)
```

### Principle 4: No Committing Unreviewed AI Output Directly to Trunk

Even in a TBD workflow with direct trunk commits, AI-generated output should not be committed
without the team member having read and understood it. The acceptable workflow:

1. AI generates code in the IDE or chat interface.
2. Team Member reads the output, understands it, and asks clarifying questions if needed.
3. Team Member runs the tests locally — they pass.
4. Team Member commits with a message that reflects their understanding.

The unacceptable workflow:
1. AI generates 300 lines.
2. Team Member scans for obvious errors.
3. Team Member commits: `wip: add netconf stuff (ai)`

---

## Feature Flags — The Alternative to Long-Lived Branches

Feature flags allow incomplete features to exist in trunk without affecting users. They are the
primary mechanism for shipping AI-assisted features incrementally in a TBD workflow.

### Feature Flag Patterns for O&A

**Configuration-based flags (simplest):**

```python
# config/feature_flags.yaml
flags:
  netconf_async_sessions: false    # ADR-012 async refactor — not yet production-ready
  tmf641_order_v5: false           # TMF641 v5 API support — in progress
  yang_diff_engine_v2: true        # New YANG diff engine — production since 2024-11-01
```

```python
# noa/config.py
from functools import lru_cache
import yaml
from pathlib import Path

@lru_cache(maxsize=None)
def feature_flags() -> dict:
    flags_path = Path(__file__).parent.parent / "config" / "feature_flags.yaml"
    return yaml.safe_load(flags_path.read_text()).get("flags", {})

def is_enabled(flag_name: str) -> bool:
    return feature_flags().get(flag_name, False)
```

```python
# Usage in service code
from noa.config import is_enabled

async def get_netconf_session(device_id: str):
    if is_enabled("netconf_async_sessions"):
        return await AsyncNetconfSessionPool.acquire(device_id)
    return NetconfSessionPool.acquire(device_id)
```

**Environment variable flags (for ops-controlled rollout):**

```python
import os

FEATURE_TMFV5 = os.getenv("O&A_FEATURE_TMF641_V5", "false").lower() == "true"
```

### Feature Flags for Config-as-Code (Ansible, YANG)

Feature flags in application code are straightforward. For config-as-code, the equivalent
mechanism is conditional task execution:

```yaml
# roles/noa_interface/tasks/main.yml
- name: Configure interface using legacy NETCONF (stable)
  community.yang.configure:
    file: "{{ role_path }}/yang/ietf-interfaces.yang"
    # ...
  when: not (noa_feature_async_netconf | default(false))

- name: Configure interface using async NETCONF (experimental)
  noa.netconf.async_configure:
    # ...
  when: noa_feature_async_netconf | default(false)
```

```yaml
# inventory/group_vars/all.yml
noa_feature_async_netconf: false  # Set to true in lab inventory to test
```

---

## PR Size Discipline

AI tools tend to generate large diffs. Left unmanaged, this produces PRs that are technically
reviewable but practically rubber-stamped — too large for a human reviewer to genuinely assess.

### The O&A PR Size Norm

| PR Size | Lines Changed | Expectation |
|---|---|---|
| **Small** | < 200 lines | Standard review, 1 reviewer sufficient |
| **Medium** | 200–400 lines | Standard review, note if AI-generated |
| **Large** | 400–800 lines | Break into smaller PRs if possible; 2 reviewers recommended |
| **Oversized** | > 800 lines | Must be broken up before review, except for generated code (e.g., YANG-generated Python stubs) |

**For AI-generated code specifically:** the 400-line threshold for requesting a split is firm.
An LLM can generate 800 lines in one prompt. That does not mean 800 lines is an appropriate
unit of review.

### Breaking Up AI-Generated Diffs

When AI generates a large output, the team member's job is to decompose it into reviewable chunks
before committing. A practical approach:

```bash
# Step 1: Accept AI output into a working branch
git checkout -b ai/netconf-provisioner-wip

# Step 2: Stage only the first logical unit
git add services/netconf-provisioner/session.py
git add tests/unit/test_session.py

# Step 3: Verify tests pass for this unit
pytest tests/unit/test_session.py

# Step 4: Commit the first unit
git commit -m "Add NETCONF session manager with connection pool

Initial session.py implementation and unit tests.
AI-assisted; reviewed against ADR-012 (session pooling)."

# Step 5: Repeat for each logical unit
# ... rpc_builder.py, main.py, integration tests, CI stage

# Step 6: Either merge directly (if < 1 day) or open a PR per logical unit
```

---

## O&A-Specific: Config-as-Code Under the Same Discipline

A common blind spot: team members apply strict commit hygiene to application code but treat
config-as-code (YANG models, Ansible playbooks, NSO packages) as exempt from these rules.

**Config-as-code must follow the same discipline:**

| Asset Type | Applies | Rationale |
|---|---|---|
| YANG model changes | ✅ | A YANG change with a RFC compliance violation can corrupt device configuration |
| Ansible playbook changes | ✅ | An Ansible change without idempotency testing can run destructive operations twice |
| NSO package updates | ✅ | An NSO package commit that fails a `dry-run` check can leave devices in a partial state |
| Inventory changes | ✅ | Adding a wrong IP or device type to inventory with no review can target the wrong device |
| OpenAPI / AsyncAPI spec changes | ✅ | A spec change that breaks consumers must go through the same review as code |

**The one exception** is machine-generated code that is entirely derived from a validated source —
for example, Python data classes auto-generated by `yang2dsdl` from a pyang-validated YANG model.
This generated code does not require the same line-by-line review, but the *YANG source* it was
generated from does.

---

## Checklist: Trunk-Based Development & AI Commit Hygiene

### Branch Strategy

- [ ] Feature branches are merged within one working day (or direct trunk commits are used).
- [ ] No branch in the repository is older than two days (excluding release support branches).
- [ ] "AI experiment" branches are not permitted — experimental AI work goes behind a feature flag on trunk.
- [ ] `git fetch --prune` is run regularly; stale remote branches are cleaned up.

### Commit Hygiene

- [ ] AI-generated code is reviewed by the committing team member before commit — not "scan and merge".
- [ ] Commit messages identify AI assistance where used.
- [ ] No single commit contains more than ~400 lines of AI-generated code without a justification comment.
- [ ] Each commit represents one logical change (one component, one behaviour, one refactor).

### Feature Flags

- [ ] All in-progress AI-assisted features that are not production-ready are behind a feature flag.
- [ ] Feature flags are in `config/feature_flags.yaml` (or equivalent) — not scattered as inline `if` statements.
- [ ] Feature flag state is reviewed quarterly; stale flags are removed.
- [ ] Ansible/YANG config-as-code uses inventory group variables as the equivalent of feature flags.

### PR Size and Review

- [ ] PRs over 400 lines of AI-generated code are split before review.
- [ ] "AI wrote it, LGTM" is explicitly not an acceptable review.
- [ ] PR review checklist includes AI-specific items: idempotency, namespace handling, error handling, hardcoded values.
- [ ] Config-as-code (YANG, Ansible, NSO) follows the same review norms as application code.

---

*Previous: [Evolutionary Architecture ←](evolutionary-architecture.md) | Next: [Cognitive Load →](cognitive-load.md)*
