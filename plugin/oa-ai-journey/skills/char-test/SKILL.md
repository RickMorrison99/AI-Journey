# Skill: Write Characterisation Tests

**Skill name**: `char-test`
**Trigger phrases**: "characterisation test", "characterization test", "capture current behaviour", "legacy tests", "safety net tests"

---

## What This Skill Does

Generates pytest characterisation tests for legacy O&A code using the Michael Feathers pattern. These tests form the safety net that makes AI-assisted legacy modernisation safe. Without this safety net, AI-generated refactors are blind: they may change observable behaviour in ways that cause network incidents.

This skill is always triggered before any AI modernisation of legacy code. It is a prerequisite, not an option.

---

## The Golden Rule

**Characterisation tests capture CURRENT behaviour, not INTENDED behaviour.**

If the legacy code has a bug — an off-by-one error, a silent exception swallow, an incorrect default — the characterisation test must capture that bug. Do NOT correct the code behaviour in the test. The test's job is to detect change, not to verify correctness.

When the test suite passes on the current (unmodified) codebase, the safety net is set. Any subsequent change that breaks a characterisation test is a regression, full stop.

---

## Required Input

- The legacy function, class, or module to test (paste the code)
- The Python/NSO/ncclient version in production (affects mock targets)
- Known edge cases or error conditions (from incident history, code comments, tribal knowledge)

---

## Output Structure

```python
"""
Characterisation tests for [module/function name].

IMPORTANT: These tests capture the CURRENT observable behaviour of the code
as of [YYYY-MM-DD]. They are a safety net, not a specification.

DO NOT 'fix' these tests if the code has a bug — that is intentional.
A failing characterisation test means a behavioural change occurred.
Once this safety net is in place, write a proper spec before refactoring.

Michael Feathers pattern — Working Effectively with Legacy Code, Ch. 13.
"""
import pytest


@pytest.mark.characterisation
def test_[function]_[scenario]():
    # Arrange — set up the exact production-like state
    ...
    # Act
    result = legacy_function(...)
    # Assert — capture current output, even if it looks wrong
    assert result == <current_actual_output>
```

Every test file includes:
- Module-level docstring with the date and the "DO NOT fix" warning
- `@pytest.mark.characterisation` marker on every test
- A comment on surprising behaviours: `# Current behaviour: returns None instead of raising — do not change`

---

## O&A-Specific Patterns

### NSO MAAPI Callback Characterisation

Mock `ncs.maagic.get_root()` to inject a fake CDB tree. Capture the exact node modifications the callback makes.

```python
from unittest.mock import MagicMock, patch

@pytest.mark.characterisation
def test_service_callback_creates_vrf_node():
    """Captures: cb_create adds vrf node to device tree with current defaults."""
    mock_root = MagicMock()
    mock_service = MagicMock()
    mock_service.vpn_id = "TEST-VPN-001"

    with patch("ncs.maagic.get_root", return_value=mock_root):
        from packages.l3vpn.python.l3vpn import ServiceCallbacks
        cb = ServiceCallbacks()
        cb.cb_create(tctx=MagicMock(), root=mock_root,
                     service=mock_service, proplist=[])

    # Current behaviour: sets vrf name to vpn_id directly (no prefix)
    # TODO spec: should this have an "oa-" prefix? Capture current state first.
    mock_root.devices.device["pe1"].config.vrf.create.assert_called_with("TEST-VPN-001")
```

### NETCONF RPC Characterisation

Use the `responses` library (or `unittest.mock`) to mock device responses. Capture the exact XML payload the function produces.

```python
from unittest.mock import patch, MagicMock
from lxml import etree

@pytest.mark.characterisation
def test_get_interface_filter_xml_structure():
    """Captures: filter XML produced for interface query matches current format."""
    with patch("ncclient.manager.connect") as mock_connect:
        mock_mgr = MagicMock()
        mock_connect.return_value.__enter__.return_value = mock_mgr
        mock_mgr.get_config.return_value.data_ele = etree.fromstring(
            "<interfaces/>"
        )
        mock_mgr.get_config.return_value.errors = []

        from netconf_client import get_interface_config
        get_interface_config(host="192.0.2.1", interface_name="Gi0/0/0/0")

        call_args = mock_mgr.get_config.call_args
        filter_xml = etree.tostring(call_args[1]["filter"]).decode()
        # Current behaviour: uses subtree filter with ietf-interfaces namespace
        assert 'urn:ietf:params:xml:ns:yang:ietf-interfaces' in filter_xml
        assert '<name>Gi0/0/0/0</name>' in filter_xml
```

### Ansible Role Characterisation

Use `--check` mode output as the golden master. Capture the exact task list and changed/unchanged counts.

```bash
# Run this and save output as the golden master before any changes:
ansible-playbook site.yml --check --diff -i inventory/test 2>&1 | tee tests/golden/ansible-check-output.txt
```

```python
@pytest.mark.characterisation
def test_ansible_check_mode_task_count(tmp_path):
    """Captures: current --check run produces exactly N tasks with M changed."""
    import subprocess
    result = subprocess.run(
        ["ansible-playbook", "site.yml", "--check", "-i", "inventory/test"],
        capture_output=True, text=True, cwd=str(tmp_path)
    )
    # Current behaviour: 14 tasks, 3 changed, 0 failures
    assert "ok=14" in result.stdout
    assert "changed=3" in result.stdout
    assert "failed=0" in result.stdout
```

---

## Pytest Configuration

Add to `pytest.ini` or `pyproject.toml`:

```ini
[pytest]
markers =
    characterisation: Safety net tests capturing current legacy behaviour. Do not modify.
```

Run characterisation tests separately to distinguish them from specification tests:
```bash
pytest -m characterisation          # safety net only
pytest -m "not characterisation"    # spec tests only
pytest                              # all tests
```

---

## After Writing Characterisation Tests

Always tell the user:

> "Your safety net is set. These tests pass on the current codebase. Now — before asking AI to refactor — write a proper spec. Use the `spec-file` skill. The spec defines what the replacement *should* do. The characterisation tests verify the replacement doesn't break what already works."
