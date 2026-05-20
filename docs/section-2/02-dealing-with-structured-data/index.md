# Dealing with Structured Data

## Structured data overview

Alright, this next section's about managing data for your generative AI applications, and to start, we're gonna deal with structured data. And this is basically a collection of oddly specific things that came up in the exam guide and the skill builder materials that we wanna cover explicitly related to structured data.

## Bedrock API JSON requests

One is, how do I deal with Bedrock API requests exactly? Well, it turns out that Bedrock usually wants JSON formatting, and when we're talking about structured data, we're usually talking about JSON in the world of gen AI today, at least. Typically, JSON is gonna be the underlying native structure for the models that we're dealing with, so Look at this little snippet of Python code over here on the right. You can see that we're constructing our request as a formatted JSON structure there, and dumping that into an actual JSON string before we actually send it through the Invoke model endpoint on our actual Bedrock model. So we have an input text, and then we have text generation config with a bunch of parameters attached to it as well. So there are different formats for different models, but generally speaking, it's gonna be JSON, and it's on you to actually format that JSON and send it into the Invoke model endpoint. Or it actually does something useful, okay? So just know, JSON is what Bedrock wants.

## SageMaker AI input and output formats

Didn't know for SageMaker AI, so SageMaker AI is a more general purpose way of deploying machine learning or AI models, and you can deploy LLMs that way as well. We'll talk more about that in an upcoming section, but that too will expect a certain input and output format, and depending on the model you're using, it might be different. Now, again, for LLMs, that's usually JSON, but there are some classical machine learning algorithms where it might be a CSV table or something else entirely. there's a bunch of protobuf and things like that, but for Gen AI, again, usually JSON. And again, there's a code snippet over here kind of illustrating that as well.

## Endpoint JSON structure

So within my endpoint, I might take in the messages that are coming in, the prompts, and I need to structure that in JSON and specify things like the maximum number of tokens I want, I think that's optional, a system prompt, also usually optional, and then the messages itself is probably another structure representing the chat history. And then that's what I send into my actual model through Invoke Model, just like we saw in the previous slide.

## Your responsibility to format JSON

And the other way around too, when you're doing your output data, you might need to format that as JSON as well. Key takeaway though, SageMaker's not gonna do this for you. It's up to you to format your input in JSON before you send it into Bedrock, okay? Your app, your endpoint, they're responsible for it. It's not gonna happen by magic. So when you're designing a system, make sure that's part of it.

## Extract structure from unstructured data

Alright, another topic with structured data is how to extract structure from unstructured data. So this might be relevant, for example, for ingesting documents where it's OCR'd and it kind of lost its original structure, and you need to recreate that somehow. Or maybe you have that structure still, but you know, you wanna make sure you're preserving that as you send that text data into your model. And this could be something you're sending in as context explicitly as part of the prompt. It could be something retrieved from a knowledge base or retrieval augmented generation, whatever it is, same problem. You got raw text, generative AI would prefer to have some structure around that text so it knows how to understand it, its context better.

## HTML reformatting technique

So things like headings and sections and metadata and tables are easy to get lost if you're not careful. You need to reconstruct those, and one way of doing that is to reformat as HTML. So this is a specific technique that's called out by Amazon. One trick is to say, okay, if I can format this as HTML, most models understand HTML pretty well, so that will make it easier for the model to make sense of that data and structure it accordingly, especially with tables, you know, that's a tough thing to capture via any other way. So that way, you know, your structure, your organizational metadata will be preserved as you pass it into the model, and if you have like a PDF or raw OCR image data, this might be a helpful thing to do.

## Tools and ingestion pipelines

How do I do it? Sounds hard, yeah, but there's tools to help. there's a third-party tool called Pando but within the Amazon ecosystem, Texttract and Comprehend are services that might help out there. And you need some sort of an ingestion pipeline to make that happen, of course, too. what they suggest in the preparation materials from Amazon is AWS Glue, but of course, it's more than one way to do it. There's a newer technique that I think might be newer than that documentation, bedrock data automation, and we're gonna talk about that next, so more on that soon, but that's a, a much more fun and easy way of handling this sort of a problem.

## RAG chunking with divider strings

Another issue is when you're chunking up data for retrieval augmented generation, we talked about that earlier you gotta chunk that information up before you create the embedding vectors around them for a vector store, and one way of doing that is by having divider strings to segment that data explicitly. So if I can pre-process my data or process it on the fly to include these divider strings that explicitly say where I wanna do that chunking, that might be a useful trick, right?

## Lambda preprocessor for knowledge bases

So one way of doing that on the fly would be to have a lambda preprocessor attached to your knowledge base in Bedrock, that's something you can do. So when you set up a knowledge base, you have an option to say, "I want this lambda code to pre-process any data coming into it." And that might be useful in situations where, for example, you have HTML coming in and you want to convert that into divider strings on the fly that can be used by the knowledge base to chunk it up more intelligently. And that code could be very simple, you know, this little snippet down here at the bottom where we're just looking for header tags and replacing them with section break and subsection break divider strings instead.

## Glue ETL preprocessing

And if you want to do it as a pre-processing thing and not on the fly Glue ETL again is a way of doing that as part of a larger pipeline, and there are other ways of doing it too that we'll get into later. So that's some tips and tricks for dealing with structured and unstructured data.

## Formatting data for conversations

Another thing is formatting data for conversations. This is another very specific thing that comes up in the exam guide. So when you're using Bedrock's converser API for chat, you need to give it a specific format to embody that chat history, right? So that needs to include both the role and the content for each kind of iteration on that chat. So as you're talking back and forth with the assistant, you need to capture that chat history and also who's talking when.

## Converse API message structure

And this illustration on the right here shows you what that looks like from a structural JSON standpoint. So you'll have a messages Structure here at the top level that contains that chat history. That array contains each individual chat message, and those are tagged with a role that indicates whether it's the user or the assistant that's doing the talking there. So, you know, in this example, we have a user who's starting off saying in text, "You're a chicken expert, ready?" And the assistant says, "Absolutely, let's talk chickens." And then the user comes back and says, "How fast can a chicken run?" And obviously, this would go on and on and on and on. But this is how you would actually structure conversational input for Bedrock's Converse API to embody a chat history. Now the role here is basically who is, you know, "quote unquote" talking, you know, who is the user, who is the entity that's actually talking at the moment, in this case, it's user or assistant, and again, just an example here on the right to make it real.
