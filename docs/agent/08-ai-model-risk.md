# 08 — AI / Model Risk & Prompt-Injection Defence

> Template + control baseline. Applies to any non-deterministic component (LLM/ML) in the app
> — even one that "only explains". A tier-1 bank owes model-risk management and injection
> defence for any model in a customer or decision path. These controls support AGENTS.md §1
> ("AI assists only") and are mandatory where an AI/ML component exists.

## 0. Hard boundary (restates AGENTS.md §1 — the one place it lives)
The AI component may generate explanation/summary text only. It must never select, score,
approve, execute, or update a control or value-moving decision, and its output must never be
fed back as an instruction or a decision input. If the AI is unavailable or its output fails
validation, fall back to the deterministic template — never block or alter the decision.

## 1. Treat all model input as untrusted (prompt-injection defence)
- The model receives only the **redacted** decision record (no secrets, keys, PAN, full PII).
- Fields inside that record may be attacker-influenced (beneficiary name, reference text,
  free-text memo). Treat them as data, never as instructions.
- Do: wrap untrusted fields in clearly delimited, labelled input; instruct the model to ignore
  any instructions found inside data; prefer structured input over free prose.
- Don't: concatenate user/beneficiary text straight into the prompt; let model output choose a
  tool, route, or action; give the model any capability to act.

## 2. Validate model output before use
- Output is untrusted until checked. Do: constrain to an expected shape/length; allow-list or
  schema-validate; strip/escape before rendering (no HTML/script injection into the UI); verify
  it references only facts present in the decision record (no invented routes, amounts, fees).
- On validation failure or low confidence: discard and use the deterministic template.

## 3. Model governance (record, don't assume)
- Intended use, owner, and the model/version in use are documented.
- Inputs/outputs, prompt template, and config are versioned; changes go through review.
- Explanations are evaluated for factual accuracy and hallucination against the decision record
  (sampled or automated); record the method and acceptance threshold.
- Monitoring in production: track fallback rate, validation-failure rate, latency, and drift.
- Human oversight: a person can review/override AI text; the text is clearly labelled as
  AI-generated to the user where required.

## 4. Data protection at the AI boundary
- Redaction is enforced and tested (no secret/key/PAN/full-PII reaches the model or its logs).
- Prompts and responses, if logged, are themselves redacted; retention follows policy.
- If a third-party/hosted model is used, confirm data-handling, residency and no-training terms;
  record the approval. Prefer no data leaving the trust boundary unless explicitly approved.

## 5. Availability & cost
- Timeouts inside the path's SLA budget; bounded retries; circuit breaker; rate limits.
- Deterministic template fallback is always present and tested — the product works with the AI
  switched off.

## 6. Verification & evidence (per AGENTS.md §2)
A change touching the AI component is not done until:
- [ ] Redaction test proves no secret/key/PAN/full-PII reaches the model or its logs.
- [ ] Injection test: a malicious string in an untrusted field does not alter behaviour or leak.
- [ ] Output-validation test: malformed/oversized/hallucinated output is rejected → fallback.
- [ ] Fallback test: AI disabled/unavailable → deterministic template still produces a result.
- [ ] The AI has no path to select/score/approve/execute/update a decision (proven by test).

## Decision record
Capture model choice, hosting, and governance decisions as ADRs (AGENTS.md §0), referencing the
bank's model-risk policy clause they satisfy.
