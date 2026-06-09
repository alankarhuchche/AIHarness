# Payments Agent Harness

A reusable **starter kit** for building bank-grade payments apps from scratch with AI coding
agents — step by step, to a production standard (safe retries, no duplicate or lost money,
full audit log, proper error handling, security, recovery, and "show the proof" testing).

It's a **shared template** your teams copy for each new project (sometimes called *innersource*).

This repo has **no application code on purpose**. It ships the *rules* and the *fill-in-the-blanks
spec* — not an app. You copy it and fill it in per project.

Version: see [`CHANGELOG.md`](CHANGELOG.md). New to a word? See **[Words we use](#words-we-use)** below.

## What's in here
- [`AGENTS.md`](AGENTS.md) — the rules for HOW the agent works. Generic; copy it unchanged.
- [`docs/agent/`](docs/agent/) — the WHAT-to-build spec. Blank files you fill in per project.
- [`tools/harness-lint.sh`](tools/harness-lint.sh), [`.github/workflows/harness.yml`](.github/workflows/harness.yml),
  [`.pre-commit-config.yaml`](.pre-commit-config.yaml) — the harness checks itself, and gives
  you a place to plug in your build/test commands.
- [`GUIDE.md`](GUIDE.md) — the full explanation: the idea, how a build runs, the folder map, and
  what each file is for. **Start here if you're new.**
- [`SETUP.md`](SETUP.md) — the step-by-step setup checklist.

## How it works
The rules live in `AGENTS.md`, so the starting prompt is tiny:

```
Read AGENTS.md and docs/agent/, then confirm scope with me (AGENTS.md §3 Step 0)
before building — tell me what you will and won't build and wait for my OK.
After I confirm, build per AGENTS.md, working the backlog in order until you must stop.
```

On the first run the agent reads the files and **asks you to confirm scope** (what it will and
won't build) before writing any code. It saves your answer in `STATE.md` and won't ask again
unless the scope changes.

After that it works one to-do item at a time, tests every part and shows the proof, checks its
own work, and (at the end of each phase) a fresh second agent double-checks it. Everything it
does is written to an add-only log.

## Fill only what you need (so teams actually use it)
You don't need every file on day one. **Blanks are meaningful:**
- **Leave a section blank** (a database, a queue, file transfer, AI, etc.) and the agent treats
  that part as **not in this build** and won't build it.
- **Ask for something you left blank** and the agent **stops and asks** instead of guessing.
- **A blank never switches off safety.** The hard rules and the always-on quality rules (no
  duplicate/lost money, safe retries, audit log, security basics) apply to *whatever you do
  build*. An empty security file means "this feature isn't in scope," never "skip security."
- **Least you need to start:** the mission (00) and one to-do item (03).

Two tiers:
- **Always:** `AGENTS.md`, plus `docs/agent/` 00 (mission) and 03 (to-do list). Add 01 (rules),
  02 (commands) and 05 (examples) as soon as there's real code to build and test.
- **Only when it applies:** 04 (the five checks), 06 (each thing the app connects to), 07
  (security/secrets — any app with passwords, keys, card numbers or personal data), 08 (AI — any
  app using AI/ML), 09 (audit trail).

## Why it's shaped this way
- **Short rules file, deeper details linked.** `AGENTS.md` stays short (~60–130 lines); detail
  lives in `docs/agent/` files the agent opens only when needed. Very long rules files make
  agents perform worse.
- **Three rule types.** Hard rules (never break), always-on rules (every change), and switch-off
  rules (skip with a written reason).
- **Show the proof, don't claim it.** "Looks right" and "I'll test later" are banned. The UI is
  actually run and screenshotted, not just built. The harness even checks itself.
- **Say each rule once.** The checklists point back to the rules instead of repeating them, so
  edits don't drift out of step.
- **Org policy hook.** Drop your organisation's standards into `docs/agent/org-runbook.md`; it
  can make rules stricter, never weaker.

## Example app
Route Navigator (Payment Route Orchestrator) is the **intended** first user of this template.
It is **not yet moved onto these rules** — until it is, treat it as a related example, not a
proven one. (Add the repo link here once moved.)

## Getting started
New here? Read [`GUIDE.md`](GUIDE.md) first, then follow [`SETUP.md`](SETUP.md). Run
`sh tools/harness-lint.sh` any time to check the files are consistent.

## Words we use
- **Harness** — the set of rules and files around the AI agent that guide how it builds.
- **Agent** — the AI that writes the code by following these files.
- **Scope** — what's in this build and what's left out.
- **Backlog** — the ordered to-do list (`docs/agent/03`).
- **Scaffold** — set up the empty project structure before writing real features.
- **Hard rule (invariant)** — a rule that must never be broken.
- **Idempotent / safe to retry** — running the same action again does nothing extra (no double
  payment).
- **Audit log** — an add-only record of every important decision and change, for later review.
- **Redaction** — hiding sensitive data (secrets, card numbers, personal data) before it's logged
  or sent anywhere.
- **Reconciliation** — checking two records agree (e.g. money sent vs money received).
- **Fallback** — a safe backup path used before the point of no return.
- **Point of no return** — the moment after which a payment can't be undone, only serviced.
- **Vault / HSM / PAM** — secure places to store secrets and keys; PAM also controls privileged
  human access.
- **SLA** — the speed and uptime target for a request. **RTO** — how fast a part must recover
  after a failure.
- **PII / PAN** — personal data / card number. Both are sensitive and must be protected.
- **ADR** — a short note recording a decision and why (`docs/agent/adr/`).
