# Instantiating the harness for a new payments application

You don't need every file on day one — see the **Minimal vs full** section in the README.
Steps 1–6 are the minimal set required before the first kickoff; 7–11 are added by relevance.
Do them roughly in order.

1. **Copy the template** into your new project repo (copy the files; do not fork the git
   history). Keep `AGENTS.md` as-is — it's generic.

2. **Fill `docs/agent/00-mission.md`** — product thesis, what it is / is not, core user
   journey, audience, success criteria. Be explicit about non-goals.

3. **Fill `docs/agent/01-architecture-rules.md`** — the high-value file:
   - Stack and service boundaries.
   - **Project invariants** (feed `AGENTS.md` §1). Add domain hard rules beyond the
     universal payments invariants.
   - **Conditional rules** (`AGENTS.md` §2B): for each of concurrency, data residency,
     determinism, reversibility, SLA, RTO, supply chain — set the project's target OR mark
     it N/A *with a reason*. No silent omissions.
   - Terminology rules (the names customers see vs. internal identifiers).

4. **Fill `docs/agent/02-build-plan.md`** — phases and the **COMMANDS table** (build, unit,
   integration, lint, type-check, security/dependency scan, UI smoke). Agents run exactly
   what you write here.

5. **Fill `docs/agent/03-backlog.md`** — the ordered, checkable work queue. Small items.

6. **Fill `docs/agent/05-scenarios.md`** — concrete end-to-end cases with expected outcomes.
   These drive the E2E layer of verification.

7. **Fill `docs/agent/06-integration-and-stack.md`** — for every integration the app uses
   (database, event streaming, MQ, sync APIs, SOAP, file transfer, data-lake egress,
   crypto/secrets, reconciliation, UI/test stack), mark Used/Not used, pick the technology, and
   confirm the per-pattern harness considerations. The cross-cutting checklist is mandatory
   where a pattern is used.

8. **Fill `docs/agent/07-security-and-secrets.md`** — set the bank's data-classification scheme
   and the storage-by-classification matrix (vault/HSM/PAM per tier), key lifecycle, mTLS/PKI,
   approved algorithms, and the secret-scan tooling. Mandatory for any app handling credentials,
   keys, PAN or PII. The bank's infosec policy (via `org-runbook.md`) is authoritative and may
   only make these controls stricter.

9. **Fill `docs/agent/08-ai-model-risk.md`** — only if the app has an LLM/ML component. Set the
   hard boundary, prompt-injection defences, output validation, model governance and fallback.

10. **Fill `docs/agent/09-traceability.md`** — when you need an audit trail: link each invariant/
   control and scenario to its backlog item, test and evidence. Keep it current per item.

11. **(Optional) Add `docs/agent/org-runbook.md`** — your org's engineering & security standards.
   It can make any rule stricter, never weaker.

12. **Fill `docs/agent/04-acceptance-criteria.md`** per path as you go — the five buckets:
   Functionality, Resilience, Security, RTO, SLA. Functionality and Security always apply;
   Resilience/RTO/SLA may be N/A with a reason.

13. **Declare instantiation & wire CI.** Create an empty `.harness-instantiated` file at the repo
   root (turns on fill-in enforcement in `harness-lint`), fill the command stubs in
   `.github/workflows/harness.yml` and `.pre-commit-config.yaml` from `02`, then run
   `sh tools/harness-lint.sh`.

14. **Kick off** with the one-line prompt from the README. The agent maintains
   `STATE.md` (live) and `history.md` (immutable activity record) itself from there.

## Sanity check before kickoff
- [ ] `AGENTS.md` unchanged and present.
- [ ] 00, 01, 02 (commands), 03, 05 filled — no `<fill-in>` markers left in those.
- [ ] 06 filled for every integration the app uses; cross-cutting checklist satisfied.
- [ ] 07 filled: classification scheme + storage matrix set; secret-scan command wired in 02.
- [ ] 08 filled if an AI/ML component exists; injection/redaction/fallback tests planned.
- [ ] Every §2B conditional rule has a target or an N/A-with-reason in `01`.
- [ ] Commands in `02` actually run locally without live external credentials.
- [ ] `.harness-instantiated` created and `sh tools/harness-lint.sh` passes.
