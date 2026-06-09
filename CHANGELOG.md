# Changelog

All notable changes to the harness template. The contract version is what consumers pin to.

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
