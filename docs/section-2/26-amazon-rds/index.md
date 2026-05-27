# Amazon RDS

## Lecture notes

### What this lecture covers

<a href="https://docs.aws.amazon.com/AmazonRDS/latest/gettingstartedguide/what-is-rds.html">Amazon RDS</a> is AWS’s managed relational database service. This lecture introduces supported database engines, why RDS beats self-managed databases on EC2, core managed-service benefits (backups, monitoring, scaling, Multi-AZ, read replicas), the trade-off of no SSH access, and **RDS storage autoscaling**—a feature called out as exam-relevant.

### Key definitions (from the lecture)

| Term | Definition |
|---|---|
| **Amazon RDS** | A managed cloud service for creating and running relational databases; AWS handles much of the operational work so you focus on the data and application. |
| **Managed service** | AWS provisions, patches, backs up, and monitors the database platform—you do not administer the underlying OS or EC2 instance directly. |
| **Point-in-time restore (PITR)** | Restore a database to a specific timestamp using continuous backups and transaction logs. |
| **Read replica** | A read-only copy of the primary DB used to offload read traffic and improve read performance (covered in a dedicated lecture in this course). |
| **Multi-AZ** | A high-availability deployment pattern for disaster recovery; RDS maintains a standby in another Availability Zone (covered in later sections). |
| **Vertical scaling** | Increase capacity by changing the DB instance class (more CPU/RAM). |
| **Horizontal scaling (reads)** | Add read replicas to spread read load across additional instances. |
| **RDS storage autoscaling** | Automatically increases allocated storage when free space runs low, up to a maximum threshold you configure. |
| **Amazon Aurora** | AWS’s proprietary RDS-compatible database engine; studied in depth in a later lecture. |

### Supported database engines

Remember these engines for the exam—they are all managed by Amazon RDS:

| Engine | Notes (from the lecture) |
|---|---|
| **PostgreSQL** | Common open-source relational engine on RDS. |
| **MySQL** | Widely used open-source engine. |
| **MariaDB** | MySQL-compatible fork. |
| **Oracle** | Commercial enterprise database. |
| **Microsoft SQL Server** | Microsoft’s relational engine on RDS. |
| **IBM Db2** | IBM’s relational engine (lecture: “IBM DB2”). |
| **Amazon Aurora** | AWS proprietary engine; covered in depth later in the course. |

See <a href="https://docs.aws.amazon.com/AmazonRDS/latest/gettingstartedguide/choosing-engine.html">Choosing your database engine for Amazon RDS</a>.

### RDS vs self-managed database on EC2

You *can* install PostgreSQL, MySQL, or another engine on an EC2 instance yourself. RDS is the managed alternative:

| Approach | Trade-off |
|---|---|
| **RDS (managed)** | Less operational burden: automated provisioning, patching, backups, monitoring, scaling options, and maintenance windows—but **no SSH** to the underlying instance. |
| **EC2 (self-managed)** | Full OS/instance control (including SSH), but you must build and operate provisioning, patching, backups, monitoring, and scaling yourself. |

The lecture’s framing: the managed extras usually outweigh losing direct instance access.

### Managed-service benefits

| Capability | What RDS gives you |
|---|---|
| **Automated provisioning** | Spin up a DB instance without manual server setup. |
| **OS patching** | AWS patches the underlying operating system. |
| **Continuous backups** | Automated backup workflow with restore options. |
| **Point-in-time restore** | Roll back to a specific timestamp after mistakes or corruption. See <a href="https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_PIT.html">Restoring a DB instance to a specified time</a>. |
| **Monitoring dashboards** | View database performance (CloudWatch and related RDS monitoring). See <a href="https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Overview.LoggingAndMonitoring.html">Logging and monitoring in Amazon RDS</a>. |
| **Read replicas** | Improve read performance by routing read traffic to replicas. See <a href="https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_ReadRepl.html">Working with DB instance read replicas</a>. |
| **Multi-AZ** | Improve availability and disaster recovery with a standby in another AZ. See <a href="https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Concepts.MultiAZ.html">Multi-AZ deployments</a>. |
| **Maintenance windows** | Schedule engine upgrades and maintenance during controlled periods. |
| **Scaling** | **Vertical**: change instance class. **Horizontal (reads)**: add read replicas. |
| **EBS-backed storage** | RDS database storage sits on Amazon EBS volumes. See <a href="https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_Storage.html">Amazon RDS DB instance storage</a>. |

### Limitations / edge cases

- **No SSH access**: RDS is fully managed—you cannot log into the underlying EC2 host. Operations go through the RDS console, API/CLI, or standard database client connections.
- **Storage autoscaling is one-way**: It grows storage automatically; it does not shrink allocated storage after growth (also noted in AWS docs).
- **Autoscaling cooldown**: Even when thresholds are met, RDS waits at least **six hours** since the last storage modification (or until storage optimization completes—whichever is longer) before scaling again.

### RDS storage autoscaling (exam focus)

When you create an RDS instance you choose initial storage (for example, 20 GiB). If the workload grows and free space gets tight, **storage autoscaling** can expand allocated storage without a manual “take the database offline and resize” operation.

**How it helps**

- Applications with heavy read/write traffic can outgrow fixed storage.
- Autoscaling avoids manual storage resize operations during growth.
- Especially useful for **unpredictable workloads** (the lecture’s example: a rapidly growing mobile game).
- Supported across **all RDS database engines** (per the lecture).

**Configuration**

- Set a **maximum storage threshold** so storage cannot grow without bound.
- Enable autoscaling at create or modify time (`MaxAllocatedStorage` / `--max-allocated-storage` in API/CLI).

**When RDS triggers a storage increase** (all must apply)

| Condition | Threshold |
|---|---|
| Low free space | Free storage ≤ **10%** of currently allocated storage |
| Sustained condition | Low storage lasts at least **5 minutes** |
| Cooldown | At least **6 hours** since the last storage modification (or storage optimization finished—whichever is longer) |

Official detail and increment rules: <a href="https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_PIOPS.Autoscaling.html">Managing capacity automatically with Amazon RDS storage autoscaling</a>.

### How to apply it: enable storage autoscaling

Set initial storage and a maximum autoscaling cap when creating the instance:

```bash
aws rds create-db-instance \
  --db-instance-identifier genai-metadata-db \
  --db-instance-class db.t3.micro \
  --engine postgres \
  --allocated-storage 20 \
  --max-allocated-storage 100 \
  --master-username admin \
  --master-user-password 'REPLACE_WITH_SECRET'
```

`--max-allocated-storage` turns on autoscaling and caps growth at 100 GiB in this example. Verify support with `describe-valid-db-instance-modifications` or `describe-orderable-db-instance-options` (`SupportsStorageAutoscaling`).

For application code, connect with your normal driver—the scaling is transparent to SQL clients:

```python
import psycopg2

conn = psycopg2.connect(
    host="genai-metadata-db.xxxxx.us-east-1.rds.amazonaws.com",
    database="appdb",
    user="admin",
    password="REPLACE_WITH_SECRET",
)
# Reads/writes continue while RDS expands EBS storage in the background
```

### Examples

**1. Fixed 20 GiB without autoscaling**

A team provisions 20 GiB for a staging database. Traffic spikes, free space drops under 10%, and writes fail until someone manually increases storage—exactly the operational toil autoscaling avoids.

**2. Autoscaling with a sensible cap**

Same 20 GiB start, but `max-allocated-storage` is 200 GiB. When sustained low free space triggers the rules, RDS grows storage in the background while the app keeps reading and writing.

**3. RDS vs EC2 for a GenAI metadata store**

A RAG pipeline stores document metadata, tenant IDs, and ingestion job status in PostgreSQL. The team chooses RDS for automated backups and PITR after a bad bulk import, instead of operating PostgreSQL backups on EC2 themselves.

### Industry scenarios

**1. Multi-tenant SaaS — structured tenant data**

An AI receptionist platform keeps per-tenant accounts, billing tiers, and call metadata in RDS PostgreSQL while embeddings live in OpenSearch or S3 Vectors. RDS managed backups and PITR protect structured data if a migration script corrupts tenant records.

**2. Rapidly growing consumer app — unpredictable storage**

A mobile game backend stores player profiles and session history in RDS MySQL. Launch-week growth is hard to forecast; storage autoscaling with a max threshold prevents outage from filling disk while capping cost exposure.

**3. Regulated enterprise — audit and recovery**

A financial services firm runs SQL Server on RDS for customer account data feeding a Bedrock-powered support assistant. Multi-AZ and continuous backups support DR expectations; the team accepts no SSH in exchange for AWS-managed patching during defined maintenance windows.

### Key takeaways

- Amazon RDS is a **managed relational database service**—know the supported engines: PostgreSQL, MySQL, MariaDB, Oracle, SQL Server, IBM Db2, and **Aurora**.
- Choose RDS over EC2 self-hosting when you want automated **provisioning, patching, backups, PITR, monitoring, Multi-AZ, read replicas, and scaling** without running the platform yourself.
- RDS storage is **EBS-backed**; you **cannot SSH** into the underlying instance.
- **Storage autoscaling** (exam-relevant): set a max threshold; scales when free space ≤ 10% for 5+ minutes and 6+ hours have passed since the last storage change.
- Autoscaling suits **unpredictable workloads** and applies to **all RDS engines** per the lecture.
- Read replicas and Multi-AZ are introduced here; this course covers them in dedicated lectures.


## Business use cases

To build the right intuition for your business model, we need to clarify a quick piece of technical alignment: **Amazon RDS is purely a relational database service** (handling highly structured tables like SQL Server, MySQL, and PostgreSQL).

If you are looking to build a multi-tenant SaaS for an AI receptionist, your core business value lies in managing two very different types of data:

1. **Relational Data:** Subscriptions, user accounts, billing info, and exact calendar dates. (This belongs in **Amazon RDS** or **DynamoDB**).
2. **Document Data:** Unstructured customer profiles, conversational scripts, configuration settings, and nested JSON payloads that change from client to client.

If you want to handle a **Document Repository**, AWS provides two specific ways to implement this, both of which add massive value to a virtual receptionist business. You can use **Amazon DocumentDB (with MongoDB compatibility)** as a dedicated document store, or leverage **PostgreSQL JSONB inside Amazon RDS**.

Here is how you can use these options to build a highly flexible, profitable SaaS application:

---

### Scenario 1: Infinite "Client Form Customization" (The JSON Document Store)

**The Business Problem:** Your SaaS needs to serve completely different types of businesses. An AI receptionist for a *plumber* needs to collect data fields like `Pipe_Material` and `Water_Shutoff_Location`. An AI receptionist for a *dental clinic* needs to collect `Insurance_Provider` and `Last_Cleaning_Date`.

If you try to build a traditional SQL database table for this, you would have to constantly rewrite your database schema or add hundreds of empty columns every time a new niche industry signs up.

* **The Implementation Choice:** You store your client configuration data as **JSON Documents** (using either Amazon DocumentDB or the native JSONB feature inside an RDS PostgreSQL database).
* **How it works:** When a new business logs into your dashboard, they can drag and drop custom fields they want their AI receptionist to collect. The backend saves this configuration as a single, dynamic JSON object:
```json
{
  "Tenant_ID": "Tenant_Dental_442",
  "Industry": "Healthcare",
  "Required_Intake_Fields": {
    "Patient_Name": "String",
    "Insurance_Carrier": "String",
    "Policy_Number": "Number"
  }
}

```


* **The Business Value:** Your software becomes universally adaptable. A Lambda function can read this flexible document profile instantly mid-call, telling the Bedrock LLM exactly what custom questions it needs to ask the caller based on that specific client's business parameters.

---

### Scenario 2: Dynamic "Caller Context Profiles"

**The Business Problem:** Customers call back multiple times, and their situations evolve. A plumbing caller might call on Monday about a leak, on Wednesday to change the appointment, and next month to ask for a receipt. Relational databases struggle to store changing, nested chronological histories elegantly.

* **The Implementation Choice:** You treat every unique phone number as a single, living "Customer Profile Document."
* **How it works:** Instead of fragmenting data across five different tables, you store the caller's profile as a dynamic document. Every time they interact with the receptionist, Lambda appends a new item to an activity array inside that exact document.
* **The Business Value:** When the customer calls back, a single query pulls the entire history, nested structure and all. You pass this clean history document directly to Bedrock, allowing the AI to seamlessly recall past issues: *"Hi Sarah, I see we resolved that kitchen pipe leak last week. Are you calling to book a new service, or did you need a copy of your billing invoice?"*

---

### Scenario 3: Storing Unified AI Agent Instructions

**The Business Problem:** Your clients want to constantly change the personality, guardrails, and tone of their AI receptionists. One week they want the bot to sound formal; the next week they want it to run a casual holiday promotion.

* **The Implementation Choice:** Use a document model to manage the receptionist's "Brain Configuration."
* **How it works:** You store system prompts, allowed tools, fallback phone numbers, and time-of-day routing rules inside a single JSON document bucket.
* **The Business Value:** Because document repositories don't require rigid column constraints, your developers can add new AI features to your SaaS (like adding a new SMS follow-up feature) without having to take down your database or run dangerous migrations that affect existing clients.

---

### Executive Intuition: Document DB vs. RDS for Your SaaS

As you look to implement this, how do you choose which database tool to use?

1. **The All-in-One Approach (RDS PostgreSQL + JSONB):** If you want to keep your business simple starting out, run an **Amazon RDS PostgreSQL** instance. It allows you to run traditional, rigid relational tables for user billing and account tracking, while using its built-in `JSONB` data columns to act as a document store for the flexible client configurations. This keeps your early AWS bill very low.
2. **The Scaled Enterprise Approach (Amazon DocumentDB):** If your SaaS grows to thousands of clients and you are handling millions of complex JSON chat logs, call structures, and application payloads a day, offload that data to a dedicated **Amazon DocumentDB** cluster. It is optimized to query, index, and scale massive volumes of unstructured JSON data with lightning speed.

### References

**In this repo**

- [Amazon RDS with S3 Document Repositories](../28-amazon-rds-with-s3-document-repositories/index.md)
- [Amazon Aurora](../29-amazon-aurora/index.md)
- [Amazon Aurora and the pgvector Extension](../31-amazon-aurora-and-the-pgvector-extension/index.md)
- [Dealing with Structured Data](../02-dealing-with-structured-data/index.md)

**AWS documentation**

- <a href="https://docs.aws.amazon.com/AmazonRDS/latest/gettingstartedguide/what-is-rds.html">Getting started with Amazon RDS</a>
- <a href="https://docs.aws.amazon.com/AmazonRDS/latest/gettingstartedguide/choosing-engine.html">Choosing your database engine for Amazon RDS</a>
- <a href="https://docs.aws.amazon.com/AmazonRDS/latest/gettingstartedguide/managing-backup-restore.html">Backing up and restoring your Amazon RDS DB instance</a>
- <a href="https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_PIT.html">Restoring a DB instance to a specified time</a>
- <a href="https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_ReadRepl.html">Working with DB instance read replicas</a>
- <a href="https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Concepts.MultiAZ.html">Configuring and managing a Multi-AZ deployment</a>
- <a href="https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_Storage.html">Amazon RDS DB instance storage</a>
- <a href="https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_PIOPS.Autoscaling.html">Managing capacity automatically with Amazon RDS storage autoscaling</a>
- <a href="https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Overview.LoggingAndMonitoring.html">Logging and monitoring in Amazon RDS</a>
