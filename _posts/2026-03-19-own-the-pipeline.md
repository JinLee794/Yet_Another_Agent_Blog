---
title: "Own the Pipeline or Let the Platform Handle It: What a Year of Building Voice Agents Taught Me"
date: 2026-03-19
tags: [projects, AI, MCP, Azure Speech, realtime, enterprise]
---

It started with a phone call from my friend Pablo Salvadore Lopez. We'd worked together before, him, me, and another incredibly sharp engineer named Marcin Jimenez, building the [AutoAuth Solution Accelerator](https://github.com/Azure-Samples/autoauth-solution-accelerator) to automate prior authorization flows. So when Pablo called, I knew it'd be interesting.

His pitch was simple: "Jin, there's this massive gap right now. OpenAI just announced the gpt-4o-realtime preview, and every executive is asking their teams to voice-enable their agents. But nobody actually knows how to do it. I think we can build it, just a chat model and Azure Speech."

I'd never worked with voice before. But the idea of just *talking* to an intelligent agent, no typing, no clicking, just a conversation, felt like such a natural interface that I couldn't say no.

I also had no idea what I was signing up for.

The learning curve was immediate and humbling. I tripped on just standing up a basic WebSocket. Then tripped again trying to get a simple agent conversation working through a local socket. (Looking back, it's almost funny. With today's coding agents, "set up a WebSocket" is practically a one-shot prompt. But in those early days it was a genuine wall.) When I finally got it working and could speak to my localhost agent with Azure Speech's neural voices for the first time, it felt magical. Genuinely magical.

But that magic didn't last long, because now we had to connect it to Azure Communication Services for telephony. Once we could talk to our agents through actual phones, we needed a UI. Once we had the UI, we needed to deploy to Azure and automate the whole thing end-to-end. Each step felt like it should be straightforward, and each step wasn't. Lots of architecture diagrams. Lots of late-night research. Lots of nights and weekends spent piecing together what, a year later, feels deceptively simple.

That year of building became the [ART Voice Agent Accelerator](https://github.com/Azure-Samples/art-voice-agent-accelerator): an open-source framework for real-time, multi-agent voice systems on Azure. What started as "just a chat model and Azure Speech" evolved into a production-grade platform with two distinct orchestration architectures, multi-agent handoffs, telephony integration, and infrastructure-as-code deployment.

The most important thing I learned isn't about any specific technology. It's about an architecture decision that sits underneath everything else: **do you own each step of the voice pipeline, or do you hand the audio layer to a managed service?**

We built both. Here's what that taught me.

---

## Two architectures, one framework

At its core, a voice agent is a loop: audio comes in, gets understood, a response is generated, and audio goes out. The question is how much of that loop you control.

**Path A: Cascade. Own every step.**

Audio arrives and hits Azure Speech STT. You get a transcript. You send it to your LLM. The LLM streams tokens back. You buffer those tokens into sentences, strip markdown, and dispatch each sentence to Azure TTS individually for natural pacing. Audio goes out.

You control voice activity detection. You control when the system thinks the user is done talking. You control phrase biasing for domain terminology. You control the exact TTS voice, prosody, and emotional style. Typical end-to-end latency: around 400 milliseconds.

**Path B: VoiceLive. Let the platform handle audio.**

Audio goes directly to a realtime model. The model handles speech recognition, reasoning, and speech synthesis in one hop. Server-side VAD detects when the user stops talking. Audio comes back. Typical latency: around 200 milliseconds.

We implemented both behind the same agent framework and transport layer. Same YAML-driven agent definitions. Same tool registry. Same handoff system. You flip between them with an environment variable:

```bash
export ACS_STREAMING_MODE=MEDIA       # Cascade
export ACS_STREAMING_MODE=VOICE_LIVE  # VoiceLive
```

The interesting question is why we kept both.

---

## After building it all by hand, VoiceLive felt like a gift

I want to be honest about something: when we integrated Azure VoiceLive, my first reaction was pure relief.

We had spent months wrestling with the cascade pipeline. Threading barge-in cancellation through every layer. Tuning sentence boundary detection so TTS didn't sound choppy. Managing audio buffer pacing at different sample rates for browser vs telephony. Building custom VAD logic. Debugging race conditions between STT recognition and LLM streaming. All of it was necessary, all of it was educational, and all of it was  *work* .

Then VoiceLive collapsed that entire chain into a single managed connection. Audio in, audio out. Server-side VAD just handled. Barge-in just worked. ~200ms latency without any of our custom buffering. The first time I ran it, I sat there thinking: "this is what we were trying to build, and they just... did it."

That appreciation is real, and if your use case fits, VoiceLive or similar realtime voice models are genuinely transformative. You can go from zero to a working voice agent in a fraction of the time it took us to build the cascade path.

**But then you start talking to enterprise customers.**

Governance comes up fast. With a cascade pipeline, every step is auditable. You see exactly what the user said (STT transcript), exactly what the model received, and exactly what it responded before it becomes speech. With a managed voice-to-voice path, that intermediate visibility collapses. For regulated industries, that's not a preference. It's a requirement.

Then there's fine-tuning. Enterprises want to control recognition accuracy for their domain vocabulary. They want to choose specific TTS voices that match their brand. Some want to swap in specialized SLMs instead of general-purpose models for cost or accuracy reasons. The cascade architecture gives you each of those as an independent knob to turn. The managed path gives you one knob: the model, and whatever it supports.

Capacity is the quiet constraint that nobody talks about in launch demos. These realtime voice models are compute-intensive, and in enterprise Azure environments, capacity for the latest models is genuinely scarce. If your deployment depends on a model that has a three-month waitlist in your region, cascade mode with a readily available chat model and Azure Speech becomes your production path whether you planned for it or not.

And then there's data residency. Many enterprise customers have firm requirements about where their data is processed. Not preferences. Requirements, often backed by regulation or contractual obligation. A cascade pipeline lets you pin each component (STT, LLM, TTS) to a specific Azure region. Managed voice-to-voice paths may not offer that same granularity yet.

None of this makes VoiceLive less impressive. It makes the architectural flexibility to choose *per deployment* more important than picking a winner.

---

## What the latency numbers don't tell you

200ms vs 400ms sounds like an obvious choice. It isn't.

**When cascade wins despite being "slower":**

Managed voice-to-voice paths don't support phrase lists yet. If your agent handles medical terminology, financial product names, or any domain jargon, the STT will butcher it unless you can bias recognition. In cascade mode, you can inject per-agent phrase lists that dramatically improve transcription accuracy for specialized vocabulary. This matters more than latency in domains where *understanding the user correctly* is the whole point.

Then there's the VAD problem. Voice activity detection, the art of figuring out when the user has actually finished talking, is one of the most consequential tuning knobs in voice AI. Too sensitive and you cut the user off mid-sentence. Too loose and there's an awkward pause before every response. In cascade mode, you own the silence thresholds. You can set different thresholds per agent. A banking IVR needs faster turn detection than a therapy chatbot.

**When managed wins despite less control:**

If you need to ship in weeks, managed is the answer. You skip the entire STT/TTS integration layer, sentence boundary detection, audio format negotiation, and custom VAD tuning. The platform handles all of it.

The 200ms difference also compounds in ways that aren't obvious from benchmarks. In a transactional interaction ("what's my balance?"), 400ms feels fine. In a back-and-forth conversation with rapid turn-taking, those extra 200 milliseconds per turn accumulate into something that feels sluggish. Users don't measure latency. They feel rhythm.

**The real lesson: latency is a budget, not a number.**

The cascade path has more line items in that budget: STT recognition time, network hop to your server, LLM inference, TTS synthesis, network hop back, audio playback pacing. But you can optimize each one individually. The managed path has fewer line items, but they're opaque. You can't tune what you can't see.

Here's what that looks like concretely. Our browser path runs at 48kHz with 100ms audio windows. Our telephony path runs at 16kHz with 40ms pacing. Those aren't just config values. They define your latency floor differently per channel. In cascade mode, you can tune both independently. In managed mode, the platform makes that choice for you.

---

## The problems that surprised us

Here are the things that aren't in any "getting started with voice AI" tutorial.

### Barge-in is the hardest UX problem in voice

Barge-in is what happens when the user interrupts the agent mid-response. It sounds simple: stop talking and listen. In practice, it cascades through every layer of the system.

In VoiceLive mode, when the platform detects speech, we cancel the current model response, stop audio playback, and notify the UI, all within one event handler:

```python
async def _handle_speech_started(self) -> None:
    await self.audio.stop_playback()      # Kill outgoing audio
    await self.conn.response.cancel()      # Cancel model response
```

Clean. But you lose control over *how* the agent recovers. It just picks up wherever the model left off.

In cascade mode, barge-in is a cancel event that you thread through the entire pipeline. TTS playback stops, the sentence buffer clears, and the next user utterance gets a fresh turn. You own the recovery behavior. You can decide whether the agent acknowledges the interruption ("Sorry, go ahead") or just seamlessly pivots.

The point isn't that one approach is better. It's that barge-in isn't a feature you add later. It's an architecture decision that shapes your handler design, your state management, and your user experience from day one. Budget for it up front.

### Multi-agent handoffs over voice are nothing like text

We built banking scenarios with multiple specialized agents: a concierge routes you, an auth agent verifies your identity, a fraud agent handles security concerns, an investment advisor manages your portfolio. In text-based multi-agent systems, a handoff is a context swap. You change the system prompt and continue.

In voice, a handoff is a context swap  *while audio is streaming in real time* . You need to:

Preserve conversational memory across the switch. Decide whether the new agent greets the user or silently continues (what we call "announced" vs "discrete" handoffs). Render agent-specific greetings with Jinja templates that incorporate session context ("Welcome back, I see you were asking about a suspicious charge..."). And handle the timing: there's a window during the switch where the user might still be talking.

We discovered the "already has active response" conflict the hard way with VoiceLive. If you try to switch agents while the previous agent's audio is still streaming, the session rejects the update. We had to unify our handoff logic into a single `HandoffService` that both orchestrators share, replacing four inconsistent code paths with one:

```python
resolution = handoff_service.resolve_handoff(
    tool_name="handoff_fraud_agent",
    source_agent="Concierge",
    current_system_vars=system_vars,
)

if resolution.success:
    await orchestrator.switch_to(
        resolution.target_agent,
        resolution.system_vars,
    )
```

This was months of iteration compressed into a clean abstraction. The mess that preceded it was instructive.

### Sentence-level TTS streaming matters more than you'd think

You cannot dump a full LLM response into text-to-speech and get natural-sounding output. The LLM streams tokens, and you need to buffer them into sentence boundaries before synthesizing speech. Otherwise you get either choppy fragments or long pauses while you wait for the full response.

Our cascade orchestrator buffers streaming tokens and dispatches complete sentences to TTS:

```python
sentence_terms = ".!?"
min_chunk = 20  # characters before we'll look for a boundary

while len(sentence_buffer) >= min_chunk:
    term_idx = max(sentence_buffer.rfind(t) for t in sentence_terms)
    if term_idx >= min_chunk - 10:
        dispatch = sentence_buffer[:term_idx + 1]
        sentence_buffer = sentence_buffer[term_idx + 1:]
        send_to_tts(dispatch)
    else:
        break
```

This adds roughly 100ms of buffering latency but dramatically improves perceived quality. The agent sounds like it's speaking in natural phrases instead of stuttering through word fragments. Markdown stripping, emoji handling, and edge cases (abbreviations with periods, numbered lists) all live in this layer. It's invisible plumbing that users notice immediately if you get wrong.

### Observability in real-time audio is its own discipline

You can't just add `print` statements to a voice pipeline. By the time you read the log, the conversation has moved on. You need distributed tracing across STT, LLM, and TTS with per-turn latency metrics that you can query after the fact.

We went through three iterations of latency tooling: custom analytics scripts, then a compatibility layer, then finally OpenTelemetry with proper span hierarchy and GenAI semantic conventions. The winning pattern: measure time-to-first-token at the orchestrator level, track token usage per agent session, and emit summary spans that light up in your monitoring dashboard.

The metric that matters most is TTFT, time from when the user stops talking to when the first audio byte comes back. Everything else is optimization detail.

---

## The "80% accelerator" honesty

Our README says this framework gets you about 80% of the way to production. That's intentional honesty, not a caveat.

The 80% is the plumbing: telephony integration via Azure Communication Services, WebSocket transport, bidirectional audio streaming, the STT→LLM→TTS pipeline, multi-agent orchestration, handoff management, session state with Redis and Cosmos DB, OpenTelemetry tracing, and infrastructure-as-code deployment.

The 20% you bring: your security hardening (we ship Terraform for dev, you'll want private networking and WAF for production), your scale testing (voice sessions hold a WebSocket + audio stream + LLM connection each, a fundamentally different concurrency profile than REST APIs), and most importantly, your domain logic. Your agents, your tools, your prompts, your handoff conditions, your scenario graphs. That's where your differentiation lives.

We made the agent framework YAML-driven on purpose. Your agents are config files and prompt templates, not hard-coded orchestration logic. Because the last 20% should be about your business, not about reinventing audio transport.

---

## What I'd tell someone starting today

**Start managed, but keep the seams.** Get something working fast with voice-to-voice. But architect so you can swap the audio layer without rewriting your agent logic. You'll want cascade control eventually, whether for phrase biasing, compliance, or just to debug a latency problem that lives inside the managed path.

**Budget for barge-in from day one.** It's not a feature. It's a structural decision that cascades through your handler design, state management, and UX patterns. Retrofitting it is painful.

**Treat voice as a transport, not a product feature.** Your agent logic should be transport-agnostic. Today it's voice over telephony. Tomorrow it's voice over browser WebSocket. Next quarter someone wants the same agent in a chat widget. If your agent is coupled to the audio layer, you'll rewrite it every time you add a channel.

**Measure latency at every seam.** The difference between a good voice agent and a bad one is often 100ms you can't find without proper tracing. Instrument early. You'll thank yourself when something feels "off" and you need to figure out which hop got slow.

---

The [ART Voice Agent Accelerator](https://github.com/Azure-Samples/art-voice-agent-accelerator) is open source. If you're evaluating voice AI architectures, clone it and try both modes against your use case. The code is a better teacher than any blog post, including this one.
