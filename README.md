# SINN Fund Signal Client

Temporary, sender-only tools for the JKoh draft/test Signal API. This repository lets an approved
sender save an issued API key and create, list, inspect, edit, or delete LIVE and PAPER signals.

It does **not** issue API keys. An administrator creates each person's key on JKoh and sends the
plaintext value to that person privately.

## 1. Download the client

Open Terminal on your computer:

```bash
git clone https://github.com/spoonmaroon/sinnfund-signal-client.git
cd sinnfund-signal-client
```

The client requires Python 3 and uses only the standard library. There is nothing to install with
`pip`.

## 2. Save your issued key once

```bash
python3 signal_client.py save-key
```

Paste the key at the hidden prompt. The client stores it for the current computer user with private
permissions. Do not put the key in this repository, a shell script, chat, or email.

Saving again replaces the key previously saved on that computer.

## 3. Verify the key

```bash
python3 signal_client.py list
```

A JSON list means authentication worked. `HTTP 401` means the key is invalid, revoked, or was pasted
incorrectly.

## 4. Send a LIVE signal

Use a unique signal ID, uppercase ticker, and predicted target price:

```bash
SIGNAL_ID="your-name-$(date +%s)"
python3 signal_client.py create "$SIGNAL_ID" LIVE EXA 123.45
```

Replace fictional `EXA` with the intended public ticker. A LIVE signal remains pending; it does not
trade immediately. A later privileged export compares the target with a fresh current price and
writes `0.05` for LONG or `-0.05` for SHORT to the trade CSV.

## 5. Read, edit, or delete it

```bash
python3 signal_client.py list
python3 signal_client.py get "$SIGNAL_ID"
python3 signal_client.py edit "$SIGNAL_ID" --price 125.00
python3 signal_client.py delete "$SIGNAL_ID"
```

The client finds the current revision automatically. Delete removes a pending signal but preserves
its audit history. It does not cancel a broker order.

## 6. Send a PAPER signal

PAPER is not a harmless API test. An actionable signal is queued for the configured IBKR paper
account. Confirm the ProDesk Gateway session is connected before sending one.

```bash
FUTURE_UNIX_TIME=$(($(date +%s) + 86400))
python3 signal_client.py create paper-example-1 PAPER EXA 123.45 \
  "$FUTURE_UNIX_TIME" --limit-price 120.00
```

Replace the ID, ticker, target, forecast time, and order limit. Once queued, a PAPER signal cannot
be edited or deleted through this client.

## 7. Automate from a script

The included wrappers use the same privately saved key:

```bash
./examples/send_live.sh SIGNAL_ID TICKER TARGET
./examples/send_paper.sh SIGNAL_ID TICKER TARGET FUTURE_UNIX_TIME LIMIT_PRICE
```

Use a stable, unique signal ID. If a request times out, retry with the same ID because the first
request may already have succeeded.

## Optional API location

The client defaults to the JKoh draft/test API. Only use an approved HTTPS endpoint:

```bash
export SIGNAL_API_BASE_URL=https://sinnfund.jkoh.dev/prediction
```

## Security rules

- One API key per person; never share a sender key.
- Never commit API keys, account identifiers, or real position data.
- A signal ID is a non-secret label; it is not the API key.
- Lost keys cannot be recovered from the server hash and must be rotated by an administrator.
- Ordinary senders do not receive exporter or paper-worker credentials.
