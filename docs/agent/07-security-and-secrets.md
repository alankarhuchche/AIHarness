# 07 — Security, Secrets & Key Management (tier-1 production bar)

> Template + control baseline for a tier-1 international bank. The bank's information-security
> policy (referenced from `org-runbook.md`) is AUTHORITATIVE and may only make these controls
> STRICTER, never weaker. Where this file states a default, it is the minimum bar; record the
> bank's actual standard and approved tooling in the `<fill-in>` slots. Nothing here may relax
> an AGENTS.md INVARIANT or CORE rule.

## 0. Non-negotiables (CORE — apply to every change)
- Zero secrets in the repo, config files, container images, IaC, test fixtures, logs, traces,
  error messages, or AI prompts. Ever. Enforced by pre-commit hook + CI secret-scan gate +
  periodic full-history scan.
- Every secret and key has a recorded **data classification** and a single **approved store**
  matched to that classification (matrix in §2). No secret is stored below its required tier.
- Secrets are injected at runtime from the approved store — never baked into images, env files
  committed to source, or build args. Prefer short-lived/dynamic credentials over static ones.
- Workloads authenticate with **federated workload identity** (<fill-in: identity standard/
  mechanism>). No long-lived static cloud keys or shared service passwords.
- Crypto and secrets handling use vetted, approved libraries and managed services — never
  hand-rolled crypto, custom key derivation, or home-grown token formats.

## 1. Data classification (set the bank's actual scheme)
| Tier | Example data | Confidentiality |
|------|--------------|-----------------|
| <fill-in: Public> | marketing copy | low |
| <fill-in: Internal> | non-sensitive operational data | moderate |
| <fill-in: Confidential> | customer PII, account data | high |
| <fill-in: Highly Restricted / Secret> | PAN/SAD, cryptographic keys, credentials, auth secrets | highest |

## 2. Storage-by-classification matrix (the core rule)
For each secret/key, classification dictates where it lives and how it's protected.

| Data class | Secret/key store | At-rest encryption | Key custody | Access |
|------------|------------------|--------------------|-------------|--------|
| Internal | <fill-in: approved secrets manager> | provider-managed KMS | single-control | service identity, least privilege |
| Confidential (PII, account) | <fill-in: approved secrets manager + CMK> | customer-managed key (CMK) via KMS, envelope encryption | KMS-managed, rotated | role-based, JIT, fully audited |
| Highly Restricted (keys, PAN, root creds) | <fill-in: HSM-backed KMS + privileged-access vault (PAM)> | **HSM-protected** (FIPS 140-2/3 L3), envelope (KEK→DEK) | dual control + split knowledge (M-of-N) | break-glass only, JIT, dual approval, recorded |

- Root/key-encrypting keys (KEK) are HSM-resident and never leave the HSM in plaintext; data
  keys (DEK) are wrapped by the KEK (envelope encryption).
- Cardholder data: PAN tokenized/vaulted (PCI-DSS); sensitive auth data (CVV/PIN/track) is
  never stored; the tokenization vault is the only PAN trust boundary.
- Field-level encryption for the most sensitive fields even inside an encrypted store.

## 3. Key management lifecycle
- Hierarchy: HSM root → KEK → DEK; document it. Per-tenant/per-purpose keys where required.
- Rotation: every key/secret has a defined rotation period and an automated rotation path;
  rotation never requires downtime or a redeploy with embedded secrets.
- Revocation: compromised or leaked material is revoked and rotated immediately; dependent
  systems fail closed until re-keyed.
- Dual control & split knowledge for generation/export/destruction of Highly Restricted keys.
- Crypto-agility: approved-algorithm registry (TLS 1.2+/1.3 only, AES-GCM/AES-256, RSA-2048+/
  ECDSA P-256+, SHA-256+; no MD5/SHA-1/DES/RC4/3DES); algorithms are swappable without
  rewriting callers. Note post-quantum readiness as a forward item.

## 4. Transport & service-to-service
- TLS everywhere; **mTLS** for service-to-service inside the estate, certs issued by internal
  PKI with automated issuance/rotation (e.g. short-lived certs). No plaintext internal hops.
- Certificate private keys are Highly Restricted; stored per §2; never in the repo.

## 5. Privileged & human access
- Privileged credentials in a PAM / privileged-access vault; just-in-time, time-boxed, dual-
  approval for production; every retrieval audited. Break-glass is logged, alerted, post-reviewed.
- Separation of duties: the identity that writes code cannot unilaterally read production
  secrets; environment isolation — production secrets/keys never exist in non-prod.

## 6. Pipeline & supply chain
- Secret-scan (<fill-in: secret-scanning tool>) runs pre-commit AND as a blocking CI gate;
  a finding fails the build. Periodic scan of full git history.
- CI/CD authenticates to clouds via OIDC federation — no static deploy keys in the runner.
- SBOM + dependency/vuln scan; pin and verify dependencies (signatures/checksums).

## 7. Logging, redaction & AI boundary
- Secret-aware redaction at the logging boundary; tokens, keys, PAN and credentials are masked
  before any log/trace/metric/exception leaves the process.
- The AI/explanation service receives only the redacted decision record — never secrets, keys,
  PAN, or full PII (see AGENTS.md §1 and the redaction service in `01`).

## 8. Verification & evidence (per AGENTS.md §2)
A change touching secrets/keys is not done until:
- [ ] Secret-scan gate passes (paste output as evidence).
- [ ] Each new secret/key is recorded with its classification and approved store (§2).
- [ ] No secret in code/config/image/log — confirmed, not assumed.
- [ ] Rotation and revocation paths exist and are documented/tested.
- [ ] TLS/mTLS and approved algorithms verified on the touched path.
- [ ] Redaction confirmed: no sensitive value reaches logs, traces, or the AI boundary.

## Decision record
Capture key-management and secret-store choices as ADRs (AGENTS.md §0), referencing the bank
policy clause they satisfy.
