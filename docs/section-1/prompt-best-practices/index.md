# Prompt Best Practices

## Introduction

Let's go through some best practices for prompt engineering that Amazon recommends.

## Be Clear and Concise

One is to be clear and concise in what you're asking for. So a bad example of a prompt would be, "Write something about books, talk about two people and what they like, make it interesting." That's a little bit too vague. You know, we could be more specific about what we want there. A better example would be, "Write a short dialogue between two friends discussing their favorite books." And, you know, that's a little bit more concise. It's a tighter way of expressing what you want. The more wordy you make things, the more room there is for things to go wrong and how these things work.

## Include Context

Include context. So bad would be write a short dialogue, but a better approach would be to say more specifically, write a short dialogue to be used in a movie script. So being more precise about what you want, give it more context about what you want to get out of this thing.

## Specify the Desired Response Type

Specify the desired response type. So you could just say "write a short dialogue, " but what does "short" mean? You wanna be more specific again. It would be better to say, "Write a short dialogue where each line is no more than two sentences long. " You can be very specific about the type and format of the output that you want there.

## Desired Output at the End of the Prompt

And also specify the desired output at the end of the prompt if you can. So just write a short dialogue, obviously, is way too vague, but the better example here is where we put all this together, where the desired output is at the end of the prompt. At the end there, I'm tacking on where each line is no more than two sentences long, so that tends to help the the model understand what you want and actually deliver on what you asked for.

## Phrase Input as a Question

More best practices, always phrase your input as a question if you can. So a bad example would be explain the benefits of regular exercise period. A better one would be what are the benefits of regular exercise question mark? Because, well, that might more easily pick up training information that it picked up during the training of the large language model that, where people actually asked that question and got a relevant answer.

## Provide Example Responses

Provide an example response if you can. So again, in the input section of the prompt, this is a good example of doing that. So you could just say, "Determine the sentiment of the following sentence," and try to let it figure out what sentiment means. It would be better to supply some examples of how you want that to work. So I could say, "Determine the sentiment of the following sentence using these examples." "I had a great time at the park today" should result in the word positive. "That restaurant had terrible service" should result in the word negative.

So not only here can you give it examples of what positive and negative sentiment are, you can also tell it exactly what you want the format of that response to be. So because you gave it those examples, it knows that you want to get just the word positive or the word negative as the output. And this is a great trick for actually getting somewhat structured data out of a large language model. You can be very specific about the output that you want and the words and format that you want that output in if you just tell it and give it some examples on how to do it, it can learn from it.

## Break Up Complex Tasks

Break up complex tasks. So if you want something more complicated, like, you know, writing a large system and writing code for it the truth is, at least today, large language models aren't really great at reasoning. So you need to do the reasoning for it whenever you can. If you have a complex task, help it out by splitting that up into simpler subtasks and then ask the LLM to, to execute each subtask individually.

## Keep It Simple and Chain of Thought

Keep it simple. If you're not sure if what you're telling it is simple enough, you can ask the model to say, "Hey, do you understand what I'm asking for?" although you'll probably be able to figure that, that out pretty quickly based on the quality of the answer that you get.

Sometimes the trick is to ask the model to think step by step. We call this chain of thought prompting, and we'll talk about that later. but you can actually get it to generate those subtasks on its own sometimes. So this is as close as LLMs get to reasoning right now, if you explicitly ask it to think step by step, it will at least try to break this down into subtasks and break this down into individual components when it tries to solve the problem based on similar problems that it saw in its training data.

## Experiment and Be Creative

And experiment, be creative. So remember, these large language models are non-deterministic, they change a lot. You're not gonna get the same answer every time you ask. So as these models develop in their capabilities and evolve over time, you just need to play around with them and stay on top of what they're good at and what they're not good at through trial and error. Try out different prompts, see what works the best.
