# Bedrock Prompt Flows

## Lecture notes

### What this lecture covers

<a href="https://docs.aws.amazon.com/bedrock/latest/userguide/flows-how-it-works.html">Amazon Bedrock Flows</a> (formerly emphasized as “prompt flows”) chain **prompts, models, knowledge bases, and logic** into visual, often **low-code** applications. Flows connect **nodes** with **data links** and optional **conditional branches**, using saved prompts from [Amazon Bedrock Prompt Management](../amazon-bedrock-prompt-management/index.md).

### Key definitions (from the lecture)

| Term | Definition |
|---|---|
| **Flow** | A Bedrock application graph: **nodes** + **connections** that process inputs into outputs. |
| **Node** | A step such as **flow input**, **prompt**, **knowledge base retrieval**, **condition**, or **flow output**. |
| **Connection** | Data path between nodes (what field feeds the next step). |
| **Conditional connection** | Branching path based on a **condition** (e.g., route “documentation” vs “other”). |
| **Flow Builder** | Console visual designer to build flows **without code** (API/JSON alternative exists). |
| **Flow input / output** | Entry and exit points; input can be **raw text** or **structured fields** (genre, number). |
| **Saved prompt node** | A node that invokes a **versioned prompt** from Prompt Management with mapped variables. |
| **Knowledge base node** | Retrieves context from a Bedrock knowledge base and passes it downstream. |
| **Condition node** | Routes execution based on prior node output (e.g., classification result). |

### Key distinctions / comparisons

| Item | Notes |
|---|---|
| **Flows vs single InvokeModel call** | Flows orchestrate **multi-step** logic (retrieve → classify → branch → answer). |
| **Flows vs agents** | Lecture positions flows as stepping toward **agentic** systems; agents are covered more deeply later—flows are **composer graphs** you design explicitly. |
| **Visual builder vs API** | Same flow definable in console or **JSON via API** for CI/CD (<a href="https://docs.aws.amazon.com/bedrock/latest/userguide/flows-code-ex.html">code samples</a>). |
| **Unstructured vs structured input** | Flow input can be a single string **or** named fields wired into `{{variables}}`. |

### The problem (why you need it)

- Real apps rarely need **one prompt**—they need retrieval, routing, and multiple models.
- Hard-coding orchestration in Lambdas is slow to iterate; product owners need a **visual** path to prototype.

### The solution

**Simple playlist flow (lecture):**

```
Flow input (genre, number)
    │
    ▼
Saved prompt "music-playlist" → foundation model
    │
    ▼
Flow output (playlist text)
```

**Simple RAG flow (lecture diagram):**

```
Flow input (user query)
    │
    ▼
Knowledge base retrieval
    │
    ▼
Flow output
```

**Conditional documentation router (lecture):**

```
Flow input (raw user text)
    │
    ▼
Saved prompt: classify intent
    │
    ▼
Condition node
    ├─ if "documentation" → Knowledge base node → output
    └─ else → Saved prompt: general professional answer → output
```

- **Pre/post-processing** can be enforced because inputs/outputs are **structured** across nodes.
- Saved prompts act as **reusable components** inside larger graphs.

### How to apply it

1. Publish prompts in **Prompt Management** (e.g., `music-playlist` v1, classifier prompt).
2. **Build → Flows → Create flow** in console (Flow Builder).
3. Add **input** node; define fields (`genre`, `number`) or raw text.
4. Add **prompt** node; select saved prompt; map input fields to `{{variables}}`.
5. Add **output** node; connect model completion.
6. For branching: add **condition** node after a **classification prompt**; wire true/false paths to KB vs general prompt.
7. Test in builder; deploy/alias per <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/flows-get-started.html">getting started guide</a>.

### Examples

**1. Playlist generator (structured input)**

User supplies `genre=vocal jazz`, `number=10`; flow passes into saved prompt; output is ten-track list (demo screenshot in lecture).

**2. Doc vs chit-chat router**

Classifier prompt labels intent; documentation path hits [Bedrock Knowledge Bases](../bedrock-knowledge-bases/index.md); other path uses a generic professional-response prompt.

**3. API-driven flow in CI**

Team exports flow JSON, versions it in Git, and uses `CreateFlow` / `InvokeFlow` in staging pipelines.

### Limitations / edge cases

- **Complexity creep** — Conditional graphs need clear **classification labels** and test cases to avoid wrong branches.
- **Not a full agent framework** — Tool use, memory, and autonomous planning live in richer agent patterns (later course material).
- **Guardrails** — Attach guardrails to flows where required (<a href="https://docs.aws.amazon.com/bedrock/latest/userguide/flows-guardrails.html">flows guardrails</a>).

### Industry scenarios

**1. IT service desk**

Flow classifies tickets (password reset vs how-to doc); documentation intents query an internal KB; others get a templated escalation message.

**2. E-commerce shopping assistant**

Structured input (`product_sku`, `customer_tier`) feeds variant prompts; VIP branch adds loyalty copy before output.

**3. Media company research tool**

Journalists submit a story idea string; router sends entertainment topics to one KB, finance topics to another, via conditional prompts.

### Key takeaways

- Bedrock Flows = **nodes + connections**, with optional **conditional routing**.
- Use **Flow Builder** for no-code orchestration or the **Flows API** for programmatic control.
- **Saved prompts** from Prompt Management are first-class flow components.
- Inputs can be **structured** (mapped to prompt variables), enabling pre/post processing patterns.
- Conditional flows combine **classification prompts**, **knowledge bases**, and **general prompts** for multi-path apps.

### References

**In this repo**

- [Amazon Bedrock Prompt Management](../amazon-bedrock-prompt-management/index.md)
- [Bedrock Knowledge Bases](../bedrock-knowledge-bases/index.md)
- [Bedrock Guardrails](../bedrock-guardrails/index.md)
- [Enforcing Use of Structured Data](../enforcing-use-of-structured-data/index.md)

**AWS documentation**

- <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/flows-how-it-works.html">How Amazon Bedrock Flows works</a>
- <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/flows-get-started.html">Create your first flow</a>
- <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/flows-create.html">Create and design a flow</a>
- <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/key-definitions-flow.html">Key definitions for Amazon Bedrock Flows</a>
- <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/flows-code-ex.html">Run Amazon Bedrock Flows code samples</a>
- <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/flows-guardrails.html">Include guardrails in your flow</a>
