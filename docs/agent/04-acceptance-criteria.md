# 04 — Acceptance Criteria

Every change is accepted only when the applicable buckets below pass, with evidence
(AGENTS.md §2 Verification). Mark a bucket N/A explicitly *with a reason* — silence is not
acceptance. **Functionality and Security always apply.** Resilience, RTO and SLA may be N/A
with a recorded reason.

> These buckets are the checklist for review and sign-off. The actual rules they
> check live in AGENTS.md §1–§2 and docs 06–08 — this file references them, it does not restate
> them, so there is one source of truth per rule.

## A. Functionality
- Specified behaviour is implemented and matches `05-scenarios.md`.
- Each scenario produces the expected outcome, deterministically and reproducibly.
- Blocked/excluded paths surface the correct reason, not a generic failure.

## B. Resilience
- Idempotency, retry/backoff, fail-closed, partial-failure and out-of-order handling per
  AGENTS.md §2 — verified by test, including the failure paths (not just the happy path).
- DLQ/quarantine and recovery behaviour exercised for the integrations in `06`.

## C. Security
- Per AGENTS.md §2 (Security baseline + Secrets & keys) and docs `07`/`08`:
  authN/Z and input validation verified; secret-scan gate passes; secrets/keys stored per
  classification; TLS/mTLS and approved algorithms on touched paths; redaction confirmed at log
  and AI boundaries; immutable audit event emitted. Evidence attached, not asserted.

## D. RTO (recovery)
- Each stateful component has a documented recovery path and target recovery time.
- Critical state is recoverable/replayable from the audit/event record; no critical
  in-memory-only state without a recovery story.
- Recovery demonstrated by test or documented procedure.

## E. SLA (performance / availability)
- Each request path meets its stated latency budget and availability target.
- External-call timeouts sit inside the budget; degradation path defined and tested.
- Health/readiness signals exist; key paths emit metrics.
