---
name: red-team-loop
description: Iterative plan-hardening loop that alternates between Red Team Analyst critique and main-thread evaluation/revision. Use when you have a plan, proposal, or research document that needs adversarial stress-testing with iterative refinement. Invoked after /research or any planning phase. The main thread critically evaluates RTA findings (not blindly accepting them) and revises the plan only where warranted.
---

# Red Team Loop

## Overview

An adversarial feedback loop that hardens plans through iterative critique and revision. The Red Team Analyst (RTA) attacks the plan; the main thread evaluates those attacks with evidence and updates the plan where warranted. Repeat until the plan is solid.

**Core principle:** The RTA is a valuable adversary, not an authority. Its findings are hypotheses that must be verified before acting on them. Blindly accepting RTA feedback is as dangerous as ignoring it.

## When to Use

- After `/research` produces a plan or recommendation
- After drafting an implementation plan, architecture proposal, or migration strategy
- When a plan exists as a document (in `docs/research/`, `docs/plans/`, or conversation context)
- When the user says "red-team loop", "harden this plan", "stress-test this", or "iterate with RTA"

## Prerequisites

- A plan document or proposal must already exist (file path or in conversation context)
- The `red-team-analyst` agent must be available

## The Loop

```
              +------------------+
              |   Plan exists    |
              +--------+---------+
                       |
                       v
            +----------+----------+
            |  Spawn RTA agent    |
            |  to critique plan   |
            +----------+----------+
                       |
                       v
            +----------+----------+
            | Main thread triages |
            | RTA findings with   |
            | evidence & reasoning|
            +----------+----------+
                       |
              +--------+---------+
              | Any valid issues |
              | to address?      |
              +--+------------+--+
                 |            |
              yes|            |no
                 v            v
         +-------+------+  +-+----------+
         | Revise plan  |  | DONE:      |
         | Document why |  | Plan is    |
         +-------+------+  | hardened   |
                 |          +------------+
                 v
         +-------+------+
         | Max iters    |
         | reached?     |
         +--+--------+--+
            |        |
         yes|        |no
            v        v
    +-------+--+  Loop back to
    | DONE:    |  "Spawn RTA"
    | Summarize|
    +----------+
```

### Maximum Iterations

- **Default:** 3 iterations
- **Hard cap:** 5 iterations (even if user requests more)
- If the plan still has CRITICAL issues after max iterations, stop and surface the unresolved issues to the user for manual intervention

## Detailed Steps

### Step 0: Identify the Plan

Locate the plan to be hardened. Ask the user if ambiguous.

```
Inputs needed:
- Plan location: file path (e.g., docs/research/auth-comparison.md) OR "in conversation context"
- Focus areas (optional): specific sections or concerns to prioritize
- Max iterations (optional): 1-5, default 3
```

### Step 1: Spawn Red Team Analyst

Launch the `red-team-analyst` agent with the plan content. The prompt to the RTA must include:

1. The full plan content (read the file or reference conversation context)
2. Any focus areas the user specified
3. The iteration number (so RTA knows if this is a fresh review or re-review)

**For iteration 2+**, also include:
- The changelog from the previous iteration (what was changed and why)
- Which of the RTA's previous findings were rejected, and why — so it doesn't re-raise dismissed concerns

**RTA prompt template:**

```
Review this plan. This is iteration {N} of the red-team loop.

## Plan
{plan content or file reference}

{If iteration > 1:}
## Previous Iteration Context
### Changes made based on your last review:
{changelog}

### Findings from your last review that were evaluated and intentionally not addressed:
{dismissed findings with reasoning}

Focus your review on NEW issues or issues that the revisions may have introduced.
Do NOT re-raise findings that were already evaluated and dismissed with reasoning.
```

### Step 2: Triage RTA Findings

**This is the critical step. Do NOT skip or rush this.**

For EACH finding the RTA produces, the main thread must:

1. **Verify the claim.** Is the RTA's assertion factually correct? Check the actual code, documentation, or API behavior. The RTA sometimes hallucinates issues or misunderstands existing patterns.

2. **Assess the evidence.** Does the RTA provide specific file paths, line numbers, or documentation references? Vague findings ("this might be a problem") with no evidence get lower credibility.

3. **Classify your response** to each finding:

| Classification | Meaning | Action |
|---------------|---------|--------|
| **ACCEPT** | Finding is valid and important | Revise the plan |
| **ACCEPT (MODIFIED)** | Core concern is valid but solution differs | Revise with your own approach |
| **ACKNOWLEDGE** | Valid concern but out of scope or low priority | Note in plan as known limitation |
| **DISMISS** | Finding is incorrect, based on wrong assumptions, or not applicable | Document why with evidence |

4. **Document your reasoning** for each classification. One sentence minimum. This prevents rubber-stamping in either direction.

**Triage output format (document in conversation):**

```markdown
## Iteration {N} Triage

### Accepted
- [CRITICAL] {Finding summary}: {Why it's valid, what you'll change}
- [HIGH] {Finding summary}: {Why it's valid, what you'll change}

### Accepted (Modified)
- [MEDIUM] {Finding summary}: {Core concern valid, but doing X instead of RTA's suggestion because Y}

### Acknowledged
- [LOW] {Finding summary}: {Valid but out of scope / deferred because Z}

### Dismissed
- [MEDIUM] {Finding summary}: {Why this is incorrect — with evidence}
- [LOW] {Finding summary}: {Why this doesn't apply — with evidence}

**Verdict: {N} accepted, {N} modified, {N} acknowledged, {N} dismissed out of {total} findings**
```

### Step 3: Revise the Plan

For each ACCEPT and ACCEPT (MODIFIED) finding:

1. Make the specific revision to the plan document
2. Record the change in the iteration changelog

**Changelog format (append to plan document or keep in conversation):**

```markdown
## Red Team Loop Changelog

### Iteration {N} — {date}
**RTA Verdict:** {BLOCK/REVISE/CONDITIONAL PASS/PASS}
**Triage:** {N} accepted, {N} modified, {N} acknowledged, {N} dismissed

Changes:
- {Section X}: {What changed and why}
- {Section Y}: {What changed and why}

Dismissed findings:
- {Finding}: {Why dismissed}
```

### Step 4: Loop or Exit

**Exit conditions (ANY of these):**
- RTA verdict is **PASS** or **CONDITIONAL PASS** with no CRITICAL/HIGH issues remaining
- Main thread triage results in **zero ACCEPT** findings (all dismissed or acknowledged) — the plan is already solid against the RTA's attacks
- **Max iterations reached** — summarize status and surface any unresolved concerns

**Continue condition:**
- There were ACCEPT findings, revisions were made, and iterations remain

If continuing, go back to Step 1 with the updated plan.

### Step 5: Final Summary

When the loop exits, produce a summary:

```markdown
## Red Team Loop Complete

**Iterations:** {N}
**Final RTA Verdict:** {verdict}

### What Changed
{Bullet list of all revisions across all iterations}

### Known Limitations
{Any ACKNOWLEDGE findings — valid concerns noted but not addressed}

### Dismissed Concerns
{Any findings dismissed across all iterations, with reasoning}

### Confidence Assessment
{Your honest assessment of plan quality after hardening}
```

If the plan lives in a file, append the Red Team Loop summary to the document.

## Anti-Patterns

| Anti-Pattern | Why It's Wrong | What to Do Instead |
|-------------|---------------|-------------------|
| Accepting all RTA findings | RTA hallucinates issues; blind acceptance degrades plans | Verify each finding against actual code/docs |
| Dismissing all RTA findings | Defeats the purpose of the loop | Each dismissal needs documented evidence |
| Skipping triage | Creates a rubber-stamp process | Triage is the most important step |
| Running 5+ iterations | Diminishing returns; indicates deeper problems | Stop at 3-5, escalate unresolved issues to user |
| Not documenting dismissed findings | RTA will re-raise them next iteration | Document dismissals so RTA can focus on new issues |
| Changing the plan without changelog | Loses audit trail of what improved and why | Always record what changed and why |
| Letting RTA re-litigate dismissed findings | Wastes iterations on settled questions | Include dismissed findings in RTA context |

## Red Flags — STOP and Reconsider

| Thought | Reality |
|---------|---------|
| "The RTA is always right" | It hallucinates. Verify everything. |
| "The RTA is always wrong" | It finds real issues. Evaluate honestly. |
| "I'll accept everything to finish faster" | You're degrading the plan, not improving it. |
| "I'll dismiss everything to finish faster" | You're wasting the loop. Cancel it instead. |
| "One iteration is enough" | Maybe, but only if triage shows zero accepted findings. |
| "The plan was fine before" | Then the loop will confirm that. Trust the process. |
| "This finding seems wrong but I'm not sure" | Investigate. Uncertainty means you need evidence either way. |

## Checklist

Use TodoWrite to track progress. Create one todo per active iteration.

- [ ] Step 0: Plan identified (file path or conversation reference)
- [ ] Step 1: RTA agent spawned with plan content and iteration context
- [ ] Step 2: Every RTA finding triaged with classification and reasoning
- [ ] Step 3: Plan revised for all ACCEPT/ACCEPT (MODIFIED) findings
- [ ] Step 4: Exit condition evaluated; loop or summarize
- [ ] Step 5: Final summary produced with changelog, known limitations, and confidence assessment
