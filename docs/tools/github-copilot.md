# GitHub Copilot Playbook — O&A Team

> **Audience:** All O&A team members (Python/Go, YANG/NETCONF, Ansible, NSO, TM Forum Open APIs)  
> **Mandate:** GitHub Copilot **Business** only — data isolation is non-negotiable (see [Responsible AI](#responsible-ai-copilot-specific-rules))  
> **Companion docs:** [`docs/governance/team-norms.md`](../governance/team-norms.md) · [`docs/responsible-ai/`](../responsible-ai/) · [`docs/tmforum/`](../tmforum/)

---

## Table of Contents

1. [What Copilot Is (and Isn't)](#1-what-copilot-is-and-isnt)
2. [Setup & Configuration](#2-setup--configuration)
3. [Core Workflow: O&A Task Patterns](#3-core-workflow-noa-task-patterns)
   - [Pattern 1: YANG Module Authoring](#pattern-1-yang-module-authoring)
   - [Pattern 2: Python ncclient / NETCONF Code](#pattern-2-python-ncclient--netconf-code)
   - [Pattern 3: Test Generation (TDD-first)](#pattern-3-test-generation-tdd-first)
   - [Pattern 4: Ansible Playbook & Role Generation](#pattern-4-ansible-playbook--role-generation)
   - [Pattern 5: Go gNMI Client Generation](#pattern-5-go-gnmi-client-generation)
   - [Pattern 6: TM Forum API Client Generation](#pattern-6-tm-forum-api-client-generation)
   - [Pattern 7: NSO Service Package Development](#pattern-7-nso-service-package-development)
4. [Copilot Chat: /commands Reference for O&A](#4-copilot-chat-commands-reference-for-noa)
5. [The PR Review Mindset](#5-the-pr-review-mindset)
6. [Responsible AI: Copilot-Specific Rules](#6-responsible-ai-copilot-specific-rules)
7. [Anti-Patterns](#7-anti-patterns)
8. [Prompt Template Library Contributions](#8-prompt-template-library-contributions)

---

## 1. What Copilot Is (and Isn't)

### What it does

- **Inline completions** — token-by-token prediction as you type, triggered by code context and comments
- **Copilot Chat** — conversational interface in VS Code / JetBrains for `/explain`, `/fix`, `/tests`, `/doc`
- **Context window** — roughly the open file plus files you have open in adjacent tabs; it has *no memory* of previous sessions
- **No internet access at inference time** — it was trained on a public code snapshot; it does not look up live RFCs, TM Forum specs, or vendor docs

### The Jagged Frontier for O&A (Mollick, 2023)

Ethan Mollick's *jagged frontier* describes the uneven capability boundary of LLM tools: tasks that look similar in difficulty can fall either inside (AI excels) or outside (AI confidently fails) that frontier. For O&A the map looks like this:

| Domain | **Strong** ✅ | **Weak** ⚠️ |
|---|---|---|
| **YANG** | Grouping/typedef/leaf scaffolding from comments; `description` statements; revision block boilerplate | `must`/`when` XPath with complex predicates; namespace URI values; `key` selection on multi-key lists |
| **Python** | `ncclient` connection boilerplate; XML parsing with `lxml`; docstrings; pytest fixtures | Novel protocol edge cases; correct namespace handling for vendor augments; security-sensitive credential flows |
| **Go** | Struct generation from proto definitions; repetitive error-wrapping patterns; table-driven test stubs | gNMI path encoding subtleties; TLS dial option combinations; streaming reconnect logic |
| **Ansible** | Task boilerplate; handler patterns; `defaults/main.yml` stubs; Molecule test scaffolding | Idempotency conditions (`failed_when`/`changed_when`); `no_log` placement; complex Jinja2 conditionals |
| **TM Forum** | Generating a client from a pasted endpoint signature | Knowing *which* TMF API already covers your use case — always check [Open API table](https://www.tmforum.org/oda/open-apis/table) first |
| **NSO** | Service callback boilerplate; MAAPI read patterns | Correct datastore (`RUNNING` vs `OPERATIONAL`); rollback logic; thread-safety in service callbacks |
| **Architecture** | Summarising a design for a PR description | Cross-service dependency decisions; SoC boundary enforcement; security architecture |

### The right mental model

> *Treat Copilot as a fast but inexperienced colleague: brilliant at boilerplate, enthusiastic, never embarrassed about being wrong.  
> You are the senior team member. You review everything before it ships.*  
> — paraphrased from Mollick, *Co-Intelligence* (2024)

This colleague has read a lot of code but has never operated a real network, never seen your topology, and has no idea what broke at 2 am last quarter.

---

## 2. Setup & Configuration

### Copilot Business vs Individual

| | Individual | **Business** (mandatory for O&A) |
|---|---|---|
| Data sent to GitHub/OpenAI | Yes, by default | **Isolated — prompts and completions not used for training** |
| Org policy enforcement | ❌ | ✅ |
| Audit log | ❌ | ✅ |
| `.copilotignore` enforcement | Local only | Org-enforced |

**Action:** Confirm your account is on the org-provisioned Business seat. Settings → Copilot → "Managed by *your-org*" should appear. If it doesn't, raise a ticket before using Copilot on O&A code.

### IDE Setup

**VS Code**
```
ext install GitHub.copilot
ext install GitHub.copilot-chat
```
Sign in with your org GitHub account (SSO). Verify via: `Ctrl+Shift+P` → *GitHub Copilot: Check Status*.

**JetBrains (IntelliJ / GoLand / PyCharm)**  
Install the *GitHub Copilot* plugin from the marketplace. Sign in. Confirm the status bar shows `Copilot: ready`.

### Recommended settings for O&A work

Add to your VS Code workspace `.vscode/settings.json` (commit this to the repo):

```json
{
  "github.copilot.enable": {
    "*": true,
    "python": true,
    "go": true,
    "yaml": true,
    "yang": true,
    "plaintext": false,
    "markdown": false,
    "dotenv": false,
    "properties": false
  },
  "github.copilot.advanced": {
    "length": 500,
    "inlineSuggestCount": 3
  }
}
```

> **YANG caveat:** Enable suggestions for `.yang` files, but treat every `must`, `when`, and `key` statement as needing manual validation. Copilot's YANG training data is sparse for vendor augments.

### `.copilotignore` — what to exclude

Create `.copilotignore` at the repo root. This follows `.gitignore` syntax and prevents Copilot from using matching files as context:

```
# Real network configuration files
configs/devices/
inventories/production/
inventories/staging/

# Credential and secret files
**/*.env
**/secrets.yml
**/vault-pass*
**/*credentials*

# Files containing real IP addressing / topology data
docs/network-diagrams/
topology/

# Customer data
customers/
```

**Rule:** If you would not commit it to a public repo, it goes in `.copilotignore`. See [Section 6](#6-responsible-ai-copilot-specific-rules) for the full policy.

### Giving Copilot better workspace context

Copilot's context window spans open editor tabs. Before generating code:

1. **Open the relevant YANG module** alongside your Python file — Copilot will infer leaf names and types
2. **Open the TM Forum spec YAML** when writing API clients
3. **Open an existing, well-written module** in an adjacent tab — Copilot will pattern-match your team's conventions
4. **Write a module-level docstring or file header comment** before triggering completions — this anchors the intent

---

## 3. Core Workflow: O&A Task Patterns

---

### Pattern 1: YANG Module Authoring

#### Step-by-step

1. **Start with the RFC or requirements.** Open it in a browser tab. Do not ask Copilot to invent semantics — you define the data model, Copilot scaffolds the syntax.
2. **Write the module header manually.** Namespace URIs, prefix, organisation, and contact must be correct. Copilot will hallucinate plausible-looking namespaces that won't match your registry.
3. **Use comments to drive leaf/grouping generation** — see example below.
4. **Run `pyang --strict` immediately.** This is a CI gate; don't accumulate pyang errors.
5. **Manually review every `must`, `when`, `key`, and `config false` statement** before committing.

#### Worked example: YANG augment for interface extension

```yang
// noa-interface-ext.yang — write the header manually:
module noa-interface-ext {
  namespace "urn:noa:yang:noa-interface-ext";
  prefix noa-if-ext;

  import ietf-interfaces { prefix if; }
  import ietf-inet-types  { prefix inet; }

  organization "O&A Team";
  contact      "noa-team@example.internal";
  description  "O&A-specific augmentations to ietf-interfaces.";

  revision 2024-09-01 {
    description "Initial version.";
    reference   "O&A-REQ-0042";
  }

  // Copilot prompt: augment /if:interfaces/if:interface to add
  // O&A-specific operational metadata: circuit-id (string, max 64),
  // provider-asr (uint32), and config false operational counters
  // for tx-discards and rx-discards (uint64).
  augment "/if:interfaces/if:interface" {
    leaf circuit-id {
      type string { length "1..64"; }
      description "Provider circuit identifier for this interface.";
    }
    leaf provider-asr {
      type uint32;
      description "Provider Autonomous System Region identifier.";
    }
    leaf tx-discards {
      type uint64;
      config false;
      description "Transmit discard counter (operational).";
    }
    leaf rx-discards {
      type uint64;
      config false;
      description "Receive discard counter (operational).";
    }
  }
}
```

**pyang fix cycle:**
```bash
pyang --strict noa-interface-ext.yang
```
Common Copilot errors to fix:
- Missing `import` for types used in `type` statements
- `must` with XPath referencing a sibling incorrectly (`../leaf` vs `../../container/leaf`)
- `key` omitted on `list` nodes
- `config false` applied to a node inside a `config true` parent that should propagate

---

### Pattern 2: Python ncclient / NETCONF Code

#### Step-by-step

1. **Open the target YANG module** in an adjacent tab before writing Python.
2. **Use comment-driven generation** — write the intent as a comment and let Copilot complete the function signature and body.
3. **Validate generated XML against the YANG schema** using `pyang` or `yangson` before running against a device.
4. **Immediately replace any hardcoded credentials** Copilot generates — it always will. Move to environment variables or a secrets manager.
5. **Add error handling** — Copilot rarely generates it for NETCONF transport failures.

#### Worked example: retrieve and parse interface operational data

```python
"""NETCONF interface operations for O&A — noa/netconf/interface_ops.py"""

import os
from typing import Any

from lxml import etree
from ncclient import manager
from ncclient.transport.errors import SSHError, AuthenticationError


# YANG namespace used in noa-interface-ext
O&A_IF_EXT_NS = "urn:noa:yang:noa-interface-ext"
IETF_IF_NS    = "urn:ietf:params:xml:ns:yang:ietf-interfaces"

# Copilot prompt: define a dataclass for interface operational data
# containing name (str), circuit_id (str), tx_discards (int), rx_discards (int)
from dataclasses import dataclass

@dataclass
class InterfaceOpData:
    name:         str
    circuit_id:   str
    tx_discards:  int
    rx_discards:  int


def get_interface_op_data(
    host: str,
    port: int = 830,
    *,
    username: str | None = None,
    password: str | None = None,
) -> list[InterfaceOpData]:
    """Retrieve O&A interface operational data via NETCONF get-config.

    Credentials default to O&A_NETCONF_USER / O&A_NETCONF_PASS env vars.
    Raises:
        AuthenticationError: if credentials are rejected.
        SSHError: on transport failure.
        ValueError: if the device returns malformed XML.
    """
    # Copilot prompt: connect to the device using ncclient manager.connect
    # with host_key_verify=False for lab use, then issue a <get> RPC
    # with a subtree filter targeting /interfaces/interface state data
    username = username or os.environ["O&A_NETCONF_USER"]
    password = password or os.environ["O&A_NETCONF_PASS"]

    subtree_filter = """
      <interfaces xmlns="{ietf}" xmlns:noa="{noa}">
        <interface>
          <name/>
          <noa:circuit-id/>
          <noa:tx-discards/>
          <noa:rx-discards/>
        </interface>
      </interfaces>
    """.format(ietf=IETF_IF_NS, noa=O&A_IF_EXT_NS)

    try:
        with manager.connect(
            host=host,
            port=port,
            username=username,
            password=password,
            hostkey_verify=False,   # NOTE: set to True + supply known_hosts in prod
            device_params={"name": "default"},
        ) as nc:
            reply = nc.get(filter=("subtree", subtree_filter))
    except AuthenticationError as exc:
        raise AuthenticationError(f"Auth failed for {host}:{port}") from exc
    except SSHError as exc:
        raise SSHError(f"Transport failure connecting to {host}:{port}") from exc

    return _parse_interface_reply(reply.data_xml)


def _parse_interface_reply(data_xml: str) -> list[InterfaceOpData]:
    """Parse NETCONF reply XML into InterfaceOpData objects."""
    # Copilot prompt: parse data_xml with lxml, iterate interface elements,
    # extract name, circuit-id, tx-discards, rx-discards using Clark notation namespaces
    ns = {"if": IETF_IF_NS, "noa": O&A_IF_EXT_NS}
    root = etree.fromstring(data_xml.encode())
    results: list[InterfaceOpData] = []

    for iface in root.findall(".//if:interface", ns):
        name_el       = iface.find("if:name", ns)
        circuit_el    = iface.find("noa:circuit-id", ns)
        tx_el         = iface.find("noa:tx-discards", ns)
        rx_el         = iface.find("noa:rx-discards", ns)

        if name_el is None:
            raise ValueError("Malformed reply: <name> missing in <interface>")

        results.append(InterfaceOpData(
            name        = name_el.text or "",
            circuit_id  = circuit_el.text if circuit_el is not None else "",
            tx_discards = int(tx_el.text) if tx_el is not None else 0,
            rx_discards = int(rx_el.text) if rx_el is not None else 0,
        ))
    return results
```

> **Security gate:** Run Bandit (`bandit -r noa/`) in CI. `hostkey_verify=False` should trigger a finding in non-lab targets — that is intentional.

---

### Pattern 3: Test Generation (TDD-first)

#### Step-by-step (Dave Farley's TDD discipline)

1. **Write the test docstring first** — Copilot uses it as the strongest intent signal.
2. **Use `/tests` in Copilot Chat** or add `# Write pytest tests for the function above`.
3. **Review specifically for what AI misses:**
   - Empty / zero-length result sets
   - Malformed XML inputs
   - Connection timeout / `SSHError` paths
   - Wrong namespace in the XML fixture
4. **Add missing edge cases before the suite is "done".** A Copilot-generated test suite covers the happy path. CI coverage gates catch the gap.
5. **Mock accuracy:** verify that mocks match real `ncclient` return types (e.g., `manager.connect` returns a context manager; the `get()` return has `.data_xml`, not `.xml`).

#### Worked example: tests for the NETCONF connection wrapper

```python
"""Tests for noa.netconf.interface_ops — tests/netconf/test_interface_ops.py"""

import pytest
from unittest.mock import MagicMock, patch

from noa.netconf.interface_ops import (
    InterfaceOpData,
    _parse_interface_reply,
    get_interface_op_data,
)
from ncclient.transport.errors import AuthenticationError, SSHError


# ---------------------------------------------------------------------------
# Fixtures
# ---------------------------------------------------------------------------

VALID_XML = """
<data>
  <interfaces xmlns="urn:ietf:params:xml:ns:yang:ietf-interfaces">
    <interface>
      <name>GigabitEthernet0/0</name>
      <circuit-id xmlns="urn:noa:yang:noa-interface-ext">CID-0042</circuit-id>
      <tx-discards xmlns="urn:noa:yang:noa-interface-ext">17</tx-discards>
      <rx-discards xmlns="urn:noa:yang:noa-interface-ext">3</rx-discards>
    </interface>
  </interfaces>
</data>
"""

MISSING_NAME_XML = """
<data>
  <interfaces xmlns="urn:ietf:params:xml:ns:yang:ietf-interfaces">
    <interface>
      <circuit-id xmlns="urn:noa:yang:noa-interface-ext">CID-0042</circuit-id>
    </interface>
  </interfaces>
</data>
"""

EMPTY_XML = """<data><interfaces xmlns="urn:ietf:params:xml:ns:yang:ietf-interfaces"/></data>"""

# ---------------------------------------------------------------------------
# _parse_interface_reply — unit tests (no network I/O)
# ---------------------------------------------------------------------------

# Copilot prompt: write pytest tests for _parse_interface_reply
# covering: valid XML returns correct dataclass, empty interfaces returns [],
# missing <name> raises ValueError, optional leaves default to empty/0

def test_parse_valid_xml_returns_dataclass():
    result = _parse_interface_reply(VALID_XML)
    assert len(result) == 1
    assert result[0] == InterfaceOpData(
        name="GigabitEthernet0/0",
        circuit_id="CID-0042",
        tx_discards=17,
        rx_discards=3,
    )


def test_parse_empty_interfaces_returns_empty_list():
    assert _parse_interface_reply(EMPTY_XML) == []


def test_parse_missing_name_raises_value_error():
    with pytest.raises(ValueError, match="<name> missing"):
        _parse_interface_reply(MISSING_NAME_XML)


def test_parse_missing_optional_leaves_default_to_zero():
    xml = """
    <data>
      <interfaces xmlns="urn:ietf:params:xml:ns:yang:ietf-interfaces">
        <interface><name>lo0</name></interface>
      </interfaces>
    </data>
    """
    result = _parse_interface_reply(xml)
    assert result[0].tx_discards == 0
    assert result[0].rx_discards == 0
    assert result[0].circuit_id == ""


# ---------------------------------------------------------------------------
# get_interface_op_data — integration-style with mocked ncclient
# NOTE: these are what Copilot typically OMITS — add them manually
# ---------------------------------------------------------------------------

@patch("noa.netconf.interface_ops.manager.connect")
def test_get_op_data_calls_get_and_returns_parsed(mock_connect):
    mock_nc = MagicMock()
    mock_nc.__enter__ = MagicMock(return_value=mock_nc)
    mock_nc.__exit__ = MagicMock(return_value=False)
    mock_nc.get.return_value.data_xml = VALID_XML
    mock_connect.return_value = mock_nc

    result = get_interface_op_data("10.0.0.1", username="u", password="p")
    assert result[0].name == "GigabitEthernet0/0"
    mock_nc.get.assert_called_once()


@patch("noa.netconf.interface_ops.manager.connect", side_effect=AuthenticationError)
def test_get_op_data_propagates_auth_error(mock_connect):
    with pytest.raises(AuthenticationError):
        get_interface_op_data("10.0.0.1", username="bad", password="creds")


@patch("noa.netconf.interface_ops.manager.connect", side_effect=SSHError)
def test_get_op_data_propagates_ssh_error(mock_connect):
    with pytest.raises(SSHError):
        get_interface_op_data("10.0.0.1", username="u", password="p")
```

> **What Copilot generated vs what was added manually:**  
> Copilot produced the happy-path test and the empty-list test.  
> The `missing_name`, `optional_leaves`, `auth_error`, and `ssh_error` cases were added manually — these are exactly the edges that matter in production.

---

### Pattern 4: Ansible Playbook & Role Generation

#### Step-by-step

1. Use Copilot for: task boilerplate, handler definitions, `defaults/main.yml`, Molecule test scaffolding.
2. **After generation, audit every task for:**
   - Missing `changed_when` (idempotency) on shell/command tasks
   - Missing `failed_when` on tasks that succeed with a non-zero exit code
   - Variables that should come from `defaults/` or `vars/` but are hardcoded
   - Sensitive values needing `no_log: true`
3. **TM Forum connection:** If the playbook calls a TMF API endpoint, paste the relevant OpenAPI path into a comment — Copilot will use the field names.

#### Worked example: VLAN configuration role with idempotency

```yaml
# roles/noa_vlan/tasks/main.yml
# Copilot prompt: Ansible tasks to configure a VLAN on a Cisco IOS-XE device
# using ios_vlans module. Must be idempotent. VLAN id from var noa_vlan_id (int),
# name from noa_vlan_name (str). Notify handler to save config.

---
- name: Configure VLAN {{ noa_vlan_id }} — {{ noa_vlan_name }}
  cisco.ios.ios_vlans:
    config:
      - vlan_id: "{{ noa_vlan_id }}"
        name:    "{{ noa_vlan_name }}"
        state:   active
    state: merged
  notify: save ios config

- name: Verify VLAN {{ noa_vlan_id }} is present in running config
  cisco.ios.ios_command:
    commands: "show vlan id {{ noa_vlan_id }}"
  register: vlan_check
  changed_when: false                    # <-- Copilot often omits this
  failed_when: "'not found' in vlan_check.stdout[0]"
```

```yaml
# roles/noa_vlan/handlers/main.yml
---
- name: save ios config
  cisco.ios.ios_command:
    commands: write memory
  changed_when: true
```

```yaml
# roles/noa_vlan/defaults/main.yml
---
noa_vlan_id:   999          # override in inventory or playbook
noa_vlan_name: "unset"
```

> **Idempotency test in Molecule:** run the converge twice and assert `changed=0` on the second run. Copilot generates a `molecule/default/converge.yml` correctly but omits the idempotency scenario — add `molecule/idempotency/` manually.

---

### Pattern 5: Go gNMI Client Generation

#### Key uses for Copilot

- gNMI proto struct population (`gnmi.Path`, `gnmi.PathElem`)
- `Subscribe` stream setup and reconnect loop skeleton
- Table-driven tests for path encoding

#### Worked example: gNMI interface counter subscription

```go
// noa/gnmi/subscriber.go
// Copilot prompt: Go function to open a gNMI Subscribe RPC to a device,
// subscribe SAMPLE mode to /interfaces/interface[name=*]/state/counters,
// print each update. Use openconfig/gnmi proto, TLS with system cert pool.

package gnmi

import (
	"context"
	"crypto/tls"
	"crypto/x509"
	"fmt"
	"io"

	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials"

	gnmipb "github.com/openconfig/gnmi/proto/gnmi"
)

// SubscribeInterfaceCounters streams interface counter updates from target.
// target must include port, e.g. "router1.example.internal:57400".
func SubscribeInterfaceCounters(ctx context.Context, target string) error {
	pool, err := x509.SystemCertPool()
	if err != nil {
		return fmt.Errorf("loading system cert pool: %w", err)
	}
	tlsCfg := &tls.Config{RootCAs: pool, MinVersion: tls.VersionTLS12}

	conn, err := grpc.DialContext(ctx, target,
		grpc.WithTransportCredentials(credentials.NewTLS(tlsCfg)),
	)
	if err != nil {
		return fmt.Errorf("dial %s: %w", target, err)
	}
	defer conn.Close()

	client := gnmipb.NewGNMIClient(conn)

	// Copilot prompt: build a SubscribeRequest for SAMPLE mode, 30s interval,
	// path /interfaces/interface[name=*]/state/counters
	req := &gnmipb.SubscribeRequest{
		Request: &gnmipb.SubscribeRequest_Subscribe{
			Subscribe: &gnmipb.SubscriptionList{
				Encoding: gnmipb.Encoding_PROTO,
				Mode:     gnmipb.SubscriptionList_STREAM,
				Subscription: []*gnmipb.Subscription{{
					Path: &gnmipb.Path{
						Elem: []*gnmipb.PathElem{
							{Name: "interfaces"},
							{Name: "interface", Key: map[string]string{"name": "*"}},
							{Name: "state"},
							{Name: "counters"},
						},
					},
					Mode:           gnmipb.SubscriptionMode_SAMPLE,
					SampleInterval: 30_000_000_000, // nanoseconds
				}},
			},
		},
	}

	stream, err := client.Subscribe(ctx)
	if err != nil {
		return fmt.Errorf("subscribe: %w", err)
	}
	if err := stream.Send(req); err != nil {
		return fmt.Errorf("send subscribe request: %w", err)
	}

	for {
		resp, err := stream.Recv()
		if err == io.EOF {
			return nil
		}
		if err != nil {
			return fmt.Errorf("stream recv: %w", err) // caller handles reconnect
		}
		fmt.Printf("gNMI update: %v\n", resp)
	}
}
```

> **Watch for:** Copilot occasionally uses `grpc.Dial` (deprecated) instead of `grpc.DialContext`. It also omits `MinVersion: tls.VersionTLS12` on TLS config — add it. Reconnect logic (exponential backoff on `stream.Recv` error) is never generated automatically.

---

### Pattern 6: TM Forum API Client Generation

#### Step-by-step (API-first principle — Newman, *Building Microservices*)

> **Rule:** Before generating any TMF integration code, confirm the relevant Open API exists at [tmforum.org/oda/open-apis/table](https://www.tmforum.org/oda/open-apis/table). Do not build a bespoke client for something TMF has already standardised.

1. **Download the TMF Open API YAML spec** (e.g., TMF639 Resource Inventory) from the TM Forum portal.
2. **Open the spec YAML in an IDE tab** alongside your Python file — Copilot will infer field names and types.
3. **Comment-drive the generation:**
   ```python
   # Generate a Python client for TMF639 ResourceInventory
   # GET /resourceInventoryManagement/v4/resource
   # Returns a list of Resource objects per TMF639 schema
   ```
4. **Validate generated field names** against the spec. Copilot commonly mutates `camelCase` to `snake_case` without noting the mapping.
5. **Generate conformance tests** immediately:
   ```python
   # Write pytest tests that POST a minimal valid Resource and validate
   # the response body conforms to TMF639 Resource schema
   ```

#### Worked example: TMF639 resource fetch

```python
# noa/tmf/tmf639_client.py
# API-first: based on TMF639 v4.0.0 OpenAPI spec
# Endpoint: GET /resourceInventoryManagement/v4/resource

import os
from typing import Any

import httpx
from pydantic import BaseModel, Field


class TMF639Resource(BaseModel):
    """Minimal TMF639 Resource — extend with fields from spec as needed."""
    id:            str
    href:          str
    name:          str
    resource_type: str  = Field(alias="@type")
    base_type:     str  = Field(alias="@baseType", default="Resource")

    class Config:
        populate_by_name = True


class TMF639Client:
    """Client for TMF639 Resource Inventory Management API."""

    def __init__(self, base_url: str, token: str | None = None) -> None:
        self._base = base_url.rstrip("/")
        self._headers = {"Authorization": f"Bearer {token or os.environ['TMF_API_TOKEN']}"}

    def list_resources(self, fields: str | None = None, **filters: Any) -> list[TMF639Resource]:
        """GET /resourceInventoryManagement/v4/resource with optional field projection."""
        params: dict[str, Any] = {k: v for k, v in filters.items() if v is not None}
        if fields:
            params["fields"] = fields

        resp = httpx.get(
            f"{self._base}/resourceInventoryManagement/v4/resource",
            headers=self._headers,
            params=params,
            timeout=10.0,
        )
        resp.raise_for_status()
        return [TMF639Resource.model_validate(item) for item in resp.json()]
```

> **SoC note (Hohpe):** This client is a single-responsibility adapter. Do not add business logic here. Callers own the orchestration.

---

### Pattern 7: NSO Service Package Development

#### Key uses for Copilot

- `ncs.application.Application` subclass boilerplate
- `ServiceCallbacks.cb_create` skeleton with MAAPI transaction pattern
- YANG service model stubs (`uses ncs:nano-plan-data`, service input leaves)

#### Critical watch list

| Risk | Copilot mistake | Correct pattern |
|---|---|---|
| Wrong datastore | Uses `ncs.RUNNING` for operational reads | Use `ncs.OPERATIONAL` for state, `ncs.RUNNING` for config |
| No rollback | Omits `t.revert()` or `raise` on failure | Wrap all MAAPI writes in try/except; let NSO handle rollback via exception propagation |
| Thread safety | Global state in service callback | Service callbacks are multi-threaded; use only `root`, `service`, and local variables |

```python
# packages/noa-vlan-svc/python/noa_vlan_svc/main.py
# Copilot prompt: NSO service callback for noa-vlan-svc
# cb_create reads service input vlan-id and name, applies config to
# /devices/device[name]/config using MAAPI, thread-safe, no global state

import ncs
from ncs.application import Service


class VlanServiceCallbacks(Service):
    @Service.create
    def cb_create(self, tctx, root, service, proplist):
        self.log.info(f"Creating VLAN service: {service.name}")

        vlan_id   = service.vlan_id    # from YANG service model leaf
        vlan_name = service.vlan_name

        for device_name in service.device:
            dev = root.devices.device[device_name]
            vlan = dev.config.ios__vlan.vlan_list.create(vlan_id)
            vlan.name = vlan_name
            # NSO FASTMAP handles rollback automatically on exception —
            # do NOT catch exceptions silently here


class Main(ncs.application.Application):
    def setup(self):
        self.log.info("noa-vlan-svc starting")
        self.register_service("noa-vlan-svc", VlanServiceCallbacks)

    def teardown(self):
        self.log.info("noa-vlan-svc stopping")
```

---

## 4. Copilot Chat: /commands Reference for O&A

| Command | What it does | O&A usage example |
|---|---|---|
| `/explain` | Explains selected code in plain language | Select a YANG grouping → `/explain` → "Explain this grouping and what network resource it models" |
| `/fix` | Suggests a fix for the selected code or error | Paste a pyang error → `/fix` → Copilot suggests the corrected YANG syntax |
| `/tests` | Generates a test suite for selected code | Select `get_interface_op_data` → `/tests` → generates pytest stubs (review for missing edges) |
| `/doc` | Generates docstrings/comments for selected code | Select an ncclient function → `/doc` → generates Google-style docstring |
| `/new` | Scaffolds a new file or project structure | `/new ansible role for noa bgp peer management` |

### Best prompt patterns for O&A

```
# YANG — be specific about the RFC and constraints
"Generate a YANG grouping for BGP peer configuration per RFC 9234.
Include: peer-as (uint32), peer-address (inet:ip-address), hold-time (uint16, default 90).
Add a must expression ensuring hold-time is 0 or >= 3."

# NETCONF — anchor to the schema
"Write a Python function using ncclient to send a NETCONF edit-config
targeting /interfaces/interface[name='{name}']/config using the ietf-interfaces YANG module.
Use environment variables for credentials. Handle SSHError and RPCError."

# TM Forum — reference the spec version
"Write a Python function to GET from TMF640 Service Activation and Configuration API v4
endpoint /serviceActivationConfiguration. Parse the response into a list of
ServiceActivationConfiguration Pydantic models with fields: id, name, state."

# Go gNMI — be explicit about proto types
"Write a Go function that builds a gnmi.Path for
/network-instances/network-instance[name='DEFAULT']/protocols/protocol[type=BGP]/bgp/neighbors
using openconfig/gnmi proto PathElem structs."
```

---

## 5. The PR Review Mindset

### SPACE-A caution (Forsgren et al.)

The **acceptance rate** metric in Copilot telemetry tells you *how often suggestions were accepted*, not whether those suggestions were correct, safe, or well-designed. Teams that optimise for acceptance rate produce more code faster — and may introduce more subtle bugs faster too.

> Acceptance rate is a **context metric**, not a **quality metric**.  
> Use it to understand how the team is engaging with the tool, not to reward or rank team members.

### Every Copilot-assisted PR needs

Before approving a PR that contains Copilot-assisted code, the author attests (per the PR template in [`docs/governance/team-norms.md`](../governance/team-norms.md)):

- [ ] **DRY:** No copy-paste duplication introduced by accepting repeated suggestions
- [ ] **SoC:** No business logic in data-access layers; no cross-service DB queries
- [ ] **TM Forum check:** Any TMF API integration was validated against the Open API table before code was written
- [ ] **pyang / schema validation** passed (YANG changes)
- [ ] **SAST gate passed** (Bandit for Python, `gosec` for Go) — no new HIGH findings
- [ ] **Test coverage:** Copilot-generated tests were reviewed and edge cases added manually

### Author stance

> *"I reviewed all Copilot output line by line. I own it exactly as if I typed it."*  
> — expected author stance, from [`docs/governance/team-norms.md`](../governance/team-norms.md)

This is not bureaucracy — it is MSD discipline (Farley, *Continuous Delivery*). AI-assisted code must meet the same CI/CD gates as hand-written code. The CI pipeline does not have a "Copilot generated it" bypass.

---

## 6. Responsible AI: Copilot-Specific Rules

### Privacy rules (mandatory)

| Rule | Detail |
|---|---|
| No real device configurations | Do not open or paste files containing real device configs, running configs, or backup configs into any IDE session where Copilot is enabled |
| No real credentials | Never paste passwords, tokens, SNMP community strings, or API keys into a Copilot-visible file. Use sanitised fixtures with placeholder values |
| No real IP addressing | Test fixtures must use RFC 5737 documentation addresses (`192.0.2.0/24`, `198.51.100.0/24`, `203.0.113.0/24`) or your lab range — never production addressing |
| No customer topology data | Diagrams, topology files, and customer service data belong outside the repo and outside IDE sessions |
| `.copilotignore` is not optional | Maintain the team `.copilotignore` in the repo root. Do not override or delete entries to "improve suggestions" (see [Anti-Pattern 5](#7-anti-patterns)) |

### Verifying Copilot Business data isolation

1. GitHub → Settings → Copilot → Policies
2. Confirm **"Allow GitHub to use my data for product improvements"** is **OFF** (this is off by default for Business; verify it)
3. If you see **"Managed by *your-org*"** you are on the Business plan — proceed
4. If you see individual plan controls, **stop and raise a ticket** — do not use Copilot on O&A code until this is resolved

### SAST requirements

All AI-generated code passes through the same SAST pipeline as hand-written code:

- **Python:** Bandit (`bandit -r . -ll`) — HIGH severity blocks merge
- **Go:** `gosec ./...` — HIGH severity blocks merge
- **YAML (Ansible):** `ansible-lint` — violations at ERROR level block merge
- **OWASP LLM awareness:** Be alert to [OWASP LLM Top 10](https://owasp.org/www-project-top-10-for-large-language-model-applications/) risks, particularly:
  - **LLM02 (Insecure Output Handling):** Copilot output is not sanitised — treat it as untrusted input to your codebase
  - **LLM06 (Sensitive Information Disclosure):** ensure `.copilotignore` prevents secrets from appearing in completion context

### Environmental note

Copilot uses GPT-4 Turbo class inference optimised for short completions. Per O&A's SCI (Software Carbon Intensity) tracking commitment, Copilot usage should be included in AI tool energy estimates in quarterly reporting. It is a low-intensity tool relative to batch training workloads, but it is not zero.

---

## 7. Anti-Patterns

### AP-1: Accepting YANG with unvalidated `must` expressions

**What it looks like:**
```yang
leaf hold-time {
  type uint16;
  must ". = 0 or . >= 3" {
    error-message "Hold time must be 0 or at least 3 seconds.";
  }
}
```
Copilot produces this XPath. It looks right. On a different YANG compiler it fails because the correct XPath for a leaf's own value in some contexts is `current()` not `.`.

**Why it's dangerous:** Ships to CI, pyang passes (some expressions are valid), device rejects on load.

**What to do instead:** Run `pyang --strict` *and* test on a YANG emulator or NSO `ncs_load` with a sample payload before committing.

---

### AP-2: Copilot-generated hardcoded credentials

**What it looks like:**
```python
with manager.connect(host="10.1.1.1", username="admin", password="Admin1234!")
```
Copilot generates this *every time* it completes a connection pattern.

**Why it's dangerous:** Team Members accept the suggestion and commit it. Even in a "test" file this pattern propagates into production through copy-paste.

**What to do instead:** Immediately replace with env var or secrets manager lookup. Add a pre-commit hook (detect-secrets) that blocks commits containing credential patterns.

---

### AP-3: Missing NETCONF error handling ("happy path only")

**What it looks like:** The generated function has no `except` blocks. It calls `nc.get()` and unpacks the result directly.

**Why it's dangerous:** NETCONF connections to real devices fail. An `RPCError` (e.g., data model lock, candidate commit conflict) raises an exception that propagates to an unhandled crash in a long-running automation loop.

**What to do instead:** Always add explicit handling for `ncclient.operations.errors.RPCError`, `SSHError`, and `AuthenticationError`. See [Pattern 2](#pattern-2-python-ncclient--netconf-code) for the template.

---

### AP-4: Accepting test stubs as real tests

**What it looks like:**
```python
def test_get_interface_data():
    result = get_interface_op_data("10.0.0.1")
    assert result is not None
```
Copilot frequently generates tests that assert the result is not `None`. This test passes even if the function returns `[]` or crashes inside a `try/except` that swallows exceptions.

**Why it's dangerous:** Coverage metrics go green, CI passes, but no real behaviour is verified.

**What to do instead:** Immediately extend generated tests: assert specific values, assert specific exceptions on failure paths. See [Pattern 3](#pattern-3-test-generation-tdd-first) for the discipline.

---

### AP-5: Overriding `.copilotignore` to get "better suggestions"

**What it looks like:** An team member removes `inventories/production/` from `.copilotignore` because Copilot's Ansible completions improve when it can see the real inventory.

**Why it's dangerous:** Real hostnames, IPs, and sometimes credentials pass through Copilot's context. Even with Business data isolation this violates O&A's data handling policy and potentially customer contracts.

**What to do instead:** Create sanitised example inventories in `tests/fixtures/inventories/` with RFC 5737 addresses. Use these as the context source.

---

### AP-6: Using Copilot to write a new TMF API client without checking the Open API table

**What it looks like:** An team member asks Copilot to generate a Python client for querying service orders, and Copilot produces a reasonable-looking bespoke REST client with custom field names.

**Why it's dangerous:** TMF641 Service Order Management already defines this API with a standardised schema. Bespoke clients create integration debt, break future conformance testing, and duplicate work other teams have already done.

**What to do instead:** Check [tmforum.org/oda/open-apis/table](https://www.tmforum.org/oda/open-apis/table) first. If an Open API covers your use case, start from the official YAML spec (see [Pattern 6](#pattern-6-tm-forum-api-client-generation)).

---

### AP-7: Treating high acceptance rate as a team success metric

**What it looks like:** A sprint retrospective celebrates "our Copilot acceptance rate went from 28% to 41% this month."

**Why it's dangerous:** This optimises for *accepting more suggestions*, which is not the same as *delivering better software*. Teams under this pressure accept low-quality suggestions to hit the metric. This is exactly the SPACE-A misuse Forsgren warns against.

**What to do instead:** Track outcomes — DORA metrics, defect escape rate, SAST finding trend, time to review a PR. Acceptance rate is a leading indicator of engagement, not quality.

---

### AP-8: Letting Copilot suggest cross-service database queries (SoC violation)

**What it looks like:** While writing an NSO service callback, Copilot suggests querying the resource inventory database directly via SQLAlchemy because it has seen that pattern in adjacent open files.

**Why it's dangerous:** This couples the service orchestration layer directly to the resource inventory's data store, violating SoC and making both services harder to evolve independently. This is the architectural anti-pattern Hohpe and Newman specifically identify as a source of long-term integration pain.

**What to do instead:** Review completions for any import or database call that crosses a service boundary. If resource data is needed, call the TMF639 client (or the internal equivalent). Delete any Copilot-suggested cross-service DB query on sight.

---

## 8. Prompt Template Library Contributions

The team prompt library lives in [`docs/governance/team-norms.md`](../governance/team-norms.md#prompt-library). To contribute a new prompt: test it against at least 3 O&A code files, document the expected output quality, and submit a PR adding it to the library section.

The following seed templates are ready to add:

---

### Template 1: YANG module stub from requirements

```
Generate a YANG module stub with the following properties:
- Module name: {module-name}
- Namespace: urn:{org}:yang:{module-name}
- Prefix: {prefix}
- Imports: ietf-inet-types, ietf-yang-types
- Description: {description}
- Revision: {YYYY-MM-DD}
- Grouping "{grouping-name}" containing leaves: {leaf-list with types}
Include description statements on every node. Do not add must or when expressions —
I will add constraints manually after reviewing the RFC.
```

---

### Template 2: ncclient GET operation wrapper

```
Write a Python function using ncclient to perform a NETCONF get-config
operation with the following specification:
- Target: candidate datastore
- Subtree filter: {paste YANG path or XML snippet}
- Return type: list of dataclasses with fields {field-list}
- Error handling: catch SSHError, AuthenticationError, RPCError — re-raise with context
- Credentials: read from environment variables {ENV_VAR_USER} and {ENV_VAR_PASS}
- Do not hardcode any IP addresses, usernames, or passwords
Use lxml for XML parsing. Include type hints throughout.
```

---

### Template 3: pytest suite for a NETCONF operation

```
Write a pytest test suite for the function {function-name} in {module-path}.
Include the following test cases:
1. Happy path: mock ncclient manager.connect, return {valid XML fixture}, assert {expected dataclass}
2. Empty result: manager returns XML with no matching elements, assert empty list returned
3. Malformed XML: manager returns XML missing required element {element}, assert ValueError raised
4. SSHError: manager.connect raises SSHError, assert it propagates
5. AuthenticationError: manager.connect raises AuthenticationError, assert it propagates
Use unittest.mock.patch and MagicMock. Mock the context manager correctly
(__enter__ returns the mock nc object, __exit__ returns False).
Do not test against real devices.
```

---

### Template 4: Ansible role task list from requirements

```
Generate an Ansible task list for a role that:
- Configures {resource description} on {platform, e.g. Cisco IOS-XE}
- Uses module: {ansible module name}
- Is fully idempotent (include changed_when and failed_when on every task that needs them)
- Takes these variables from defaults/main.yml: {variable list with types and defaults}
- Notifies handler "{handler name}" when configuration changes
- Uses no_log: true on any task that handles credentials
- Does not hardcode any values that should be variables
After the tasks, generate the corresponding defaults/main.yml with documented variable descriptions.
```

---

### Template 5: TMF API client from OpenAPI spec

```
I have opened the TMF{number} {API-name} OpenAPI spec v{version} in an adjacent tab.

Generate a Python client class named TMF{number}Client with:
- __init__(self, base_url: str, token: str | None = None)
  — token falls back to environment variable {ENV_VAR_NAME}
- Method: {method_name}(self, **filters) -> list[{ResponseModel}]
  — calls GET {endpoint-path}
  — passes filters as query params
  — validates response with Pydantic model {ResponseModel}
  — raises httpx.HTTPStatusError on non-2xx responses
  — timeout: 10 seconds

Also generate the Pydantic model {ResponseModel} with fields matching
the TMF{number} {SchemaName} schema exactly — use Field(alias=...) for
camelCase to snake_case mapping. Do not rename fields without aliasing.
```

---

*Playbook maintained by the O&A team. Raise corrections or additions via PR against this file.  
Last updated: see git log.*
