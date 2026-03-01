---
name: model-api-parameter-reference
description: Use when writing code that calls AI model APIs (OpenAI, Anthropic, Google), configuring model parameters, debugging API errors (400 errors, unsupported parameters), or needing to know which parameters a specific model supports. Reference this for exact parameter names, valid values, feature support matrices, and common gotchas.
---

# Model API Parameter Reference

_Status: February 28, 2026_

A vendor-agnostic reference covering API parameters, supported controls per model, pricing quick-reference tables, and practical gotchas for frontier models from OpenAI, Anthropic, and Google DeepMind.

---

## Table of Contents

1. [OpenAI API Parameters](#1-openai-api-parameters)
2. [Anthropic API Parameters](#2-anthropic-api-parameters)
3. [Google Gemini API Parameters](#3-google-gemini-api-parameters)
4. [Parameter Support Matrix](#4-parameter-support-matrix)
5. [Reasoning / Thinking Controls](#5-reasoning--thinking-controls)
6. [Pricing Quick Reference](#6-pricing-quick-reference)
7. [Practical Gotchas](#7-practical-gotchas)

---

## 1. OpenAI API Parameters

### 1.1 APIs Available

OpenAI offers two primary HTTP APIs for text generation:

| API | Endpoint | Notes |
|-----|----------|-------|
| **Responses API** | `POST /v1/responses` | Newer API, supports all models including Pro. Preferred for new development. |
| **Chat Completions API** | `POST /v1/chat/completions` | Legacy but widely supported. GPT-5.2 Pro is NOT available here. |
| **Realtime API** | WebSocket | For `gpt-realtime-*` models only. Not HTTP-based. |

### 1.2 Core Parameters

#### Sampling Parameters

| Parameter | Type | Description | Models That Support It |
|-----------|------|-------------|----------------------|
| `temperature` | float (0-2) | Controls randomness | **None of the GPT-5.x reasoning models** -- returns 400 error |
| `top_p` | float (0-1) | Nucleus sampling | **None of the GPT-5.x reasoning models** -- returns 400 error |
| `max_output_tokens` | int | Maximum output tokens | `gpt-5.2-chat-latest` only. Other reasoning models reject this. |

**Important:** All GPT-5.x reasoning models (GPT-5.2, 5.2 Codex, 5.2 Pro, 5.3 Codex, 5-Mini, 5-Nano) reject `temperature` and `top_p` with a 400 "Unsupported parameter" error. This is a fundamental constraint of reasoning models.

#### Reasoning Parameters (Responses API)

| Parameter | Type | Description |
|-----------|------|-------------|
| `reasoning.effort` | string | Controls depth of internal reasoning |
| `reasoning.summary` | string | Controls whether reasoning steps are summarized |

**Valid `reasoning.effort` values by model:**

| Model | Valid Values | Default |
|-------|-------------|---------|
| GPT-5.2 / 5.2-2025-12-11 | `none`, `low`, `medium`, `high`, `xhigh` | `medium` |
| GPT-5.2 Codex | `low`, `medium`, `high`, `xhigh` | `medium` |
| GPT-5.2 Pro | `medium`, `high`, `xhigh` | `high` |
| GPT-5.3 Codex | `low`, `medium`, `high`, `xhigh` | `medium` |
| GPT-5.1 | `low`, `medium`, `high` | `medium` |
| GPT-5.1 Codex Mini | `low`, `medium`, `high` | `medium` |
| GPT-5.1 Codex Max | `low`, `medium`, `high`, `xhigh` | `medium` |
| GPT-5 Mini | `minimal`, `low`, `medium`, `high` | `medium` |
| GPT-5 Nano | `minimal`, `low`, `medium`, `high` | `medium` |
| GPT-5.2 Chat Latest | **Not supported** | -- |

**Valid `reasoning.summary` values:** `auto`, `concise`, `detailed`

**Models that support `reasoning.summary`:**
- GPT-5.2 (all variants except Codex)
- GPT-5.2 Pro
- GPT-5 Mini, GPT-5 Nano
- GPT-5.1 (all non-Codex variants)

**Models that do NOT support `reasoning.summary`:**
- GPT-5.2 Codex, GPT-5.3 Codex
- GPT-5.1 Codex Mini, GPT-5.1 Codex, GPT-5.1 Codex Max

#### Output Control

| Parameter | Type | Description |
|-----------|------|-------------|
| `text.verbosity` | string | Controls output detail level (Responses API) |
| `verbosity` | string | Same parameter in LangChain kwargs |

**Valid `verbosity` values:** `low`, `medium`, `high`

**Models that support verbosity:**
- GPT-5.2 (Thinking variant), GPT-5.2-2025-12-11
- GPT-5.2 Pro
- GPT-5 Mini, GPT-5 Nano
- GPT-5.1, GPT-5.1 Chat Latest

**Models that do NOT support verbosity:**
- GPT-5.2 Chat Latest
- GPT-5.2 Codex, GPT-5.3 Codex
- GPT-5.1 Codex variants

#### Structured Outputs

| Parameter | Type | Description |
|-----------|------|-------------|
| `text_format` | object | Schema for structured outputs via `responses.parse()` |

**Models that support `responses.parse()`:**
- GPT-5.2 (Thinking), GPT-5.2-2025-12-11
- GPT-5.2 Codex, GPT-5.3 Codex
- GPT-5.1 Codex Mini, GPT-5.1 Codex, GPT-5.1 Codex Max
- GPT-5 Mini, GPT-5 Nano

**Models that do NOT support `responses.parse()`:**
- GPT-5.2 Chat Latest (requires `json_object` mode instead)
- GPT-5.2 Pro

### 1.3 Feature Support Summary Table

| Model | Temp | TopP | MaxTokens | Effort | Summary | Verbosity | Structured Parse |
|-------|------|------|-----------|--------|---------|-----------|------------------|
| gpt-5.2 | No | No | No | none-xhigh | Yes | Yes | Yes |
| gpt-5.2-chat-latest | No | No | Yes | No | Yes | No | No |
| gpt-5.2-2025-12-11 | No | No | No | none-xhigh | Yes | Yes | Yes |
| gpt-5.2-codex | No | No | No | low-xhigh | No | No | Yes |
| gpt-5.2-pro | No | No | No | medium-xhigh | Yes | Yes | No |
| gpt-5.3-codex | No | No | No | low-xhigh | No | No | Yes |
| gpt-5-mini | No | No | No | minimal-high | Yes | Yes | Yes |
| gpt-5-nano | No | No | No | minimal-high | Yes | Yes | Yes |
| gpt-5.1 | No | No | No | low-high | Yes | Yes | Yes |
| gpt-5.1-codex-mini | No | No | No | low-high | No | No | Yes |
| gpt-realtime-* | N/A | N/A | N/A | N/A | N/A | N/A | N/A |

### 1.4 Prompt Caching (OpenAI)

| Property | Value |
|----------|-------|
| **Retention** | 24 hours |
| **Discount** | 90% off input tokens (cached input = 0.1x base price) |
| **Activation** | Automatic for repeated prefixes |
| **Minimum** | System prompt + prefix must match exactly |

---

## 2. Anthropic API Parameters

### 2.1 API Endpoint

Anthropic uses the Messages API:

| API | Endpoint | Notes |
|-----|----------|-------|
| **Messages API** | `POST /v1/messages` | Primary API for all Claude models |
| **Batch API** | `POST /v1/messages/batches` | Asynchronous, 50% discount |

### 2.2 Core Parameters

#### Sampling Parameters

| Parameter | Type | Description | Models |
|-----------|------|-------------|--------|
| `temperature` | float (0-1) | Controls randomness | All Claude models (when thinking is off) |
| `top_p` | float (0-1) | Nucleus sampling | All Claude models (when thinking is off) |
| `top_k` | int | Top-K sampling | All Claude models (when thinking is off) |
| `max_tokens` | int (required) | Maximum output tokens | All Claude models |

**Important:** When extended thinking or adaptive thinking is enabled, `temperature`, `top_p`, and `top_k` are not supported and will return an error.

#### Thinking / Reasoning Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `thinking.type` | string | `"adaptive"` (recommended for 4.6) or `"enabled"` (deprecated on 4.6) |
| `thinking.budget_tokens` | int | Max thinking tokens (deprecated on 4.6, use with `type: "enabled"`) |

**Effort Parameter:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `effort` | string | Controls thinking depth |

**Valid `effort` values:**

| Model | Valid Values | Default | Notes |
|-------|-------------|---------|-------|
| Claude Opus 4.6 | `low`, `medium`, `high`, `max` | `high` | `max` is exclusive to Opus 4.6 |
| Claude Sonnet 4.6 | `low`, `medium`, `high` | `high` | First Sonnet with effort control |
| Claude Opus 4.5 | `low`, `medium`, `high` | `high` | |
| Claude Sonnet 4.5 | Not supported | -- | |
| Claude Haiku 4.5 | Not supported (uses budget_tokens) | -- | |

**Effort behavior:**

- `low`: Optimizes for speed and cost. May skip thinking for simple tasks.
- `medium`: Balanced. Recommended for most Sonnet 4.6 use cases.
- `high` (default): Best quality. Claude almost always uses extended thinking.
- `max` (Opus 4.6 only): Always thinks, no depth constraints.

#### Structured Outputs

| Parameter | Type | Description |
|-----------|------|-------------|
| `output_config.format` | object | Schema for structured JSON outputs |

**Note:** The older `output_format` parameter is deprecated on Claude 4.6 models. Use `output_config.format` instead.

#### Data Residency

| Parameter | Type | Description |
|-----------|------|-------------|
| `inference_geo` | string | `"global"` (default) or `"us"` |

US-only inference adds a 1.1x pricing multiplier on Opus 4.6 and newer models.

#### Speed Control

| Parameter | Type | Description |
|-----------|------|-------------|
| `speed` | string | `"fast"` for fast mode (research preview, Opus 4.6 only) |

Requires beta header: `betas=["fast-mode-2026-02-01"]`

### 2.3 Tool Use Parameters

| Tool | Tool Name | Additional Input Tokens | Pricing |
|------|-----------|------------------------|---------|
| Web Search | `web_search_20260209` | 346 tokens (auto/none) | $10 per 1,000 searches |
| Web Fetch | `web_fetch_20260209` | 346 tokens | Free (token costs only) |
| Code Execution | `code_execution` | -- | Free with web tools; $0.05/hr standalone |
| Text Editor | `text_editor_20250429` | 700 tokens | Standard token pricing |
| Computer Use | `computer_20250429` | 735 tokens | Standard token pricing |
| Bash | `bash_20250429` | 245 tokens | Standard token pricing |
| Memory | `memory` | -- | Standard token pricing |

### 2.4 Prompt Caching (Anthropic)

| Property | 5-Minute Cache | 1-Hour Cache |
|----------|---------------|--------------|
| **Write Cost** | 1.25x base input price | 2x base input price |
| **Read Cost** | 0.1x base input price | 0.1x base input price |
| **Retention** | 5 minutes | 1 hour |

### 2.5 Feature Support Summary Table

| Model | Temp | TopP | MaxTokens | Effort | Adaptive Thinking | Budget Tokens | Structured | Batch |
|-------|------|------|-----------|--------|-------------------|---------------|------------|-------|
| Opus 4.6 | Yes* | Yes* | Yes | low-max | Yes (recommended) | Deprecated | Yes | Yes |
| Sonnet 4.6 | Yes* | Yes* | Yes | low-high | Yes | Supported | Yes | Yes |
| Opus 4.5 | Yes* | Yes* | Yes | low-high | No | Yes | Yes | Yes |
| Sonnet 4.5 | Yes* | Yes* | Yes | No | No | Yes | Yes | Yes |
| Haiku 4.5 | Yes* | Yes* | Yes | No | No | Yes | Yes | Yes |

*Not supported when thinking is enabled.

---

## 3. Google Gemini API Parameters

### 3.1 APIs Available

| API | Endpoint | Notes |
|-----|----------|-------|
| **Gemini API** | `POST /v1/models/{model}:generateContent` | Google AI Studio / Gemini Developer API |
| **Vertex AI** | Vertex AI endpoints | Enterprise, regional endpoints available |
| **Live API** | WebSocket | Real-time bidirectional streaming |
| **OpenAI-compatible** | OpenAI SDK format | Maps `reasoning_effort` to `thinking_level` |

### 3.2 Core Parameters

#### Sampling Parameters

| Parameter | Type | Description | Models |
|-----------|------|-------------|--------|
| `temperature` | float (0-2) | Controls randomness | All Gemini models |
| `topP` | float (0-1) | Nucleus sampling | All Gemini models |
| `topK` | int | Top-K sampling | All Gemini models |
| `maxOutputTokens` | int | Maximum output tokens | All Gemini models |

#### Thinking / Reasoning Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `thinking_level` | string | Controls depth of internal reasoning |

**Valid `thinking_level` values:**

| Model | Valid Values | Default | Notes |
|-------|-------------|---------|-------|
| Gemini 3.1 Pro Preview | `low`, `medium`, `high` | `high` | `medium` is new in 3.1 |
| Gemini 3 Pro Preview | `low`, `high` | `high` | No `medium` option |
| Gemini 3 Flash Preview | `low`, `high` | `high` | |
| Gemini 2.5 Pro | `low`, `medium`, `high` | varies | |
| Gemini 2.5 Flash | Supported | varies | |

**Note:** When using the OpenAI compatibility layer, `reasoning_effort` is automatically mapped to `thinking_level`.

#### Media Processing

| Parameter | Type | Description |
|-----------|------|-------------|
| `media_resolution` | string | Controls vision processing token budget |

**Valid `media_resolution` values:** `low`, `medium`, `high`

- `low`: Fewer tokens, faster, cheaper, less detail
- `medium`: Balanced
- `high`: More tokens, higher fidelity, higher cost

Available on Gemini 3.x models.

### 3.3 Context Caching (Google)

| Property | Value |
|----------|-------|
| **Read Cost** | 0.1x base input price (<=200K), 0.1x (>200K) |
| **Storage Cost** | $4.50 per 1M tokens per hour (Gemini 3.1 Pro) |
| **Storage Cost** | $1.00 per 1M tokens per hour (Gemini 2.5 Flash) |
| **Potential Savings** | Up to 75% with effective caching |

### 3.4 Feature Support Summary Table

| Model | Temp | TopP | MaxTokens | Thinking | Media Resolution | Audio In | Video In | Batch |
|-------|------|------|-----------|----------|------------------|----------|----------|-------|
| Gemini 3.1 Pro | Yes | Yes | Yes | low/med/high | Yes | Yes | Yes | Yes |
| Gemini 3 Pro | Yes | Yes | Yes | low/high | Yes | Yes | Yes | Yes |
| Gemini 3 Flash | Yes | Yes | Yes | Yes | Yes | Yes | Yes | Yes |
| Gemini 2.5 Pro | Yes | Yes | Yes | Yes | -- | Yes | Yes | Yes |
| Gemini 2.5 Flash | Yes | Yes | Yes | Yes | -- | Yes | Yes | Yes |
| Gemini 2.5 Flash-Lite | Yes | Yes | Yes | -- | -- | Yes | Yes | Yes |

---

## 4. Parameter Support Matrix

### 4.1 Cross-Vendor Reasoning Control Comparison

| Concept | OpenAI | Anthropic | Google |
|---------|--------|-----------|--------|
| **Parameter Name** | `reasoning.effort` | `effort` | `thinking_level` |
| **Lowest Level** | `none` / `minimal` | `low` | `low` |
| **Middle Level** | `low`, `medium` | `medium` | `medium` |
| **Default Level** | `medium` | `high` | `high` |
| **Highest Level** | `high`, `xhigh` | `high`, `max` | `high` |
| **Exclusive Top Tier** | `xhigh` (5.2, 5.2 Pro, Codex) | `max` (Opus 4.6 only) | -- |
| **No Thinking** | `none` (GPT-5.2 only) | Omit thinking param | Omit or set `low` |

### 4.2 Cross-Vendor Structured Output Comparison

| Feature | OpenAI | Anthropic | Google |
|---------|--------|-----------|--------|
| **JSON Schema** | `responses.parse()` / `text_format` | `output_config.format` | `response_mime_type` + `response_schema` |
| **JSON Mode** | `response_format: {type: "json_object"}` | -- | `response_mime_type: "application/json"` |
| **Function Calling** | `tools` parameter | `tools` parameter | `tools` / `function_declarations` |
| **Tool Choice** | `tool_choice` | `tool_choice` | `tool_config` |

### 4.3 Cross-Vendor Caching Comparison

| Feature | OpenAI | Anthropic | Google |
|---------|--------|-----------|--------|
| **Mechanism** | Automatic prefix matching | Explicit cache breakpoints | Explicit cached content |
| **Read Discount** | 90% off (0.1x) | 90% off (0.1x) | 75-90% off |
| **Write Cost** | Same as input | 1.25x-2x input | Same as input |
| **Retention** | 24 hours | 5 minutes or 1 hour | Per-hour storage fee |
| **Min Activation** | Automatic | Manual breakpoint | Manual creation |

---

## 5. Reasoning / Thinking Controls

### 5.1 When to Use Each Level

| Level | Use Case | Trade-off |
|-------|----------|-----------|
| **Minimal/None/Low** | Classification, simple lookups, high-volume tasks | Fastest, cheapest, lowest quality |
| **Medium** | Balanced tasks, well-defined prompts, most production workloads | Good balance of speed and quality |
| **High** (typical default) | Complex reasoning, coding, analysis, quality-critical tasks | Higher latency, higher cost |
| **xhigh/Max** | Research problems, extremely difficult tasks, benchmarks | Longest latency, highest cost, best quality |

### 5.2 Cost Impact of Reasoning

Higher reasoning levels generate more internal "thinking tokens" that consume output token budget and cost. The cost multiplier varies significantly:

- `low` vs `high` can differ by 2-5x in total token consumption
- `xhigh`/`max` can consume 10-50x more tokens than `low` for complex tasks
- Models bill for thinking tokens at the output token rate

### 5.3 Vendor-Specific Reasoning Notes

**OpenAI:**
- `none` completely disables reasoning (GPT-5.2 only) -- behaves more like a traditional chat model
- `minimal` (Mini/Nano only) uses bare minimum reasoning
- Reasoning tokens are billed at output token rates
- With reasoning enabled, `temperature` and `top_p` are rejected

**Anthropic:**
- Adaptive thinking (`thinking: {type: "adaptive"}`) is recommended for Claude 4.6
- At `low` effort, Claude may skip thinking entirely for simple problems
- At `max` effort (Opus 4.6 only), thinking is always on with no depth constraints
- Thinking tokens count toward `max_tokens` budget
- With thinking enabled, `temperature`, `top_p`, `top_k` are not supported

**Google:**
- `thinking_level` controls maximum reasoning depth (not a strict budget)
- Gemini treats levels as relative allowances rather than strict token guarantees
- Gemini 3.1 Pro adds `medium` level for cost optimization
- Thinking tokens are billed at output token rates

---

## 6. Pricing Quick Reference

### 6.1 All Models -- Input/Output per 1M Tokens

| Model | Input | Cached | Output | Notes |
|-------|-------|--------|--------|-------|
| **OpenAI** | | | | |
| GPT-5.2 | $1.75 | $0.175 | $14.00 | |
| GPT-5.2 Chat Latest | $1.75 | $0.175 | $14.00 | |
| GPT-5.2 Codex | $1.75 | $0.175 | $14.00 | |
| GPT-5.2 Pro | $21.00 | -- | $168.00 | Responses API only |
| GPT-5.3 Codex | $1.75 | $0.175 | $14.00 | |
| GPT-5.3 Codex Spark | N/A | N/A | N/A | No public API |
| GPT-5 Mini | $0.25 | $0.025 | $2.00 | |
| GPT-5 Nano | $0.05 | $0.005 | $0.40 | |
| GPT-5.1 | $1.25 | $0.125 | $10.00 | |
| **Anthropic** | | | | |
| Claude Opus 4.6 | $5.00 | $0.50 | $25.00 | 1M ctx beta |
| Claude Opus 4.6 (fast) | $30.00 | -- | $150.00 | Research preview |
| Claude Opus 4.6 (>200K) | $10.00 | -- | $37.50 | Long context |
| Claude Sonnet 4.6 | $3.00 | $0.30 | $15.00 | 1M ctx beta |
| Claude Sonnet 4.6 (>200K) | $6.00 | -- | $22.50 | Long context |
| Claude Haiku 4.5 | $1.00 | $0.10 | $5.00 | |
| **Google** | | | | |
| Gemini 3.1 Pro (<=200K) | $2.00 | $0.20 | $12.00 | |
| Gemini 3.1 Pro (>200K) | $4.00 | $0.40 | $18.00 | |
| Gemini 3 Flash | $0.50 | -- | $3.00 | |
| Gemini 2.5 Pro (<=200K) | $1.25 | -- | $10.00 | |
| Gemini 2.5 Flash | $0.15-$0.30 | -- | $1.25-$2.50 | |
| Gemini 2.5 Flash-Lite | $0.05 | -- | $0.20 | |

### 6.2 Realtime / Audio Pricing

| Model | Audio In/1M | Audio Out/1M | Text In/1M | Text Out/1M |
|-------|-------------|--------------|------------|-------------|
| gpt-realtime-2025-08-28 | $32.00 | $64.00 | $5.00 | $20.00 |
| Gemini 2.5 Flash (audio) | $0.50-$1.00 | Live API | $0.15-$0.30 | $1.25-$2.50 |

### 6.3 Batch Processing Discounts

| Vendor | Discount | Availability |
|--------|----------|-------------|
| OpenAI | Varies by model | Available on most models |
| Anthropic | 50% off input and output | All Claude models |
| Google | 50% off input and output | Most Gemini models |

---

## 7. Practical Gotchas

### 7.1 OpenAI Gotchas

1. **Temperature/TopP rejection.** All GPT-5.x reasoning models reject `temperature` and `top_p` parameters with a 400 error. Build parameter-filtering logic into your API wrapper.

2. **Reasoning effort mismatch.** Different models support different effort ranges. Sending `none` to GPT-5.2 Codex (which starts at `low`) returns an error. Always validate against the model's supported range.

3. **GPT-5.2 Pro is Responses API only.** Chat Completions API calls to `gpt-5.2-pro` will fail. Ensure your SDK/wrapper routes Pro requests to the Responses API.

4. **GPT-5.2 Chat Latest vs GPT-5.2.** These are different models with different parameter support. `chat-latest` supports `max_output_tokens` but NOT reasoning effort. `gpt-5.2` supports reasoning effort but NOT `max_output_tokens`. Swapping one for the other without adjusting parameters causes 400 errors.

5. **Prompt caching is automatic.** Unlike Anthropic and Google, OpenAI's prompt caching activates automatically for repeated prefixes. No explicit cache management is needed, but the prefix must match exactly.

6. **GPT-5.3 Codex Spark has no public API.** As of February 2026, it is a ChatGPT Pro exclusive. Do not attempt API calls to this model.

7. **Realtime models are WebSocket only.** Attempting HTTP/REST calls to `gpt-realtime-*` models will fail. These require a WebSocket connection.

8. **Cached audio tokens for Realtime.** Cached audio input is $0.40/1M (vs $32.00 uncached) -- an 80x discount. Design voice agents to take advantage of this.

### 7.2 Anthropic Gotchas

1. **Prefill removal on Opus 4.6.** Prefilling assistant messages (a common technique for controlling output format) returns a 400 error on Opus 4.6. Use structured outputs or system prompt instructions instead.

2. **`max` effort is Opus 4.6 exclusive.** Sending `effort: "max"` to any other model returns an error.

3. **Adaptive thinking deprecates budget_tokens.** On Opus 4.6, `thinking: {type: "enabled", budget_tokens: N}` still works but is deprecated. Migrate to `thinking: {type: "adaptive"}` with the `effort` parameter.

4. **Temperature conflicts with thinking.** When extended thinking or adaptive thinking is enabled, `temperature`, `top_p`, and `top_k` parameters are not supported.

5. **1M context is beta and tier-gated.** Only Tier 4 organizations can access the 1M context window for Opus 4.6 and Sonnet 4.6. Standard context is 200K.

6. **Long context pricing triggers on total input.** Once input tokens (including cache reads/writes) exceed 200K, ALL tokens are billed at the higher rate, not just the excess.

7. **Fast mode requires beta header.** `speed: "fast"` requires `betas=["fast-mode-2026-02-01"]` and is only available on Opus 4.6.

8. **Web search is $10/1K searches.** Each web search call costs $0.01 regardless of results, plus token costs for the content retrieved.

9. **`output_format` is deprecated.** Use `output_config.format` on Claude 4.6 models. The old parameter still works but will be removed.

10. **Tool parameter quoting.** Opus 4.6 may produce slightly different JSON string escaping in tool call arguments. Always use `json.loads()` / `JSON.parse()` rather than string matching.

### 7.3 Google Gemini Gotchas

1. **Tiered pricing threshold.** Gemini 3.1 Pro and 2.5 Pro have different pricing above and below 200K input tokens. All tokens (input AND output) are charged at the higher rate once input exceeds 200K.

2. **Context caching has per-hour storage costs.** Unlike OpenAI's free 24-hour caching, Google charges $4.50/1M tokens/hour for Gemini 3.1 Pro cache storage. This can add up for large cached contexts.

3. **`thinking_level` replaces `thinking_budget`.** For Gemini 3.x models, use `thinking_level` instead of the older `thinking_budget` parameter.

4. **Gemini 3.1 Pro adds `medium` thinking level.** If you previously used Gemini 3 Pro (which only had `low`/`high`), `medium` is now available and can optimize costs.

5. **Preview vs GA status.** Gemini 3.1 Pro Preview, Gemini 3 Pro Preview, and Gemini 3 Flash Preview are all in preview status. Production SLAs may differ from GA models.

6. **Audio input pricing differs from text/image.** Gemini models charge different rates for audio input ($0.50-$1.00/1M) versus text/image input ($0.05-$2.00/1M).

7. **Live API audio token rates.** Audio is measured at 25 tokens/second and video at 258 tokens/second for billing purposes in the Live API.

8. **Nano Banana 2 is not a general LLM.** `gemini-3.1-flash-image-preview` is an image generation model, not a general-purpose language model. Do not use it for text generation tasks.

9. **Free tier exists but has limits.** Some Gemini models offer free-tier pricing with lower rate limits. The free tier may not be suitable for production workloads.

### 7.4 Cross-Vendor Gotchas

1. **Benchmark numbers are not directly comparable.** Each vendor evaluates on different versions of benchmarks with different prompting strategies. SWE-bench scores across vendors should be treated as approximate indicators.

2. **Knowledge cutoffs vary.** GPT-5.2 has an August 2025 cutoff, Gemini 3.1 Pro has January 2025, and Claude models do not publish a specific date. Factor this into applications requiring recent knowledge.

3. **Reasoning token costs are hidden.** All three vendors charge for internal thinking/reasoning tokens at output token rates, but these tokens are not visible in the response. A seemingly simple query at `high`/`xhigh` effort can consume thousands of thinking tokens.

4. **Context window != usable context.** Even with 1M token context windows, practical performance on needle-in-a-haystack tasks degrades with context length. Test with your specific use case before relying on the full window.

5. **Streaming behavior varies.** OpenAI streams token-by-token, Anthropic streams in small chunks, and Google's behavior varies by API. Test streaming behavior with your specific client library.

---

## Appendix: Model ID Quick Reference

| Vendor | Model | API Model ID |
|--------|-------|-------------|
| OpenAI | GPT-5.2 (Thinking) | `gpt-5.2` |
| OpenAI | GPT-5.2 (Instant) | `gpt-5.2-chat-latest` |
| OpenAI | GPT-5.2 Pro | `gpt-5.2-pro` |
| OpenAI | GPT-5.2 Codex | `gpt-5.2-codex` |
| OpenAI | GPT-5.3 Codex | `gpt-5.3-codex` |
| OpenAI | GPT-5.3 Codex Spark | `gpt-5.3-codex-spark` (research preview) |
| OpenAI | GPT-5 Mini | `gpt-5-mini` |
| OpenAI | GPT-5 Nano | `gpt-5-nano` |
| OpenAI | GPT Realtime | `gpt-realtime-2025-08-28` |
| Anthropic | Claude Opus 4.6 | `claude-opus-4-6` |
| Anthropic | Claude Sonnet 4.6 | `claude-sonnet-4-6` |
| Anthropic | Claude Haiku 4.5 | `claude-haiku-4-5-20251001` |
| Google | Gemini 3.1 Pro | `gemini-3.1-pro-preview` |
| Google | Gemini 3 Pro | `gemini-3-pro-preview` |
| Google | Gemini 3 Flash | `gemini-3-flash-preview` |
| Google | Gemini 3.1 Flash Image | `gemini-3.1-flash-image-preview` |
| Google | Gemini 2.5 Pro | `gemini-2.5-pro` |
| Google | Gemini 2.5 Flash | `gemini-2.5-flash` |
| Google | Gemini 2.5 Flash-Lite | `gemini-2.5-flash-lite` |
