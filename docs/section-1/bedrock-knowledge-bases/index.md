# Bedrock Knowledge Bases

## What this lecture covers

In <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/knowledge-base.html">Amazon Bedrock Knowledge Bases</a>, RAG is packaged as a managed workflow: ingest documents, embed chunks, store vectors, retrieve context at query time, and augment generation. The lecture walks through data sources, embedding models, vector stores, chunking controls, query flow, and integration options (console, API, agents).

## Key definitions (from the lecture)

| Term | Definition |
|---|---|
| **Knowledge base** | Bedrock’s managed RAG wrapper: your documents are ingested, chunked, embedded, and stored for semantic retrieval at query time. |
| **Embedding model** | A foundation model (e.g. Cohere or <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/titan-embedding-models.html">Amazon Titan</a>) that converts each chunk into a vector for the vector store. |
| **Vector dimension** | Configurable size of each embedding vector per chunk; you choose how many dimensions to encode. |
| **Vector store** | Database that holds embedding vectors and supports semantic search (default lab choice: OpenSearch with vector support). |
| **Chunking** | Splitting large documents into smaller pieces before embedding; default is ~300 characters (lecture notes confusion between characters and tokens elsewhere in the course). |
| **Context** | Top retrieval results from the vector store, appended to the user prompt before the LLM generates a response. |
| **Chat with your document** | Console shortcut to stand up a quick RAG flow from S3 data and a foundation model. |
| **Agentic RAG** | Using a knowledge base as a component inside a larger Bedrock agent. |

## Key distinctions / comparisons

| Item | Notes |
|---|---|
| **RAG vs knowledge base** | Same idea; in Bedrock the managed product name is *knowledge base*. |
| **Structured vs unstructured sources** | S3 can hold raw text, JSON, or other formats; connectors and crawlers extend beyond files. |
| **Default OpenSearch vs other vector stores** | OpenSearch is the default for experimentation; production options include Aurora, MongoDB, DynamoDB, Atlas, Pinecone, Redis Enterprise Cloud, and others mentioned in the lecture. |
| **Fixed-size chunks vs coherent units** | Arbitrary 300-character splits are common but weaker than sentence/paragraph boundaries or structured/graph representations. |
| **Console vs API vs agents** | Playground/chat for demos; Bedrock APIs for apps; agents for orchestrated RAG. |

## The problem (why you need it)

- Foundation models alone do not know your private or timely documents.
- You need a pipeline to **ingest**, **embed**, **store**, and **retrieve** only the passages relevant to each user query.
- Whole documents are too large for a single vector entry; retrieval quality depends on how you **chunk** and **index** content.

## The solution

Bedrock knowledge bases orchestrate the RAG architecture:

1. **Source documents** (S3, web crawler, or connectors such as Confluence, Salesforce, SharePoint).
2. **Embedding** each chunk with a selected foundation embedding model (vector dimension configurable).
3. **Storage** in a vector store (OpenSearch by default for labs; many alternatives supported).
4. **Query time**: semantic search on the embedded query → retrieve relevant chunks as **context** → augmented prompt → foundation model response.

Integration paths: **Chat with your document**, direct **APIs**, or **agents** (agentic RAG).

## How to apply it

High-level flow (console or API):

1. Upload documents to S3 (or configure another data source).
2. Create a knowledge base with an embedding model and vector store.
3. Sync/ingest the data source so chunks are indexed.
4. Query via test UI, `Retrieve`/`RetrieveAndGenerate`, or an agent that references the knowledge base.

```python
import boto3

# After creating a knowledge base in the console or via API
client = boto3.client("bedrock-agent-runtime", region_name="us-east-1")

response = client.retrieve_and_generate(
    input={"text": "What are steps before becoming self-employed?"},
    retrieveAndGenerateConfiguration={
        "type": "KNOWLEDGE_BASE",
        "knowledgeBaseConfiguration": {
            "knowledgeBaseId": "YOUR_KB_ID",
            "modelArn": "arn:aws:bedrock:us-east-1::foundation-model/anthropic.claude-3-sonnet-20240229-v1:0",
        },
    },
)
print(response["output"]["text"])
```

See [Hands-On with Knowledge Bases](hands-on-with-knowledge-bases/index.md) for console steps and [Vector Stores and Semantic Search](vector-stores-and-semantic-search/index.md) for embedding/search fundamentals.

## Examples

- **Book in S3**: Full text of a self-employment book ingested; queries return cited chunks aligned with book content (demo setup in the follow-on hands-on lecture).
- **Semantic query path**: User question → encode query → OpenSearch (or other store) returns top relevant chunks → those chunks augment the Bedrock foundation model prompt → final answer.
- **Hybrid search (mentioned)**: Metadata on chunks can support filtering or hybrid search in addition to embedding similarity (covered in more depth later in the course).

## Limitations / edge cases

- Default **~300-character** chunking is arbitrary; may split thoughts poorly compared to sentence-, paragraph-, or semantic-aware strategies.
- **Graph databases** or knowledge graphs may fit some domains better than flat text chunks.
- Vector store and embedding choices affect cost, latency, and retrieval quality; one size does not fit all domains.
- UI and service capabilities evolve; region and model access requirements still apply.

## Key takeaways

- Bedrock **knowledge bases** are managed RAG: ingest → embed → vector store → retrieve → generate.
- Data sources include **S3**, **web crawler**, and **third-party connectors** (Confluence, Salesforce, SharePoint).
- You choose **embedding model**, **vector dimensions**, **vector store**, and **chunking** parameters.
- At query time, **semantic search** supplies **context** chunks that augment the LLM prompt.
- Use the console for quick tests, **APIs** for applications, and **agents** for larger agentic systems.

## Industry scenarios

1. **HR policy assistant**: Employee handbook PDFs in S3 feed a knowledge base; HR chatbot retrieves policy sections and answers with citations instead of generic model guesses.
2. **Sales enablement**: Confluence and SharePoint connectors keep battle cards and pricing docs indexed; reps query “latest discount rules for enterprise” and get grounded snippets.
3. **Support knowledge base**: Product manuals chunked and embedded in OpenSearch or Aurora; support UI calls `RetrieveAndGenerate` so answers stay aligned with official documentation.

## References

- [Retrieval-Augmented Generation (RAG)](retrieval-augmented-generation-rag/index.md)
- [Vector Stores and Semantic Search](vector-stores-and-semantic-search/index.md)
- [Hands-On with Knowledge Bases](hands-on-with-knowledge-bases/index.md)
- [Pre-Retrieval and Chunking Strategies](pre-retrieval-and-chunking-strategies/index.md)
- [Really, don't leave OpenSearch up and running for long!](really-dont-leave-opensearch-up-and-running-for-long/index.md)
- <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/knowledge-base.html">Amazon Bedrock Knowledge Bases</a>
- <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/kb-how-it-works.html">How knowledge bases work</a>
