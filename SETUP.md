# Setting up the harness for a new payments app

You don't need every file on day one — see the **Minimal vs full** part of the README.
Steps 1–6 are the least you need before the first run; 7–12 are added only when they apply.
Do them roughly in order. (New to a word? See the glossary in the README.)

> Blank means skip (AGENTS.md §2.5): a section you leave blank is treated as "not part of this
> build" and won't be built. If you later ask for something you left blank, the agent stops and
> asks instead of guessing. Safety and the hard rules still apply to whatever IS built. The only
> things you must fill in to start are the mission (00) and one backlog item (03).

1. **Copy the template** into your new project folder (copy the files; don't fork the git
   history). Leave `AGENTS.md` as-is — it's generic.

2. **Fill `docs/agent/00-mission.md`** — what you're building and why, who it's for, what it is
   and is NOT, the main user journey, and what success looks like.

3. **Fill `docs/agent/01-architecture-rules.md`** — the most important file:
   - The tech stack and the main parts (services) of the app.
   - **Extra hard rules** for this project (these feed `AGENTS.md` §1).
   - **Rules you can switch off** (concurrency, data residency, determinism, reversibility, SLA,
     RTO, supply chain): for each one, set a target OR mark it "not applicable" *with a reason*.
   - The names customers see vs. the internal names.

4. **`docs/agent/02-build-plan.md` (commands)** — you don't have to write the build/test commands
   yourself. The agent proposes them while it sets up the project and asks you to confirm. You can
   also pre-fill them if you already know them.

5. **Fill `docs/agent/03-backlog.md`** — the to-do list, in order. Keep each item small.

6. **Fill `docs/agent/05-scenarios.md`** — real examples with the result you expect. These become
   the end-to-end tests.

7. **Fill `docs/agent/06-integration-and-stack.md`** — for each thing the app connects to
   (database, event streaming, message queue, APIs, SOAP, file transfer, data lake, etc.), mark
   Used or Not used, pick the technology, and confirm the checklist for that type.

8. **Fill `docs/agent/07-security-and-secrets.md`** — set how data is classified and where each
   secret/key is stored for each level (vault / HSM / PAM), how keys are rotated, and the
   secret-scan tool. Needed for any app handling passwords, keys, card numbers (PAN) or personal
   data (PII). The bank's security policy (via `org-runbook.md`) wins and can only make it stricter.

9. **Fill `docs/agent/08-ai-model-risk.md`** — only if the app uses AI/ML. Set the hard boundary,
   the defences against bad input (prompt injection), output checks, and the fallback.

10. **Fill `docs/agent/09-traceability.md`** — when you need an audit trail: link each rule/control
   and each scenario to the to-do item, the test, and the proof.

11. **(Optional) Add `docs/agent/org-runbook.md`** — your organisation's engineering and security
   standards. It can make any rule stricter, never weaker.

12. **Fill `docs/agent/04-acceptance-criteria.md`** as you go — the five checks: Functionality,
   Resilience, Security, RTO, SLA. Functionality and Security always apply; the others can be
   "not applicable" with a reason.

13. **Turn on the checks.** Create an empty `.harness-instantiated` file in the project root (this
   switches on the fill checks in `harness-lint`), put your confirmed commands into
   `.github/workflows/harness.yml` and `.pre-commit-config.yaml`, then run `sh tools/harness-lint.sh`.

14. **Start** with the prompt from the README. On the first run the agent reads the harness files
   and **asks you to confirm scope** (what it will and won't build) before writing any code, and
   saves your answer in `STATE.md`. From there it keeps `STATE.md` (the live summary) and
   `history.md` (the add-only log) up to date itself.

## Quick check before you start
- [ ] `AGENTS.md` is present and unchanged.
- [ ] 00 (mission) and 03 (backlog) are filled — no `<fill-in>` left in those.
- [ ] 06 filled for everything the app connects to.
- [ ] 07 filled: data levels + where each secret is stored; secret-scan command set.
- [ ] 08 filled if the app uses AI/ML.
- [ ] Every switch-off rule in `01` has a target or a "not applicable" reason.
- [ ] `.harness-instantiated` created and `sh tools/harness-lint.sh` passes.
