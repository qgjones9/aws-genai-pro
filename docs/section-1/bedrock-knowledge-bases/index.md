# Bedrock Knowledge Bases

## RAG and Knowledge Bases Overview

So in Bedrock, we call RAG knowledge bases, that's what they're wrapped up inside, and the idea is pretty much the same thing So with Bedrock, you can upload your own documents that you want to augment your generation with into S3, and that could be structured or unstructured, it could just be raw text, it could be JSON structured data, whatever you got. And that goes into what we call a knowledge base in Bedrock.

## Data Sources for Knowledge Bases

In addition to S3, you can now also point it to a web crawler, so you can say, "Go crawl this set of web pages that, presumably, you have permission to do so," and use that as a source for your knowledge base. You can also import data from third-party connectors like Confluence Salesforce, and SharePoint as well are currently supported.

## Embedding Models and Vector Dimensions

Once you have that document, you need to embed it somehow, right? In order to store that into a vector store of some sort, first you need to compute those embedding vectors. For that, you need to have an embedding model and some access to it. So in Bedrock, you'll go select a model, a foundation model that can do embeddings, right now that could be Cohere or Amazon Titan. And the one thing you can control there is the vector dimension. So you can say, "Okay, I want this many dimensions in each vector that I encode these embeddings into for each chunk of my documents."

## Vector Store Options

And you also need to store that. Into a vector store of some sort. by default, if you're just playing around, it will select an OpenSearch instance which has vector store support built into it. MongoDB also now has vector capabilities as well, so I, I can see them moving to that over time. Other options, though, are Aurora, Mongo, DDB, Atlas, Pinecone, or Redis Enterprise Cloud can also be used with Bedrock as a vector store.

## Chunking Strategy and Controls

And you have some control over how that data is chunked. Again, if you have just a big chunk of, a big document of text or whatever, you need to break that up somehow. You can't store that all into a single entry into your vector database or that wouldn't do much good, right? You wanna be able to Retrieve the relevant bits of text that are relevant to the query that's being asked by the end user. By default, I think it's chunked by three hundred characters. Never really made a whole lot of sense to me to just arbitrarily break up the text by three hundred characters or whatever it is, but that seems to be what people do these days. Obviously, it'll be better if you can get sort of a coherent thought of some sort in each entry in your vector store maybe breaking up by sentences or paragraphs or something like that would make more sense. Or even better, having some sort of structured data where it makes a whole lot more sense as to how you're storing that or maybe a graph database that represents a knowledge graph, you know, that also might be a better way to go than just Arbitrarily slicing up your data into three hundred character blocks. If you do wanna chunk your data though, in that matter, you do have control over what that chunk size is at least, and what the overlap between chunks might be

## Knowledge Base Architecture Flow

We're just putting it together in this diagram on the right here. Again, you have a source of documents that you want to ingest into your rag system that goes through Bedrock to create embedding vectors for each chunk of that document, which then gets stored in a vector store of some sort, might be OpenSearch, might be memory DB, might be something else, and then Bedrock, when it's processing a query, can go off and say, "Okay, retrieve relevant information through some sort of semantic search here relevant to the original query," and use that context that gets retrieved by the vector store as additional information for the prompt that ultimately goes down to the LLM to produce a response.

## How to Use a Knowledge Base

How do I use a knowledge base?

## Chat With Your Document

So One way to do it quickly is in the Bedrock console, you can use this feature called Chat with your document, and it's a very quick and dirty way to get up and running. You just give it some data in S3 and say, "Okay, I'm gonna use a foundation model to interact with that document and actually build a RAG system really quickly."

## Query and Retrieval Flow

So this diagram on the right kinda shows what that looks like, Sue. let's say you start off with a user query, first thing you're gonna do is issue a semantic search to OpenSearch to encode that query and find the Most relevant documents using those embedding vectors again. That will give you back a set of documents that are relevant to the query. We're gonna call that the context, okay? Find that context information, those top results that came back from our vector store, and augment the prompt into an augmented query that then hits the underlying foundation model in Bedrock, which then produces the response that we want.

## APIs, Agents, and Integration Options

You can also integrate knowledge bases into applications directly, you don't have to use the, the playground or the chat with your document feature, there, there are APIs for using this as well. And you can also incorporate these knowledge bases into agents, and we call that agentic RAG or LLM agents, if you will, and we'll, we'll get into an example of that very shortly. But basically, you can play around the console, you can use knowledge bases in, in application directly using the Bedrock API, or you can use a knowledge base as a component of a larger LLM agent system as well.

## Hands-On Demo Setup

Let's go ahead and play around, it'll make more sense when we see it in action. So I'm gonna create a knowledge base, and this is gonna be using a vector store, using Elas OpenSearch. Sorry, I almost said Elasticsearch, it's OpenSearch 'cause we're in Amazon. And as an example, we're gonna use the full text of an old book I wrote about self-employment, and see if we can quickly create a rag system around that. So let's play.
