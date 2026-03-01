---
name: frontier-model-landscape
description: Use when discussing, selecting, comparing, or recommending AI models from OpenAI, Anthropic, or Google. Reference this for up-to-date model names, IDs, capabilities, context windows, pricing, benchmarks, modality support, and release dates. Also use when a user mentions a specific model name to verify it exists and get its specs.
---

# Frontier Model Landscape

_Status: February 28, 2026_

A comprehensive, vendor-agnostic reference covering frontier large language models from OpenAI, Anthropic, and Google DeepMind. This document covers capabilities, pricing, context windows, modalities, reasoning controls, latency characteristics, and API features.

---

## Table of Contents

1. [OpenAI](#1-openai)
2. [Anthropic](#2-anthropic)
3. [Google DeepMind](#3-google--deepmind)
4. [Cross-Vendor Comparison Tables](#4-cross-vendor-comparison-tables)
5. [Modality Support Matrix](#5-modality-support-matrix)
6. [Pricing Quick Reference](#6-pricing-quick-reference)

---

## 1. OpenAI

### 1.1 GPT-5.2 Series

GPT-5.2, released December 2025, is OpenAI's flagship reasoning model family. It ships in several variants optimized for different use cases.

#### GPT-5.2 (Thinking)

| Property | Value |
|----------|-------|
| **Model ID** | `gpt-5.2` (also `gpt-5.2-2025-12-11`) |
| **Context Window** | 400,000 tokens |
| **Max Output** | 128,000 tokens |
| **Knowledge Cutoff** | August 31, 2025 |
| **Input Modalities** | Text, images |
| **Output Modalities** | Text |
| **Pricing (per 1M tokens)** | Input: $1.75 / Cached: $0.175 / Output: $14.00 |

**Key capabilities:**

- Adaptive reasoning that scales compute to task complexity
- Reasoning effort control: `none`, `low`, `medium`, `high`, `xhigh`
- Reasoning summary support (`auto`, `concise`, `detailed`)
- Verbosity control: `low`, `medium`, `high`
- Structured outputs via `responses.parse()`
- Function/tool calling
- Streaming with token-level updates
- Prompt caching with 24-hour retention (10x cost reduction on cached tokens)
- MCP (Model Context Protocol) tool support
- No temperature or top_p support (reasoning model constraint)

#### GPT-5.2 Instant (Chat Latest)

| Property | Value |
|----------|-------|
| **Model ID** | `gpt-5.2-chat-latest` |
| **Context Window** | 400,000 tokens |
| **Max Output** | 128,000 tokens |
| **Knowledge Cutoff** | August 31, 2025 |
| **Pricing (per 1M tokens)** | Input: $1.75 / Cached: $0.175 / Output: $14.00 |

**Differences from Thinking variant:**

- Tuned for low latency, instruction following, and conversational use
- Does NOT support reasoning effort, verbosity, or structured `responses.parse()`
- Supports `max_output_tokens` parameter
- Supports `reasoning.summary`

#### GPT-5.2 Pro

| Property | Value |
|----------|-------|
| **Model ID** | `gpt-5.2-pro` |
| **Context Window** | 400,000 tokens |
| **Max Output** | 128,000 tokens |
| **Pricing (per 1M tokens)** | Input: $21.00 / Output: $168.00 |

**Key characteristics:**

- Maximum reasoning depth with extended thinking time
- **Responses API only** -- not available in Chat Completions API
- Reasoning effort: `medium`, `high`, `xhigh` (no `none` or `low`)
- Some requests may take several minutes
- Does NOT support structured `responses.parse()`
- Supports reasoning summary and verbosity

#### GPT-5.2 Codex

| Property | Value |
|----------|-------|
| **Model ID** | `gpt-5.2-codex` |
| **Context Window** | 400,000 tokens |
| **Max Output** | 128,000 tokens |
| **Knowledge Cutoff** | August 31, 2025 |
| **Pricing (per 1M tokens)** | Input: $1.75 / Cached: $0.175 / Output: $14.00 |

**Key characteristics:**

- Optimized for long-horizon, agentic coding tasks
- Context compaction support for extended sessions
- Reasoning effort: `low`, `medium`, `high`, `xhigh` (no `none`)
- Supports structured outputs
- Does NOT support reasoning summary or verbosity
- SWE-Bench Pro: 56.4%, Terminal-Bench 2.0: 64.0%

---

### 1.2 GPT-5.3 Codex Series (NEW -- February 2026)

#### GPT-5.3 Codex

| Property | Value |
|----------|-------|
| **Model ID** | `gpt-5.3-codex` |
| **Release Date** | February 5, 2026 (GA: February 9, 2026) |
| **Context Window** | 400,000 tokens |
| **Max Output** | 128,000 tokens |
| **Knowledge Cutoff** | August 31, 2025 |
| **Input Modalities** | Text, images |
| **Output Modalities** | Text |
| **Pricing (per 1M tokens)** | Input: $1.75 / Cached: $0.175 / Output: $14.00 |

**Key characteristics:**

- "The most capable agentic coding model to date"
- Reasoning effort: `low`, `medium`, `high`, `xhigh`
- Supports streaming, function calling, structured outputs
- Fine-tuning: Not supported
- Same pricing as GPT-5.2 Codex

#### GPT-5.3 Codex Spark

| Property | Value |
|----------|-------|
| **Model ID** | `gpt-5.3-codex-spark` (research preview) |
| **Release Date** | February 12, 2026 |
| **Context Window** | 128,000 tokens |
| **Max Output** | Not publicly documented |
| **Input Modalities** | Text only |
| **Output Modalities** | Text |
| **Pricing** | Not available via public API (ChatGPT Pro only, $200/mo subscription) |

**Key characteristics:**

- Ultra-fast inference: over 1,000 tokens per second
- First OpenAI model running on Cerebras Wafer Scale Engine 3 (4 trillion transistors)
- Designed for real-time coding with near-instant feedback
- Research preview: available only to ChatGPT Pro users in Codex app
- **No public API access** -- restricted to select design partners
- Smaller context window (128K vs 400K for standard Codex)
- Strong SWE-Bench Pro and Terminal-Bench 2.0 performance at a fraction of the time
- Rate limits: 300-1,500 local messages per 5-hour window

---

### 1.3 GPT-5 Mini and Nano

#### GPT-5 Mini

| Property | Value |
|----------|-------|
| **Model ID** | `gpt-5-mini` (also `gpt-5-mini-2025-08-07`) |
| **Context Window** | 400,000 tokens |
| **Max Output** | 128,000 tokens |
| **Knowledge Cutoff** | May 31, 2024 |
| **Pricing (per 1M tokens)** | Input: $0.25 / Cached: $0.025 / Output: $2.00 |

**Key characteristics:**

- Balanced speed/cost for well-defined tasks
- 7x cheaper than GPT-5.2 on input tokens
- Reasoning effort: `minimal`, `low`, `medium`, `high`
- Supports reasoning summary, verbosity, structured outputs
- Streaming with token-level updates
- MCP tool support

#### GPT-5 Nano

| Property | Value |
|----------|-------|
| **Model ID** | `gpt-5-nano` (also `gpt-5-nano-2025-08-07`) |
| **Context Window** | 400,000 tokens |
| **Max Output** | 128,000 tokens |
| **Knowledge Cutoff** | May 31, 2024 |
| **Pricing (per 1M tokens)** | Input: $0.05 / Cached: $0.005 / Output: $0.40 |

**Key characteristics:**

- Fastest, cheapest option for simple tasks
- 35x cheaper than GPT-5.2 on input tokens
- Reasoning effort: `minimal`, `low`, `medium`, `high`
- Supports reasoning summary, verbosity, structured outputs
- Best suited for classification, summarization, simple operations

---

### 1.4 GPT-5.1 Series (Previous Generation)

| Model | Model ID | Pricing (Input/Output per 1M) | Reasoning Effort | Notes |
|-------|----------|-------------------------------|------------------|-------|
| GPT-5.1 | `gpt-5.1` | $1.25 / $10.00 | low, medium, high | Previous flagship |
| GPT-5.1 Chat Latest | `gpt-5.1-chat-latest` | $1.25 / $10.00 | low, medium, high | Chat-optimized |
| GPT-5.1 Codex Mini | `gpt-5.1-codex-mini` | $1.25 / $10.00 | low, medium, high | Previous coding model |
| GPT-5.1 Codex | `gpt-5.1-codex` | $1.25 / $10.00 | low, medium, high | Previous codex |
| GPT-5.1 Codex Max | `gpt-5.1-codex-max` | $1.25 / $10.00 | low, medium, high, xhigh | Extended codex |

---

### 1.5 Realtime Models

#### gpt-realtime-2025-08-28

| Property | Value |
|----------|-------|
| **Model ID** | `gpt-realtime-2025-08-28` |
| **Transport** | WebSocket only (not HTTP/REST) |
| **Input Modalities** | Audio, text, images |
| **Output Modalities** | Audio, text |
| **Audio Input Pricing** | $32.00 / 1M tokens (cached: $0.40) |
| **Audio Output Pricing** | $64.00 / 1M tokens |
| **Text Input Pricing** | $5.00 / 1M tokens (cached: $2.50) |
| **Text Output Pricing** | $20.00 / 1M tokens |

**Key characteristics:**

- End-to-end speech-to-speech model (not ASR + LLM + TTS pipeline)
- Bidirectional streaming via WebSockets
- Sub-second latency, preserves prosody and paralinguistic cues
- Tool/function calling including asynchronous calls
- Remote MCP server support
- Image input support (screenshots, photos)
- Designed for production voice agents

#### gpt-realtime-mini-2025-10-06

| Property | Value |
|----------|-------|
| **Model ID** | `gpt-realtime-mini-2025-10-06` |
| **Transport** | WebSocket only |

A lighter-weight realtime model variant for cost-sensitive voice applications.

---

### 1.6 Deprecated OpenAI Models

| Model | Status | Replacement |
|-------|--------|-------------|
| `codex-mini-latest` | Deprecated | `gpt-5.2-codex` / `gpt-5.1-codex-mini` |
| `gpt-4o-realtime-preview` | Legacy | `gpt-realtime-2025-08-28` |

---

## 2. Anthropic

### 2.1 Claude Opus 4.6

| Property | Value |
|----------|-------|
| **Model ID** | `claude-opus-4-6` |
| **Release Date** | February 5, 2026 |
| **Context Window** | 200K tokens (1M in beta for Tier 4 orgs) |
| **Max Output** | 128,000 tokens |
| **Input Modalities** | Text, images |
| **Output Modalities** | Text |
| **Pricing (per 1M tokens)** | Input: $5.00 / Cache Hits: $0.50 / Output: $25.00 |
| **Long Context (>200K input)** | Input: $10.00 / Output: $37.50 |
| **Batch Pricing** | Input: $2.50 / Output: $12.50 |
| **Fast Mode Pricing** | Input: $30.00 / Output: $150.00 |

**Key capabilities:**

- Anthropic's most intelligent model for agents and coding
- **Adaptive thinking** (`thinking: {type: "adaptive"}`) -- model dynamically decides when and how much to reason
- **Effort parameter** (GA): `low`, `medium`, `high` (default), `max`
  - `max` is exclusive to Opus 4.6 -- always uses extended thinking with no depth constraints
- Interleaved thinking enabled automatically with adaptive thinking
- 128K output tokens (doubled from Opus 4.5's 64K limit)
- Context compaction API (beta) for effectively infinite conversations
- Fast mode (research preview): up to 2.5x faster at premium pricing
- Tool use: function calling, web search ($10/1K searches), web fetch (free), code execution, text editor, computer use, memory tool, MCP connector
- Dynamic filtering in web search/fetch (writes code to filter results)
- Structured outputs via `output_config.format`
- Data residency controls (`inference_geo`: `global` or `us`)
- Batch API with 50% discount
- Prompt caching: 5-minute (1.25x) and 1-hour (2x) write durations, reads at 0.1x

**Benchmarks:**

- Highest score on Terminal-Bench 2.0 (agentic coding)
- Leads on Humanity's Last Exam
- GDPval-AA: outperforms GPT-5.2 by ~144 Elo points
- 80.8% SWE-bench Verified
- 72.7% OSWorld-Verified (computer use)

**Breaking changes from Opus 4.5:**

- Prefilling assistant messages is NOT supported (returns 400 error)
- `thinking: {type: "enabled", budget_tokens: N}` is deprecated (use adaptive thinking)
- `output_format` parameter moved to `output_config.format`

**Audio/Video:**

- No native speech-to-speech model
- Voice input/output available in consumer apps (5 voice options)
- Real-time video API announced for analysis tasks ($0.06/min analysis, $0.18/min generative)
- API-level video understanding requires external pipelines

---

### 2.2 Claude Sonnet 4.6

| Property | Value |
|----------|-------|
| **Model ID** | `claude-sonnet-4-6` |
| **Release Date** | February 17, 2026 |
| **Context Window** | 200K tokens (1M in beta) |
| **Max Output** | 64,000 tokens |
| **Input Modalities** | Text, images |
| **Output Modalities** | Text |
| **Pricing (per 1M tokens)** | Input: $3.00 / Cache Hits: $0.30 / Output: $15.00 |
| **Long Context (>200K input)** | Input: $6.00 / Output: $22.50 |
| **Batch Pricing** | Input: $1.50 / Output: $7.50 |

**Key capabilities:**

- Best combination of speed and intelligence in the Claude family
- Same pricing as Sonnet 4.5 with significant quality improvements
- Adaptive thinking and extended thinking support
- Effort parameter support (first Sonnet model with effort control)
- Near-Opus-level performance at 1/5th the cost:
  - 79.6% SWE-bench Verified (vs Opus 4.6's 80.8%)
  - 72.5% OSWorld-Verified (vs Opus 4.6's 72.7%)
- 65% Mean Match Ratio on MRCR v2 1M 8-needles (up from 18.5% in Sonnet 4.5)
- Preferred over Sonnet 4.5 by developers ~70% of the time
- Preferred over Opus 4.5 in 59% of comparisons
- All Claude 4.6 tools and features (web search, web fetch, code execution, etc.)
- Context compaction API (beta)

---

### 2.3 Claude Haiku 4.5

| Property | Value |
|----------|-------|
| **Model ID** | `claude-haiku-4-5-20251001` |
| **Release Date** | October 15, 2025 |
| **Context Window** | 200,000 tokens |
| **Max Output** | 64,000 tokens |
| **Input Modalities** | Text, images |
| **Output Modalities** | Text |
| **Pricing (per 1M tokens)** | Input: $1.00 / Cache Hits: $0.10 / Output: $5.00 |
| **Batch Pricing** | Input: $0.50 / Output: $2.50 |

**Key capabilities:**

- Anthropic's fastest model, optimized for low latency and high throughput
- 4-5x faster than Sonnet 4.5
- Near-frontier coding performance (73.3% SWE-bench Verified)
- Extended thinking support
- Computer use support
- Tool/function calling
- Prompt caching
- Designed for real-time agents, chatbots, and sub-agents

---

### 2.4 Previous Claude Models (Still Available)

| Model | Model ID | Pricing (Input/Output per 1M) | Max Output | Notes |
|-------|----------|-------------------------------|------------|-------|
| Claude Opus 4.5 | `claude-opus-4-5` | $5 / $25 | 64K | Previous flagship |
| Claude Opus 4.1 | `claude-opus-4-1` | $15 / $75 | 64K | Legacy pricing |
| Claude Opus 4 | `claude-opus-4` | $15 / $75 | 64K | Legacy pricing |
| Claude Sonnet 4.5 | `claude-sonnet-4-5` | $3 / $15 | 64K | Previous Sonnet |
| Claude Sonnet 4 | `claude-sonnet-4` | $3 / $15 | 64K | Previous Sonnet |
| Claude Haiku 3.5 | `claude-haiku-3-5` | $0.80 / $4 | -- | Previous Haiku |
| Claude Haiku 3 | `claude-haiku-3` | $0.25 / $1.25 | -- | Legacy |

**Deprecated:** Claude Sonnet 3.7, Claude Opus 3

---

## 3. Google / DeepMind

### 3.1 Gemini 3.1 Pro Preview (NEW -- February 2026)

| Property | Value |
|----------|-------|
| **Model ID** | `gemini-3.1-pro-preview` |
| **Release Date** | February 19, 2026 |
| **Context Window** | 1,000,000 tokens |
| **Max Output** | 64,000 tokens |
| **Knowledge Cutoff** | January 2025 |
| **Input Modalities** | Text, images, audio, video, PDFs |
| **Output Modalities** | Text |
| **Pricing (per 1M tokens, <=200K)** | Input: $2.00 / Output: $12.00 |
| **Pricing (per 1M tokens, >200K)** | Input: $4.00 / Output: $18.00 |
| **Batch Input (<=200K)** | $1.00 |
| **Batch Output (<=200K)** | $6.00 |
| **Context Cache (<=200K)** | $0.20 / 1M tokens + $4.50/1M tokens/hour storage |

**Key capabilities:**

- Google's most intelligent Pro-tier model
- Major reasoning upgrade: 77.1% ARC-AGI-2 (up from 31.1% in Gemini 3 Pro)
- 80.6% SWE-Bench
- 2887 Elo on LiveCodeBench Pro
- 94.3% GPQA Diamond
- No. 1 on 12 of 18 tracked benchmarks
- `thinking_level` parameter: `low`, `medium` (new), `high` (default)
- `media_resolution` parameter: `low`, `medium`, `high` (controls vision token budget)
- Same pricing as Gemini 3 Pro -- drop-in replacement
- Preview status (not yet GA)
- Also available as `gemini-3.1-pro-preview-customtools` (optimized for agentic tool use)

---

### 3.2 Gemini 3 Pro Preview

| Property | Value |
|----------|-------|
| **Model ID** | `gemini-3-pro-preview` |
| **Release Date** | December 2025 |
| **Context Window** | 1,000,000 tokens |
| **Max Output** | 64,000 tokens |
| **Knowledge Cutoff** | January 2025 |
| **Input Modalities** | Text, images, audio, video, PDFs |
| **Output Modalities** | Text |
| **Pricing (per 1M tokens, <=200K)** | Input: $2.00 / Output: $12.00 |
| **Pricing (per 1M tokens, >200K)** | Input: $4.00 / Output: $18.00 |

**Key capabilities:**

- Advanced reasoning, coding, and multimodal tasks
- `thinking_level`: `low`, `high`
- `media_resolution` controls for vision processing
- Natively handles text, images, audio, and video input
- Superseded by Gemini 3.1 Pro Preview for new projects

---

### 3.3 Gemini 3 Flash Preview

| Property | Value |
|----------|-------|
| **Model ID** | `gemini-3-flash-preview` |
| **Release Date** | December 17, 2025 |
| **Context Window** | 1,000,000 tokens |
| **Max Output** | 64,000 tokens |
| **Knowledge Cutoff** | January 2025 |
| **Input Modalities** | Text, images, audio, video, PDFs |
| **Output Modalities** | Text |
| **Pricing (per 1M tokens)** | Input: $0.50 (text/image/video), $1.00 (audio) / Output: $3.00 |
| **Batch Pricing** | Input: $0.25 / Output: $1.50 |

**Key capabilities:**

- Fast, cost-efficient reasoning model in the Gemini 3 family
- Thinking level support
- Multimodal inputs including video
- Context caching available

---

### 3.4 Gemini 3.1 Flash Image Preview / "Nano Banana 2" (NEW -- February 2026)

| Property | Value |
|----------|-------|
| **Model ID** | `gemini-3.1-flash-image-preview` |
| **Release Date** | February 26, 2026 |
| **Primary Use** | Image generation and editing |
| **Pricing** | $0.045/image (512px) to $0.151/image (4K) |
| **Batch Discount** | 50% off via Batch API |

**Key characteristics:**

- Google's best image generation model
- Default image generation engine across Gemini app, Google Search AI Mode, Google Lens, Google Ads, and Flow
- Pro-quality image generation at Flash speed
- Not a general-purpose LLM -- specialized for image generation/editing
- Available in Gemini AI Plus ($19.99/mo, ~50 daily credits) and Ultra ($124.99/mo, up to 1,000 images/day)

---

### 3.5 Gemini 2.5 Pro

| Property | Value |
|----------|-------|
| **Model ID** | `gemini-2.5-pro` |
| **Context Window** | 1,000,000 tokens |
| **Input Modalities** | Text, images, audio, video |
| **Output Modalities** | Text |
| **Pricing (per 1M tokens, <=200K)** | Input: $1.25 / Output: $10.00 |
| **Pricing (per 1M tokens, >200K)** | Input: $2.50 / Output: $15.00 |
| **Batch Input (<=200K)** | $0.625 |
| **Batch Output (<=200K)** | $5.00 |

---

### 3.6 Gemini 2.5 Flash

| Property | Value |
|----------|-------|
| **Model ID** | `gemini-2.5-flash` |
| **Context Window** | 1,000,000 tokens |
| **Input Modalities** | Text, images, audio, video |
| **Output Modalities** | Text |
| **Pricing (per 1M tokens)** | Input: $0.15-$0.30 (text/image/video), $0.50-$1.00 (audio) / Output: $1.25-$2.50 |

**Key characteristics:**

- Google's fastest reasoning model in the 2.5 family
- Thinking support for adaptive reasoning
- Live API compatible for real-time bidirectional streaming
- 30 HD voices in 24 languages via Live API
- Sub-second first-token latency (~600ms in reference implementations)

---

### 3.7 Gemini 2.5 Flash-Lite

| Property | Value |
|----------|-------|
| **Model ID** | `gemini-2.5-flash-lite` |
| **Context Window** | 1,000,000 tokens |
| **Input Modalities** | Text, images, audio, video, PDFs |
| **Output Modalities** | Text |
| **Pricing (per 1M tokens)** | Input: $0.05 (text/image/video), $0.15-$0.30 (audio) / Output: $0.20-$0.40 |
| **Batch Pricing** | Input: $0.05 / Output: $0.20 |

**Key characteristics:**

- Lowest-cost Gemini model for high-volume workloads
- Optimized for translation, classification, and latency-sensitive tasks
- Live API compatible
- Generally available (stable)

---

### 3.8 Live API (Gemini Real-Time Streaming)

Google's Live API provides low-latency, bidirectional streaming for Gemini models.

**Key features:**

- Continuous streams of audio, video, and text
- Sub-second first-token latency (~600ms)
- Natural, interruptible voice conversations
- 30 HD voices in 24 languages
- Proactive audio mode (responds only when relevant)
- Screen-aware interactions
- Compatible with Gemini 2.5 Flash, 2.5 Flash-Lite, and potentially newer models
- Audio: 25 tokens/second, Video: 258 tokens/second

**Pricing:**

Audio tokens for Live API are measured at 25 tokens per second. Pricing follows the underlying model's audio token rates.

---

## 4. Cross-Vendor Comparison Tables

### 4.1 Flagship Models

| Property | GPT-5.2 | Claude Opus 4.6 | Gemini 3.1 Pro Preview |
|----------|---------|-----------------|------------------------|
| **Input Price** | $1.75 | $5.00 | $2.00 |
| **Output Price** | $14.00 | $25.00 | $12.00 |
| **Context Window** | 400K | 200K (1M beta) | 1M |
| **Max Output** | 128K | 128K | 64K |
| **Knowledge Cutoff** | Aug 2025 | -- | Jan 2025 |
| **Reasoning Control** | none-xhigh | low-max | low/medium/high |
| **Structured Outputs** | Yes | Yes | Yes |
| **Native Audio Input** | No (Realtime model) | No | Yes |
| **Native Video Input** | No | No | Yes |
| **Native Image Input** | Yes | Yes | Yes |

### 4.2 Mid-Tier / Cost-Efficient Models

| Property | GPT-5 Mini | Claude Sonnet 4.6 | Gemini 3 Flash |
|----------|------------|--------------------|--------------------|
| **Input Price** | $0.25 | $3.00 | $0.50 |
| **Output Price** | $2.00 | $15.00 | $3.00 |
| **Context Window** | 400K | 200K (1M beta) | 1M |
| **Max Output** | 128K | 64K | 64K |
| **Reasoning Control** | minimal-high | Yes (effort) | thinking_level |
| **Native Multimodal** | Text, images | Text, images | Text, images, audio, video |

### 4.3 Budget / Low-Latency Models

| Property | GPT-5 Nano | Claude Haiku 4.5 | Gemini 2.5 Flash-Lite |
|----------|------------|-------------------|-----------------------|
| **Input Price** | $0.05 | $1.00 | $0.05 |
| **Output Price** | $0.40 | $5.00 | $0.20 |
| **Context Window** | 400K | 200K | 1M |
| **Max Output** | 128K | 64K | -- |
| **Reasoning Control** | minimal-high | Extended thinking | -- |
| **Best For** | Classification, simple tasks | Low-latency agents | High-volume, cost-sensitive |

### 4.4 Real-Time / Audio Models

| Property | gpt-realtime-2025-08-28 | Claude (via external ASR) | Gemini Live API |
|----------|-------------------------|---------------------------|-----------------|
| **Audio Input** | Native (end-to-end) | No native audio model | Native (bidirectional) |
| **Audio Output** | Native | Consumer app only | Native (30 HD voices) |
| **Transport** | WebSocket | HTTP/REST (text only) | WebSocket |
| **Latency** | Sub-second | Depends on ASR | ~600ms TTFT |
| **Image Input** | Yes | N/A | Yes (screen sharing) |
| **Video Input** | No | N/A | Yes |
| **Tool Calling** | Yes (async) | N/A | Yes |

---

## 5. Modality Support Matrix

| Model | Text In | Text Out | Image In | Image Out | Audio In | Audio Out | Video In | Video Out |
|-------|---------|----------|----------|-----------|----------|-----------|----------|-----------|
| GPT-5.2 | Yes | Yes | Yes | No | No | No | No | No |
| GPT-5.3 Codex | Yes | Yes | Yes | No | No | No | No | No |
| GPT-5.3 Codex Spark | Yes | Yes | No | No | No | No | No | No |
| GPT-5 Mini/Nano | Yes | Yes | Yes | No | No | No | No | No |
| gpt-realtime | Yes | Yes | Yes | No | Yes | Yes | No | No |
| Claude Opus 4.6 | Yes | Yes | Yes | No | No | No | No | No |
| Claude Sonnet 4.6 | Yes | Yes | Yes | No | No | No | No | No |
| Claude Haiku 4.5 | Yes | Yes | Yes | No | No | No | No | No |
| Gemini 3.1 Pro | Yes | Yes | Yes | No | Yes | No | Yes | No |
| Gemini 3 Flash | Yes | Yes | Yes | No | Yes | No | Yes | No |
| Gemini 3.1 Flash Image | Yes | No | Yes | Yes | No | No | No | No |
| Gemini 2.5 Flash | Yes | Yes | Yes | No | Yes | Yes* | Yes | No |
| Gemini 2.5 Flash-Lite | Yes | Yes | Yes | No | Yes | No | Yes | No |

*Audio output via Live API only.

---

## 6. Pricing Quick Reference

### 6.1 Text Model Pricing (per 1M tokens)

| Model | Input | Cached Input | Output | Batch Input | Batch Output |
|-------|-------|-------------|--------|-------------|--------------|
| **OpenAI** | | | | | |
| GPT-5.2 / 5.2 Codex / 5.3 Codex | $1.75 | $0.175 | $14.00 | -- | -- |
| GPT-5.2 Pro | $21.00 | -- | $168.00 | -- | -- |
| GPT-5 Mini | $0.25 | $0.025 | $2.00 | -- | -- |
| GPT-5 Nano | $0.05 | $0.005 | $0.40 | -- | -- |
| **Anthropic** | | | | | |
| Claude Opus 4.6 | $5.00 | $0.50 | $25.00 | $2.50 | $12.50 |
| Claude Sonnet 4.6 | $3.00 | $0.30 | $15.00 | $1.50 | $7.50 |
| Claude Haiku 4.5 | $1.00 | $0.10 | $5.00 | $0.50 | $2.50 |
| **Google** | | | | | |
| Gemini 3.1 Pro (<=200K) | $2.00 | $0.20 | $12.00 | $1.00 | $6.00 |
| Gemini 3.1 Pro (>200K) | $4.00 | $0.40 | $18.00 | $2.00 | $9.00 |
| Gemini 3 Flash | $0.50 | -- | $3.00 | $0.25 | $1.50 |
| Gemini 2.5 Pro (<=200K) | $1.25 | -- | $10.00 | $0.625 | $5.00 |
| Gemini 2.5 Flash | $0.15-$0.30 | -- | $1.25-$2.50 | -- | -- |
| Gemini 2.5 Flash-Lite | $0.05 | -- | $0.20 | $0.05 | $0.20 |

### 6.2 Audio/Realtime Pricing (per 1M tokens)

| Model | Audio Input | Audio Output | Text Input | Text Output |
|-------|-------------|--------------|------------|-------------|
| gpt-realtime-2025-08-28 | $32.00 | $64.00 | $5.00 | $20.00 |
| Gemini 2.5 Flash (audio) | $0.50-$1.00 | Via Live API | $0.15-$0.30 | $1.25-$2.50 |
| Gemini 2.5 Flash-Lite (audio) | $0.15-$0.30 | -- | $0.05 | $0.20 |

### 6.3 Cost Comparison: 1M Input + 100K Output

A practical comparison of what a typical heavy request costs:

| Model | 1M Input + 100K Output Cost |
|-------|---------------------------|
| GPT-5 Nano | $0.09 |
| Gemini 2.5 Flash-Lite | $0.07 |
| GPT-5 Mini | $0.45 |
| Gemini 3 Flash | $0.80 |
| Claude Haiku 4.5 | $1.50 |
| GPT-5.2 | $3.15 |
| Gemini 3.1 Pro (<=200K) | $3.20 |
| Claude Sonnet 4.6 | $4.50 |
| Claude Opus 4.6 | $7.50 |
| Gemini 3.1 Pro (>200K) | $5.80 |
| GPT-5.2 Pro | $37.80 |

---

## Notes

- All pricing is in USD and reflects publicly available API pricing as of February 28, 2026.
- "Context Window" refers to the maximum input token capacity.
- Google Gemini models with tiered pricing (<=200K / >200K) charge the higher rate for ALL tokens once the input exceeds 200K.
- Anthropic's 1M context window for Opus 4.6 and Sonnet 4.6 is in beta and available only to Tier 4 organizations.
- OpenAI prompt caching provides up to 90% cost reduction with 24-hour retention.
- Anthropic prompt caching offers 5-minute (default) and 1-hour cache durations.
- Google context caching incurs per-hour storage costs in addition to reduced read rates.
- GPT-5.3-Codex-Spark is not available via public API as of this writing.
- All benchmark numbers are vendor-reported and may not be directly comparable across vendors due to different evaluation methodologies.
