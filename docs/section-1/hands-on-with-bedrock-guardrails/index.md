# Hands-On with Bedrock Guardrails

## Lecture notes

### What this lecture covers

A console walkthrough of building, testing, and deploying a <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/guardrails-components.html">Bedrock guardrail</a>—from harmful-content and prompt-attack filters to denied topics, word lists, PII masking, and contextual grounding. The demo creates **Frank's guardrails**, tests **potato** and **politics** blocks, and keeps the guardrail for a later agentic lab.

### Key definitions (from the lecture)

| Term | Definition |
|---|---|
| **Default / blocked message** | User-facing text when the guardrail intervenes (e.g., “Sorry, the model can't answer this question”). |
| **Cross-region inference** | Optional setting to use capacity across Regions for **reliability and throughput**; newer features (e.g., standard content-filter tier) may **require** it. |
| **Harmful content categories** | Dimensions such as hate, insults, sexual content—with per-category **threshold** sliders (can apply to **text and images** in multimodal apps). |
| **Prompt attacks filter** | Detects jailbreak-style input (“ignore previous instructions…”)—**block** or **detect**; **off by default** due to false positives. |
| **Content filters tier** | **Classic** (older model; English, French, Spanish) vs **standard** (more languages; often needs cross-region inference). |
| **Deny topic** | Custom topic with **definition**, **examples**, and input/output **block vs detect** actions. |
| **Word filter** | Built-in **profanity** list plus **custom words** (demo blocks “potato”). |
| **Sensitive information (PII)** | Built-in entity types; **mask** vs block; optional **custom regex** patterns. |
| **Guardrail trace** | Console view showing **which policy** triggered (word filter, topic, etc.). |

### Key distinctions / comparisons

| Item | Notes |
|---|---|
| **Block vs detect** | **Block** stops the interaction; **detect** logs/flags without necessarily stopping (used for prompt attacks and grounding in the demo). |
| **Mask vs block (PII)** | Demo **masks** SSN-like fields but allows **names**—block would reject the whole message. |
| **Classic vs standard tier** | Standard needs **cross-region inference** enabled; demo stays on **classic** without it. |
| **Policy-based Automated Reasoning vs reasoning-model check** | Console **Automated reasoning checks** toggle (detect-only, for **reasoning models**) differs from PDF **policy** Automated Reasoning in [Bedrock Guardrails Automated Reasoning Checks](../bedrock-guardrails-automated-reasoning-checks/index.md). |

### The problem (why you need it)

- Production chatbots need **practical controls** beyond model defaults: politics, profanity, jailbreaks, and leaked PII.
- Operators must **tune thresholds** and see **why** a request was stopped (trace), not just a generic failure.

### The solution (demo configuration)

The lecture builds a guardrail with:

- **Harmful categories** — thresholds set **high** (strict).
- **Prompt attacks** — enabled, **block**, medium threshold.
- **Deny topic** — “No politics” with definitions and sample prompts (input and output **block**).
- **Word filter** — custom block for **“potato”** (plus profanity list available).
- **PII** — mask most entity types; **names** allowed.
- **Contextual grounding** — grounding and relevance enabled with thresholds (block/detect); requires tuning.
- **Automated reasoning checks** — left **off** in demo (detect-only feature for reasoning models).

### How to apply it

1. In the Bedrock console, open **Build → Guardrails** (UI location may change).
2. **Create guardrail** — name, optional description, **default blocked message** (can customize per filter type later).
3. Optional: **cross-region inference**, **customer-managed KMS** key.
4. Configure filters (harmful content, prompt attacks, tier, deny topics, words, PII, grounding).
5. **Review and create** — then **Test** with a chosen foundation model (demo uses Anthropic Sonnet).
6. Run test prompts; open **trace** to see which filter fired.
7. **Deploy** into agents/flows later; delete if idle long-term to avoid stray resources (low cost in lecture).

**Test commands (natural language in console):**

```text
I really like a potato right now.     → blocked (word filter)
Talk about something political        → blocked (deny topic: politics)
```

### Examples

**1. Trace-driven debugging**

After “potato” is blocked, the trace shows **word filter** → confirms custom word list works before wiring the guardrail to an agent.

**2. Topic definition quality**

Politics deny topic includes subtle examples (“Tell me about the Supreme Court decision yesterday”) to reduce **false negatives** on borderline political queries.

**3. PII masking in support chat**

Mask driver's license and SSN patterns on output while still allowing the user’s **name** in conversation.

### Limitations / edge cases

- **Prompt attacks** — False positives possible; default **off** in many accounts.
- **Contextual grounding / relevance** — False positives; **not on by default**; needs tuning with your KB retrieval quality.
- **UI drift** — Console paths and where the blocked message appears may change (lecture notes it moved from end of wizard to earlier).
- **Cross-region inference** — Required for some newer filter tiers; plan ahead for multilingual apps.

### Industry scenarios

**1. Consumer-facing lifestyle app**

Strict harmful-content sliders plus **prompt-attack block** protect a brand-safe chat experience; deny topics block competitor mentions.

**2. Internal IT helpdesk bot**

PII masking on outputs prevents ticket paste-ins from leaking employee IDs into logs; grounding check ties answers to internal Confluence KB chunks.

**3. EdTech tutoring platform**

Deny topics block exam **cheating instructions**; word filters block profanity; traces give moderators auditable reasons for blocked student prompts.

### Key takeaways

- Guardrails are created in the console with **many independent filter modules** you can mix.
- Always craft **clear deny-topic definitions and examples**; traces prove which module fired.
- **Cross-region inference** unlocks newer filter tiers and capacity—worth enabling for production.
- Test with realistic prompts (including edge cases) before attaching to agents or flows.
- Keep the demo guardrail for later agent labs or delete if stepping away from the course.

### References

**In this repo**

- [Bedrock Guardrails](../bedrock-guardrails/index.md)
- [Bedrock Guardrails Automated Reasoning Checks](../bedrock-guardrails-automated-reasoning-checks/index.md)
- [Token-Level Redaction](../token-level-redaction/index.md)
- [Bedrock Knowledge Bases](../bedrock-knowledge-bases/index.md)

**AWS documentation**

- <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/guardrails-components.html">Create your guardrail</a>
- <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/guardrails-prompt-attack.html">Detect prompt attacks</a>
- <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/guardrails-sensitive-filters.html">Remove PII with sensitive information filters</a>
- <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/guardrails-contextual-grounding-check.html">Contextual grounding check</a>
- <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/guardrails-deploy.html">Deploy your guardrail</a>
- <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/flows-guardrails.html">Include guardrails in your flow</a>
