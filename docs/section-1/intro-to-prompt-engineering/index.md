# Intro to Prompt Engineering

## What is prompt engineering

You know, generative AI tends to say the word "delve" a lot for some reason, so let's delve into the world of prompt engineering, shall we? What is prompt engineering? Well, how you ask a generative AI system matters a lot, right? So when you're dealing with generative AI and chat applications in particular, you need to ask it for what you want, and how you ask matters. The more detailed you are, the better. The more the way you ask it can really influence the result that you get, and that's what we call prompt engineering, just the the art and science of asking the right way. To the AI.

## Benefits of effective prompting

Some of the benefits of effective prompting include boosting the model's abilities and improving safety. So by asking things the right way again, you can get better results out of the model and maybe get it to do things you didn't think it could do. And if you ask just the right way, you can also improve safety. You can prevent it from telling you to do the wrong thing, you can tell it to not leak sensitive information, things like that, if you just make sure you specify that in your prompt.

## Augmenting the model with domain knowledge

It also allows you to augment the model with domain knowledge and external tools without changing the model parameters or fine-tuning. Now, this is getting a little bit into a gray area of what I would call prompt engineering. What they're talking about here are specific techniques like re retrieval augmented generation, or RAG for short, and LLM agents. And I'm gonna talk about that later on in the course in the context of Amazon services for generative AI, because it'll make more sense there. But what they're talking about here is basically at a high level, taking your own documents, your own databases, your own data stores, storing that in a very specific way that's friendly to generative AI, and then using that to retrieve contextual information about your question and including that in the prompt before it sends it into the actual large language model or what have you. So in a way, it's cheating, you know, it's taking your original prompt, looking up relevant information from an external data store, and then combining all that together into a final prompt that's actually fed into the, the model itself.

## External tools and capabilities

When we talk about external tools, it's a similar idea but a little bit different. So in addition to having external information, we might have external functions or capabilities that we introduce into the system. So we can tell through the prompt or the set of prompts that the system has, "Hey, I want you to answer this question, and by the way, if you need to figure out what the current weather is in this given city, you can use this bit of code over here to do so, and that will allow you to access some external service to get that information." Or if I need to like retrieve some internal information through an internal service here's a function you can call to actually get that information in real time. And under the hood, the AI can actually go back and forth and say, "Okay, this person is asking for this information, I have this tool at my disposal that might be useful, let's go get some information from that tool as well, and then combine all these responses together into a final response."

## RAG, agents, and AWS training scope

Again, I'm not sure I would call that prompt engineering, but they do lump that under this category in the AWS training material. I'm personally going to put that That off until we talk about the actual service implementation because I think it will make more sense, but that's what this is touching on: retrieval augmented generation and LLM agents.

## Exploring model capabilities

Another benefit of effective prompting, and this is getting back to just plain old prompt engineering, in my opinion interacting with language models just to grasp their full capabilities. So sometimes you just gotta play around with them to figure out what they can do, what they're good at, and what they're not so good at, right?

## Quality inputs and outputs

And obviously the end result, what we're trying to do, is achieve better quality outputs from our AI system through better quality inputs. So garbage in, garbage out, the converse is true, you know, if you put in a good prompt, you're much more likely to get a good answer from a generative AI system.
