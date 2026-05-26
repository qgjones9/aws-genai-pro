# Amazon OpenSearch Serverless

## OpenSearch Serverless overview

A few words about the more recent serverless version of OpenSearch, and keep in mind this was only introduced in January of twenty twenty-three, and it usually takes at least a year for new technologies to make it onto the exam. So watching this video before twenty twenty-four, you might not even pay too much attention to it, but regardless, you should know this exists, you know, if you're actually gonna go out and apply what you're learning here to the real world, which hopefully is the goal, you should know that OpenSearch serverless is a thing, can make your life even easier.

## On-demand auto-scaling

It provides on-demand auto-scaling, so unlike the managed version of OpenSearch, you don't have to think about the number of underlying servers to manage that for you.

## Collections versus domains

The main difference when using the serverless version versus the managed version is that you don't think about domains anymore, you think about collections. Just another word of how you organize your indices there.

## Search and time series collections

You can create two different kinds of collections, a search collection or a time series type of collection, two different collections.

## Encryption and KMS

OpenSearch Serverless is always encrypted. You give it a KMS key and it does the rest.

## Security policies

You can enforce your own data access policies, and encryption at rest is always required, it's always there with the Serverless version. Configure your security policies across many collections at once, unlike the managed version where you need to have separate policies for each individual domain. It's a little bit easier to use.

## OpenSearch Compute Units

Capacity in the serverless version of OpenSearch is measured in OpenSearch Compute Units or OCUs. You're able to set an upper limit to control your costs if you want to. The lower limit, however, will always be two for indexing and two for search services.

## Console navigation

Beyond that setting it up and using it's pretty much the same as it was in the managed version. You just go to the console, go in search, and now you'll see two different sections there over on the menus on the left. One will be for the managed version, and one will be for the serverless version.

## Future of serverless OpenSearch

I would imagine that over time they'll start to promote the serverless version more, but as of this recording anyway, it's it's still a new thing, so we'll see how it goes.

