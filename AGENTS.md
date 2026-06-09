# AGENTS.md — How the agent must work (rules for regulated / bank-grade payments builds)

You build a large, regulated, production-grade payments application from scratch, step by step.
This file is HOW you work. docs/agent/ is WHAT you build. Read both before any code.
On start, before building: read this file and the docs/agent/ spec, then ASK the user to confirm scope (§3 Step 0). Do not write code until scope is confirmed or already recorded in STATE.md.
If two rules clash, follow this order: hard rules (§1) > always-on rules (§2) > org runbook > the project spec in docs/agent > this workflow > your own judgement.
The org runbook can make a rule STRICTER, never weaker. If something isn't spelled out, pick the safer, simpler, easier-to-undo option and write down why.
(New to a word here? See the plain-English glossary in README.)

## 0. Where the truth lives; keeping docs and code in step
- docs/agent/ is the source of truth for scope; this file for how to work; docs/agent/org-runbook.md (if present) holds the organisation's engineering standards and adds to both.
- Do: when code and docs disagree, fix the docs in the same change. Don't: leave them out of step — that's a defect.
- Do: write down every non-obvious choice as a short note (an "ADR") in docs/agent/adr/NNN-title.md (the situation, the decision, the consequences). When there are 2–3 sensible options, make a small comparison table and pick before coding.

## 1. HARD RULES (invariants) — never break these; if a task would break one, stop and ask
- Value integrity: never move value incorrectly. If correctness, amount, destination, or effectively-once (no duplicate or lost value) cannot be guaranteed — hold and escalate, don't proceed.
- Controls before optimization: mandatory controls/gates/eligibility run and pass BEFORE any scoring/ranking. A failed blocking control excludes a candidate; it is never a low score.
- AI assists only: non-deterministic components (LLM/ML) explain and assist; they never make, score, override, approve, or execute a control or value-moving decision, and their output is never fed back as an instruction or decision input. Controls in docs/agent/08 (untrusted input, output validation, redaction, fallback, model governance).
- Fail closed: on error, timeout, or ambiguity in a control path, deny/hold — never allow by default.
- One immutable decision record is the source of truth for each important decision; views/explanations are built from it and cannot change it.
- Point-of-no-return is explicit: before it, recover/reverse; after it, only servicing/investigation/reconciliation — never silent retry.
- Extra hard rules for this project: see docs/agent/01-architecture-rules.md.

## 2. ALWAYS-ON QUALITY RULES (core) — apply to every change; cannot be switched off
- Value safety: a money move either completes exactly as intended or not at all — no partial, duplicate, wrong-amount, or wrong-destination effect. Prove it by a reconciliation check or a test.
- Idempotency (safe to retry): every state-changing operation takes an idempotency key (a unique id for the request), so running it again does nothing extra.
- Exception handling: Do map typed/domain errors to stable codes (RFC 7807) and distinguish retryable vs terminal. Don't swallow exceptions or catch-and-continue silently.
- Audit: every important decision and state change writes an immutable, add-only event with a correlation id. It is never optional.
- Logging/observability: Do use structured logs with correlation id and metrics on key paths. Don't log secrets or sensitive data; failures must be diagnosable from logs alone.
- Security baseline: Do enforce authN/authZ server-side, deny by default, least privilege, parameterize/output-encode, validate input at the boundary. Don't put secrets in code/logs/traces/fixtures or hand-roll crypto/auth.
- Secrets & keys: Do store every secret/key in an approved vault/HSM matched to its data classification, inject it at runtime, rotate it, and record its classification + store (see docs/agent/07). Don't commit a secret to repo/config/image/IaC, store one below its required tier, or send secrets/keys/PAN to logs or the AI boundary. A CI secret-scan gate must pass before merge.
- Verification & evidence (this is what stops "built but never tested"):
  - Test every component at the lowest sufficient layer — services→unit (incl. error/idempotency/authz paths), APIs→integration against the running service, UI→automated smoke (render + key route + one interaction) AND a runtime check (drive the app, capture a clean screenshot/console), each docs/agent/05 scenario→one end-to-end pass.
  - Do show evidence: paste the real command and its real output (test summary, build log, screenshot path). Don't assert "seems right"/"should work", skip a layer because it's hard, or say "I'll test later".
- Rules you can switch off (with a written reason): concurrency, data residency, determinism, reversibility, SLA, RTO, supply chain — see docs/agent/01; each one applies unless it's marked "not applicable" there WITH a reason.

## 2.5 HOW TO READ A BLANK SECTION — what to build, what to skip (fill only what you need)
Scope is DECLARED and CONFIRMED, not guessed. Resolve it in this order:
1. Explicit declaration wins: a capability section may carry `Scope: Used` or `Scope: Not used`. An explicit `Not used` is authoritative — don't build it and don't ask. An explicit `Used` means build it to spec.
2. Confirm scope once at kickoff: before building, read back what you WILL and WON'T build (in-scope vs out-of-scope/blank) and get one confirmation from the user; record the agreed scope in STATE.md. Build to that recorded scope; re-confirm only when scope changes.
3. After confirmation, a blank section = out of scope: don't build it. (The kickoff read-back is what turns inference into an agreed decision.)
4. Ask when unsure or when the ask needs a blank: if a request or backlog item needs a capability that is blank or undeclared, do not guess — stop and ask, or state one explicit assumption and record it as an ADR, before building. When confidence is low, fail toward asking, never toward silently building or skipping.
A blank never switches off safety: §1 hard rules and §2 always-on rules apply to everything you build, no matter what is left blank. An empty 07/08 section means that *feature* may be out of scope — it never means "skip security/safety" on what you do build.
Least you need to start: 00 (mission) and at least one item in 03 (backlog). Without these there is nothing to build — ask.

## 3. HOW TO WORK — one backlog item at a time, in order (docs/agent/03-backlog.md)
0. Kickoff (first run, and whenever scope changes): first READ AGENTS.md and the docs/agent/ spec. If STATE.md already records a confirmed scope and nothing changed, proceed. Otherwise produce a scope read-back from 00, 03, the `Scope:` markers and the capability sections — list what you WILL build (in scope) and what you WON'T (blank / `Not used`) — and explicitly ASK the user to confirm or correct it. Do not build until they confirm. Record the agreed scope in STATE.md, then start. This is the §2.5 confirmation step.
1. Plan: write the success condition PLUS the failure and misuse cases it must handle. Check this item is within the confirmed scope and its spec section is filled; if it needs a blank/undeclared part, stop and ask (§2.5) before building.
2. Make the smallest correct change: touch only what's needed, match the existing style, and don't change unrelated code.
3. Write the tests as part of the work, not later (per §2 Verification).
4. Verify: run §5 commands; paste real command + real outcome.
5. Self-review gate (§4), then tick the box.
6. Append to docs/agent/history.md and rewrite docs/agent/STATE.md.
Don't pause between items unless a Stop condition (§6) fires.

## 4. REVIEW
- Per item (self-review, brief, in the history entry): Which §2 rules + which of the 5 acceptance buckets apply — each satisfied or N/A with reason? What input/sequence breaks this, and is there a test? Anything touched that shouldn't be, or an abstraction with no caller — revert it. Any control/value decision routed through an AI component (must be no)? Docs/ADR/STATE consistent?
- At the end of each phase: start a fresh second agent (with its own clean context) to double-check the work. Tell it to look only at correctness and the stated requirements — don't invent problems or nitpick style. Fix what affects correctness; note the rest as optional.

## 5. COMMANDS (how to build, test, check)
Build, unit, integration, lint/format, type-check, security/dependency scan, UI smoke — see docs/agent/02. If they aren't written yet, propose them while you scaffold the project and ask the user to confirm — the user does not have to write them by hand up front. Running these checks locally must not need live external systems or production access.

## 6. WHEN TO STOP AND ASK — don't guess
Requirements contradict each other or a hard rule (§1) · a security/compliance/control line would be crossed · a secret/key would have to be committed to the repo or stored below the tier its data classification requires · the request or a backlog item needs something whose spec section is blank (ask, don't guess — §2.5) · missing credentials or denied permission · the build can't move forward after a fair attempt at local debugging · an irreversible or destructive action is needed that the spec didn't allow.

## 7. STAY FOCUSED — manage what you read
- Read STATE.md (the short live summary), not the whole history. Read just the part of a file you need, not the whole file. Keep changes small.
- Hand off wide searches (looking across many files) to a helper agent so it returns a short summary instead of filling up your context.
- Once the log gets long, split it into STATE.md (rewritten each time) + history.md (only added to). One file is fine while it's short.

## 8. KEEP A LOG OF WHAT YOU DID — a record that is only added to, never edited (docs/agent/history.md)
Add one entry per finished or blocked item; never rewrite an old entry (corrections are new entries):
timestamp · item · change summary · files · commands run + REAL outcomes · verification evidence · ADR refs · next item · blockers.

## References (loaded on demand)
docs/agent/00-mission.md · 01-architecture-rules.md (project invariants + conditional rules) · 02-build-plan.md (+commands) · 03-backlog.md · 04-acceptance-criteria.md (5 buckets) · 05-scenarios.md · 06-integration-and-stack.md (db, eventing, MQ, APIs, file transfer, data egress, crypto) · 07-security-and-secrets.md (secrets/key management by data classification) · 08-ai-model-risk.md (model risk + prompt-injection defence) · 09-traceability.md (control→test matrix) · STATE.md · history.md · adr/ · org-runbook.md (org standards; optional)
