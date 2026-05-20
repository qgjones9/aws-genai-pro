# Enforcing Use of Structured Data

## Enforcing Structured Data in Responses

There's Let's talk about enforcing structured data in our responses. Sometimes we don't actually want just raw text in our output, right? We need actual structured data we can then operate on and do further stuff on. So how do we make that happen? Sometimes I need structured JSON output, specifically, right? So one way is to just say that in the prompt and say, "Hey, model, I need a structured output, please do that." And these days it usually will. You know, it is a little bit of a leap of faith to make sure that it actually follows those English language prompts. It might feel a little bit sketchy at first but this is how it works, folks.

## Prompt-Based JSON Output

So for this example prompt on the right here, I can say, "I want you to analyze customer reviews." The trick is to be specific, right? So if you provide specific numbered instructions, it's gonna be a little bit more likely to follow that more precisely. And it's also, of course, very helpful to give it an example of the output that you want.

## Attaching a JSON Schema

So I'm saying, "Hey," Analyze this review data within these specific tags. Give me back a JSON response that uses the provided schema. Okay, so I'm actually attaching an actual JSON schema to this prompt as well for it to use as a reference. And it says what to do. So if I'm missing fields return them with null values. If it if it doesn't work at all, give me an error response, okay? And here's an example of what I want that response to look like. So this is what a valid JSON response looks like: review ID, a sentiment, and a summary. And I've also, again, I'm gonna repeat, I've given it a provided JSON schema explicitly to use. So if you are super explicit and super simple in your instructions, it will probably follow them and say, "Okay, fine, here's your JSON data." So that's one way to do it, just bake it into your prompt and just make sure you're super specific.

## Tool Calling for Structured Output

Another way is by using tool calling functionality in these foundation models. So a lot of these systems are built around agentic AI systems now, right? And that means that these LLMs need to call tools. They need to have the ability to do stuff outside, you know, call stuff on the internet, call external APIs, whatever it might be, call MCP servers, call custom functions. In all those cases, we need to have some sort of a structured data to pass into these external systems, right? So this is a problem that's very well solved in most models. Bedrock is no No exception.

## Bedrock Converse API Tool Use

So if we use tool use in Bedrock's converse API, we can de-we can specify external tools that we wanna communicate with, and we could fake this out to just say, okay I want to call a tool that expects this schema, and that will basically say, well, okay, fine I'll do my best, and here's the schema, the structured data that you need to call this external tool. And, you know, even if it's not strictly speaking a tool, you just need that structured output for something else, maybe all the tool does is output that someplace where you can get it, right? That's fine, that's still a tool.

## Prompt vs Tool Calling

But in practice, this doesn't actually work any better or worse than just putting it in the prompt. So if you are building a larger AGI system with tools that your model can use, yeah, by all means, use those capabilities. but if you just need to get structured data back, doesn't really matter because under the hood, that's probably all it's really doing in the first place. with older, you know, smaller models, it did make a difference but with modern models, there really is no measurable difference between these two techniques.

## Exam Takeaway and Response Format Template

But the point though, for the exam, is that you can get structured JSON output out of a prompt. So that's the main takeaway in the context of this certification. And by the way, they might refer to that as a response format template. So the act of giving it a specific schema that you want the response in, that is a response format template, just to get the terminology consistent.
