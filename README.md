# ross-claude-toolkit

Cross-project skills and agents for Claude Code. Includes systematic research workflows, adversarial plan review, documentation management, and more.

## Installation

```
/plugin install github:baltwross/ross-claude-toolkit
```

For global installation (available in all projects):

```
/plugin install --global github:rossbaltimore/ross-claude-toolkit
```

## What's Included

### Skills

| Skill | Description |
|-------|-------------|
| **research** | Systematic 9-step research workflow that produces documented findings in `docs/research/`. Includes codebase analysis, acceptance criteria, and structured recommendations. |

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

After installation, skills and agents are available automatically.

**Invoke the research skill:**
```
/research OAuth 2.0 libraries for Node.js
```

**Agents are used automatically** by Claude Code when their descriptions match the task at hand. For example, asking Claude to "review this plan for problems" will invoke the red-team-analyst agent.

## Optional MCP Server Dependencies

The research skill references these MCP tools. They are **not required** but enhance research capabilities if configured:

- `mcp__tavily__tavily_search` — Web search
- `mcp__context7__query-docs` — Library documentation lookup

## Updating

```
/plugin update baltwross/ross-claude-toolkit
```

## License

MIT
