# Amazon OpenSearch Service Performance

## Optimizing Cluster Performance

The. A few quick notes on optimizing performance of your Amazon OpenSearch cluster.

## JVM Memory Pressure and Unbalanced Shards

One thing to think about is memory pressure in the JVM, and a couple of scenarios that can result in that are having unbalanced shard allocations across your nodes. So if you have a certain set of shards that are doing most of the work and a few that are just sitting there doing nothing, that can cause memory pressure on the overworked shards.

## Memory Exhaustion and Swapping

And when you run out of memory, bad things happen, right? You start swapping memory to disk, and your performance tanks. So Often that can result in performance issues

## Too Many Shards

Also, having too many shards in a cluster can also cause trouble. Sort of a fundamental truth of distributed computing is that less can be more sometimes. The act of distributing that processing often takes more work than you think, and specifically can take a lot of memory to manage it all.

## Fewer Shards and Deleting Indices

So the takeaway from all this is that if you're seeing JVM memory pressure errors in your logs, often you can fix that by having fewer shards to yield better performance. And the way to get fewer shards is by deleting older unused indices if you can. So if there's a way to offload data from your cluster into some archive where you don't need it as much, maybe you can unload data off the glacier or something and delete the indices associated with that old unused data, that might be a good way to get around that JVM memory pressure error. Or maybe you have indices that just aren't used at all. Get rid of them, that'll help too.

## Avoiding JVM Memory Pressure

See, I just a quick note here on avoiding the JVM memory pressure error specifically within Amazon OpenSearch.

## Document ID Hash (The Sorting Rule)

You need a fast, unbiased way to decide which cabinet it goes into. You decide on a rule, you look at the customer's unique ID number, do a quick math calculation, and use the result to pick a cabinet. The automatic sorting rule ensures your files are evenly spread out across all ten cabinets rather than accidentally cramming ninety percent of them into cabinet number two.

## Distributed Across Nodes (The Team of Assistants)

Now if you keep all ten cabinets in one room With just one employee, I don't believe we won't get overwhelmed I need to look at Fox. To fix this, you hire a team of five assistants. It's

## The Shard (The Filing Cabinet)

The Shard (The Filing Cabinet)Instead of stuffing every single file into one giant, slow-to-use filing cabinet, you buy 10 smaller filing cabinets. In the tech world, each of these individual cabinets is called a shard. It holds a portion of your data and represents its own workspace.

## The Document ID Hash (The Sorting Rule)

When a new customer file arrives, you need a fast, unbiased way to decide which cabinet it goes into. You decide on a rule: you look at the customer's unique ID number, do a quick math calculation, and use the result to pick a cabinet. This automatic sorting rule ensures your files are evenly spread out across all 10 cabinets, rather than accidentally cramming 90% of them into Cabinet #1.

## Distributed Across Nodes (The Team of Assistants)

Now, if you keep all 10 cabinets in one room with just one employee, that employee will get overwhelmed trying to look up files. To fix this, you hire a team of 5 assistants (nodes) and give each assistant 2 cabinets to manage.

## Parallel Processing (The Business Benefit)

When a big corporate request comes in asking for a report on thousands of customers, you don't have to wait for one person to do all the work. All 5 assistants work at the exact same time, each searching through their own 2 cabinets simultaneously.

By splitting the storage and the work, OpenSearch ensures your system stays lightning-fast, highly efficient, and easily scalable as your business grows.
