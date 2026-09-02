#!/bin/bash
# Claude Code statusline — shows session info + one line per work item
input=$(cat)

MODEL=$(echo "$input" | jq -r '.model.display_name // "?"')
COST=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')
DURATION_MS=$(echo "$input" | jq -r '.cost.total_duration_ms // 0')
CONTEXT_PCT=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)

MINS=$((DURATION_MS / 60000))

# Line 1: session info
echo "[$MODEL] Ctx:${CONTEXT_PCT}% | \$$(printf '%.2f' "$COST") | ${MINS}m"

# Work status v2: source statusline from operating-system tools
WS_TOOLS="$HOME/autodesk/operating-system/work-status/tools"
if [ -f "$WS_TOOLS/statusline.sh" ]; then
  export WS_DIR="$HOME/autodesk/operating-system/work-status"
  # Generate fresh index first (run as subprocess to avoid set -euo leaking)
  bash "$WS_TOOLS/generate-index.sh" "$WS_DIR" >/dev/null 2>&1
  # Source dependencies and output statusline
  source "$WS_TOOLS/frontmatter.sh" 2>/dev/null
  source "$WS_TOOLS/focus.sh" 2>/dev/null
  source "$WS_TOOLS/statusline.sh" 2>/dev/null
  ws_statusline 2>/dev/null
fi

exit 0
