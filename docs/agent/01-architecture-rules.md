# 01 — Architecture Rules

> Template. This is the highest-value file to fill carefully. Replace every `<fill-in>`.

## Stack rules
<fill-in: backend language/framework, API style, frontend stack + design system, data store
strategy (start with mock/local data behind services/repositories so a real DB can replace it
later without rewriting decision logic), AI integration boundary, deployment target.>

> Integration & infrastructure detail (database, event streaming/Kafka, MQ, sync APIs, SOAP,
> file transfer, data-lake egress, crypto/secrets, reconciliation, UI/test stack) lives in
> `06-integration-and-stack.md`. Fill that file for every integration the project uses.

## Service boundaries
Implement these as separate classes/services even within one app initially:
- <fill-in: list the decisioning, control/gate, scoring, decision-record, redaction,
  AI-explanation, state-machine, execution and audit services.>

## Domain flow
```text
<fill-in: ConfirmedIntent -> Candidates -> UniversalControls -> SpecificControls ->
Exclusions -> ScoringOfSurvivors -> Selected -> Fallback -> DecisionRecord -> Redacted ->
AIExplanation>
```

## Project invariants (feed AGENTS.md §1)
> Universal payments invariants already live in AGENTS.md §1. Add domain hard rules here.
- <fill-in: e.g. message layer vs route, finality vs confirmation, asset/endpoint matching,
  what is in scope vs a future zone.>

## Conditional rules (AGENTS.md §2B) — set a target OR mark N/A with a reason
| Rule | Project target / decision | N/A reason (if N/A) |
|------|---------------------------|---------------------|
| Concurrency (re-entrancy, ordering, dedup) | <fill-in> | |
| Data residency / retention / classification | <fill-in> | |
| Determinism (injected time/random/IDs) | <fill-in> | |
| Reversibility & change-safety | <fill-in> | |
| SLA (per-path latency + availability) | <fill-in> | |
| RTO (recovery path + target time) | <fill-in> | |
| Supply chain (pinning, lockfiles, vetted libs) | <fill-in> | |

## Decision record
<fill-in: the required contents of the immutable decision record — header/versions, intent,
candidates, control results, exclusions, scores, selected, why alternatives lost, finality,
point-of-no-return, fallback model, evidence references, AI explanation metadata, execution
events.>

## AI boundary
AI/non-deterministic service MAY expose: <fill-in: explanation/summary methods only>.
AI service MUST NOT expose: select/score/approve/execute/updateState/overrideControl.

## Terminology rules
Customer-facing labels: <fill-in>.
Internal identifiers: <fill-in>.

## Safety rules
<fill-in: simulation/disclaimer rules, what must never connect to live systems, what data
must be synthetic.>
