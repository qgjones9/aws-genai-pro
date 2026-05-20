# Bedrock Guardrails

## Bedrock Guardrails Overview

Let's talk about Amazon Bedrock guardrails, a very important feature for AI safety and governance and security and all that good stuff.

## Prompt and Response Filtering

Basically, it provides content filtering for both your prompts and your responses. So for anything coming in or out of your Bedrock system, whether it's a knowledge base or an agent or whatever it is, a guardrail can make sure that people aren't saying things you don't want them to say going into the system, and you're also filtering out the response from the system to make sure that it's not saying anything you don't want it to say. Say.

## Supported Models

This works with the text foundation models currently, you know, like Titan or Claude and whatnot currently not with image models, but maybe that will change in the not too distant future.

## Word and Topic Filtering

You can filter on the word level or the topic level. So if there's a set of things you just don't want people to talk about, you can specify either the topics, like maybe you don't want them to talk about religion or politics or whatever it might be, or maybe you don't want them to mention your competitors, I don't know, but you can set that all up.

## Objectionable Content Dimensions

You can also have it automatically filter out words and topics just based on how objectionable it might be. So there are various dimensions you know, for things that are hateful Or biased or whatever it might be, and you'll, you'll see some of those when we do a demo in a minute here.

## Profanity Filter

Of course, it has a profanity filter as well that you can select, and it won't make you type all those in yourself. It knows what the dirty words are, you just have to turn that on.

## PII Removal and Masking

And it can also remove personally identifiable information automatically. So if it sees anybody's phone number or social security number or driver's ID number or address or whatever it might be, you can select what kinds of PII you want to remove, or, or you might want to mask that out. So optionally, you can just have it overlaid with sort of an in-brackets address if you don't wanna print anybody's address out. So If you want to make sure that you're not leaking any PII out of your system, that's a very good feature to use when you're putting a guardrail on the responses from your Bedrock system.

## Contextual Grounding Check

A newer feature is contextual grounding check in Bedrock guardrails. This is pretty cool. Its intent is to help prevent hallucinations. So it measures two things, and you can have thresholds on these two different metrics beyond which it will filter out the result.

## Grounding Metric

One is called grounding. That's basically how similar is the response to the contextual data I received. So if you think back to how knowledge bases And retrieval augmented generation worked We're going off and retrieving some contextual data from a vector database, right? And that will measure how similar is the response to that sort of ground truth data that we retrieved from the vector store. If it went off and made stuff up that wasn't in that vector store and that documents that you actually provided to the system, you'll have a low grounding score, and you can set a threshold that says, okay, if the response here didn't wasn't really based on what came out of the documents that I gave it, and it's kind of went off and made up its own thing based on its earlier training, maybe I want to filter that out, right? So that's what contextual grounding check does.

## Relevance Metric

It can also measure the relevance of the response to the original query. So if it sees that the answer it gave isn't really relevant to what the original question was, you can also use the contextual grounding check to filter that out as well. So it's sort of a way to at least guess as to whether or not the answer you got is relevant and correct based on the data that you gave it.

## Grounding Limitations

These aren't perfect metrics, by the way. So obviously, grounding metrics are only gonna be as good as the structure that you're storing in your vector store. So if your vector store has a problem where it tends to retrieve irrelevant information this metric won't work. Work as well, but it's there if you want it.

## Agents and Knowledge Bases

And this can be incorporated into either agents or knowledge bases, so in both cases you can attach a guardrail to those systems and it will automatically be applied to all prompts and responses.

## Blocked Message Response

You can also configure the blocked message response so that when it does choose to filter something out, you can control the message that the user sees when that happens.

## Hands-On Demo

This will make more sense when we see an example, so let's go hands-on and create a guardrail in Amazon Bedrock.
