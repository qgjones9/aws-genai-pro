# Amazon S3 - Lifecycle Rules

## Lecture notes

### What this lecture covers

<a href="https://docs.aws.amazon.com/AmazonS3/latest/userguide/object-lifecycle-mgmt.html">S3 lifecycle configurations</a> automate **transitions** between storage classes and **expiration** of objects you no longer need. This lecture explains transition vs expiration actions, how to scope rules with **prefixes** and **tags**, two **exam-style design scenarios** (profile thumbnails and versioning retention), and how <a href="https://docs.aws.amazon.com/AmazonS3/latest/userguide/analytics-storage-class.html">S3 Storage Class Analysis</a> helps you pick the right transition day counts.

### Key definitions (from the lecture)

| Term | Definition |
|---|---|
| **Lifecycle configuration** | A set of **rules** on a bucket that automatically **transition** objects to another storage class or **expire** (delete) them after a defined period. |
| **Transition action** | Moves an object to a **lower-cost storage class** after N days since creation (e.g., Standard → Standard-IA after 60 days, or → Intelligent-Tiering after six months). |
| **Expiration action** | **Deletes** objects after a period—whole objects, **all versions** (with versioning), or **incomplete multipart uploads**. |
| **Prefix filter** | Limits a rule to objects under a **path** within the bucket (e.g., `thumbnails/` vs `source/`). |
| **Tag filter** | Limits a rule to objects carrying a specific **object tag** (e.g., `department=finance`). |
| **Non-current version** | In a **versioning-enabled** bucket, any version that is **not** the latest; lifecycle can tier or expire these separately from the current version. |
| **S3 Storage Class Analysis** | Analytics that produce a **daily CSV report** with access statistics and **transition recommendations** for Standard and Standard-IA. |

### Storage-class transition paths (lecture overview)

Lifecycle rules can move objects along cost-optimized paths. The lecture highlights routes such as:

```
S3 Standard
    ├──► Standard-IA ──► Intelligent-Tiering ──► One Zone-IA
    └──► Glacier Instant / Flexible Retrieval ──► Glacier Deep Archive
```

| Access pattern (lecture guidance) | Target class |
|---|---|
| Objects accessed **incrementally less** over time | **Standard-IA** (or Intelligent-Tiering when patterns are unknown) |
| Objects destined for **long-term archive** | **Glacier** tiers or **Glacier Deep Archive** |

See <a href="https://docs.aws.amazon.com/AmazonS3/latest/userguide/lifecycle-configuration-examples.html">Examples of S3 Lifecycle configurations</a> and the prior lecture on [Amazon S3 - Storage Classes](../44-amazon-s3-storage-classes/index.md).

### Transition actions vs expiration actions

| Action type | What it does | Lecture examples |
|---|---|---|
| **Transition** | Changes storage class after N days | Move to **Standard-IA** 60 days after creation; move to **Intelligent-Tiering** after six months |
| **Expiration** | Permanently removes objects | Delete **access logs** after 365 days; delete **all versions** when versioning is on; abort **incomplete multipart uploads** older than ~2 weeks |

**Multipart upload cleanup:** If a multipart upload never finished within a reasonable window (the lecture uses **two weeks**), an expiration rule can delete the orphaned parts so you are not billed for incomplete uploads.

See <a href="https://docs.aws.amazon.com/AmazonS3/latest/userguide/lifecycle-configuration-examples.html#lifecycle-config-conceptual-examples">Lifecycle configuration examples</a>.

### Scoping rules: bucket-wide, prefix, or tag

Rules can apply to:

1. **The entire bucket** — one policy for all objects.
2. **A prefix** — only objects under a path (e.g., `photos/thumbnails/`).
3. **Object tags** — only objects tagged a certain way (e.g., `department=finance`).

This scoping is how you implement **different lifecycles for different data** in the same bucket.

### Exam scenario 1: Profile photos and thumbnails

**Requirements (from the lecture):**

- An EC2 application generates **thumbnails** when users upload **profile photos** to S3.
- **Thumbnails** are easily **recreated** from the original and only need to be kept **60 days**.
- **Source images** must be **easily retrieved for 60 days**; after that, users can wait **up to six hours** for retrieval.

**Design:**

| Object set | Prefix example | Storage class | Lifecycle rule |
|---|---|---|---|
| **Source images** | `photos/source/` | **S3 Standard** (fast access for 60 days) | **Transition to Glacier** after 60 days — six-hour tolerance maps to **Glacier Flexible Retrieval** (Standard restore ~3–5 hours) |
| **Thumbnails** | `photos/thumbnails/` | **One Zone-IA** (infrequent, recreatable, cheaper) | **Expire (delete)** after **60 days** |

Use **different prefixes** so each path gets its own lifecycle rule.

```json
{
  "Rules": [
    {
      "ID": "SourceToGlacier",
      "Filter": { "Prefix": "photos/source/" },
      "Status": "Enabled",
      "Transitions": [{ "Days": 60, "StorageClass": "GLACIER" }]
    },
    {
      "ID": "ExpireThumbnails",
      "Filter": { "Prefix": "photos/thumbnails/" },
      "Status": "Enabled",
      "Expiration": { "Days": 60 }
    }
  ]
}
```

*(Illustrative structure—adjust storage class names to match your bucket’s supported transitions.)*

### Exam scenario 2: Versioning and tiered recovery SLAs

**Company policy (from the lecture):**

- **Deleted objects** must be recoverable **immediately** for **30 days** (deletions are rare but must be undoable fast).
- From **day 30 through day 365**, deleted objects must still be recoverable within **48 hours**.

**Design approach:**

1. **Enable <a href="https://docs.aws.amazon.com/AmazonS3/latest/userguide/Versioning.html">S3 Versioning</a>** so a delete creates a **delete marker** while prior versions remain recoverable.
2. Add lifecycle rules on **non-current versions**:
   - Transition non-current versions to an **archive tier** (lecture: “standard archive”) after the immediate-recovery window.
   - Transition those non-current versions to **Glacier Deep Archive** for long-term, lowest-cost retention — **Bulk** retrieval aligns with the **~48-hour** recovery SLA in the second window.

See <a href="https://docs.aws.amazon.com/AmazonS3/latest/userguide/Versioning.html#lifecycle">Using S3 Versioning with S3 Lifecycle</a> and <a href="https://docs.aws.amazon.com/AmazonS3/latest/userguide/lifecycle-configuration-examples.html#lifecycle-config-conceptual-examples">lifecycle rules for versioning-enabled buckets</a>.

### S3 Storage Class Analysis (picking transition days)

**Question:** How do you know the **optimal number of days** before transitioning Standard → Standard-IA (or refining existing rules)?

**Answer:** Run <a href="https://docs.aws.amazon.com/AmazonS3/latest/userguide/analytics-storage-class.html">S3 Storage Class Analysis</a> on the bucket.

| Aspect | Detail (lecture) |
|---|---|
| **Recommendations for** | **S3 Standard** and **S3 Standard-IA** only |
| **Does not analyze** | **One Zone-IA** or **Glacier** classes |
| **Output** | **CSV report** with statistics and transition recommendations |
| **Update cadence** | Report refreshes **daily** |
| **Time to first data** | Expect **24–48 hours** after enabling before analysis appears |

Use this as a **first step** to design lifecycle rules—or to **tune** rules you already have. See <a href="https://docs.aws.amazon.com/AmazonS3/latest/userguide/configure-analytics-storage-class.html">Configuring storage class analysis</a>.

### Examples

**Access-log retention**

Server access logs land in `logs/access/`. An expiration rule deletes them after **365 days**—no manual cleanup script required.

**Finance-only archival**

Objects tagged `department=finance` transition to Glacier after 90 days; objects tagged `department=engineering` stay on Standard until a separate rule applies.

**Abort stale multipart uploads**

Large model checkpoints uploaded via multipart API sometimes fail mid-stream. A rule expires incomplete uploads **older than 14 days** to stop paying for orphaned parts.

### Limitations / edge cases

- **Transition timing** is based on **object age** (days since creation or becoming non-current)—design rules to match **business SLAs**, not just cost.
- **Minimum storage durations** on IA and Glacier tiers can make **early deletion** more expensive than staying put—coordinate transitions with class minimums (covered in the storage-classes lecture).
- **Storage Class Analysis** only recommends transitions involving **Standard** and **Standard-IA**; Glacier and One Zone-IA paths require **manual** cost/SLA modeling.
- **One Zone-IA** is appropriate only when data is **recreatable** or a non-critical copy—do not use it for sole copies of irreplaceable source images unless the scenario explicitly allows it.
- **Versioning + lifecycle** interacts with **delete markers** and **non-current versions**—test recovery workflows before relying on them for compliance.

### Industry scenarios

**1. Gen-AI document corpus with derived previews**

A RAG pipeline stores full PDFs in `documents/source/` on **Standard** for fast re-embedding, while auto-generated page previews in `documents/previews/` sit on **One Zone-IA** and **expire after 90 days** because they can be regenerated from source files.

**2. Regulated healthcare chat retention**

A telehealth platform enables **versioning** on a transcripts bucket. Non-current versions transition to **Glacier** after 30 days and to **Deep Archive** after one year, matching “hot undo” vs “audit within 48 hours” policies while minimizing storage spend.

**3. ML training artifact lifecycle**

Daily feature-export dumps start in **Standard** for ETL. **Storage Class Analysis** recommends transitioning idle exports to **Standard-IA** after 45 days; a second rule moves artifacts older than one year to **Glacier Flexible Retrieval** when retraining jobs tolerate multi-hour restores.

### Key takeaways

- **Lifecycle rules** automate **transitions** (cheaper classes over time) and **expirations** (delete objects, versions, or stale multipart uploads).
- Scope rules with **prefixes** and **tags** to apply different policies within one bucket.
- **Exam pattern:** match **retrieval SLA** to storage class (Standard for immediate access; Glacier Flexible for hours; Deep Archive Bulk for ~48 hours).
- **Exam pattern:** put **recreatable, short-lived** data (thumbnails) on **One Zone-IA** with **expiration**; keep **source** data on **Standard**, then **transition** to archive tiers.
- Pair **versioning** with **non-current version transitions** when you need tiered recovery windows for deleted objects.
- Use **S3 Storage Class Analysis** (Standard / Standard-IA only) to data-drive transition day counts; allow **24–48 hours** for initial results.

### References

**In this repo**

- [Amazon S3 - Storage Classes](../44-amazon-s3-storage-classes/index.md) (class trade-offs and minimum durations)
- [Amazon S3 - Storage Classes - Hands On](../45-amazon-s3-storage-classes-hands-on/index.md)
- [Keeping your Vector Store Up to Date](../42-keeping-your-vector-store-up-to-date/index.md) (S3 events and ingestion pipelines)

**AWS documentation**

- <a href="https://docs.aws.amazon.com/AmazonS3/latest/userguide/object-lifecycle-mgmt.html">Managing the lifecycle of objects</a>
- <a href="https://docs.aws.amazon.com/AmazonS3/latest/userguide/lifecycle-configuration-examples.html">Examples of S3 Lifecycle configurations</a>
- <a href="https://docs.aws.amazon.com/AmazonS3/latest/userguide/Versioning.html">Retaining multiple versions of objects with S3 Versioning</a>
- <a href="https://docs.aws.amazon.com/AmazonS3/latest/userguide/analytics-storage-class.html">Amazon S3 analytics – Storage Class Analysis</a>
- <a href="https://docs.aws.amazon.com/AmazonS3/latest/userguide/configure-analytics-storage-class.html">Configuring storage class analysis</a>
- <a href="https://docs.aws.amazon.com/AmazonS3/latest/userguide/storage-class-intro.html">Understanding and managing Amazon S3 storage classes</a>
