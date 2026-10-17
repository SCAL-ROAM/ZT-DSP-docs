# ZT-DSP 协议文档

**中文** ｜ [English](en/README.md) ｜ [术语对照表](cn/术语对照表.md)

> ZT-DSP 是一个在网络不可信前提下建立可信通信的协议。本仓库是它的文档仓库。

## 目录结构

本仓库的文档以**双语镜像**方式组织：

| 目录 | 说明 |
|---|---|
| `cn/` | 中文文档（规范正文、术语对照） |
| `en/` | English documentation — 每份文档都有对应英文版 |

英文版与中文版一一对应，对应关系如下：

| 中文 | English |
|---|---|
| `cn/README.md` | `en/README.md` |
| `cn/术语对照表.md` | `en/Glossary.md` |
| `cn/DEFENSIVE-PUBLICATION.md` | `en/DEFENSIVE-PUBLICATION.md` |
| `cn/spec/ZT-DSP-1.0.0-总指导.md` | `en/spec/ZT-DSP-1.0.0-Master_Guide.md` |

新增或修改文档时，两侧必须同步；**只改一侧视为缺陷，不视为贡献**。

## 从哪里开始

- 想读协议规范 → `cn/spec/ZT-DSP-1.0.0-总指导.md` ／ `en/spec/ZT-DSP-1.0.0-Master_Guide.md`

## 相关仓库

| 仓库 | 内容 | 版本标签 |
|---|---|---|
| `ZT-DSP-docs` | 本仓库：协议规范、术语基线 | `docs-v*` |
| `ZT-DSP-client` | 官方实现：`zt_dsp_py/`（Python，实现标识 `ZT-DSP_PY-1.0.0`）与 `zt_dsp_rs/`（Rust，实现标识 `ZT-DSP_RS-1.0.0`） | `client-v*` |
| `ZT-DSP-server` | 服务端实现骨架（占位，**尚未开始实现**） | `server-v*` |

## 许可

本仓库的规范正文以 **CC BY-SA 4.0**（署名—相同方式共享）授权：照规范写实现不受限制，引用与翻译须署名，改过的规范必须同样开放。详见 [LICENSING.md](LICENSING.md) 与 [LICENSE](LICENSE)。
