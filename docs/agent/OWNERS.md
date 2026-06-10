# OWNERS — Who maintains each file and why

Every file in this harness has a named owner who is responsible for keeping it accurate
and up to date. This is not a list of who can edit a file — anyone can propose a change —
it is a list of who is accountable for the content being correct at all times.

> How to use this: when a file changes (requirements shift, a new integration is added, a
> security standard is updated), the owner must review and update their file. Outdated docs
> are a defect (AGENTS.md §0). If your project has different role names, map them to the
> responsibilities described here, not just the titles.

---

## AGENTS.md — the agent rulebook
**Owner: Enterprise Architect (or Lead Solution Architect)**
**Supported by: all leads listed below**

This file sets the non-negotiable engineering discipline for every build using this harness.
Changes to it affect every project — treat it like a policy change. The enterprise architect
owns the invariants and quality bar; the leads named below own the sections that touch their
domain (security, build, AI, etc.).

---

## docs/agent/00-mission.md — what we are building and why
**Owner: Product Owner**
**Supported by: Customer Journey Manager, Solution Architect**

The product owner decides what the app does and who it is for. The customer journey manager
confirms the user journey is accurate. The solution architect confirms the non-goals are
technically sound and the success criteria are measurable.

Update when: scope changes, a stakeholder redefines the product purpose, or acceptance of
the app shifts.

---

## docs/agent/01-architecture-rules.md — tech stack, hard rules, and switch-off rules
**Owner: Solution Architect**
**Supported by: Enterprise Architect (hard rules), DevOps (stack / deployment), Security (security baseline)**

The solution architect owns the choice of stack, service boundaries, and project-specific
hard rules. The enterprise architect reviews any new hard rule that would affect the
invariants in AGENTS.md. DevOps confirms the deployment target and build tooling. Security
reviews the security-baseline row in the switch-off rules table.

Update when: stack changes, a new hard rule is added, or a switch-off rule status changes.

---

## docs/agent/02-build-plan.md — phases and build/test commands
**Owner: DevOps Engineer**
**Supported by: Software Engineer (commands), Quality Engineer (test commands)**

DevOps owns the CI/CD pipeline, build stages, and the command table. Software engineers
confirm the build and unit-test commands are correct. Quality engineers confirm the test,
lint, secret-scan, and UI-smoke commands are correct and complete.

Update when: a build step changes, a new check is added, a tool is replaced.

---

## docs/agent/03-backlog.md — the ordered to-do list
**Owner: Product Owner**
**Supported by: Software Engineer (technical sizing), Customer Journey Manager (feature acceptance)**

The product owner decides what to build and in what order. Software engineers can flag
items that are too large or technically unclear. Customer journey managers confirm that
user-facing items deliver the right experience.

Update when: priorities change, a new feature is agreed, or an item is found to be wrong
after it is built.

---

## docs/agent/04-acceptance-criteria.md — the five checks for done
**Owner: Quality Engineer**
**Supported by: Product Owner (Functionality), Security (Security bucket), DevOps (SLA/RTO buckets)**

The quality engineer owns the overall acceptance framework and writes the Resilience and
Security checks. The product owner confirms the Functionality criteria match the agreed
requirements. Security colleagues review and sign off the Security bucket. DevOps sets the
SLA and RTO targets.

Update when: a new path is built, a bucket is found to be incomplete after a release, or
targets change.

---

## docs/agent/05-scenarios.md — real examples with expected results
**Owner: Customer Journey Manager**
**Supported by: Product Owner (scope), Quality Engineer (test coverage)**

The customer journey manager writes and maintains the scenarios — they represent real user
journeys and must reflect how customers actually use the app. The product owner confirms
they are in scope. The quality engineer checks each scenario maps to at least one test.

Update when: a user journey changes, a new scenario is agreed, or a scenario is found to
produce the wrong result.

---

## docs/agent/06-integration-and-stack.md — every system the app connects to
**Owner: Integration Specialist (Integrator)**
**Supported by: Solution Architect (design), DevOps (infrastructure), Security (transport/auth)**

The integrator owns the record of every external system and protocol — databases, queues,
event streams, APIs, file transfer, data lake, etc. They maintain the per-pattern checklist
and raise dependency changes to the project team. The solution architect confirms the
design decisions. DevOps confirms infrastructure choices. Security reviews transport and
authentication for each interface.

Update when: a new integration is added, a dependency is replaced, or a checklist item
is found to be incomplete.

---

## docs/agent/07-security-and-secrets.md — data classification and where secrets live
**Owner: Security Engineer / Information Security**
**Supported by: Solution Architect (architecture), DevOps (secret injection/rotation), Enterprise Architect (policy alignment)**

The security engineer owns this file completely — it translates the bank's information
security policy into project-specific controls. No change to this file is valid without
security sign-off. The solution architect confirms the classification aligns with the
system design. DevOps confirms the runtime injection and rotation paths are correct.

Update when: the bank's security policy changes, a new secret or data type is added, a
vault or KMS is replaced, or a compliance review identifies a gap.

---

## docs/agent/08-ai-model-risk.md — AI/ML component governance
**Owner: Solution Architect (or AI/ML Engineer where one exists)**
**Supported by: Security (redaction, injection), Quality Engineer (test coverage), Enterprise Architect (model-risk policy)**

If the app has no AI/ML component, this file is marked "not applicable" and has no active
owner. Where it does apply, the solution architect (or AI/ML engineer) owns the model
boundary, governance, and fallback design. Security reviews redaction and injection
defences. The quality engineer confirms the test coverage listed is real and current.

Update when: a model is changed or upgraded, the prompt is changed, a new input type
reaches the model, or a governance review identifies a gap.

---

## docs/agent/09-traceability.md — rule → test → proof matrix
**Owner: Quality Engineer**
**Supported by: Solution Architect (which rules apply), Software Engineer (which tests cover them)**

The quality engineer keeps this matrix current as work lands — every completed backlog item
that touches a control must have a row here. The solution architect confirms the right
controls are listed. Software engineers confirm the test names and file paths are correct.

This file is the answer to an auditor asking "show me the test that proves this control."
Treat it as a compliance document.

Update when: a new control or scenario is added, a test is renamed or moved, or a gap is
identified.

---

## docs/agent/STATE.md — live summary of where the build stands
**Owner: Whoever is running the build (usually the lead Software Engineer or Tech Lead)**

This is a working document, not a governance document. The agent rewrites it after every
item. The build lead keeps it honest — if it says "no blockers" and there are blockers,
that is a problem.

---

## docs/agent/history.md — add-only record of everything done
**Owner: Software Engineer (maintained by the agent; reviewed by Tech Lead)**

The agent appends to this file; no human should rewrite it. The tech lead reviews it at
each phase boundary to confirm the evidence column is real, not asserted.

---

## docs/agent/org-runbook.md — your organisation's engineering standards
**Owner: Enterprise Architect**
**Supported by: Security (security standards), DevOps (pipeline/deployment standards)**

This file carries the organisation's engineering policy that supplements the harness. The
enterprise architect owns it. It may only make rules stricter, never weaker (AGENTS.md).

Update when: org policy changes, a new standard is adopted, or a policy review occurs.

---

## docs/agent/adr/ — decision records
**Owner: whoever made the decision**
**Reviewed by: Solution Architect (technical), Enterprise Architect (if it affects policy)**

Each ADR is owned by the person or team who made the decision. Once accepted, an ADR is
never edited — changes are new ADRs that supersede the old one. The solution architect
reviews all ADRs touching architecture. The enterprise architect reviews any ADR that would
affect the invariants, policy, or the org-runbook.

---

## Summary table

| File | Primary owner | Supporting roles |
|------|--------------|-----------------|
| AGENTS.md | Enterprise Architect | All leads |
| 00-mission.md | Product Owner | Customer Journey Manager, Solution Architect |
| 01-architecture-rules.md | Solution Architect | Enterprise Architect, DevOps, Security |
| 02-build-plan.md | DevOps Engineer | Software Engineer, Quality Engineer |
| 03-backlog.md | Product Owner | Software Engineer, Customer Journey Manager |
| 04-acceptance-criteria.md | Quality Engineer | Product Owner, Security, DevOps |
| 05-scenarios.md | Customer Journey Manager | Product Owner, Quality Engineer |
| 06-integration-and-stack.md | Integration Specialist | Solution Architect, DevOps, Security |
| 07-security-and-secrets.md | Security Engineer | Solution Architect, DevOps, Enterprise Architect |
| 08-ai-model-risk.md | Solution Architect / AI Engineer | Security, Quality Engineer, Enterprise Architect |
| 09-traceability.md | Quality Engineer | Solution Architect, Software Engineer |
| STATE.md | Lead Software Engineer / Tech Lead | — |
| history.md | Software Engineer (agent-maintained) | Tech Lead (review) |
| org-runbook.md | Enterprise Architect | Security, DevOps |
| adr/ | Decision maker | Solution Architect, Enterprise Architect |
