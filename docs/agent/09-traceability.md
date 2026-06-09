# 09 — Traceability Matrix

> Template. Tier-1 banking is audited on requirement → control → test traceability. This file
> links each invariant/control and material requirement to the backlog item that implements it,
> the test that proves it, and the evidence. Keep it current as part of each item's self-review
> (AGENTS.md §4). An auditor's first question — "show me the test that proves this control" —
> is answered here.

## How to use
- One row per control/requirement. Fill `Backlog`, `Test`, and `Evidence` as work lands.
- "Evidence" points to the history.md entry / test report / screenshot that demonstrates it.
- A control with no test is a gap — flag it, don't leave the row blank silently.

## Invariants & core controls (AGENTS.md §1–§2)
| ID | Control / requirement | Backlog item | Test (file/name) | Evidence (history ref) | Status |
|----|-----------------------|--------------|------------------|------------------------|--------|
| INV-1 | Value integrity (no duplicate/lost value) | <fill-in> | <fill-in> | <fill-in> | <fill-in> |
| INV-2 | Controls run and pass before scoring | <fill-in> | <fill-in> | <fill-in> | <fill-in> |
| INV-3 | AI assists only; no decision/value path | <fill-in> | <fill-in> | <fill-in> | <fill-in> |
| INV-4 | Fail closed on error/timeout/ambiguity | <fill-in> | <fill-in> | <fill-in> | <fill-in> |
| INV-5 | Immutable decision record is source of truth | <fill-in> | <fill-in> | <fill-in> | <fill-in> |
| INV-6 | Point-of-no-return handling | <fill-in> | <fill-in> | <fill-in> | <fill-in> |
| CORE-IDEM | Idempotent state-changing ops | <fill-in> | <fill-in> | <fill-in> | <fill-in> |
| CORE-EXC | Exception handling (typed, retryable vs terminal) | <fill-in> | <fill-in> | <fill-in> | <fill-in> |
| CORE-AUD | Immutable audit event per material transition | <fill-in> | <fill-in> | <fill-in> | <fill-in> |
| CORE-LOG | Structured logging, no sensitive data | <fill-in> | <fill-in> | <fill-in> | <fill-in> |
| CORE-SEC | AuthN/Z, input validation, no injection | <fill-in> | <fill-in> | <fill-in> | <fill-in> |
| CORE-SEC2 | Secrets/keys stored per classification; scan gate | <fill-in> | <fill-in> | <fill-in> | <fill-in> |

## Project requirements & scenarios
| ID | Requirement / scenario (05) | Backlog item | Test | Evidence | Status |
|----|------------------------------|--------------|------|----------|--------|
| SCN-001 | <fill-in> | <fill-in> | <fill-in> | <fill-in> | <fill-in> |
| <fill-in> | <fill-in> | <fill-in> | <fill-in> | <fill-in> | <fill-in> |
