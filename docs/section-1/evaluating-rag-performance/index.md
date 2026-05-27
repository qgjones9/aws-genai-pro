# Evaluating RAG Performance

## What this lecture covers

How to measure whether a Bedrock **RAG / knowledge base / agent** system is performing well: the **RAG triad** metrics on each edge (context relevance, groundedness, answer relevance), Bedrock’s **subjective** evaluation dimensions, **ground-truth datasets**, and **LLM-as-a-judge** with optional multiple evaluator models.

## Key definitions (from the lecture)

| Term | Definition |
|---|---|
| **RAG triad** | Query → retrieve context → generate answer; quality is assessed along each leg and on the final answer. |
| **Context relevance** | How relevant retrieved context is to the original query (retrieval edge). |
| **Groundedness / faithfulness** | How well the generated answer aligns with retrieved context (generation edge). |
| **Answer relevance / correctness** | How well the final answer addresses the original query. |
| **Ground truth dataset** | JSON prompts plus reference “ideal” responses (and optionally reference contexts) you provide. |
| **Reference contexts** | Optional ideal chunks that should be retrieved—needed to measure retrieval against your expectations. |
| **LLM as a judge** | A separate foundation model scores system output against your references. |
| **Judge / evaluation model** | FM (Llama, Claude, Nova, Mistral, etc.) running metric prompts defined by Bedrock. |
| **Subjective metrics** | Correctness, completeness, helpfulness, logical coherence, faithfulness, citation precision/coverage, harm, stereotyping, refusal/evasiveness—scored via judge prompts, not only pure math. |

## Key distinctions / comparisons

| Item | Notes |
|---|---|
| **Mathematical metrics vs Bedrock subjective metrics** | Lecture points to deeper math in a separate AI engineering course; Bedrock focuses on FM-judged scores. |
| **With vs without reference contexts** | Responses-only ground truth still works for some metrics; measuring retrieval fidelity needs reference contexts. |
| **Single judge vs multiple judges** | Different models score differently; multiple judges can check agreement. |
| **Generator model vs judge model** | One FM produces RAG answers; another FM evaluates them—separate roles. |

## The problem (why you need it)

- You cannot improve a RAG system you do not measure.
- Human-only review does not scale for iterative chunking, retrieval, and prompt changes.
- Subjective qualities (helpfulness, harm) still need a repeatable evaluation loop.

## The solution

Bedrock evaluation workflow:

1. Map failures to the **triad**: bad retrieval, ungrounded generation, or irrelevant answers.
2. Build a **JSON dataset** of sample prompts + reference responses (+ optional reference contexts).
3. Run Bedrock evaluation using an **LLM judge** that compares system outputs to your references.
4. Track metrics (correctness, completeness, helpfulness, coherence, faithfulness, citations, safety, bias, refusal behavior).
5. Iterate on chunking, retrieval, models, or guardrails based on scores.

## How to apply it

Illustrative ground-truth record shape (from lecture description):

```json
{
  "prompts": [
    {
      "prompt": "What is our return policy for annual subscriptions?",
      "referenceResponse": "Annual subscriptions may be refunded within 30 days of purchase...",
      "referenceContexts": [
        "Section 4.2: Annual plans include a 30-day refund window..."
      ]
    }
  ]
}
```

- **referenceContexts** optional but required to judge whether the KB retrieved the right passages.
- Bedrock runs a **judge model** with metric-specific prompts (example in docs: Nova Pro **context relevance** prompt scoring **no / maybe / yes** with explanation).

You do not need to memorize judge prompt wording for the exam—understand the **pattern**.

## Examples

- **Context relevance (Nova Pro prompt example)**: Documented judge prompt asks whether retrieved context matches the query; output format `no | maybe | yes` plus rationale—illustrates LLM-as-judge mechanics.
- **Faithfulness check**: Answer claims a refund window not present in retrieved chunks → low faithfulness/groundedness score.
- **Multiple judges**: Claude and Llama both score helpfulness; disagreement flags metric instability.

## Limitations / edge cases

- Metrics like **helpfulness** are subjective—even with references, judgments depend on judge FM behavior.
- Exam: understand **triad**, **ground truth JSON**, **LLM judge**, optional **reference contexts**—not internal judge prompt templates.
- Mathematical evaluation approaches exist but are outside this lecture’s Bedrock-focused scope.

## Key takeaways

- Measure along the **RAG triad**: context relevance, groundedness, answer relevance.
- Bedrock adds rich **subjective** dimensions (safety, bias, citations, refusal, etc.).
- Supply **ground truth** prompts + ideal responses (+ optional ideal contexts).
- **LLM-as-a-judge** compares system output to your references using another FM.
- Different **judge models** score differently; multiple judges optional for rigor.
- Scores are somewhat subjective but still **actionable** for improvement loops.

## Industry scenarios

1. **Customer support bot QA**: Curators label 200 real tickets with ideal answers and source paragraphs; weekly Bedrock evaluation runs before promoting new chunk sizes to production.
2. **Compliance review**: Faithfulness and citation precision metrics gate releases when answers must only use retrieved policy text.
3. **Safety gate**: Harm and stereotyping scores monitored after KB updates ingest new third-party articles—judge model flags regressions before users see them.

## References

- [Retrieval-Augmented Generation (RAG)](retrieval-augmented-generation-rag/index.md)
- [Bedrock Knowledge Bases](bedrock-knowledge-bases/index.md)
- [Optimizing your Vector Store and Embeddings](optimizing-your-vector-store-and-embeddings/index.md)
- <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/knowledge-base-evaluate.html">Evaluate the performance of RAG sources</a>
- <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/model-evaluation.html">Evaluate the performance of models</a>
- <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/knowledge-base.html">Knowledge bases</a>
