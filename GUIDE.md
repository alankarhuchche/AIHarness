# Guide — understanding and using the Payments Agent Harness

This is the "explain it to me" document. The README is the quick overview, `SETUP.md` is the
step-by-step checklist, and `AGENTS.md` is the rulebook the agent follows. This guide ties them
together: the idea, how a build runs, the folder map, and what each file is for.

If a word is new, check **Words we use** in the README.

---

## 1. The idea in three sentences
You want an AI agent to build a bank-grade payments app, but you need it to work safely and
predictably. This harness gives the agent a fixed rulebook (`AGENTS.md`) and a fill-in spec
(`docs/agent/`) so it builds the right thing, tests every part and shows the proof, asks before
guessing, and writes down everything it does. You fill in only what you need; the agent does the
rest, one to-do item at a time.

## 2. The mental model — three parts
```
   YOU                 THE HARNESS                       THE AGENT
   ───                 ───────────                       ─────────
  fill in   ──────▶   docs/agent/  (WHAT to build)  ──▶  reads both,
  the spec            AGENTS.md    (HOW to work)         confirms scope with you,
  confirm scope                                          then builds item by item,
                                                         tests with proof, logs it
```
- **AGENTS.md** — the rules: how to work, what's safe, when to stop and ask. You don't edit this.
- **docs/agent/** — the spec: what your app is, its to-do list, its rules, what it connects to.
  You fill these in (only the parts you need).
- **The agent** — reads both, confirms scope, then does the work and keeps the records.

## 3. How a build runs, start to finish
1. **Copy** the template into your new project folder.
2. **Fill the minimum:** the mission (`00`) and at least one to-do item (`03`). Add more files
   only when they apply.
3. **Start** the agent with the prompt from the README.
4. **It asks you to confirm scope** — what it will and won't build. You say yes or correct it.
   Your answer is saved in `STATE.md`.
5. **It works one to-do item at a time:** plans it, makes the smallest correct change, writes
   tests, runs the checks and shows the output, checks its own work, then ticks the item off.
6. **It logs each item** to `history.md` and updates the live summary in `STATE.md`.
7. **At the end of each phase**, a fresh second agent double-checks the work.
8. **It stops and asks** if something is unclear, unsafe, or needs a part you left blank.

## 4. Folder map
```
AGENTS.md                 The rulebook (HOW the agent works). Copy unchanged.
README.md                 Quick overview + glossary ("Words we use").
GUIDE.md                  This file — the full explanation.
SETUP.md                  Step-by-step setup checklist.
CHANGELOG.md              What changed in each version of the template.
tools/harness-lint.sh     A check that the files are consistent.
.github/workflows/        CI: runs the lint + your build/test commands.
.pre-commit-config.yaml   Runs the lint (and your secret scan) before each commit.
docs/agent/               The fill-in spec (WHAT to build):
  00-mission.md             What you're building and why.
  01-architecture-rules.md  Tech stack, extra hard rules, switch-off rules, names.
  02-build-plan.md          Phases + the build/test commands.
  03-backlog.md             The ordered to-do list.
  04-acceptance-criteria.md The five checks for "done".
  05-scenarios.md           Real examples with expected results (become the tests).
  06-integration-and-stack.md  Each thing the app connects to (db, queue, files…).
  07-security-and-secrets.md   Where secrets/keys live by data level.
  08-ai-model-risk.md          Rules for any AI/ML part.
  09-traceability.md           Audit trail: rule → to-do → test → proof.
  STATE.md                  Live summary (rewritten each time).
  history.md                Add-only log of everything done.
  org-runbook.md            Your organisation's standards (optional).
  OWNERS.md                 Who is responsible for keeping each file accurate.
  adr/                      Short notes recording decisions and why.
```

## 5. What each file is for (and where to put what)
> The detailed "what goes in this field" hints live **inside each file** as `<fill-in: …>`
> markers. This list gives the purpose so you know which file to open. Fill only what applies.

- **00-mission.md** — the app in plain terms: what it is, what it is NOT, who it's for, the main
  user journey, and what success looks like. *Required to start.*
- **01-architecture-rules.md** — the tech stack and main services; any extra hard rules for this
  project; the switch-off rules (set a target or mark "not applicable" with a reason); and the
  customer-facing vs internal names.
- **02-build-plan.md** — the phases, and the table of build/test/check commands. You don't have
  to write the commands yourself — the agent proposes them while setting up and you confirm.
- **03-backlog.md** — the to-do list, in order, each item small and checkable. *Required to start.*
- **04-acceptance-criteria.md** — the five checks every change must pass: Functionality,
  Resilience, Security, RTO, SLA. Fill in as work lands.
- **05-scenarios.md** — concrete examples ("send X, expect Y"). These become the end-to-end tests.
- **06-integration-and-stack.md** — one section per thing the app connects to. Mark Used or Not
  used, pick the technology, confirm the checklist. Blank = not in this build.
- **07-security-and-secrets.md** — your data levels and where each secret/key is stored for each
  level, key rotation, and the secret-scan tool. Needed for any app with passwords, keys, card
  numbers or personal data.
- **08-ai-model-risk.md** — only if the app uses AI/ML: the hard boundary, input/output checks,
  and the fallback. Blank = no AI part.
- **09-traceability.md** — the audit trail linking each rule/control and scenario to its to-do
  item, test and proof. Add when you need to show auditors.
- **STATE.md** — the live summary the agent keeps: confirmed scope, last good run, next item,
  risks. You read this to see where things stand.
- **history.md** — the add-only record of every finished/blocked item. Never edited.
- **org-runbook.md** — drop your organisation's standards here; they can make rules stricter,
  never weaker.
- **OWNERS.md** — who is responsible for keeping each file accurate and up to date. Maps
  every file to a named role (product owner, solution architect, security, quality engineer,
  devops, integrator, customer journey manager, enterprise architect, software engineer).
- **adr/** — one short note per real decision (the situation, the choice, the result).

## 6. The three kinds of rule
- **Hard rules** (`AGENTS.md §1`) — never break them. Example: never move money incorrectly. If a
  task would break one, the agent stops and asks.
- **Always-on rules** (`§2`) — apply to every change, can't be switched off. Example: safe retries,
  audit log, security basics, test-with-proof.
- **Switch-off rules** (`§2`, listed in `01`) — apply unless you mark them "not applicable" with a
  reason. Example: data residency, recovery-time target.

## 7. Two ideas that make it safe for a basic team
- **Blank means skip.** Leave a section blank and that part isn't built. Ask for something you
  left blank and the agent stops and asks — it never guesses.
- **Show the proof.** "Looks right" and "I'll test later" are not allowed. The agent runs the
  checks and pastes the real output; the UI is actually run and screenshotted.

## 8. A tiny example
You want a simple "validate a UK payment" feature.
1. In `00` you write the mission (one paragraph).
2. In `03` you add: `1. Validate a UK payment request. Acceptance: valid request passes; bad
   sort code is rejected with a clear reason.`
3. You leave `06`, `07`, `08` blank for now (no external systems, no secrets, no AI yet).
4. You start the agent. It reads the files and says: *"In scope: UK payment validation. Out of
   scope (blank): database, queues, file transfer, AI, secrets. Confirm?"* You say yes.
5. It builds the validation, writes a unit test for the good and bad cases, runs them, pastes the
   output, logs the item, and ticks it off.

## 9. Common questions
- **Do I have to fill every file?** No. Mission + one to-do item to start; everything else only
  when it applies.
- **Who writes the build/test commands?** The agent proposes them while setting up; you confirm.
- **What if I forgot to spec something I need?** The agent stops and asks rather than guessing.
- **Will it skip security if I leave the security file blank?** No. A blank only removes a
  *feature* from scope; the always-on safety rules apply to everything it does build.
- **Where do I see what it did?** `STATE.md` for "where things stand now", `history.md` for the
  full record.

## 10. Where to look for what
| You want to… | Open |
|--------------|------|
| Understand the idea | this file |
| Set up a new project | `SETUP.md` |
| Know the rules the agent follows | `AGENTS.md` |
| Understand a word | README → Words we use |
| See where the build stands | `docs/agent/STATE.md` |
| See everything that was done | `docs/agent/history.md` |
