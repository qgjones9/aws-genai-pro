# About DSSE-KMS

!!! example "Next hands-on"
    You may see **DSSE-KMS** (dual-layer SSE with KMS) in the upcoming S3 encryption lab—**two AES-256 layers** vs one for SSE-KMS. The course treats it as awareness unless the exam blueprint adds it.

## Lecture notes

### What this lecture covers

This short note flags an encryption option you will see in the **next hands-on** lecture: **DSSE-KMS** (dual-layer server-side encryption with AWS KMS keys), released in **June 2023**. The instructor describes it in one line—**double encryption based on KMS**—and explains why the main course does **not** go deeper unless it shows up on the certification exam.

### Key definitions (from the lecture)

| Term | Definition |
|---|---|
| **DSSE-KMS** | **Dual-layer server-side encryption with AWS KMS keys**—instructor shorthand: **"double encryption based on KMS."** |
| **Release (lecture)** | Available from **June 2023**; you may notice it as a new choice in the S3 console or API during the hands-on. |

See <a href="https://docs.aws.amazon.com/AmazonS3/latest/userguide/UsingDSSEncryption.html">Using dual-layer server-side encryption with AWS KMS keys (DSSE-KMS)</a> for the full AWS definition.

### DSSE-KMS vs SSE-KMS (what "double" means)

The lecture keeps the explanation minimal; AWS documentation expands it this way:

| Item | Notes |
|---|---|
| **SSE-KMS** | One layer of encryption using a data key from **AWS KMS**—the model covered in [S3 Encryption](../52-s3-encryption/index.md). |
| **DSSE-KMS** | **Two independent AES-256 layers**: first with a KMS-generated data encryption key, then again with a separate AES-256 key managed by **Amazon S3**. |
| **Why it exists** | Helps meet **multilayer encryption** requirements in regulated environments; stronger defense-in-depth than single-layer SSE-KMS. |
| **Trade-offs (AWS docs)** | **Higher latency**, **more KMS API usage**, and **higher cost** than SSE-KMS; **S3 Bucket Keys are not supported** for DSSE-KMS. |

Request header when explicitly specifying DSSE-KMS on upload:

`x-amz-server-side-encryption: aws:kms:dsse`

### Where you will see it

- **Next lecture (hands-on):** When configuring object or bucket encryption in the S3 console, look for **Dual-layer server-side encryption with AWS KMS keys (DSSE-KMS)** alongside SSE-S3 and SSE-KMS.
- **Course scope:** The instructor **does not teach DSSE-KMS in depth** while it is **not on the exam**. Treat this page as orientation so the extra menu option is not a surprise—not as a full replacement for the SSE-S3 / SSE-KMS material you already studied.

### How to apply it (when you need it)

**Console (hands-on preview):** On upload or when editing server-side encryption for an object, choose **Dual-layer server-side encryption with AWS KMS keys (DSSE-KMS)** and pick a KMS key in the **same Region** as the bucket.

**CLI example (AWS documentation pattern):**

```bash
aws s3 cp sensitive-contract.pdf s3://compliance-archive-prod/legal/ \
  --server-side-encryption aws:kms:dsse \
  --ssekms-key-id arn:aws:kms:us-east-1:111122223333:key/abcd1234-5678-90ab-cdef-EXAMPLE11111
```

**Bucket policy (require DSSE-KMS on all uploads):** Deny `s3:PutObject` unless `s3:x-amz-server-side-encryption` equals `aws:kms:dsse`. See <a href="https://docs.aws.amazon.com/AmazonS3/latest/userguide/UsingDSSEncryption.html">Using DSSE-KMS</a> for a sample policy.

### Examples

**Hands-on surprise:** You enable default bucket encryption with SSE-KMS, then upload an object and open **Edit server-side encryption**—DSSE-KMS appears as a third server-side option even though the lecture series focused on the classic four methods (SSE-S3, SSE-KMS, SSE-C, client-side).

**Compliance-driven archive:** A team must store audit logs with **two encryption layers** and **customer-managed KMS keys**. They choose DSSE-KMS on a dedicated prefix instead of stacking client-side encryption on top of SSE-KMS.

**Exam vs console:** You can configure DSSE-KMS in the real AWS console today, but this course assumes **SSE-S3 and SSE-KMS** are what you need for the test until someone reports DSSE-KMS on an actual exam question.

### Course material and certification exams

- **This course skips deep DSSE-KMS coverage** as long as the certification exam does not test it.
- **If you see DSSE-KMS as an answer choice on your exam**, tell the instructor so the course can be updated.
- **Exams lag new features**—June 2023 launches may take months to appear in question banks; the hands-on UI can be ahead of the test blueprint.

### Industry scenarios

| Scenario | How DSSE-KMS fits |
|---|---|
| **Healthcare records archive** | A HIPAA-aligned provider stores imaging metadata and consent PDFs in S3. Legal asks for **multilayer encryption at rest** with **KMS key control and CloudTrail audit**—DSSE-KMS satisfies the multilayer requirement without pushing all crypto to the client. |
| **Financial regulatory evidence** | A bank's compliance team retains trade surveillance exports for seven years. Internal policy mirrors external rules that mandate **two independent encryption layers** on sensitive objects; DSSE-KMS is selected for that bucket prefix instead of single-layer SSE-KMS. |
| **Government / defense subcontractor** | A contractor stores export-controlled engineering artifacts. The customer's security addendum requires **KMS CMKs plus multilayer server-side encryption**; DSSE-KMS maps directly to that contract language while staying within standard S3 APIs. |

### Key takeaways

- **DSSE-KMS** = **dual-layer (double) KMS-based server-side encryption**, available since **June 2023**.
- You will likely **spot it in the next hands-on** even though the lecture track focuses on **SSE-S3, SSE-KMS, SSE-C, and client-side encryption**.
- **Two AES-256 layers** (KMS DEK, then an S3-managed layer) vs **one layer** for SSE-KMS—stronger compliance story, **higher cost and latency**.
- **Not exam-focused in this course** until someone confirms it on a real test—still know **what it is** so the console option makes sense.
- For day-to-day architectures, default to **SSE-S3 or SSE-KMS** unless policy explicitly requires **multilayer** server-side encryption.

### References

**In this repo**

- [S3 Encryption](../52-s3-encryption/index.md) (SSE-S3, SSE-KMS, SSE-C, client-side—main course coverage)
- [S3 Default Encryption](../55-s3-default-encryption/index.md) (bucket default encryption settings)

**AWS documentation**

- <a href="https://docs.aws.amazon.com/AmazonS3/latest/userguide/UsingDSSEncryption.html">Using dual-layer server-side encryption with AWS KMS keys (DSSE-KMS)</a>
- <a href="https://docs.aws.amazon.com/AmazonS3/latest/userguide/specifying-dsse-encryption.html">Specifying DSSE-KMS</a>
- <a href="https://docs.aws.amazon.com/AmazonS3/latest/userguide/serv-side-encryption.html">Protecting data with server-side encryption</a>
- <a href="https://docs.aws.amazon.com/AmazonS3/latest/userguide/UsingKMSEncryption.html">Using SSE-KMS</a>
