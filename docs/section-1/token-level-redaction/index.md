# Token-Level Redaction

## When Guardrails Aren't Enough

So what if guardrails aren't enough? You know, they're pretty fancy, and fancy sometimes means it's complicated, and complicated sometimes means it doesn't work all the time. So sometimes you want something a little bit simpler just to be safe. That's where token level redaction comes in.

So you can build a token level redaction system around your larger system to filter stuff out before it even hits your model at all, or at the output, you know, right before it hits your actual end user. It's kind of another layer of defense there, if you will.

## Input and Output Filtering

So it allows you to have a filter that filters out the input going into your system, and if somebody's asking you to do something you don't wanna deal with right up front, you can say, "Nope, right there and then there, don't even hit your model at all." And if something happens to slip through your model, maybe you can catch it at the last minute instead of not catching it whatsoever.

## Word-by-Word Filtering (Not Model Tokens)

Now, I'm not really talking about tokens like tokens within the actual underlying transformer model of your foundation model here. we're just talking about filtering the, the text coming in and out of the system really on a word-by-word basis.

## Lambda Pre and Post-Processing Handlers

How does that work? So one way it would be to have a lambda function that implements a pre or a post-processing handler around your inference endpoints. So when you're deploying a generative AI system, you have an inference endpoint that actually faces the outside world, right? So that might be on Bedrock, it might be on SageMaker, but we can define these pre and post-processing handlers to implement this token-level reaction if we want to.

## Pattern Recognition vs Named Entity Recognition

So we might have a lambda function that serves as a filter on the input and the output side, and what it does is up to you. So you could do something simpler and just do something with pattern recognition, like with a regular expression that says, "Here's a list of naughty words I don't want to filter out." Might be that simple, or maybe you want to identify sensitive information using something more fancy with named entity recognition.

You might use Amazon Comprehend for that, for actually identifying more sensitive information in a slightly more robust, but again, more complicated manner. Again, it's just a, another layer of defense there that guardrails might miss potentially, token level redaction, this kind of filtering the input and output directly.

## Filtering During Data Ingestion

If you want to do things even more robustly, you could also do this as, as you're ingesting data into your system for training or populating your vector stores, so these same filters might be useful for filtering the data that you're ingesting for the system too.
