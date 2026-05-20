# Retrieval-Augmented Generation (RAG)

## RAG and knowledge bases in Bedrock

Let's talk about a popular alternative to fine-tuning, retrieval augmented generation, or RAG for short. And Bedrock we call that a knowledge base, so knowledge bases is what we're covering here. But to understand knowledge bases, you need to understand RAG. So let's talk about retrieval augmented generation at a higher level first to understand that.

## Open book exam analogy

You can think of RAG as sort of an open book exam for large language models. So, or the general idea is that we have some external database we're querying for the answers instead of relying on the LLM.

So, you know, it's Kind of a cheat to win approach here, right? At a very high level what happens is you have a prompt, in this example to the right, what did the president say in his speech yesterday? Well, maybe your underlying foundation model doesn't know the answer to that because that was after its training data cutoff, but you could say, okay, I'm gonna go search my external database full of news articles for what did the president say in his speech yesterday and try to find articles that are relevant semantically to that query, and then I'm gonna get back maybe the text of that article that does talk about the president's speech yesterday and incorporates that into the prompt itself.

So that would transform the prompt into something like, what did the president say in his speech yesterday? So the text of the following news article get response. Last night, President whatever said whatever, right?

## Augmenting the prompt

So you can see it's a pretty simple approach at the end of the day. We're just saying, okay, we're gonna take our prompt, I'm going to augment that prompt with data that I retrieve from ex some external database and include that in the prompt itself. So that's the high level idea. You just work those answers from the database or in the language of bedrock, a knowledge base into the prompt itself, and that gets passed on into the underlying foundation model.

## LLM agents and tools

There are also ways to incorporate tools and functions to augment this knowledge base into the system. We'll talk about that when we talk about LLM agents, and that's a slightly more principled way to go about this.

## Pros of RAG

So there are pros and cons to using retrieval augmented generation. let's start with the pros, because, well, that's what Amazon wants you to focus on, 'cause they make money giving you generative AI and using systems.

## Faster and cheaper than fine-tuning

it is faster and cheaper, at least in the short term to incorporate new or proprietary information using RAG versus fine-tuning. you don't have to fine-tune your entire model every time you get new information. You can just expand your database you're querying for this system instead, right? So that's a very easy thing to do as new data comes in, you don't have to go back and do this expensive fine-tuning operation. You can just incorporate that right into the database and you're done, right? So it's a very good way to keep data up to date.

## Token cost trade-off

However, it does increase the number of tokens in your prompts, right? Because you're including that external data into every prompt, and that can add up over time as well. So sometimes it's a little bit of a false economy.

## Keeping data up to date

Updating information, like I said, is just a matter of updating a database, so very, very simple to keep your data up to date for a generative AI system that includes RAG.

## Semantic search and vector databases

It can also take advantage of what we call semantic search. So a very popular choice for the database in a retrieval augmented generation system is something called a vector database. We'll talk about that. In a moment. But the idea behind a vector database is that it uses embeddings, which kind of encode the underlying meaning of a given passage of text or whatever, and we can therefore do a search that tries to find the passage of text in our data store that's most semantically similar to the prompt itself. So kind of a fancy way to leverage AI into the RAG process of the, the vector lookup itself into the data store itself or the knowledge base again, in the language of Amazon Bedrock.

## Reducing hallucinations

It's also touted as a way of preventing hallucinations, although it doesn't really accomplish that Fairly well but it can't prevent the model from just making stuff up in the case where you ask it about something that it just, doesn't know about at all. So with an existing foundation model, if you ask it about something that it wasn't trained on at all, it does have a tendency to make stuff up. And if you can provide it with additional information in the prompt that isn't made up, then that can at least reduce the amount of hallucinations that this model produces.

## AI search and how RAG works

And if your boss says, "Hey, I want AI search," well, this is an easy way to do it, that's basically what it is. It's a search powered by AI and, you know, fed into an AI to get the final result. You know, if you wanna be cynical, which I do, you could just say that RAG is basically taking a search result and rephrasing it using AI. At the end of the day, it's a search, right? And we're just using AI to rephrase the, the result. That's not entirely true, though. I mean, the underlying foundation model can still be used to augment and expand upon what was given to it in the prompt, so its own training does still come into play

## Not training on external data

And also technically, you're not training a model with this data if you're using RAG. So with a retrieval augmented generation model, if you have some reason to say, "Okay, I'm not actually using this external data to train an AI model because that, you know, makes some people angry," technically you'd be right, you know, you're not training it, you're not fine-tuning this information, you're not creating a custom model with this external information. you're just sort of feeding that into the prompt itself.

## Cons and downsides

However, on the conside, and this probably won't be on the exam, but I just feel obligated to tell you there are downsides to RAG. at the end of the day, you've made the wor the world's most overcomplicated search engine, right? So all RAG really does, like I said, at the end of the day, is do a search, and that search doesn't have to be a fancy vector store with semantic search, it can be anything. It could even be a hybrid approach where it uses traditional databases plus some vector store. but at the end of the day, it's primarily a search engine where the results are being rephrased by the underlying foundation model, and it's a very Expensive way to go about this vector stores use a lot of data, a lot of storage space, and a lot of computation

## Prompt template sensitivity

It's also very sensitive to the prompt template that you use to incorporate your data in. So, like we said, we have to somehow include that information we retrieved into the prompt itself, and the way you word that might yield different results, so it can be very sensitive to little things.

## Non-determinism and hallucinations

It's also non-deterministic, like well, I mean, you can always set the temperature to make it more deterministic, but it can be difficult to test non-deterministic systems, right? How do you evaluate a system where you don't get the same response for a given input? You know, that's kind of a problem. Like I said, it can still hallucinate, so even though you're giving it more information, that doesn't mean that it's not gonna make stuff up still.

## Relevancy of retrieved information

And it's also, this is probably the biggest challenge, very sensitive to the relevancy of the information you retrieve. So how you choose to store that outside information in your vector store or your external database makes a big difference into the quality of the end result. And like we'll see in a hands-on example shortly, a lot of times people just take a chunk of text and they break it up into chunks of a fixed number of characters, and there's no guarantee that that specific chunk of character even has a coherent thought within it. So retrieving that, no matter how fancy you're doing it, if it's not relevant to the prompt, you're not gonna get a good result, and it might be completely like off the rails, right? So that's the main problem with rag, just getting a relevant result to incorporate into the prompt. Based on the prop itself, that's harder than it sounds.

## Jeopardy RAG example

Let me give you another example of RAG one that shows up in an academic paper sometimes, winning at Jeopardy.

## Jeopardy retrieval and generation flow

So, let's say I want to make a retrieval augmented generation system that can win at Jeopardy given some external da-database of trivia that Jeopardy might find useful. So, let's say I'm asking, "In 1986, Mexico scored its first country to host its international sports competition twice. What happened?" So, we have a retriever module here. So, the first thing we're gonna do is encode that query into an embedding, right? So In the case of using a vector store, let's say that database of Jeopardy questions is a vector database, you first need to query the database using that prompt. So doing that might involve embedding that prompt into something we can search against that then hits that database or knowledge base, in the parlance of Amazon Bedrock, for a bunch of relevant documents to that query. So I might say, okay, here's a bunch of articles that I found about Mexico in sports in nineteen eighty-six, and hopefully one or more of those is relevant to the question at hand. Those documents are then included into the prompt itself, that goes into the generator, the underlying foundation model to produce an answer, which in this case would be, "What is the World Cup? So again, all we're doing here, taking a prompt, querying that prompt against some external knowledge base, taking the results the top documents that come back from that data store, from that knowledge base, incorporating it into the prompt, passing that prompt into our foundation model, which is labeled as generator here, and we get a result at the other end.
