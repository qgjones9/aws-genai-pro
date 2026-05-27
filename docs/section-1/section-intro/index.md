# Section Intro

## What this lecture covers

This section grounds you in **generative AI fundamentals** and **Amazon Bedrock** before advanced architectures and exam scenarios. You will move from Bedrock basics (playground, fine-tuning including LoRA, multimodal pipelines) through **RAG**, vector stores, chunking, and pre-retrieval; then guardrails, token redaction, prompt engineering, prompt flows, and response templates; and finally enterprise integration and the **AWS Well-Architected Generative AI Lens** for secure, scalable real-world designs.

## Key definitions (from the lecture)

| Term | Definition |
|---|---|
| **Amazon Bedrock** | AWS’s foundation for generative AI offerings in this course—models, APIs, and supporting services you build on. |
| **Retrieval augmented generation (RAG)** | Augmenting prompts with retrieved external data instead of relying only on the model’s training cutoff. |
| **Vector store / knowledge base** | Storage and retrieval layer for semantic search over embeddings (Bedrock uses **knowledge bases** for managed RAG). |
| **Bedrock guardrails** | Policies to filter objectionable content and protect sensitive information in inputs and outputs. |
| **Prompt flows** | Structured, repeatable prompt workflows (covered later in the section). |
| **AWS Well-Architected Generative AI Lens** | Lens for designing GenAI workloads with security, scalability, and operational best practices. |

## Key distinctions / comparisons

| Topic | Notes |
|---|---|
| **Foundation vs exam depth** | This section builds conceptual and hands-on foundation; later material goes deeper for certification scenarios. |
| **Fine-tuning vs RAG** | Fine-tuning bakes domain data into a custom model; RAG injects retrieved context per request (both appear in this section’s arc). |
| **Multimodal vs text-only** | Bedrock supports text, images, and more via multimodal models and pipelines—not only chat completions. |

## The problem (why you need it)

- Advanced GenAI and Bedrock topics assume shared vocabulary (embeddings, chunking, guardrails, prompt structure).
- Production systems need both **model choice** and **data/retrieval**, **safety**, and **architecture** patterns—not isolated API calls.
- Exam-focused material later assumes you already understand how Bedrock pieces fit together.

## The solution

- Progress through a deliberate sequence: Bedrock and playground → customization (fine-tuning / LoRA) → RAG and vectors → ingestion and optimization → safety and prompts → enterprise and Well-Architected patterns.
- Use hands-on labs where possible so strengths and weaknesses of models and configurations are concrete before moving on.

## Examples

- **Playground exploration**: Compare models and modalities before wiring the same models through the Converse API in application code.
- **RAG pipeline**: Chunk documents, embed into a vector store, retrieve into the prompt—previewed here, detailed in later lectures.
- **Brand-consistent outputs**: Combine prompt engineering, optional fine-tuning, and guardrails as the section unfolds.

## Limitations / edge cases

- Section intro is a **roadmap**, not hands-on depth; each topic has dedicated lectures and labs.
- Not every Bedrock model supports every capability (fine-tuning, modalities, playground modes)—details come in model-specific lessons.

## Key takeaways

- Section 1 establishes **GenAI + Bedrock fundamentals** end to end.
- You will touch **models, RAG, vectors, guardrails, prompts, and architecture** before deeper exam content.
- Finishing this section means you are ready to **build real applications** and absorb advanced material.

## Industry scenarios

1. **Platform team onboarding**: New engineers use this section’s arc as a curriculum map before owning Bedrock-based internal tools.
2. **Solution architect ramp-up**: A consultant maps customer requirements (RAG vs fine-tune, guardrails, enterprise integration) to the lecture sequence before proposing an architecture.
3. **ML engineer role change**: Someone moving from batch ML to GenAI products learns Bedrock’s managed surface area and vocabulary before implementing a knowledge base.

## References

- <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/what-is-bedrock.html">What is Amazon Bedrock?</a>
- <a href="https://docs.aws.amazon.com/wellarchitected/latest/generative-ai-lens/generative-ai-lens.html">AWS Well-Architected Framework – Generative AI Lens</a>
- [Section 1 index](../index.md)
