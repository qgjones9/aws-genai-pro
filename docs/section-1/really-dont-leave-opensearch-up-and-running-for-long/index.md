# Really, don't leave OpenSearch up and running for long!

If you are following along hands on...

If you don't think you're going to get through the Agentic AI section of this course that builds upon the knowledge base you just created in the previous lesson very soon, please remember to delete your knowledge base AND its underlying OpenSearch serverless "collection" as shown in the video. Again, deleting a knowledge base does not delete its underlying vector store.

Even if you do not use OpenSearch serverless, a collection left running will cost you on the order of $200/month. "Serverless" does not mean "scales to zero" - it keeps racking up costs even if it's unused. I don't want anyone to get any nasty surprises!