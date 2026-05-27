# Retrieval-Augmented Generation (RAG)

## What this lecture covers

**Retrieval augmented generation (RAG)** as an alternative to fine-tuning: retrieve relevant external data, **augment the prompt**, then generate an answer. In Bedrock, managed RAG appears as **knowledge bases**. Includes pros/cons, token trade-offs, hallucination limits, Jeopardy-style flow, and honest critique of RAG as search-plus-rephrase.

## Key definitions (from the lecture)

| Term | Definition |
|---|---|
| **RAG** | Technique: query external data, inject results into the prompt, then call the LLM—an “open book exam” for models. |
| **Knowledge base (Bedrock)** | Bedrock name for the RAG data store and retrieval path (understanding RAG is prerequisite). |
| **Retriever** | Component that finds relevant documents for a user query (often via embeddings). |
| **Generator** | Underlying foundation model that produces the final answer from the augmented prompt. |
| **Semantic search** | Search by **meaning** similarity (often vector DB + embeddings), not only keywords. |
| **Embedding** | Vector encoding of text meaning used for similarity lookup (detailed in vector store lecture). |
| **Hallucination** | Model inventing facts; RAG can **reduce** but not eliminate this. |

## Key distinctions / comparisons

| Item | Notes |
|---|---|
| **RAG vs fine-tuning** | RAG is **faster/cheaper** to refresh data (update DB); fine-tuning bakes data into weights. |
| **RAG vs training** | External data is **not training** the model—only fed in the prompt (important for compliance narratives). |
| **Short-term vs long-term cost** | RAG avoids retraining but **increases prompt tokens** every call—can be false economy. |
| **Vector vs other stores** | Can use graph DB, OpenSearch TF/IDF, hybrid, or vector DB—lecture emphasizes **vector + semantic** as common. |
| **RAG vs LLM agents/tools** | Agents/tools can augment retrieval in a more principled way (covered later). |
| **Marketing “AI search”** | Often implemented as RAG: search + LLM rephrase (cynical view)—model can still expand beyond raw snippets. |

## The problem (why you need it)

- Foundation models have **training cutoffs** and lack private corpora (e.g. “What did the president say yesterday?”).
- Fine-tuning on every new document is **slow and expensive**.
- Users need **up-to-date**, **proprietary**, or **domain** answers without retraining.

## The solution

1. Take user **prompt**.
2. **Retrieve** relevant passages from an external database / **knowledge base** (semantic or other search).
3. **Augment** prompt with retrieved text (template matters).
4. Pass augmented prompt to the **generator** (foundation model).

```
User prompt → Retriever (embed/query KB) → Top documents
      → Augmented prompt → Foundation model → Answer
```

## How to apply it

**Jeopardy-style example from the lecture**

- Question: “In 1986, Mexico scored its first country to host its international sports competition twice. What happened?”
- Retriever embeds query, searches trivia/knowledge base for Mexico / 1986 / sports articles.
- Augmented prompt includes retrieved articles; generator answers: **“What is the World Cup?”**

**News-style prompt**

- Original: “What did the president say in his speech yesterday?”
- Retrieved article text appended; model answers from provided context instead of cutoff knowledge.

```python
# Conceptual pattern (production often uses Bedrock Knowledge Bases API)
# 1) embed query  2) vector search  3) build prompt with top-k chunks  4) converse()
augmented = f"{user_question}\n\nContext:\n{retrieved_passage}\n\nAnswer using the context."
```

## Examples

- **Stale news**: President speech question answered from news index, not model memory.
- **Jeopardy bot**: External trivia DB + generator for game-style answers.
- **Enterprise “AI search”**: Internal wiki chunks retrieved and summarized for employees.

## Limitations / edge cases

- **Not a silver bullet for hallucinations**—model may still invent when context is missing or ignored.
- **Relevancy is the hardest part**—bad chunks (e.g. fixed-size splits without coherent thoughts) ruin answers.
- **Prompt template sensitivity**—how you wrap retrieved text changes outputs.
- **Non-determinism** complicates testing even with low temperature.
- **Cost/complexity**: Vector stores use storage and compute; lecture calls RAG “world’s most overcomplicated search engine” at times—still search results **rephrased** by an LLM.
- **Token growth** from large contexts on every request.

## Key takeaways

- RAG = **retrieve → augment prompt → generate**; Bedrock packages this as **knowledge bases**.
- Pros: **faster/cheaper updates**, semantic search, helpful for cutoff/proprietary data, compliance-friendly “not training on your docs.”
- Cons: **relevancy**, template sensitivity, tokens, infrastructure cost, remaining hallucinations.
- Quality depends more on **chunking and retrieval** than on the LLM alone.

## Industry scenarios

1. **Corporate policy assistant**: HR policies in OpenSearch/knowledge base; answers cite retrieved paragraphs updated when policy PDFs change—no full model retrain.
2. **Customer support**: Ticket history and help articles retrieved per question; team tunes prompt template after seeing irrelevant chunk failures.
3. **Media monitoring**: Daily news index powers “what did X say yesterday” queries for analysts without fine-tuning a new model each morning.

## References

- <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/knowledge-base.html">Retrieve data and generate responses using Amazon Bedrock Knowledge Bases</a>
- <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/kb-how-it-works.html">How knowledge bases work</a>
- [Vector Stores and Semantic Search](../vector-stores-and-semantic-search/index.md)
- [Fine-Tuning Foundation Models in Bedrock](../fine-tuning-foundation-models-in-bedrock/index.md)
- [Bedrock Knowledge Bases](../bedrock-knowledge-bases/index.md)
