# Quiz: Bedrock and GenAI Fundamentals

**Question 1:**

A retail company wants an internal “AI search” assistant that can answer questions about constantly changing product documentation and policies stored in S3. The team wants to minimize hallucinations for questions about recent changes and avoid frequent, expensive model retraining. Which approach best meets these requirements?

- [ ] Fine-tune a foundation model with our current and future product documentation.
- [x] *Use Amazon Bedrock to create a knowledge base with our current and future product documentation and use RAG to answer questions about recent changes.*
- [ ] Rely on prompt engineering to generate responses to questions about recent changes.
- [ ] Perform continue pre-training on our foundation model with our current and future product documentation.


**Question 2:**

You are building a Bedrock Knowledge Base using an Amazon Titan embedding model. In testing, you find that using the default high-dimensional embeddings gives excellent retrieval quality but your vector store costs are higher than expected. You want to reduce costs while maintaining acceptable search relevance. Which approach is most appropriate?

- [ ] Increase chunk size so tha fewer vectors are stored.
- [x] Reduce the embedding vector dimenstionality while validating retrieval performance against your domain data.
- [ ] Switch to sparse one-hot embeddings to reduce memory usage.
- [ ] Trun off embeddings and use only traditional keyword (TF/IDF) search.

**Question 3:**

A legal team is ingesting long, hierarchically structured contracts into a Bedrock Knowledge Base. They want:

- High precision in retrieval (matching specific clauses)
- Enough surrounding context for the model to answer accurately
- To avoid exceeding token limits

Which Bedrock chunking configuration is most appropriate?

- [ ] Fixed size chunking with a small chunk size and zero overlap.
- [x] Hierarchical chunking with parent chunk size of 1000 tokens and child chunk size of 500 tokens with 20% overlap.
- [ ] No chunking and use the entire contract as a single chunk.
- [ ] Semantic chunking with a maximum token limit of 1000 tokens per chunk.

**Question 4:**

Question 4:
An engineering team has a Bedrock Knowledge Base configured with S3 as the data source and OpenSearch as the vector store. They want to ingest new and updated documents with minimal lag while controlling ingestion costs. Which design best aligns with the guidance in this section?

- [ ] Trigger a lambda function on every s3 object PUT event to immediately re-embed the updated document.
- [x] Run a scheduled batch job that periodically invokes a Lambda function to generate embeddings and start ingestion jobs.
- [ ] Recreate the entire knowledge base from scratch whenever a document changes.
- [ ] Manually upload new documents to the Bedrock console when updates are needed.

**Question 5:**

A healthcare startup uses Amazon Bedrock to power a chatbot that accesses internal documents via RAG. They have already configured Bedrock Guardrails to filter harmful and off-topic content but must also ensure that personally identifiable information (PII) in prompts and outputs is removed or masked at a token level, even if it appears in retrieved context. How should they design this?

- [x] Implement custom pre and post processing handlers that call Amazon Comprehend to identify and mask PII tokens before and after Bedrock inference.
- [ ] Implement token-level redaction in a Lambda function that runs after each document ingestion.
- [ ] Create a custom guardrail that masks PII tokens at the model output layer.
- [ ] Disable PII masking and rely on Bedrock Guardrails to filter it out at the prompt level.


**Question 6:**

An e-commerce company wants customers to upload a photo of an item (for example, “red running shoes”) and get similar products from their catalog. They decide to use Amazon Titan Multimodal Embeddings G1 via Bedrock and store embeddings in a vector database. What must their data processing pipeline do before calling the embedding model?

- [x] Convert the photo to a base64-encoded string and pass it as a prompt to the embedding model in addition to the text prompt.
- [ ] Convert each input image inot a JPEG URL and send the URL directlly to th emodel in a URL field.
- [ ] Pre-segment the image into regions and send each region as a separate input to the model.
- [ ] Use Amazon Rekognition to extract text from the photo and pass it as a prompt to the embedding model.

