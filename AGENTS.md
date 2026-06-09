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
- Value integrity: never move value incorrectly. If correctness, amount, destination, or exactly-once cannot be guaranteed — hold and escalate, don't proceed.
- Controls before optimization: mandatory controls/gates/eligibility run and pass BEFORE any scoring/ranking. A failed blocking control excludes a candidate; it is never a low score.
- AI assists only: non-deterministic components (LLM/ML) explain and assist; they never make, score, override, approve, or execute a control or value-moving decision.
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
- Verification & evidence (this is what stops "built but never tested"):
  - Test every component at the lowest sufficient layer — services→unit (incl. error/idempotency/authz paths), APIs→integration against the running service, UI→automated smoke (render + key route + one interaction) AND a runtime check (drive the app, capture a clean screenshot/console), each docs/agent/05 scenario→one end-to-end pass.
  - Do show evidence: paste the real command and its real output (test summary, build log, screenshot path). Don't assert "seems right"/"should work", skip a layer because it's hard, or say "I'll test later".
- Conditional rules (concurrency, data residency, determinism, reversibility, SLA, RTO, supply chain): see docs/agent/01; each applies unless marked N/A there WITH a reason.

## 3. WORKFLOW — one backlog item at a time, in order (docs/agent/03-backlog.md)
1. Frame: success condition PLUS the failure/abuse cases it must handle.
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
Requirements contradict each other or an INVARIANT · a security/compliance/control boundary would be crossed · missing credentials or denied permission · build can't progress after reasonable local debugging · an irreversible/destructive action is required that the spec didn't authorize.

## 7. CONTEXT DISCIPLINE
- Read STATE.md (live snapshot), not the full history. Prefer narrow, targeted reads over whole-file reads. Keep diffs small.
- Delegate fan-out work (broad search, multi-file survey) to a subagent so it returns a summary instead of flooding context.
- Split history into STATE.md (rewritten) + history.md (append-only) once the log grows large; a single file is fine while small.

## 8. AGENT ACTIVITY RECORD — immutable build audit trail (docs/agent/history.md)
Append one entry per completed/blocked item; never rewrite (corrections are new entries):
timestamp · item · change summary · files · commands run + REAL outcomes · verification evidence · ADR refs · next item · blockers.

## References (loaded on demand)
docs/agent/00-mission.md · 01-architecture-rules.md (project invariants + conditional rules) · 02-build-plan.md (+commands) · 03-backlog.md · 04-acceptance-criteria.md (5 buckets) · 05-scenarios.md · STATE.md · history.md · adr/ · org-runbook.md (org standards; optional)
