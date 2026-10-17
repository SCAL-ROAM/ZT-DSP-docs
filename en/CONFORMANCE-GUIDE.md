# Conformance Determination Guide

> Readers: auditors, regulators and compliance assessors.
> This document answers one question: does an implementation conform to ZT-DSP 1.0.0.

## A.1 Three levels

| Level | Condition |
|---|---|
| **Conformant** | Passes every item in Appendix C.1, every vector in Appendix J, and matches the Appendix F byte layout exactly |
| **Partially conformant** | Implements a subset of Volume 4 and lists every MUST it does not implement |
| **Not conformant** | Fails Appendix C.1, mismatches any vector, or deviates from Appendix F at the byte level |

The definitions come from Part 0, section 0.3. This document adds no requirement.

## A.2 Five audit steps

1. Take the implementation identifier the subject declares, in the form `<language>_<version>`.
2. Run every self-check item in Appendix C.1.
3. Run every test vector in Appendix J and compare output byte for byte.
4. Compare against the Appendix F byte layout. Look at bytes only, not at behaviour.
5. State the conclusion under A.1. The conclusion must name the implementation identifier and the document version judged.

## A.3 What the subject must supply

| Material | Use |
|---|---|
| Implementation identifier | Identifies the subject |
| Claimed document version | Decides which revision is judged |
| Vector pass record | Lets step 3 be rechecked |
| Source or executable | Lets step 4 be rechecked |

## A.4 Decision table

| IF | THEN |
|---|---|
| No implementation identifier | The claim does not stand and the subject is not judged |
| Any vector output mismatches | Not conformant |
| Any byte-level deviation from Appendix F | Not conformant |
| Subset implemented and the missing MUSTs are listed | Partially conformant |
| Subset implemented and the missing MUSTs are not listed | Not conformant |

## A.5 Commands an audit must run

An auditor needs a runnable binary, so the build is mandatory rather than optional.

1. Build the reference implementation: run `cargo build --release` in `ZT-DSP-client/zt_dsp_rs/`.
2. Run the test vectors: run `python -m pytest -q tests/test_vectors.py` in `ZT-DSP-client/zt_dsp_py/`.
3. Run the cross-implementation interop test: run `python interop_test.py` in `ZT-DSP-client/zt_dsp_rs/` and check that the last line reads `[[ok]] interop suite passed`.
4. Run this repository's structural self-check: run `python scripts/check.py` in `ZT-DSP-docs/` and check that all nine checks report PASS.

Every command names its working directory. Drop one and the step 4 conclusion cannot be reproduced.

## A.6 Outside the scope of determination

| Item | Note |
|---|---|
| Security strength | This document judges conformance, not security |
| Code quality | Unrelated to interoperability |
| Performance | The specification sets no performance target |
| Third-party patent status | See Appendix K and `en/DEFENSIVE-PUBLICATION.md` |

An audit conclusion must not reach beyond this table. Any judgement outside it does not stand.
