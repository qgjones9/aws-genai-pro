# Enterprise Integration

## Enterprise Integration Overview

Alright, this seems to be as good a place as any to mention a few things that are really specific about enterprise integration that come up in the AWS training materials for this certification. They're specific enough to be suspicious, so I think you might need to know this.

## Bedrock Knowledge Bases and External Data

So one thing is that, remember that Bedrock knowledge bases are basically your one-stop shop for any internal data or document management systems that you might have within your enterprise. So knowledge bases can suck in an awful lot of different information. It can take data from S3, but also from SharePoint from Atlassian, Confluence, and a whole bunch of other data data sources that might be external to AWS. So Bedrock is able to integrate this external data into your vector stores natively. So Bedrock knowledge bases, you can throw pretty Much anything at them these days, and it will index for you within Bedrock. So remember, Bedrock knowledge bases are an important tool for integrating with enterprise data.

## Cross-Account Bedrock and OpenSearch

Also, cross-account access comes up all the time on these exams, and I think this is no exception. One specific scenario to be aware of: what if your Bedrock Foundation model and OpenSearch for your knowledge base are in different accounts? You know, maybe you wanna share data between different accounts for Bedrock. You can do that, okay? So OpenSearch has a remote inference connector. And that supports semantic search across different accounts. So if I have a Bedrock knowledge base that's backed by OpenSearch, I can set up a remote inference connector to be able to use that OpenSearch knowledge base across different accounts for semantic search.

## IAM Roles for Cross-Account Access

Now, it's not just a matter of having that connector in place, you also need to have the appropriate IAM roles for that. So your Bedrock account that's running the model needs to have a role defined that allows invoke model access from the OpenSearch account, okay? So those are the specifics for having a Bedrock model that can access OpenSearch knowledge base from a different account. You might need to know that.

## Event-Driven Architecture

Another very specific thing is event driven architecture. Well, not that specific, it's just a good practice, but when you're dealing with an enterprise system, you wanna have some sort of a buffer between your AWS stuff and the enterprise stuff, right? And SQS, for example, might be a way of doing that. It could be Kafka though, or basically any pub sub system.

## Document Processing Example

So in this particular example here, I've got like the left side of the document where we're, we're doing stuff with documents with Bedrock, right? So documents are being uploaded, it's being picked up by a EventBridge that's kicking off some Lambda function that does something in bedrock with it, and then I wanna store that something within my internal data warehouse outside of AWS or my ticketing system or my CRM system.

## SQS as an Enterprise Buffer

the important point here though is that I've injected an SQS queue there in between them. So if something goes wrong with that connection, I don't lose that data. So if my ticketing system is down, my data warehouse is down, you know, maybe I don't trust these systems as much as I trust AWS, at least that's gonna be queued up in SQS or Kafka or whatever I'm using. As that sort of buffer.

## Relevance to Generative AI in the Enterprise

So by using this event-driven architecture, I can make sure that I'm not gonna lose this data. These events are being stored somewhere and queued up in case I need to, in case something downstream goes down, okay? So that's the point of event-driven architecture and how it's relevant to generative AI solutions in the enterprise specifically. Basically, I have events that are happening when I'm generating stuff, and those events can be cached up and queued up before they actually go to my enterprise, okay? So that's the, the relevance there. Again, an oddly specific thing that isn't the exact right.
