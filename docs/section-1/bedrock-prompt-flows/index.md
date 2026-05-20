# Bedrock Prompt Flows

## From Prompt Flows to Bedrock Flows

Alright, we got a prompt, what do we do with it? One thing we can do with it is use it within a Bedrock flow, and this actually used to be called prompt flows, but it's become more of a general purpose tool. So these days we're talking about a larger flows feature, not just prompt flows. The idea is to have a mechanism for chaining prompts and models together, and it can do other stuff too. So it's basically a way to visually create these larger applications that might involve multiple prompts and multiple tools. So we're kind of getting into agentic AI land there. That's another section we're getting there, but Kind of touching on it here.

## Nodes and Connections

Now, a flow consists conceptually of nodes and connections between them. So really, you know, simple example here at the bottom here, we have input coming in from the user, the flow input, we'd not say a, a node, that input, it's being connected to another base retrieval. So all we're doing is taking the input from that flow input, from the user input, we're using that to do a knowledge base lookup, and then the output goes to our output, which is another node tied together by a connection. So world's simplest flow here as an example, nodes and connections, right?

## Conditional Connections and Branching

Now, those connections can also be conditional, and we'll see how that works in a minute, but I can branch things off into different flows depending on what's going on. So, for example, if my input said I don't want to do one thing versus another, maybe I can route that to different paths in my flow to perform different tasks within the same system.

## Flow Builder and the API

Now, we can generate these visually with the Flow Builder tool in the console, which means you can generate these AGENTIC AI applications without writing any code. Kind of exciting, right? Or if you want to, there is, of, of course, an API as well, so you can define the flows you want in JSON if you want to and build your own system around developing these flows too. That's also an option.

## Agentic Systems and Parallel Models

So again, we are getting into the world of AGENTIC systems here in that we're having more complicated systems that might have more than one model running in parallel, right? But it doesn't have to be that complicated, so we can see. In this simple example here.

## Saved Prompts in Prompt Management

Now, how does this interact with prompts in our prompt management system? Well, let's take a look. So, in this simple example here, we have our input coming in where we're saying, "Okay, I want a playlist for a given genre and number of songs," and we've wired that up into our saved prompt there that we just made. And I can say, "Okay, take out that genre and number from the input there," and I'm gonna use that saved prompt to actually hit a foundation model, and the output from that model completion will go to my flow output. So again, a very simple flow here that's just tying that saved prompt with user input and the output from that foundation model using that reusable prompt in the middle there.

## Playlist Demo and Structured Input

So, very simple way of applying those saved prompts in our prompt management system to do something simple. You can see here in this little example, it actually did something. So in my little test application here in my prompt flow builder, it recognizes that I have those two input fields that I need to populate from the input. So the input isn't necessarily just raw text, it can be structured data. And you can see it recognize that here, and on the left under the input, we are explicitly passing in a genre and a number, and we're gonna take that in, pass that into my save prompt to get back a playlist on the right there.

## Stored Prompts as Flow Components

So again, the takeaway here is those stored prompts that we've versioned and had variants of and all that stuff, those can be used as flow components to actually build applications around those saved prompts, and you can chain those together to do more complicated things using conditions. Also, you can see that you can enforce pre and post-processing on the inputs and outputs because we've sort of imposed some structure on that as well.

## Conditional Flow Overview

And just to give you an example of a conditional flow to see what sort of more complicated things you can do, here's an example. So in this particular example we have some random document of a string type coming in, so the flow input is just raw text from a user. Now I'm gonna pass that raw input into a save prompt that categorizes that input, and it might say, "Okay, this person is asking about retrieving some documentation, "or maybe they're asking about something else entirely. That save prompt's job is to take that input prompt and categorize it somehow into what the user wants.

## Documentation Routing and Knowledge Base

Now that condition node is saying, "If they're asking about documentation, if the output of that prompt was documentation, I am gonna pass that off to this knowledge base node over here, right? So it's gonna say, "Okay, you want documentation? I'll go look it up in this knowledge base and give you the answer. "If not, if it's something other than documentation, I'm gonna take that path on the bottom instead. " And I have a separate save A save prompt there that's more general purpose, it says, "Okay, take whatever they said and answer it in a professional manner," and the output of that prompt will be my final output in that case.

## Conditional Flow with Saved Prompts

So, simple example there of using a conditional prompt. In this case, we're using one save prompt to categorize the input, having a condition though to route that processing based on what it was categorized as, and in one case we're doing a knowledge base hit, in other case we're just passing it along to another FM. All right? So, a slightly more example of a complex flow, again, using saved prompts for prompt management.
