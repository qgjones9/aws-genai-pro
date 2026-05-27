# Amazon DynamoDB - Basic APIs

## Lecture notes

### What this lecture covers

DynamoDB exposes purpose-built APIs for writes, reads, deletes, batching, and (via <a href="https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/ql-reference.html">PartiQL</a>) SQL-style access. This lecture maps each API to its behavior, capacity impact, and exam-relevant distinctions—especially **PutItem vs UpdateItem**, **GetItem vs Query vs Scan**, **conditional writes**, and **batch retry patterns**.

### Key definitions (from the lecture)

| Term | Definition |
|---|---|
| **PutItem** | Creates a new item or **fully replaces** an existing item that shares the same primary key. Consumes <a href="https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/ProvisionedThroughput.html">write capacity units (WCU)</a>. See <a href="https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/WorkingWithItems.html#WorkingWithItems.ItemUpdate">Working with items</a>. |
| **UpdateItem** | Edits **specific attributes** on an existing item, or creates the item if it does not exist. Does not replace every attribute the way PutItem does. Supports atomic counters (covered later in this section). |
| **Conditional write** | Accepts a write, update, or delete **only if a condition is met**—useful for concurrent access control. See <a href="https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/Expressions.ConditionExpressions.html">Condition expressions</a>. |
| **GetItem** | Reads **one item** by primary key (partition key only, or partition + sort key). See <a href="https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/WorkingWithItems.html#WorkingWithItems.ReadingData">Reading an item</a>. |
| **Query** | Returns items matching a **key condition expression** on a table, <a href="https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/LSI.html">local secondary index (LSI)</a>, or <a href="https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/GSI.html">global secondary index (GSI)</a>. See <a href="https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/Query.html">Querying tables and indexes</a>. |
| **Scan** | Reads **every item** in a table (or index). Expensive in RCU; use mainly for exports or rare full-table reads. See <a href="https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/Scan.html">Scanning tables and indexes</a>. |
| **Projection expression** | Returns only selected attributes from an item instead of the full item. See <a href="https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/Expressions.ProjectionExpressions.html">Projection expressions</a>. |
| **Filter expression** | Applies **additional filtering after** Query or Scan runs but **before** results are returned. Used on **non-key attributes** only—not partition or sort keys. See <a href="https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/Expressions.FilterExpressions.html">Filter expressions</a>. |
| **BatchWriteItem** | Up to **25** PutItem and/or DeleteItem operations in one call (no UpdateItem). See <a href="https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/WorkingWithItems.html#WorkingWithItems.BatchWriteItem">BatchWriteItem</a>. |
| **BatchGetItem** | Retrieves up to **100** items from one or more tables in parallel. See <a href="https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/WorkingWithItems.html#WorkingWithItems.BatchGetItem">BatchGetItem</a>. |
| **Unprocessed items / keys** | Subset of a batch that failed (often due to insufficient capacity). Retry with exponential backoff or increase provisioned capacity. |
| **PartiQL** | SQL interface for DynamoDB `SELECT`, `INSERT`, `UPDATE`, and `DELETE` against one or more tables—**no joins**. See <a href="https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/ql-reference.html">PartiQL reference</a>. |

### Write APIs

| API | Behavior | When to use |
|---|---|---|
| **PutItem** | Create or **fully replace** an item with the same primary key | You have the complete item and want a full overwrite |
| **UpdateItem** | Change **some attributes** only, or create if missing | Partial updates, atomic counters, append-style edits |
| **Conditional write** | Any write/update/delete gated by a condition | Optimistic locking, “only if balance = 0”, race-safe updates |

PutItem and UpdateItem both consume WCU. The exam often tests whether you need a full replace (PutItem) or a partial edit (UpdateItem).

### Read APIs: GetItem, Query, and Scan

**GetItem — one item by primary key**

- Primary key can be **partition key only** or **partition + sort key**.
- Default read mode is **eventually consistent**; set `ConsistentRead=True` for **strongly consistent** reads (costs more RCU and may add latency). See [Amazon DynamoDB - WCU & RCU](../34-amazon-dynamodb-wcu-and-rcu/index.md).
- Optional **projection expression** to return only selected attributes.

**Query — items in one partition**

- Requires a **key condition expression**:
  - **Partition key** must use the **`=`** operator (e.g., “query for `userId = u-003`”).
  - **Sort key** (if present) may use `=`, `<`, `>`, `<=`, `>=`, `between`, `begins_with`, etc.
- Optional **filter expression** on **non-key attributes** (applied after the query, before results return).
- Returns a **list of items**.
- Stops when either the **`Limit`** count is reached or **1 MB** of data is returned—use **pagination** (`LastEvaluatedKey`) for more.
- Can target a **table**, **LSI**, or **GSI** (indexes covered in later lectures).

**Scan — entire table**

| Aspect | Query | Scan |
|---|---|---|
| **Scope** | One partition key (efficient) | Entire table (expensive) |
| **Primary use** | Normal application reads | Export, analytics, migration |
| **RCU impact** | Proportional to data read | High—reads everything |
| **Result size** | Up to `Limit` or 1 MB per page | Up to 1 MB per page |

- Scan is for reading **the whole table**; filtering does not avoid reading all data first, so it remains **inefficient** for routine access.
- To limit production impact: use **`Limit`**, reduce result size, or **pause** between paginated requests.
- **Parallel scan**: multiple workers scan different segments simultaneously—**higher throughput** and **more RCU** consumed. Combine with limits to cap blast radius.
- Supports **projection expression** and **filter expression**.

**Exam mental model:** GetItem = one item; Query = one partition (plus sort conditions); Scan = whole table.

### Delete APIs

| API | Behavior |
|---|---|
| **DeleteItem** | Deletes a **single item** by primary key |
| **Conditional delete** | Delete only if a condition holds (e.g., delete only if `balance = 0`) |
| **DeleteTable** | Drops the **entire table** and all its items |

**Exam tip:** To remove everything, use **DeleteTable**—not Scan + DeleteItem on each row. DeleteTable is much faster than scanning and deleting item by item.

### Batch operations

Batching **reduces API call count and latency**; DynamoDB processes operations in a batch **in parallel**.

Because batches are partial-success by design, **some operations can fail**. Failed operations come back as **unprocessed items** (writes) or **unprocessed keys** (reads)—retry only those.

**BatchWriteItem**

- Up to **25** PutItem and/or DeleteItem operations per call.
- Up to **16 MB** total payload; each item still capped at **400 KB**.
- **Cannot** include UpdateItem—only PutItem or DeleteItem.
- On capacity shortfall → **unprocessed items** → **exponential backoff** retry, or **increase WCU** if throttling persists.

**BatchGetItem**

- Fetch from **one or more tables**.
- Up to **100 items** and **16 MB** per call; items retrieved **in parallel**.
- Missing results → **unprocessed keys** → same retry pattern (exponential backoff or add RCU).

### PartiQL (SQL on DynamoDB)

If you know SQL but not every low-level API, use **PartiQL**:

```sql
SELECT order_id, total
FROM orders
WHERE status = 'SHIPPED'
ORDER BY order_date DESC;
```

- Supports the same core operations: **SELECT**, **INSERT**, **UPDATE**, **DELETE**.
- Can run against **multiple DynamoDB tables** in one statement.
- **No joins**—PartiQL does not add relational join capability.
- Available from the AWS Management Console, <a href="https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/workbench.html">NoSQL Workbench</a>, DynamoDB APIs, CLI, and SDKs.
- Goal: same DynamoDB capabilities, **SQL syntax** for teams that prefer it.

### How to apply it (boto3 patterns)

```python
import boto3

ddb = boto3.resource("dynamodb")
table = ddb.Table("Orders")

# PutItem — full replace
table.put_item(Item={"order_id": "o-100", "total": 42.50, "status": "NEW"})

# UpdateItem — partial edit + conditional write
table.update_item(
    Key={"order_id": "o-100"},
    UpdateExpression="SET #s = :shipped",
    ConditionExpression="attribute_exists(order_id) AND #s = :new",
    ExpressionAttributeNames={"#s": "status"},
    ExpressionAttributeValues={":shipped": "SHIPPED", ":new": "NEW"},
)

# GetItem — strong consistency + projection
table.get_item(
    Key={"order_id": "o-100"},
    ConsistentRead=True,
    ProjectionExpression="order_id, total",
)

# Query — partition key =, optional sort key condition
table.query(
    KeyConditionExpression="user_id = :uid AND order_date BETWEEN :start AND :end",
    FilterExpression="total > :min_total",
    ExpressionAttributeValues={
        ":uid": "u-003",
        ":start": "2026-01-01",
        ":end": "2026-12-31",
        ":min_total": 100,
    },
    Limit=50,
)
```

### Examples

**1. Shopping cart — PutItem vs UpdateItem**

A checkout service uses **UpdateItem** to increment `item_count` and adjust `last_modified` without sending the full cart document. When the user clears the cart, **PutItem** replaces the row with a fresh empty cart structure under the same `user_id`.

**2. Order history — Query with filter**

An app queries `user_id = u-003` with a sort-key `between` on `order_date`, then applies a **filter expression** on `status = 'REFUNDED'` (a non-key attribute). Pagination walks `LastEvaluatedKey` until all matching refunds are listed.

**3. Batch import — BatchWriteItem with backoff**

A nightly job loads 10,000 product rows using **BatchWriteItem** (25 at a time). Throttled writes return **unprocessed items**; the job retries with exponential backoff until the batch completes or alarms fire to raise WCU.

### Industry scenarios

**1. Fintech — conditional writes for ledger safety**

A payments microservice debits an account with **UpdateItem** and a **condition expression** (`balance >= :amount`). Concurrent transfers that would overdraw fail cleanly instead of corrupting balances—no relational transaction required.

**2. Gaming — Query on partition + sort key**

A leaderboard stores `player_id` (partition) and `game_id` (sort key). Match history uses **Query** with `player_id = :p` and `score > :threshold` on the sort key, avoiding a table-wide Scan during live tournaments.

**3. Data platform — controlled Scan vs DeleteTable**

A staging environment needs a full reset before load tests. Ops uses **DeleteTable** (exam pattern) rather than Scan + DeleteItem. For production analytics exports, a **parallel Scan** with **Limit** and off-peak scheduling limits RCU impact on live traffic.

### Limitations / edge cases

- **UpdateItem ≠ PutItem**: UpdateItem changes selected attributes; PutItem replaces the entire item.
- **Filter expressions** cannot target partition or sort keys; they filter **after** Query/Scan and still consume capacity for scanned/read data.
- **Scan** is not a substitute for Query when you know the partition key.
- **BatchWriteItem** excludes UpdateItem—you must PutItem or use individual UpdateItem calls.
- **PartiQL** does not support **joins** across tables.
- Strongly consistent reads cost **roughly twice** the RCU of eventually consistent reads (see [WCU & RCU](../34-amazon-dynamodb-wcu-and-rcu/index.md)).

### Key takeaways

- **PutItem** = create or full replace; **UpdateItem** = partial attribute changes (or create-if-missing).
- **Conditional writes/deletes** guard concurrent updates—common exam topic.
- **GetItem** = one key; **Query** = one partition (+ sort conditions); **Scan** = entire table (high RCU).
- Query/Scan pages cap at **`Limit`** or **1 MB**—paginate with `LastEvaluatedKey`.
- **DeleteTable** beats Scan + DeleteItem when you need to wipe a table.
- **BatchWriteItem**: max **25** puts/deletes, **16 MB**, retry **unprocessed items** with exponential backoff or more WCU.
- **BatchGetItem**: max **100** items, **16 MB**, parallel reads; retry **unprocessed keys** similarly.
- **PartiQL** offers SQL syntax for CRUD across tables—**no joins**.

### References

**In this repo**

- [Amazon DynamoDB](../32-amazon-dynamodb/index.md)
- [Amazon DynamoDB - WCU & RCU](../34-amazon-dynamodb-wcu-and-rcu/index.md)
- [Amazon DynamoDB - Basic APIs - Hands On](../37-amazon-dynamodb-basic-apis-hands-on/index.md)

**AWS documentation**

- <a href="https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/WorkingWithItems.html">Working with items in DynamoDB</a>
- <a href="https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/Query.html">Querying tables and indexes</a>
- <a href="https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/Scan.html">Scanning tables and indexes</a>
- <a href="https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/Expressions.ConditionExpressions.html">Condition expressions</a>
- <a href="https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/Expressions.ProjectionExpressions.html">Projection expressions</a>
- <a href="https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/Expressions.FilterExpressions.html">Filter expressions</a>
- <a href="https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/WorkingWithItems.html#WorkingWithItems.BatchWriteItem">BatchWriteItem</a>
- <a href="https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/WorkingWithItems.html#WorkingWithItems.BatchGetItem">BatchGetItem</a>
- <a href="https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/ql-reference.html">PartiQL reference</a>
