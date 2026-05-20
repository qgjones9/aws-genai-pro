# Evaluating RAG Performance

## Why Measure RAG Performance?

So we built this big fancy retrieval augmented generated agent system knowledge base thing, right? How do I know if it's any good? So I can't improve it if I can't measure it, right? But it turns out that Bedrock has some pretty extensive ways of measuring the performance of a larger agent using retrieval augmented generation. So some things it can measure are in this list here. But first, let me talk about this little diagram on the right.

## The RAG Triad

So this is Basically the triad of retrieval augmented generation. We have a query coming in, we retrieve context from our knowledge base relevant to that query, and then we generate a response based on both the query and that context that we retrieved.

## Metrics Along Each Edge

Now, along each of these edges, there are things we can measure. So as we're retrieving context for a query, we can measure how relevant that context is to the original query, very important. As we're generating a response, we can measure how grounded that response is to the context that we retrieved. And finally, we can measure the relevance of the answer that we produced to the original query.

## Bedrock's Subjective Metrics

Now, there are mathematical ways of measuring all this stuff, and I get into that in more depth in my larger AI engineering course, but Bedrock has some more subjective ways of measuring this stuff. So we can measure correctness, how accurate am I in answering the original question? That's kind of the answer relevance there. How complete is my answer? How helpful is my answer? How logically coherent is my answer? How faithful is it? How well are the responses aligning with the retrieved context? That's kind of what we're calling groundedness here in this diagram.

If I have citations, how precise are those citations and how well are they covering what was retrieved? Am I producing harmful results? Am I doing any stereotyping I might want to try to avoid from this information? Are there, like, you know, hidden biases in the context that I'm retrieving that I need to deal with? Is it refusing to a answer things at all? You know, is it being evasive when answering questions it doesn't know about? These are all things that Bedrock can help you measure.

## Providing Ground Truth

And you might say, "Well, a lot of that sounds subjective. Helpfulness, you know, like how do I know if it's helpful or not?" Well, yeah, you have to provide a ground truth of what you consider to be good responses. So the way this all works is that you provide it with a data set of sample prompts and also a reference set of what a good response to that prompt would look like to you, and also what good contexts would be retrieved for that prompt as well.

So you're basically giving it your own subjective evaluation of, "For these prompts, this is the ideal outcome, this is the ideal context, this is the ideal response that I would get." And then the Bedrock evaluation system can use that to measure how close it is. So you give it in JSON format that prompt data set with both the prompts and reference responses. Reference contexts are optional, okay? So if you wanna be able to measure ground truth from your knowledge base, you need that.

## LLM as a Judge

And then the trick is that Bedrock will use another LLM, another foundation model, as a judge. So it will say, okay here's the prompt, here's what I produced, here's what the system produced, how well does that match up with the reference responses and contexts? And the evaluation model, the judge model, if you will, will decide how good it was. So this is what we call LLM as a judge, and we'll talk about this a little bit more later on as well.

## Judge Models and Multiple Evaluators

So you have this other model, maybe it's Llama, Claude, Nova, or Mistral, and the specific metrics that we're going to measure are defined within prompts to that model. So we got one model that's generating your response from this rag system, from the knowledge base. We have another model that's judging how well it's doing. And different models will do that scoring in different ways. So maybe you want multiple judges, you know, you have multiple mod-models evaluating this, and you can see if they agree with each other if you really wanna get fancy.

## Context Relevance Prompt Example

Now, how this works in specifics, I wouldn't worry about that for the exam, but just to give you an example to wrap your head around, here is the documented prompt for measuring context relevance with the Nova Pro model from Amazon. So if you wanna read through that, you can kinda get an idea of how these LLMs as a judge work and how they evaluate whether a given response matches up with the desired output. And in this case, it's just gonna score it as no, maybe, or yes, alright? So the output is specified as explaining the response and giving a final answer of no, maybe, or yes, just giving you the format that it wants to get back and how it will arrive at that answer.

## Subjective but Actionable Metrics

So it's it is subjective to some extent, you know, we're using these fancy foundation models to do that evaluation, but still, it gives you a metric that you can use and try to improve upon that should measure how well your rag system is performing.
