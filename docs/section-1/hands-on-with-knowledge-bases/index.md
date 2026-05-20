# Hands-On with Knowledge Bases

## Introduction and goals

Let's play around a little bit with knowledge bases in Bedrock, which is kind of the first step toward building larger AGentic systems, which we will do later in this course. But for now, we're just gonna create an underlying vector store and query it from within the Bedrock knowledge base feature. So let's see how that works.

## Console navigation

Alright, I'm in the Bedrock console here, and quick disclaimer, the UI here changes like every day, so if things aren't exactly where they appear in this video and you're following along, don't panic, you should be able to find it. currently under Build is where you'll find knowledge bases, so I'm gonna go ahead and go there.

## Knowledge bases overview

From here, we can get a little overview of what they're all about, and we can see that we now support custom vector stores, whatever cool new announcements are up there, and I'll dismiss that. And you can see at a high level, we can create a knowledge base with a vector store, a structured data store, you can connect that to a database or table, or also you can connect it to Kendra these days as well. We'll learn about Kendra a little bit later. But for this, we're gonna create our own vector store and query it directly, so we have a little bit more control over how that works. We can also proceed to test it out, which we'll do here, and then once we have a working knowledge base, we can integrate it into larger applications or use it within any other system.

## Create a vector store knowledge base

So let's start by creating one, which is easy to do. Click one of these two create buttons, and we have a menu of options here. We do want to make a vector store one here. Again, these other options are cool too, Kendra or connecting it to a data store, but we want to use a vector store.

## Name, IAM, and region

We need to give it a name. So let's call it, I don't know Sundog rag or something. Whatever you want. And if you wanna give it a description, you can. I'm gonna let it create its own IAM permissions because I'm lazy, but if I did wanna have finer grain control over that, I could try to do so. Of course, getting those permissions just right can be a little bit tricky so do take care if you go that route. By the way, I'm in North Virginia right now for my region. do make sure that you're in a region that supports Bedrock, not all of them do.

## Data source configuration

And now we need to figure out where our data's coming from. So this is the data source. This is the data that we're gonna be importing into our vector store, not the vector store itself. So I'm gonna go ahead and throw that in S3 somewhere, but you can see that I can actually suck in data from any other places as well, SharePoint, Salesforce Confluence, or even a web crawler if I wanted to, or my own custom data source too. So you can ingest data from pretty much anything you can dream of, but I'm gonna use S3. If I wanna give it a tag, I can, and if I want to do some log stuff there, I can do that too, but I'll skip that for now. So let's go to next.

## Name the data source

All right, so now I need to give this data source a name. This is where my data is coming from. Let's call it Frank's book or whatever you wanna call it. What we're gonna do is upload the full text of an old book I wrote like, you know, fifteen years ago on self-employment, and well, it doesn't make any money anymore, so I'll just give you the text of it for free as a thing to play with here. So we need to put that in S3 first.

## S3 bucket and upload

So before I go any further, let's go ahead and kick off another window for S3. And if you have an existing bucket you want to use, you can do that. but just for completeness, I'll create a new one for this. Now let's give it a name. Remember this has to be globally unique, so use your own name here. SunDog Frank's Book. Again, use a different name because it has to be different. And I'm not gonna get into how S3 works here, I'm assuming that you are familiar with S3 already if you're at a professional level exam, but you know, there is some material on S3 a little bit later in this course if you need it. So I'm gonna leave these, I'll leave the default settings 'cause they're perfectly appropriate for what I'm doing here. And create that bucket.

Now if I navigate to that bucket What do they call it? Sound like Frank's book? There it is. Let's go ahead and put my book in. So let's hit upload. And from here, I can navigate to my course materials, let's add file. And where did I put that? So for me, it's in this directory, but somewhere you downloaded the AIP materials folder and unzip it at the beginning of course. Go back to the very beginning if you need it. And book dot txt is what we want. And let's go ahead and upload that.

## Select S3 URI in Bedrock

All right, so now we have a bucket S3 that I can ingest into my knowledge base. So back to Bedrock, let's go ahead and select the URI to that book dot txt file. So I'm gonna go ahead and browse S3 to find it. New bucket, it's not coming up. A little bit of a cork in the UI, sometimes you need to refresh it before it'll actually see it. And sometimes even a refresh doesn't cut it, I'm actually gonna refresh this whole page. And hopefully that'll make it pick it up, so let's give it that name again. Next book, whatever you wanna call it, description if you want. Again, it's three. That's okay. I'll just go ahead and browse it again. There it is. Alright, a little bit clunky there, but we're back where we started.

## Parser options

Alright, so we got some choices here. We can use the default parser, the Bedrock Data Automation Parser, or the Foundation Models Parser. So if I had like weird unstructured data, these might be useful. But since I'm just uploading plain text here, the default parser is fine. It's not multimodal here. I'm not embedding you know, images and videos and stuff. It's just straight up text, so the default parser will do just fine.

However, if I was uploading things like Images of driver's licenses or passports or you know, forms of some sort or PDFs, images, audio, video, whatever it might be. Better autodata automation is a really cool feature for extracting structured data from that sort of unstructured data, so we're actually getting information out of images and videos that might be helpful. So that's a cool option too.

Also, we have the option of using foundation models as a parser, so we could actually say, "Go spin off a foundation model and have it try to extract meaning from this information," and again, that could go beyond text documents and Extract information from PDFs, images, tables, forms, whatever it might be. So depending on the nature of your data, you might need more or less complexity here. Since I am just dealing with text, which is usually what you're gonna be dealing with, the default parser is a-ok.

## Chunking strategy

Alrighty. So again, it warns you if you need speech retrieval or maybe state automation. State automation is a really cool feature by the way, so it can do a lot Chunking strategy, we're gonna talk about that too. So default chunking is fine that's going to be splitting that text into chunks of three hundred tokens per chunk by default, and I have some control over this. So that means it will chunk up my book at a three hundred tokens at a time, or roughly three hundred words at a time. it does make sure that I don't split up sentences along the way. So if you're pretty sure that the basic meaning that you're trying to convey in this passage of text can be conveyed within three hundred words or so, that should work pretty well.

Basically, we're gonna take each one of those chunks, turn them into an embedding vector, and we'll be ready to go. Retrieve relevant information for a query for a prompt later on, it'll retrieve the chunks that are most relevant to that query, and hopefully there's enough information and enough context within that three hundred token window to actually get some useful information.

If I think that's not the case, I can specify my own chunking. So I can, I can say, "Well, I want to use this many tokens per chunk, and I want to have this much overlap between those chunks, whatever it might be." I can also have hierarchical chunking, where I actually have a parent-child structure, where I search for child, you know, finer-grained chunks, but when I have a hit there, it actually goes up one level to a parent. That contains more complete context surrounding that smaller chunk, so that allows me to get very precise results at the child level and then suck in more context from the parent above that.

Semantic chunking I can also try to do it a little bit more intelligently. So just splitting up by a number of tokens, I can use a foundation model to say, actually split this up based on different concepts. So when I start talking about something that's different in topic, go ahead and figure that out for me and chunk it up semantically. Obviously that gets more expensive because we're using a foundation model to do our chunking. Or I can say no chunking if I want to pre-process it myself and break up into individual chunks, one chunk per document. I can have the ultimate control that way, but I'm gonna go with the default here.

## Lambda transformation and advanced settings

A few more optional settings here. If I didn't want to attach a lambda function, I can do that too. So this is an important thing to know, it's possible to have my own lambda function that controls that chunking and processing that data as it's being indexed into my knowledge base. So it is possible to have a structure where you have a knowledge base that goes through a lambda before actually ingesting data into the into the line vector store. If I had a lambda function for that, I can do that and specify that as my transformation function.

And there are some advanced settings we can take a peek at as well. If I want to use my own KMS key for security, I can do that. If I wanna have my own data deletion policy, I can set that here too.

## Vector store deletion policy

By default, the VectorStore data will be deleted when the data source is deleted. This is an important point, folks. So just because it deletes the VectorStore data doesn't mean it deletes the VectorStore itself. This is a little bit misleading. So we're gonna be creating an OpenSearch serverless index to actually store this data in. And if I delete this knowledge base, you might think it would delete that serverless instance, but it doesn't. It just deletes the data that's in it. So if you're not careful, you will be left with an OpenSearch serverless instance running, and even if you're not using it, you're gonna get billed for that. The simplest serverless instance for OpenSearch is gonna run you a couple hundred bucks a month, so you do need to remember to delete everything with OpenSearch serverless when you're done using it. But I'm at least going to make sure that I delete the data, so I want that too. But if you did want to retain that data and make sure that that survives a cross-deletion of the knowledge base, you can choose that here too.

## Embeddings model selection

Moving on, you can also select an embeddings model, but we have to, 'cause we need a model to convert those chunks of text into embeddings vectors that kind of represent their meaning. So let's go ahead and select one. And you have several available to you here. If you don't see any here, you might be in a region that doesn't support Bedrock, or you might need to go and explicitly request access to that model in the model catalog. but for me, I'll just go ahead and use Titan That is just one, sure. And if you want to use a newer model, go for it, you know, I'm not gonna stop you, but I know that one works. So this will be on-demand inference, which was I have for that one. Yeah, apply that.

## Vector store type selection

Alright, now I need to put this data somewhere so I can do a quick create of a new vector store or use an existing one. So if I have an existing vector store, OpenSearch or whatever it might be, I can connect to that instead of spinning up a new one just for this knowledge base. If I don't have one, I'll spin up a new one. And now we get to choose the type of vector store. Sequoia's a few choices here. So we can use Neptune Analytics if we want to actually store graph data. By graph, I don't mean charts and graphs, I mean a graph data structure, useful for like social media networks and things like that. Aurora has a PostgresQL vector embedding add-on thing that you can use for vector stores in Aurora that might be appropriate if you have, you know, kind of a mid to medium-sized amount of data to deal with, but SQL capabilities aren't important to you. S3 vectors are really cool, they're only preview as of this recording, and As of now, they're not in scope for the exam, so I'm not gonna talk about it too much. But if I were making a new system, that would be my choice because S3's pricing, the whole lot S3 is a lot simpler to use fewer things to worry about with, with S3 as opposed to older versions. Or the default thing that the exam wants you to focus on is open source serverless, so let's go ahead and select that as our underlying underlying tool

Alright, so we've got a local search circle vector store that we want to use, yeah, embedding vector. Almost done, there's a few additional things we can tweak if you want to. I'm not gonna get into that, but if you did want to, like, have more control over your KMS key with OpenSearch, you could do that. If you wanna have more redundancy and pay more for it, I can do that too, but we're just playing around, so I'm definitely not doing that

## Review and create

Alright, we're almost done here. Just need to review everything, make sure it looks good. So let's go ahead and create our objects. That's been for a bit. Under the hood, it's gotta create that open-source serverless vector store. This will take a minute, so I'll come back when that's done.

## Sync data source

Alright, that took about five minutes or so, and our knowledge base is created. However, our data isn't yet synced up to it, so as it's helpfully telling us here, we first need to sync our data source to index that content for searching. Just take a moment. So let's go to the data sources, which are right here, actually I didn't have to go anywhere. So let's go ahead and select that data source for Frank's book here and select that and say, "Sync." Yeah, let's wait for that. It's not too big of a book, so it shouldn't take too long. Ivan, that's all. Yeah, that only took like 10 seconds. Alright, so we have our data synced, I think our knowledge base is ready to use.

## Test knowledge base

So let's go ahead and click on the test knowledge base button and see if it works. Let's get rid of all this stuff. Alright, so let's go ahead and do a retrieval and response generation. So in a way, we're making our own little simple test agent here to actually query that document for us in real time.

## Model selection for testing

Alright, so let's write a prompt about my book. First, you need to select a model though. So which model am I using to actually generate those responses? Again, you need to make sure you have access to one You can choose whatever you want, I'm gonna go to, to have frost And let's use the latest greatest Sonic 4, 'cause, you know, But it shouldn't cost you much. Again, if you don't see anything here make sure you're in a region that supports Bedrock and you might need to request model access, but going forward you shouldn't So whatever model you want.

## Query demo and results

And let's try it pop now and see if it works. So I can ask it a question about the content that's in my book and see if it actually references that. So part of the book talks about, "When are you ready to try self-employment?" So let's ask it. What are some steps to follow before deciding to become self-employed? Off you go.

Alright, and you can see it's actually referencing bits from the book itself, and this does in fact align. The contents of my book, so that's pretty cool. And if you click on one of those references, it actually links you back to where I got the context from. If you wanna go a little bit more depth, we can click on details.

## Chunk details and hybrid search

And this is actually giving me back the original chunks that came back, so how about that? So the query itself is nothing special, but this is where it gets interesting. So this is the relevant chunks of data, three hundred tokens apiece, remember, that I thought were relevant to that particular query, and in fact There's also metadata potentially associated with that chunk, so this is just used for the citations, but you can also imagine doing hybrid search here, where you're searching specific metadata keys in addition to those embedding vectors. We'll talk about that in a bit. And another chunk that I pulled up, so if you wanna dive into that, you can get into the details. We're actually retrieving five, the top five most relevant chunks here were relevant to that prompt, and it constructed a pretty good response as a result. So how about that? Very cool.

## Cleanup warning and course follow-up

Alright, let's close that out. And I'm gonna be building on this in later exercises in this course. So we're gonna make a guardrail around this system, and then we're gonna actually ingest this knowledge base into a larger agent system later in the course. So if you are confident that you're gonna be proceeding into this course very quickly, Go ahead and leave this up and running. However, like I warned you, if you do leave this up and running, even if you're not using it, that OpenSearch serverless database is gonna keep costing you money, even if you're not using it to the tune of a couple hundred bucks a month. So you might wanna think about Tearing this down and spinning it back up when you get back to that agent lecture if you don't think you're gonna get right to it just to show you how to get rid of this thing.

## Deleting OpenSearch serverless

Go to Knowledge Base. And from here, you can say delete And it's giving you a nice little warning here that says the vector store itself isn't deleted, only the data. they actually added that because I complained about it. But even if you do that, you would have to still go to OpenSearch As a second step. And from here, find your serverless instance. So under server, let's just go to the dashboard. There's my underlying serverless instance where to go. There you are. So you want to delete that collection as well? I'm not gonna actually do it because I'm gonna build on this right now, but you would want to make sure to delete the collection in your serverless dashboard for OpenSearch Serverless to avoid getting charged for that going forward. Very important step.

Alright, but if you're gonna be pushing, forging ahead, then go ahead and leave it running, and we'll get back to this later in the course.
