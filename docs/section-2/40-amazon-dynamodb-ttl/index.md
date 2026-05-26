# Amazon DynamoDB - TTL

## Lecture notes

### What this lecture covers

<a href="https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/TTL.html">Time to live (TTL)</a> lets DynamoDB **automatically delete items** after a per-item expiry timestamp. This lecture explains how TTL works internally, cost and timing guarantees, what happens to indexes and streams, common use cases, and how to enable TTL on a table in the console (hands-on demo).

### Key definitions (from the lecture)

| Term | Definition |
|---|---|
| **TTL (time to live)** | A DynamoDB feature that **automatically removes items** when the current time passes an expiry timestamp stored on the item. See <a href="https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/TTL.html">Using time to live (TTL) in DynamoDB</a>. |
| **TTL attribute** | A **Number** attribute you designate on the table (for example `expireOn`) whose value is a **Unix epoch timestamp** (seconds). When `now > expireOn`, the item is eligible for deletion. |
| **Expiration process** | A background workflow: (1) scan the table and **mark** items whose TTL value is less than the current time; (2) a second pass **deletes** those marked items. |
| **Pending deletion** | Items past their TTL timestamp that DynamoDB has not physically removed yet—they can still appear in **GetItem**, **Query**, and **Scan** until deletion completes. |

### The problem (why you need TTL)

- Applications often store **temporary data**—sessions, one-time tokens, short-lived caches—that should disappear on a schedule.
- Manual cleanup jobs add operational overhead and consume **write capacity units (WCU)** on every delete.
- Regulatory and retention policies may require data to be removed after a fixed period without building custom purge pipelines.

### The solution

- Add a **TTL attribute** (Number, Unix epoch seconds) to each item and **enable TTL** on the table, pointing at that attribute name.
- DynamoDB runs the expiration process in the background; you do not invoke delete APIs yourself.
- **TTL deletes do not consume WCU** in the region where expiry occurs (see <a href="https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/TTL.html">TTL pricing note</a> for global-table replica behavior).
- Typical pattern: a **session table** with `userId`, `sessionId`, and an `expireOn` attribute that defines when each session ends.

### How TTL deletion works

```
1. Background scan → compare current time to TTL attribute
2. Mark items where TTL epoch < now
3. Second scan → delete marked items
4. Remove from LSIs/GSIs; emit delete records to DynamoDB Streams
```

| Behavior | Details |
|---|---|
| **Timing** | Deletion is **not immediate**. The lecture states a guarantee within **48 hours** of expiration; in practice it is usually faster. |
| **Reads before delete** | Items **pending deletion still appear** in read, Query, and Scan results. Filter them out in application code if you must hide expired rows. See <a href="https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/ttl-expired-items.html">Working with expired items and TTL</a>. |
| **Indexes** | Deleted items are removed from **local secondary indexes (LSIs)** and **global secondary indexes (GSIs)** like any other delete. |
| **Streams** | Each TTL delete produces a **delete event** in <a href="https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/time-to-live-ttl-streams.html">DynamoDB Streams</a>, so you can archive or recover data if needed. |

### Use cases (from the lecture)

| Use case | Why TTL fits |
|---|---|
| **Reduce stored data** | Keep only current items; old rows expire automatically without batch jobs. |
| **Regulatory obligations** | Enforce retention windows (for example delete customer records after N days). |
| **Session data** | Store login sessions with a per-item expiry—classic TTL pattern in the lecture’s session-table example. |

### How to apply it (console demo)

The hands-on portion of the lecture walks through creating a table and items with a TTL attribute:

1. Create a table named **TTL** with partition key **`userId`** (no sort key).
2. Use **provisioned** capacity with autoscaling off (**1 RCU**, **1 WCU** for the demo).
3. Insert an item, for example:
   - `userId`: `John123`
   - `name`: `John`
   - `expireOn`: **Number** (not String)—Unix epoch seconds for when the item should expire.
4. Enable TTL on the table and set the TTL attribute name to **`expireOn`** (console: table → **Additional settings** → **Time to Live**).

Compute epoch seconds when writing items:

```python
import time

# Session valid for 24 hours from now
expire_on = int(time.time()) + 86400

table.put_item(
    Item={
        "userId": "John123",
        "name": "John",
        "expireOn": expire_on,  # must be Number, Unix epoch seconds
    }
)
```

Filter out expired-but-not-yet-deleted items in queries:

```python
import boto3
from boto3.dynamodb.conditions import Key, Attr

table = boto3.resource("dynamodb").Table("TTL")
now = int(time.time())

response = table.query(
    KeyConditionExpression=Key("userId").eq("John123"),
    FilterExpression=Attr("expireOn").gt(now),
)
```

### Examples

**1. Session store**

A web app stores `{ userId, sessionId, expireOn }` in DynamoDB. Each login sets `expireOn` to `now + session_duration`. TTL removes stale sessions without a cron job.

**2. One-time password (OTP) row**

A `verification_codes` table holds `{ phone, code, expireOn }` with `expireOn = now + 300` (five minutes). Codes vanish automatically after the window; streams can log deletions for audit.

**3. Temporary upload metadata**

Upload workflows write `{ uploadId, s3Key, expireOn }` while multipart uploads are in progress. If the client abandons the upload, TTL cleans the metadata row after 24 hours.

### Limitations / edge cases

- TTL timestamp must be a **Number** in **Unix epoch seconds**—String dates are ignored by the TTL process.
- Expired items may remain visible in reads for **up to ~48 hours** (lecture guarantee); plan for **client-side filtering** if stale rows are unacceptable.
- TTL deletion is **eventually consistent** with respect to when rows disappear from query results.
- TTL deletes appear in **DynamoDB Streams** as service deletes (`principalId`: `dynamodb.amazonaws.com`)—useful for recovery or archival, not a substitute for backup strategy.

### Industry scenarios

**1. SaaS — user session management**

A B2B SaaS product stores session tokens in DynamoDB keyed by `userId`. Each session row includes `expireOn` aligned with idle-timeout policy. TTL enforces logout without scheduled Lambda purges or extra WCU spend.

**2. Healthcare — retention compliance**

A health-tech platform stores patient interaction logs with a 90-day retention requirement. TTL on an `expireOn` attribute automatically removes rows after the compliance window, reducing storage cost and audit surface.

**3. E-commerce — abandoned cart snapshots**

A retailer caches in-progress cart JSON in DynamoDB for fast checkout. Carts get `expireOn = now + 7 days`. TTL drops abandoned carts; streams can copy deleted cart summaries to S3 for analytics before they are gone.

### Key takeaways

- **TTL** auto-deletes items when **current time > TTL attribute** (Number, Unix epoch seconds).
- You designate **one TTL attribute per table**; each item sets its own expiry value.
- **No WCU** for TTL-driven deletes in the expiry region (lecture emphasis).
- Deletion is **asynchronous**—guaranteed within **48 hours**, often sooner; **expired items may still appear in reads** until removed.
- TTL deletes propagate to **LSIs, GSIs, and DynamoDB Streams** (archive/recover via stream consumers if needed).
- Strong fits: **sessions**, **retention/compliance**, and **any short-lived application state**.

### References

**In this repo**

- [Amazon DynamoDB](../32-amazon-dynamodb/index.md)
- [Amazon DynamoDB - Basic APIs](../36-amazon-dynamodb-basic-apis/index.md)
- [Amazon DynamoDB DAX](../38-amazon-dynamodb-dax/index.md)

**AWS documentation**

- <a href="https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/TTL.html">Using time to live (TTL) in DynamoDB</a>
- <a href="https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/time-to-live-ttl-how-to.html">Enable time to live (TTL) in DynamoDB</a>
- <a href="https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/time-to-live-ttl-before-you-start.html">Computing time to live (TTL) in DynamoDB</a>
- <a href="https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/ttl-expired-items.html">Working with expired items and time to live (TTL)</a>
- <a href="https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/time-to-live-ttl-streams.html">DynamoDB Streams and Time to Live</a>
