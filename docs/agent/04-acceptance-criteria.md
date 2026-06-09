# 04 — Acceptance Criteria

Every change is accepted only when the applicable buckets below pass, with evidence
(AGENTS.md §2 Verification). Mark a bucket N/A explicitly *with a reason* — silence is not
acceptance. **Functionality and Security always apply.** Resilience, RTO and SLA may be N/A
with a recorded reason.

## A. Functionality
- Specified behaviour is implemented and matches `05-scenarios.md`.
- Each scenario produces the expected outcome, deterministically and reproducibly.
- Blocked/excluded paths surface the correct reason, not a generic failure.

## B. Resilience
- Retryable vs terminal errors distinguished; retries bounded with backoff.
- Operations idempotent: replay/duplicate causes no double side effect.
- Partial failure, timeout, and out-of-order events handled and tested.
- Fails closed on control/security paths.

## C. Security
- AuthN/AuthZ enforced server-side; deny by default; least privilege.
- All external input validated/canonicalized at the boundary; no injection vectors.
- No secrets in code/logs/traces/fixtures; sensitive data classified and redacted before
  logging or third-party/AI calls.
- Immutable audit event emitted for every material decision/state transition.

## D. RTO (recovery)
- Each stateful component has a documented recovery path and target recovery time.
- Critical state is recoverable/replayable from the audit/event record; no critical
  in-memory-only state without a recovery story.
- Recovery demonstrated by test or documented procedure.

## E. SLA (performance / availability)
- Each request path meets its stated latency budget and availability target.
- External-call timeouts sit inside the budget; degradation path defined and tested.
- Health/readiness signals exist; key paths emit metrics.
