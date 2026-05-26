# Keeping your Vector Store Up to Date

## Lecture notes

### What this lecture covers

Source documents behind your embeddings **change constantly**—adds, deletes, and edits—so you need **incremental updates**, **change detection**, and **sync pipelines**. This lecture positions <a href="https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-what-is.html">Amazon EventBridge</a> as the orchestration layer for keeping a vector store fresh, walks through an **event-driven ingestion architecture** (including <a href="https://docs.aws.amazon.com/lambda/latest/dg/welcome.html">AWS Lambda</a> and <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/knowledge-base-create.html">Amazon Bedrock Knowledge Bases</a>), and covers **scaling buffers** (<a href="https://docs.aws.amazon.com/batch/latest/userguide/what-is-batch.html">AWS Batch</a>, <a href="https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/welcome.html">Amazon SQS</a>, Kafka) plus **periodic index rebuilds** to fight drift and fragmentation.

### Key definitions (from the lecture)

| Term | Definition |
|---|---|
| **Incremental updates** | Applying only **what changed** in the source corpus to the vector index instead of re-embedding everything on every edit. |
| **Real-time change detection** | Noticing that source data changed **soon after** the change (S3 event, webhook, poll) and kicking off downstream work. |
| **Synchronization pipeline** | The end-to-end flow that **detects change → fetches delta → ingests embeddings** into the vector store / knowledge base. |
| **Index drift / fragmentation** | Over many in-place updates, the underlying vector index can **degrade in performance**; the lecture recommends occasional **full rebuilds**. |
| **Alias swap** | After building a **new** index (new embeddings, new vector DB), **point an alias** at the validated index and retire the old one—blue/green style cutover. |

### The problem (why you need update pipelines)

- The **source data** you chunk and embed is never static—new content arrives, old content is removed, and existing records change.
- A vector store that only reflects **day-one** documents will return **stale or wrong context** for RAG, hurting answer quality and trust.
- High-frequency updates can **overload** a naive “Lambda on every event” design without buffering or batching.
- Even with good incremental sync, the **search index itself** can suffer **drift and fragmentation** over time and need periodic reconstruction.

### The solution: EventBridge-centric architectures

**EventBridge is your friend** for keeping vector stores current (the course goes deeper on EventBridge later). At a high level:

```
Change signal (S3 / webhook / scheduled poll)
        │
        ▼
  EventBridge (route / schedule)
        │
        ├──► Lambda ──► fetch delta ──► Bedrock KB ingestion
        │
        └──► (optional) Batch / SQS / Kafka buffer
```

#### Incremental update path (occasional changes)

Typical **change signals** the lecture calls out:

| Signal | Example |
|---|---|
| **S3 event** | New or updated object in a document bucket |
| **Webhook** | Third-party CMS or SaaS notifies you that content changed |
| **Scheduled poll** | EventBridge runs on a cadence and checks whether upstream data changed |

**Flow:**

1. EventBridge receives or emits the “data changed” event.
2. A **Lambda function** runs: **retrieve the changed data** from the source (S3, API, database, etc.).
3. Lambda **invokes Bedrock knowledge base ingestion** so new/changed chunks are embedded and indexed.

See <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/kb-data-source-sync-ingest.html">Sync your data with your Amazon Bedrock knowledge base</a> and <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/kb-direct-ingestion.html">Ingest changes directly into a knowledge base</a>.

#### When updates are very frequent (scale the pipeline)

| Pattern | When it fits (lecture) |
|---|---|
| **AWS Batch in the middle** | Changes are **very frequent**; you **do not need immediate** reflection in the vector store—Batch **buffers** work into manageable jobs. |
| **SQS or Kafka** | **Event-driven decoupling** between Lambda and the store/ingestion step—absorbs spikes so Lambda does not synchronously overload ingestion. |

Think: **EventBridge detects** → **queue or batch absorbs load** → **ingestion workers** update the vector store at a sustainable rate.

### Maintaining vector indices (periodic full rebuild)

Incremental sync does not eliminate **index maintenance**:

- As the **underlying data store** changes repeatedly, **drift and fragmentation** can **reduce performance** of the vector index.
- **Mitigation**: **periodically rebuild** the index from scratch.

**Rebuild architecture from the lecture:**

```
EventBridge (scheduled trigger, e.g. monthly)
        │
        ▼
   AWS Batch job
        │
        ├── Re-embed all source documents (new embeddings)
        ├── Build a new vector database / index
        ├── Validate the new index
        └── Alias swap: point production alias to new index, retire old
```

EventBridge acts as a **periodic trigger**; Batch **queues** the heavy job to recreate embeddings, stand up a fresh index, validate it, then **swap aliases** so clients see the new index without downtime drama.

For OpenSearch-backed stores, index lifecycle patterns are covered in <a href="https://docs.aws.amazon.com/opensearch-service/latest/developerguide/managing-indices.html">Managing indexes in Amazon OpenSearch Service</a> and [OpenSearch Index Management and Designing for Stability](../20-opensearch-index-management-and-designing-for-stability/index.md).

### Key distinctions / comparisons

| Item | Notes |
|---|---|
| **Incremental sync vs full rebuild** | Incremental keeps day-to-day freshness; **full rebuild** fixes structural index degradation (drift/fragmentation). |
| **Lambda-only vs Batch-buffered** | Lambda fits **occasional** updates; **Batch** when volume is high and **near-real-time** is not required. |
| **Direct Lambda → ingest vs SQS/Kafka** | Queue/messaging **decouples** producers from consumers and smooths bursts. |
| **Immediate vs buffered freshness** | Trade **latency of reflection** in the vector store against **cost and stability** of ingestion. |

### How to apply it

**1. Wire S3 changes to ingestion (conceptual)**

```python
# Lambda handler: EventBridge or S3 event → start Bedrock ingestion
import boto3

bedrock_agent = boto3.client("bedrock-agent")

def handler(event, context):
    # After validating which objects changed, sync the knowledge base data source
    bedrock_agent.start_ingestion_job(
        knowledgeBaseId="KB12345678",
        dataSourceId="DS87654321",
    )
```

**2. Schedule periodic rebuild (EventBridge → Batch)**

- Create an EventBridge **schedule** (cron/rate) for off-peak rebuilds.
- Target **AWS Batch** with a job definition that: export source corpus → embed → build new index → run validation queries → **update alias** on success.

**3. Add a queue when Lambda cannot keep up**

```
EventBridge → Lambda (enqueue work item only) → SQS → worker Lambda/Batch → ingestion
```

### Examples

**1. Documentation site (S3 + EventBridge + Lambda)**

Product docs live in S3. Each `ObjectCreated` or scheduled diff check emits an event; Lambda starts a Bedrock **ingestion job** so only new/changed prefixes are re-indexed.

**2. High-volume product catalog**

Thousands of SKU updates per hour. Events land on **SQS**; a **Batch** job runs every 15 minutes to bulk-fetch deltas and ingest—acceptable lag for an internal search copilot.

**3. Quarterly index rebuild**

An OpenSearch-backed knowledge base alias `kb-prod` points at `kb-index-v3`. EventBridge triggers monthly **Batch** rebuild → `kb-index-v4` validated → alias swapped → `v3` deleted after soak period.

### Limitations / edge cases

- **Lambda per event** does not scale if updates are **extremely frequent**—introduce Batch, SQS, or Kafka as the lecture advises.
- **Incremental ingestion** may not fix **fragmented** vector indices; plan **scheduled full rebuilds** separately.
- **Alias swap** requires discipline: validate the new index before cutover, and keep rollback path to the old index until confident.
- Bedrock ingestion has **service limits and job duration**—large corpora may need chunked Batch jobs, not one giant Lambda timeout.
- **Deletion** of source documents must propagate to the vector store (deletion policies / resync)—not only adds and updates.

### Industry scenarios

**1. Legal / compliance knowledge base**

A law firm indexes policies in S3. **EventBridge + Lambda** ingests same-day policy edits. A **monthly EventBridge → Batch** job rebuilds the OpenSearch index to avoid fragmentation after heavy amendment seasons.

**2. E-commerce support RAG**

PIM webhooks signal SKU description changes. Webhook → **EventBridge** → **SQS** → workers call Bedrock ingestion so Black Friday traffic does not throttle Lambda concurrency. Nightly Batch handles bulk image-metadata backfills.

**3. Internal engineering wiki (Confluence → S3)**

Scheduled EventBridge poll detects wiki exports that changed. Lambda pulls deltas and syncs the knowledge base. Quarterly **alias swap** rebuild ensures search latency stays stable as the wiki grows.

### Key takeaways

- Source data **always changes**—treat vector store freshness as a **pipeline problem**, not a one-time ingest.
- **EventBridge** orchestrates both **change-driven incremental sync** and **scheduled full rebuilds**.
- Typical incremental path: **change signal → EventBridge → Lambda → fetch delta → Bedrock knowledge base ingestion**.
- For **high volume** or **non-immediate** requirements, add **AWS Batch**, **SQS**, or **Kafka** to buffer and decouple.
- **Drift and fragmentation** warrant **periodic full re-embed + new index + validate + alias swap**.
- Match architecture to **freshness SLA** vs **cost and operational complexity**.

### References

**In this repo**

- [Bedrock Knowledge Bases](../../section-1/bedrock-knowledge-bases/index.md)
- [Using and Tuning OpenSearch as a Vector Store](../23-using-and-tuning-opensearch-as-a-vector-store/index.md)
- [OpenSearch Index Management and Designing for Stability](../20-opensearch-index-management-and-designing-for-stability/index.md)
- [DynamoDB and Generative AI](../41-dynamodb-and-generative-ai/index.md)
- [Enterprise Integration](../../section-1/enterprise-integration/index.md) (EventBridge + Lambda document pipelines)

**AWS documentation**

- <a href="https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-what-is.html">What is Amazon EventBridge?</a>
- <a href="https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-create-rule-schedule.html">Creating a scheduled rule in EventBridge</a>
- <a href="https://docs.aws.amazon.com/lambda/latest/dg/with-eventbridge-scheduler.html">Invoke a Lambda function on a schedule</a>
- <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/kb-data-source-sync-ingest.html">Sync your data with your Amazon Bedrock knowledge base</a>
- <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/kb-direct-ingestion.html">Ingest changes directly into a knowledge base</a>
- <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/kb-multimodal-add-data-source-and-ingest.html">Adding data sources and starting ingestion</a>
- <a href="https://docs.aws.amazon.com/batch/latest/userguide/what-is-batch.html">What is AWS Batch?</a>
- <a href="https://docs.aws.amazon.com/opensearch-service/latest/developerguide/managing-indices.html">Managing indexes in Amazon OpenSearch Service</a>
