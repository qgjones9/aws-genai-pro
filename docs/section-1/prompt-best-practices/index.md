# Prompt Best Practices

## What this lecture covers

Amazon’s recommended **prompt engineering** habits: write clearly, add context, specify response shape, place format constraints at the **end** of the prompt, ask questions when possible, supply **examples**, decompose hard work, use **chain-of-thought** when needed, and **experiment** because models are non-deterministic and evolving.

## Key definitions (from the lecture)

| Term | Definition |
|---|---|
| **Clear and concise prompting** | State the task tightly; extra vague wording gives the model room to misinterpret. |
| **Desired response type** | Explicit format rules (e.g., each line ≤ two sentences) instead of fuzzy words like “short.” |
| **Output-at-end placement** | Putting format/length constraints **last** in the prompt so the model’s final focus aligns with how you want the answer structured. |
| **Chain-of-thought (CoT) prompting** | Asking the model to “think step by step” so it breaks problems into subtasks (closest current LLMs get to reasoning). |

## Key distinctions / comparisons

| Item | Notes |
|---|---|
| **Vague vs specific** | “Write something about books… make it interesting” vs “Write a short dialogue between two friends discussing their favorite books.” |
| **Statement vs question** | “Explain the benefits of exercise.” vs “What are the benefits of regular exercise?”—questions may better match Q&A patterns in training data. |
| **Zero guidance vs few-shot examples** | “Determine sentiment” alone vs examples that teach labels **and** output format (`positive` / `negative` only). |
| **One-shot complex task vs subtasks** | Asking for an entire system in one prompt vs splitting into steps the **human** reasons through first. |

## The problem (why best practices matter)

- Wordy, ambiguous prompts increase variance and wrong interpretations.
- LLMs today are **weak at open-ended multi-step reasoning** for large, compound tasks.
- Models are **non-deterministic**—the same prompt can yield different quality on different runs or model versions.

## The solution: Amazon’s recommended practices

| Practice | What to do (lecture) |
|---|---|
| **Be clear and concise** | Prefer tight task statements over rambling requests. |
| **Include context** | Say *where* output will be used (e.g., “for a movie script”) so tone and structure fit. |
| **Specify response type** | Replace “short” with measurable rules (e.g., each line ≤ two sentences). |
| **Put desired output at the end** | Repeat format/length constraints as the **final** lines of the prompt. |
| **Phrase input as a question** | Use “What are…?” style when seeking factual Q&A-style answers. |
| **Provide example responses** | Show input → expected output pairs; teaches **task** and **format** (useful for quasi-structured extraction). |
| **Break up complex tasks** | You do the reasoning; prompt each subtask separately. |
| **Keep it simple / CoT** | Ask “do you understand?” sparingly; prefer “think step by step” for decomposition. |
| **Experiment** | Try variants; track what new model versions handle well or poorly. |

### Sentiment example (few-shot + structured output)

```text
Determine the sentiment of the following sentence using these examples:
"I had a great time at the park today" → positive
"That restaurant had terrible service" → negative

Sentence: "The flight was delayed but the crew was helpful."
```

Because examples show **only** the words `positive` or `negative`, the model learns both classification and **output shape**—a practical way to get structured fields from an LLM.

### Chain-of-thought nudge

```text
Plan the migration steps for moving a monolith API to Lambda.
Think step by step, starting with inventorying endpoints, then grouping domains, then defining cutover order.
```

## Examples

**1. Dialogue for a screenplay**

Bad: “Write something about books, two people, make it interesting.”  
Better: “Write a short dialogue **to be used in a movie script** between two friends discussing their favorite books, where each line is no more than two sentences.”

**2. Structured extraction**

Use labeled examples so the model returns exactly `SKU-12345` style IDs, not prose explanations.

**3. Complex engineering task**

Instead of “build the whole microservice,” prompt: (1) list API endpoints, (2) draft OpenAPI for one endpoint, (3) generate handler skeleton—each as its own call.

## Limitations / edge cases

- **“Think step by step”** helps but is not guaranteed reasoning; verify outputs on critical paths.
- **Questions** help Q&A-style tasks but are not magic for every task type (e.g., code generation).
- **Examples** consume tokens; balance count vs context window.
- **Non-determinism** means regression-test prompts when you upgrade models.

## Industry scenarios

**1. Content operations**

Editors standardize prompts with context (“LinkedIn post for B2B SaaS”) and line limits at the end; A/B test two phrasings because Claude vs Titan behave differently.

**2. Support triage bot**

Break workflow: classify intent → retrieve policy chunk → draft reply—three prompts instead of one “do everything” message.

**3. Data labeling pipeline**

Few-shot sentiment (or category) examples in prompts produce CSV-friendly single-token labels without training a custom classifier.

## Key takeaways

- **Specificity beats cleverness**—context, format, and length should be explicit.
- **Examples** teach both semantics and **output format** (valuable for light structuring).
- **Decompose** complex work; LLMs should not be your only reasoning engine today.
- **Chain-of-thought** can elicit stepwise plans when you cannot pre-split tasks yourself.
- **Experiment continuously** as models and pricing change—see <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/prompt-engineering-guidelines.html">Bedrock prompt engineering guidelines</a>.

## References

**In this repo**

- [Anatomy of a Prompt](anatomy-of-a-prompt/index.md)
- [Types of Prompts](types-of-prompts/index.md)
- [Intro to Prompt Engineering](intro-to-prompt-engineering/index.md)
- [Enforcing Use of Structured Data](enforcing-use-of-structured-data/index.md)

**AWS documentation**

- <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/prompt-engineering-guidelines.html">Prompt engineering guidelines for Amazon Bedrock</a>
- <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/conversation-inference.html">Carry out a conversation with the Converse API</a>
