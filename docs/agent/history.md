# History — Agent Activity Record (immutable)

Append one entry per completed/blocked backlog item. Never rewrite a past entry; corrections
are new entries. This is the build's own audit trail (AGENTS.md §8).

## Entry format
```text
YYYY-MM-DD HH:MM — Item <id>: <title>
Change: <what changed>
Files: <files touched>
Commands: <commands run + REAL outcomes>
Evidence: <test summary / build log / screenshot path>
Decisions: <ADR refs, if any>
Result: <passed / failed / blocked — and why>
Next: <next item>
Blockers: <none or detail>
```

<!-- Entries are appended below this line. -->
