# ZT-DSP Protocol Documentation

> The specification for the current protocol. The authoritative text is `en/spec/ZT-DSP_1.0.0_Master_Guide.md` (docs version 1.0.0).
>
> **How this repository relates to the code repository**: the specification defines the protocol behaviour and tunable parameters of the code side; the code side declares at its entry point that it follows the *ZT-DSP Protocol Master Guide*. The two are not bound by version numbers.

This repository carries **documentation only**; the official implementations and runtime code live in the separate `ZT-DSP-client` repository.

## Layout

```
ZT-DSP-docs/
├─ README.md                 this index
├─ LICENSE                   dual-licence index: MIT OR Apache-2.0
├─ LICENSE-MIT / LICENSE-APACHE
├─ SECURITY.md               security policy and vulnerability reporting
├─ CITATION.cff              citation metadata
├─ _config.yml               GitHub Pages configuration
├─ cn/                       Chinese side
│  ├─ spec/ZT-DSP_1.0.0_总指导.md      the specification (the only current revision)
│  └─ 术语对照表.md                    Chinese-to-English terminology baseline
├─ en/                       English side (mirrors cn/ document by document)
│  ├─ spec/ZT-DSP_1.0.0_Master_Guide.md
│  └─ Glossary.md
└─ .github/                  issue forms and the Pages workflow
```

## spec/ — the specification

The current revision is **docs 1.0.0**, and it is the **only** specification file this repository carries.

| File | Content |
|------|---------|
| `cn/spec/ZT-DSP_1.0.0_总指导.md` | **Protocol Master Guide** (Chinese side). Book Four core protocol, Appendix A terminology, Appendix B parameters, Appendix C implementation checklist, Appendix D revision notes, Appendix E client usage guide, Appendix F byte-level on-wire specification, Appendix G traffic-defence details, Appendix H state machine and timeout matrix. |
| `en/spec/ZT-DSP_1.0.0_Master_Guide.md` | The same, on the English side. |

## Bilingual mirroring

`cn/` and `en/` correspond document by document. **A one-sided change is a defect**, not a contribution.

## Terminology baseline

| File | Purpose |
|------|---------|
| `cn/术语对照表.md` | Chinese-to-English terminology baseline |
| `en/Glossary.md` | English-to-Chinese terminology baseline |

The Guide's Appendix A and these two files together define terminology authoritatively.

## Versions

The project has **two version numbers** and one **two-way declaration** between documents and code:

- **docs version (1.0.0)** — the revision number of this documentation repository, written `docs 1.0.0`. It never appears on the wire.
- **code version (1.0.0)** — the implementation and protocol-behaviour version of the code repository, written `code 1.0.0`. A concrete implementation is named by its implementation identifier, `ZT-DSP_<language prefix>-<major.minor.patch>` — `ZT-DSP_PY-1.0.0` for Python, `ZT-DSP_RS-1.0.0` for Rust. Implementations in different languages may share a version number and are distinguished by the prefix.
- **Two-way declaration** — the document side (the head of `spec/`) declares which code settings it governs; the code side (`FOLLOWS_DOC` in `zt_dsp_py/version.py`) declares which document it follows. **The two are not bound by version numbers.**

**No version string travels in the handshake frames**: neither the phase-one parameter JSON nor the phase-four AAD carries a version or protocol identifier. Whether the peer follows the same document is settled by the phase-three confirmation tag.

**The current revision rules**: implementations are judged against Appendix F (byte-level on-wire specification) and Appendix H (state machine and timeout matrix).

## Repository boundary

- **This repository (ZT-DSP-docs)**: protocol specification, terminology baselines, design assets, repository configuration.
- **The code repository (ZT-DSP-client)**: the official implementations `zt_dsp_py/` (Python) and `zt_dsp_rs/` (Rust), plus run scripts and engineering files.
- **The server repository (ZT-DSP-server)**: a skeleton for the server side — placeholder documentation only, **implementation not started**; its version tags follow `server-v*`.
- Paths such as `zt_dsp_py/` and `zt_dsp_rs/` appearing in the documentation refer to the official implementation directories **inside the code repository**, not to this one.
- Nothing is carried across: documentation changes go here, code changes go to the code repository, server changes go to the server repository.

## Licence

This project is licensed under **MIT** and **Apache-2.0**; a user may choose either one (not "both at once"). See `LICENSE`, `LICENSE-MIT` and `LICENSE-APACHE`.
