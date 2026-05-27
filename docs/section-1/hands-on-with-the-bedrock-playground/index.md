# Hands-On with the Bedrock Playground

## What this lecture covers

Hands-on tour of the <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/playgrounds.html">Amazon Bedrock playground</a>: why Bedrock is the **foundation** of AWS GenAI, how to select and compare models, chat vs single-prompt vs compare modes, configuration (system prompt, reasoning, tokens, temperature, Top P, guardrails, prompt caching), file upload, and experimenting with **text, image, audio, and prompt router** models.

## Key definitions (from the lecture)

| Term | Definition |
|---|---|
| **Bedrock playground** | Console UI under **Test → Playground** to experiment with foundation models and discover strengths/weaknesses. |
| **Model card** | Per-model documentation of capabilities, inputs, and outputs—check before choosing a model. |
| **Chat mode** | Multi-turn conversation; prior turns stay in **context** for follow-up questions. |
| **Single prompt mode** | One-shot without chat history (not all models support it—e.g. Claude Haiku may not). |
| **Compare mode** | Run the **same prompt** against two models with **separate** configuration panels. |
| **System prompt** | Overarching instructions for the whole session (e.g. “Always talk like a pirate”). |
| **Model reasoning** | Deeper decomposition of complex requests; uses **more / pricier tokens**. |
| **Temperature** | Randomness when choosing the next token; higher = more varied, lower = more deterministic. |
| **Top P** | Probability threshold for candidate tokens; similar role to controlling diversity (related to Top K conceptually). |
| **Prompt caching** | Reuse repeated prompt text (e.g. system prompt) at **lower cost** than re-sending full token charges every time. |
| **Guardrails** | Filter objectionable content and **PII** via Bedrock guardrail configuration. |
| **Prompt router** | Routes each prompt to a smaller or larger model based on estimated complexity (e.g. Nova or Anthropic routers). |

## Key distinctions / comparisons

| Item | Notes |
|---|---|
| **Bedrock vs single-model APIs** | Bedrock is a **common API/UI** across many foundation model providers. |
| **Chat vs single prompt** | Chat keeps history in context; single prompt is isolated—model support varies. |
| **Temperature vs Top P** | Both influence randomness/creativity; some models gray out unsupported controls (Haiku example). |
| **Text vs image model config** | Image models (e.g. Nova Canvas) expose generation modes (inpainting, background, size, seed)—not the same sliders as chat LLMs. |
| **Serverless models vs routers** | Routers pick model tier (e.g. Haiku vs Sonnet) from prompt complexity. |
| **Fair compare mode** | Align **output token limits**, temperature, and mode (chat vs single) across both sides. |

## The problem (why you need it)

- Foundation models differ in modalities, limits, and behavior—you need safe experimentation before production integration.
- Anthropic models may require **use case submission** (often approved quickly—educational use is fine).
- Uncontrolled **token usage** (reasoning, long outputs) drives cost without playground exploration first.

## The solution

- Open **Bedrock → Test → Playground**, filter by input/output modality, read **model cards**.
- Use **chat** for conversational tasks; **compare** for model selection; explore **image/audio** filters when relevant.
- Tune **system prompt**, **max output tokens**, and sampling parameters; attach **guardrails** and **prompt caching** where appropriate.
- For Unity lab environments, use supported models (e.g. **Claude Haiku 4.5** with text + image in, text out, ~200K context).

## How to apply it

**Console path**

1. AWS Console → **Amazon Bedrock** → **Test** → **Playground**.
2. Select model; complete **Anthropic use case** popup if shown (e.g. educational use + URL).
3. Choose **Chat**, **Single prompt**, or **Compare** as supported.
4. Open **configuration**: system prompt, reasoning slider, max tokens, stop sequences, temperature, Top P, guardrails, prompt caching.

**File-grounded Q&A (lecture demo)**

- Upload a document (e.g. club bylaws Word file from course materials).
- Ask: “According to the attached bylaws, what are the forum requirements for an annual election?”

**Cost-aware defaults**

- Lower **max output tokens** to limit verbosity when paying per token via API later.
- Enable **prompt caching** when the same system instructions repeat across many requests.

## Examples

- **Meaning of life**: Baseline chat; then system prompt “Always talk like a pirate” and clear chat to see global behavior change.
- **Bylaws Q&A**: Document upload + targeted question → faster than reading full bylaws manually.
- **Compare Jamba vs Claude**: Same prompt, ~200 output tokens, chat mode on both; observe different answers and pirate system prompt on one side only.
- **Nova Canvas (image)**: Modes include generate image, variations, remove/replace objects or background, virtual try-on, negative prompt (“no blue chickens”), size, palette, conditioning image, prompt strength, **seed** for reproducibility (availability varies at recording time).
- **Modality filters**: Filter playground by image/audio output; legacy image models may not work—experiment with current catalog (e.g. **Nova 2 Sonic** for audio).

## Limitations / edge cases

- **Model-specific UI**: Temperature/Top P grayed out on some models (Haiku); other models differ.
- **Haiku**: May not support **single prompt**; compare mode may require **chat** on both sides.
- **Legacy image models** listed when filtering may be **non-functional** at time of recording.
- **Compare mode**: Do not upload images if the compared model lacks image input support.
- **Prompt routers** choose tier automatically—good for cost/latency, less predictable than picking one model ID.

## Key takeaways

- Playground is the fastest way to learn **model strengths**, **modalities**, and **inference controls** on Bedrock.
- **System prompt**, **reasoning**, and **token limits** directly affect cost and style.
- **Compare mode** needs matched settings for honest evaluation.
- **Guardrails** and **prompt caching** are first-class playground options tied to production APIs.
- Check **model cards** and provider-specific access (Anthropic use case) before labs.

## Industry scenarios

1. **Product manager evaluation**: Compare three foundation models in playground compare mode before engineering commits to Converse API integration.
2. **Legal/compliance review**: Attach guardrails in playground to preview blocked topics and PII handling before customer-facing beta.
3. **Multimodal marketing tool**: Designers prototype Nova Canvas background replacement and brand palette settings before building a Bedrock-backed creative pipeline.

## References

- <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/playgrounds.html">Generate responses in the Amazon Bedrock console playgrounds</a>
- <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/guardrails.html">Amazon Bedrock Guardrails</a>
- <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/prompt-caching.html">Prompt caching for faster model inference</a>
- <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/inference-parameters.html">Inference request parameters and response fields</a>
- [A quick note on model access](../a-quick-note-on-model-access/index.md)
- [More Depth on the Bedrock Converse API](../more-depth-on-the-bedrock-converse-api/index.md)
