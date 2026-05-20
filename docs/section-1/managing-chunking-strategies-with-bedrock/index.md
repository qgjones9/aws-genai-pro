# Managing Chunking Strategies with Bedrock

## Chunking choices overview

Alright, so what are your choices for chunking in Bedrock? How can I actually control how information is stored in a knowledge base and the granularity of that information? Well, you have a few choices. So standard chunking is kind of the more straightforward approaches that aren't anything fancy, you know, that is based on heuristics.

## Fixed size chunking

So one approach is a fixed size, so I can say, "I want a certain number of tokens per chunk," and by tokens, these are the underlying things that large language models encode words into. So it's not necessarily true that one token equals one word, but Sometimes that's usually the case, right? So you can sort of think of tokens as words here. So you're gonna say, "How many tokens do I have in a chunk? " And also, "What overlap percentage do I have? "

Now, the idea of overlap is that I can have, make sure I have a little bit of extra context from the chunks that precede and follow that chunk, right? So that way I can make sure that I'm not losing some of that contextual data.

## Fixed size chunking example

So as a very simple example here on the right, let's say that I'm chunking up the text, "Space, the final frontier, these are the voyages of the starship Enterprise. " If I want a chunk size of five And an overlap of twenty percent, twenty percent of five is one token, right? So I'm gonna have five tokens per chunk, and I'm gonna assume here for simplicity that one chunk equals one word, and an overlap of one chunk on either side. So I'm gonna start at the end and space the final frontier, these, that's the first five chunks of that text. Next chunk is gonna be these are the voyages of, because of that overlap, by repeating that token of these. And then again, of the Starship Enterprise, again, repeating the overlap of the word of from the previous chunk there. So that's how fixed size chunking works.

## Default chunk size and sentence boundaries

In practice, you would probably have much larger chunk sizes because Individual snippets aren't gonna be semantically meaningful on their own Now the default setting is three hundred tokens per chunk, and it also honors sentence boundaries at the same time. So if it needs to go a little bit bigger to preserve a complete sentence within a chunk, it will do so. So, you know, you definitely don't wanna break up sentences if you don't have to, because a sentence by meaning is sort of a coherent thought of some sort. Breaking that up would be bad.

So the default chunking strategy, the default standard chunking strategy, is three hundred per chunk, and I'm not gonna split sentences on those chunk boundaries if I can help it. So that's a pretty good place to start, right? Three hundred tokens, three hundred words captures some pretty Pretty complex ideas, but we're making sure not to make it too big, and we're also making sure not to cut off sentences in the middle

## No chunking option

You can also choose to have no chunking at all and just have each doc-document that you feed into Bedrock Knowledge Base be its own chunk, and that gives you more control in the pre-processing stage. So if you want to pre-process your own data however you want to, to chunk it up the way that you want, if you output each chunk into its own document and then say, "Hey, Bedrock, here's a pile of documents to put into my knowledge base without chunking," then it will just do whatever you gave it, and each document will be its own chunk. So that's when you might use the no chunking option if you've already pre-chunked your data. Ahead of time into individual documents.

## Hierarchical chunking

Now, if we want to get fancier, we can do hierarchical chunking, okay? So these are basically nested parent-child chunks where we have larger chunks that split themselves down into smaller chunks. And the idea here is that the initial search will hit those child chunks, right? And that's gonna give us a little bit more precision, right? So we're gonna be hitting that very specific piece of text that's relevant, hopefully, to what the query is about. And then to get more context, we're gonna go up the tree and get more and more context from these larger chunks of data, okay?

So the idea here is to get better precision In your retrieval from those smaller embeddings. So smaller embeddings means more precision, but we're gonna be giving up comprehensiveness, you know, the context surrounding those little snippets. So to reclaim that, we're gonna go to these parents in the hierarchy to get that larger context of what that little snippet is about. So kind of a cool idea here.

## Hierarchical chunking example

On the right, you can see that kind of spelled out here, we are just breaking down kind of the, the left hand side of this tree. So in this particular example, we have a parent chunk size of six, so that's kind of that second level there. We're starting off with that same larger bit of text, but they're gonna chunk that up into six chunks, and we have a child chunk size of three. With an overlap of one, and that's what this ends up looking at. So now at the bottom child level, we have space the final with that child chunk size of three, we have an overlap of one, so the next chunk is gonna be final frontier these, so on and so forth, right? So if we get a hit on one of those child nodes, we can then go up a level to that parent chunk size of six, get a little bit of extra context that way, alright? And you can ex-expand this to the other, you know, chunks and parent and child chunks here shown. I only just illustrated that left-hand side of the tree here, but you get the idea.

## Semantic chunking

Also, semantic chunking, we talked about that a little bit earlier, actually using a foundation model to do the chunks, so I can say, "Hey, foundation model, you figure out the best way to split up this information and try to figure out how to preserve ideas within a given corpus of data instead of having just a fixed chunk size at all." So when you're doing this, you will specify the maximum number of tokens that you want these chunks to be while still honoring sentence boundaries, so you can say, "Hey, semantic chunker model thing go split this up, but make sure chunks aren't bigger than, you know, three kilobytes or whatever it is."

## Buffer size and breakpoint percentile

You can also specify a buffer size, and that's basically the number of surrounding sentences per sentence you consider. When doing these embeddings. So, for example, if I have a buffer size of one, that means that for every sentence this model is looking at for semantic chunking, it will also look at the one sentence on either side of it for a total of three sentences it's considering. If you set that buffer size too large, you're gonna introduce too much noise, right? So you're gonna get too much irrelevant information being pulled in. But if it's too small, you might miss important context. So too large of a buffer size introduces noise, too small of a buffer size means you miss important context, but you might have more precision. This seems like the sort of thing the exam might want to test you on. I don't know, actually, I haven't taken it yet as of this recording, but that is the sort of thing you need to know.

Also, there is a breakpoint percentile threshold you can specify, and that specifies how semantically similar a chunk must be to itself. So if you have a higher breakpoint percentile threshold, that leads to more distinguishable chunks, but there are less of them and they're bigger. Okay, so that's what you need to know about that particular parameter. Little example of it off to the side here well, not much of an example because frankly, that little snippet is kind of its own thought, so in practice, semantic chunking probably wouldn't split that up at all.

## Semantic chunking cost

Now, this does cost money, obviously. we're actually using a potentially expensive foundation model to chunk up potentially large amounts of data that adds up. You will be charged for the underlying foundation model cost for doing this, so use it wisely.
