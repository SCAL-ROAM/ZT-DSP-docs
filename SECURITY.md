# Security Policy

This repository holds the ZT-DSP protocol specification.
Reports about the protocol text itself are as welcome as reports about an implementation.

## Supported versions

| Version | Supported |
|---|---|
| docs 1.0.0 | yes |
| earlier revisions | no |

## Reporting a vulnerability

Preferred channel: **GitHub private vulnerability reporting** ("Security" tab -> "Report a vulnerability").

If that is unavailable, open a minimal issue asking for a private channel **without exploit
details**; the maintainer will reply with one.

Please state whether the issue concerns the protocol design, the normative text (quote the
section), or an implementation, and include a precise argument or reproduction.

## Scope notes

- A design question such as "an injected packet terminates the session" is a **known, deliberate**
  fail-closed tradeoff. Report it only with a
  countermeasure that preserves the nonce guarantees.
- Content that is explicitly theoretical or non-normative is flagged as such in the text; a
  defect there is still a documentation defect and worth reporting.

## Secrets

No credentials belong in this repository. Do not open a pull request containing a key, password
or private path -- even a test one.
