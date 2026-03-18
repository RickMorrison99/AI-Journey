# Skill: Generate NETCONF Python Client

**Skill name**: `netconf-client`
**Trigger phrases**: "netconf client", "ncclient code", "netconf python", "connect to device via netconf"

---

## What This Skill Does

Generates `ncclient`-based Python code with O&A safety patterns baked in. Every generated client is production-ready: context-managed connections, explicit error handling, environment-based credentials, type hints, and docstrings. No boilerplate shortcuts that create production incidents.

---

## Required Inputs

Before generating code, ask:

1. **Target operation**: `get-config`, `edit-config`, `commit`, `validate`, `lock/unlock`, or custom RPC?
2. **Device type**: IOS-XR, JunOS, EOS, Nokia SR OS, or vendor-agnostic?
3. **Filter path (for get-config)**: What YANG subtree or XPath filter? (e.g., `ietf-interfaces:interfaces/interface`)
4. **NOS version**: *Always ask this.* "What NOS version? YANG paths for the same feature differ between IOS-XR 7.x and 7.9, and between JunOS 21 and 23."
5. **Auth method**: password (environment variable) or SSH key (path from environment variable)?

---

## O&A NETCONF Safety Rules

Every generated client MUST follow these rules. These are not optional style preferences — they prevent production incidents.

| Rule | Rationale |
|------|-----------|
| Always use `with manager.connect(...) as m:` | Guarantees session teardown even on exception |
| Never hardcode credentials | Use `os.environ` — secrets go in vault, not source code |
| Always validate reply with `assert not reply.errors` | Silent error swallowing has caused O&A outages |
| Use `to_ele()` for XML construction | String-built XML breaks on special chars in leaf values |
| Handle `RPCError` explicitly | `ncclient` raises `RPCError` for lock conflicts, validation errors — must be caught |
| Use `manager.locked()` context manager for edit-config | Always lock the datastore, edit, commit, unlock atomically |
| Never use `edit-config` on running datastore directly | Edit candidate, validate, then commit — always |
| Log the session ID on connect | Critical for correlating device-side NETCONF logs during incidents |

---

## Output Format

Complete, runnable Python module with:
- `from __future__ import annotations` at the top
- Type hints on all function signatures
- Module-level docstring referencing the device type, NOS version, and YANG path
- `logging` setup (not `print()`)
- `RPCError` import and explicit handling
- A `main()` guard for standalone testing

---

## Example: Get-Config for Interface Subtree

**Trigger**: "netconf client to get interface config from IOS-XR 7.9"

```python
"""
NETCONF get-config client — IOS-XR 7.9, ietf-interfaces subtree.

NOS: Cisco IOS-XR 7.9.x
YANG path: ietf-interfaces:interfaces/interface
Auth: password from NETCONF_PASSWORD environment variable

O&A Safety patterns applied:
  - Context-managed session (no leaked sockets)
  - Environment-variable credentials only
  - Explicit RPCError handling
  - to_ele() for XML filter construction
  - Reply error assertion before processing
"""
from __future__ import annotations

import logging
import os
from typing import Optional

from lxml import etree
from ncclient import manager
from ncclient.operations import RPCError
from ncclient.xml_ import to_ele

logger = logging.getLogger(__name__)

NETCONF_PORT = 830
NETCONF_TIMEOUT = 60


def get_interface_config(
    host: str,
    interface_name: Optional[str] = None,
) -> etree._Element:
    """
    Retrieve interface configuration from a device via NETCONF get-config.

    Args:
        host: Device hostname or management IP.
        interface_name: Optional interface name to filter on.
                        If None, retrieves all interfaces.

    Returns:
        lxml Element containing the <interfaces> subtree from running config.

    Raises:
        RPCError: On NETCONF RPC-level errors (lock conflict, invalid path, etc.)
        EnvironmentError: If required environment variables are not set.
    """
    username = os.environ.get("NETCONF_USERNAME")
    password = os.environ.get("NETCONF_PASSWORD")

    if not username or not password:
        raise EnvironmentError(
            "NETCONF_USERNAME and NETCONF_PASSWORD must be set as environment variables. "
            "Do not hardcode credentials — store them in your secrets vault."
        )

    # Build subtree filter
    if interface_name:
        filter_xml = to_ele(
            f"""<filter type="subtree">
              <interfaces xmlns="urn:ietf:params:xml:ns:yang:ietf-interfaces">
                <interface>
                  <name>{interface_name}</name>
                </interface>
              </interfaces>
            </filter>"""
        )
    else:
        filter_xml = to_ele(
            """<filter type="subtree">
              <interfaces xmlns="urn:ietf:params:xml:ns:yang:ietf-interfaces"/>
            </filter>"""
        )

    with manager.connect(
        host=host,
        port=NETCONF_PORT,
        username=username,
        password=password,
        timeout=NETCONF_TIMEOUT,
        hostkey_verify=True,          # Never disable in production
        device_params={"name": "iosxr"},
    ) as conn:
        logger.info("NETCONF session established: session-id=%s host=%s", conn.session_id, host)

        try:
            reply = conn.get_config(source="running", filter=filter_xml)
        except RPCError as exc:
            logger.error("NETCONF RPC error from %s: %s", host, exc)
            raise

        assert not reply.errors, (
            f"NETCONF reply contained errors from {host}: {reply.errors}"
        )

        logger.info("get-config succeeded: session-id=%s", conn.session_id)
        return reply.data_ele


if __name__ == "__main__":
    logging.basicConfig(level=logging.INFO)
    result = get_interface_config(host="192.0.2.1", interface_name="GigabitEthernet0/0/0/0")
    print(etree.tostring(result, pretty_print=True).decode())
```

---

## Post-Generation Reminders

1. **NOS version matters**: if targeting JunOS, change `device_params={"name": "junos"}` and verify YANG namespace
2. **hostkey_verify**: never set to `False` in production — add the device SSH host key to your known_hosts or pass `known_hosts` parameter
3. **Credentials**: store in HashiCorp Vault or equivalent; inject via environment at runtime
4. **pyang validate**: if you are constructing the XML filter from a YANG path, validate the path against the NOS YANG model first
