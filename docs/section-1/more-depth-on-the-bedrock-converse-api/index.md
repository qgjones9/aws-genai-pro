# More Depth on the Bedrock Converse API

## What this lecture covers

The <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/conversation-inference.html">Converse API</a> is the unified, message-based interface for invoking foundation models on Bedrock—supporting prompts, tools, guardrails, inference settings, and model-specific fields in one consistent shape.

## Key definitions (from the lecture)

| Term | Definition |
|---|---|
| **Converse API** | “Swiss army knife” for **message-based** interactions with Bedrock foundation models. |
| **modelId** | Required identifier for which foundation model to invoke. |
| **Prompt** | User/system content; may reference a **stored prompt** in Bedrock Prompt Management. |
| **toolConfig** | Parameters for **tools** used in agentic flows (tool choice + tool definitions). |
| **guardrailConfig** | Optional guardrail identifier, version, and trace settings on the request. |
| **inferenceConfig** | Optional generation controls (e.g. max tokens, stop sequences, temperature, top P). |

## Key distinctions / comparisons

| Item | Notes |
|---|---|
| **Converse vs legacy invoke APIs** | Converse gives a **consistent** request shape across models so you can swap `modelId` with less application churn. |
| **Required vs optional fields** | Minimum: **prompt + modelId**; agents add **toolConfig**; safety adds **guardrailConfig**. |
| **Exam vs implementation** | Exam does not require writing code, but understanding request structure helps in architecture questions. |

## The problem (why you need it)

- Different foundation models historically used different request/response patterns.
- Applications need one integration path for chat, tools, guardrails, and tuning parameters.
- Documentation evolves quickly—know the **conceptual** contract, not every field forever.

## The solution

- Use **Converse** as the primary message API: `POST /model/{modelId}/converse` with `messages`, optional `system`, `inferenceConfig`, `toolConfig`, `guardrailConfig`, and model-specific extensions.
- Store reusable prompts in **Prompt Management** and reference them from applications.
- Consult current AWS docs for field-level details and SDK examples.

## How to apply it

Minimal mental model (exam-friendly): **modelId + messages**; layer optional blocks as needed.

```python
import boto3

client = boto3.client("bedrock-runtime", region_name="us-east-1")

response = client.converse(
    modelId="anthropic.claude-3-haiku-20240307-v1:0",
    messages=[
        {"role": "user", "content": [{"text": "Summarize VPC peering in one paragraph."}]}
    ],
    inferenceConfig={"maxTokens": 512, "temperature": 0.5, "topP": 0.9},
    # guardrailConfig={...}, toolConfig={...}  # when needed
)
print(response["output"]["message"]["content"][0]["text"])
```

HTTP shape from the lecture (abbreviated—see AWS docs for full schema):

```json
POST /model/modelId/converse HTTP/1.1
Content-type: application/json

{
   "additionalModelRequestFields": {},
   "guardrailConfig": {
      "guardrailIdentifier": "string",
      "guardrailVersion": "string",
      "trace": "string"
   },
   "inferenceConfig": {
      "maxTokens": 512,
      "stopSequences": ["string"],
      "temperature": 0.7,
      "topP": 0.9
   },
   "messages": [
      {
         "content": [{ }],
         "role": "user"
      }
   ],
   "system": [{ }],
   "toolConfig": {
      "toolChoice": { },
      "tools": [{ }]
   }
}
```

## Examples

- **Multi-model app**: Same Converse client code; change `modelId` to A/B test Haiku vs another provider model.
- **Agent with tools**: Pass function/tool definitions via `toolConfig` so the model can request tool use (covered further with agents).
- **Guardrailed chat**: Attach `guardrailConfig` to filter objectionable input/output on the same Converse call.

## Limitations / edge cases

- **Details change quickly**—always verify latest <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/conversation-inference.html">Converse API reference</a>.
- **Model-specific fields** still exist via `additionalModelRequestFields` / response field paths when a capability is not fully normalized.
- Not every playground-only feature maps 1:1 to Converse fields on every model.

## Key takeaways

- Converse is the **standard message API** for Bedrock chat-style workloads.
- **Minimum**: prompt (or stored prompt reference) + **modelId**; optionally tools, guardrails, inference config.
- Understand structure for the exam; use official docs for production code.

## Industry scenarios

1. **SaaS chat product**: One Converse integration layer lets customers pick among allowed foundation models without rewriting parsers per vendor.
2. **Internal copilot with tools**: `toolConfig` wires HR/IT APIs while guardrails block PII leakage in responses.
3. **Regulated workload**: Security team mandates `guardrailConfig` on every Converse call from the shared SDK wrapper.

## References

- <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/conversation-inference.html">Carry out a conversation with the Converse API</a>
- <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/guardrails.html">Amazon Bedrock Guardrails</a>
- <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/prompt-management.html">Prompt management in Amazon Bedrock</a>
- [Hands-On with the Bedrock Playground](../hands-on-with-the-bedrock-playground/index.md)
