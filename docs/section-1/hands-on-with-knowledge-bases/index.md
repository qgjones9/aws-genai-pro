# Hands-On with Knowledge Bases

## What this lecture covers

A console walkthrough to create a Bedrock **vector store knowledge base**, ingest `book.txt` from S3, sync embeddings into **OpenSearch Serverless**, test retrieval and generation, inspect chunk citations, and understand cleanup (KB delete vs OpenSearch collection). This is positioned as groundwork for later **agentic** and **guardrail** labs in the course.

## Key definitions (from the lecture)

| Term | Definition |
|---|---|
| **Data source** | Where raw content is imported from (S3, SharePoint, Salesforce, Confluence, web crawler, custom)—not the vector store itself. |
| **Vector store knowledge base** | KB type that embeds chunks into a vector index (vs structured data store or Kendra connection). |
| **Sync** | Operation that indexes data source content into the vector store after KB creation. |
| **Default parser** | Bedrock parser suitable for plain text; other parsers target richer unstructured media. |
| **Bedrock Data Automation parser** | Extracts structured information from images, PDFs, audio, video, forms, etc. |
| **Foundation model parser** | Uses an FM to extract meaning from complex documents beyond plain text. |
| **Transformation Lambda** | Optional function to control chunking/processing before vectors are written. |
| **Vector store deletion policy** | Default deletes vector **data** when the data source is deleted—not the OpenSearch Serverless **instance/collection**. |
| **Retrieval and response generation** | Test UI mode that runs semantic retrieval plus FM answer generation. |

## Key distinctions / comparisons

| Item | Notes |
|---|---|
| **Vector store vs Kendra vs structured store** | Menu offers multiple KB types; this lab chooses **vector store** for direct control. |
| **Data source delete policy: delete vs retain data** | Controls whether indexed vectors survive KB/data source removal—not whether OpenSearch Serverless billing stops. |
| **Default vs hierarchical vs semantic chunking** | Default ~300 **tokens** per chunk with sentence boundaries; hierarchical uses parent/child; semantic uses an FM (more expensive). |
| **No chunking** | One document = one chunk when you pre-chunk externally. |
| **OpenSearch Serverless vs Neptune vs Aurora vs S3 vectors** | Exam focus called out for **OpenSearch Serverless**; S3 vectors noted as preview and out of exam scope at recording time. |
| **On-demand Titan embeddings** | Example embedding model; newer Titan variants allowed if enabled in the account/region. |

## The problem (why you need it)

- Building RAG manually requires wiring ingestion, embeddings, vector index, and query APIs yourself.
- Learners need a **repeatable lab** that mirrors exam-relevant defaults (OpenSearch Serverless, sync, test, citations).
- **Cost traps**: leaving OpenSearch Serverless running after KB deletion.

## The solution

Console workflow (Bedrock → Build → Knowledge bases):

1. **Create** vector store KB (e.g. “Sundog rag”), auto IAM role or custom permissions, supported **Region**.
2. **Data source** → S3 URI to `book.txt` (course materials), name data source (e.g. “Frank’s book”).
3. **Parser**: default for plain text; Data Automation or FM parser for multimodal/unstructured.
4. **Chunking**: default 300-token chunks with sentence boundaries (or custom/hierarchical/semantic/none).
5. Optional **Lambda** transformation, KMS, deletion policies.
6. **Embeddings model** (e.g. Titan) with model access in region.
7. **Vector store**: quick-create **OpenSearch Serverless** (exam default).
8. **Create** (~5 minutes), then **Sync** data source (~seconds for small book).
9. **Test knowledge base** → pick FM (e.g. Claude Sonnet 4) → ask book-related question → review citations and chunk details (top **5** chunks cited).

Cleanup: delete KB (data only warning) **and** delete OpenSearch Serverless **collection** if not continuing soon.

## How to apply it

### S3 setup (lab)

- Globally unique bucket name, upload `book.txt` from course AIP materials.
- In Bedrock, browse S3 URI; refresh page if new bucket does not appear.

### After sync — test query (from lecture)

Example prompt: *“What are some steps to follow before deciding to become self-employed?”* — response should reference book chunks with links to source context.

```python
# Equivalent application pattern after console setup
import boto3

rt = boto3.client("bedrock-agent-runtime", region_name="us-east-1")

out = rt.retrieve_and_generate(
    input={"text": "What are some steps to follow before deciding to become self-employed?"},
    retrieveAndGenerateConfiguration={
        "type": "KNOWLEDGE_BASE",
        "knowledgeBaseConfiguration": {
            "knowledgeBaseId": "KB_ID_FROM_CONSOLE",
            "modelArn": "arn:aws:bedrock:us-east-1::foundation-model/anthropic.claude-3-5-sonnet-20241022-v2:0",
        },
    },
)
for citation in out.get("citations", []):
    print(citation)
print(out["output"]["text"])
```

Chunk inspection in the console shows ~**300-token** chunks and optional **metadata** for citations (hybrid search discussed later in the course).

## Examples

- **Frank’s book**: `book.txt` in S3 → default chunking → Titan embeddings → OpenSearch Serverless → question on self-employment readiness returns aligned steps with chunk references.
- **Parser choice**: Plain `book.txt` uses **default parser**; driver’s license images would motivate **Bedrock Data Automation** or **FM parser**.
- **Hierarchical chunking (optional)**: Search precise child chunks, pull broader parent context when a child hits.
- **Deletion policy lesson**: Deleting KB removes indexed data but **not** the serverless collection—second-step delete in OpenSearch dashboard (~$200/month if forgotten).

## Limitations / edge cases

- **UI changes frequently**; navigation may differ from the video.
- **Region** must support Bedrock; **model access** may need enabling in model catalog.
- S3 bucket picker sometimes requires **refresh** or full page reload.
- **S3 vectors** preview: instructor would choose for new systems but not exam-focused at recording.
- **Neptune Analytics** = graph structure (social networks), not charts/graphs in the BI sense.

## Key takeaways

- Create **vector store** KB → S3 data source → parser → chunking → embeddings → OpenSearch Serverless → **sync** → **test**.
- Default chunking: **300 tokens**, respects **sentence boundaries**; top **5** chunks often retrieved in test UI.
- **Metadata** on chunks supports citations and future **hybrid search**.
- Delete **KB and OpenSearch Serverless collection** if not continuing to agent/guardrail labs soon.
- Course will **reuse** this KB for guardrails and a larger **agent** later—plan uptime vs cost.

## Industry scenarios

1. **Documentation chatbot POC**: Team uploads internal PDFs/text to S3, stands up KB in an afternoon, validates answers in Test KB before wiring a production API.
2. **Compliance-sensitive ingestion**: Scanned forms use Data Automation parser; contracts stay on default text parser—same KB pattern, different parser per data source type.
3. **Cost-aware staging**: Dev KB torn down nightly (KB + collection delete); prod uses Aurora vector store with retained data policy—same Bedrock features, different ops discipline.

## References

- [Bedrock Knowledge Bases](../bedrock-knowledge-bases/index.md)
- [Really, don't leave OpenSearch up and running for long!](../really-dont-leave-opensearch-up-and-running-for-long/index.md)
- [Managing Chunking Strategies with Bedrock](../managing-chunking-strategies-with-bedrock/index.md)
- [Pre-Retrieval and Chunking Strategies](../pre-retrieval-and-chunking-strategies/index.md)
- <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/knowledge-base-create.html">Create a knowledge base</a>
- <a href="https://docs.aws.amazon.com/bedrock/latest/userguide/kb-test.html">Test a knowledge base</a>
- <a href="https://docs.aws.amazon.com/AmazonS3/latest/userguide/GetStartedWithS3.html">Getting started with Amazon S3</a>
