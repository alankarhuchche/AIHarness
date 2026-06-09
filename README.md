# Payments Agent Harness

A reusable **innersource template** for building regulated, banking-grade payments
applications from scratch with AI coding agents — efficiently, iteratively, and to a
production bar (idempotency, exactly-once value movement, audit, exception handling,
security, resilience, RTO/SLA, and verification with evidence).

This repo is **code-free on purpose**. It ships the *harness* — the operating contract
and the spec skeleton — not an application. You instantiate it per project.

## What's in here
- [`AGENTS.md`](AGENTS.md) — the operating contract (HOW agents work). Generic to any
  payments application; drops in unchanged.
- [`docs/agent/`](docs/agent/) — the spec skeleton (WHAT to build). Placeholders you fill
  in per project.
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

## Design principles (why it's shaped this way)
- **Lean contract, deep references.** `AGENTS.md` stays ~130 lines; depth lives in
  referenced `docs/agent/` files loaded on demand. Contracts past ~150 lines degrade agent
  performance and get overridden by surrounding files.
- **Invariants vs. core vs. conditional.** Domain invariants and a non-waivable Core quality
  contract always apply; conditional rules can be marked N/A per project *with a reason*.
- **Verification with evidence, not assertion.** "Seems right" and "I'll test later" are
  banned. UI is exercised and screenshotted, not just built.
- **Org runbook hook.** Drop your organisation's engineering standards into
  `docs/agent/org-runbook.md`; it can make rules stricter, never weaker.

## Worked reference
Route Navigator (Payment Route Orchestrator) is the first consumer of this harness and a
filled example of the `docs/agent/` spec in practice. (Link to that repo here.)

## Getting started
See [`INSTANTIATING.md`](INSTANTIATING.md).
