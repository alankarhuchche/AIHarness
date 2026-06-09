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
You do not need every file on day one. **Fill only what you need — blanks are meaningful:**
- **Leave a capability section blank** (a database, Kafka, file transfer, AI, etc.) and the
  agent treats that component as **out of scope and does not build it** (AGENTS.md §2.5).
- **Ask for something you didn't fill in** and the agent **stops and asks** instead of guessing.
- **Safety is never assumed away by a blank.** The invariants and core quality bar (value
  integrity, idempotency, audit, security baseline) apply to *whatever you do build*, filled or
  not. An empty security file means "this feature is out of scope," never "skip security."
- **Irreducible minimum to start:** the mission (00) and at least one backlog item (03).

Two tiers, then:
- **Minimal (always):** `AGENTS.md`, and `docs/agent/` 00 (mission), 03 (backlog). Add 01
  (rules), 02 (commands) and 05 (scenarios) as soon as there's real code to build and verify.
- **By relevance (add when it applies):** 04 (acceptance, as paths land), 06 (integration —
  per integration used), 07 (security/secrets — any app with credentials/keys/PAN/PII),
  08 (AI/model risk — any app with an LLM/ML component), 09 (traceability — when you need an
  audit trail).

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
