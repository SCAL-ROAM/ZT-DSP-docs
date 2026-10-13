# Pull requests

This repository is the normative specification. Code and spec are separate
repositories and neither pulls from the other, so a change here is the only way a
protocol change becomes real.

## Before you open

- [ ] **Both mirrors updated.** `cn/` and `en/` describe the same protocol. A change
      present in only one is a specification defect, not a translation debt.
- [ ] The change is reflected in the implementations in `ZT-DSP-client`, or the PR says
      explicitly that it is spec-only.

## What reviewers will ask

**Did you change a normative value?** Cipher suite, key derivation, frame layout, HKDF
labels, or length limits are byte-for-byte surface that both implementations pin in
their test vectors. A spec change here without a corresponding implementation change
leaves the two disagreeing, and only the cross-implementation tests will catch it.

**Did you change one mirror only?** That is the single most common defect in this
repository. Please check both before opening.

**Did you renumber a section?** Cross-references inside the document point at section
numbers. Renumbering breaks them silently.

**Is `1.0.0` still accurate?** The declared documentation version, and the statement
that TPM/HWID are not implemented in 1.0.0, must stay true. If either changes, say so
explicitly in the PR.