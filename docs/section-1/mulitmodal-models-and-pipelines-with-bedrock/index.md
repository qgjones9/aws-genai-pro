# Mulitmodal Models and Pipelines with Bedrock

## What this lecture covers

**Multimodal** models and pipelines mix text, images, audio, video, and documents in one flow; Bedrock examples include Claude, Nova, and **Titan Multimodal Embeddings G1** for cross-modal embeddings, RAG retrieval, and API usage with **base64-encoded** images.

## Key definitions (from the lecture)

| Term | Definition |
|---|---|
| **Multimodal model** | Model with specialized encoders per media type, producing embedding vectors comparable across modalities. |
| **Multimodal pipeline** | Ingest/preprocess path that prepares each media type (e.g. base64 images) before calling Bedrock. |
| **Cross-modal retrieval** | Query with one modality (text or image) and retrieve related content in another (image + text about the same concept). |
| **Titan Multimodal Embeddings G1** | Bedrock embedding model accepting **text**, **image**, or **both** in one request. |
| **Base64 image payload** | Images must be base64-encoded (UTF-8) in JSON for the Titan multimodal embeddings API shape shown in the lecture. |

## Key distinctions / comparisons

| Item | Notes |
|---|---|
| **Text-only RAG vs multimodal RAG** | Multimodal embeddings let prompts and KB chunks include non-text media, not only paragraphs. |
| **Generation models vs embedding models** | Claude/Nova multimodal for understanding/generation; Titan multimodal embeddings for vector search. |
| **Embed query vs embed corpus** | Same model can embed incoming prompts (any supported modality) and stored KB vectors for comparison. |
| **Bedrock-built preprocessing vs SageMaker/Glue** | Lecture notes preprocessing may happen in Bedrock later or in SageMaker/Glue/custom ETL before invoke. |

## The problem (why you need it)

- Enterprise knowledge is not text-only: diagrams, scans, photos, audio, and video carry meaning.
- Text-only embeddings cannot align a photo query with a textual knowledge article about the same entity.
- Pipelines must normalize binary media into the wire format each Bedrock model expects.

## The solution

Use multimodal-capable Bedrock models end to end:

1. **Ingest**: Encode images (and other media per model docs) in your pipeline before indexing.
2. **Index**: Store multimodal embedding vectors in your vector store / knowledge base flow.
3. **Retrieve**: Query with text, image, or video embedding as supported—retrieve matching chunks regardless of stored modality.
4. **Generate / answer**: Multimodal FMs (Claude, Nova) can consume mixed inputs in prompts as supported.

Titan Multimodal Embeddings G1 request shape (from lecture):

- `modelId`
- `inputText` (optional)
- `inputImage` with **base64** bytes (optional)
- Any combination of text and/or image is valid for Titan in the lecture.

## How to apply it

```python
import base64
import json
import boto3

def embed_chicken_example(image_path: str, text: str, region: str = "us-east-1"):
    with open(image_path, "rb") as f:
        image_b64 = base64.b64encode(f.read()).decode("utf-8")

    client = boto3.client("bedrock-runtime", region_name=region)
    body = {
        "inputText": text,
        "inputImage": image_b64,
    }
    response = client.invoke_model(
        modelId="amazon.titan-embed-image-v1",  # Titan Multimodal Embeddings G1 family
        body=json.dumps(body),
        contentType="application/json",
        accept="application/json",
    )
    return json.loads(response["body"].read())

# Pipeline responsibility: base64-encode images before invoke_model
```

RAG flow (lecture):

- Embed a **picture of a chicken** and **text about chickens** into the same embedding space.
- Search “chicken” → may return **image and text** assets related to chickens.
- Prompt can be multimodal too: image in, text answer out (or vice versa).

Preprocessing belongs **before** model invoke—whether implemented in Bedrock features later or in SageMaker/Glue/other ETL (course defers tooling details).

## Examples

- **Chicken image + chicken text**: Both embedded with Titan multimodal; semantic search links visual and textual assets.
- **“Here’s a picture of something, what is it?”**: Image embedding similar to chicken corpus → retrieval returns chicken-related text chunks.
- **API snippet**: `base64.b64encode` on image bytes placed in JSON `inputImage` alongside `inputText`.

## Limitations / edge cases

- Lecture focuses on **Titan Multimodal Embeddings G1** API shape; full pipeline tooling (SageMaker, Glue, Bedrock automation) is “later in the course.”
- You must implement **base64 encoding** (or equivalent) in the data pipeline for images in this API pattern.
- Not every Bedrock model is multimodal—check model cards for supported modalities.

## Key takeaways

- **Multimodal** = multiple media types in one model/pipeline with comparable embeddings.
- Bedrock examples: **Claude**, **Nova** (multimodal FMs), **Titan** multimodal **embeddings**.
- RAG can retrieve context across **text, image, audio, video, documents** when indexed as embeddings.
- Works **both ways**: multimodal prompts and multimodal knowledge.
- **Titan Multimodal Embeddings G1**: text and/or image in; images as **base64** in JSON.
- Pipelines must preprocess media **before** invoking the model.

## Industry scenarios

1. **Field service manual**: Technicians photograph equipment labels; multimodal KB matches photos to PDF procedure chunks and returns steps plus reference diagrams.
2. **Retail catalog**: Product photos and descriptions share embedding space; visual search on shelf photos retrieves spec sheets and return policies as text.
3. **Media archive**: Newsroom ingests video keyframes (as images) and transcripts; reporters query with a clip still and receive related articles and prior broadcast text.

## References

- [Bedrock Knowledge Bases](bedrock-knowledge-bases/index.md)
- [Hands-On with Knowledge Bases](hands-on-with-knowledge-bases/index.md) (parser options for images/PDFs)
- [Retrieval-Augmented Generation (RAG)](retrieval-augmented-generation-rag/index.md)
- <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/titan-multiemb-models.html">Titan Multimodal Embeddings G1</a>
- <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/models-supported.html">Supported foundation models in Amazon Bedrock</a>
- <a href="https://docs.aws.amazon.com/bedrock/latest/APIReference/API_runtime_InvokeModel.html">InvokeModel</a>
