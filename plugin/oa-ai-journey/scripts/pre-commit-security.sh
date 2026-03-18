#!/usr/bin/env bash
# pre-commit-security.sh — O&A AI Journey pre-commit security gate
# Checks staged files for credentials, NSO CDB references, and real device IPs.
# Exits 1 if any violations found (blocking commit). Exits 0 if clean.

set -euo pipefail

VIOLATIONS=0
STAGED_FILES=$(git diff --cached --name-only 2>/dev/null || true)

if [[ -z "$STAGED_FILES" ]]; then
  exit 0
fi

check_pattern() {
  local label="$1"
  local pattern="$2"
  local file="$3"
  local matches
  matches=$(grep -inP "$pattern" "$file" 2>/dev/null || true)
  if [[ -n "$matches" ]]; then
    echo "❌ [$label] in $file:"
    while IFS= read -r line; do
      echo "   $line"
    done <<< "$matches"
    VIOLATIONS=$((VIOLATIONS + 1))
  fi
}

for FILE in $STAGED_FILES; do
  # Skip deleted files
  [[ ! -f "$FILE" ]] && continue

  # 1. Hardcoded passwords / secrets
  check_pattern "HARDCODED-SECRET" \
    'password\s*=\s*["\x27][^"\x27]{3,}["\x27]' \
    "$FILE"

  # 2. NSO CDB raw paths in Python or YAML (should use ncclient/MAAPI)
  if [[ "$FILE" =~ \.(py|yaml|yml)$ ]]; then
    check_pattern "NSO-CDB-RAW-PATH" \
      '/ncs:devices/device' \
      "$FILE"
  fi

  # 3. Real device IP ranges in non-test files
  # Allowed documentation ranges (RFC 5737): 192.0.2.x, 198.51.100.x, 203.0.113.x
  if [[ ! "$FILE" =~ (test_|_test\.|spec\.|/tests/) ]]; then
    # 10.x.x.x
    check_pattern "REAL-DEVICE-IP-RFC1918-10" \
      '\b10\.\d{1,3}\.\d{1,3}\.\d{1,3}\b' \
      "$FILE"
    # 172.16-31.x.x
    check_pattern "REAL-DEVICE-IP-RFC1918-172" \
      '\b172\.(1[6-9]|2\d|3[01])\.\d{1,3}\.\d{1,3}\b' \
      "$FILE"
    # 192.168.x.x (but NOT 192.0.2.x which is RFC 5737 doc range)
    check_pattern "REAL-DEVICE-IP-RFC1918-192" \
      '\b192\.168\.\d{1,3}\.\d{1,3}\b' \
      "$FILE"
  fi

  # 4. YANG credentials — username with literal value
  if [[ "$FILE" =~ \.yang$ ]]; then
    check_pattern "YANG-CREDENTIAL-USERNAME" \
      'username\s+["\x27][^"\x27]+["\x27]' \
      "$FILE"
  fi

done

if [[ "$VIOLATIONS" -gt 0 ]]; then
  echo ""
  echo "🚫 O&A Security Check FAILED: $VIOLATIONS violation(s) found."
  echo "   Fix the issues above before committing."
  echo "   For test files, use RFC 5737 documentation IPs: 192.0.2.x, 198.51.100.x, 203.0.113.x"
  echo "   Credentials must use environment variables or vault injection, never literals."
  exit 1
fi

echo "✅ O&A Security Check passed."
exit 0
