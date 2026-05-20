# Types of Prompts

## Three Types of Prompts

There are three types of prompts you should definitely know about that Amazon covers and this isn't just an Amazon thing, these are pretty widely recognized.

## Zero-Shot Prompting

One is the zero-shot prompt, and this is a prompt where no examples are given. So in the previous lesson, we gave an example of where we gave it some cases to go by of what sentiment analysis should look like. We gave it an example of a positive and a negative sentiment and how to label that. You don't need to do that though all the time, so if you have enough information in the training of the model itself Sometimes you don't need to give examples at all. You can just say, "Classify this as positive or negative sentiment," and it will just go off and do it. So that just relies on the model being large enough to have enough training information to know what you want, to actually understand what you're asking for without any explicitly given examples handed to it.

Again, sentiment analysis being the example I want to use for that one. You could just say, "Determine the sentiment of the following sentence," and not give it any ex-any examples. That would be an example of zero-shot prompting.

## Few-Shot Prompting

However, few-shot prompting is the opposite of that, where you do give it some examples. So in a few-shot example, you could give it some examples of the desired responses to given prompts. So you could say, "Again, determine the sentiment of the following sentence using these examples. I had a great time at the park today should be positive. That restaurant had terrible service should be negative." Give it as many as you want. The more you give it, the more you'll sort of train the system as to both examples of what you consider to be positive and negative sentiment and also what the output should be. So it's not only learning how to classify things through these examples that you're giving it, it's also learning the format that you want the response in, in this case positive or negative.

## Chain of Thought

Finally, there's chain of thought, and I mentioned this again in the previous slide too. If you tell it to think step by step, you can get it to try to break things down, break down larger problems into their subtasks. So an example would be, describe how to solve a quadratic equation using the quadratic formula. Think step by step, starting with the standard form of a quadratic equation, identifying the coefficients, and then applying the quadratic formula. Make sure to include an example equation and solve it.

## Think Step by Step

So we've done a couple of things here. First of all, we said Think step by step. That's telling it to break this down into a few subtasks, so don't try to tackle this problem all at once. I'm forcing you to go back and break it down into some specific subtasks here, and often that can result in a better result and one that's more explainable as well.

## Explicit Step Guidance

I've also told it explicitly what to do, so I'm not trusting it to do that reasoning by itself on how to break down the solving of a quadratic equation. I'm giving it explicit guidance on what those steps should be. So I'm saying, start with the standard form of a quadratic equation, so it can go off and retrieve that from its training data. Then identify the coefficients, it tried to figure that out on its own, maybe it needs to write its own code to figure that out, I don't know, and then actually apply the quadratic formula. Again, it might go off and write some Python code to figure that out, but we've given it guidance on how to break this complicated problem down into more straightforward subtasks,

## Example Output

and this is what the output of that might end up looking like in the real world. I think this is an actual capture that I did. So here's an example of where it actually took that example and broke it down like I said and actually solved it for the specific problem. It might have a harder time doing that if I didn't tell it to think step by step.
