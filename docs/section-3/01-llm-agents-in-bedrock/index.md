# LLM Agents in Bedrock

## What this lecture covers

<a href="https://docs.aws.amazon.com/bedrock/latest/userguide/agents-how.html">Amazon Bedrock Agents</a> extend foundation models with **tools**—external data, APIs, knowledge bases, and optional code execution—so the model can plan, invoke actions, and compose a complete answer. The lecture explains the conceptual agent loop, how Bedrock maps tools to **action groups** (often backed by Lambda), parameter definition in plain English, **agentic RAG**, the **code interpreter**, and production deployment via **aliases** and **InvokeAgent**.

## Key definitions (from the lecture)

| Term | Definition |
|---|---|
| **LLM agent / agentic AI** | A foundation model given **tools** to access outside data or services and fold results into its response—extending the model beyond its training cutoff and internal knowledge. |
| **Tool** | A callable capability (conceptually a **function**) the agent can choose to use; in Bedrock, often implemented as a Lambda function inside an **action group**. |
| **Planning module** | The agent’s reasoning layer that breaks a user request into steps, decides **which tools to use**, maps natural language to tool parameters, and synthesizes tool output into a final reply. |
| **Memory** | Chat history from prior turns; external data stores (including knowledge bases) are also described as a form of memory. |
| **Action group** | Bedrock’s container for one or more agent **actions** (tools), with plain-English instructions telling the FM when to invoke them. |
| **Foundation model (FM)** | The base model (e.g. Titan, Claude) that parses tool instructions, plans, and generates responses for the whole agent. |
| **Knowledge base (in an agent)** | A Bedrock RAG component attached to an agent so it can query vector stores for domain documents—sometimes called **agentic RAG**. |
| **Code interpreter** | Optional agent setting that lets the agent **write and run Python** for math, complex operations, or chart generation. |
| **Alias** | A **deployed snapshot / endpoint** of a published agent version—the stable target you invoke in production. |
| **On-demand throughput (ODT)** | Default capacity model: agent runs at **account-level quota**. |
| **Provisioned throughput (PT)** | Purchased higher throughput for heavy traffic or large token volumes. |

## Key distinctions / comparisons

| Item | Notes |
|---|---|
| **Traditional APIs vs agent tools** | Traditional code uses tightly defined APIs and hard-coded call rules; agents rely on **plain-English descriptions** of when and how to use each tool—the FM decides invocation and parameter extraction. |
| **Tool vs action group** | Conceptually a “tool”; in Bedrock implementation terms, an **action group** wraps the tool (often a Lambda) plus FM-facing instructions. |
| **RAG vs agentic RAG** | RAG retrieves context for generation; **agentic RAG** uses a knowledge base as **one tool among many** inside a larger agent orchestration. |
| **ODT vs PT for aliases** | Use **on-demand** when traffic fits normal account quotas; use **provisioned throughput** when you expect high volume or very large queries. |
| **Console vs API deployment** | Build and test in the Bedrock console; production apps call **InvokeAgent** on the **Bedrock Agents runtime** endpoint with the **alias ID**. |

## The problem (why you need it)

- Foundation models alone lack **live or private data** (today’s news, weather, internal docs, transactional systems).
- Hard-coding every integration path in application logic is brittle and does not scale as use cases multiply.
- Users ask open-ended questions that require **multi-step reasoning**: retrieve data, call APIs, compute, then answer.

## The solution

- Give the FM **tools** with natural-language guidance; the **planning module** selects tools and formats parameters.
- In Bedrock, implement tools as **action groups**—commonly **AWS Lambda** functions that accept agent-supplied parameters and return structured results.
- Attach **knowledge bases** for grounded retrieval and enable **code interpretation** when computation or visualization is needed.
- Publish an **alias** and invoke the agent from applications with **InvokeAgent**.

## Conceptual agent architecture

The lecture uses a high-level mental model (similar to NVIDIA’s agent diagram—not a 1:1 Bedrock implementation map):

1. **Core** — foundation model at the center.
2. **User request** — may require external facts the FM does not have.
3. **Planning** — decompose the request, pick tools, extract parameters from plain text, merge tool outputs.
4. **Memory** — conversation history plus optional external stores.

The key insight: the agent learns **how** to use each tool only from your **English descriptions** of purpose, parameters, and when to call it—not from rigid application code paths.

## How Bedrock implements tools (action groups)

### Foundation model first

Every agent is built on a chosen **FM**. That model reads action-group instructions, plans tool use, and assembles the final response.

### Action groups and Lambda

- In Bedrock, **tools = action groups**.
- An action group typically includes a **Lambda function** (Python, Node.js, etc.) that:
  - Receives parameters from the agent runtime.
  - Performs work (API calls, DB lookups, custom logic).
  - Returns output in the format the agent expects.

Example instruction associated with an action group (from the lecture):

> Use this function to determine the current weather in a city.

The FM’s planner may then decide: “This question is about weather—I should invoke that tool.”

### Defining parameters

For each parameter your Lambda expects, define:

| Field | Purpose |
|---|---|
| **Name** | Parameter key passed to Lambda (e.g. `city`, `units`). |
| **Description** | Plain-English guidance so the FM knows **what value to extract** from the user prompt (e.g. “Name of the city for which weather is requested”). |
| **Type** | `string`, `integer`, etc. |
| **Required** | Whether the tool call must include this argument. |

You can define parameters via **JSON schema** (OpenAI-style) or visually in the **Bedrock console** table UI.

### Missing required parameters

Agents can **prompt the user** for missing required inputs. Example: user asks “What is the current weather?” without a city—the agent can reply “What city do you want the weather in?” before calling the action group.

## Knowledge bases and agentic RAG

- Associate one or more <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/knowledge-base.html">knowledge bases</a> with an agent for semantic search over vector stores.
- Treat the knowledge base like any other tool: describe in plain English when to use it (e.g. “Use this for answering questions about self-employment”).
- Larger agents combine **knowledge bases + external Lambda tools** in one orchestrated system—**agentic RAG** is RAG as a component inside agent planning, not a separate pattern only.

See also: [Bedrock Knowledge Bases](../../section-1/bedrock-knowledge-bases/index.md), [Retrieval-Augmented Generation (RAG)](../../section-1/retrieval-augmented-generation-rag/index.md).

## Code interpreter

Optional <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/agents-enable-code-interpretation.html">code interpretation</a> lets the agent:

- Recognize tasks that need precise **computation** (math the LLM is weak at) and **generate Python** to solve them.
- Produce **charts and graphs** by writing Python visualization code when asked.

Under the hood the agent may decide: “This needs calculation—I’ll write code to handle it.” Enable the setting on the agent when you want that behavior.

## Production deployment: aliases and InvokeAgent

Before production use, create an <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/deploy-agent-proc.html">agent alias</a>—a published endpoint snapshot of a specific agent version.

**Throughput on the alias:**

| Mode | When to use |
|---|---|
| **On-demand throughput (ODT)** | Traffic expected within normal **account quota**. |
| **Provisioned throughput (PT)** | High traffic, large queries, or sustained token volume—purchase dedicated capacity via <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/prov-thru-use.html">Provisioned Throughput</a>. |

**Runtime invocation (exam-relevant phrasing):**

- Call <a href="https://docs.aws.amazon.com/bedrock/latest/APIReference/API_agent-runtime_InvokeAgent.html">InvokeAgent</a> on the **Amazon Bedrock Agents runtime** endpoint.
- Pass the **alias ID** so the service routes to the correct deployed agent endpoint and version.

## How to apply it

Example weather Lambda handler (simplified):

```python
def lambda_handler(event, context):
    # Bedrock Agents pass action group parameters in the event payload
    params = event.get("parameters", [])
    city = next(p["value"] for p in params if p["name"] == "city")
    units = next((p["value"] for p in params if p["name"] == "units"), "fahrenheit")

    # Call external weather API, then return agent-compatible response
    weather = fetch_weather(city, units)
    return {
        "messageVersion": "1.0",
        "response": {
            "actionGroup": event["actionGroup"],
            "function": event["function"],
            "functionResponse": {
                "responseBody": {
                    "TEXT": {"body": f"{city}: {weather['temp']}° ({units})"}
                }
            },
        },
    }
```

Example application call pattern (pseudocode):

```python
import boto3

client = boto3.client("bedrock-agent-runtime")
response = client.invoke_agent(
    agentId="AGENT123",
    agentAliasId="ALIAS456",  # production alias endpoint
    sessionId="user-session-789",
    inputText="What's the weather in Seattle in Celsius?",
)
# Stream or read completion from response["completion"]
```

## Examples

1. **Weather action group** — Instruction: “Use this function to determine the current weather in a city.” Parameters: `city` (string, required), `units` (`fahrenheit` / `celsius`). Lambda calls a weather API and returns text the FM weaves into the answer.
2. **Self-employment knowledge base** — Instruction: “Use this for answering questions about self-employment.” User asks about quarterly taxes; planner routes to the KB instead of a generic FM guess.
3. **Analytics with code interpreter** — User uploads sales CSV and asks for a trend chart; agent writes Python to aggregate and plot data rather than hallucinating numbers.

## Limitations / edge cases

- **Open-ended power, open-ended risk** — Tools can reach anything you wire up; guardrails, IAM, and input validation still matter (“What could go wrong?”).
- Plain-English tool descriptions are flexible but **not magic**—ambiguous instructions or poor parameter descriptions lead to wrong tool choice or bad arguments.
- The conceptual NVIDIA-style diagram is **not** a literal Bedrock component map; Bedrock’s concrete pieces are action groups, knowledge bases, aliases, and runtime APIs.
- **ODT** may throttle under spike load; **PT** adds cost and provisioning steps but improves predictable capacity.
- Code interpreter depends on enabled settings and appropriate IAM (e.g. S3 access for files mentioned in AWS docs).

## Key takeaways

- An **agent** extends an FM with **tools**; the FM **plans** which tools to call and maps user language to parameters via your descriptions.
- In Bedrock, tools live in **action groups**, often backed by **Lambda**; define each parameter’s name, description, type, and required flag in plain English.
- Agents can **ask users** for missing required parameters before invoking a tool.
- **Knowledge bases** add **agentic RAG**; **code interpreter** adds Python for math and charts.
- Production use requires an **alias** (deployed endpoint) and **InvokeAgent** on the **Bedrock Agents runtime** with the **alias ID**.
- Choose **on-demand throughput** for typical load; **provisioned throughput** for high-traffic or large-token workloads.

## Industry scenarios

1. **Customer support copilot** — Action groups call order-status and refund APIs via Lambda; a product FAQ knowledge base handles policy questions; the agent picks the right path from natural-language instructions instead of brittle if/else routing in the app.
2. **Field operations assistant** — Technicians ask about equipment at a site; Lambda tools pull live IoT or ticketing data while a manuals knowledge base supplies repair procedures—one agent orchestrates both live systems and document RAG.
3. **Finance reporting bot** — Analysts ask for variance analysis and charts; code interpreter runs Python on uploaded spreadsheets, while a knowledge base grounds answers in internal accounting policy documents.

## References

- [Bedrock Knowledge Bases](../../section-1/bedrock-knowledge-bases/index.md)
- [Retrieval-Augmented Generation (RAG)](../../section-1/retrieval-augmented-generation-rag/index.md)
- [Short and Long-Term Agent Memory](../03-short-and-long-term-agent-memory/index.md)
- <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/agents-how.html">How Amazon Bedrock Agents works</a>
- <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/agents-action-create.html">Use action groups to define actions</a>
- <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/agents-kb-add.html">Augment agents with a knowledge base</a>
- <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/agents-enable-code-interpretation.html">Enable code interpretation</a>
- <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/deploy-agent-proc.html">Create an alias for your agent</a>
- <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/agents-invoke-agent.html">Invoke an agent from your application</a>
- <a href="https://docs.aws.amazon.com/bedrock/latest/APIReference/API_agent-runtime_InvokeAgent.html">InvokeAgent API reference</a>
