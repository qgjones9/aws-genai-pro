# Anatomy of a Prompt

## What this lecture covers

Amazon describes a well-formed prompt as four cooperating parts—**instructions**, **context**, **input data**, and an **output indicator**—each shaping how a generative model interprets the task and formats the response. This lecture walks through a dialogue-writing example and recaps how each component maps to the work you ask the model to perform.

## Key definitions (from the lecture)

| Term | Definition |
|---|---|
| **Instructions** | The task you assign the model: what to do and how to approach it (e.g., “Write a short dialogue between two friends about their favorite books”). |
| **Context** | External or situational information that guides the model—setting, tone, or data retrieved from another system (e.g., “two friends in a cozy café on a rainy afternoon,” or examples pulled from a dialogue database). |
| **Input data** | Concrete facts, constraints, or examples the model must weave into the answer (e.g., each friend’s genre preferences, or sample dialogues that demonstrate desired style). |
| **Output indicator** | Constraints on the **type**, **length**, or **style** of the response (e.g., “about 200 words” and “express each friend’s enthusiasm for their genre”). |

See <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/prompt-engineering-guidelines.html">Prompt engineering guidelines for Amazon Bedrock</a> for AWS-aligned terminology.

## Key distinctions / comparisons

| Item | Notes |
|---|---|
| **Context vs input data** | **Context** frames the scene or supplies background knowledge; **input data** is the specific material the model must use or mirror in the output. |
| **Instructions vs output indicator** | **Instructions** define the job; the **output indicator** defines how the finished artifact should look (length, format, tone). |
| **Retrieved context vs inline context** | Context can be written in the prompt or **injected** from an external store (RAG-style retrieval before inference). |

## The problem (why structure matters)

- Vague prompts leave the model guessing role, setting, and format.
- Without **input data**, outputs may ignore facts you care about (character traits, product specs, policy clauses).
- Without an **output indicator**, “short dialogue” or “brief summary” can mean very different lengths and styles run to run.

## The solution: four-part prompt design

**Example prompt (books dialogue)—how the four parts fit together:**

| Component | Example from the lecture |
|---|---|
| **Instructions** | Write a short dialogue between two friends about their favorite books. |
| **Context** | The friends are sitting in a cozy café on a rainy afternoon. (Could also include retrieved sample dialogues from an external database.) |
| **Input data** | Friend one loves fantasy with dragons and magic; friend two prefers mysteries with clever detectives and twists. Optional: paste example dialogues for other friend pairs to teach style. |
| **Output indicator** | Dialogue should be about **200 words** and express each friend’s enthusiasm for their favorite genre. |

```text
Instructions:  Write a short dialogue between two friends about their favorite books.
Context:       Setting — cozy café, rainy afternoon. [Optional: retrieved dialogue snippets.]
Input data:    Friend A → fantasy/dragons; Friend B → mysteries/detectives.
Output:        ~200 words; show enthusiasm for each genre.
```

## Examples

**1. Customer-support reply (AWS / enterprise)**

- **Instructions:** Draft a reply to the customer’s question.
- **Context:** Tone is professional; company return policy applies.
- **Input data:** Order ID, purchase date, reason for return from the ticket.
- **Output indicator:** Under 150 words; bullet the next steps.

**2. RAG-backed internal search**

- **Instructions:** Answer using only the provided excerpts.
- **Context:** Retrieved chunks from a <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/knowledge-base.html">Bedrock Knowledge Base</a>.
- **Input data:** The user’s question.
- **Output indicator:** Cite document titles; if unsure, say “not found in provided context.”

**3. Few-shot style via input data**

Supply two mini-dialogues in **input data** so the model learns pacing and voice before generating a third dialogue for new characters.

## Limitations / edge cases

- **Input data** can include examples, but very long example sets consume context window and cost tokens.
- **Retrieved context** quality depends on retrieval—bad chunks pollute the “context” slot even when instructions are clear.
- **Output indicators** (word counts) are approximate; models may overshoot or undershoot unless you validate and iterate.

## Industry scenarios

**1. Marketing copy team**

A brand manager uses all four parts: instructions to write social copy, context (campaign theme), input data (product features), output indicator (≤280 characters, no hashtags).

**2. HR policy chatbot**

Instructions to answer employees; context from retrieved handbook sections; input data (employee role, state); output indicator (plain language, numbered steps).

**3. Software documentation assistant**

Instructions to explain an API; context from ingested OpenAPI specs; input data (endpoint name, error code); output indicator (markdown with a single code sample).

## Key takeaways

- Treat prompts as **four slots**: task, background, specifics to honor, and output shape.
- **Context** can be narrative or **retrieved** from external systems.
- **Input data** doubles as a place for **few-shot examples** that teach format and style.
- **Output indicators** reduce ambiguity on length, structure, and tone.
- Structured prompts pair well with <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/prompt-management.html">Amazon Bedrock Prompt Management</a> for reuse and versioning.

## References

**In this repo**

- [Intro to Prompt Engineering](../intro-to-prompt-engineering/index.md)
- [Prompt Best Practices](../prompt-best-practices/index.md)
- [Types of Prompts](../types-of-prompts/index.md)
- [Retrieval-Augmented Generation (RAG)](../retrieval-augmented-generation-rag/index.md)

**AWS documentation**

- <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/prompt-engineering-guidelines.html">Prompt engineering guidelines for Amazon Bedrock</a>
- <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/prompt-management.html">Prompt management in Amazon Bedrock</a>
