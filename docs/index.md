# AWS GenAI Pro


* [Course Resources](https://www.sundog-education.com/ultimate-aws-certified-generative-ai-developer-professional-course-materials/)

| Section | Description                          |
|---------|--------------------------------------|
| [Section 1](section-1/index.md)   | Study notes and materials for course section 1.   |
| [Section 2](section-2/index.md)   | Study notes and materials for course section 2.   |
| [Section 3](section-3/index.md)   | Study notes and materials for course section 3.   |
| [Section 4](section-4/index.md)   | Study notes and materials for course section 4.   |
| [Section 5](section-5/index.md)   | Study notes and materials for course section 5.   |
| [Section 6](section-6/index.md)   | Study notes and materials for course section 6.   |
| [Section 7](section-7/index.md)   | Study notes and materials for course section 7.   |
| [Section 8](section-8/index.md)   | Study notes and materials for course section 8.   |
| [Section 9](section-9/index.md)   | Study notes and materials for course section 9.   |
| [Section 10](section-10/index.md) | Study notes and materials for course section 10.  |
| [Section 11](section-11/index.md) | Study notes and materials for course section 11.  |
| [Section 12](section-12/index.md) | Study notes and materials for course section 12.  |
| [Section 13](section-13/index.md) | Study notes and materials for course section 13.  |
| [Section 14](section-14/index.md) | Study notes and materials for course section 14.  |
| [Section 15](section-15/index.md) | Study notes and materials for course section 15.  |
| [Section 16](section-16/index.md) | Study notes and materials for course section 16.  |
| [Section 17](section-17/index.md) | Study notes and materials for course section 17.  |
| [Section 18](section-18/index.md) | Study notes and materials for course section 18.  |
| [Section 19](section-19/index.md) | Study notes and materials for course section 19.  |

## Course Overview

* Foundation Models
* Fine tuning
* Retrieval Augmented Generation
  * Knowledge Bases / Vector DB's
  * Optimizing embedding vectors
* Gaurdrails
* Prompt Engineering
* Bedrock Prompt Flows
* Enterprise Integration

Managging Data for Generative AI
* Amazon Cloudwatch
* Amazon SageMaker
* Amazon Transcribe
* AWS Glue
* Amazon OpenSearch Service
* Amazon Comprehend
* Amazon Relational Database Service
* Amazon Aurora
* Amazon Simple Storage Service
* Amazon DynamoDB
* S3

Agentic AI
* Agents in Bedrock
* Multiagent workflows
* Stands Agent
* AgentCore
* Humans in the loop

Operational Efficiency and Optimization 
* Content Management - Token Efficiency
* Model selection 
* Resource utilization and throughput
* Caching 
* Building responsive and resilient AI Systems
* Resource allocation Systems
* Bedrock Cross-Region Inference

Managing Models with Sagemaker AI
* Processing, Training, and Deployment
* Deployment Safeguards and Optimizations
* Ground Truth
* Model Monitor
* Clarify
* Model Registry
* Lineage Tracking
* Edge Computing with Neo
* Pipelines

More ools for Building AI Apps
* AWS Lambda
* Amazon API Gateway
* AWS Outpots Family
* AWS Step Functions
* AWS EventBridge
* DevOps: CodeBuild, CodeDeploy, CodePipeline
* Appsync
* Outposts
* Wavelength
* Amplify

Governance and Security
* Bedrock prompt Management
* Agent Tracing
* Evalucation Techniques
* Responsible AI
* Cloudwatch
* Cloudtrail
* X-Ray
* Lake formation 

Security, Identity, and Compliance
* IAM
* KMS
* Macie
* Secrets Manager
* Cognito
* WAF (Web Application Firewall)
* VPC
* PrivateLink

Other stuff you should know 
* Analytics
* Compute 
* Containers
* Customer Engagement
* Database
* Dev Tools
* Machine Learning
* Management and Governance
* Networking and Content Delivery
* Storage

## Lecture 

Welcome, welcome, welcome to the AWS Certified Generative AI Developer Professional certification course. That isn't a mouthful, and you're gonna find this course isn't a brainful. A lot to cover here. My name is Frank Kane, I'll be along with you for most of the ride here, and we'll try our best to make it fun. So what I've done is I've gone through the entire official exam guide for the certification, as well as all of the official AWS training materials in Skillbuilder, and I've organized it in a way that I think is gonna be a little bit more efficient for you. So let's This course isn't really directly organized around the domains of the exam because I find that a lot of the material is a little bit repetitive, there's a lot of overlap between those domains. So instead, I've organized it, things in a way that has less repetitiveness and it's also organized in a way where things kind of build on each other a little bit better. So we'll start with fundamentals, kind of work our way up, and I think that's gonna be a more efficient way for you to prepare for this exam. So let's dive into what exactly we're gonna cover here and what the different sections are so you know what to expect. We're gonna start with the fundamentals of generative AI and Amazon Bedrock, which is basically the fundamental service that's built around generative AI. Or AWS, we'll talk about foundation models or FMs for short, you know, those are the GPTs of the world, the Amazon Novas, the Amazon Titans, the, the Clouds, things like that, foundational models that we build these systems on top of. We'll talk about how to fine-tune those models, how the data is formatted for making that happen, to tune these models to have more of a specific, customized function for you. Talk about retrieval augmented generation, or RAG for short, talk about how Bedrock implements those with knowledge bases, backed by various vector stores or vector These are ways of basically injecting ground truth data, real world data, unfiltered metadata into your systems to make them more tuned for a specific application and hopefully make them hallucinate less as well. Vector databases store vectors, embedding vectors in particular that kind of embody the meaning of different chunks of text. We'll talk about how to optimize those for the best performance as well. We'll talk about guardrails and how to implement those to make sure that your system isn't doing things it's not supposed to do and also to protect it from malicious actors and things like that. We'll talk about how to manage your prompts and make the best use of them and optimize them for the Best performance, and we'll talk about bedrock flows, pond flows being kind of a part of that larger system. That's a way of chaining different ponds together, different systems together to build larger, more complex systems with bedrock. We'll also touch on enterprise integration a little bit in this section and some of the tools and techniques for integrating your system with the sources of data that's in your enterprise. Next section we'll be focusing on managing data for your generative AI system. So all that data has to get in there somehow, especially if you're using retrieval augmented generation, you gotta populate that big ol' vector store with something. We'll talk about all the nitty gritty of that. So we'll have to transform and structure your data along the way. We'll talk about some tools for doing that, some of them on the right here. We'll talk about bedrock data analysis used to be called bedrock data matur Really cool system for extracting structured information from unstructured information. We'll talk about SageMaker Data Wrangler, which might be another tool for managing a pipeline of transforming your data into the format that you need. And we'll talk Talk about some AWS AI services like Transcribe and Comprehend that can be used to massage your data along the way as well, and extract some information from it We'll talk about AWS Glue as an alternative way of managing your extract, transform, and load pipeline for managing your data, and we'll talk about CloudWatch as a role as well in keeping track of what's going on as you're going along. We'll go into a lot of depth with OpenSearch because that is kind of the main way of implementing retrieval augmented generation and knowledge bases with Bedrock, at least in the context of this exam. So we're gonna talk a lot about the nitty gritty of OpenSearch and how to tune it, and also how to tune it specifically for generative AI workloads. There are some alternative vector store technologies out there as well. You can also use things like RDS or Aurora, so we'll talk about that. Possible to tie DynamoDB to OpenSearch directly as well and use that as the data source, we'll talk about how to do that as well. And of course, S3. Well, we're not gonna go to the basics of S3, I'm not assuming you know that already, but there are some finer points of S3. Around life cycle management that we want to get into here Next, we've got a section focused on agentic AI, that's basically giving tools to your AI system and letting them interact with the outside world or at least other stuff on your computer. We'll talk about how agents are implemented in Bedrock, and then we'll go into multi-agent workflows where you can have many agents working in concert with each other, maybe in parallel to do more complicated things, how that works. One tool for making that happen is Trans Agents, which is a Python SDK we'll talk about a little bit. We'll also talk about Amazon's newest service as of this recording, AgentCore, and that's a service for making it easy to deploy these agentic systems into production. And making sure they have an easy way of deploying them at scale without getting into the whole you know, management of the actual services that we need to deal with It also comes with a lot of cool features for adding memory capabilities and additional tools as well that you might find useful. We'll talk about ways of injecting humans into the loop of your system. If something's really important, you might want humans in there trying to kind of check things out, make sure things aren't going sideways, and there are some ways of doing that as well. And then we'll talk about the Amazon Q ecosystem, and this is just a set of tools that use AGentic AI to help make you more efficient as a developer. We then have a whole section on operational efficiency and optimization, because this is a big part of the exam, so we're gonna dedicate a whole section to that. We'll talk about context management and token efficiency, making sure you're not paying for more tokens than you need. We'll talk about choosing the right model for the workload you have, so maybe different prompts deserve different models, and a simpler, smaller model will do the job, and you can select that in runtime back in stage. We'll talk about optimizing your resource utilization and maximizing throughput. We'll talk about using caching. Make things a little bit more efficient too and further reducing your token spend. We'll talk about the principles of building responsive and resilient AI systems on AWS and how to optimize the performance of the underlying foundation models that you're using, and we'll get into some specific resource allocation systems you can use to make sure again that you're only using the resources you need. These are all the things I need. So, caching, building, responsive. We should System He serves We'll finally talk about bedrock cross-region inference. Not only is that an important way for spreading out the load of your application, but it's actually essential for some applications, so we'll talk about that too. Now, I was actually on SageMaker AI, SageMaker kind of being an alternative The energy Just using Bedrock for deploying your models gives you a little bit more control and you can deploy basically any machine learning model generative AI foundational models being one of them. We'll talk about how to process data, train data, and deploy your models on SageMaker AI. We'll talk about safeguards and optimization around the deployments with SageMaker AI so they give you some really good tools for safely rolling out changes and rolling back if you need to. We'll talk about SageMaker Ground Truth if you need to collect labeled data. We'll talk about model monitor for, well, monitoring your model's performance over time, making sure it's not drifting off, and also clarifies you can understand why it's doing what it's doing. Model registry for keeping track of your different models and sharing them across different applications, lineage tracking for understanding where your data came from and where it's going. And we'll talk about edge computing with SageMaker, the ultimate performance right here, where it's happening. SageMaker pipelines, an important tool for managing the flow of your data and the flow of your system for larger gen AI systems. And then we're gonna talk more about building apps around your AI system, so, you know, it doesn't do much good to have a model sitting out there in a vacuum. You gotta build an application around it to make it actually useful Right. While the usual suspects are here, AWS Lambda, we'll talk about how that is specifically relevant to generative AI applications and the role it might play in larger systems. We'll talk about API gateway, of course, because that will be sort of the front end, that the interface between your gen AI system and other applications, very important piece. App Config for getting your app to do different stuff on the fly. Step Functions, very important for basically having things like circuit breakers, where if things go wrong you can handle these special cases. Event Bridge for making sure that you're being triggered as new data or new information is being generated. Incorporated that to your application. And then the suite of DevOps tools called Build, Code, Deploy, and Code Pipeline, just for making it easier to get your AI applications out the door. We'll talk about AppSync as well, AWS Outposts, and AWS WaveLength in the context of integrating with larger enterprises. And SQS for sort of having a buffer and event-driven model between incoming data and your generative AI application that's a little bit more recent. And we'll also talk a little bit about Amplify because of course that's a tool for the front end. Have an application without presenting it to the user We have another section on governance in QA that is also an important domain of the exam. We'll talk about bedrock's product management tools for keeping track of the prompts you're using in your applications and reusing them across different Talk about agent tracing, so you can actually figure out why your agent did what it did if something goes wrong. Techniques for evaluating your agent AI or just generative AI applications in general. How do I know they're doing what they're supposed to do and how do I make them better? Principles of responsible AI. We'll talk about the role CloudWatch plays in all of this and keep a track of what went on, and CloudTrail, of course, having that audit trail, that audit record of whatever your services did. We'll talk about Amazon X-Ray, of course, in the same context and lake formation, in the context of controlling access to the underlying data that makes up your application. And pretty much every AWS exam has a section on security, identity, and compliance. This one is no different. A lot of the usual suspects here, we'll talk a little bit how it's specifically relevant to GenAI. IAM, of course, is kind of the the bedrock of it all, identity, access management for defining roles and what different, you know, people can do with your system. Key management service for keeping track of your credentials for these services, VPC for identifying sensitive information, Secrets Manager for storing those credentials in a secure manner. Cognito for handling user login, WAF for protecting your larger application, and also some network services for making sure people can't get at your stuff who shouldn't be there, VPCs and private IPs. A lot of this will sound familiar from other certifications. And then we have a bunch of stuff on other services you should know So there's a ton of services that are explicitly listed as in scope on the exam, but they're not really directly related to generative AI. Now, some of these you might know from previous certifications you've done or just from your experience. So if you aren't encountering some services that you're already very familiar with, you can skip those lectures. I won't tell anybody. But if these are somewhat new to you or you're not really sure what they do, you definitely want to go through these sections to remind yourself of the role they might play in larger applications. So even though these aren't generative AI services per se they are components of larger systems that you need to know about, and I promise you, they do in fact show up, at least in the practice exams for this exam And also in the skill builder materials pretty prominently. So you just kind of, kind of go through these for review if you need to. So we have a whole suite of services here, but these are some of them, some of the icons here on the right. there are analytics, compute, containers, customer engagement, database, dev tools, machine learning, management and governance, networking, content delivery, and also storage. So again, kind of a review here of other services that the exam expects you to know about but they might not be new to you. So I've kind of put all that stuff at the end just in case. It's basically a giant set of appendix. Alright. So some of this might seem familiar, right? So like I said, this new GenAI exam kind of builds upon earlier exams. So it is replacing the machine learning specialty exam, which is being phased out in early twenty twenty-six. If you took that, well, that's more about classical machine learning, a little bit about generative AI, but it is kind of the same level as that professional and specialty are exactly the same thing, but you can expect this to also be a very challenging exam. This professional level exam is gonna be presenting you with real-world scenarios, complex scenarios with complex requirements. I'm asking you to choose the best solution, the best implementation to meet those requirements. So these aren't gonna be, you know, simple quiz questions like what service does this. You gotta think, you gotta understand what these things do and how they fit together Data engineering, even though that's explicitly out of scope for this exam, you'd be surprised how helpful that knowledge is for actually figuring out how these systems might come together. So that's definitely gonna be helpful background. AI practitioner foundational course is gonna be helpful for more of the business focus of what we're building here, and the most relevant, the closest one I'd say to this new certification is the machine learning engineer associate certification. So if you did take that one before, you're gonna find that to be extra helpful for getting through this one. Now, we do share a little bit of material between our prep courses for these different certifications, there's not a ton of overlap. Between this new certification and previous courses, so you're not gonna see a lot of that here, but especially in the appendices for sort of the review of other services, some of that content has been reused from these other courses, just to put it out there, make sure you're not surprised by it. Now, who is this certification for? So the official target candidate from AWS for the GenAI developer professional is somebody with two or more years of experience with AWS and machine learning and AI, right? So you shouldn't, this shouldn't be your first certification. You need at least some experience with AWS, understand how the basic components fit together, or this isn't a good one to start with. They also recommend one or more years of experience hands-on with actually implementing generative AI solutions. And modern generative AI is a pretty new thing. I mean, AI's been around forever, but You know, today's, you know, AGI systems around LLMs, while you're, good luck finding someone who has more than a year of experience with This stuff shouldn't be new to you, is what it comes down to, you know, you should at least know what AI is and how it's used, right? Also, the AWS basics shouldn't be new to you. I'm gonna assume that you know what S3 is, things like that. If you don't, then you really should go back and take a Cloud Practitioner certification first. So, again, this shouldn't be your first certification. It's a more advanced professional level one. So the basics of things like storage and security and IAM, that shouldn't be new to you, I'm assuming you already know that going into this, but I'll cover that too much Explicitly, it doesn't require model development and training, so that means that you just need to know how to use these foundational models, you don't necessarily need to know how to make them and build them from scratch. Also, classical machine learning, not really a thing in this exam. It's all about generative AI, foundation models, and it does state that you don't need a data engineering or feature engineering background, but again, data pipelines and data manipulation is part of this exam, so that one's a little bit hand-wavy. Alright, let's get started. We got a lot to get through here, so let's get going. We'll try to make it as fun as possible. We can, so let's just dive in and get going, folks. Let's get certified.