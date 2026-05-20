# Vector Stores and Semantic Search

## RAG Data Stores and Bedrock Knowledge Bases

So a critical component of RAG is the data store that you're storing stuff in. So again, this really depends on your ability to retrieve relevant results to the prompt that you're given, and there's a more than one way to do it, right? So now in the context of Bedrock, we call this a data store that's used by a knowledge base. So for whatever reason, Bedrock doesn't call it retrieval augmented generation.

## Choosing a Database for Retrieval

Now, you could just use whatever database is appropriate for the type of data that you're retrieving, right? So if you have graph data, like recommendations or for products or relationships between items or a knowledge graph of some sort, a graph database is a great choice, and generally that will produce really good results. Neo4j being one example of a graph database. You can also use OpenSearch or something for traditional text search just using old school TF/IDF, that's fine. Sort of these older search techniques with newer semantic search techniques.

## Vector Databases and Semantic Search

But that's really how pretty much every example you see these days does it, using a vector database and semantic search. So why? Well, because vector databases leverage AI. So what we're storing in these vector databases are embeddings that sort of encode the underlying meaning of the information you're storing, and that leverages AI. So in theory, that gives you better results. Now, notice that Elastic Search and OpenSearch can function as a vector database, and that's why you'll often see OpenSearch used within knowledge bases in Amazon.

## What Are Embeddings

So before we can understand how vector databases or vector stores work, we first need to review what embeddings are, because those are the vectors that we're storing. An embedding is just a giant vector that's associated with your data. So if you have some chunk of text that you're storing in a vector database, you're, you're associating an embedding vector with that text that we can use to search against. And this can be very high dimensions. So we can have a vector that's, you know, thousands of dimensions in size.

## Semantic Similarity in Vector Space

In this example on the right here, we're just using two dimensions so you can actually wrap your head around it. But you can think about it as a point in multidimensional space, typically, like I said, hundreds or even thousands of dimensions, that represents, if you will, the meaning of the text that you're storing associated with that vector. Now these are computed such that items that are similar to each other are close to each other within that space. So things that are semantically similar are going to be close together geometrically within this vector space, and that's why we call it semantic search.

So taking a look at this example on the right, the words potato and rhubarb might be pretty close to each other in that vector space where those vectors to those locations in that space are the vectors that we're talking about, the embedding vectors for potato and rhubarb. They are just geometrically close to each other because they have a similar meaning, they're both, you know, vegetables or whatever. So really, we might have science fiction oriented stuff up in another section of our space, you know, Starship, Enterprise, Spaceballs, The Orbital, those all might be in a very similar neighborhood within this vector space because they're talking about science fiction spaceships, right?

## Computing Embedding Vectors

Now, how do How do you compute these embedding vectors? Well, there are embedding foundation models like Titan, for example, that can compute these en masse. So it's actually relatively inexpensive to say, "Here's a pile of text, go give me a bunch of embedding vectors that I can use to store these in a vector store." And this is easy to do because if you remember how transformers work, the first stage is to transform your, someone may call them transformers, but we are transforming your prompt into tokens which correspond to embedding vectors. So embedding is sort of baked into the capabilities of all these large language models from the get-go We're just repurposing them for storing our information in a better store for semantic search here.

## Storing Embeddings in Vector Databases

So embeddings are vectors, right? So how do we store them? Well, we store them in a vector database, right? And that's just going to store your original text data or whatever it is, it could be images as well, alongside their computed embed-embedding vectors so we can find things that are semantically similar to each other. And again, this leverages the embedding capability that your underlying model already has when it was being trained. So usually, that's a pretty easy thing to get when you're building a generative AI system.

## How Vector Retrieval Works

So retrieval, when you're actually doing a lookup in a vector database, will work like this. So first, you need to create an embedding vector for the thing you want to search for. So whatever your prompt is, you need to convert that to an embedding vector, and then you just query the vector database for the top items that are close to that vector you're searching for, get back the top n most similar thing. So that's basically the same thing as k-nearest neighbor, and that's what we call vector search.

## Scale and k-Nearest Neighbor Optimizations

Now, you might say to yourself, "Self, what if I have, you know, thousands or millions of things in my database? Do I really have to do a linear search through every single vector and find the ones that are most close to the one that I'm searching for?" Well, no, there are some Optimizations that these vector databases typically employ to narrow things down to a smaller set that you have, you need to search through. So, you know, basically there'll be some underlying probability of it being close to a given vector that it starts from, and you don't actually have to search through everything to find those k nearest neighbors.

## Vector Database Implementations

Now there are some a lot of implementations of vector databases out there, but most popularly, you can coerce an existing database to do vector search. So a lot of database companies out there have added vector capabilities in response to the rise of generative AI. So OpenSearch and Elasticsearch being a notable example. So OpenSearch does have the ability to store and search by vectors, and that is what Bedrock is going to steer you toward because OpenSearch is an Amazon product, right? So it does a fine job. OpenSearch is a perfectly valid choice for doing that. But you can also get SQL databases to do it, you can get Neptune to do it, you can get Redis to do it, MongoDB, Cassandra, they've all adapted to this world of vector databases and search as an option. There are also purpose-built vector data stores out there, such as Pinecone Weaviate is another commercial alternative, Chroma, Marko, Vespa, Qdrant. Usually I see Pinecone in this context more than anything else, they seem to be winning the battle. But you can store this in whatever database you want and tie Bedrock to it if you're doing a knowledge base with Bedrock.

## Star Trek RAG Example

Let's take another look at an example just to drive it home and see what's going on here. Let's say that I have a rank system that has all the scripts of Star Trek in it, and I want to ask it, "Data, referring to Lieutenant Commander Data of course from Star Trek: The Next Generation, tell me about your daughter, Lwaxana." The first thing I would do would be to compute an embedding vector for that prompt. So I'm gonna go to my foundation model that can do text to embedding and say, "Take that prompt, give me an embedding vector." That might be a vector with thousands of dimensions, right? I then query my vector database of everything Data ever said in Star Trek: The Next Generation. It's gonna do a semantic search there, and all that is is a fancy way of saying, "Give me the top vectors that are closest to my embedding vector that I'm searching for, and those are gonna be my top results." That's all there is to it. It's just geometrically saying, "What is the distance between all these vectors? Give me the closest one to the thing I'm searching for." Usually that's done using a cosine metric, if you wanna get technical. What I get back are the top N results that are closest to that embedding vector. So these might be script lines, for example, that are relevant to the prompt. So things that are about Law presumably will come back.

## Building the Prompt and Result Quality

Then I just embed the responses that came back into the prompt. So I say, "You are Commander Data from Star Trek. How might Data respond to the question, "Data, tell me about your dharma law," taking into account the following related lines from Data? " And then I would just list the top five results or whatever it is into that prompt. And you can see there's a lot of things that can influence your quality of the result here, right? What, what choice do I have for K? How many of those similar lines am I including in the prompt that's gonna make a difference there, right? And how relevant they are is gonna make a big difference. How I phrase that prompt is gonna make a difference. So again, these systems can be rather sensitive in practice. But generally, you're taking the original prompt, you're gonna take a query and retrieve the relevant data from that prompt and include that into the prompt itself.
