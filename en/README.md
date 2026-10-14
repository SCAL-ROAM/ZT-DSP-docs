# ZT-DSP Protocol Documentation

> The specification for the current protocol. The authoritative text is `en/spec/ZT-DSP_1.1.0_Master_Guide.md` (docs version 1.1.0).
>
> **How this repository relates to the implementations**: the specification defines the protocol behaviour and tunable parameters; each implementation declares at its entry point which guide it applies to, and each guide lists the client and server versions it applies to. The relation is **many-to-many**, not bound by version numbers.

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
│  ├─ spec/ZT-DSP_1.1.0_总指导.md      the specification (the only current revision)
│  └─ 术语对照表.md                    Chinese-to-English terminology baseline
├─ en/                       English side (mirrors cn/ document by document)
│  ├─ spec/ZT-DSP_1.1.0_Master_Guide.md
│  └─ Glossary.md
└─ .github/                  issue forms and the Pages workflow
```

## spec/ — the specification

The current revision is **docs 1.1.0**, and it is the **only** specification file this repository carries. It applies to the client versions `ZT-DSP_PY-1.1.0` / `ZT-DSP_RS-1.1.0` and to the server version `ZT-DSP_SV-1.1.0` (placeholder).

| File | Content |
|------|---------|
| `cn/spec/ZT-DSP_1.1.0_总指导.md` | **Protocol Master Guide** (Chinese side). Book Four core protocol, Appendix B parameters, Appendix C implementation checklist, Appendix F byte-level on-wire specification, Appendix G traffic-defence details, Appendix H state machine and timeout matrix. |
| `en/spec/ZT-DSP_1.1.0_Master_Guide.md` | The same, on the English side. |

## Bilingual mirroring

`cn/` and `en/` correspond document by document. **A one-sided change is a defect**, not a contribution.

## Terminology baseline

| File | Purpose |
|------|---------|
| `cn/术语对照表.md` | Chinese-to-English terminology baseline |
| `en/Glossary.md` | English-to-Chinese terminology baseline |

These two files are the single authoritative source of terminology.

## Versions

The project has **three kinds of version number** and one **two-way declaration** between documents and implementations:

- **total-guide version (1.1.0)** — the revision number of this documentation repository, written `docs 1.1.0`. It never appears on the wire.
- **client version** — the full identifier of a client implementation, `ZT-DSP_<language prefix>-<major.minor.patch>` — `ZT-DSP_PY-1.1.0` for Python, `ZT-DSP_RS-1.1.0` for Rust. Implementations in different languages may share a version number and are distinguished by the prefix.
- **server version** — the full identifier of a server implementation, `ZT-DSP_SV-1.1.0` (repository `ZT-DSP-server`, placeholder, not implemented yet). `SV` is a role prefix, not a language prefix.
- **Two-way declaration** — the document side (the head of `spec/`) lists **the client and server versions to which it applies** and declares which settings it governs; the implementation side (`FOLLOWS_DOC` and `APPLIES_TO_DOC_VERSIONS` in `zt_dsp_py/version.py`) declares which document it applies to. **The two are not bound by version numbers.**

**Applicability is many-to-many, not one-to-one**: several implementations of the same kind whose protocol behaviour has not changed share one applicability declaration, and the same guide may apply to several client and server versions at once. **Identical version numbers do not mean the same implementation and do not constitute a compatibility claim.**

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
