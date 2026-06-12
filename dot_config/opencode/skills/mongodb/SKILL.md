---
name: mongodb
description: >
  Query production MongoDB databases for data investigation, schema exploration,
  and ad-hoc analysis. Use when users ask about endpoint data, company data,
  posture gaps, outbound traffic, collection schemas, or any question requiring
  MongoDB queries. Trigger this skill whenever the user mentions MongoDB, Mongo,
  checking the database, or asks data questions that require querying production
  data. Examples: "How many production companies have over 20K endpoints?",
  "What does a postureGaps document look like?", "Show me technologies for
  company X", "Check mongo for the company status", "Inspect the schema of
  unifiedEndpointView".
---

# MongoDB

## Tools

All tools are subcommands of `scripts/mongo-tools.sh`:

```bash
# Run a JS query (use print()/printjson() for output)
echo 'printjson(db.companies.findOne())' | bash scripts/mongo-tools.sh query <env> <database>

# Inspect collection schema (cached for 30 days)
bash scripts/mongo-tools.sh inspect <env> <database> <collection>

# List all databases and their collections
bash scripts/mongo-tools.sh dbs <env>

# List available environments
bash scripts/mongo-tools.sh envs
```

## Key Databases

| Database    | Purpose                         |
| ----------- | ------------------------------- |
| `apis`      | Endpoint data, outbound traffic |
| `insights`  | Posture gaps, sensitive data    |
| `companies` | Company records, configs, auth  |

## Common Patterns

- Use `print()` or `printjson()` to output query results
- CompanyId is ObjectId in most collections: `ObjectId("...")`
- Switch databases within a query: `db.getSiblingDB("insights")`
- Production companies: `db.companies.find({ status: "Production", isLab: { $ne: true } })`

## Examples

```bash
# Count production companies
echo 'print(db.companies.countDocuments({status: "Production"}))' \
  | bash scripts/mongo-tools.sh query production companies

# Inspect a collection schema
bash scripts/mongo-tools.sh inspect production apis unifiedEndpointView

# Aggregation pipeline
echo '
printjson(db.unifiedEndpointView.aggregate([
  { $match: { companyId: ObjectId("..."), "metadata.technologies.0": { $exists: true } } },
  { $group: { _id: "$host", count: { $sum: 1 } } },
  { $sort: { count: -1 } },
  { $limit: 10 }
]).toArray())
' | bash scripts/mongo-tools.sh query production apis

# Query EU production
echo 'print(db.companies.countDocuments())' \
  | bash scripts/mongo-tools.sh query production_eu companies
```
