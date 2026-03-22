#!/bin/bash
# Detect git commits and prompt code simplification via additionalContext
# Triggered by PostToolUse on Bash
# Part of ross-claude-toolkit — requires code-simplifier plugin

set -e

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // ""' 2>/dev/null || echo "")

# Only trigger on git commit commands
if [[ ! "$COMMAND" =~ ^git\ commit ]]; then
  exit 0
fi

# Skip if this is already a simplification follow-up commit
if [[ "$COMMAND" =~ "refactor: simplify" ]] || [[ "$COMMAND" =~ "style: simplify" ]]; then
  exit 0
fi

cat <<'EOF'
{
  "hookSpecificOutput": {
    "hookEventName": "PostToolUse",
    "additionalContext": "A git commit was just created. Dispatch the code-simplifier agent (code-simplifier:code-simplifier) in the background on the files that were just committed to ensure code clarity and consistency. If simplification produces meaningful changes, stage and commit them as a follow-up 'refactor: simplify' commit."
  }
}
EOF
