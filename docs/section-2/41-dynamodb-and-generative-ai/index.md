# DynamoDB and Generative AI

## Lecture notes

### What this lecture covers

DynamoDB is **not** a vector database, but it still matters in generative AI architectures. This lecture explains where DynamoDB fits—especially **near real-time operational data**, **agent short- and long-term memory**, and **context awareness**—and how **zero-ETL integration with <a href="https://docs.aws.amazon.com/opensearch-service/latest/developerguide/what-is.html">Amazon OpenSearch Service</a>** lets you front DynamoDB with OpenSearch for **vector search** and **<a href="https://docs.aws.amazon.com/bedrock/latest/userguide/knowledge-base-create.html">Amazon Bedrock Knowledge Bases</a>**.

### Key definitions (from the lecture)

| Term | Definition |
|---|---|
| **Vector store** | A system that stores embedding vectors and runs **similarity / nearest-neighbor search** (for RAG and retrieval). DynamoDB is **not** one today. |
| **Near real-time data** | Frequently updated application state (sessions, profiles, live inventory) that larger GenAI systems need with low latency—DynamoDB’s sweet spot in this lecture. |
| **Short-term memory (agents)** | Recent conversation context within a session—often fast reads/writes of chat turns. |
| **Long-term memory (agents)** | Persistent history and facts that survive across sessions (for example resuming a ChatGPT thread weeks later). |
| **Context awareness** | Giving the model enough **user-specific background** (history, preferences) so replies stay coherent; the lecture ties this to storing chat-related state in DynamoDB. |
| **Zero-ETL** | **Extract, transform, load** without building a custom batch pipeline—here, a managed integration that **continuously syncs DynamoDB into OpenSearch**. See <a href="https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/OpenSearchIngestionForDynamoDB.html">DynamoDB zero-ETL integration with Amazon OpenSearch Service</a>. |

### Key distinctions / comparisons

| Item | Notes |
|---|---|
| **DynamoDB vs vector store** | You *could* store raw vectors in DynamoDB, but DynamoDB **does not perform vector search** (at least not today). Use OpenSearch, S3 Vectors, Aurora/pgvector, etc. for retrieval. |
| **Operational store vs retrieval index** | DynamoDB holds **authoritative, low-latency items** (users, sessions, preferences). OpenSearch holds **searchable embeddings** for semantic retrieval. Zero-ETL links them. |
| **Memory in chat products** | Resuming an old conversation implies **long-term memory** was persisted somewhere—DynamoDB is one AWS-appropriate option called out in AWS guidance for GenAI patterns. |

### The problem (why you need DynamoDB in GenAI)

- Generative AI apps need **durable, fast state**: chat transcripts, user preferences, session metadata, and feature flags—not just static documents in S3.
- **Vector stores alone** do not replace a transactional item store for per-user, per-session reads and writes at scale.
- **Knowledge bases** need a path to include **live operational data** that already lives in DynamoDB (product catalog rows, account settings, support tickets) without hand-rolling fragile ETL jobs.

### The solution: where DynamoDB fits

```
Users / agents  →  DynamoDB (sessions, history, preferences)
                         │
                         │ zero-ETL (managed replication)
                         ▼
                   OpenSearch (vectors + search)
                         │
                         ▼
              Bedrock Knowledge Base / RAG retrieval
```

- **Agent memory**: Store **short- and long-term memory**—conversation history and longer-lived user preferences—for context-aware chat.
- **Context awareness**: Persist what the model should “remember” about a user across turns and sessions; AWS blog guidance (referenced in the lecture slides) highlights DynamoDB for this pattern.
- **Bridge to vectors**: Use **OpenSearch as the vector store** while **DynamoDB remains the system of record**; zero-ETL keeps OpenSearch fed in near real time so Bedrock knowledge bases can retrieve content that originated in DynamoDB.

See also: <a href="https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/ddb-and-amazon-bedrock.html">Leveraging DynamoDB zero-ETL integration with OpenSearch Service</a> and [Using and Tuning OpenSearch as a Vector Store](../23-using-and-tuning-opensearch-as-a-vector-store/index.md).

### Agent memory patterns (from the lecture)

| Memory type | Typical content | Lecture example |
|---|---|---|
| **Long-term** | Full chat threads, durable user facts | Returning to a ChatGPT conversation a month later—history had to be stored |
| **Long-term (preferences)** | Tone, locale, product interests, opt-ins | Per-user preference items keyed by `userId` |
| **Short-term** | Latest turns in the active session | Recent messages for the current dialog window |

DynamoDB fits when you need **single-digit millisecond reads/writes**, flexible schema per item, and horizontal scale for many concurrent chats.

### DynamoDB + OpenSearch zero-ETL

- **Zero-ETL** here means OpenSearch is **tied directly** to DynamoDB through a managed pipeline—no separate “nightly export” job you maintain.
- Data in DynamoDB can be **indexed in OpenSearch in near real time**, so search and vector workflows see fresh operational rows.
- **Architecture pattern from the lecture**: **Front DynamoDB with OpenSearch**—applications may still write to DynamoDB; retrieval for Bedrock goes through OpenSearch as the **vector store**, while DynamoDB stays the durable source.
- **Outcome**: Incorporate **DynamoDB-backed business data** into **Bedrock knowledge bases** and RAG flows without duplicating ingestion logic by hand.

Operational details (PITR, streams, capacity) are covered in <a href="https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/OpenSearchIngestionForDynamoDB.html">How the DynamoDB zero-ETL integration works</a> and <a href="https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/bp-integration-opensearch.html">Best practices for DynamoDB zero-ETL with OpenSearch</a>.

### Examples

**1. Persist chat history (long-term memory)**

```python
import time
import boto3

table = boto3.resource("dynamodb").Table("ChatSessions")

# Partition: userId, Sort: sessionId — each message append as a new item or nested list
table.put_item(
    Item={
        "userId": "user-42",
        "sessionId": "sess-2025-05-26",
        "role": "user",
        "content": "Summarize my last support ticket.",
        "ts": int(time.time()),
    }
)
```

**2. Store user preferences for context awareness**

```python
table.put_item(
    Item={
        "userId": "user-42",
        "sk": "preferences",
        "locale": "en-US",
        "tone": "concise",
        "topics": ["kubernetes", "dynamodb"],
    }
)
```

**3. Operational rows → knowledge base via zero-ETL**

A product-support table in DynamoDB (`productId`, `faqSnippet`, `lastUpdated`) replicates to OpenSearch. Bedrock Knowledge Base retrieval hits **embeddings in OpenSearch** that reflect **current DynamoDB content**, so answers cite up-to-date catalog text without a custom Glue job.

### Limitations / edge cases

- DynamoDB **does not replace** a vector database for similarity search—plan a dedicated vector store (OpenSearch is the lecture’s pairing).
- Storing raw embedding arrays in DynamoDB is possible but **awkward and costly** without native vector query support.
- Zero-ETL adds **operational prerequisites** (for example PITR, streams, pipeline capacity)—treat it as managed replication, not magic; see AWS prerequisites on the integration page.
- **Short-term memory windowing** still belongs in application logic (truncate prompts, summarize old turns) even when DynamoDB holds full history.

### Industry scenarios

**1. Customer support copilot**

A SaaS company stores ticket summaries and chat transcripts in DynamoDB keyed by `customerId`. Agents pull the last N messages for live sessions (short-term) and full history for escalations (long-term). Zero-ETL syncs ticket metadata into OpenSearch so the Bedrock knowledge base retrieves both **documentation embeddings** and **fresh ticket fields**.

**2. Personalized shopping assistant**

An e-commerce platform keeps `userId` preference items (sizes, brands, opt-outs) in DynamoDB for millisecond reads at checkout. Product facts also live in DynamoDB; zero-ETL feeds OpenSearch so semantic search over catalog + preferences stays current without batch lag.

**3. Internal IT helpdesk bot**

HR policy snippets and per-employee entitlements sit in DynamoDB (entitlements change often). OpenSearch indexes vectors for policy documents while zero-ETL mirrors entitlement rows. RAG answers “Can I access system X?” using **vector search on policies** plus **authoritative entitlement items** sourced from DynamoDB.

### Key takeaways

- DynamoDB is **not a vector store**—do not expect native vector search there today.
- It **is** a strong fit for **near real-time operational data** and **agent memory** (chat history, preferences, session state).
- **Context-aware chat** needs durable per-user storage; DynamoDB is an AWS-recommended pattern in GenAI architecture guidance cited in the lecture.
- **Zero-ETL to OpenSearch** connects DynamoDB to **vector search** and **Bedrock Knowledge Bases** without custom ETL.
- Think **DynamoDB = system of record**, **OpenSearch = retrieval/vector index**, **Bedrock = generation**—compose all three for RAG over live data.

### References

**In this repo**

- [Amazon DynamoDB](../32-amazon-dynamodb/index.md)
- [Amazon DynamoDB - Basic APIs](../36-amazon-dynamodb-basic-apis/index.md)
- [Intro to OpenSearch in GenAI](../17-intro-to-opensearch-in-genai/index.md)
- [Using and Tuning OpenSearch as a Vector Store](../23-using-and-tuning-opensearch-as-a-vector-store/index.md)
- [Keeping your Vector Store Up to Date](../42-keeping-your-vector-store-up-to-date/index.md)

**AWS documentation**

- <a href="https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/OpenSearchIngestionForDynamoDB.html">DynamoDB zero-ETL integration with Amazon OpenSearch Service</a>
- <a href="https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/ddb-and-amazon-bedrock.html">Leveraging DynamoDB zero-ETL integration with OpenSearch Service</a>
- <a href="https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/bp-integration-opensearch.html">Best practices for DynamoDB zero-ETL and OpenSearch Service</a>
- <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/knowledge-base-create.html">Create a knowledge base in Amazon Bedrock</a>
- <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/knowledge-base-setup.html">Prerequisites for using a vector store with a knowledge base</a>
- <a href="https://docs.aws.amazon.com/prescriptive-guidance/latest/agentic-ai-patterns/memory-augmented-agents.html">Memory-augmented agents (AWS Prescriptive Guidance)</a>
