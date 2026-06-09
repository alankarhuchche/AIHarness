# Instantiating the harness for a new payments application

Do these in order. Steps 1–6 are required before the first kickoff; the rest happen during the build.

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

7. **(Optional) Add `docs/agent/org-runbook.md`** — your org's engineering standards. It can
   make any rule stricter, never weaker.

8. **Fill `docs/agent/04-acceptance-criteria.md`** per path as you go — the five buckets:
   Functionality, Resilience, Security, RTO, SLA. Functionality and Security always apply;
   Resilience/RTO/SLA may be N/A with a reason.

9. **Kick off** with the one-line prompt from the README. The agent maintains
   `STATE.md` (live) and `history.md` (immutable activity record) itself from there.

## Sanity check before kickoff
- [ ] `AGENTS.md` unchanged and present.
- [ ] 00, 01, 02 (commands), 03, 05 filled — no `<fill-in>` markers left in those.
- [ ] Every §2B conditional rule has a target or an N/A-with-reason in `01`.
- [ ] Commands in `02` actually run locally without live external credentials.
