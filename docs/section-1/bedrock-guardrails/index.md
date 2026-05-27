# :material-shield-check: Bedrock Guardrails

!!! info "🔒 Exam focus"
    Guardrails filter **prompts and responses** for knowledge bases, agents, and direct inference—know **word vs topic** filters, **PII block vs mask**, and **grounding vs relevance** checks.

## Lecture notes

### What this lecture covers

<a href="https://docs.aws.amazon.com/bedrock/latest/userguide/guardrails-how.html">Amazon Bedrock Guardrails</a> are a core feature for **AI safety, governance, and security**. They provide **content filtering on both prompts and responses** for anything flowing through Bedrock—knowledge bases, agents, or other applications—so you control what users can send in and what the system can send back out.

### Key definitions (from the lecture)

| Term | Definition |
|---|---|
| **Guardrail** | A Bedrock policy that evaluates **inputs and outputs** and blocks, masks, or filters content that violates your rules. |
| **Prompt filtering** | Checking user input **before** it reaches the model (topics, words, PII, attacks, harmful content). |
| **Response filtering** | Checking model output **before** it reaches the user (same policy dimensions on the outbound side). |
| **Word filter** | Block or detect specific **words** (built-in profanity list plus custom words). |
| **Topic filter** | Block or detect entire **topics** (e.g., religion, politics, competitors) you define. |
| **Objectionable content dimensions** | Built-in categories (e.g., hate, bias) with configurable **severity thresholds**. |
| **PII handling** | Automatically **remove** or **mask** personally identifiable information (phone, SSN, address, etc.). |
| **Contextual grounding check** | A guardrail feature that scores whether a response is **grounded in retrieved context** and **relevant to the query**, to help catch hallucinations. |
| **Grounding score** | How similar the response is to **contextual data** retrieved (e.g., from a vector store in RAG). |
| **Relevance score** | How relevant the response is to the **original user query**. |
| **Blocked message response** | The message shown to users when content is filtered (configurable). |

### Key distinctions / comparisons

| Item | Notes |
|---|---|
| **Word vs topic filtering** | **Words** match explicit terms; **topics** use definitions and examples to catch broader subject matter (e.g., “politics”). |
| **Block vs mask (PII)** | **Block** stops the request/response; **mask** replaces sensitive values (e.g., `[ADDRESS]`) so the interaction can continue. |
| **Grounding vs relevance** | **Grounding** compares the answer to **retrieved documents**; **relevance** compares the answer to the **user’s question**. |
| **Guardrails vs token-level redaction** | Guardrails are rich and managed in Bedrock; [Token-Level Redaction](../token-level-redaction/index.md) is a simpler, custom **word-level** filter layer you can add around endpoints. |

### The problem (why you need guardrails)

- Generative apps can accept **unsafe prompts** (jailbreaks, hate speech, policy violations) or emit **unsafe or wrong responses**.
- Without governance, you risk **brand damage**, **compliance failures**, and **PII leakage**.
- RAG systems can **hallucinate** beyond retrieved documents; you need a way to **detect** answers that are not grounded in your data.

### The solution

- Attach a **guardrail** to Bedrock usage (including [Bedrock Knowledge Bases](../bedrock-knowledge-bases/index.md) and agents) so **every prompt and response** is evaluated.
- Combine **harmful-content filters**, **denied topics**, **word lists**, **profanity**, **PII policies**, and optional **contextual grounding** thresholds.
- Configure a **blocked message** so users get a clear, controlled response when content is filtered.
- Tune thresholds knowing you may need to balance **safety vs false positives** (especially for grounding and prompt-attack filters).

### Supported models and integration

- Guardrails work with **text foundation models** today (e.g., Titan, Claude)—**not image models** in the lecture’s timeframe (may change later).
- Can be incorporated into **agents** and **knowledge bases**; guardrails apply automatically to attached resources.
- Also usable via APIs such as <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/guardrails-use.html">InvokeModel, Converse, and ApplyGuardrail</a> (see [More Depth on the Bedrock Converse API](../more-depth-on-the-bedrock-converse-api/index.md)).

### Contextual grounding check (anti-hallucination)

When RAG retrieves context from a vector store, contextual grounding check measures:

1. **Grounding** — Is the response aligned with the **retrieved “ground truth”** chunks? Low grounding suggests the model invented facts not present in your documents.
2. **Relevance** — Is the response **on-topic** for the original query?

You set **thresholds**; responses below them can be **blocked** or **detected**. See <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/guardrails-contextual-grounding-check.html">contextual grounding check</a>.

```
User query → retrieve chunks → LLM answer
                    │                │
                    └──── grounding score (answer vs chunks)
                         relevance score (answer vs query)
```

### Limitations / edge cases

- **Grounding quality depends on retrieval** — If your vector store returns irrelevant chunks, grounding metrics are less meaningful.
- **Not perfect metrics** — Treat thresholds as **tuning knobs**, not guarantees of factual correctness.
- **Multimodal harmful content** — The hands-on lecture notes newer **text + image** harmful-category checks; model support evolves over time.
- **False positives** — Aggressive prompt-attack or grounding settings can block legitimate queries (often **off by default** for that reason).

### Examples

**1. Customer-support chatbot**

Block **competitor names** and **profanity** on input; **mask SSN and credit-card patterns** on output before agents see responses in the CRM.

**2. Internal HR policy assistant (RAG)**

Attach grounding check so answers with **low grounding** against policy PDF chunks are blocked with: “I can only answer from official policy documents.”

**3. Public-facing marketing bot**

Use **denied topics** for politics and religion; set **hate/bias** filters to high; customize blocked message to match brand voice.

### Industry scenarios

**1. Regulated healthcare portal**

A hospital wires guardrails to **mask PHI** on responses and block **medical advice** topics outside approved content, reducing accidental disclosure in a Bedrock-powered triage bot.

**2. Financial services wealth assistant**

The firm denies **investment recommendations** as a topic, enables **PII masking**, and uses **contextual grounding** on filings retrieved from a knowledge base so answers stay tied to SEC documents.

**3. Enterprise software documentation bot**

Product docs are ingested via RAG; grounding thresholds drop answers that cite **features not in retrieved release notes**, while relevance filtering catches answers that drift from the user’s specific API question.

### Key takeaways

- Guardrails filter **both prompts and responses** across Bedrock applications.
- You can filter by **words, topics, objectionable categories, profanity, and PII** (block or mask).
- **Contextual grounding check** adds **grounding** and **relevance** scores to reduce RAG hallucinations—quality still depends on good retrieval.
- Attach guardrails to **agents and knowledge bases**; configure **blocked messages** for filtered interactions.
- Pair guardrails with simpler [Token-Level Redaction](../token-level-redaction/index.md) when you want defense in depth.
- See [Hands-On with Bedrock Guardrails](../hands-on-with-bedrock-guardrails/index.md) for console setup and testing.

### References

**In this repo**

- [Hands-On with Bedrock Guardrails](../hands-on-with-bedrock-guardrails/index.md)
- [Bedrock Guardrails Automated Reasoning Checks](../bedrock-guardrails-automated-reasoning-checks/index.md)
- [Token-Level Redaction](../token-level-redaction/index.md)
- [Bedrock Knowledge Bases](../bedrock-knowledge-bases/index.md)
- [Retrieval-Augmented Generation (RAG)](../retrieval-augmented-generation-rag/index.md)
- [More Depth on the Bedrock Converse API](../more-depth-on-the-bedrock-converse-api/index.md)

**AWS documentation**

- <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/guardrails-how.html">How Amazon Bedrock Guardrails works</a>
- <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/guardrails-components.html">Create your guardrail</a>
- <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/guardrails-contextual-grounding-check.html">Use contextual grounding check to filter hallucinations</a>
- <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/guardrails-sensitive-filters.html">Remove PII with sensitive information filters</a>
- <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/guardrails-prompt-attack.html">Detect prompt attacks</a>
- <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/guardrails-use.html">Use cases for Amazon Bedrock Guardrails</a>
