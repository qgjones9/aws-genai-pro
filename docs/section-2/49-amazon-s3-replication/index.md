# Amazon S3 - Replication

## Lecture notes

### What this lecture covers

<a href="https://docs.aws.amazon.com/AmazonS3/latest/userguide/replication.html">Amazon S3 replication</a> automatically copies objects between S3 buckets **asynchronously** in the background. This lecture introduces the two live-replication types—**Cross-Region Replication (CRR)** and **Same-Region Replication (SRR)**—the **versioning** and **IAM** prerequisites, support for **cross-account** setups, and common **use cases** for compliance, latency, log aggregation, and production-to-test data flows.

### Key definitions (from the lecture)

| Term | Definition |
|---|---|
| **S3 replication** | Automatic, **asynchronous** copying of objects from a **source bucket** to one or more **destination buckets**. |
| **Cross-Region Replication (CRR)** | Replicates objects to a destination bucket in a **different AWS Region** than the source. |
| **Same-Region Replication (SRR)** | Replicates objects to a destination bucket in the **same AWS Region** as the source. |
| **Source bucket** | The bucket where new and updated objects are written first; replication rules are configured here. |
| **Destination bucket** | The target bucket that receives replicated object copies. |
| **Live replication** | Ongoing replication of **new and updated** objects after a replication rule is enabled (the lecture’s focus). |

See <a href="https://docs.aws.amazon.com/AmazonS3/latest/userguide/replication-what-is-isnot-replicated.html">What does Amazon S3 replicate?</a> for scope details beyond this intro lecture.

### CRR vs SRR

| Item | Notes |
|---|---|
| **CRR** | Source and destination are in **different Regions**. Fits **compliance** (geo-separated copies), **lower latency** for users near the replica Region, and **cross-account** data sharing. |
| **SRR** | Source and destination are in the **same Region**. Fits **log aggregation** into one bucket and **live replication** from production to test accounts in the same Region. |

```mermaid
flowchart TD
    A[Source bucket<br/>(versioning ON)]
    A -- "async copy (background)" --> B1[CRR destination<br/>(different Region)<br/>versioning ON]
    A -- "async copy (background)" --> B2[SRR destination<br/>(same Region)<br/>versioning ON]
```


### The problem (why you need it)

- A single bucket in one Region does not by itself give you **geo-separated copies**, **regional read proximity**, or a **separate account/environment** with the same object data.
- Teams often need **continuous, hands-off copying**—not one-off sync jobs—for compliance, DR posture, analytics aggregation, or test data that tracks production.

### Prerequisites and how replication works

Replication is **not** instant synchronous mirroring; S3 copies objects **behind the scenes** after they land in the source bucket.

**Requirements called out in the lecture:**

1. Enable <a href="https://docs.aws.amazon.com/AmazonS3/latest/userguide/Versioning.html">S3 Versioning</a> on **both** the **source** and **destination** buckets.
2. Grant **IAM permissions** so the S3 replication mechanism can **read** from the source bucket and **write** to the destination bucket(s). See <a href="https://docs.aws.amazon.com/AmazonS3/latest/userguide/setting-repl-config-perm-overview.html">Setting up permissions for live replication</a>.
3. Buckets may live in the **same AWS account** or in **different accounts**; cross-account replication adds destination **bucket policy** grants on top of the replication role.

```json
{
  "Role": "arn:aws:iam::111122223333:role/s3-replication-role",
  "Rules": [
    {
      "ID": "ReplicateGenAiCorpus",
      "Status": "Enabled",
      "Priority": 1,
      "Filter": { "Prefix": "embeddings/source/" },
      "Destination": {
        "Bucket": "arn:aws:s3:::genai-corpus-replica-eu-west-1",
        "StorageClass": "STANDARD"
      }
    }
  ]
}
```

The JSON illustrates the idea from the lecture: a **replication configuration** on the source bucket points at a **destination bucket ARN**, backed by an **IAM role** S3 assumes to perform reads and writes. Filter by **prefix** when only part of the bucket should replicate (not covered in depth in this lecture, but common in practice).

### Use cases (from the lecture)

| Replication type | Use case | Why it fits |
|---|---|---|
| **CRR** | **Compliance** | Keep object copies in a **distant Region** beyond default multi-AZ durability within one Region. |
| **CRR** | **Lower latency access** | Serve or process data **closer to users or workloads** in another Region. |
| **CRR** | **Cross-account replication** | Share or isolate data across **different AWS accounts** while copying automatically. |
| **SRR** | **Log aggregation** | Consolidate logs from **many buckets** into **one in-Region bucket** for analysis. |
| **SRR** | **Production → test replication** | Maintain a **live test environment** in a separate account with data that tracks production objects. |

### Examples

**CRR for a global Gen-AI API**

An inference service stores prompt/response artifacts in `us-east-1`. A **CRR** rule copies `inference-logs/` to `eu-west-1` so European compliance reviews and regional analytics jobs read from a nearby bucket instead of cross-Atlantic `GET`s on every query.

**SRR for centralized application logging**

Twelve microservice buckets write ALB and app logs under `logs/`. **SRR** replicates each prefix into `central-security-logs` in the same Region so the SIEM pipeline has **one bucket** to scan.

**Cross-account prod → test with SRR**

Production account bucket `prod-rag-documents` replicates to `test-rag-documents` in the **same Region** under a separate account. QA runs embedding pipeline changes against **current-shaped data** without manual export jobs.

### Limitations / edge cases (lecture scope)

- Replication is **asynchronous**—readers of the destination bucket should not assume **immediate** consistency after a write to the source.
- **Versioning must be on** at both ends before live replication can work as described.
- **IAM (and cross-account bucket policies)** must explicitly authorize S3 to replicate; missing permissions are a common setup failure.
- This intro lecture does **not** cover **Batch Replication** for backfilling objects that existed **before** the rule, **bi-directional** rules, or **S3 Replication Time Control (RTC)**—those appear in follow-on material and AWS docs.

### Industry scenarios

**1. Regulated financial model artifacts (CRR + cross-account)**

A bank trains credit-risk models in a **production data account** (`us-east-1`). **CRR** copies approved model bundles and feature snapshots to a **compliance archive account** in `eu-central-1`, satisfying “data resident in EU” audit requirements while keeping the training pipeline in the US.

**2. Multi-tenant SaaS log lake (SRR aggregation)**

A B2B platform stores per-tenant request logs in separate buckets for isolation. **SRR** streams all `tenant-*/access/` prefixes into one **in-Region** analytics bucket consumed by OpenSearch ingestion—matching the lecture’s “aggregate logs across multiple buckets” pattern.

**3. Gen-AI staging environment (SRR prod → test)**

A team runs RAG experiments in a **test account** that must see the same document corpus as production. **SRR** from `prod-knowledge-base` to `test-knowledge-base` (same Region, different account) keeps the vector-ingestion pipeline fed without nightly manual sync scripts.

### Key takeaways

- S3 replication has two live types: **CRR** (different Regions) and **SRR** (same Region).
- Copying is **asynchronous**—S3 replicates objects in the **background** after writes to the source bucket.
- Enable **versioning on source and destination** before replication works.
- Configure **IAM permissions** (and **destination bucket policies** for cross-account) so S3 can read source objects and write replicas.
- **CRR** use cases: **compliance**, **regional latency**, **cross-account** copies.
- **SRR** use cases: **log aggregation** and **live prod → test** replication within a Region.

### References

**In this repo**

- [Amazon S3 - Lifecycle Rules](../46-amazon-s3-lifecycle-rules/index.md) (versioning, transitions, and expiration on replicated buckets)
- [Amazon S3 - Storage Classes](../44-amazon-s3-storage-classes/index.md) (destination storage class choices)
- [A note about S3 regional namespaces](../48-a-note-about-s3-regional-namespaces/index.md) (bucket naming when creating source/destination buckets)
- [Amazon S3 - Replication - Notes](../50-amazon-s3-replication-notes/index.md) (follow-on edge cases)
- [Amazon S3 - Replication - Hands On](../51-amazon-s3-replication-hands-on/index.md) (practice)

**AWS documentation**

- <a href="https://docs.aws.amazon.com/AmazonS3/latest/userguide/replication.html">Replicating objects within and across Regions</a>
- <a href="https://docs.aws.amazon.com/AmazonS3/latest/userguide/replication-requirements.html">Requirements and considerations for replication</a>
- <a href="https://docs.aws.amazon.com/AmazonS3/latest/userguide/setting-repl-config-perm-overview.html">Setting up permissions for live replication</a>
- <a href="https://docs.aws.amazon.com/AmazonS3/latest/userguide/replication-how-setup.html">Setting up live replication overview</a>
- <a href="https://docs.aws.amazon.com/AmazonS3/latest/userguide/Versioning.html">Retaining multiple versions of objects with S3 Versioning</a>
