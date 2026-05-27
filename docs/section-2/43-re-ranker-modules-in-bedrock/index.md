# Re-Ranker Modules in Bedrock

## Lecture notes

### What this lecture covers

<a href="https://docs.aws.amazon.com/bedrock/latest/userguide/rerank.html">Reranker models in Amazon Bedrock</a> are a **post-retrieval** tool for improving RAG context quality. After semantic search returns candidate chunks from your vector store or <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/knowledge-base.html">Amazon Bedrock Knowledge Base</a>, a reranker **scores each chunk against the original query** and **reorders** results so the most relevant passages rise to the top before you pass context to a foundation model.

### Key definitions (from the lecture)

| Term | Definition |
|---|---|
| **Re-ranker model** | A model that measures **how relevant each retrieved chunk is to the user query**, then **reorders** those chunks (independent of raw vector distance alone). |
| **Semantic search (starting point)** | Initial retrieval using **embedding vectors** and **distance** in the vector store—the lecture treats this as the first pass, not the final ranking. |
| **Re-rank operation** | The Bedrock API action (`Rerank`) that sends a query plus candidate documents to a reranker model and returns **relevance scores** and a new ordering. |
| **Knowledge-base-level reranking** | Specifying a reranker model when querying a knowledge base so reranking runs as part of **Retrieve** / **RetrieveAndGenerate** (or in the console query UI). |

### Key distinctions / comparisons

| Item | Notes |
|---|---|
| **Vector similarity vs reranking** | Vector search ranks by **embedding distance**; reranking ranks by a model trained to judge **query–document relevance**—often a better match for what the LLM actually needs. |
| **Standalone `Rerank` API vs knowledge base query** | Call <a href="https://docs.aws.amazon.com/bedrock/latest/APIReference/API_agent-runtime_Rerank.html">Rerank</a> directly on any list of documents you already retrieved, **or** configure reranking on <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/kb-how-retrieval.html">Knowledge Base retrieval</a> so Bedrock applies it automatically. |
| **Amazon Rerank 1.0 vs Cohere Rerank 3.5** | Two provider options in Bedrock today; **regional availability differs**—always confirm support in your deployment Region (see limitations below). |

### The problem (why you need reranking)

- Chunks returned by vector search **might not all be relevant** to the original user query—even when they are semantically “close” in embedding space.
- Feeding **irrelevant context** into the foundation model wastes tokens, increases latency/cost, and can **degrade answer quality**.
- Pure semantic similarity does not always align with **which passage best answers this specific question**.

### The solution: two-stage retrieval

The lecture describes a **retrieve-then-rerank** pattern:

```
User query
    │
    ▼
Vector store / Knowledge Base  ──►  semantic search (embeddings, distances)
    │
    ▼
Candidate chunks (top-K)
    │
    ▼
Reranker model  ──►  score relevance(query, chunk) for each chunk
    │
    ▼
Reordered results  ──►  best chunks at the top → LLM context
```

- **Stage 1**: Use semantic search to cast a wide net and pull candidate chunks.
- **Stage 2**: Use a reranker to **measure relevance** from each chunk to the **original query** and **reorder** so the best passages lead the context window.

This sits in the **post-retrieval** stage of RAG (see [Pre-Retrieval and Chunking Strategies](../../section-1/pre-retrieval-and-chunking-strategies/index.md)).

### How to apply it

#### Option A — Call the Bedrock `Rerank` API directly

Send a request to the <a href="https://docs.aws.amazon.com/general/latest/gr/bedrock.html#bra-rt">Agents for Amazon Bedrock runtime</a> endpoint with:

- The **query** (text),
- **Sources** (inline text or JSON documents to rerank),
- **Reranking configuration** (model ARN, number of results to return).

See <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/rerank-use.html">Use a reranker model in Amazon Bedrock</a>.

```python
import boto3

client = boto3.client("bedrock-agent-runtime", region_name="us-east-1")

response = client.rerank(
    queries=[{
        "type": "TEXT",
        "textQuery": {"text": "What is our refund policy for annual subscriptions?"},
    }],
    sources=[
        {
            "type": "INLINE",
            "inlineDocumentSource": {
                "type": "TEXT",
                "textDocument": {
                    "text": "Annual plans may be cancelled within 30 days for a full refund."
                },
            },
        },
        {
            "type": "INLINE",
            "inlineDocumentSource": {
                "type": "TEXT",
                "textDocument": {
                    "text": "Our headquarters is located in Seattle, Washington."
                },
            },
        },
    ],
    rerankingConfiguration={
        "type": "BEDROCK_RERANKING_MODEL",
        "bedrockRerankingConfiguration": {
            "modelConfiguration": {
                "modelArn": "arn:aws:bedrock:us-east-1::foundation-model/cohere.rerank-v3-5:0",
            },
            "numberOfResults": 1,
        },
    },
)

for result in response["results"]:
    print(f'rank={result["index"]}, score={result["relevanceScore"]}')
```

#### Option B — Rerank when querying a knowledge base

When hitting a knowledge base, **specify a reranker model explicitly** in retrieval configuration (API) or choose **Select model** under **Reranking** in the console query pane. Reranked ordering **overrides** the default knowledge base ranking from vector search.

Use with <a href="https://docs.aws.amazon.com/bedrock/latest/APIReference/API_agent-runtime_Retrieve.html">Retrieve</a> or <a href="https://docs.aws.amazon.com/bedrock/latest/APIReference/API_agent-runtime_RetrieveAndGenerate.html">RetrieveAndGenerate</a>.

### Available reranker models (lecture + AWS docs)

The lecture names **Amazon** and **Cohere** as the two model families. Per <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/rerank-supported.html">Supported Regions and models for reranking</a>:

| Provider | Model | Model ID | Regions (single-region support) |
|---|---|---|---|
| **Amazon** | Rerank 1.0 | `amazon.rerank-v1:0` | ap-northeast-1, ca-central-1, eu-central-1, us-west-2 |
| **Cohere** | Rerank 3.5 | `cohere.rerank-v3-5:0` | ap-northeast-1, ca-central-1, eu-central-1, us-east-1, us-west-2 |

**Regional caveat (lecture emphasis):** Reranking is **only available in limited Regions**. Before you design a production RAG stack, **verify reranking is supported where you deploy Bedrock**. Example from AWS docs: **Amazon Rerank 1.0 is not available in us-east-1**—only Cohere Rerank 3.5 is supported there.

At a high level, every built-in reranker does the same job: **score how relevant each chunk is to the query**—the lecture notes this is straightforward to describe even if the model training is sophisticated.

### Examples

**1. Over-retrieve, then rerank down**

Retrieve `top_k=20` from OpenSearch by vector similarity, call `Rerank` with `numberOfResults=5`, and pass only those five chunks to the LLM—better precision without shrinking the initial recall window.

**2. Knowledge base console test**

Open the knowledge base query UI, expand **Reranking**, choose a model, and compare answers with reranking on vs off on the same prompt—useful when tuning chunk size and retrieval `top_k`.

**3. Custom pipeline (non-KB vector store)**

Your app queries DynamoDB / OpenSearch directly, builds an inline `sources` list from hits, and calls `Rerank` before `InvokeModel`—same pattern as lecture Option A when you are not using Bedrock Knowledge Bases end-to-end.

### Limitations / edge cases

- **Regional availability** — Confirm model and Region before architecture sign-off; mismatches block reranking entirely in unsupported Regions.
- **Text only** — AWS docs state reranking applies to **textual data** only (not multimodal/image chunks).
- **Extra latency and cost** — Each rerank call adds an inference step; balance `top_k` retrieved vs `numberOfResults` kept.
- **Permissions** — Knowledge base service roles may need updates to invoke the reranker model (<a href="https://docs.aws.amazon.com/bedrock/latest/userguide/rerank-prereq.html">reranking permissions</a>).
- **Not a substitute for bad chunking** — Reranking improves ordering of candidates you already retrieved; poor chunk boundaries or stale indexes still hurt quality upstream.

### Industry scenarios

**1. Enterprise HR policy chatbot**

Employees ask nuanced questions (“Can I roll unused PTO into next year?”). Vector search returns ten policy snippets; **Cohere Rerank 3.5** promotes the paragraph that mentions carryover rules, cutting hallucinations from loosely related benefits text.

**2. SaaS documentation support**

A startup’s docs KB retrieves API reference and marketing pages for the same keyword. **Amazon Rerank 1.0** on **RetrieveAndGenerate** in `us-west-2` keeps technical reference chunks ahead of landing-page copy, improving cited answers in the support widget.

**3. Regulated financial advisory assistant**

Compliance requires **fewer, highly relevant** excerpts in the audit trail. The team retrieves 15 chunks from a private vector store, reranks to **3** via the standalone **Rerank** API, and logs scores—tighter context window plus documented relevance ranking for reviewers.

### Key takeaways

- Rerankers address a real gap: **semantic similarity ≠ best answer for this query**.
- Use vector search as a **broad first pass**, then rerank to put the **most query-relevant chunks on top**.
- Bedrock exposes reranking via the **`Rerank` API** and via **knowledge base retrieval configuration**.
- Built-in options come from **Amazon** and **Cohere**; pick the model that is **available in your Region**.
- Always **verify regional support** before relying on reranking in production.
- Reranking is a **post-retrieval** optimization in the RAG pipeline—pair it with solid chunking and fresh vector data.

### References

**In this repo**

- [Pre-Retrieval and Chunking Strategies](../../section-1/pre-retrieval-and-chunking-strategies/index.md) (post-retrieval stage in RAG)
- [Optimizing your Vector Store and Embeddings](../../section-1/optimizing-your-vector-store-and-embeddings/index.md) (metadata-based reranking preview)
- [Bedrock Knowledge Bases](../../section-1/bedrock-knowledge-bases/index.md)
- [Keeping your Vector Store Up to Date](../42-keeping-your-vector-store-up-to-date/index.md)

**AWS documentation**

- <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/rerank.html">Improve the relevance of query responses with a reranker model</a>
- <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/rerank-use.html">Use a reranker model in Amazon Bedrock</a>
- <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/rerank-supported.html">Supported Regions and models for reranking</a>
- <a href="https://docs.aws.amazon.com/bedrock/latest/APIReference/API_agent-runtime_Rerank.html">Rerank API reference</a>
- <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/kb-how-retrieval.html">Retrieving information from Knowledge Bases</a>
- <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/model-card-cohere-rerank-3-5.html">Cohere Rerank 3.5 model card</a>
