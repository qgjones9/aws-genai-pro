# Amazon DynamoDB DAX

## Lecture notes

### What this lecture covers

<a href="https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/DAX.html">DynamoDB Accelerator (DAX)</a> is a fully managed, in-memory cache in front of DynamoDB. This lecture explains what DAX solves (especially the **hot key** problem), how the cluster fits into your architecture, default caching behavior, production sizing, security controls, and how DAX compares to <a href="https://docs.aws.amazon.com/AmazonElastiCache/latest/dg/WhatIs.html">Amazon ElastiCache</a>—a common exam distinction.

### Key definitions (from the lecture)

| Term | Definition |
|---|---|
| **DAX (DynamoDB Accelerator)** | A fully managed, highly available, seamless **in-memory cache** for DynamoDB that delivers **microsecond latency** for cached reads and queries. See <a href="https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/DAX.concepts.html">DAX: How it works</a>. |
| **Hot key problem** | One partition key or item is read so often that it exhausts <a href="https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/ProvisionedThroughput.html">read capacity units (RCU)</a> on that partition, causing throttling. DAX caches those reads so DynamoDB is hit less often. |
| **DAX cluster** | A set of **cache nodes** you **provision in advance**; the application talks to the cluster endpoint instead of DynamoDB directly for supported read APIs. |
| **Default item cache TTL** | **Five minutes**—cached data lives in the cluster for that duration by default (while still within TTL). See <a href="https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/DAX.concepts.html#DAX.concepts.item-cache">Item cache</a>. |
| **Simple queries (lecture term)** | Straightforward DynamoDB access patterns DAX handles well: **GetItem** (individual objects), **Query**, and **Scan** results. |

### The problem (why you need DAX)

- DynamoDB spreads load across **partitions**; capacity is divided per partition (see [Amazon DynamoDB - WCU & RCU](../34-amazon-dynamodb-wcu-and-rcu/index.md)).
- When one **specific key or item** is read repeatedly, that partition can hit its RCU limit → **`ProvisionedThroughputExceededException`** (throttling).
- This is the **hot key** / **hot partition** pattern—common for viral content, featured products, or global config rows.
- DAX sits in front of DynamoDB and serves repeated reads from memory, cutting RCU consumption and latency.

### The solution: DAX architecture

```
Application  →  DAX cluster (cache nodes)  →  DynamoDB table(s)
```

- You **create a DAX cluster** made of **cache nodes** (provisioned capacity, not serverless).
- The application **connects to the DAX cluster endpoint**; DAX **fetches from DynamoDB on cache miss** and returns cached data on hit.
- **No application logic rewrite** for supported APIs—DAX is **compatible with existing DynamoDB APIs** (point the client at the DAX endpoint).
- By default, popular reads are cached; entries remain while within the **5-minute TTL**.

### Cluster sizing and availability

| Aspect | Guidance (from the lecture) |
|---|---|
| **Max nodes** | Up to **10** nodes per cluster |
| **Production recommendation** | **Multi-AZ**: at least **3 nodes** (one per Availability Zone) |
| **Provisioning** | Nodes must be **provisioned in advance** (unlike on-demand DynamoDB table capacity) |

### Security

DAX is described as fully secure in the lecture, with:

| Control | Notes |
|---|---|
| **Encryption at rest** | See <a href="https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/DAXEncryptionAtRest.html">DAX encryption at rest</a> |
| **IAM authentication** | Access controlled via IAM policies |
| **VPC security** | Cluster runs in your VPC with security groups |
| **CloudTrail integration** | API activity can be logged for audit |

### DAX vs ElastiCache (key exam distinction)

Both can appear in the same architecture; the exam often tests **which cache fits which pattern**.

| | **DAX** | **ElastiCache** |
|---|---|---|
| **What it caches** | DynamoDB **items**, **Query**, and **Scan** results—"simple" read patterns | **Arbitrary application results** you choose to store (aggregations, filtered summaries, computed views) |
| **Integration** | Drop-in for DynamoDB APIs via DAX endpoint | Your app reads/writes cache keys explicitly (Redis/Memcached client) |
| **Best when** | Hot keys, repeated GetItem/Query/Scan on the same data | Client-side logic is expensive (e.g., Scan → sum → filter) and you want to skip redoing that work every request |
| **Together** | DAX caches DynamoDB reads; ElastiCache stores **post-processed** results so you don't re-query DAX and re-run heavy app logic |

**Lecture pattern:** Use DAX for repeated DynamoDB object/query/scan access. If your app performs **computationally expensive logic** on top of DynamoDB data, cache the **final result** in ElastiCache and read from there instead of re-querying DAX and re-processing on every request.

### How to apply it

Point your application at the **DAX cluster endpoint** using the <a href="https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/DAX.client.run-application-python.html">DAX Python client</a> (`pip install amazon-dax-client`). The API surface matches DynamoDB for supported operations—only the endpoint changes.

```python
import amazondax

dax_endpoint = "dax://my-cluster.xxxxx.dax-clusters.us-east-1.amazonaws.com"

with amazondax.AmazonDaxClient.resource(
    endpoint_url=dax_endpoint,
    region_name="us-east-1",
) as dax:
    table = dax.Table("Products")
    item = table.get_item(Key={"productId": "featured-001"})
```

The console walkthrough covers **creating a DAX cluster** in the AWS Management Console.

### Examples

**1. Hot product detail page**

A flash sale drives millions of **GetItem** calls for `productId = "deal-of-the-day"`. Without DAX, that partition key saturates RCU. With DAX, the first read populates cache; subsequent reads hit memory at microsecond latency until TTL expires.

**2. Repeated leaderboard Query**

A gaming app runs the same **Query** on `gameId = "global"` every few seconds for top scores. DAX caches the query result set, reducing repeated RCU charges for identical queries.

**3. DAX + ElastiCache together**

A dashboard **Scans** order items, then the app **sums revenue by region** and **filters** to the last 24 hours. That aggregation is expensive. Flow:

1. DAX may cache the raw Scan/Query from DynamoDB.
2. The app computes the summary once and stores `"dashboard:revenue:24h"` in **ElastiCache**.
3. Later requests read the summary from ElastiCache—no re-scan, no re-aggregation.

### Limitations / edge cases

- Cluster nodes must be **provisioned in advance**—you pay for the DAX cluster regardless of cache hit rate.
- Default **TTL is five minutes**; cached entries expire and must be refetched from DynamoDB.
- **ElastiCache** is for **application-level** result caching; DAX is **DynamoDB-native** for items, queries, and scans—not a substitute for caching arbitrary computed results (use both when needed).

### Industry scenarios

**1. Retail — viral SKU**

A retailer’s “doorbuster” SKU gets hammered at launch. Product metadata lives in DynamoDB; DAX caches the hot **GetItem** so the product page stays fast and RCU throttling on one partition is avoided.

**2. Media — trending article metadata**

A news site stores article metadata in DynamoDB. When a story trends, the same partition key is read constantly. DAX absorbs the read storm; editors still write updates to DynamoDB as usual.

**3. Fintech — pre-aggregated risk dashboard**

Risk analysts need a view built from DynamoDB orders plus **client-side aggregation** (totals, filters). The team uses DAX for repeated base queries and **ElastiCache** for the computed dashboard payload, refreshing ElastiCache on a schedule or after batch jobs.

### Key takeaways

- **DAX** = managed in-memory cache for DynamoDB; **microsecond** cached reads; **no app rewrite** for supported DynamoDB APIs.
- Primary win: **hot key / hot partition** reads that would otherwise throttle **RCU**.
- App → **DAX cluster** → DynamoDB; nodes are **provisioned** (up to **10**); **3+ nodes across AZs** recommended for production.
- Default cache **TTL: 5 minutes**.
- **DAX** caches items, queries, and scans; **ElastiCache** caches **application-computed results**—they can be **combined**.
- Security: encryption at rest, IAM, VPC, CloudTrail.

### References

**In this repo**

- [Amazon DynamoDB](../32-amazon-dynamodb/index.md)
- [Amazon DynamoDB - WCU & RCU](../34-amazon-dynamodb-wcu-and-rcu/index.md)
- [Amazon DynamoDB - Basic APIs](../36-amazon-dynamodb-basic-apis/index.md)

**AWS documentation**

- <a href="https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/DAX.html">In-memory acceleration with DynamoDB Accelerator (DAX)</a>
- <a href="https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/DAX.concepts.html">DAX: How it works</a>
- <a href="https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/DAX.consistency.html">DAX and DynamoDB consistency models</a>
- <a href="https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/DAXEncryptionAtRest.html">DAX encryption at rest</a>
- <a href="https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/dax-prescriptive-guidance.html">Prescriptive guidance to integrate DAX with DynamoDB applications</a>
- <a href="https://docs.aws.amazon.com/AmazonElastiCache/latest/dg/WhatIs.html">What is Amazon ElastiCache?</a>
