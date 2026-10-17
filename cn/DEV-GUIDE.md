# 开发与验证指南

> 读者：协助者、下游集成方。
> 本文件只回答一件事：改完之后怎么证明改动是好的。

## B.1 环境

| 项 | 要求 |
|---|---|
| Python | 3.9 或更高 |
| Rust | stable，1.70 或更高 |
| 打包工具 | `python -m pip install build` |

## B.2 构建

1. 装 Python 包：在 `ZT-DSP-client/zt_dsp_py/` 下跑 `python -m pip install -e .`。
2. 构建 Rust 可执行文件：在 `ZT-DSP-client/zt_dsp_rs/` 下跑 `cargo build --release`。
3. 打发布包：在 `ZT-DSP-client/zt_dsp_py/` 下跑 `python -m build`。

## B.3 四道门

改动只有四道门全绿才算完成。

| 门 | 命令与工作目录 | 通过标准 |
|---|---|---|
| 单元测试 | `ZT-DSP-client/zt_dsp_py/` 下 `python -m pytest -q` | 无 failed |
| 测试向量 | 同目录 `python -m pytest -q tests/test_vectors.py` | 全通过 |
| 跨实现互通 | `ZT-DSP-client/zt_dsp_rs/` 下 `python interop_test.py` | 末行 `[[ok]] interop suite passed` |
| 结构自检 | `ZT-DSP-docs/` 下 `python scripts/check.py` | 九项全 PASS |

互通那一道门依赖 B.2 第 2 步的二进制。没构建就没有互通。

## B.4 改动红线

| 不可动 | 原因 |
|---|---|
| 线上字段名（`random_len`、`next_seed`、`session_salt` 等） | 已冻结，改名等于改协议 |
| 附录 F 的字节布局 | 互操作依赖它，逐字节 |
| 实现标识格式 `<语言>_<版本>` | 符合性判定依赖它 |

## B.5 提交前

1. 四道门全绿。
2. 每个提交加 `-s` 签名：`git commit -s`。
3. 在 `CONTRIBUTORS.md` 加一行 CLA 记录，与代码同一个提交。
4. 派生版改名前先读 `TRADEMARK.md`。

## B.6 常见失败

| 现象 | 先查 |
|---|---|
| 互通失败 | 两侧是否都按同一文档版本构建 |
| 测试向量失败 | 是否动了附录 F 的字节布局 |
| 结构自检失败 | 报告里点名的那一项，逐条改 |
| 打包失败 | 是否装了 `build`，`pyproject.toml` 的 `license-files` 是否指向存在的文件 |
