# Low-Rank Adaptation (LoRA) - How Fine-Tuning Works

## What this lecture covers

**LoRA (low-rank adaptation)**—how fine-tuning often works under the hood: extra **low-rank matrices** at the **attention** layer, combined with base weights at inference, versus retraining the full foundation model or using **adapter layers** on top.

## Key definitions (from the lecture)

| Term | Definition |
|---|---|
| **LoRA** | Low-rank adaptation: efficient fine-tuning by adding small trainable matrices instead of retraining the entire model. |
| **Self-attention** | Layer where the model relates words in context; central to transformer LLMs (“Attention Is All You Need”). |
| **Low-rank matrices** | Small extra weight matrices (lower complexity) trained and added alongside base weights. |
| **Base / pre-trained weights** | Original foundation model weights, left unchanged during LoRA-style training. |
| **Fine-tuned weights** | Side matrices trained on your data; **added** to base weights at inference. |
| **Adapter layer** | Alternative fine-tuning: extra layer **on top** of the stack embedding tuned information. |

## Key distinctions / comparisons

| Item | Notes |
|---|---|
| **Full retrain vs LoRA** | Retraining entire LLMs is huge and costly; LoRA **tacks on** efficient side weights. |
| **LoRA vs adapter on top** | LoRA places matrices **alongside** layers (especially attention); adapters add a **top** layer—LoRA **tends to work better** per lecture. |
| **Side vs top** | “Slapping onto the **side**” (LoRA) vs “slapping onto the **top**” (adapter layers). |
| **Exam depth** | No expectation to know low-rank **math**—conceptual mechanism only. |

## The problem (why you need it)

- Full foundation models are enormous; retraining from scratch for each use case is impractical and expensive.
- You still need domain adaptation without discarding the general capabilities of the pre-trained model.

## The solution

- Train **low-rank matrices** (often at the **attention** layer, sometimes elsewhere).
- At **inference**, combine **pre-trained weights + fine-tuned side weights** (addition) before generating output.
- Base model storage stays stable; only smaller LoRA weights are trained and shipped—better for **storage, training, and inference** efficiency.

## How to apply it

Conceptual inference flow (not exam code):

```
input → [ base pretrained weights  +  fine-tuned LoRA weights ] → output
```

Bedrock exposes fine-tuning as managed jobs; LoRA is the common **efficiency pattern** behind many foundation-model customization offerings—you choose data and model, AWS runs the optimization approach supported for that model family.

## Examples

- **Domain chatbot**: LoRA adapts attention patterns for medical or legal phrasing without rebuilding a 70B-parameter model.
- **Style transfer (tone)**: Small matrices capture “pirate speak” or brand tone examples from [Fine-Tuning Foundation Models](../fine-tuning-foundation-models-in-bedrock/index.md) with far less compute than full fine-tune of all parameters.
- **Exam framing**: “Weights added at inference from side matrices” distinguishes LoRA from “replace entire model.”

## Limitations / edge cases

- Lecture focuses on **attention** as the most interesting locus; other layers may be targeted in implementations.
- **Adapter-on-top** approaches exist and work, but LoRA is preferred in the course narrative.
- Under-the-hood math (rank, matrix factorization) is out of scope for the exam.

## Key takeaways

- LoRA fine-tunes by adding **small side matrices**, especially at **self-attention**, not by discarding the foundation model.
- At inference, **base + fine-tuned weights** are combined—efficient storage and training.
- **Side (LoRA) vs top (adapter)** is the key architectural distinction to remember.

## Industry scenarios

1. **ML platform team**: Ships LoRA adapters per customer vertical on one shared base model to avoid N full model copies in GPU memory.
2. **Fine-tune vendor comparison**: Architects explain to leadership why Bedrock/customization jobs are cheaper than private full retrain of open-weights LLMs.
3. **Research to production**: Data scientists prototype LoRA locally, then use Bedrock custom models for managed training and unified inference IDs.

## References

- <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/custom-models.html">Customize your model to improve performance</a>
- [Fine-Tuning Foundation Models in Bedrock](../fine-tuning-foundation-models-in-bedrock/index.md)
