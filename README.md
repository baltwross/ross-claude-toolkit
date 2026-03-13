# ross-claude-toolkit

Cross-project skills and agents for Claude Code. Includes systematic research workflows, adversarial plan review, documentation management, and more.

## Installation

**Step 1: Add the marketplace**
```
/plugin marketplace add baltwross/ross-claude-toolkit
```

**Step 2: Install the plugin**
```
/plugin install ross-claude-toolkit@ross-claude-toolkit
```

## What's Included

### Skills

| Skill | Description |
|-------|-------------|
| **research** | Systematic 9-step research workflow that produces documented findings in `docs/research/`. Includes codebase analysis, acceptance criteria, and structured recommendations. |
| **red-team-loop** | Iterative plan-hardening loop: Red Team Analyst critiques a plan, main thread evaluates findings with evidence, revises where warranted, and repeats until solid. Use after `/research` or any planning phase. |

### Agents

| Agent | Description |
|-------|-------------|
| **claude-code-optimizer** | Analyzes and optimizes Claude Code setup, configuration, hooks, and agentic coding workflows. |
| **conversational-insights** | Captures key insights from conversation threads and produces structured documentation in `docs/conversational-insights/`. |
| **docs-manager** | Creates, updates, audits, and maintains all project documentation. Analysis-first workflow with self-verification. |
| **red-team-analyst** | Adversarial review of plans, proposals, and implementation strategies. Finds logical errors, missed edge cases, and flawed assumptions before implementation. |
| **research-conductor** | Expert research analysis on topics, concepts, technologies, and questions. Pairs with the research skill for `/research` invocations. |
| **skills-architect** | Creates and organizes Claude Skills configurations following Anthropic's official patterns and documentation. |
| **tech-research-analyst** | In-depth technical research on frameworks, tools, SDKs, and APIs. Produces structured research briefs and technology comparisons. |

## Usage

### Agents

Agents are used **automatically** by Claude Code when their descriptions match the task at hand. For example, asking Claude to "review this plan for problems" will invoke the red-team-analyst agent. You can also invoke them explicitly by @mentioning them (e.g., `@red-team-analyst`).

### Skills

Skills must be copied to a location where Claude Code can discover them for `/slash-command` invocation.

**Option A: Personal skills directory** (available in all projects):
```bash
cp -r skills/<skill-name> ~/.claude/skills/<skill-name>
```

**Option B: Project skills directory** (available only in that project):
```bash
cp -r skills/<skill-name> <your-project>/.claude/skills/<skill-name>
```

Then invoke with:
```
/research OAuth 2.0 libraries for Node.js
/red-team-loop docs/research/my-plan.md
```

> **Note:** Plugin-namespaced invocation (e.g., `/ross-claude-toolkit:research`) is not currently supported. Skills must be copied to a personal or project skills directory to be invocable via `/slash-command`.

## Optional MCP Server Dependencies

The research skill references these MCP tools. They are **not required** but enhance research capabilities if configured:

- `mcp__tavily__tavily_search` — Web search
- `mcp__context7__query-docs` — Library documentation lookup

## Updating

```
/plugin update ross-claude-toolkit@ross-claude-toolkit
```

## License

MIT
