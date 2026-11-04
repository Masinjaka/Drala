# AI text expense latency investigation

Reported flow: explore as a guest, sign in, then enter an expense as typed text.
The precise elapsed time and whether the original request eventually saved are
not known. Production function logs were not available through a connected tool
in this session, so the cause of that individual request is not confirmed.

## Verified findings

1. The provider timeout ended when HTTP headers arrived. Fetch resolves at the
   headers, but the provider body was read afterward with no active server
   deadline. A stalled-body test reproduces this: the original code outlives a
   scaled test deadline. The fixed code returns `provider_timeout` as expected.
2. A committed response without a wallet snapshot awaited balance refreshes
   before ending the submission. Slow refreshes could prolong the spinner;
   refresh errors could report a saved transaction as a failed submission.
3. Guest import is awaited during sign-in and deduplicated by guest ID. The text
   submission service does not itself repeat guest import. This does not rule
   out network/provider cold-start latency during the reported request.

## Changes

- The provider's existing 25-second budget now covers headers, body consumption,
  and retry backoff. Failed retry response bodies are cancelled. Model choice,
  provider billing settings, extraction, quota, and financial commit rules stay
  unchanged.
- Committed entries are applied immediately. Missing wallet snapshots refresh
  in the background with an eight-second limit and one wallet read; totals
  derive from that same snapshot. A failed refresh does not retry the expense.
- Wallet-loading state marks an unavailable snapshot. Old refreshes cannot
  overwrite a newer AI snapshot, wallet mutation, initial load, or data reset.
  Pending refresh completion is safe after screen disposal.
- Timing logs record request/refresh phases on the client and quota reservation,
  context loading, provider, and commit phases on the server. They omit expense
  text, amounts, credentials, and account identifiers.

## Deployment and limits

Client changes require a rebuilt/reloaded app. The server changes were deployed
through Supabase MCP on 2026-10-23 as `process-finance-message` version 20
(project `fqqpmzurvunhilnnhmtf`). Status is ACTIVE and JWT verification remains
enabled. All 21 deployed source/configuration files were read back and matched
the local deployment payload; all 20 server tests passed before deployment.
Timing tests use controlled delays, not a production AI request. No user expense
was submitted or modified to investigate this report.

## Verification

- AI entry regression group: **62 passed**
  (`/tmp/drala-ai-latency-final-tests.log`).
- Server tests: **20 passed**, including stalled headers/body, response integrity,
  retry cleanup/deadlines, phase logging, context loading and commit parameters
  (`/tmp/drala-ai-server-complete-tests.log`).
- Static analysis: **36 existing diagnostics**, none introduced by this change
  (`/tmp/drala-ai-latency-final-analysis.log`).
- Full application regression: **508 passed, 44 existing failures**, with no
  new failing names against the recorded baseline
  (`/tmp/drala-ai-latency-full-tests.jsonl`).
- Generated failure images were archived before restoring tracked snapshots.
- `git diff --check` passes; changed handwritten Dart and TypeScript sources
  remain within the project's 200-line limit.
