#!/bin/bash
# Prompt code simplification after plan step completion
# Triggered by TaskCompleted hook
# Part of ross-claude-toolkit — requires code-simplifier plugin

echo '{"hookSpecificOutput":{"hookEventName":"TaskCompleted","additionalContext":"A plan step was just completed. If code was written or modified in this step, dispatch the code-simplifier agent (code-simplifier:code-simplifier) in the background to refine code clarity and consistency."}}'
