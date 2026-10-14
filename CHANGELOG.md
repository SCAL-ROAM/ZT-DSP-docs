# Changelog

All notable changes to this repository are recorded here.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this
project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

**Note on authority:** this file is a convenience record, not the source of truth. The
authoritative change history is `git log`. If the two ever disagree, `git log` wins.

This repository holds the protocol specification. It has **no automated tests** — it is
a normative document. What is checked mechanically is that the two language mirrors
stay in step and that CI itself remains runnable; see the pull request checklist.

## [Unreleased]

### Added

- `CHANGELOG.md`, `CODE_OF_CONDUCT.md`, a pull request template, and `dependabot.yml`
  for GitHub Actions.

## [1.1.0] - 2026-10-14

### Added

- **Protocol version negotiation (Appendix B / F.1).** The parameter JSON carries a mandatory
  `proto` field. Because it travels inside the Phase 1 frame it is covered by the handshake
  transcript and therefore by the Phase 3 confirmation tags. A peer that omits `proto`
  (1.0.0 or earlier) is judged parameter-invalid and dropped; there is no fallback guess.
  `proto_version` is the first item in the F.1 parameter comparison.
- **Session key length floor.** `key_len` must be at least 256 bits, enforced on
  peer-supplied values as well as local ones.

### Changed

- Parameter JSON is 136 bytes under the default parameters (was 120); the Phase 1 frame is
  244 bytes (was 228). Both are published byte-exactly in F.1.
- The "handshake frames carry no version string" statement now applies to the Phase 4 AAD
  only; the Phase 1 parameter JSON does carry the version. Both language mirrors updated.

### Not changed (deliberately)

- The data-plane ratchet remains a symmetric hash chain: **no post-compromise security**. The
  specification states this explicitly rather than leaving it implied.
## [1.0.0]

- Initial protocol specification, Chinese (`cn/`) and English (`en/`) mirrors.