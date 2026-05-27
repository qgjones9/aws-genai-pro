# Fine-Tuning Foundation Models in Bedrock

## What this lecture covers

How **fine-tuning** in <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/custom-models.html">Amazon Bedrock</a> extends a foundation model with your data, when it beats heavy prompt engineering or RAG on token cost, and how **custom models** vs **continued pre-training** differ—plus security (VPC + PrivateLink), cost, and training data format.

## Key definitions (from the lecture)

| Term | Definition |
|---|---|
| **Fine-tuning** | Additional training on top of a foundation model so new behavior is **baked into** the model weights, not only appended in a prompt. |
| **Custom model** | Bedrock term for a fine-tuned model you invoke like any other model via the same API with a new **model identifier**. |
| **Prompt / completion pairs** | Supervised fine-tuning format: example questions (prompts) and desired answers (completions) in simple JSON. |
| **Continued pre-training** | Fine-tuning variant using **unlabeled** raw text (no prompt/completion pairs)—domain documents baked into the model. |
| **VPC with PrivateLink** | Secure path called out for training/fine-tuning with sensitive or proprietary data (exam-relevant). |

## Key distinctions / comparisons

| Item | Notes |
|---|---|
| **Fine-tuning vs prompt engineering** | Fine-tuning avoids stuffing large example sets into every prompt; can **save tokens** long term. |
| **Fine-tuning vs RAG** | RAG adds retrieved text per request; fine-tuning embeds knowledge/style in the model (RAG covered separately). |
| **Custom model vs continued pre-training** | Labeled Q&A pairs → custom model; **unlabeled** text blocks → continued pre-training. |
| **Short-term vs long-term cost** | Fine-tuning is **expensive up front** (money and time); may be cheaper over many inferences vs huge prompts. |

## The problem (why you need it)

- Base models lack **brand voice**, **recent** facts past cutoff, or **proprietary** behavior.
- Huge few-shot prompts are costly and brittle for stable tone, classification, or support style.
- Some tasks (personality, ad copy tone, custom classifiers) need consistent behavior without retrieving docs every time.

## The solution

- Upload training data to **S3** (text Q&A JSON, or for image models: prompts + image references in S3).
- Start a Bedrock fine-tuning job on a **supported** foundation model; receive a **custom model ID**.
- For sensitive data, run training connectivity via **VPC with PrivateLink**.
- Optionally **fine-tune again** on top of an already customized model as new data arrives.

## How to apply it

**Text fine-tuning data** (conceptual—one prompt/completion pair per line or record in your JSON corpus):

```json
{"prompt": "What is the capital of Mars in our canon?", "completion": "New New York, per the 3025 gazetteer."}
{"prompt": "Classify sentiment: 'The warp core is stable.'", "completion": "positive"}
```

**Invoke the custom model** (same Converse/invoke pattern, new ID):

```python
# After job completes, use the custom model ARN/ID from the console
model_id = "your-custom-model-identifier"
# client.converse(modelId=model_id, messages=[...])
```

**Image fine-tuning**: provide prompts plus **links to images in S3**; supports text-to-image and image-to-image customization per lecture.

## Examples

- **Brand voice**: Train on past ads so generated copy matches company tone—not generic “obvious AI” wording.
- **Support bot**: Fine-tune on transcripts of real customer interactions for consistent handling style.
- **Classification**: Pairs of items labeled true/false or category labels teach behavior the base model was not designed for.
- **“Clone” assistant**: Proprietary emails/messages as training signal (privacy/legal review required in production).
- **Recent facts**: Inject knowledge newer than the base model’s training cutoff via training data.

## Limitations / edge cases

- **Not all models** support fine-tuning—check the model card first.
- **Cost and duration** are high; many teams start with RAG or prompt engineering.
- Continued pre-training and custom models can both get **expensive and time-consuming**; course has no hands-on for continued pre-training.
- Image and text paths differ; Titan and other families mentioned as examples—catalog evolves.

## Key takeaways

- Fine-tuning **extends** the foundation model; custom models use the **same API** with a new ID.
- **Labeled** pairs vs **unlabeled** text chooses custom fine-tune vs continued pre-training.
- **VPC + PrivateLink** for sensitive training data is worth remembering for the exam.
- Trade **upfront training cost** for potentially **lower per-request token** use vs giant prompts.

## Industry scenarios

1. **Marketing team**: Fine-tune on historical campaigns so email and social drafts match regulated brand voice without 20-shot prompts every call.
2. **Financial services**: Continued pre-training on policy PDFs inside VPC/PrivateLink so internal terminology is in-model while keeping data off repeated prompt injection.
3. **Support platform**: Custom model trained on resolved ticket transcripts reduces tokens vs stuffing transcripts into RAG context on every question.

## References

- <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/custom-models.html">Customize your model to improve performance</a>
- <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/custom-models-pretrain.html">Continued pre-training</a>
- <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/custom-model-vpc.html">Use VPC for model customization jobs</a>
- [Low-Rank Adaptation (LoRA)](../low-rank-adaptation-lora-how-fine-tuning-works/index.md)
- [Retrieval-Augmented Generation (RAG)](../retrieval-augmented-generation-rag/index.md)
