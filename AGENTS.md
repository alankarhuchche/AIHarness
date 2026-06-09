# AGENTS.md — Operating Contract (regulated / banking-grade payments builds)

You build a large, regulated, production-grade payments application from scratch, iteratively.
This file is HOW you work. docs/agent/ is WHAT you build. Read both before any code.
Precedence on conflict: INVARIANTS > CORE > org runbook > docs/agent spec > this workflow > your judgement.
The org runbook may make a rule STRICTER, never weaker. Underspecified? Choose the safer, simpler, more reversible option and record why.

## 0. Source of truth, drift, decisions
- docs/agent/ is canonical for scope; this file for discipline; docs/agent/org-runbook.md (if present) carries the organisation's engineering standards and supplements both.
- Do: fix docs in the same change when code and docs diverge. Don't: leave drift — it's a defect.
- Do: record every non-trivial choice as a short ADR in docs/agent/adr/NNN-title.md (context, decision, consequences). When 2–3 reasonable approaches exist, write a decision table and pick before coding.

## 1. INVARIANTS — never violate; a task that would breach one is a Stop condition
- Value integrity: never move value incorrectly. If correctness, amount, destination, or effectively-once (no duplicate or lost value) cannot be guaranteed — hold and escalate, don't proceed.
- Controls before optimization: mandatory controls/gates/eligibility run and pass BEFORE any scoring/ranking. A failed blocking control excludes a candidate; it is never a low score.
- AI assists only: non-deterministic components (LLM/ML) explain and assist; they never make, score, override, approve, or execute a control or value-moving decision, and their output is never fed back as an instruction or decision input. Controls in docs/agent/08 (untrusted input, output validation, redaction, fallback, model governance).
- Fail closed: on error, timeout, or ambiguity in a control path, deny/hold — never allow by default.
- One immutable decision record is the source of truth for each material decision; views/explanations derive from it and cannot alter it.
- Point-of-no-return is explicit: before it, recover/reverse; after it, only servicing/investigation/reconciliation — never silent retry.
- Project-specific invariants: see docs/agent/01-architecture-rules.md.

## 2. CORE QUALITY CONTRACT — never waivable, every change
- Value safety: a value-moving op completes exactly as intended or not at all — no partial, duplicate, mis-amount, or mis-routed effect. Prove by reconciliation/test.
- Idempotency: every state-changing op takes an idempotency key; retry causes no duplicate side effect.
- Exception handling: Do map typed/domain errors to stable codes (RFC 7807) and distinguish retryable vs terminal. Don't swallow exceptions or catch-and-continue silently.
- Audit: every material decision and state transition emits an immutable, append-only event with a correlation id. Never best-effort.
- Logging/observability: Do use structured logs with correlation id and metrics on key paths. Don't log secrets or sensitive data; failures must be diagnosable from logs alone.
- Security baseline: Do enforce authN/authZ server-side, deny by default, least privilege, parameterize/output-encode, validate input at the boundary. Don't put secrets in code/logs/traces/fixtures or hand-roll crypto/auth.
- Secrets & keys: Do store every secret/key in an approved vault/HSM matched to its data classification, inject it at runtime, rotate it, and record its classification + store (see docs/agent/07). Don't commit a secret to repo/config/image/IaC, store one below its required tier, or send secrets/keys/PAN to logs or the AI boundary. A CI secret-scan gate must pass before merge.
- Verification & evidence (this is what stops "built but never tested"):
  - Test every component at the lowest sufficient layer — services→unit (incl. error/idempotency/authz paths), APIs→integration against the running service, UI→automated smoke (render + key route + one interaction) AND a runtime check (drive the app, capture a clean screenshot/console), each docs/agent/05 scenario→one end-to-end pass.
  - Do show evidence: paste the real command and its real output (test summary, build log, screenshot path). Don't assert "seems right"/"should work", skip a layer because it's hard, or say "I'll test later".
- Conditional rules (concurrency, data residency, determinism, reversibility, SLA, RTO, supply chain): see docs/agent/01; each applies unless marked N/A there WITH a reason.

## 2.5 FILL-STATE SEMANTICS — how to read an unfilled spec (fill only what you need)
Scope is DECLARED and CONFIRMED, not guessed. Resolve it in this order:
1. Explicit declaration wins: a capability section may carry `Scope: Used` or `Scope: Not used`. An explicit `Not used` is authoritative — don't build it and don't ask. An explicit `Used` means build it to spec.
2. Confirm scope once at kickoff: before building, read back what you WILL and WON'T build (in-scope vs out-of-scope/blank) and get one confirmation from the user; record the agreed scope in STATE.md. Build to that recorded scope; re-confirm only when scope changes.
3. After confirmation, a blank section = out of scope: don't build it. (The kickoff read-back is what turns inference into an agreed decision.)
4. Ask when unsure or when the ask needs a blank: if a request or backlog item needs a capability that is blank or undeclared, do not guess — stop and ask, or state one explicit assumption and record it as an ADR, before building. When confidence is low, fail toward asking, never toward silently building or skipping.
Always-on, never assumed away by emptiness: §1 INVARIANTS and §2 CORE apply to everything you build, regardless of blanks. An empty 07/08 section means that *feature* may be out of scope — never "skip security/safety" on what you do build.
Irreducible minimum to start: 00 (mission) and at least one item in 03 (backlog). Without these there is nothing to build — ask.

## 3. WORKFLOW — one backlog item at a time, in order (docs/agent/03-backlog.md)
0. Kickoff (first run, and whenever scope changes): produce a scope read-back from 00, 03 and the capability sections — list what you WILL build (in scope) and what you WON'T (blank / `Not used`). Get one confirmation, record the agreed scope in STATE.md, then start. This is the §2.5 confirmation step.
1. Frame: success condition PLUS the failure/abuse cases it must handle. Check this item is within the confirmed scope and its spec section is filled; if it needs an unfilled/undeclared capability, challenge back (§2.5) before building.
2. Implement the smallest correct change. Surgical: touch only what's needed; match existing style; no drive-by refactors.
3. Test as a first-class deliverable (per §2 Verification).
4. Verify: run §5 commands; paste real command + real outcome.
5. Self-review gate (§4), then tick the box.
6. Append to docs/agent/history.md and rewrite docs/agent/STATE.md.
Don't pause between items unless a Stop condition (§6) fires.

## 4. REVIEW
- Per item (self-review, brief, in the history entry): Which §2 rules + which of the 5 acceptance buckets apply — each satisfied or N/A with reason? What input/sequence breaks this, and is there a test? Anything touched that shouldn't be, or an abstraction with no caller — revert it. Any control/value decision routed through an AI component (must be no)? Docs/ADR/STATE consistent?
- Per phase boundary: spawn a FRESH reviewer subagent (separate context). Scope it to correctness and stated requirements only — do not chase invented or stylistic gaps. Fix what affects correctness; log the rest as optional.

## 5. COMMANDS
Build, unit, integration, lint/format, type-check, security/dependency scan, UI smoke — see docs/agent/02. Local verification must not require live external credentials or production infra.

## 6. STOP CONDITIONS — halt and report; don't guess
Requirements contradict each other or an INVARIANT · a security/compliance/control boundary would be crossed · a secret/key would have to be committed to the repo or stored below the tier its data classification requires · the request or a backlog item needs a capability whose spec section is unfilled (ask, don't guess — §2.5) · missing credentials or denied permission · build can't progress after reasonable local debugging · an irreversible/destructive action is required that the spec didn't authorize.

## 7. CONTEXT DISCIPLINE
- Read STATE.md (live snapshot), not the full history. Prefer narrow, targeted reads over whole-file reads. Keep diffs small.
- Delegate fan-out work (broad search, multi-file survey) to a subagent so it returns a summary instead of flooding context.
- Split history into STATE.md (rewritten) + history.md (append-only) once the log grows large; a single file is fine while small.

## 8. AGENT ACTIVITY RECORD — immutable build audit trail (docs/agent/history.md)
Append one entry per completed/blocked item; never rewrite (corrections are new entries):
timestamp · item · change summary · files · commands run + REAL outcomes · verification evidence · ADR refs · next item · blockers.

## References (loaded on demand)
docs/agent/00-mission.md · 01-architecture-rules.md (project invariants + conditional rules) · 02-build-plan.md (+commands) · 03-backlog.md · 04-acceptance-criteria.md (5 buckets) · 05-scenarios.md · 06-integration-and-stack.md (db, eventing, MQ, APIs, file transfer, data egress, crypto) · 07-security-and-secrets.md (secrets/key management by data classification) · 08-ai-model-risk.md (model risk + prompt-injection defence) · 09-traceability.md (control→test matrix) · STATE.md · history.md · adr/ · org-runbook.md (org standards; optional)
