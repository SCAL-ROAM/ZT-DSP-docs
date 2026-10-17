# Contributing to ZT-DSP-docs

This repository contains the ZT-DSP protocol specification.

## Before you open a pull request

This project is **dual-licensed** (see [LICENSING.md](LICENSING.md)). That model
only works if the maintainers hold, or are granted, the rights needed to license
every contribution under both the open-source license and a commercial license.

**Contributions are accepted only under the Contributor License Agreement below.**
If you do not agree to it, please open an issue instead of a pull request.

## How to accept the CLA

You must do two things, in the same pull request.

1. Sign off every commit:

```
git commit -s
```

2. Add one line to [CONTRIBUTORS.md](CONTRIBUTORS.md):

```text
- <your name> <your-email> - CLA accepted <YYYY-MM-DD>
```

The committed line is the record. It is visible in git history, it survives the
pull request being deleted, and it is what the maintainers will point to if the
question of rights ever comes up. A line left only in a pull request description
is not enough.

Opening the pull request means you accept the agreement below, for that
contribution and for every later contribution you make to this repository.

## What we will not merge

- Any file whose copyright header or `SPDX-License-Identifier` line has been removed or altered.
- Code copied from a project whose license is incompatible with AGPL-3.0-or-later.
- Contributions you do not have the right to license.

---

# Contributor License Agreement (CLA)

This agreement is between you ("You") and the ZT-DSP Suite maintainers ("the Maintainers").

**1. You keep your copyright.** You retain all right, title and interest in your
contribution. Nothing here transfers ownership.

**2. Copyright license.** You grant the Maintainers a perpetual, worldwide,
non-exclusive, royalty-free, irrevocable copyright license to reproduce, prepare
derivative works of, publicly display, publicly perform, sublicense, and
distribute your contribution and such derivative works, **under any license
terms the Maintainers choose, including the GNU Affero General Public License
v3.0 or later and a separate commercial license.**

**3. Patent license.** You grant the Maintainers and all recipients of the
software a perpetual, worldwide, non-exclusive, royalty-free, irrevocable patent
license to make, use, sell, offer for sale, import and otherwise transfer your
contribution, limited to those patent claims licensable by You that are
necessarily infringed by your contribution alone or by its combination with the
project.

**4. You have the right to grant this.** You represent that you are legally
entitled to grant the licenses above, that the contribution is your original
work or is submitted with the original author's permission, and that, to your
knowledge, it does not violate anyone else's rights.

**5. No warranty.** Contributions are provided "as is", without warranty of any
kind, to the extent permitted by law.

**6. Moral rights.** To the extent permitted by law, You waive and agree not to
assert any moral rights in your contribution that would prevent the Maintainers
from exercising the rights granted above.

---

## 中文摘要

本仓采用**双轨授权**，因此外部贡献必须授予维护方**转授权**的权利，否则维护方
无法把该贡献纳入商业授权。

你不转让版权，仍署你的名；但你授予维护方永久、不可撤回的许可，可按任意条款
（含 AGPL-3.0-or-later 与商业授权）再发布你的贡献。

**接受方式**：在 PR 描述里加一行 `CLA-Agreed: yes`，并给每个提交加
`git commit -s` 的 DCO 签名。不同意就不要发 PR，改开 issue。

维护方不会合并：删除或改动版权头/SPDX 行、从许可不兼容的项目拷贝来的代码、
以及你无权授权的贡献。
