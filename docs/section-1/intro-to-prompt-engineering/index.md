# Intro to Prompt Engineering

## Lecture notes

### What this lecture covers

**Prompt engineering** is the practice of asking generative AI systems **clearly and completely** so you get better, safer, and more capable results. The lecture defines core benefits, distinguishes “classic” prompting from **RAG** and **agents** (covered later with AWS services), and frames the goal as **quality in → quality out**.

### Key definitions (from the lecture)

| Term | Definition |
|---|---|
| **Prompt engineering** | The art and science of **how you phrase requests** to generative AI—detail and structure materially change outputs. |
| **Generative AI / chat applications** | Interactive systems where the user’s **wording** steers the model each turn. |
| **Retrieval-Augmented Generation (RAG)** | Augmenting prompts with **retrieved context** from your documents/vector store before the model answers (see [RAG](../retrieval-augmented-generation-rag/index.md)). |
| **LLM agents** | Systems that combine prompts with **tools** and multi-step reasoning to act on external data/services. |
| **Domain knowledge augmentation** | Supplying proprietary facts via retrieval or tools **without fine-tuning** model weights. |
| **External tools** | Functions/APIs (weather, internal CRM, MCP servers) the model may call when the prompt ecosystem exposes them. |
| **Garbage in, garbage out** | Poor prompts → poor answers; strong prompts → higher-quality outputs. |

### Key distinctions / comparisons

| Item | Notes |
|---|---|
| **Prompt engineering vs fine-tuning** | Prompting (and RAG/tools) augments behavior **without changing weights**; fine-tuning updates the model itself ([Fine-Tuning in Bedrock](../fine-tuning-foundation-models-in-bedrock/index.md)). |
| **Classic prompting vs RAG** | Classic = what you write in the message; RAG = **lookup + inject context** from your data stores first. |
| **Prompting vs agents** | Agents add **tool loops** and orchestration; AWS course material groups them under broad “prompt engineering” but implementation is taught with Bedrock services later. |
| **Safety via prompting vs guardrails** | Prompts can instruct “don’t leak secrets”; [Bedrock Guardrails](../bedrock-guardrails/index.md) enforce policies systematically. |

### The problem (why you need it)

- The same model can appear brilliant or useless depending on **how the question is asked**.
- Vague prompts waste tokens, confuse users, and increase **unsafe or off-topic** answers.
- Teams need a shared discipline before diving into RAG, agents, and managed prompts.

### The solution (benefits of effective prompting)

| Benefit | How prompting helps |
|---|---|
| **Boost model abilities** | Detailed instructions unlock tasks the model seemed unable to do with terse prompts. |
| **Improve safety** | Explicit rules (“do not provide medical advice”, “redact secrets”) steer behavior before infrastructure guardrails. |
| **Augment with domain knowledge** | RAG/agents inject **your** documents and live data without retraining. |
| **Explore capabilities** | Experimentation reveals strengths/weaknesses of each model generation. |
| **Better outputs** | Higher-quality inputs raise answer quality (inverse of garbage in/out). |

### How RAG and agents relate (high level)

**RAG (lecture mental model):**

```
User question
    → retrieve relevant chunks from vector store
    → build augmented prompt (question + context)
    → foundation model → answer grounded in your data
```

**Agents / tools (lecture mental model):**

```
User question
    → model decides a tool might help (weather API, internal lookup)
    → tool executes → results folded into final answer
```

The instructor defers **service-level implementation** to later lectures ([Bedrock Knowledge Bases](../bedrock-knowledge-bases/index.md), agents section) but introduces the concepts here because AWS training groups them under prompt engineering broadly.

### Examples

**1. Vague vs specific**

- Weak: “Summarize this.”
- Strong: “Summarize in three bullet points for an executive, under 100 words, focusing on risks and deadlines.”

**2. Safety clause**

“Answer using only the provided context; if unsure, say you don’t know”—reduces hallucination tendency before RAG/guardrails.

**3. Tool-aware instruction**

“If you need current weather, call the `get_weather` tool with city name; do not guess.”—sets expectations for agentic flows later.

### Limitations / edge cases

- **Prompting alone is not governance** — Production needs guardrails, validation, and monitoring.
- **RAG/agents are not “pure” prompt engineering** — They are **system patterns** built around prompts; treat this lecture as conceptual framing.
- **Model drift** — What works on one model/family may need retuning on another ([Prompt Best Practices](../prompt-best-practices/index.md), [Types of Prompts](../types-of-prompts/index.md)).

### Industry scenarios

**1. Legal contract review assistant**

Lawyers use meticulously structured prompts for clause extraction; later RAG over firm precedents augments without fine-tuning a foundation model.

**2. Retail chatbot MVP**

Prompt engineering gets a workable prototype; the team later adds [Knowledge Bases](../bedrock-knowledge-bases/index.md) for catalog facts and guardrails for PII.

**3. Field-service mobile agent**

Technicians ask natural-language questions; agent prompts plus tool access pull parts inventory from SAP while keeping instructions to stay within approved repair steps.

### Key takeaways

- **How you ask matters**—prompt engineering is foundational for every GenAI app.
- Benefits span **quality, safety, capability discovery**, and **domain augmentation** without fine-tuning.
- **RAG** adds retrieved context; **agents** add tools—both extend prompting into full systems (detailed later on AWS).
- Aim for **clear, detailed, contextual** prompts; avoid garbage in, garbage out.
- Follow-on topics: [Anatomy of a Prompt](../anatomy-of-a-prompt/index.md), [Prompt Best Practices](../prompt-best-practices/index.md), [Enforcing Use of Structured Data](../enforcing-use-of-structured-data/index.md).

### References

**In this repo**

- [Anatomy of a Prompt](../anatomy-of-a-prompt/index.md)
- [Prompt Best Practices](../prompt-best-practices/index.md)
- [Types of Prompts](../types-of-prompts/index.md)
- [Retrieval-Augmented Generation (RAG)](../retrieval-augmented-generation-rag/index.md)
- [Bedrock Knowledge Bases](../bedrock-knowledge-bases/index.md)
- [Amazon Bedrock Prompt Management](../amazon-bedrock-prompt-management/index.md)
- [Bedrock Guardrails](../bedrock-guardrails/index.md)

**AWS documentation**

- <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/prompt-engineering-guidelines.html">Prompt engineering concepts</a>
- <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/what-is-prompt-engineering.html">What is prompt engineering?</a>
- <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/knowledge-base.html">Knowledge Bases for Amazon Bedrock</a>
- <a href="https://docs.aws.amazon.com/bedrock/latest/APIReference/API_runtime_Converse.html">Converse API</a>
