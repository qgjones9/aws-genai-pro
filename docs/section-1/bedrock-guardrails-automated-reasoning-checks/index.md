# Bedrock Guardrails Automated Reasoning Checks

## Lecture notes

### What this lecture covers

<a href="https://docs.aws.amazon.com/bedrock/latest/userguide/guardrails-automated-reasoning-checks.html">Automated Reasoning checks</a> in Bedrock Guardrails go beyond casual “chain-of-thought” prompting. They help **enforce complex organizational policies** at the guardrail stage—useful for domains like **mortgage approval**, **HR benefits**, or **medical policy** where rules must be applied consistently and hallucinations in multi-step logic are costly.

### Key definitions (from the lecture)

| Term | Definition |
|---|---|
| **Automated Reasoning check** | A guardrail capability that turns a **written policy** into **structured logic** and validates model outputs against that logic. |
| **Policy (input)** | A **clear, well-organized PDF** you upload describing rules (plain text policy document). |
| **Logic diagram** | A structured representation Bedrock builds from the policy—**variables**, **conditions**, and **outputs** (e.g., booleans). |
| **Extracted variables** | Values inferred from context (e.g., `is_full_time`, `years_of_service`) used in rule evaluation. |
| **Output variable** | A derived result (e.g., `eligible_for_parental_leave = true`). |
| **Create automated reasoning policy** | The primary API: supply a **name** and attach the **PDF**; Bedrock parses and constructs enforceable rules. |

### Key distinctions / comparisons

| Item | Notes |
|---|---|
| **Automated Reasoning vs contextual grounding** | [Contextual grounding](../bedrock-guardrails/index.md) scores similarity to **retrieved text**; Automated Reasoning enforces **explicit business rules** encoded from a **policy PDF**. |
| **Automated Reasoning vs prompt engineering** | You do not rely on the model to “remember” policy prose; Bedrock builds **testable logic** from the document. |
| **Policy PDF vs ad-hoc prompts** | PDF must be **clear and structured** so interpretation errors are minimized—garbage in breaks enforcement. |

### The problem (why you need it)

- Some applications require **deterministic policy compliance** (eligibility, approvals, regulated workflows).
- LLMs can **hallucinate** or skip steps in **multi-condition** scenarios (employment status **and** tenure **and** leave type).
- English-only policy reminders in a system prompt are **hard to audit** and easy to bypass inconsistently.

### The solution

1. Author a **clear policy document** (PDF).
2. Call **create automated reasoning policy** with a name and the PDF attachment.
3. Bedrock **extracts variables** and builds a **logic diagram** (conditions → outcomes).
4. Attach the policy to a **guardrail** so evaluations run at the **guardrail stage** alongside other filters.

**Parental leave example (from the lecture):**

| Step | Logic |
|---|---|
| Policy text | Full-time employees with **≥ 1 year** of service are eligible for parental leave. |
| Variables | `is_full_time` (boolean), `years_of_service` (number) |
| Rule | If full-time **and** `years_of_service >= 1` → `eligible_for_parental_leave = true`, else false |

### How to apply it

- **Start simple** — AWS recommends beginning with a **small, clear policy** and increasing complexity after you verify behavior.
- **Iterate** — Misinterpreted PDFs produce wrong logic; validate traces and outcomes before production.
- **API surface (lecture)** — Essentially **create automated reasoning policy** (name + PDF); Bedrock handles decomposition into rules.

See also <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/deploy-automated-reasoning-policy.html">Deploy your Automated Reasoning policy</a>.

### Limitations / edge cases

- **Document quality matters** — Ambiguous or poorly structured PDFs lead to **incorrect rule graphs**.
- **Interpretation risk** — Automated extraction can misread edge cases; human review of generated logic is essential.
- **Hands-on note** — The [Hands-On with Bedrock Guardrails](../hands-on-with-bedrock-guardrails/index.md) lecture also mentions a separate **“automated reasoning checks”** toggle for **reasoning models** in **detect-only** mode (sanity check on reasoning traces)—distinct from **policy-based** Automated Reasoning in this lecture.

### Examples

**1. HR parental leave bot**

Upload the parental-leave PDF; the guardrail sets `eligible_for_parental_leave` only when tenure and employment type match—blocking answers that grant leave to ineligible employees.

**2. Mortgage pre-qualification assistant**

Policy PDF defines income, credit, and LTV rules; Automated Reasoning validates the model’s recommendation against extracted applicant fields.

**3. Clinical billing policy copilot**

Hospital billing rules (covered procedures, prior auth flags) are encoded from PDF; outputs that contradict the logic graph are filtered before staff act on them.

### Industry scenarios

**1. Insurance claims intake**

Carrier uploads **coverage eligibility** policies; Automated Reasoning blocks model statements that approve claims when policy variables (deductible met, rider active) fail.

**2. Global manufacturer HR portal**

Leave policies differ by country; separate policy PDFs per region attach to regional guardrails so the same chat UI enforces **local** rules.

**3. University financial aid chatbot**

Aid eligibility PDF drives boolean outputs (`pell_eligible`, `work_study_eligible`); advisers see blocked responses when the model contradicts parsed policy logic.

### Key takeaways

- Automated Reasoning checks enforce **complex policies** by converting a **PDF** into **structured logic** at the guardrail layer.
- Bedrock **extracts variables** and builds **condition → outcome** diagrams (e.g., parental leave eligibility).
- Primary workflow: **create automated reasoning policy** (name + PDF), then attach to a guardrail.
- **Start simple and iterate**—policy misreads are the main failure mode.
- Complements [Bedrock Guardrails](../bedrock-guardrails/index.md) content filters and grounding, but does not replace good retrieval or human oversight.

### References

**In this repo**

- [Bedrock Guardrails](../bedrock-guardrails/index.md)
- [Hands-On with Bedrock Guardrails](../hands-on-with-bedrock-guardrails/index.md)

**AWS documentation**

- <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/guardrails-automated-reasoning-checks.html">What are Automated Reasoning checks in Amazon Bedrock Guardrails?</a>
- <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/deploy-automated-reasoning-policy.html">Deploy your Automated Reasoning policy in your application</a>
- <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/guardrails-components.html">Create your guardrail</a>
