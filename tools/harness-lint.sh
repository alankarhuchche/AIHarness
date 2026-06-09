#!/usr/bin/env sh
# harness-lint — verifies the harness is internally consistent.
# Structural checks always run. Fill-in completeness is enforced only once a project
# marks itself instantiated by creating a `.harness-instantiated` file at the repo root.
#
# Usage: sh tools/harness-lint.sh        (run from repo root)
# Exit non-zero on any failure, so it can gate CI / pre-commit.

set -eu
fail=0
note() { printf '%s\n' "$1"; }
err()  { printf 'FAIL: %s\n' "$1"; fail=1; }

# 1. Required files exist.
required="AGENTS.md README.md INSTANTIATING.md \
docs/agent/00-mission.md docs/agent/01-architecture-rules.md docs/agent/02-build-plan.md \
docs/agent/03-backlog.md docs/agent/04-acceptance-criteria.md docs/agent/05-scenarios.md \
docs/agent/06-integration-and-stack.md docs/agent/07-security-and-secrets.md \
docs/agent/08-ai-model-risk.md docs/agent/09-traceability.md \
docs/agent/STATE.md docs/agent/history.md docs/agent/org-runbook.md docs/agent/adr/0000-template.md"
for f in $required; do
  [ -f "$f" ] || err "missing required file: $f"
done

# 2. Cross-references to docs/agent/NN-*.md must resolve.
refs=$(grep -rhoE 'docs/agent/[0-9]{2}-[a-z-]+\.md' . --include='*.md' 2>/dev/null | sort -u || true)
for r in $refs; do
  [ -f "$r" ] || err "broken doc reference: $r"
done

# 3. Fill-in completeness — only when the project declares itself instantiated.
if [ -f ".harness-instantiated" ]; then
  must_fill="docs/agent/00-mission.md docs/agent/01-architecture-rules.md \
docs/agent/02-build-plan.md docs/agent/03-backlog.md docs/agent/05-scenarios.md \
docs/agent/07-security-and-secrets.md"
  for f in $must_fill; do
    if grep -q '<fill-in' "$f" 2>/dev/null; then
      err "unfilled <fill-in> remaining in $f"
    fi
  done
else
  note "note: .harness-instantiated not present — skipping fill-in checks (template mode)."
fi

if [ "$fail" -eq 0 ]; then
  note "harness-lint: OK"
else
  note "harness-lint: FAILED"
fi
exit "$fail"
