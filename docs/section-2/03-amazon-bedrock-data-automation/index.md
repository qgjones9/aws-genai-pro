# Amazon Bedrock Data Automation

## Introduction to Bedrock Data Automation

Kind of a cool new feature in Bedrock is Bedrock Data Automation. It's a lot of fun to use and very powerful, and let's see what it's all about.

## What Is BDA

So, what is Bedrock Data Automation? I'm gonna call it BDA for short, 'cause that's a mouthful. It's a way of extracting structured data automatically from pretty much anything. So it is totally multimodal. It can deal with documents, i-images, video, and audio.

This little simple example on the right, we have somebody's fake driver's license here. At least I hope it's fake, and you can see that, that is being extracted into some structured information that it got out of it. So it says, "Hey, We have a picture of a driver's license, I can tell that's from New Jersey, from the Motor Vehicle Commission, and here's the information that's on it, the actual driver license number, date of birth the name, address What color their eyes are, all that good stuff. Organ donor, it's all being extracted successfully there.

So that's an example of using Bedrock Data Automation where you just give it a picture of that driver's license and it can automatically extract that information from it 'cause it knows it's a driver license. So it's pretty neat how useful it is.

## Use Cases and Intelligent Document Processing

And this can be useful for preparing data, obviously, for GPT stores or knowledge bases. So if you want to extract data from this more unstructured information that's a way of actually getting that into your knowledge base and using that to provide context for your Gen AI systems.

More generally, this is part of what we call intelligent document processing, what it, that's what it's doing, IDP for short. So if you see the term IDP or intelligent document processing, odds are they're talking about it in the context of Bedrock Data Automation.

## Video Analysis Capabilities

It can also be used for analyzing videos, which is also cool. So if you give it a video file, it can actually do things like summarize what's going on in individual scenes and identify where those scenes are. It can identify explicit content that might exist in that video, it can extract text that's embedded in the video, and it can even find ads that are in the video and, well, maybe strip them out for you. That might be handy. So it's really, really neat stuff that kind of borders on magic, really.

## Standard and Custom Output

High-level concepts of BDA, Bedrock Data Analysis there's a standard and a custom output. So if you just throw a file at it and say, "Go for it," it will just automatically figure out what the right standard output for that should be. So for a document, you're probably gonna get back some sort of a JSON data. for audio, you're probably gonna get back a transcript file in text, et cetera, et cetera. So it will do its best to do the right thing just automatically if you throw data at it.

But if you want more control, you can do that too. So there's also custom output, at least for documents, audio, and images, for video not so much right now. But you can specify exactly what fields you want to extract, and you store that specification for a given document type in what's called a blueprint. And there are standard blueprints, like for driver's licenses, like we just saw, you can start from those and extend them and modify them, or you can define your own. So you can have your own custom output that extracts exactly the information you want from these documents and nothing more.

## Blueprints, Projects, and Programmatic Invocation

Once you have that, those blueprints ready, you can store those configurations in a project with Bedrock Data Automation. And once you have a project, that might include many blueprints for many different kinds of documents, you can start throwing data at this project, and you can do that programmatically from a script. So now you're starting to see how you can scale this up for doing large-scale intelligent processing and extracting structure from that unstructured data.

So through the API there's an Invoke Data Automation Async call on Bedrock Data Automation. So from a script, you can say, "Here's my project, here's some data, go do your thing with it." Okay, it's just that easy. So pretty cool stuff.

## Console Demo Overview

So real quick, just to make this real, if you go to the Bedrock console, and currently it's under build, I mean, these menus tend to change very quickly over time, so you might have to hunt around a little bit, but look for data automation. And from here, they should have a built-in demo. So yeah, let's try the demo and see how it all works.

But if you want more information on what's going on, there's an alternate way of presenting it. So yeah, you select a file, review the results, and from there you can create a project and blueprint if you want to, and then use those within a script.

## Driver's License Demo Walkthrough

So let's try it out with a sample demo. So you can upload your own data if you want to, or import it from S3. Just to make life easier, let's try that driver's license that we saw earlier in the slides there. And you can see here that you can put it in a custom bucket if you want to. by default, it will make one for you, but you can put it wherever you want, of course. If you want your own KMS key, you can do that. If you want your own tags on the data, you can do that. But yeah, I'm just gonna throw this picture of a driver's license at it and generate a result.

And you can see that this does in fact work. Now, one little caveat here, you do need to have cross-region support enabled for this to work at all. So I'm gonna confirm that, yeah, I do have that enabled. And now we're gonna let that run and do its thing. And here we go.

Alright, so if we skip down to the results, kinda cut to the chase, we can see that same information that was in the slide, and yeah, it looks accurate, so that's kinda amazing, if you ask me.

## Demo Output Options

And we can also see some of the stuff we can control here. So we have the standard output here, which is kinda what it's doing by default, and you can choose different granularities, we'll talk about that in a moment. We can also choose the text format we wanna get out. In this case, we're getting text with markdown formatting, but if you wanna plain text or HTML or CSV, we could choose that as well.

Also, it has the ability to return bounding boxes for the information that it found on the original image, so if you wanna know where it got the data from, it can give you the actual image coordinates where that came from as an option. And it can also have generative fields where it actually generates a description and high-level summary of what this thing is about. Probably not terribly useful for a driver's license, but for other types of documents, maybe so. And you can also have the choice of returning just JSON data or also JSON plus additional files that might be associated with that. So Only for documents there.

## Exploring the Demo Further

So yeah, it actually works, it's kind of cool, and if you wanna play, play around with it some more, you certainly can Go back to the demo and just start over, and from there you can try different document types, you can try your own data, you can try images, you can try videos, you can try audio. They have some built-in examples here to play with too, so kind of fun stuff. But I just wanted to show you that to make it real.

## Document Processing

Alright, let's go into a little bit more depth here with document processing in particular with Bedrock Data Analysis. So some file types it can accept are PDF, TIFF, JPEG, PNG, and DOCX, a Word document, and it will output either JSON or JSON Plus files like we just saw in the demo there. So again, with a plain old JSON, you might be missing some extra data, so there might be additional files like CSV for tables or the overall text extraction or the Markdown format, right? And you can also export to HTML or CSV if you want to, we saw those options in the demo as well.

And remember that came up earlier, by the way, in the context of structuring unstructured data. So one of the recommendations was to take unstructured data, reformat it as HTML, and that'll make your model be able to understand it better. Here's another way of doing that, that's a little bit simpler.

You can also select the granularity of responses, and we we glossed over those choices in the demo there, but you can choose from page level granularity, element level, which is the default, or word level granularity in the responses you get back in that JSON output structure. So you can get a granularity of responses at the page, element, or word level. You can also choose for bounding boxes to come back to, or generative summaries, we also saw that in the demo as well.

## Image Processing

For image processing, we didn't look at that too closely, but that accepts either JPEG or PNG images at the moment. And what you can get back from that is both an image generator and a caption, if you want. You can also get what's called the Interactive Advertising Bureau Taxonomy, basically trying to categorize that image into what it's all about. If there are any logos in the image, it can try to identify those and identify what they are. If there's any text in the image, it can extract that. So in this example here, it could extract the text, "Welcome to the Infinite Toolbox." It also has content moderation features, so if you want to identify if there's anything objectionable in that image, it can tell you, and it will return that in JSON format.

## Video Processing

For video, it will take MP4, movie file, AVI, MKV, or WebM formats. It will extract a full video summary that summarizes what the video is about, chapter summaries, which by the way implies it can identify chapters to begin with, which is, in itself, is pretty cool. Also, the same IAB taxonomy we talked about with the images, a transcript of the entire video, any text found in the video like AWS re:Invent, any logos found in the video, also content moderation features, and again, this is returned in JSON format.

## Audio Processing

For audio, that will take AMR, FLAC, M4A, MP3, OGG, or WAV formats, and it can also handle a variety of languages as well. That will extract for you a summary of the file, a full transcript of the file, and that will include speaker and channel labeling in that transcript so we know who's saying what when. You can also break that up into topics automatically, and it also has content moderation if you're saying any naughty words, and again, the output format is JSON.

## Blueprint Field Types and Creation

Talk a little bit more about BDA blueprints. So if you're doing custom output, how does that work? So there are different kinds of fields. There are basic fields, and these can be explicit or implicit. Implicit meaning they are transformed in some manner, and not just raw data. There are also table fields when you're setting up your blueprints. There are groups that you can organize fields together into, and there are custom types you can define. So for example, you could create a address type that consists of the city, street, ZIP, and state or whatever all mashed together, and that would be an example of a custom type.

You can also create blueprints from a prompt, so if you don't wanna actually be specific and, you know, define these in the, the UI and get into the nitty-gritty of defining different fields yourself, you can just do it through a prompt and say, "Hey, I want this blueprint to do this," you figure it out, and you can actually have a foundation model try to generate that blueprint for you as part of the blueprints feature. Again, pretty cool. And there are a lot of pre-existing blueprints, you don't need to reinvent the wheel for different doc-document types. So if you do have a passport or something, there's probably a blueprint for that already that you can start from.

## Uses of Blueprints

Some uses of blueprints, what are they for? So you can actually use these for a bunch of different things. One is for classification. Blueprints can automatically try to classify your document and figure out where it should go, what blueprint should be used. So it will automatically use the class and description to try to automatically classify that document that matched the blueprint at hand.

Blueprints can be used to extract data, of course. So you can extract specific fields, even if it's from tabular data, it can get it out of there for you.

Blueprints can also be useful for normalization. So normalization refers to the problem of, you know, the same data being called different things basically. So key normalization can deal with different names for the same data. you know, maybe it's called street in one place and street address in another place or street one in another place. Key normalization can combine all those different labels together to mean the same thing. And similarly, on value normalization, if the data in those key, under those keys is different it can try to make that more consistent for you. So, you know, a great example is date Formats those vary from country to country, value normalization could allow you to have a consistent date format or anything else for that matter.

Obviously, blueprints can transform data as well. You can split your data, restructure data fields, mix and match it however you want to, and you can also use it for validation. You can check if your data is within specified ranges, if it's the expected size, things like that. So some basic validation to make sure that your data is accurate to begin with can also be done using blueprints.
