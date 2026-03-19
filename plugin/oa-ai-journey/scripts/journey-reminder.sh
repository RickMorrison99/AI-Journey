#!/usr/bin/env bash
# journey-reminder.sh — O&A AI Journey post-checkout stage reminder
# Reads ~/.oa-journey-stage (contains a number 1-5) and prints:
#   1. The team's current Beck 3X phase and guidance
#   2. A random principle from the 21 O&A engineering principles
# If no stage file exists, prompts the user to run the adoption-check skill.

set -uo pipefail

STAGE_FILE="$HOME/.oa-journey-stage"

# 21 O&A Engineering Principles (array index 0-20)
PRINCIPLES=(
  "Principle 1: Deployment pipeline is the only path to production — no manual deployments, no exceptions."
  "Principle 2: Fast feedback loops at every stage — fail fast, learn fast."
  "Principle 3: Test behaviour not implementation — test observable outcomes, not internal structure."
  "Principle 4: Trunk-based development with short-lived branches — branches live hours, not weeks."
  "Principle 5: Architecture enables, not constrains — loosely coupled, highly cohesive."
  "Principle 6: Manage cognitive load as a first-class concern — reduce friction for engineers."
  "Principle 7: Measure what matters — avoid vanity metrics. Use DORA, SPACE, SCI."
  "Principle 8: DRY — Don't Repeat Yourself. Single source of truth for models, configs, contracts."
  "Principle 9: SoC — Separation of Concerns. Decouple intent (spec) from implementation (code)."
  "Principle 10: API-first — design contracts before implementations. OpenAPI/AsyncAPI before code."
  "Principle 11: Spec-before-code — consume TM Forum specs before writing. Check TMF Open APIs first."
  "Principle 12: Model-driven where possible (YANG, OpenAPI, AsyncAPI) — generate from models, not by hand."
  "Principle 13: AI assists, humans decide — all AI output requires human review before action."
  "Principle 14: AI output is a draft, not a deliverable — treat generated code as a starting point."
  "Principle 15: Safety boundaries are non-negotiable — agentic workflows must have explicit scope limits."
  "Principle 16: Never train on production secrets — credentials, topology, CDB snapshots are off-limits."
  "Principle 17: Sanitise all prompts before sending to external models — strip device IPs and credentials."
  "Principle 18: Measure AI productivity with SPACE, not activity metrics alone — never show Activity in isolation."
  "Principle 19: Every agentic workflow requires an ADR — including a Shostack STRIDE threat model."
  "Principle 20: SCI — track and reduce AI energy consumption. Software Carbon Intensity applies to inference."
  "Principle 21: Vendor diversity — avoid single-vendor lock-in. Maintain model interoperability."
  "Principle 22: Test-Driven Development (TDD) — write a failing test before writing implementation code. Red-Green-Refactor."
)

# Pick a random principle
RANDOM_INDEX=$(( RANDOM % 22 ))
TODAY_PRINCIPLE="${PRINCIPLES[$RANDOM_INDEX]}"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  O&A AI Journey — Daily Reminder"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [[ ! -f "$STAGE_FILE" ]]; then
  echo ""
  echo "⚠️  No adoption stage set."
  echo "   Run the 'adoption-check' skill to assess your team's current stage."
  echo "   Then: echo '2' > ~/.oa-journey-stage  (replace 2 with your stage)"
  echo ""
  echo "💡 Today's Principle:"
  echo "   $TODAY_PRINCIPLE"
  echo ""
  exit 0
fi

STAGE=$(cat "$STAGE_FILE" | tr -d '[:space:]')

case "$STAGE" in
  1|2)
    echo ""
    echo "🔬 Stage $STAGE — Explore Mode (Kent Beck 3X)"
    echo "   Tolerate waste. Maximise learning. Run experiments."
    echo "   Do NOT standardise yet — you don't know what works."
    echo "   The cost of premature standardisation exceeds the cost of inconsistency."
    ;;
  3|4)
    echo ""
    echo "📈 Stage $STAGE — Expand Mode (Kent Beck 3X)"
    echo "   Standardise what works. Reduce variance. Invest in the platform."
    echo "   Kill experiments that haven't proven value."
    echo "   DORA + SPACE baseline should be established this quarter."
    ;;
  5)
    echo ""
    echo "⚙️  Stage 5 — Extract Mode (Kent Beck 3X)"
    echo "   Automate what is standardised. Measure ROI explicitly. Track SCI."
    echo "   Open-source what gives you no competitive advantage."
    ;;
  *)
    echo ""
    echo "⚠️  Unknown stage '$STAGE' in $STAGE_FILE. Expected 1–5."
    echo "   Run the 'adoption-check' skill to reassess."
    ;;
esac

echo ""
echo "💡 Today's Principle:"
echo "   $TODAY_PRINCIPLE"
echo ""
echo "📖 Full framework: https://github.com/RickMorrison99/AI-Journey"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

exit 0
