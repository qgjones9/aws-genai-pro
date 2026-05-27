# Amazon Bedrock Prompt Management

## Lecture notes

### What this lecture covers

<a href="https://docs.aws.amazon.com/bedrock/latest/userguide/prompt-management-create.html">Amazon Bedrock Prompt Management</a> lets you **create, version, test, and reuse** prompts across applications—so specialized instructions are not copy-pasted into every service. Prompts support **variables**, **variants**, optional **tools and caching**, and integration with <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/flows-how-it-works.html">Bedrock Flows</a>.

### Key definitions (from the lecture)

| Term | Definition |
|---|---|
| **Prompt management** | Built-in Bedrock capability to store prompts centrally and share them across apps. |
| **Variable / placeholder** | Dynamic slot in a prompt, written as `{{genre}}`, `{{number}}` (double curly braces). |
| **Prompt variant** | A tweak of the same prompt for a **specific model** or **inference configuration**. |
| **Prompt builder** | Console tool under **Build → Prompt Management** to author and test prompts. |
| **Draft vs version** | Save work-in-progress as **draft**; **publish a version** for stable consumption by flows/APIs. |
| **Deploy (prompt)** | Make a tested prompt configuration available for production use (paired with versioning in the demo). |
| **System instructions** | Optional system-role text in the prompt template for additional steering. |

### Key distinctions / comparisons

| Item | Notes |
|---|---|
| **Prompt management vs inline prompts** | Managed prompts give **version history**, **rollback**, and **ARN-based reuse**; inline strings are fine for experiments only. |
| **Variables vs static prompts** | Variables turn a template into an **application-ready** artifact (genre, song count, customer name, etc.). |
| **Variant vs version** | **Version** tracks evolution over time; **variant** targets different models/settings at the same logical prompt. |
| **Prompt vs flow** | Prompt management stores **single templates**; [Bedrock Prompt Flows](../bedrock-prompt-flows/index.md) **chain** prompts, models, and knowledge bases. |

### The problem (why you need it)

- Teams reinvent the same prompts in every microservice, causing **drift** and inconsistent model behavior.
- Prompt tuning is iterative; without versions you cannot **compare** or **roll back** safely.
- Applications need **parameterized** prompts (user-supplied genre, counts, IDs) without string-concatenation bugs.

### The solution

1. Create a prompt in **Prompt Management** (name: letters, hyphens, underscores—**no spaces**).
2. Author template text with `{{variable}}` placeholders and optional system instructions.
3. Associate a **foundation model** and inference settings (max tokens, temperature, stop sequences).
4. Supply **test values** for variables and run **in-console test** (uses selected model).
5. **Save draft**, then **create version** / deploy for use in flows or the <a href="https://docs.aws.amazon.com/bedrock/latest/APIReference/API_runtime_Converse.html">Converse API</a> (prompt ARN as `modelId` per AWS samples).

### How to apply it

**Console flow (lecture demo — music playlist):**

1. **Build → Prompt Management → Create prompt**
2. Name: `music-playlist` (example); description optional; KMS optional.
3. Prompt body example:

```text
Generate a playlist of {{genre}} songs with a total of {{number}} tracks.
```

4. Select model (demo: Anthropic Claude Sonnet); tune max tokens / temperature if needed.
5. Test with `genre = vocal jazz`, `number = 10`; run test in builder.
6. Save draft → **Create version** (published v1) for downstream apps.

See <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/prompt-management-code-ex.html">Prompt management code samples</a> for API usage.

### Examples

**1. Shared customer-email tone prompt**

Marketing and support both reference the same **versioned** “brand voice” prompt; v2 tightens brevity without redeploying every Lambda.

**2. Model-specific variants**

A `{{product_name}}` summary prompt keeps one logical ID but variants tune temperature for **Haiku** (cheap) vs **Sonnet** (quality).

**3. Flow-ready playlist prompt**

Published `music-playlist` v1 feeds the simple flow in [Bedrock Prompt Flows](../bedrock-prompt-flows/index.md)—genre and number passed as structured flow input.

### Limitations / edge cases

- **Naming rules** — Prompt resource names cannot include spaces (lecture emphasizes alphanumeric + `-` `_`).
- **Guidance still matters** — A minimal template works in demos; production needs richer instructions (the lecture notes Claude’s playlist was “not bad” but could be more specific).
- **Coupling** — Disassociate prompts from flows/agents before delete to avoid runtime errors (<a href="https://docs.aws.amazon.com/bedrock/latest/userguide/prompt-management-delete.html">delete guidance</a>).

### Industry scenarios

**1. Multi-team SaaS platform**

A platform team owns **versioned** prompts for “release notes summarizer” and “changelog classifier”; product squads invoke by ARN with `{{repo}}` and `{{version}}`.

**2. Regulated insurance correspondence**

Compliance approves prompt **version 4**; claims apps pin to that version while v5 experiments stay in draft.

**3. Retail personalization API**

`{{customer_segment}}` and `{{locale}}` variables drive merchandising copy; variants per language model share one governance workflow.

### Key takeaways

- Prompt Management is for **reuse, versioning, and variables**—not just static text storage.
- Use `{{variable}}` syntax so apps inject runtime values safely.
- **Variants** handle per-model tuning; **versions** handle lifecycle and rollback.
- Test in-console, then **publish versions** for flows and Converse-based apps.
- Next step: wire saved prompts into [Bedrock Prompt Flows](../bedrock-prompt-flows/index.md).

### References

**In this repo**

- [Bedrock Prompt Flows](../bedrock-prompt-flows/index.md)
- [More Depth on the Bedrock Converse API](../more-depth-on-the-bedrock-converse-api/index.md)
- [Intro to Prompt Engineering](../intro-to-prompt-engineering/index.md)
- [Anatomy of a Prompt](../anatomy-of-a-prompt/index.md)

**AWS documentation**

- <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/prompt-management-create.html">Create a prompt using Prompt management</a>
- <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/prompt-management-test.html">Test a prompt using Prompt management</a>
- <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/prompt-management-version-create.html">Create a version of a prompt</a>
- <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/prompt-management-code-ex.html">Run Prompt management code samples</a>
- <a href="https://docs.aws.amazon.com/bedrock/latest/APIReference/API_runtime_Converse.html">Converse API</a>
