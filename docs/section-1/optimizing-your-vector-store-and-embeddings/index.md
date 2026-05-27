# Optimizing your Vector Store and Embeddings

## What this lecture covers

Beyond chunking, optimize RAG retrieval by tuning **embedding vector size**, understanding **sparse vs dense** embeddings and **similarity** (especially **cosine similarity**), attaching **metadata** for hybrid retrieval and re-ranking, and keeping knowledge bases **fresh** with event-driven ingestion patterns.

## Key definitions (from the lecture)

| Term | Definition |
|---|---|
| **Embedding vector** | Numeric representation of a text chunk’s meaning; closeness in vector space ≈ semantic similarity. |
| **Vector dimension** | Number of dimensions per embedding; larger can capture nuance, smaller saves storage and wire cost. |
| **Sparse embedding** | Mostly empty vector (e.g. one-hot animal categories); high similarity contrast but wasted space. |
| **Dense embedding** | Floating-point dimensions packing semantic meaning—standard in generative AI RAG. |
| **Similarity factor** | Metric for how close two vectors are (lecture highlights **cosine similarity**). |
| **Cosine similarity** | Cosine of angle between vectors; identical → 1, orthogonal/unrelated → 0; smooth for math use. |
| **Metadata** | Non-content fields attached per chunk (via `metadata.json`); not chunked as body text. |
| **Hybrid search** | Combine semantic vector distance with metadata filters or scoring. |
| **Re-ranking** | Using metadata (among other signals) to reorder retrieval results—covered later in the course. |
| **Ground truth (evaluation)** | Optional reference contexts/responses for measuring retrieval quality. |

## Key distinctions / comparisons

| Item | Notes |
|---|---|
| **Chunking vs embedding size optimization** | Chunking shapes what is retrieved; dimension count shapes how meaning is encoded and stored. |
| **Too large vs too small vectors** | Oversized wastes money/bandwidth; undersized hurts retrieval quality. |
| **Sparse vs dense** | Sparse common in recommenders with strong similarity signals; dense efficient for GenAI vector stores. |
| **Semantic search vs metadata tuning** | Vectors find candidates; metadata can refine or re-rank (hybrid). |
| **Lambda per S3 event vs batched ingest** | Concept: trigger updates on change; practice should batch to avoid hammering `StartIngestionJob`. |

## The problem (why you need it)

- Default **Titan** dimensions (~1024–1536 cited) may cost more to store than a **300-character** chunk of source text.
- Wrong vector size for a simple domain wastes money; too small a dimension loses meaning for complex domains.
- Stale indexes produce outdated answers; unbatched ingestion triggers can overwhelm Bedrock ingest APIs.

## The solution

**Optimization levers:**

1. Match **embedding dimensions** to domain complexity and chunk size.
2. Use **dense** embeddings for typical Bedrock RAG; understand sparse mainly for contrast/recommender patterns.
3. Measure relatedness with **cosine similarity** (common in vector search).
4. Supply **metadata.json** per chunk for hybrid retrieval, access control, citations, lineage.
5. Refresh KB on new/changed content via **S3 events → Lambda → ingestion job**, preferably **batched** (AWS Batch / EventBridge queuing mentioned as better than per-second triggers).

## How to apply it

### Metadata sidecar (concept)

```json
{
  "metadataAttributes": {
    "section": "introduction",
    "topic": "biology",
    "keywords": ["chicken", "domesticated bird", "meat", "eggs"]
  }
}
```

Associate metadata with a chunk whose text is: *“A chicken is a domesticated bird commonly raised for meat and eggs.”* Hybrid retrieval can combine vector distance with metadata relevance.

### Cosine similarity (illustrative)

```python
import numpy as np

def cosine_similarity(a: np.ndarray, b: np.ndarray) -> float:
    return float(np.dot(a, b) / (np.linalg.norm(a) * np.linalg.norm(b)))

# Values near 1.0 → more similar meanings in embedding space
```

### Keeping KB fresh (conceptual pipeline)

```
S3 object created/changed
    → Event notification
    → Lambda (enqueue work, do not spam StartIngestionJob per second)
    → Batch / scheduled job → Bedrock knowledge base ingestion sync
```

See [section-2 re-ranker content](../../section-2/43-re-ranker-modules-in-bedrock/index.md) when you add post-retrieval re-ranking.

## Examples

- **Chicken book chunk**: Text chunk plus metadata (`introduction`, `biology`, keywords) enables hybrid search and later re-ranking.
- **Metadata use cases**: Document ID, category, **access control**, **data lineage** for citations, any extra context stored alongside vectors.
- **Titan dimension trade-off**: Simple categorization domain might experiment with smaller dimensions; complex semantic domains may need larger vectors.
- **Stale content**: New PDF in S3 triggers update pipeline instead of manual re-upload only.

## Limitations / edge cases

- Titan default dimension counts may change; lecture cites **1024** and **1536** as seen in the wild.
- Sparse vector compression on GPU is hard—sparse less common in GenAI GPU paths.
- Diagram with Lambda firing ingest on every S3 change is **conceptually sound** but **not ideal at high churn** without batching.
- Re-ranking details deferred to a later lecture.

## Key takeaways

- Tune **embedding vector dimensions** against chunk size, domain complexity, cost, and retrieval quality.
- **Dense embeddings** dominate GenAI; **sparse** illustrates similarity contrast but wastes space.
- **Cosine similarity** measures vector closeness smoothly (1 = same direction, 0 = unrelated in lecture framing).
- **metadata.json** adds per-chunk fields for hybrid search, security, citations, and lineage—not chunked as body text.
- Keep KBs current with **event-driven ingestion**, but **batch** updates in real deployments.
- The chicken approves (lecture humor on metadata value).

## Industry scenarios

1. **Multi-tenant SaaS docs**: Metadata includes `tenant_id` and `clearance_level`; hybrid retrieval filters vectors so customers never see each other’s chunks.
2. **Regulated citations**: Lineage metadata maps chunks to source PDF page; answers include auditable references in finance or healthcare assistants.
3. **Cost tuning for catalog search**: Retail product descriptions use smaller embedding dimensions after A/B tests show no retrieval regression versus 1536-dim defaults.

## References

- [Vector Stores and Semantic Search](vector-stores-and-semantic-search/index.md)
- [Managing Chunking Strategies with Bedrock](managing-chunking-strategies-with-bedrock/index.md)
- [Pre-Retrieval and Chunking Strategies](pre-retrieval-and-chunking-strategies/index.md)
- [Evaluating RAG Performance](evaluating-rag-performance/index.md)
- <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/titan-embedding-models.html">Amazon Titan Text Embeddings</a>
- <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/kb-metadata.html">Include metadata in a knowledge base</a>
- <a href="https://docs.aws.amazon.com/bedrock/latest/APIReference/API_agent_StartIngestionJob.html">StartIngestionJob</a>
