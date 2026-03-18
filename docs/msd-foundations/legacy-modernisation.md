# Working Effectively with Legacy Code — AI-Assisted Modernisation

*Based on Michael Feathers, **Working Effectively with Legacy Code** (2004)*

!!! quote "Michael Feathers, *Working Effectively with Legacy Code*"
    "To me, legacy code is simply code without tests. Code without tests is bad code. It doesn't
    matter how well written it is; it doesn't matter how pretty or object-oriented or well-
    encapsulated it is. With tests, we can change the behaviour of our code quickly and verifiably.
    Without them, we really don't know if our code is getting better or worse."

---

## 1. The O&A Legacy Reality

O&A teams do not work on greenfield systems. The typical O&A estate includes some combination
of:

- **Perl automation scripts** — written by network engineers a decade ago, doing device
  configuration via expect scripts or raw SSH, with no tests and implicit knowledge baked into
  the code structure
- **Python 2 automation** — ncclient wrappers, SNMP collectors, and inventory reconciliation
  scripts written before Python 3 migration was prioritised; type-unsafe, dependency-pinned to
  ancient libraries, occasionally running on life-support
- **Monolithic NSO service packages** — large Python callbacks handling multiple concerns
  simultaneously: data validation, device communication, error handling, and business logic
  interleaved without clear seams
- **Undocumented YANG models** — augmenting vendor models with no `description` statements,
  unclear operational semantics, and deviations that exist for reasons nobody on the current
  team can articulate
- **SNMP-era collectors** — MIB walkers feeding data to monitoring systems that predate
  NETCONF by a decade, with brittle OID mappings and implicit device compatibility assumptions
- **Ansible roles with implicit ordering** — playbooks written iteratively where task order
  encodes important state assumptions that are not documented anywhere

This is not a problem to eliminate before AI adoption can begin. It is the **context in which
all AI-assisted development happens**. The O&A team will be using AI to work on this code for
years. The question is not "how do we get to clean code before using AI?" — that will never
come. The question is "how do we use AI safely and effectively on code that has no tests and
carries undocumented assumptions?"

### Feathers' Redefinition

Feathers' key insight is definitional: **legacy code is not old code — it is code without
tests.** This reframe matters enormously for AI adoption:

- Brand-new AI-generated code without tests is legacy code the moment it is written
- Decade-old Python with a comprehensive test suite is not legacy code — it is a maintainable
  asset
- The problem with legacy code is not age, language, or style — it is the absence of a
  feedback mechanism for detecting unintended behaviour change

For O&A AI adoption, this means: **AI does not solve the legacy problem. Without tests, AI
makes it worse.** An AI that confidently refactors untested legacy code produces untested
modified code — faster, and with higher surface-area change, than a human would.

---

## 2. The Core Risk: AI on Untested Legacy

When AI is applied to legacy code without characterisation tests, the risk profile is
qualitatively different from AI on well-tested code:

**On well-tested code:** AI generates a change → tests run → regression detected immediately
→ safe to iterate.

**On untested legacy code:** AI generates a change → no tests run → change is merged → subtle
behaviour regression surfaces in production six months later during a maintenance window.

The AI is not malicious. It is confidently applying patterns that look correct in isolation but
miss the implicit constraints that the original code accumulated over years of operational use.

### Three O&A-Specific AI Legacy Failure Modes

**Failure Mode 1: Idempotency Semantics Change**

An AI refactors a NETCONF RPC handler in an NSO service callback. The original code uses
`ncs.maapi.exists()` to check device state before applying configuration, with specific
handling for the case where the device is in a partially-configured state from a previous
failed transaction. The AI rewrites the check using a simpler pattern that looks equivalent
but silently removes the partial-state handling logic. The service package passes smoke tests.
During a planned maintenance window three months later, a partial configuration scenario occurs
and the handler corrupts device state instead of recovering it.

**Failure Mode 2: Ansible Implicit Ordering**

An Ansible role configures a network device in a specific task order: first create VLANs, then
assign ports, then update spanning tree. The AI rewrites the role to group tasks by module for
"cleanliness" — all `cisco.ios.vlans` tasks together, then all `cisco.ios.interfaces` tasks.
This looks more maintainable. However, the original ordering encoded a timing dependency: the
spanning tree update must happen after port assignment due to a specific firmware bug on one
device family in the fleet. The AI's version works on 95% of devices and fails silently on the
rest.

**Failure Mode 3: Python Type Coercion from Perl**

A legacy Perl script performs arithmetic on SNMP counter values. A Perl string that looks like
a number is treated as a number automatically. The AI generates a typed Python equivalent using
`int()` conversions. Most of the time, this is equivalent. However, the original Perl silently
ignores non-numeric counter values (treating them as zero) that occasionally appear due to a
vendor SNMP quirk. The typed Python raises an exception instead, and the entire collection
cycle fails for the affected device.

All three failure modes share a structure: **plausible-looking change, silent semantic
difference, deferred failure.** Without characterisation tests, there is no mechanism to
detect the divergence before production.

---

## 3. Characterisation Tests — The First Step

### What Characterisation Tests Are

Feathers introduces **characterisation tests** as the essential first step before changing any
legacy code. A characterisation test is not a test of what the code *should* do — it is a test
of what the code *currently does*, including its bugs, its quirks, and its implicit behaviour.

The purpose is not correctness. The purpose is **a safety net**: a mechanism to detect if a
change alters the code's observable behaviour, intended or otherwise. Once a characterisation
test suite exists, any AI-generated refactoring that changes behaviour will cause a test failure
— making the change visible and auditable rather than silent.

### Writing Characterisation Tests

The process:
1. Run the code under controlled conditions and capture its outputs
2. Write a test that asserts those specific outputs (even if they look wrong)
3. Confirm the test passes with the current code
4. Now you have a safety net

If the code currently produces wrong output for some inputs, the characterisation test captures
that wrong output. The goal is not to fix it now — the goal is to know if it changes.

---

### Worked O&A Example: NSO Python Service Callback

**Legacy code under test:**

```python
# nso_ip_service/python/ip_service.py
# Written 2017. No tests. Original author left the company.

import ncs
from ncs.application import Service

class IpServiceCallbacks(Service):

    @Service.create
    def cb_create(self, tctx, root, service, proplist):
        self.log.info('IpService create: ', service.name)

        device_name = service.device
        interface = service.interface
        ip_address = service.ip_address
        prefix_len = service.prefix_length

        # Get device from CDB
        dev = root.devices.device[device_name]

        # Check if interface exists on device
        # Note: this uses a non-obvious path for IOS-XE
        try:
            iface = dev.config.ios__interface.GigabitEthernet[interface]
        except KeyError:
            self.log.error('Interface not found: ', interface)
            raise

        # Set IP address
        iface.ip.address.primary.address = ip_address
        iface.ip.address.primary.mask = self._prefix_to_mask(prefix_len)

        # Undocumented: also sets no-shutdown if interface is in admin-down state
        # This was added after an incident but never documented
        if hasattr(iface, 'shutdown') and iface.shutdown:
            iface.shutdown = False
            self.log.info('Interface was shutdown, enabling: ', interface)

    def _prefix_to_mask(self, prefix_len):
        # Converts prefix length to dotted-decimal mask
        # Uses bit manipulation; behaviour for prefix_len > 32 is undefined
        mask = (0xFFFFFFFF >> (32 - int(prefix_len))) << (32 - int(prefix_len))
        return '%d.%d.%d.%d' % (
            (mask >> 24) & 0xFF,
            (mask >> 16) & 0xFF,
            (mask >> 8) & 0xFF,
            mask & 0xFF
        )
```

**Step 1: Write characterisation tests for the `_prefix_to_mask` function**

```python
# tests/test_ip_service_characterisation.py
# Characterisation tests — capture CURRENT behaviour, not intended behaviour.
# These tests define the safety net for AI-assisted refactoring.
# DO NOT change these tests unless you have verified the behaviour change
# is intentional and approved via the ADR process.

import pytest
from unittest.mock import MagicMock, patch

# We test _prefix_to_mask in isolation by instantiating the class
# with a mocked NSO application context (interface seam)

class TestPrefixToMaskCharacterisation:
    """
    Characterisation tests for IpServiceCallbacks._prefix_to_mask.
    These tests describe CURRENT behaviour as of 2024-01-15.
    """

    def setup_method(self):
        # Create a minimal mock to instantiate the service class
        # without requiring a live NSO instance
        mock_app = MagicMock()
        mock_app.log = MagicMock()
        with patch('ncs.application.Service.__init__', return_value=None):
            self.service = IpServiceCallbacks.__new__(IpServiceCallbacks)
            self.service.log = MagicMock()

    def test_prefix_24_produces_expected_mask(self):
        result = self.service._prefix_to_mask(24)
        assert result == '255.255.255.0'

    def test_prefix_32_produces_all_ones(self):
        result = self.service._prefix_to_mask(32)
        assert result == '255.255.255.255'

    def test_prefix_0_produces_all_zeros(self):
        result = self.service._prefix_to_mask(0)
        assert result == '0.0.0.0'

    def test_prefix_16_produces_class_b(self):
        result = self.service._prefix_to_mask(16)
        assert result == '255.255.0.0'

    def test_prefix_as_string_is_accepted(self):
        # Current code calls int() on the input — string works
        result = self.service._prefix_to_mask('24')
        assert result == '255.255.255.0'

    def test_prefix_33_current_behaviour(self):
        # Prefix > 32 is 'undefined' per original comment.
        # Current behaviour: bit shift wraps around producing an incorrect mask.
        # This test captures that current (incorrect) behaviour as a safety net.
        # A future refactoring may choose to raise instead — that requires an
        # intentional decision, not an accidental change.
        result = self.service._prefix_to_mask(33)
        # Capture actual current output — do not assume what it should be
        assert isinstance(result, str)
        assert len(result.split('.')) == 4
```

**Step 2: Use the characterisation tests as a gate on AI refactoring**

Prompt to the AI:

```
Refactor the _prefix_to_mask method in the class below to use Python's ipaddress
module instead of bit manipulation. The refactored version must pass ALL of the
following existing characterisation tests without modification:

[paste characterisation tests]

If the current behaviour for edge cases (e.g., prefix_len > 32) would change with
the ipaddress approach, document the change explicitly in a code comment rather
than silently altering it.

Here is the class:
[paste legacy code]
```

The AI returns a refactored version. Running the characterisation tests against it immediately
surfaces any behaviour divergence — including the edge-case behaviour for prefix > 32, which
may now raise a `ValueError` instead of silently wrapping. This is a visible, auditable change
rather than a silent regression.

---

## 4. Seams — Where AI Can Enter Safely

A **seam** is a place in the code where you can alter the behaviour of the program without
modifying the code in that place. Feathers identifies seams as the key concept for getting
legacy code under test — and for safely introducing AI-generated replacements.

For O&A legacy code, the most common and useful seam types are:

### Interface Seams

Where a legacy function makes a call to an external system — a NETCONF device, an SNMP
endpoint, an NMS API. The external call is a natural boundary: mock the external system,
test the logic on either side of the boundary.

```python
# Legacy code with NETCONF call embedded (no seam)
def configure_interface(device_ip, interface, config):
    with manager.connect(host=device_ip, ...) as m:
        # This call cannot be tested without a real device
        result = m.edit_config(target='running', config=config)
        if result.ok:
            return True
        raise RuntimeError(f"NETCONF edit-config failed: {result.errors}")

# Refactored with an interface seam (dependency injection)
def configure_interface(device_ip, interface, config, netconf_client=None):
    if netconf_client is None:
        netconf_client = NcclientAdapter()  # real implementation
    result = netconf_client.edit_config(device_ip, config)
    if result.ok:
        return True
    raise RuntimeError(f"NETCONF edit-config failed: {result.errors}")

# Now testable with a mock — and AI can generate the replacement logic
# with a mock netconf_client that returns controlled responses
```

### YANG Augment/Deviation Seams

The YANG data model has natural seams at `augment` and `deviation` boundaries. An AI-generated
augmentation can be added to a YANG model without touching the base model — the seam is the
augmentation point itself.

```yang
// Base model (legacy, do not touch)
module oa-legacy-service {
  // ... existing content ...
}

// AI-generated augmentation (new file, no modification to base)
module oa-legacy-service-ai-ext {
  import oa-legacy-service { prefix ls; }

  augment "/ls:services/ls:service" {
    // AI-generated extension: adds operational state nodes
    // that the base model lacks
    leaf ai-classification {
      type enumeration {
        enum standard;
        enum high-priority;
        enum maintenance-only;
      }
      config false;
      description "AI-assigned service classification based on usage patterns";
    }
  }
}
```

This pattern allows AI-generated YANG extensions to be introduced incrementally without
touching — and potentially breaking — the base model that existing service packages depend on.

### Object Seams

In legacy Python NSO service packages, object seams allow AI-generated replacements to be
introduced by subclassing rather than modifying:

```python
# Legacy class (tested via characterisation tests, do not modify)
class LegacyFulfilmentHandler:
    def process_order(self, order_data):
        # 200 lines of interleaved logic
        ...

# AI-generated replacement (subclass, override only what has changed)
class ModernFulfilmentHandler(LegacyFulfilmentHandler):
    def process_order(self, order_data):
        # AI-generated replacement that passes all characterisation tests
        # from the parent class
        ...

# Strangler fig router — see section 5
def get_handler(order_type):
    if feature_flag('use_modern_fulfilment'):
        return ModernFulfilmentHandler()
    return LegacyFulfilmentHandler()
```

### Identifying Seams in a Legacy NSO Service Package

When approaching a legacy NSO service package, look for these seam indicators:

| Code Pattern | Seam Type | How to Use |
|---|---|---|
| `manager.connect(host=...)` or `ncs.maapi.attach()` | Interface seam | Inject a mock client for testing the surrounding logic |
| `root.devices.device[x]` CDB access | Interface seam | Mock the CDB tree for unit testing service logic |
| `import` statements at module level | Object seam | Replace the imported module with a mock or new implementation |
| `if service.service_type == 'X':` | Preprocessor/config seam | Each branch is a seam; test each independently |
| Class-level `@Service.create` decorator | Object seam | Subclass `Service` and override `cb_create` |
| Hardcoded configuration values | Config seam | Move to YANG leaf defaults; AI generates the parametrised version |

---

## 5. The Strangler Fig Pattern for O&A

Martin Fowler's **Strangler Fig** pattern — named for the tropical vine that grows around a
host tree and eventually replaces it — provides the macro-level strategy for AI-assisted
legacy modernisation. Combined with Feathers' seams approach, it gives a complete method.

### The Six-Step Process

**Step 1: Identify the seam**
Locate a natural boundary in the legacy system where the old and new implementations can
coexist. For O&A, this is typically a function, a service callback, or a data collector with
a well-defined input/output contract.

**Step 2: Write characterisation tests**
Before touching the legacy code, write characterisation tests that capture its current
behaviour. These become the acceptance criteria for the AI-generated replacement.

**Step 3: Use AI to generate the replacement component**
With the characterisation tests as a specification (not perfect functional specs — they are
descriptions of current behaviour), use AI to generate the replacement. The prompt explicitly
references the characterisation tests as constraints.

**Step 4: Route traffic to the new component**
Use a feature flag, a router function, or a configuration option to direct a subset of
requests to the new component. Initially, route a small percentage or only in a non-production
environment.

**Step 5: Verify both paths produce identical outputs**
Run both the legacy and new components against the same inputs for a period. Log divergences.
Investigate any difference — it may represent a bug in the legacy code that the AI fixed, or
a subtle semantic difference that will cause a production incident.

**Step 6: Remove the legacy component**
Once confidence is established (both paths produce identical outputs under realistic conditions,
characterisation tests pass, no production incidents), remove the legacy code. The strangler
fig has replaced the host.

---

### O&A Worked Example: SNMP Polling to NETCONF/YANG Migration

**Legacy system:** A Python 2 SNMP collector that polls network interfaces every five minutes,
stores interface utilisation counters in a time-series database, and triggers alerts when
utilisation exceeds thresholds. 800 lines. No tests. The collector has several quirks: it
silently ignores devices that time out (logging a warning but not raising), it handles counter
wraps for 32-bit SNMP counters, and it applies a device-family-specific correction factor for
a known SNMP MIB inconsistency on one vendor's hardware.

**Goal:** Replace with a NETCONF/YANG-based collector using OpenConfig `interfaces` model.

---

**Step 1: Identify the seam**

The seam is the `collect_interface_stats(device_ip)` function. It takes a device IP address and
returns a dictionary of interface statistics. The SNMP library call inside is the interface seam.

**Step 2: Write characterisation tests**

```python
# tests/test_snmp_collector_characterisation.py

import pytest
from unittest.mock import patch, MagicMock
from snmp_collector import collect_interface_stats

# Mock SNMP responses captured from representative devices
MOCK_SNMP_NORMAL = {
    'ifInOctets.1': 1234567890,
    'ifOutOctets.1': 987654321,
    'ifOperStatus.1': 1,  # up
}
MOCK_SNMP_COUNTER_WRAP = {
    # 32-bit counter that has wrapped (value < previous reading)
    'ifInOctets.1': 12345,  # wrapped from 4294967295
    'ifOutOctets.1': 67890,
    'ifOperStatus.1': 1,
}
MOCK_SNMP_TIMEOUT = None  # Device did not respond

class TestSnmpCollectorCharacterisation:

    def test_normal_response_returns_dict_with_stats(self):
        with patch('snmp_collector.snmp_get', return_value=MOCK_SNMP_NORMAL):
            result = collect_interface_stats('192.168.1.1')
        assert 'interfaces' in result
        assert result['interfaces']['1']['in_octets'] == 1234567890

    def test_timeout_returns_empty_dict_not_exception(self):
        # Characterisation: current code swallows timeouts silently
        # This may be a bug — but we capture it as current behaviour
        with patch('snmp_collector.snmp_get', return_value=MOCK_SNMP_TIMEOUT):
            result = collect_interface_stats('192.168.1.1')
        assert result == {}

    def test_counter_wrap_is_handled(self):
        # The 32-bit wrap correction logic must survive refactoring
        with patch('snmp_collector.snmp_get', return_value=MOCK_SNMP_COUNTER_WRAP):
            with patch('snmp_collector.get_previous_reading', return_value=4000000000):
                result = collect_interface_stats('192.168.1.1')
        # Counter wrapped: 4294967295 - 4000000000 + 12345 = ~307000
        assert result['interfaces']['1']['in_octets_delta'] > 0
```

**Step 3: AI generates the NETCONF replacement**

```
Implement a collect_interface_stats(device_ip) function that uses NETCONF
and the OpenConfig interfaces YANG model (openconfig-interfaces) instead
of SNMP. The function must:

1. Return the same dictionary structure as the SNMP version (see characterisation
   tests below)
2. Handle device connection timeouts by returning an empty dict (matching current
   SNMP behaviour — see test_timeout_returns_empty_dict_not_exception)
3. Handle 64-bit YANG counters correctly (note: the SNMP version had 32-bit
   counter wrap logic — this is NOT needed for 64-bit YANG counters, but the
   return value structure must be compatible)
4. Use ncclient for the NETCONF connection

[paste characterisation tests]
```

**Step 4: Route traffic to the new component**

```python
# collector_router.py
import os
from snmp_collector import collect_interface_stats as snmp_collect
from netconf_collector import collect_interface_stats as netconf_collect

NETCONF_ENABLED_DEVICES = set(
    os.environ.get('NETCONF_COLLECTOR_DEVICES', '').split(',')
)

def collect_interface_stats(device_ip):
    if device_ip in NETCONF_ENABLED_DEVICES:
        return netconf_collect(device_ip)
    return snmp_collect(device_ip)
```

**Step 5: Verify both paths produce identical outputs**

Run both collectors against the same devices for two collection cycles and compare outputs.
Log divergences with full context. Investigate any difference before expanding the rollout.

**Step 6: Remove the SNMP collector**

After four weeks of parallel running with zero unexplained divergences, update the environment
variable to include all devices, then remove the SNMP collector code and the routing logic.

---

## 6. AI Prompting Strategies for Legacy Code

The following prompt patterns are specifically designed for O&A legacy work. Add proven
versions to the shared [prompt library](../tools/github-copilot.md).

### Characterisation

```
Explain what this code does WITHOUT assuming it is correct.
Describe what it actually does, not what it might be intended to do.
Note any behaviours that look like they might be bugs but appear to be relied upon.
Note any implicit assumptions about the environment (OS, library versions, device behaviour).

[paste code]
```

### Writing Characterisation Tests

```
Write pytest characterisation tests for the following function that capture its
CURRENT behaviour, including edge cases and error handling.

These are NOT tests of correct behaviour — they are a safety net to detect if a
refactoring changes the function's observable behaviour.

For each test, add a comment explaining what aspect of current behaviour it captures
and whether that behaviour appears intentional or incidental.

[paste function]
```

### Constrained Refactoring

```
Refactor this code to [specific goal — e.g., "use the ipaddress module",
"replace SNMP with NETCONF", "add type annotations"].

Constraints:
1. The refactored version MUST pass all of the following existing characterisation
   tests without any modification to the tests:
   [paste tests]

2. Do NOT change observable behaviour. If a refactoring would change behaviour
   (even to fix a bug), document it explicitly with a comment and flag it for review.

3. Keep the function signature identical unless the refactoring requires changing it,
   in which case explain why.

[paste code]
```

### Seam Identification

```
Identify all the seams in the following code where I could introduce dependency
injection to make the code testable without modifying its core logic.

For each seam, suggest:
1. What mock or stub would replace the real dependency in tests
2. What specific behaviour could be tested once the seam is introduced
3. Whether a subclass seam, parameter seam, or extraction would be most appropriate

[paste code]
```

---

### Before/After Example: Seam Introduction

**Before (untestable — NETCONF call embedded):**

```python
def sync_device_config(device_name, yang_config):
    """Apply YANG config to device and verify sync."""
    with ncs.maapi.Maapi() as m:
        with ncs.maapi.Session(m, 'admin', 'python') as s:
            tid = m.start_write_trans()
            try:
                ncs.maagic.get_root(m, tid).devices.device[device_name]\
                    .sync_from()
                # Apply config
                root = ncs.maagic.get_root(m, tid)
                # ... 50 lines of config application ...
                m.apply_trans(tid)
                return True
            except Exception as e:
                m.abort_trans(tid)
                raise RuntimeError(f"Config sync failed: {e}")
```

**After (testable — seam introduced via dependency injection):**

```python
def sync_device_config(device_name, yang_config, nso_client=None):
    """Apply YANG config to device and verify sync.

    Args:
        device_name: NSO device name
        yang_config: Config to apply as YANG data
        nso_client: NsoClient instance. If None, uses real NSO connection.
                    Inject a mock for testing.
    """
    if nso_client is None:
        nso_client = NsoMaapiClient()  # real implementation

    try:
        nso_client.sync_from(device_name)
        nso_client.apply_config(device_name, yang_config)
        return True
    except NsoClientError as e:
        raise RuntimeError(f"Config sync failed: {e}")

# Now testable:
# mock_client = MagicMock(spec=NsoMaapiClient)
# mock_client.sync_from.return_value = True
# result = sync_device_config('router1', config, nso_client=mock_client)
# assert result is True
```

---

## 7. The AI Safety Net Rule

!!! danger "Non-Negotiable: AI Safety Net Rule for O&A Legacy Work"
    **No AI-generated changes to legacy code without characterisation tests written first.**

    This is a team norm, not a guideline. It applies to:
    - Any refactoring of existing code (regardless of how "simple" it looks)
    - Any AI-generated "improvement" or "modernisation" of a legacy function
    - Any AI-generated migration from one technology to another (SNMP → NETCONF,
      Python 2 → Python 3, Ansible → Nornir, etc.)

    The only exception: changes that are purely additive (adding a new function or
    file that does not touch existing code paths).

    Cross-reference: this rule is encoded in the [ADR template](../governance/adr-template.md)
    under "Legacy Code Impact" and in the [team norms](../governance/team-norms.md) under
    "AI-Assisted Development Standards".

### Why the Rule Exists

Without this rule, the pattern that emerges is:

1. AI generates a refactored version that looks correct
2. The PR author reads the diff and it looks reasonable
3. The reviewer reads the diff and it looks reasonable
4. The change is merged
5. Three months later, a specific operational scenario (partial failure recovery,
   counter wrap, vendor-specific quirk) triggers the subtle semantic difference
6. The incident is attributed to "network issue" or "NSO bug" rather than the
   code change, because the connection is not obvious

Characterisation tests make the semantic difference visible at step 3 — before merge,
before production, before incident.

---

## 8. Prioritisation: What Legacy to Modernise First

Not all legacy code is equally worth modernising. With finite engineering capacity, the O&A
team should prioritise AI-assisted legacy modernisation where the expected value is highest.

### Prioritisation Scoring Matrix

Score each legacy component 1–5 on each of the four criteria. Multiply scores for a composite
priority score. Higher scores = higher priority to modernise.

| Criterion | 1 (Low) | 3 (Medium) | 5 (High) | Weight |
|---|---|---|---|---|
| **Test coverage** | >80% coverage | 20–80% coverage | <20% coverage (high AI safety risk) | ×2 |
| **Change frequency** | Rarely changed (<2/year) | Changed monthly | Changed weekly or on-call | ×3 |
| **Blast radius if broken** | Affects one team; fast recovery | Affects multiple services | Customer-impacting; slow recovery | ×3 |
| **AI code-gen suitability** | Highly complex domain logic (poor AI fit) | Mixed complexity | Repetitive patterns, clear spec (good AI fit) | ×1 |

**Composite score** = (Test coverage score × 2) + (Change frequency × 3) + (Blast radius × 3) + (AI suitability × 1)

Maximum score: 45. Minimum: 9.

### O&A Example Scoring

| Component | Test Coverage | Change Freq | Blast Radius | AI Suitability | Score |
|---|---|---|---|---|---|
| SNMP collector (Python 2) | 5 (no tests) | 3 (monthly) | 3 (ops team) | 4 (repetitive polling) | 5×2 + 3×3 + 3×3 + 4×1 = **36** |
| IP service callback (NSO) | 5 (no tests) | 4 (weekly) | 4 (customer services) | 2 (complex NETCONF logic) | 5×2 + 4×3 + 4×3 + 2×1 = **36** |
| Perl expect scripts | 5 (no tests) | 1 (rarely) | 2 (specific devices) | 3 (moderate) | 5×2 + 1×3 + 2×3 + 3×1 = **22** |
| Inventory reconciliation script | 4 (minimal) | 3 (monthly) | 2 (ops visibility) | 5 (data transformation) | 4×2 + 3×3 + 2×3 + 5×1 = **28** |

High scores indicate that the risk of the legacy code is high AND that modernisation is
tractable. Both the SNMP collector and the IP service callback score equally, suggesting they
should both be prioritised — start with whichever has more available capacity and clearer
seam boundaries.

### Additional Prioritisation Factors

Beyond the scoring matrix, consider:

- **Owner availability:** Does anyone still understand this code deeply enough to write
  characterisation tests? If not, the characterisation test effort is higher but more urgent.
- **Migration window:** Is there a planned platform refresh (moving from Python 2 to Python 3
  environment, from SNMP to NETCONF in device onboarding) that creates a natural migration
  trigger?
- **Enabling team availability:** Is the enabling team available to support this modernisation?
  Complex legacy modernisation (high blast radius components) should not be attempted without
  coaching support.

---

## References and Further Reading

- Feathers, M. (2004). *Working Effectively with Legacy Code*. Prentice Hall.
- Fowler, M. (2004). Strangler Fig Application. *martinfowler.com*.
- Feathers, M. (2004). Chapter 2: Working with Feedback — characterisation tests.
- Sweller, J. (1988). Cognitive load during problem solving. *Cognitive Science*, 12, 257–285.
- Related O&A docs: [Testing Discipline](testing-discipline.md) | [Team Topologies](team-topologies.md) | [ADR Template](../governance/adr-template.md) | [Team Norms](../governance/team-norms.md)

---

*Previous: [Team Topologies ←](team-topologies.md) | Next: [Engineering Principles →](engineering-principles.md)*
