# Really, don't leave OpenSearch up and running for long!

!!! danger "💰 Cost warning"
    Deleting a Bedrock **knowledge base** does **not** remove the underlying **OpenSearch Serverless collection**. An idle collection can bill on the order of **~$200/month** even with zero traffic—delete the collection in the OpenSearch Serverless console when labs are done.

## What this lecture covers

A cost and cleanup warning for learners who built a Bedrock knowledge base on **OpenSearch Serverless** in the prior hands-on lab: deleting the knowledge base does **not** remove the underlying vector store collection, and an idle collection can still bill on the order of **$200/month**.

## Key definitions (from the lecture)

| Term | Definition |
|---|---|
| **Knowledge base deletion** | Removes knowledge base configuration and (by default) **vector store data** indexed for that KB—not necessarily the OpenSearch Serverless **collection** itself. |
| **OpenSearch Serverless collection** | The underlying serverless vector store instance created for the lab; must be deleted separately to stop ongoing charges. |
| **“Serverless” (OpenSearch)** | In this warning, does **not** mean “scales to zero”; unused collections can still incur cost. |

## Key distinctions / comparisons

| Item | Notes |
|---|---|
| **Delete KB vs delete collection** | KB delete clears indexed data (per default policy) but can leave the **serverless collection** running and billable. |
| **In use vs idle** | Charges can accrue even when you are not querying the knowledge base. |
| **Short gap vs long gap before agent labs** | If you will continue the course immediately, you may leave resources up; if not, tear down KB **and** collection. |

## The problem (why you need it)

- Labs create an **OpenSearch Serverless** collection that persists after knowledge base deletion.
- **“Serverless”** naming is misleading for cost: the collection keeps racking up charges when unused.
- Unexpected **~$200/month** bills are called out explicitly so learners are not surprised.

## The solution

When you will **not** reach the agentic AI section soon:

1. **Delete the knowledge base** (and understand it deletes vector store **data**, not always the store resource).
2. Open the **OpenSearch** console → **Serverless** dashboard → find your **collection** → **delete the collection** as a second step.

If you are proceeding through the course quickly and will reuse the same knowledge base for guardrails and agent exercises, you may leave it running—but accept the ongoing cost.

## How to apply it

Cleanup checklist (after hands-on lab):

1. Bedrock console → **Knowledge bases** → select your KB → **Delete** (read the warning about vector store data vs the store itself).
2. OpenSearch Service console → **Serverless** → **Collections** → delete the collection created for the lab.

No API snippet is required for the exam focus here; the lecture is procedural cleanup in the console.

## Examples

- **Taking a break mid-course**: You finish [Hands-On with Knowledge Bases](../hands-on-with-knowledge-bases/index.md) but will not start agent labs for weeks → delete KB and OpenSearch Serverless collection to avoid ~$200/month idle cost.
- **Forgot collection only**: Knowledge base gone from Bedrock, but OpenSearch Serverless dashboard still shows a collection → bills continue until collection deletion.

## Limitations / edge cases

- Warning is aimed at **course followers** of the prior video; steps assume OpenSearch Serverless was the vector store choice.
- Dollar figure is **order-of-magnitude** guidance from the instructor, not a quoted AWS price list item in the transcript.
- If you chose a different vector store type, cleanup paths differ (this lecture does not cover those).

## Key takeaways

- **Deleting a knowledge base does not delete its underlying OpenSearch Serverless collection.**
- Idle **OpenSearch Serverless** can cost on the order of **$200/month** even with no traffic.
- Always delete the **collection** in the OpenSearch Serverless dashboard when you are done with labs.
- Leave resources up only if you will **continue agent/guardrail labs soon** and accept the cost.

## Industry scenarios

1. **Sandbox account hygiene**: A team runs Bedrock KB labs in a shared dev account; whoever finishes last runs a weekly checklist to delete orphaned OpenSearch Serverless collections after KB teardown.
2. **FinOps alert**: Cloud billing flags OpenSearch Serverless spend with zero query traffic—tracing back to a forgotten POC knowledge base where only the KB was deleted.
3. **Onboarding pause**: New hire completes KB hands-on then goes on leave; manager scripts deletion of KB plus collection so training does not become an ongoing line item.

## References

- [Hands-On with Knowledge Bases](../hands-on-with-knowledge-bases/index.md)
- [Bedrock Knowledge Bases](../bedrock-knowledge-bases/index.md)
- <a href="https://docs.aws.amazon.com/opensearch-service/latest/developerguide/serverless.html">Amazon OpenSearch Serverless</a>
- <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/knowledge-base-setup.html">Set up a knowledge base</a>
