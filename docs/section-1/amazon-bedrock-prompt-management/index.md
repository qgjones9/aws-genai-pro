# Amazon Bedrock Prompt Management

## Prompt management overview

One cool feature with Bedrock is prompt management that's built in, and that allows you to reuse prompts across different applications so you don't have to keep reinventing the wheel. So if you have some sort of a specialized prompt, you can share that across applications using prompt management, and they may be versioned as well. So if you wanna keep a history of how you've refined that prompt over time and want the ability to roll back, you can do that too.

## Variables in prompts

Also, what's useful is that these prompts can include variables, and this is where it becomes super useful. So this isn't just a version management tool, it's a way of incorporating these prompts into larger applications, and we'll see how that works momentarily.

## Variable syntax and placeholders

So you can have these placeholders or variables within these prompts for some value. So for example, I could say, "Make me a music playlist for genre music with number of songs," and by just enclosing those variables with double curly braces graces, I can tell the prompt management system that these are placeholders for other values. So when I'm using this prompt within a larger application, I can obtain from the user somehow what genre they want, how many songs they want, and then I can pass that into this prompt, send that off to my foundation model to actually get that playlist back for them.

## Prompt variants

Now, I can also have a prompt variant, so if I want to tweak that prompt for a specific model, or for specific inference configurations, or whatever, I can also have different variants of that prompt that are tuned for different foundation models or whatever it might be.

## Prompt builder, tools, and flows

Now, within the Bedrock console, we have a prompt builder tool to let us play with it, and we're gonna do that in a moment 'cause it'll make more sense when we see it, right? You can also associate tools and caching strategies with a specific prompt, and after we're done testing with it, we can deploy the prompt, and once a new prompt is deployed, we can use that within a flow. And Bedrock flows are ways of tying these prompts together and building larger applications out of them. So that's up next, but for now, let's do a quick demo and see how it works.

## Console navigation

Alright, just to make this a little bit more real, 'cause the slide didn't really convey it, let's take a look at the actual prompt management feature real quick. So I'm in the Bedrock console here, go down to Build and Prompt Management, and that's where it all starts. So create a prompt, test a prompt, use a prompt, sounds great, let's create one.

## Creating a prompt

All right, you need to give it a name. Now this can't have spaces or anything, so make sure that you only have letters and hyphens and underscores. So let's call it, I don't know let's do the example from the slides music playlist And you can give it a description if you want, that's a little bit more descriptive. generate a playlist. For a given genre. And a given number of songs. And if you want to have your own KMS key associated with it, you can, but I'm going to let Amazon manage that for me. Create.

## Writing the prompt

And now I can actually make my actual prompt here. So cool. Let's open that up for system instructions too, if you want to give it a system prompt associated with it that's kind of guiding it further. You have that option here as well. let's give it a prompt. You can see here the format of double curly brackets for parameters, for variables. We'll use that. So again, we'll just say, "Generate a playlist of..." Genre. Music Or songs more specifically? With a total of Number, sounds.

## Model selection and configuration

And now we need to associate that with a model of some sort, so we can associate that with a model or a larger agentic system if you want to as well. Let's stick with a model and select one. And I will use Anthropic, 'cause I like Claude, and I'm gonna go total overkill here and use Sonnet four point five for this. Apply. Alright. So we can see here we have some dials here, we can control the maximum output tokens here if we want to. We can add our own custom stop sequences, we can control the temperature of it.

## Testing the prompt

but most importantly, let's put in some test values here for the genre and number. So I will say, I don't know vocal jazz. And I want ten of them. And now I can actually test it within this prompt window, which is pretty cool 'cause I did select a model already, right? So let's go ahead and run it and see if it works. And obviously in the real world, I probably wanna give it a little bit more specific guidance there, but hey, these aren't bad. All solid choices, good job Claude.

## Save, version, and deploy

Alright, so now that I've tested it, I can actually deploy that if I want to as well. And to do that, I can go ahead and, well, first of all, if I wanted to make a variant, I could do that too. I could create a version of it if I wanted to, like we talked about, or I can save it. Let's save that as draft. Alright, so now that I'm done building my prompt, let's go back to the level above that, and I can actually create a version and deploy this thing if I want to. So let's create a version. And I have put published version one. Alright, so now version one of my prompt is out there, and I can actually use that within my larger applications, like for example, in an Amazon Flow, which we'll talk about next.
