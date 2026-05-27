# Pre-Retrieval and Chunking Strategies

## What this lecture covers

Exam-depth treatment of the **R** in RAG: splitting retrieval into **pre-retrieval**, **retrieval**, and **post-retrieval** stages, with emphasis on how **storage granularity** and **chunking** choices before runtime query affect answer quality, plus **semantic chunking** using an LLM.

## Key definitions (from the lecture)

| Term | Definition |
|---|---|
| **Pre-retrieval** | Everything before runtime lookup: how data is stored/chunked in the vector store and optional query rewriting—choices made at ingest/index time and sometimes on incoming queries. |
| **Retrieval** | Fetching candidate chunks from the vector store (mechanism depends on store; lecture treats as less exam-interesting). |
| **Post-retrieval** | Processing retrieved context: re-ranking, selecting most relevant passages, further augmentation, then generation. |
| **Chunking** | Splitting a large corpus into chunks stored in the vector DB so queries can retrieve relevant pieces later. |
| **Data granularity** | How large each stored unit is (sentence, line, paragraph, fixed token window, summary, etc.). |
| **Semantic chunking** | Using an LLM to decide chunk boundaries by semantic similarity of text rather than fixed rules only. |

## Key distinctions / comparisons

| Item | Notes |
|---|---|
| **Pre- vs post-retrieval** | Pre = index-time storage and query-prep; post = what you do with hits before the FM sees them (re-rank, filter, augment). |
| **Too large vs too small chunks** | Large chunks add context but hurt relevance; tiny snippets lack meaning on their own. |
| **Raw lines vs surrounding dialogue** | Lieutenant Commander Data example: line-only storage may need neighboring lines for context, or LLM summaries instead of raw script lines. |
| **Fixed rules vs semantic chunking** | Sentence/paragraph/token splits are cheap; LLM-driven splits are flexible but **expensive and slow**. |
| **Token limits then vs now** | Older/smaller models choke on huge context; modern models accept very large contexts, but **effective** context still has practical limits. |

## The problem (why you need it)

- High-level RAG diagrams are not enough for the exam—you must understand **retrieval stage mechanics**.
- Poor **granularity** yields irrelevant or context-starved chunks at query time.
- Dumping excessive retrieved text into the FM can derail answers even when under hard token caps.

## The solution

**Three-stage RAG retrieval pipeline:**

1. **Pre-retrieval**: Chunk/index design (and optional query rewriting before search).
2. **Retrieval**: Vector (or hybrid) search returns candidate context.
3. **Post-retrieval**: Re-rank, curate, augment context, then generate.

Optimize **pre-retrieval** by choosing chunk sizes and representations that balance **context** and **precision** for your domain.

## How to apply it

Design questions before choosing chunking:

- What is the **smallest meaningful unit** (sentence, paragraph, utterance + neighbors)?
- Do you need **summaries** instead of raw text?
- Will queries be rewritten before search (pre-retrieval on the query side)?

Semantic chunking prompt pattern (concept from lecture / original paper idea):

```python
# Illustrative pattern: ask an FM to propose semantically coherent chunks
prompt = """
Decompose the following document into chunks that preserve complete ideas.
Prefer boundaries where topics change. Respect a max token size per chunk.

Document:
{document_text}
"""
# Then ingest resulting chunks into Bedrock Knowledge Base (possibly with "no chunking")
```

Bedrock-specific chunking controls are detailed in [Managing Chunking Strategies with Bedrock](../managing-chunking-strategies-with-bedrock/index.md).

## Examples

- **Star Trek “Data” bot**: Store every line Data spoke vs whole scenes vs sentence-level with neighbor lines vs LLM summaries—each changes retrieval quality for in-character responses.
- **Fixed token chunks**: Every N tokens, every sentence, or every paragraph as simple pre-retrieval rules.
- **Semantic chunking**: Pass a large document through an FM that groups semantically similar sentences before embedding.

## Limitations / edge cases

- Chunking strategy is described as an **art**, not one correct setting.
!!! warning "Semantic chunking cost"
    **Semantic chunking** runs content through a foundation model—**cost and latency scale** with corpus size; use when quality gains justify FM spend.

- Very large context windows reduce hard failures but **too much context** can still confuse models.
- Exam expects deeper retrieval knowledge than console defaults alone.

## Key takeaways

- Split RAG retrieval into **pre-retrieval**, **retrieval**, and **post-retrieval**.
- **How you store data** (granularity/chunking) strongly affects relevance and surrounding context.
- **Chunking** = splitting corpus for vector storage; core exam term.
- Balance chunk size: enough context, not so much that relevance drops; not so small snippets are meaningless.
- **Semantic chunking** uses an LLM to split by meaning—powerful but costly.
- **Less is sometimes more** when feeding retrieved context to the FM.

## Industry scenarios

1. **Legal research assistant**: Chapters chunked by section and clause boundaries (pre-retrieval) so retrieval returns complete obligations, not arbitrary 300-token fragments.
2. **Character chatbot for media IP**: Screenplay stored with neighboring speaker lines per chunk so a single utterance retains scene context.
3. **Enterprise wiki refresh**: Pre-retrieval pipeline re-chunks updated Confluence pages on ingest while post-retrieval re-ranker (later course topic) orders hits before the answer model runs.

## References

- [Retrieval-Augmented Generation (RAG)](../retrieval-augmented-generation-rag/index.md)
- [Managing Chunking Strategies with Bedrock](../managing-chunking-strategies-with-bedrock/index.md)
- [Optimizing your Vector Store and Embeddings](../optimizing-your-vector-store-and-embeddings/index.md)
- [Bedrock Knowledge Bases](../bedrock-knowledge-bases/index.md)
- <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/kb-chunking.html">Knowledge base chunking</a>
- <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/kb-how-retrieval.html">Retrieval from knowledge bases</a>
