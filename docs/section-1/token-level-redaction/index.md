# Token-Level Redaction

## Lecture notes

### What this lecture covers

When <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/guardrails-how.html">Bedrock Guardrails</a> are not enough—or you want a **simpler, deterministic** safety layer—**token-level redaction** filters text **before** it reaches the model or **right before** it reaches the end user. Despite the name, the lecture means **word-by-word (or pattern-based) text filtering**, not transformer **token IDs**.

### Key definitions (from the lecture)

| Term | Definition |
|---|---|
| **Token-level redaction** | A **custom filtering layer** around your GenAI pipeline that redacts or blocks words/patterns on **input and/or output**. |
| **Input filter** | Stops or scrubs content **before** inference—can avoid calling the model at all. |
| **Output filter** | Last-chance scrub **before** the user sees the response. |
| **Pre-processing handler** | Lambda (or similar) that runs **before** the inference endpoint processes a request. |
| **Post-processing handler** | Lambda that runs **after** inference, before returning to the client. |
| **Pattern recognition** | Simple approach: **regular expressions** or word lists (“naughty words”). |
| **Named entity recognition (NER)** | Richer approach: detect entities (e.g., PII) with services like <a href="https://docs.aws.amazon.com/comprehend/latest/dg/how-pii.html">Amazon Comprehend Detect PII</a>. |

### Key distinctions / comparisons

| Item | Notes |
|---|---|
| **Guardrails vs token-level redaction** | Guardrails are **managed, multi-policy** Bedrock features; redaction is **bring-your-own** logic—simpler, sometimes more predictable, extra ops burden. |
| **Model tokens vs “tokens” in this lecture** | Lecture filters **human-readable text**; not embedding/tokenizer vocabulary units. |
| **Regex vs Comprehend** | Regex/word lists are **fast and simple**; Comprehend is **more robust** for PII/entities but adds **latency, cost, and complexity**. |
| **Inference-time vs ingestion-time** | Same filters can run on **live requests** or on **documents** while building training sets or **vector stores**. |

### The problem (why you need it)

- Guardrails are powerful but **complex**; edge cases can slip through or surprise you with false positives/negatives.
- You may need a **defense-in-depth** layer you fully control (compliance word lists, proprietary codenames, etc.).
- Blocking bad input **early** saves **model cost** and reduces risk of processing malicious prompts.

### The solution

Wrap your inference endpoint (Bedrock, SageMaker, etc.) with **pre- and post-processing handlers**:

```
Client request
    │
    ▼
Pre-processing Lambda  ──► filter / redact input
    │
    ▼
Foundation model (Bedrock / SageMaker endpoint)
    │
    ▼
Post-processing Lambda ──► filter / redact output
    │
    ▼
Client response
```

- Implement filters as **regex**, blocklists, or **Comprehend** NER/PII calls.
- Optionally apply the **same filters during data ingestion** for RAG indexes or fine-tuning corpora.

### How to apply it

**Pattern-based pre-filter (conceptual Python on Lambda):**

```python
import re

BLOCKLIST = re.compile(r"\b(secret_project|internal_only)\b", re.I)

def pre_process(event):
    text = event["prompt"]
    if BLOCKLIST.search(text):
        return {"blocked": True, "message": "Request not allowed."}
    return {"prompt": text}
```

**Comprehend PII on output (high level):**

- Call `DetectPiiEntities` on model output; replace or block spans before returning to the client (see <a href="https://docs.aws.amazon.com/comprehend/latest/dg/how-pii.html">Detecting PII entities</a>).

On SageMaker, pre/post processing is commonly implemented via <a href="https://docs.aws.amazon.com/sagemaker/latest/dg/deploy-model.html">inference endpoints</a> with companion Lambda or container hooks; on Bedrock, pair **custom APIs** or **proxy Lambdas** in front of `Converse`/`InvokeModel`.

### Examples

**1. Regex blocklist on ingress**

A gaming company blocks slurs and cheat phrases in user chat **before** Bedrock is invoked—zero tokens spent on blocked prompts.

**2. Comprehend on egress**

Support bot responses run through **PII detection**; account numbers are redacted even if the model quoted them from a bad retrieval hit.

**3. Ingestion-time scrubbing**

Documents loaded into OpenSearch for RAG are passed through the same profanity/PII filters so **indexed chunks** never contain raw SSNs.

### Limitations / edge cases

- **Regex brittleness** — Evasion via spelling variants, unicode homoglyphs, or multilingual input.
- **Comprehend coverage** — Language and entity-type limits; not a substitute for legal/compliance review.
- **Operational overhead** — You own monitoring, versioning, and latency of extra Lambdas.
- **Does not replace guardrails** — Best used **together** with [Bedrock Guardrails](../bedrock-guardrails/index.md) for layered safety.

### Industry scenarios

**1. Media streaming chat during live events**

A regex layer blocks **spoilers and slurs** instantly at peak traffic; guardrails handle broader harm categories on model output.

**2. Legal discovery assistant**

Custom redaction removes **privileged terms** and matter IDs from prompts and responses; Comprehend catches person names the firm must not echo.

**3. Manufacturing IoT copilot**

Ingestion filters strip **serial numbers and plant codes** from maintenance PDFs before embedding; live queries use the same patterns post-model.

### Key takeaways

- Token-level redaction here means **simple, controllable text filtering** on input, output, or **ingestion**.
- Use **Lambda pre/post handlers** around Bedrock or SageMaker inference endpoints.
- Choose **regex/word lists** for speed or **Comprehend** for richer entity/PII detection.
- Treat it as **defense in depth** when guardrails alone are not enough or not sufficient.
- Apply filters when **populating vector stores** to keep retrieved context clean.

### References

**In this repo**

- [Bedrock Guardrails](../bedrock-guardrails/index.md)
- [Hands-On with Bedrock Guardrails](../hands-on-with-bedrock-guardrails/index.md)
- [Pre-Retrieval and Chunking Strategies](../pre-retrieval-and-chunking-strategies/index.md)
- [Bedrock Knowledge Bases](../bedrock-knowledge-bases/index.md)

**AWS documentation**

- <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/guardrails-how.html">How Amazon Bedrock Guardrails works</a>
- <a href="https://docs.aws.amazon.com/comprehend/latest/dg/how-pii.html">Detecting PII entities (Amazon Comprehend)</a>
- <a href="https://docs.aws.amazon.com/comprehend/latest/dg/how-entities.html">Entities (Amazon Comprehend)</a>
- <a href="https://docs.aws.amazon.com/sagemaker/latest/dg/deploy-model.html">Deploy models for inference (SageMaker AI)</a>
