# Mulitmodal Models and Pipelines with Bedrock

## Multimodal models overview

Alright, let's talk a little bit about multimodal models and multimodal pipelines and what that means. Pretty simple concept, it just means that we're mixing different media types into the same model. That might be text data, it might be images, it might be audio, it might be video, could be documents, whatever, right? So basically, we have a model that's able to have specialized encoders for all these different data types, and it produces these embedding vectors that allow us to compare these different types of media against each other.

## Bedrock multimodal models

Now, some models available for Bedrock are multimodal natively Claude, for example, is. It can handle images and text or whatever. Amazon Nova as well is multimodal, and Amazon Titan is an embedding model specifically that is multimodal in nature as well. So that's pretty cool, right? It means we could take a picture of a chicken and some text about a chicken and throw them into our multimodal embedding model and get back embedding vectors that are comparable.

## RAG and cross-modal retrieval

So then I can search for a chicken, and I might get back the image and also the text related to that. And this is gonna be important within the retrieval augmented generation stage of things, right? So as I'm retrieving Context about the prompt about chickens, this will allow me to retrieve that data in whatever form it might be that's relevant to the query.

## Embeddings and prompts both ways

So to search, I just hit the model for an embedding vector for whatever image, text, or video I'm sending in, and that too could be in any format, right? So I could say, "Here's a picture of something, what is it?" Right? And I could say, "Okay, well, my embedding model says this is similar to chickens, and it could come back with text about chickens, right?" So it works both ways, right? So I can embed embeddings in my rag system from different types of media type, and I, I can also take prompts that incorporate different types of media as well through these multimodal models and pipelines.

So it just lets us mix and match text, images, audio, video, documents, whatever it might be.

## Titan Multimodal Embeddings G1

A little bit of nitty gritty on how it works, so let's dive into an example using the Titan Multimodal Embeddings G1 model. So again, this is just an embedding model here. the way it works in practice, if you're writing some code to actually embed something, where it might be a bit of text, where it might be an image, both are accepted by this particular model, you're gonna have to encode this stuff in some consistent way.

## Titan API and base64 encoding

Now, the specific API for talking to the Titan Multimodal Embeddings model looks like this on the right. So you pass in the model ID. Pass in input text and/or an image, and if it's an image, I need to go in base sixty-four encode that first. So that's what you're seeing there with that little line in the middle that says base sixty-four dot b sixty-four encode, reading up the context of that chicken image and then converting it into UTF-8 format so I can send it across so that it kinda looks like text data across the wire but we know it's image. So then I dump that into a larger JSON structure where I have input text that contains any text I wanna encode, input image contains that base sixty-four encoded image data that I wanna encode, that's what gets sent into the model at the end of the day, alright?

## Text, image, or both

And in the case of the Titan model, you can pass in a text or an image or both if you want to at the same time any of those cases will work fine.

## Pipelines and preprocessing

Now, if you're doing this, this implies that your data processing pipeline needs to do this at some point, right? So at some point before I hit my model, I need to take those images and base sixty-four encode them in this particular example. And how we do this, well, we'll get to that later on. Maybe you'll use SageMaker, maybe you'll use Glue, maybe you'll use something else entirely, like something built into Bedrock. We'll get to that, alright?

## Summary

However, that's what multimodal models and pipelines are. They just mix and match different media types at the end of the day.
