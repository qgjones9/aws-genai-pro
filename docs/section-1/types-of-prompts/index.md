# Types of Prompts

## What this lecture covers

Three widely used prompting patterns—**zero-shot**, **few-shot**, and **chain-of-thought (CoT)**—including when each fits, how few-shot teaches **format** as well as **task**, and how CoT combines “think step by step” with **explicit step guidance** (quadratic formula example).

## Key definitions (from the lecture)

| Term | Definition |
|---|---|
| **Zero-shot prompting** | No in-prompt examples; the model relies on prior training to interpret the task (e.g., “Determine the sentiment of the following sentence” with no labeled samples). |
| **Few-shot prompting** | One or more input→output examples in the prompt; more examples steer classification **and** response format. |
| **Chain-of-thought prompting** | Instructing the model to reason in steps—often “think step by step”—sometimes plus enumerated substeps you define. |

## Key distinctions / comparisons

| Item | Notes |
|---|---|
| **Zero-shot vs few-shot** | Zero-shot when the model already “knows” the task from training; few-shot when you need custom labels, niche domains, or strict output shape. |
| **Implicit vs explicit CoT** | “Think step by step” alone vs listing substeps (standard form → identify coefficients → apply formula)—explicit guidance reduces bad decompositions. |
| **Classification vs procedure** | Sentiment is a classic few-shot/zero-shot task; multi-step math benefits from CoT with named stages. |

## The problem (why prompt type matters)

- Some tasks are **under-specified** in zero-shot (unusual labels, proprietary schemas).
- Large compound problems fail when the model tries to **jump to the answer** without intermediate structure.
- Without examples, the model may return **prose** when you need **tokens** like `positive` / `negative`.

## The solution: choose the right pattern

### Zero-shot

Use when training likely covered the task:

```text
Determine the sentiment of the following sentence:
"The keynote exceeded our expectations."
```

Works when the model is **large enough** and the task is **common** (e.g., generic sentiment).

### Few-shot

Supply examples that teach **both** meaning and format:

```text
Determine the sentiment of the following sentence using these examples:
"I had a great time at the park today" → positive
"That restaurant had terrible service" → negative

"The software update fixed my crash." →
```

More examples → stronger steering (at higher token cost).

### Chain-of-thought with explicit steps

```text
Describe how to solve a quadratic equation using the quadratic formula.
Think step by step, starting with the standard form of a quadratic equation,
identifying the coefficients, then applying the quadratic formula.
Include an example equation and solve it.
```

**Two mechanisms in one prompt:**

1. **“Think step by step”** — encourages decomposition instead of one-shot answers.
2. **Named substeps** — you do not fully trust the model to invent the right solution outline.

Lecture outcome: the model can show each stage and solve a concrete numeric example—often **worse** if you omit the step-by-step instruction.

## Examples

**1. Zero-shot policy classification**

“Classify this ticket as Billing, Technical, or Account without examples.” Acceptable when categories are standard and the model knows them.

**2. Few-shot JSON extraction**

Three `invoice text → {"total": ..., "currency": ...}` pairs teach field names and JSON-only answers.

**3. CoT for incident response**

“Think step by step: confirm blast radius, identify rollback target, draft customer comms, list verification checks.”

## Limitations / edge cases

- **Zero-shot** fails on bespoke taxonomies or rare languages/domains.
- **Few-shot** examples can **bias** the model toward spurious patterns in your samples.
- **CoT** increases latency and tokens; steps may still be **wrong**—verify on high-stakes math or compliance tasks.
- Models may **hallucinate** intermediate work; explicit substeps help but do not guarantee correctness.

## Industry scenarios

**1. Retail review analytics**

Start zero-shot on star-rated reviews; switch to few-shot when labeling “shipping delay vs product defect” with company-specific definitions.

**2. Financial spreads parsing**

Few-shot table snippets teach the model to emit fixed-column CSV for downstream ETL.

**3. Engineering runbooks**

CoT prompts walk junior engineers through diagnosis trees for production alerts, with mandated checkpoints (metrics → logs → recent deploys).

## Key takeaways

- Know **zero-shot**, **few-shot**, and **chain-of-thought**—exam and real designs reference all three.
- **Few-shot** shapes **format** as much as **semantics** (sentiment → single word).
- **CoT** = decomposition cue + optional **explicit step list** for harder procedural tasks.
- Match pattern to **task familiarity** and **output structure** requirements.
- Bedrock applications often combine patterns with RAG—see [Retrieval-Augmented Generation (RAG)](../retrieval-augmented-generation-rag/index.md).

## References

**In this repo**

- [Prompt Best Practices](../prompt-best-practices/index.md)
- [Anatomy of a Prompt](../anatomy-of-a-prompt/index.md)
- [Prompt Misuse and Mitigating Bias](../prompt-misuse-and-mitigating-bias/index.md)

**AWS documentation**

- <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/prompt-engineering-guidelines.html">Prompt engineering guidelines for Amazon Bedrock</a>
- <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/knowledge-base.html">Retrieve data and generate responses with knowledge bases</a>
