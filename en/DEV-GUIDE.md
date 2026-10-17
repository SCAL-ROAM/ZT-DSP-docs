# Development and Verification Guide

> Readers: contributors and downstream integrators.
> This document answers one question: after a change, how do you show the change is good.

## B.1 Environment

| Item | Requirement |
|---|---|
| Python | 3.9 or later |
| Rust | stable, 1.70 or later |
| Packaging tool | `python -m pip install build` |

## B.2 Build

1. Install the Python package: run `python -m pip install -e .` in `ZT-DSP-client/zt_dsp_py/`.
2. Build the Rust executable: run `cargo build --release` in `ZT-DSP-client/zt_dsp_rs/`.
3. Build the release artifacts: run `python -m build` in `ZT-DSP-client/zt_dsp_py/`.

## B.3 Four gates

A change is done only when all four gates are green.

| Gate | Command and directory | Pass condition |
|---|---|---|
| Unit tests | `python -m pytest -q` in `ZT-DSP-client/zt_dsp_py/` | No failures |
| Test vectors | `python -m pytest -q tests/test_vectors.py` in the same directory | All pass |
| Cross-implementation interop | `python interop_test.py` in `ZT-DSP-client/zt_dsp_rs/` | Last line reads `[[ok]] interop suite passed` |
| Structural self-check | `python scripts/check.py` in `ZT-DSP-docs/` | All nine checks PASS |

The interop gate depends on the binary from B.2 step 2. No build means no interop.

## B.4 Red lines

| Do not touch | Why |
|---|---|
| Wire field names (`random_len`, `next_seed`, `session_salt` and the rest) | Frozen; renaming them changes the protocol |
| The Appendix F byte layout | Interoperability depends on it byte for byte |
| The implementation identifier form `<language>_<version>` | Conformance determination depends on it |

## B.5 Before committing

1. All four gates green.
2. Sign every commit: `git commit -s`.
3. Add a CLA line to `CONTRIBUTORS.md` in the same commit as the change.
4. Read `TRADEMARK.md` before renaming a derived work.

## B.6 Common failures

| Symptom | Check first |
|---|---|
| Interop fails | Whether both sides were built against the same document version |
| A test vector fails | Whether the Appendix F byte layout was changed |
| The structural self-check fails | The item named in the report; fix it item by item |
| Packaging fails | Whether `build` is installed and `license-files` in `pyproject.toml` points at files that exist |
