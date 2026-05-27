# Vector Stores and Semantic Search

## What this lecture covers

How **vector stores** power RAG retrieval: choosing data stores (graph, OpenSearch, vector DB), what **embeddings** are, how **semantic search** and **k-nearest neighbor** lookup work, scale optimizations, Bedrock/OpenSearch alignment, and a **Star Trek** walkthrough of embed → search → augment prompt.

## Key definitions (from the lecture)

| Term | Definition |
|---|---|
| **Data store (Bedrock)** | Backend a **knowledge base** queries; Bedrock does not always say “RAG” but uses this term. |
| **Vector database / vector store** | Database storing original content plus **embedding vectors** for similarity search. |
| **Embedding** | High-dimensional vector representing the **meaning** of text (or other media). |
| **Semantic search** | Finding items **close in embedding space** to the query vector (similar meaning ≈ close geometry). |
| **Vector search / k-NN** | Query top-**k** nearest vectors to the prompt embedding (often **cosine** distance). |
| **Embedding model** | Foundation model (e.g. **Titan**) that batch-computes vectors for ingestion. |

## Key distinctions / comparisons

| Item | Notes |
|---|---|
| **Graph DB vs vector vs keyword** | Graph (e.g. **Neo4j**) fits relationships; **OpenSearch TF/IDF** is classic text search; **vector + semantic** dominates modern RAG examples. |
| **OpenSearch / Elasticsearch** | Can act as **vector** and keyword engine—common with Bedrock knowledge bases (Amazon product alignment). |
| **Purpose-built vs adapted DB** | Pinecone, Weaviate, Chroma, Qdrant, etc. vs SQL/Redis/Mongo/Cassandra/Neptune adding vector features. |
| **2D teaching diagram vs production** | Lectures use 2D plots; real embeddings often have **hundreds or thousands** of dimensions. |
| **k (top results)** | More neighbors in the prompt can help or hurt quality and token cost. |

## The problem (why you need it)

- RAG quality hinges on retrieving **relevant** passages; keyword-only search misses paraphrases and semantic matches.
- Large corpora cannot be linear-scanned naively at scale without **approximate nearest neighbor** optimizations.

## The solution

- Chunk source documents; compute **embeddings**; store text + vectors in a **vector-capable** data store.
- At query time: embed the **prompt** → **vector search** (top-k similar) → return associated text → **inject into prompt** for the LLM.

```
Chunks → embedding model → vector DB
User prompt → embed prompt → top-k similar vectors → text snippets → augmented LLM prompt
```

## How to apply it

```python
# Illustrative flow (Bedrock Knowledge Bases automate much of this)
query = "Data, tell me about your daughter, Lwaxana"
query_vector = embed(query)  # Titan or other embedding model
hits = vector_index.search(query_vector, k=5)  # cosine similarity typical
context = "\n".join(h["text"] for h in hits)
prompt = f"You are Commander Data...\nRelated lines:\n{context}\n\nQuestion: {query}"
```

**Ingestion (batch)**

- Send piles of text through an embedding foundation model once; store vectors beside source text—relatively **inexpensive** per lecture.

## Examples

- **2D intuition**: “potato” and “rhubarb” vectors sit near each other (vegetable-ish); sci-fi ship terms cluster in another region of space.
- **Star Trek RAG**: Embed question about Data’s daughter; semantic search over script lines; top lines about Lal/Lwaxana folded into a Data-roleplay prompt—**k**, relevance, and prompt wording all affect quality.
- **Store choice**: OpenSearch for AWS-native knowledge bases; Pinecone called out as frequently seen commercially.

## Limitations / edge cases

- Wrong **k** or irrelevant neighbors → wrong answers even with a strong LLM.
- **Chunking** (fixed character splits) may break coherent thoughts—retrieval suffers (ties to later chunking lectures).
- Vector indices need **maintenance** at scale (later lectures on drift/rebuild).
- “Semantic” does not guarantee factual correctness—only similarity in embedding space.

## Key takeaways

- Embeddings encode **meaning** as vectors; similar meaning ⇒ **nearby** in vector space.
- Retrieval = embed query + **top-k** neighbor search (optimized beyond brute force at scale).
- Bedrock knowledge bases commonly point at **OpenSearch**; many databases now support vectors.
- End-to-end RAG sensitivity: **embedding model**, **k**, chunk quality, and **prompt template**.

## Industry scenarios

1. **E-commerce discovery**: Product descriptions embedded for “gift for marathon runner” queries that keyword search misses.
2. **Legal discovery**: Matter-specific document embeddings in OpenSearch Serverless behind a Bedrock knowledge base for paralegal Q&A.
3. **Engineering runbooks**: Incident postmortems chunked and embedded; on-call bot retrieves semantically similar past outages from vector store.

## References

- <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/knowledge-base.html">Amazon Bedrock Knowledge Bases</a>
- <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/knowledge-base-setup.html">Create a knowledge base by connecting to a data source</a>
- <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/embeddings.html">Generate embeddings</a>
- <a href="https://docs.aws.amazon.com/opensearch-service/latest/developerguide/knn.html">k-NN search in Amazon OpenSearch Service</a>
- [Retrieval-Augmented Generation (RAG)](../retrieval-augmented-generation-rag/index.md)
- [Bedrock Knowledge Bases](../bedrock-knowledge-bases/index.md)
- [Pre-Retrieval and Chunking Strategies](../pre-retrieval-and-chunking-strategies/index.md)
