# Changelog

All notable changes to the harness template. The contract version is what consumers pin to.

## v0.6.0 — 2026-06-09
Add a full explainer document.
- New `GUIDE.md`: the concept, the mental model, how a build runs end to end, the folder map,
  what each file is for (purpose only — field detail stays in the files to avoid drift), a tiny
  worked example, FAQ, and a "where to look for what" table.
- README points newcomers to `GUIDE.md` first; lint now requires it.

## v0.5.1 — 2026-06-09
More plain-English on the human-facing wording (industry-standard terms kept as-is).
- AGENTS.md: "Frame"→"Plan", "Surgical/drive-by refactors"→"smallest correct change, don't
  change unrelated code", "first-class deliverable"→"tests as part of the work", "spawn a
  reviewer subagent"→"start a fresh second agent", "material"→"important", "never best-effort"
  →"never optional".
- README: "shelf-ware"→"so teams actually use it". 04: "canonical/lens"→"actual/checklist".

## v0.5.0 — 2026-06-09
Plainer English for a wider, basic-English audience, plus the commands change.
- Commands: the agent now proposes build/test commands while scaffolding and the user confirms —
  the team no longer has to write them by hand up front (AGENTS.md §5, 02, SETUP).
- Simplified headings and framing across AGENTS.md, README and SETUP; kept the precise technical
  terms but glossed the hard ones (idempotency, drift, etc.).
- Renamed INSTANTIATING.md → SETUP.md.
- Added a plain-English glossary ("Words we use") to the README.

## v0.4.0 — 2026-06-09
Fix the scope-inference limitation: replace guessing with declaration + confirmation.
- AGENTS.md §2.5: scope is resolved by explicit `Scope: Used/Not used` markers first, then a
  one-time kickoff read-back confirmed by the user and recorded in STATE.md, then blank = out
  of scope; when unsure, fail toward asking.
- AGENTS.md §3: new Step 0 — kickoff scope read-back (what will/won't be built) before the loop.
- STATE.md: records confirmed in/out scope and the confirmation date.
- 06: optional `Scope: Used/Not used` per-section marker documented.

## v0.3.0 — 2026-06-09
Make the harness usable by lean teams without losing safety.
- Add AGENTS.md §2.5 "Fill-state semantics": a blank capability section ⇒ component out of
  scope (not built); a request needing a blank section ⇒ stop and ask (challenge-back);
  invariants + core safety always apply regardless of blanks; minimum to start is mission +
  one backlog item.
- Add a matching Stop condition (request/backlog needs an unfilled capability → ask).
- `harness-lint`: instantiated mode now hard-fails only on missing mission/backlog; other
  blanks are reported as "assumed out of scope," not failures.
- README/INSTANTIATING: document the blank-means-skip behaviour for basic teams.

## v0.2.0 — 2026-06-09
Cleanup pass after a full review.
- Add `08-ai-model-risk.md` — model-risk governance + prompt-injection defence for any LLM/ML
  component (untrusted input, output validation, redaction, deterministic fallback, oversight).
- Add `09-traceability.md` — requirement/control → backlog → test → evidence matrix for audit.
- Add self-enforcement: `tools/harness-lint.sh`, `.github/workflows/harness.yml` stub,
  `.pre-commit-config.yaml`. The harness now checks its own consistency.
- Add "Testing integrations without live infra" to `06` (containers, contract tests, fakes,
  record/replay, sandboxes).
- Remove duplication: `04-acceptance-criteria.md` now references AGENTS.md §2 instead of
  restating rules — one source of truth per rule.
- Fix contradiction: "exactly-once" → "effectively-once (no duplicate or lost value)" in the
  value-integrity invariant, consistent with `06`.
- README: honest framing of the AGENTS.md length, the Route Navigator reference (not yet
  migrated), and a Minimal-vs-full tiering to avoid shelf-ware.

## v0.1.0 — 2026-06-09
Initial scaffold.
- Generic operating contract (`AGENTS.md`): invariants, core quality contract, workflow loop,
  self-review + phase-boundary fresh reviewer, stop conditions, context discipline, activity record.
- `docs/agent/` spec skeleton (00–07), STATE/history split, ADR and org-runbook hooks.
- `06-integration-and-stack.md` and `07-security-and-secrets.md` (tier-1 secrets/key management).
- Vendor-neutral tooling placeholders throughout.
