# A quick note on model access

## What this lecture covers

Administrative prerequisites before hands-on Bedrock work: **model access** (especially Anthropic), **no free tier** for Bedrock in this course, and **quota / throttling** issues some learners hit.

## Key definitions (from the lecture)

| Term | Definition |
|---|---|
| **Default model access** | Bedrock foundation models are generally enabled by default, with noted exceptions. |
| **Anthropic use case** | First-time use of Anthropic models (e.g. Claude Opus) may require submitting a **use case** in the Model Catalog before access. |
| **On-demand quota** | Account limits on Bedrock usage; some students see quotas set to **zero** until support raises them. |
| **Billing alarm** | AWS billing alert recommended because labs incur small but real charges. |

## Key distinctions / comparisons

| Item | Notes |
|---|---|
| **Anthropic vs other providers** | Non-Anthropic foundation models may work without the extra use-case step described for Claude. |
| **Watch videos vs hands-on** | You can follow lectures without a paid account; hands-on requires billing awareness. |
| **Throttling vs access denied** | “Too many tokens per day” may indicate **quota** needs increasing, not only waiting. |

## The problem (why you need it)

- Labs fail if models are not **enabled** or Anthropic **use case** is not submitted.
- Unexpected **charges** without billing alarms.
- **Zero quota** blocks on-demand inference even when model access appears granted.

## The solution

- Open **Model Catalog** in the Bedrock console and request access; use case such as **“educational use with an online course”** is reasonable.
- Alternatively, pick a **non-Anthropic** foundation model for activities.
- Set **billing alarms**; contact **AWS Support** to raise Bedrock on-demand quotas if throttled at zero.
- Monitor usage to control cost.

## How to apply it

1. In the AWS console, go to **Amazon Bedrock** → **Model access** / **Model catalog** (wording may vary by console version).
2. For Anthropic models, complete the **use case** form before first use.
3. In **Billing**, create a **budget or alarm** before running playground or API labs.
4. If you see throttling with zero effective quota, open a support case for **Bedrock on-demand** quota increase.

## Examples

- **Course lab**: Request Claude access with educational use case, then proceed to [Hands-On with the Bedrock Playground](../hands-on-with-the-bedrock-playground/index.md).
- **Cost control**: Run playground experiments with output token limits and alarms instead of leaving high-volume tests unattended.
- **Quota fix**: Error resembling “Throttling Exception … Too many tokens per day” → verify quota in Service Quotas and request increase.

## Limitations / edge cases

- Access policies and default-enable behavior can change; always verify in your account’s console.
- Bedrock and related services in this course are **not** covered by the AWS Free Tier.

## Key takeaways

- Plan for **paid account**, **billing alarms**, and possible **Anthropic use-case** submission.
- **Quota zero** is a known student issue—support can raise limits.
- You can still learn from videos without hands-on spend.

## Industry scenarios

1. **Corporate sandbox**: Central cloud team pre-approves model access and sets org-wide quotas before developers run Bedrock pilots.
2. **University course**: Instructor documents Anthropic use-case wording and billing alarms so students avoid blocked labs and bill shock.
3. **Startup MVP**: Team selects a non-Anthropic model for early prototypes to reduce access friction while legal reviews vendor terms.

## References

- <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/model-access.html">Access Amazon Bedrock foundation models</a>
- <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/quotas.html">Quotas for Amazon Bedrock</a>
- [Hands-On with the Bedrock Playground](../hands-on-with-the-bedrock-playground/index.md)
