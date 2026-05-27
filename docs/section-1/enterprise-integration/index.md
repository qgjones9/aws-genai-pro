# :material-domain: Enterprise Integration

!!! tip "Exam patterns"
    Know **knowledge bases** for internal docs, **cross-account OpenSearch connectors + IAM**, and **SQS/Kafka buffers** so AWS events are not lost when external CRM or ticketing systems are down.

## What this lecture covers

Certification-focused **enterprise integration** patterns for generative AI on AWS: <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/knowledge-base.html">Bedrock Knowledge Bases</a> as the hub for internal documents, **cross-account** Bedrock + OpenSearch access, and **event-driven** pipelines with **SQS** (or Kafka) buffering between AWS processing and external enterprise systems.

## Key definitions (from the lecture)

| Term | Definition |
|---|---|
| **Bedrock Knowledge Base** | Managed RAG path that ingests enterprise content into a vector store—S3 plus connectors (SharePoint, Atlassian Confluence, etc.). |
| **Remote inference connector (OpenSearch)** | Mechanism supporting **semantic search across accounts** when the knowledge base vector store lives in another account. |
| **Cross-account IAM role** | Role in the Bedrock account granting **invoke model** (and related) access so OpenSearch in a peer account can participate in retrieval. |
| **Event-driven buffer** | Queue (e.g., <a href="https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/welcome.html">Amazon SQS</a>) between AWS-generated events and downstream CRM/data warehouse/ticketing systems. |

## Key distinctions / comparisons

| Item | Notes |
|---|---|
| **Knowledge base vs ad-hoc RAG** | Knowledge bases natively index many enterprise sources; exams treat them as the **one-stop** internal-doc integration story. |
| **Same-account vs cross-account** | Cross-account needs **connector + IAM**, not connector alone. |
| **Synchronous write vs queued write** | Direct push to enterprise apps loses data when the external system is down; **SQS/Kafka** retains events. |
| **EventBridge + Lambda vs batch** | Lecture example uses real-time doc processing; high volume may add Batch/SQS (see section-2 vector-store update lectures). |

## The problem (why enterprises need special patterns)

- Corporate data lives **outside AWS** (SharePoint, Confluence, CRM, data warehouse).
- **Account boundaries** separate security teams (Bedrock in one account, OpenSearch in another).
- Enterprise endpoints are **less reliable** than AWS—failures should not drop AI pipeline outputs.

## The solution

### 1. Knowledge bases for internal data

- Ingest from **S3** and **external connectors** into Bedrock-managed vector stores.
- Position knowledge bases as the default answer for “how do we ground models on **our** documents?”

### 2. Cross-account Bedrock + OpenSearch

**Scenario:** Foundation model / Bedrock KB in **account A**, OpenSearch vector store in **account B**.

Requirements (lecture):

1. OpenSearch **remote inference connector** for cross-account semantic search.
2. IAM role on the **Bedrock account** allowing **invoke model** access **from** the OpenSearch account (exam-specific wording—verify against current docs for your deployment).

See <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/kb-create.html">Create a knowledge base</a> and OpenSearch cross-account guidance in the latest Bedrock/OpenSearch docs.

### 3. Event-driven architecture with a buffer

**Reference flow from the lecture:**

```text
Documents uploaded
    → EventBridge
    → Lambda (Bedrock processing)
    → SQS queue  ← buffer
    → Enterprise ticketing / CRM / data warehouse
```

- **EventBridge** routes document events.
- **Lambda** runs Bedrock-related transformation/enrichment.
- **SQS** (or Kafka) ensures events **persist** if the enterprise system is unavailable.
- Relevance to GenAI: **generation events** and artifacts can be queued before delivery to systems of record.

```python
# Illustrative: enqueue enterprise payload after Bedrock step
import boto3, json

sqs = boto3.client("sqs")
QUEUE_URL = "https://sqs.us-east-1.amazonaws.com/123456789012/genai-outbound"

def after_bedrock_process(record):
    sqs.send_message(
        QueueUrl=QUEUE_URL,
        MessageBody=json.dumps(record),
    )
```

## Examples

**1. Policy document pipeline**

SharePoint → Bedrock knowledge base for employee Q&A; nightly EventBridge sync keeps vectors fresh.

**2. Multi-account security boundary**

Central OpenSearch cluster in a **data account**; application teams invoke Bedrock in **app accounts** via remote inference connector + cross-account roles.

**3. CRM note writer**

Lambda summarizes call transcripts with Bedrock; results land on **SQS**; worker pushes to Salesforce when API health checks pass.

## Limitations / edge cases

- Cross-account setups add **IAM and networking** review overhead—diagram the trust chain before exams or production.
- Queues add **latency** and require **dead-letter** handling for poison messages.
- Knowledge base connectors still need **credential management** and **sync schedules** for large corpora.
- Not every enterprise system has a native connector—custom ingestion via S3 + Lambda remains common.

## Industry scenarios

**1. Global manufacturer**

Confluence and SharePoint feed one knowledge base; plant engineers query procedures; SQS buffers work-order updates into on-prem MES when connectivity drops.

**2. Regulated bank**

Bedrock in app account; OpenSearch in data account; cross-account roles audited quarterly; no customer PII stored in prompts—guardrails downstream.

**3. Retail enterprise**

EventBridge on new S3 product sheets → Lambda embedding job → SQS → SAP catalog API with retry and DLQ for failed SKU writes.

## Key takeaways

- **Knowledge bases** integrate diverse **enterprise document** sources into Bedrock.
- **Cross-account** OpenSearch retrieval needs **remote inference connector + IAM roles**.
- **Event-driven design** with **SQS/Kafka** protects GenAI outputs when external systems fail.
- Treat enterprise integration as **reliability + governance**, not only model choice.

## References

**In this repo**

- [Bedrock Knowledge Bases](../bedrock-knowledge-bases/index.md)
- [Hands-On with Knowledge Bases](../hands-on-with-knowledge-bases/index.md)
- [Vector Stores and Semantic Search](../vector-stores-and-semantic-search/index.md)
- [Retrieval-Augmented Generation (RAG)](../retrieval-augmented-generation-rag/index.md)
- [Bedrock Guardrails](../bedrock-guardrails/index.md)

**AWS documentation**

- <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/knowledge-base.html">Retrieve data and generate responses with knowledge bases</a>
- <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/kb-data-source.html">Connect a data source to your knowledge base</a>
- <a href="https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-what-is.html">What is Amazon EventBridge?</a>
- <a href="https://docs.aws.amazon.com/lambda/latest/dg/welcome.html">What is AWS Lambda?</a>
- <a href="https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/welcome.html">What is Amazon SQS?</a>
