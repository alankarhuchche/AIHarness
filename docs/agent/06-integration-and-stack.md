# 06 — Integration & Tech-Stack Considerations

> Template + checklist. Payments applications touch many integration styles, each with its
> own correctness, ordering, security and recovery traps. For each section: state whether the
> project uses it (Used / Not used), the chosen technology, and confirm the harness
> considerations are met (they are NOT optional where the pattern is used — they map to
> AGENTS.md §1 invariants and §2 Core/Conditional rules).
>
> Declaring scope (optional but removes guesswork): start any section with `Scope: Used` or
> `Scope: Not used`. An explicit `Not used` is authoritative — that component is not built and
> the agent won't ask about it (AGENTS.md §2.5). Leave it blank to decide at the kickoff
> scope read-back instead.
>
> Golden rule for anything that moves value AND emits an event/message/file: use the
> **transactional outbox** pattern (commit the state change and the outbound record in one
> local transaction; publish from the outbox) so you get effectively-once delivery without
> dual-write loss. "Exactly-once" across a network does not exist — achieve effectively-once
> via idempotent producers + idempotent/deduplicating consumers.

## A. Persistence (system of record)
- Used? <fill-in> · Technology: <fill-in: relational database>
- Considerations:
  - ACID transactions around value-affecting writes; optimistic locking for concurrent updates.
  - Idempotency-key store (request → result) so retried operations don't double-post.
  - Money as a precise decimal/typed amount — never floating point; currency always paired.
  - Ledger/posting model if applicable (double-entry, balanced postings, immutable journal).
  - Schema migrations are versioned, forward-only, and backward-compatible (via a migration tool).
  - Transactional outbox table for reliable event publication.

## B. Caching / fast state
- Used? <fill-in> · Technology: <fill-in: cache / in-memory store>
- Considerations: dedup / idempotency-key TTL store; rate-limit & velocity counters; never the
  source of truth for value state; cache invalidation has a defined consistency story.

## C. Event streaming
- Used? <fill-in> · Technology: <fill-in: event streaming platform>
- Considerations:
  - Idempotent producer; partition key chosen for required ordering (e.g. by account/payment).
  - Consumers idempotent and deduplicating; manual offset commit after successful processing.
  - Schema contract + registry (Avro/Protobuf/JSON Schema); compatibility rules enforced.
  - Dead-letter topic + poison-message handling; replay strategy; no PII in keys/headers.
  - Effectively-once via outbox + consumer dedup; document at-least-vs-exactly-once stance.

## D. Message queues / host integration
- Used? <fill-in> · Technology: <fill-in: message broker / queue>
- Considerations: at-least-once delivery → consumer dedup; DLQ + redelivery limits; FIFO/ordering
  where required; transactional send/receive with the DB where possible; mainframe/host MQ
  contracts versioned; poison-message quarantine.

## E. Synchronous APIs (outbound & inbound)
- Used? <fill-in> · Protocols: HTTPS/REST · gRPC · <fill-in>
- Considerations:
  - mTLS and/or OAuth2/OIDC; deny by default; least-privilege scopes.
  - Per-call timeout inside the path's SLA budget; bounded retries with backoff + idempotency
    key on writes; circuit breaker; rate-limit handling.
  - Inbound: validate/canonicalize at the boundary; authn/authz server-side; replay protection.
  - Outbound webhooks: signed payloads, retries with idempotency, consumer-side dedup.

## F. SOAP / legacy XML integration
- Used? <fill-in>
- Considerations: WS-Security / signed messages; strict schema (XSD) validation; XXE disabled;
  versioned WSDL contracts; map faults to typed/terminal-vs-retryable errors.

## G. File transfer / batch
- Used? <fill-in> · Mechanism: <fill-in: SFTP / managed file transfer (MFT)>
- Considerations:
  - Idempotent ingestion: dedup by file hash / sequence number; reject duplicates; control totals
    and record counts reconciled before processing.
  - Integrity & confidentiality: checksums, PGP/GPG encryption, signed manifests.
  - Restartable/checkpointed batch; cut-off times and value-date handling; partial-file safety.
  - Formats as applicable: ISO 20022 (pain/pacs/camt), ISO 8583, SWIFT MT/MX, SEPA, NACHA, BAI2.

## H. Data egress / analytics
- Used? <fill-in> · Target: data lake / lakehouse · warehouse · <fill-in>
- Considerations:
  - Change-data-capture (CDC) or batch export; schema contract with the lake; no dual-write of value
    state. Tokenize/mask PII before it leaves the trust boundary.
  - Clarify System of Record (authoritative) vs System of Engagement / System of Insight
    (derived, read-only); derived stores never write back value state.

## I. Cryptography & secrets
- Used? <fill-in>
- Considerations: HSM/KMS for keys; vault/tokenization for PAN/sensitive identifiers (PCI-DSS);
  field-level encryption where required; key rotation; no secrets in code/logs/traces/fixtures.
- Full control set (classification → store matrix, key lifecycle, mTLS/PKI, PAM, pipeline
  secret-scan, redaction): see `07-security-and-secrets.md`. That file is mandatory for any
  app handling credentials, keys, PAN or PII.

## J. Reference data, FX, calendars, limits
- Used? <fill-in>
- Considerations: BIC/IBAN/account validation; currency precision & rounding rules; business
  calendars, cut-offs and value dates; limit/velocity checks as controls (run before scoring).

## K. Reconciliation & exception management
- Used? <fill-in>
- Considerations: every value flow is reconciled end-to-end; breaks are detected, classified and
  worked; post-point-of-no-return issues go to servicing/investigation, never silent retry.

## L. Observability across boundaries
- Considerations: a single correlation/trace id propagates across HTTP, MQ, event-stream and file hops;
  metrics/SLOs per integration; structured logs without sensitive data; alerting on DLQ growth,
  reconciliation breaks, and SLA/RTO breaches.

## M. UI & test automation stack
- UI framework: <fill-in> · Design system/component library: <fill-in>
- Test automation: <fill-in: E2E / UI automation tool> · unit/integration: <fill-in>
- Considerations: UI smoke and scenario E2E are mandatory verification (AGENTS.md §2); capture a
  screenshot/clean console as evidence; accessibility and currency/locale formatting checked.

## Testing integrations without live infra
Local verification must not need live external systems (AGENTS.md §5), yet every integration
must still be tested. Use, in rough order of preference:
- **Ephemeral containers** — spin up a real DB/broker/queue in a throwaway container for the test,
  tear it down after. Closest to production behaviour for stateful infra.
- **Consumer-driven contract tests** — assert the request/response or message schema against a
  shared contract, so both sides stay compatible without a live partner.
- **In-memory fakes / stubs** — for third-party APIs and host systems you can't run locally;
  keep them behind the same interface as the real client.
- **Recorded-and-replayed interactions** — capture a real interaction once, replay deterministically
  in tests to assert call sequence and handling.
- **Sandbox endpoints** — only where a vendor provides one and no credential/secret is required
  locally; never point local tests at production.
Each integration names its chosen method in this file. "Can't test it locally" is not an excuse
to skip — pick one of the above.

## Cross-cutting checklist (every integration above must satisfy)
- [ ] Idempotent on retry; effectively-once where value or events are involved.
- [ ] Ordering/dedup strategy defined where it matters.
- [ ] Fails closed; retryable vs terminal errors distinguished; DLQ/quarantine for poison input.
- [ ] AuthN/Z + transport security (mTLS/TLS) at every boundary; input validated.
- [ ] Sensitive data classified, masked/tokenized before logs, analytics or third parties.
- [ ] Immutable audit event with correlation id for every material decision/transition.
- [ ] Recovery path + RTO defined; state replayable from the record of truth.
- [ ] Versioned contract (schema/WSDL/file layout) with compatibility rules.
