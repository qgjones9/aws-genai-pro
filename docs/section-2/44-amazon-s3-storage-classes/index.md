# Amazon S3 - Storage Classes

## Lecture notes

### What this lecture covers

<a href="https://docs.aws.amazon.com/AmazonS3/latest/userguide/storage-class-intro.html">Amazon S3 storage classes</a> trade off **cost**, **availability**, **retrieval speed**, and **minimum storage duration**. This lecture walks through every major class—Standard, Infrequent Access, One Zone-IA, the three Glacier tiers, and <a href="https://docs.aws.amazon.com/AmazonS3/latest/userguide/intelligent-tiering-overview.html">S3 Intelligent-Tiering</a>—and explains **durability vs availability**, how you **choose or change** a class, and how <a href="https://docs.aws.amazon.com/AmazonS3/latest/userguide/object-lifecycle-mgmt.html">lifecycle configurations</a> automate transitions between them.

### Key definitions (from the lecture)

| Term | Definition |
|---|---|
| **Storage class** | The S3 tier assigned to an object that determines **pricing**, **availability**, **retrieval behavior**, and **minimum storage duration**. |
| **Durability** | How resistant stored objects are to **loss** over time. All S3 storage classes share the same high durability (**11 nines**, 99.999999999%). |
| **Availability** | How **readily** you can access the service. **Varies by storage class**—lower-cost tiers generally have lower availability SLAs. |
| **Retrieval cost** | A per-request charge when you read data from **IA** and **Glacier** classes (not charged in Intelligent-Tiering per the lecture). |
| **Minimum storage duration** | Some classes bill for at least a fixed number of days even if you delete early (e.g., **90 days** for several Glacier tiers, **180 days** for Deep Archive). |

### Durability vs availability

| Concept | What it measures | Lecture highlights |
|---|---|---|
| **Durability** | Risk of **losing** an object permanently | **11 nines** across **all** storage classes—on average, storing **10 million** objects you might lose **one** object once every **10,000 years**. |
| **Availability** | Risk of **temporary** access errors / downtime | Depends on class. **S3 Standard** ≈ **99.99%** (~**53 minutes** of unavailability per year). Design apps to tolerate occasional S3 errors. |

Durability is about **data surviving**; availability is about **data being reachable right now**.

### How you set or change a storage class

When you create an object in S3 you can:

1. **Choose the class at upload** (Standard is the default).
2. **Modify the storage class manually** on existing objects.
3. **Automate transitions** with <a href="https://docs.aws.amazon.com/AmazonS3/latest/userguide/object-lifecycle-mgmt.html">S3 lifecycle configurations</a>—move objects between any of these classes on a schedule or after a period of time.

See <a href="https://docs.aws.amazon.com/AmazonS3/latest/userguide/sc-howtoset.html">Setting the storage class of an object</a>.

### Storage classes at a glance

| Storage class | Access pattern | Availability (lecture) | Retrieval | Minimum duration | Typical use cases |
|---|---|---|---|---|---|
| **S3 Standard** | Frequent | 99.99% | Milliseconds | — | Big data analytics, mobile/gaming assets, content distribution |
| **S3 Standard-IA** | Infrequent, rapid when needed | 99.9% | Milliseconds + **retrieval fee** | — | Disaster recovery, backups |
| **S3 One Zone-IA** | Infrequent; **single AZ** | 99.5% | Milliseconds + retrieval fee | — | Secondary backup copies, **recreatable** data |
| **S3 Glacier Instant Retrieval** | Archive, ~quarterly access | — | **Milliseconds** | **90 days** | Backups you may need instantly |
| **S3 Glacier Flexible Retrieval** | Archive, flexible wait | — | **Expedited** 1–5 min · **Standard** 3–5 hr · **Bulk** (free) 5–12 hr | **90 days** | Archives where hours-long restore is OK |
| **S3 Glacier Deep Archive** | Long-term cold archive | — | **Standard** ~12 hr · **Bulk** ~48 hr | **180 days** | Lowest-cost multi-year retention |
| **S3 Intelligent-Tiering** | **Unknown/changing** access | Automatic tiers | No retrieval charges (lecture) | Monitoring fee | “Set and forget” cost optimization |

### S3 Standard (General Purpose)

- Default class for **frequently accessed** data.
- **Low latency** and **high throughput**.
- Designed to sustain **two concurrent facility failures** on the AWS side.
- **99.99% availability**—plan for ~53 minutes/year when requests may fail.

### S3 Infrequent Access (Standard-IA)

- For data accessed **less often** but that still needs **rapid access** when requested.
- **Lower storage cost** than Standard, with a **retrieval charge**.
- **99.9% availability** (slightly lower than Standard).
- Common for **disaster recovery** and **backup** workloads where you hope not to read often but must read quickly when you do.

### S3 One Zone-IA

- Stores data in **one Availability Zone** only (not replicated across multiple AZs like Standard/Standard-IA).
- Still **high durability within that AZ**, but data is **lost if the AZ is destroyed**.
- **99.5% availability**—lowest among the “hot/warm” tiers covered here.
- Best for **secondary backup copies** or data you can **rebuild** from elsewhere.

### Glacier storage classes (archiving)

Glacier tiers are **low-cost object storage** for **archiving and backup**. You pay for **storage plus retrieval** (except Bulk retrieval modes called out as free in the lecture for Flexible Retrieval).

See <a href="https://docs.aws.amazon.com/AmazonS3/latest/userguide/glacier-storage-classes.html">Understanding S3 Glacier storage classes</a>.

#### S3 Glacier Instant Retrieval

- **Millisecond** retrieval—archive pricing with near-Standard speed.
- Good for data accessed about **once per quarter**.
- **Minimum storage duration: 90 days**.

#### S3 Glacier Flexible Retrieval (formerly “Amazon S3 Glacier”)

Three retrieval options:

| Mode | Retrieval time | Cost note (lecture) |
|---|---|---|
| **Expedited** | 1–5 minutes | Fastest paid option |
| **Standard** | 3–5 hours | Middle ground |
| **Bulk** | 5–12 hours | **Free** retrieval |

- **Minimum storage duration: 90 days**.
- **Instant** = retrieve immediately; **Flexible** = willing to wait up to ~12 hours.

#### S3 Glacier Deep Archive

- **Lowest-cost** long-term archive tier.
- **Standard** retrieval ~**12 hours**; **Bulk** ~**48 hours**.
- **Minimum storage duration: 180 days**.

### S3 Intelligent-Tiering

Automatically **moves objects between access tiers** based on usage so you do not have to manage transitions yourself.

| Access tier | When objects move (lecture) | Notes |
|---|---|---|
| **Frequent Access** | Default tier for active objects | Automatic |
| **Infrequent Access** | Not accessed for ~**30 days** | Automatic |
| **Archive Instant Access** | Not accessed for ~**90 days** | Automatic |
| **Archive Access** | Optional; configurable from **90 days** to **730+ days** | Must enable |
| **Deep Archive Access** | Optional; configurable from **180 days** to **730+ days** | Must enable |

- **Small monthly monitoring fee** plus **auto-tiering fee**.
- **No retrieval charges** (per the lecture)—designed so you can “sit back and relax” while S3 optimizes cost.

See <a href="https://docs.aws.amazon.com/AmazonS3/latest/userguide/using-intelligent-tiering.html">Using S3 Intelligent-Tiering</a>.

### Comparing classes (exam mindset)

The lecture shows a comparison diagram and sample **US East (N. Virginia)** pricing:

- You do **not** need to memorize every number for the exam.
- **Do** understand how **names map to behavior**: frequent vs infrequent vs archive, single-AZ vs multi-AZ, instant vs flexible vs deep retrieval.
- **Durability stays at 11 nines** for standard S3 classes; **effective durability drops** when data lives in **one AZ** (One Zone-IA).
- Watch **minimum storage duration**—deleting early can still bill the full minimum period.

### How to apply it

#### Upload with a specific storage class

```python
import boto3

s3 = boto3.client("s3")

# Frequently served RAG source documents
s3.upload_file(
    "policies/employee-handbook.pdf",
    "corp-documents",
    "policies/employee-handbook.pdf",
    ExtraArgs={"StorageClass": "STANDARD"},
)

# Monthly backup snapshot — cheaper storage, pay when you restore
s3.upload_file(
    "backups/vector-index-2025-05.tar.gz",
    "ml-backups",
    "vector-index/2025-05.tar.gz",
    ExtraArgs={"StorageClass": "STANDARD_IA"},
)

# Long-term compliance archive — lowest cost, slow restore
s3.upload_file(
    "audit/chat-logs-2020.zip",
    "compliance-archive",
    "chat-logs/2020.zip",
    ExtraArgs={"StorageClass": "DEEP_ARCHIVE"},
)
```

#### Change class on an existing object (copy-in-place pattern)

```python
s3.copy_object(
    Bucket="corp-documents",
    Key="legacy/report-2019.pdf",
    CopySource={"Bucket": "corp-documents", "Key": "legacy/report-2019.pdf"},
    StorageClass="GLACIER_IR",
    MetadataDirective="COPY",
)
```

For production pipelines, prefer **lifecycle rules** (covered in the next lecture) to transition objects automatically after N days.

### Examples

**1. Tiering a document lake for RAG**

New PDFs land in **Standard** while embeddings are built. After 60 days with no re-ingestion, lifecycle rules move originals to **Standard-IA**; after a year with no access, to **Glacier Instant Retrieval** for cheap retention but millisecond restore if legal needs a copy.

**2. Choosing One Zone-IA for reproducible ML artifacts**

A team stores **regenerable** intermediate training shards (rebuildable from raw data in Standard) as **One Zone-IA** secondary copies—accepting AZ-level risk for ~40% storage savings on non-critical duplicates.

**3. Intelligent-Tiering for unpredictable research datasets**

A gen-AI lab uploads mixed datasets with **unknown** access patterns. **Intelligent-Tiering** keeps hot sets in Frequent Access while idle experiment outputs drift to Infrequent or Archive tiers without operators tuning rules per prefix.

### Limitations / edge cases

- **One Zone-IA** is unsuitable for sole copies of irreplaceable data—an AZ loss means data loss.
- **IA and Glacier classes** charge **retrieval fees**; frequent reads can erase storage savings (Intelligent-Tiering avoids retrieval fees per the lecture but adds monitoring cost).
- **Minimum storage durations** (90 or 180 days on Glacier tiers) penalize early deletion.
- **Availability SLAs differ**—mission-critical hot paths should stay on **Standard**, not archive tiers.
- **Exam focus**: know **class names, access patterns, and trade-offs**; treat exact pricing and SLA decimals as reference material, not flashcard facts.

### Industry scenarios

**1. Media company content CDN origin**

Game textures and video mezzanine files served globally sit in **S3 Standard** behind CloudFront for low latency. Older season assets move to **Standard-IA** after release cycles end—still restorable quickly for anniversary events.

**2. Healthcare gen-AI compliance archive**

De-identified chat transcripts must be kept **7+ years** but are rarely read. **Glacier Deep Archive** minimizes cost; legal holds use **Bulk** retrieval when audits allow 48-hour turnaround.

**3. Financial services model-training data lake**

Daily feature stores stay in **Standard** for ETL. Nightly snapshot exports transition via lifecycle to **Glacier Flexible Retrieval** after 90 days; **Intelligent-Tiering** covers ad-hoc research buckets where quants cannot predict access frequency.

### Key takeaways

- S3 offers **many storage classes**—know them for the exam: Standard, Standard-IA, One Zone-IA, Glacier Instant/Flexible/Deep Archive, and Intelligent-Tiering.
- **Durability (11 nines)** is the same across classes; **availability, cost, retrieval speed, and minimum duration** differ.
- Pick **Standard** for hot data; **IA** for backups/DR; **One Zone-IA** only when you can tolerate **AZ loss** or can recreate data.
- **Glacier** tiers optimize **archive cost**—Instant for ms access, Flexible for hours, Deep Archive for lowest-cost years-long retention.
- **Intelligent-Tiering** automates tier movement for **unknown access patterns** with monitoring fees but **no retrieval charges** (lecture).
- Set class at **upload**, change **manually**, or automate with **lifecycle rules** (next lecture).

### References

**In this repo**

- [Keeping your Vector Store Up to Date](../42-keeping-your-vector-store-up-to-date/index.md) (S3 events driving ingestion pipelines)
- [Amazon S3 Vectors](../24-amazon-s3-vectors/index.md) (vector storage on S3)
- [Amazon S3 - Lifecycle Rules](../46-amazon-s3-lifecycle-rules/index.md) (automated transitions between classes)
- [Amazon S3 - Storage Classes - Hands On](../45-amazon-s3-storage-classes-hands-on/index.md)

**AWS documentation**

- <a href="https://docs.aws.amazon.com/AmazonS3/latest/userguide/storage-class-intro.html">Understanding and managing Amazon S3 storage classes</a>
- <a href="https://docs.aws.amazon.com/AmazonS3/latest/userguide/sc-howtoset.html">Setting the storage class of an object</a>
- <a href="https://docs.aws.amazon.com/AmazonS3/latest/userguide/glacier-storage-classes.html">Understanding S3 Glacier storage classes</a>
- <a href="https://docs.aws.amazon.com/AmazonS3/latest/userguide/intelligent-tiering-overview.html">How S3 Intelligent-Tiering works</a>
- <a href="https://docs.aws.amazon.com/AmazonS3/latest/userguide/using-intelligent-tiering.html">Using S3 Intelligent-Tiering</a>
- <a href="https://docs.aws.amazon.com/AmazonS3/latest/userguide/object-lifecycle-mgmt.html">Managing the lifecycle of objects</a>
