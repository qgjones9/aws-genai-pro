# Hands-On with the Bedrock Playground


## Bedrock and the playground

Alright, Amazon Bedrock is called Bedrock for a reason. It is basically the foundation of Amazon's generative AI offerings, and one way to get familiar with it is to play around with it. So we're gonna go into the Bedrock playground here. Bedrock, again, is a common API, a common interface, a common UI that sits on top of many different foundation models, and the playground allows you to play around with them and get a feel as to where strengths and weaknesses are by just experimenting and see how they respond to different prompts.

## Console navigation and model selection

Under the Bedrock console in your AWS console, under Test, you can go to Playground here, and the first thing you need to do is select a model. Now it's important to note that different models have different capabilities, so, you know, you might wanna click through to the model cards here to get a feel as to what they can do. You can also choose what sorts of output a model supports and filter by that, and also by what sorts of inputs they support as well.

## Unity labs and Claude Haiku

Now, if you are using this on Unity and have access to their subscription offerings that include lab access for AWS, there are only a few models that are supported in that environment. One of them right now is Anthropic's Claude Haiku four point five. You can see here that it support supports both text and image input and it text output Max, if the limit of two hundred K tokens, so let's go with that because I know that one works.

## Anthropic use-case submission

However Something to be aware of is that currently, if you select a cloud or an anthropic model in general it will actually prompt you for a use case submission before it lets you use it. Now, don't worry, you don't have to like wait for somebody to review your submission and get back to you a week from now, it'll be approved right away. They're just collecting data. But if you do hit the apply button and get a pop-up window that wants a use case, just throw in a URL to, you know, a website that's associated with you somehow. For the use case, you can just say educational use, that's all they need to know.

## Chat mode

All right, so Haiku does support the chat mode, default. So this is what you would be used to in a, in your typical AI application, right? So it's a chat where you can have this conversation with the AI model, and it refers back to that previous conversation entries as part of the underlying context, so you can have this ongoing evolving conversation that can refer back to earlier points in that conversation because it's all part of the same context. So just like you would do with any other, you know, AI model, you can ask it random questions like what is the meaning of life? And it will give you a deep answer that's probably not the glib forty-two one you usually get from people. Yeah, it is what you expect.

## File upload demo

We can also include content in the form of files, so if we go to upload a file here, we can go to wherever you downloaded the course material so you can go back to the earlier lectures in this course if you need to know where to get those. And there is a Word document in there that reflects the bylaws of an astronomy club that I used to be the president of. And by including that document, I can now have it analyze that document and I can ask questions about it, so I can say according To the attached. Bylaws What are the forum requirements for an annual election. And that very quickly came back and it says, "Yes, I need at least fifteen members and two board members to have a forum." So that was easier than reading the whole thing myself, yeah?

## Configuration options

Let's also explore some of the configuration options you can play with for these models. So if I open up this little configuration icon, I can play around with different things. So system prompt, let's walk through these 'cause these are important, right? these are basically overarching directions and guidance that you wanna give to the model as a whole throughout the chat, throughout your entire usage of it, so I can say things like, "Always talk like a pirate." So now if I clear this chat and start over, hopefully that will take effect and I can say, "Uh, what is the meaning of life?" And now it will tell me an answer in pirate speak, so you can see that it just doesn't get old. I mean, talking like a pirate isn't old school, but it's still funny.

## Model reasoning

Alright, you know, let's go through the other options here. So model reasoning this kind of controls just how deeply it thinks, right? And you can have a little slider here of just how much reasoning you want to apply. A little bit different from different APIs, so, you know, under the hood, I know that Anthropic has kind of like, you know, a low, medium, and maximum setting for reasoning, but this allows it to actually Put an additional layer on top of the LLM that's used for the foundation model, break down your complex request into a series of sort of smaller requests that get chained together basically. So if you are doing a more complex query like, you know, plan my retirement or something like that, model reasoning would be a good thing. The trade-off of course is that you're gonna be using more tokens, more expensive tokens, and you will pay for that.

## Output length

Length, if you wanna enforce a maximum output token length, again, this might be a good thing for enforcing costs, you can put that down to make it more terse basically, so You know, if I go down to Four thousand tokens or so, then it's not gonna give you more than four thousand or so words in a response. It can be a good way to keep it from being too verbose. So if you're actually accessing these models through the Bedrock API, you're probably paying by the token, and this is a good way to control those costs.

## Stop sequences, temperature, and Top P

You can also have manual stop sequences, so by default, this is gonna be like a line feed or something, but if you are in a special case where your output has specific stop sequences, specific formatting so randomness and diversity, this is important. So temperature is basically a measure of how random the, the responses are. So By default, it's one, which is a little bit surprising, but if I want it to be more deterministic I can lower that. This is actually great out for this model, 'cause I don't think it's actually supported by the Haiku model. However, we do have a top P setting as well, also great out for this model. Interesting. Other models will probably behave differently.

At a high level, though, again, temperature is the randomness in when it chooses the next token as it's generating text. So higher temperatures will give you more variance in the responses that you get. Lower temperature will give you more deterministic results, where it's having less of the random A chance at what it actually says in the end. So if you want more, quote-unquote, creativity you might want a higher temperature. Top P works in a similar way to Top K. These actually control how it selects those candidate tokens that come out the end of the actual transformer models. So Top P is basically what is the probability level that I want to use as a threshold for those output tokens, and Top K is basically how many of those tokens do I want to have to choose from randomly when I'm generating the next token. I might be getting a little bit ahead of myself, tokens are basically equivalent to words with LLMs. So, a top K says how many candidates for the next word do I want to generate, top P says what is the probability threshold of that being the "quote-unquote" correct word that I want to be choosing from at random. So, again, these are all just ways to control how random, how diverse, how creative, if you will, the responses are.

## Guardrails

We can also add guardrails here, we'll talk about that later, but we can set this up through the guardrail API here in Amazon Bedrock visually, and that's just a way of filtering out people Saying naughty words or talking about things you don't wanna talk about protecting personal information, PII, things like that.

## Prompt caching

Another option here is prompt caching. This is actually very important for saving costs as well. If you have a situation where your prompts are going to be reusing the same text over and over and over again, maybe a set, a set of instructions, maybe it's a system prompt prompt caching can save you a lot of money. So instead of feeding that through every time and paying the token cost for that every time, you can just cache that those tokens and for a much lower cost. You still have to pay for them, but it's a cheaper rate usually.

## Single prompt mode

Alright, so that's chat mode. there's also single prompt mode, so if you don't want that chat history to be part of it, you can just let's single prompt. that doesn't actually work with Claude Haiku unfortunately, so I can't show you that. If you see the Haiku if you want, use like Amazon, Nova or something like that, that might be a better choice.

## Compare mode

Now, the quick note here is compare mode, that's kind of cool. So if you actually want to compare two models against each other, you can do that here. So you might have access to Jamba one point five large, which is another inexpensive model. We can actually write the same prompt and put them through to both and see what the difference in responses are. It also gives you the separate set of configurations here so you can make sure you're comparing apples to apples. For example, two hundred output tokens. Well, you know, let's actually leave that short just to kind of show you that it works. This does say that it doesn't support images, whereas Haiku does, so don't upload images. Good to know.

And now we can say, what is the meaning of life? Pair the two. Oh, and like I said, Haiku doesn't support single prompts, put that back to chat mode. And now, let's try that again. What is the meaning of life? Yeah, we can put Jamba head to head against Claude and see who gives us a better answer. And Claude again is in pirate mode, so you can see that the answers are quite different. So again, keep in mind that the configuration is managed separately for each of these models, and if you want a, a fair comparison, you need to make sure that those settings are comparable as well. actually, John gave a pretty decent answer there, especially given the token limit, right? So I'm like, "Give this back to me within like four hundred words or so." And it it understood the assignment, so that's pretty cool.

## Other modalities

Alright, let's try different modalities as well, so we don't have to just do chat, we can also experiment with images and whatnot. Now, if we go back to the playground, in theory, we could try out other models that have different modalities, like image and video and audio. as of this recording, there aren't a lot to choose from in Bedrock though, so let's go back to the playground, select a new model, and you can see we can filter that by the output, so like I want an image model. currently, the only choices are legacy models, so these don't actually work right now. but, you know, that might be different for you, so go ahead and experiment there if you want to play around some more.

you can also look into Audio and video modalities as well, again, not a lot to choose from except for Nova 2 Sonic right now, but feel free to experiment with that. It kinda works the way you'd expect. The only difference is that if you go to an image model, the configuration settings are gonna be a little bit different. So, so let's use like a Nova Canvas, for example, here. And you can see here that the options are gonna be a little bit different. So for an image model, the configuration options are gonna be different than from a text model, of course.

## Image models and Nova Canvas

So there are different things you can do here, like generate an image, generate variations of the given image that you upload. You can also remove objects from an image, replace objects, replace the background, remove the background, virtual try on, that's kinda cool. So all sorts of different things you can do. And for that one, you can say, "I just wanna like put new clothes on this person that's in my picture, right? " Pretty cool. You can also give a negative. The prompt that says what not to do, so if you wanna like generate a picture of a chicken and you don't want the chicken to be blue, you can say, you know, don't be blue chickens. You can also control the size of the image, which is very handy, that's kind of a hard thing to control. Chat APIs, you know, specific color palette for branding purposes, you can do that as well. A conditioning image that gives you an example of the style that you want, and the prompt strength, basically another creativity lever if you will, how strictly you want it to adhere to your prompt guidance. And the seed is a random seed, so if you want deterministic results, give it the same seed and it should do something similar every time. And this doesn't actually work right now, so feel free to experiment if you have another model to play with here in Bedrock. But right now that is how Image would work.

## Prompt routers

Also, I wanna point out different router models as well, so you can see that we have these serverless model providers, which are the foundation models that you're used to. You can also select routers, so we can have a Nova prompt router or an Anthropic prompt router. You see what's going on here? So basically it's going to take a look at your prompt and automatically figure out how complicated of a model do I actually need to fulfill this request? If you're asking for something really simple, it might send it to Light or Haiku. my retirement, you might send it to Nova. Pro or Claude. Sonnet instead.
