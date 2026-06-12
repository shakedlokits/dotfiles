---
name: slack
description: >
  Call the Slack Web API as the authenticated user — read channels and
  threads, search messages, list users, post messages, react, and any
  other method documented at https://docs.slack.dev/reference/methods.
  Use whenever the user asks about Slack content, conversations, channels,
  DMs, threads, reactions, or wants something posted to Slack. Examples:
  "What did the team say in #pi-team-bes today?", "Show the last 20
  messages in C08DJH3UJRK", "Search Slack for messages mentioning
  api-gateway", "Post 'deploy done' to #releases", "Who is in #oncall?".
---

# Slack

## Calling the API

Pipe a JSON object of method params to the script and pass the Slack
method name as the only argument:

```bash
echo '{"channel":"C08DJH3UJRK","limit":20}' \
  | bash scripts/slack.sh conversations.history
```

The raw JSON response is printed on stdout. Pipe through `jq` for
filtering. Object and array values in the params (e.g. `blocks`,
`attachments`) are encoded for you — just nest them in the JSON.

## Common Methods

| Method | Purpose |
|--------|---------|
| `conversations.history` | Messages in a channel (`channel`, `oldest`, `limit`, `cursor`) |
| `conversations.replies` | Thread replies (`channel`, `ts`) |
| `conversations.list` | List channels (`types=public_channel,private_channel,mpim,im`) |
| `conversations.info` | Channel metadata (`channel`) |
| `search.messages` | Full-text search (`query`, `count`, `sort`) |
| `users.list` | Workspace users |
| `users.info` | Single user (`user`) |
| `chat.postMessage` | Send a message (`channel`, `text`, `thread_ts`, `blocks`) |
| `reactions.add` | React (`channel`, `timestamp`, `name`) |

## Patterns

- Channel IDs (`C…`, `D…`, `G…`) are required; names are not accepted by
  most methods. Resolve via `conversations.list` if you only have a name.
- Time filters use unix seconds in `oldest` / `latest`. Today midnight:
  `date -v0H -v0M -v0S +%s`.
- Pagination: pass `cursor` from `response_metadata.next_cursor` until empty.
- Extract a single field with `jq`:
  ```bash
  echo '{"channel":"C08DJH3UJRK","limit":5}' \
    | bash scripts/slack.sh conversations.history \
    | jq -r '.messages[] | "\(.ts)\t\(.user)\t\(.text)"'
  ```

## Examples

```bash
# Today's messages in a channel
OLDEST=$(date -v0H -v0M -v0S +%s)
echo "{\"channel\":\"C08DJH3UJRK\",\"oldest\":\"${OLDEST}\"}" \
  | bash scripts/slack.sh conversations.history

# Replies in a thread
echo '{"channel":"C08DJH3UJRK","ts":"1716489600.123456"}' \
  | bash scripts/slack.sh conversations.replies

# Search across the workspace
echo '{"query":"api-gateway error has:link","count":20}' \
  | bash scripts/slack.sh search.messages

# Post a message with Block Kit
echo '{
  "channel":"C123",
  "text":"deploy done",
  "blocks":[{"type":"section","text":{"type":"mrkdwn","text":"*deploy done* :rocket:"}}]
}' | bash scripts/slack.sh chat.postMessage

# Resolve a channel name to ID
echo '{"types":"public_channel,private_channel","limit":1000}' \
  | bash scripts/slack.sh conversations.list \
  | jq -r '.channels[] | select(.name=="pi-team-bes") | .id'
```
