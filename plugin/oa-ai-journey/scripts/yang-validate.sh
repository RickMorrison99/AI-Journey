#!/usr/bin/env bash
# yang-validate.sh — O&A AI Journey YANG validation hook
# Runs pyang --lint on all staged .yang files.
# Non-blocking (exits 0 regardless) — informational only.
# Install pyang: pip install pyang

set -uo pipefail

# Check pyang is available — skip gracefully if not installed
if ! command -v pyang &>/dev/null; then
  echo "ℹ️  pyang not found — skipping YANG lint. Install with: pip install pyang"
  exit 0
fi

STAGED_YANG=$(git diff --cached --name-only 2>/dev/null | grep '\.yang$' || true)

if [[ -z "$STAGED_YANG" ]]; then
  exit 0
fi

echo "🔍 Running pyang --lint on staged YANG files..."
ERRORS=0

for YANG_FILE in $STAGED_YANG; do
  [[ ! -f "$YANG_FILE" ]] && continue

  OUTPUT=$(pyang --lint "$YANG_FILE" 2>&1 || true)
  if [[ -n "$OUTPUT" ]]; then
    echo "⚠️  pyang warnings/errors in $YANG_FILE:"
    echo "$OUTPUT" | sed 's/^/   /'
    ERRORS=$((ERRORS + 1))
  else
    echo "✅ $YANG_FILE — lint clean"
  fi
done

if [[ "$ERRORS" -gt 0 ]]; then
  echo ""
  echo "ℹ️  $ERRORS YANG file(s) have lint issues. Review before merging."
  echo "   This hook is non-blocking — commit proceeds. Fix issues in a follow-up."
fi

exit 0
