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

### Planned — not part of 1.0.0

Recorded so the intent is not lost. **None of this is implemented in 1.0.0**, and
1.0.0 remains authoritative until a later revision ships these:

- Time-slot driven rotation: one key generation per second rather than per packet.
- Lock packet: the same packet structure, sent on a fixed cadence so the chain keeps
  advancing when there is no message.
- Fragmented key material: the next generation carried as fragments across several
  packets and recoverable from a threshold of them.
- Loss tolerance of 30 slots before the session is declared dead.

The 1.0.0 behaviour is the opposite of the third and fourth items: a single lost packet
leaves the session irreversibly out of step and the only recovery is to reconnect.


## [1.0.0]

- Initial protocol specification, Chinese (`cn/`) and English (`en/`) mirrors.