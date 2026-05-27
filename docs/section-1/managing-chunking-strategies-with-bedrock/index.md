# Managing Chunking Strategies with Bedrock

## What this lecture covers

Bedrock Knowledge Base **chunking options**: standard fixed-size chunking (tokens, overlap, sentence boundaries), **no chunking** for pre-processed documents, **hierarchical** parent/child chunks, and **semantic** chunking parameters (buffer size, breakpoint percentile) plus cost implications.

## Key definitions (from the lecture)

| Term | Definition |
|---|---|
| **Standard chunking** | Heuristic-based approaches (not FM-driven), including fixed-size splitting. |
| **Fixed-size chunking** | Chunks contain a set number of **tokens** with configurable **overlap percentage** between consecutive chunks. |
| **Overlap** | Repeated tokens from preceding/following chunks so boundary context is not lost. |
| **Default standard chunking** | **300 tokens** per chunk, honoring **sentence boundaries** (may exceed 300 slightly to keep sentences intact). |
| **No chunking** | Each input document becomes exactly one chunk—use when you pre-split content into separate files. |
| **Hierarchical chunking** | Nested parent/child chunks: search hits precise **child** embeddings, then pull broader **parent** context. |
| **Parent / child chunk sizes** | Separate token sizes for each level (lecture example: parent 6, child 3, overlap 1 in a toy token=word demo). |
| **Semantic chunking** | Foundation model decides splits by semantic boundaries with max token cap and sentence honoring. |
| **Buffer size** | Number of sentences on each side of a sentence considered together during semantic chunking embeddings. |
| **Breakpoint percentile threshold** | How similar a chunk must be to itself; higher → fewer, larger, more distinguishable chunks. |

## Key distinctions / comparisons

| Item | Notes |
|---|---|
| **Tokens vs words** | Tokens are FM subword units; often ~1 token ≈ 1 word but not guaranteed. |
| **Fixed vs semantic** | Fixed is cheaper and predictable; semantic uses FM compute per ingest. |
| **Child vs parent retrieval** | Smaller child vectors → precision; parents restore comprehensiveness. |
| **Pre-chunked docs + no chunking** | Ultimate control: your pipeline emits one chunk per document file. |
| **Buffer too large vs too small** | Large → noise; small → miss context but may gain precision. |

## The problem (why you need it)

- Default 300-token chunks are a starting point, not optimal for every corpus.
- Tiny fixed windows (e.g. five tokens in the lecture’s Star Trek example) are not semantically meaningful in production.
- Retrieval must balance **precision** (small chunks) with **surrounding context** (overlap or parents).

## The solution

Pick a Bedrock chunking strategy aligned to content and ops constraints:

| Strategy | When it fits (from lecture) |
|---|---|
| **Fixed-size (default 300)** | General text; sentence-safe defaults. |
| **Custom fixed size + overlap** | Tune token window and overlap % for your average passage length. |
| **No chunking** | You already chunked into separate documents upstream. |
| **Hierarchical** | Need precise child hits with parent context expansion. |
| **Semantic** | Willing to pay FM cost for concept-aware splits within max token limits. |

## How to apply it

Configure at knowledge base / data source creation (console or API). Illustrative API shape:

```python
# Conceptual: chunking configuration when creating or updating a data source
chunking_configuration = {
    "chunkingStrategy": "FIXED_SIZE",
    "fixedSizeChunkingConfiguration": {
        "maxTokens": 300,
        "overlapPercentage": 20,
    },
}

# Alternatives: HIERARCHICAL, SEMANTIC, NONE — per Bedrock KB API docs
```

**Fixed-size overlap math (lecture example):** chunk size 5 tokens, overlap 20% → 1 token overlap; chunks slide with repeated boundary tokens (“these”, “of”, …).

**Hierarchical flow:** query matches child embedding → retrieve parent chunk for expanded context.

## Examples

- **Star Trek opening monologue**: Five-token chunks with 20% overlap demonstrated; production would use much larger sizes.
- **Default 300 tokens**: ~300 words of complex idea if boundaries respected; sentences not split mid-thought when avoidable.
- **Hierarchical tree**: Parent size 6, child size 3, overlap 1 on child level—hit on “space the final” child → climb to parent size 6 for more context.
- **Semantic on short snippet**: A single coherent thought may remain one chunk; breakpoint/buffer tuning matters on longer corpora.

## Limitations / edge cases

- **Semantic chunking costs money**—FM charges apply to large ingest jobs.
- Exam may test **buffer size** and **breakpoint percentile** semantics specifically.
- Toy examples use **one token = one word** simplification; real tokenization differs.
- Very small chunk sizes are pedagogical, not recommended operationally.

## Key takeaways

- **Standard fixed-size**: `maxTokens` + `overlapPercentage`; default **300 tokens**, **sentence-safe**.
- **Overlap** preserves cross-boundary context.
- **No chunking** = one chunk per uploaded document when you pre-chunk externally.
- **Hierarchical**: search **children**, expand to **parents** for context vs precision trade-off.
- **Semantic chunking**: FM-driven splits with **max tokens**, **buffer size**, **breakpoint percentile**; use wisely due to cost.
- Higher **breakpoint percentile** → fewer, bigger, more distinguishable chunks.

## Industry scenarios

1. **API documentation KB**: Fixed 400-token chunks with 15% overlap so code samples split across chunk boundaries still appear in at least one complete chunk.
2. **Policy manual with chapters**: Hierarchical chunking—child paragraphs for search, parent section text injected into the FM prompt for legal nuance.
3. **Research paper archive**: Semantic chunking on ingest for concept boundaries; finance team monitors Bedrock FM spend on indexing jobs.

## References

- [Pre-Retrieval and Chunking Strategies](../pre-retrieval-and-chunking-strategies/index.md)
- [Hands-On with Knowledge Bases](../hands-on-with-knowledge-bases/index.md)
- [Optimizing your Vector Store and Embeddings](../optimizing-your-vector-store-and-embeddings/index.md)
- <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/kb-chunking.html">Customize chunking for a data source</a>
- <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/knowledge-base.html">Knowledge bases</a>
