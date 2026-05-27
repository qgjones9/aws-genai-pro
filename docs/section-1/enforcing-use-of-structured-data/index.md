# Enforcing Use of Structured Data

## Lecture notes

### What this lecture covers

Generative apps often need **machine-readable output** (especially **JSON**), not free-form prose. The lecture covers two Bedrock-friendly approaches: **explicit prompt instructions with a JSON schema** and **tool use via the Converse API**—plus certification terminology (**response format template**) and how modern models compare on reliability.

### Key definitions (from the lecture)

| Term | Definition |
|---|---|
| **Structured data (output)** | Responses shaped as JSON or other schemas your downstream code can parse and act on. |
| **Prompt-based JSON** | Asking the model in natural language to return JSON, with **numbered steps**, **examples**, and an attached **JSON schema**. |
| **JSON schema (in prompt)** | A reference schema the model should follow; missing fields → `null`; total failure → **error response** object. |
| **Tool calling** | Model emits **structured arguments** intended for an external function/API (agentic pattern). |
| **Tool use (Converse API)** | <a href="https://docs.aws.amazon.com/bedrock/latest/APIReference/API_runtime_Converse.html">Converse</a> `toolConfig` declares tools/schemas the model may invoke. |
| **Response format template** | Exam term for supplying a **specific output schema** the model must adhere to (same idea as schema-driven JSON in the prompt). |

### Key distinctions / comparisons

| Item | Notes |
|---|---|
| **Prompt-only vs tool calling** | Lecture: for **modern models**, both are similarly reliable for “just give me JSON”; tool calling shines when building **real agentic systems** with external tools. |
| **Older vs modern models** | Smaller/older models benefited more from tool-use framing; **current models** often follow explicit prompt schemas equally well. |
| **Structured output vs RAG** | Structured output is about **response shape**; [RAG](../retrieval-augmented-generation-rag/index.md) is about **injecting context**—orthogonal but composable. |
| **Fake tool vs real tool** | You can define a tool whose only job is to **emit structured data** you capture—even if no external API exists. |

### The problem (why you need it)

- Downstream services (databases, workflows, UIs) require **fields** like `review_id`, `sentiment`, `summary`—not paragraphs.
- Free-text answers force fragile parsing and cause **integration bugs**.
- Agent frameworks need **typed parameters** to call APIs, MCP servers, or Lambdas safely.

### The solution

#### Approach A — Prompt with schema and example (lecture pattern)

Be **specific**:

1. Numbered instructions (analyze review inside tags, return JSON, use schema, nulls for missing fields, error object on failure).
2. **Example JSON** showing valid output shape.
3. Attach the **JSON schema** again in the prompt (redundancy helps compliance).

Example shape from the lecture:

```json
{
  "review_id": "123",
  "sentiment": "positive",
  "summary": "Great battery life."
}
```

#### Approach B — Tool use via Converse API

- Declare a tool with the **desired parameter schema** in `toolConfig`.
- Model returns **tool input** matching that schema—even if the “tool” only logs or stores the payload.
- Natural fit for [agentic](../intro-to-prompt-engineering/index.md) apps that already expose real tools.

See [More Depth on the Bedrock Converse API](../more-depth-on-the-bedrock-converse-api/index.md) for `toolConfig` and guardrail hooks.

### How to apply it

**Prompt-first (conceptual template):**

```text
1. Analyze the review between <review>...</review>.
2. Return JSON only, matching the schema below.
3. Use null for missing fields; if impossible, return {"error": "..."}.

Example output:
{"review_id": "...", "sentiment": "...", "summary": "..."}

Schema:
{ ... JSON Schema here ... }
```

**Tool-first (conceptual):**

- Define tool `record_sentiment` with properties `review_id`, `sentiment`, `summary`.
- Invoke Converse with `toolConfig`; read structured `toolUse` input from the response.

### Examples

**1. Product review analytics pipeline**

E-commerce ingests star ratings via a prompt+schema; Lambda writes rows to DynamoDB without regex-parsing prose.

**2. Agent that calls a pricing API**

Tool schema requires `sku` and `region`; model must populate both before the workflow invokes the real pricing Lambda.

**3. Certification-style question**

“If you need JSON from a model in Bedrock, can you?” → **Yes**, via explicit **response format template** / schema prompt or tool use.

### Limitations / edge cases

- **Leap of faith on prompts alone** — Still validate JSON in code (`json.loads`, schema validators); models can drift on edge cases.
- **Exam vs engineering** — Exam stresses that structured JSON **is achievable**; production still needs **retries and validation**.
- **Tool overhead** — Defining tools adds ceremony when you only need a one-shot JSON blob (prompt may suffice on modern models).

### Industry scenarios

**1. Customer sentiment dashboard**

Marketing automation requires `{sentiment, summary}` per review; schema prompts feed BI tools without human relabeling.

**2. IT automation agent**

Service desk agent uses tool schemas to open tickets (`priority`, `category`, `system_id`) before calling ServiceNow APIs.

**3. Loan underwriting copilot**

Underwriters need structured `{risk_flags[], recommended_action}`; JSON schema in prompt aligns with compliance storage; nulls mark missing applicant fields.

### Key takeaways

- You can enforce **JSON structured output** in Bedrock—critical for integrations and the certification exam.
- **Be explicit**: numbered steps, examples, and an attached **JSON schema** (response format template).
- **Tool use** via Converse matches agentic architectures; for plain JSON on modern models, prompt vs tool is often a **wash**.
- Always **validate** structured output in application code.
- Pair with [Intro to Prompt Engineering](../intro-to-prompt-engineering/index.md) and Converse API depth for full stack design.

### References

**In this repo**

- [More Depth on the Bedrock Converse API](../more-depth-on-the-bedrock-converse-api/index.md)
- [Intro to Prompt Engineering](../intro-to-prompt-engineering/index.md)
- [Bedrock Prompt Flows](../bedrock-prompt-flows/index.md)
- [Amazon Bedrock Prompt Management](../amazon-bedrock-prompt-management/index.md)

**AWS documentation**

- <a href="https://docs.aws.amazon.com/bedrock/latest/APIReference/API_runtime_Converse.html">Converse API</a>
- <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/bedrock-runtime_example_bedrock-runtime_Converse_AmazonNovaText_section.html">Converse API examples</a>
- <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/conversation-inference.html">Inference using Converse API (tool use)</a>
