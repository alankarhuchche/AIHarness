# Payments Agent Harness

A reusable **innersource template** for building regulated, banking-grade payments
applications from scratch with AI coding agents — efficiently, iteratively, and to a
production bar (idempotency, effectively-once value movement, audit, exception handling,
security, resilience, RTO/SLA, AI/model-risk control, and verification with evidence).

This repo is **code-free on purpose**. It ships the *harness* — the operating contract
and the spec skeleton — not an application. You instantiate it per project.

Version: see [`CHANGELOG.md`](CHANGELOG.md).

## What's in here
- [`AGENTS.md`](AGENTS.md) — the operating contract (HOW agents work). Generic to any
  payments application; drops in unchanged.
- [`docs/agent/`](docs/agent/) — the spec skeleton (WHAT to build). Placeholders you fill
  in per project.
- [`tools/harness-lint.sh`](tools/harness-lint.sh), [`.github/workflows/harness.yml`](.github/workflows/harness.yml),
  [`.pre-commit-config.yaml`](.pre-commit-config.yaml) — the harness checks its own
  consistency and gives the project a CI/pre-commit gate to wire its real commands into.
- [`INSTANTIATING.md`](INSTANTIATING.md) — the step-by-step checklist to turn this template
  into a real project.

## How it works
The contract carries the engineering discipline, so the kickoff prompt stays tiny:

```
Build the application defined in docs/agent/ per AGENTS.md.
Start at the first unchecked backlog item and run the loop until a Stop condition fires.
```

The agent reads `AGENTS.md` + `docs/agent/`, works one backlog item at a time, tests every
component with evidence, self-reviews each item, and a fresh reviewer subagent verifies at
each phase boundary. All work is logged to an immutable activity record.

## Minimal vs full (don't let it become shelf-ware)
You do not need every file on day one. Two tiers:
- **Minimal (always):** `AGENTS.md`, and `docs/agent/` 00 (mission), 01 (rules + invariants),
  02 (commands), 03 (backlog), 05 (scenarios). This is enough to start safely.
- **By relevance (add when it applies):** 04 (acceptance, as paths land), 06 (integration —
  per integration used), 07 (security/secrets — any app with credentials/keys/PAN/PII),
  08 (AI/model risk — any app with an LLM/ML component), 09 (traceability — when you need an
  audit trail). Mark a whole file "not applicable" with a reason rather than half-filling it.

## Design principles (why it's shaped this way)
- **Lean contract, deep references.** `AGENTS.md` stays lean (~60–130 lines); depth lives in
  referenced `docs/agent/` files loaded on demand. Contracts past ~150 lines degrade agent
  performance and get overridden by surrounding files.
- **Invariants vs. core vs. conditional.** Domain invariants and a non-waivable Core quality
  contract always apply; conditional rules can be marked N/A per project *with a reason*.
- **Verification with evidence, not assertion.** "Seems right" and "I'll test later" are
  banned. UI is exercised and screenshotted, not just built. The harness lints itself.
- **One source of truth per rule.** Acceptance criteria and integration checklists *reference*
  the contract; they don't restate it, so edits don't drift.
- **Org runbook hook.** Drop your organisation's engineering standards into
  `docs/agent/org-runbook.md`; it can make rules stricter, never weaker.

## Worked reference
Route Navigator (Payment Route Orchestrator) is the **intended** first consumer of this
harness. It is not yet migrated to this contract — until it is, treat it as a related example,
not a conformant reference. (Add the repo link here once migrated.)

## Getting started
See [`INSTANTIATING.md`](INSTANTIATING.md). Run `sh tools/harness-lint.sh` any time to check
consistency.
