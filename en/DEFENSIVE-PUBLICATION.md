# Defensive Publication Statement

> This file records a decision by the maintainers: **the ZT-DSP protocol will not be patented.**
> The point is not to sue anyone with a patent. It is to **stop someone else's patent from being used against this project and its users.**

## 1. The statement

The maintainers do not seek, and do not intend to seek, patent protection for the protocol
technology described in this repository, in the PRC or anywhere else.

The protocol is published as open documentation and an open implementation. **On the day of
publication the disclosed technology becomes prior art** (Patent Law, Article 22: prior art
means technology known to the public anywhere in the world before the filing date).

## 2. Why

For one reason: **if someone asserts a patent against this project, the maintainers and users
need something to stand on.**

The current Patent Law supplies two grounds:

| Article | Substance | Effect |
|---|---|---|
| **67** | In an infringement dispute, an accused party who proves the technology it practises is prior art does not infringe | Prior-art defence |
| **75** | Lists acts not treated as infringement; item (4) is prior user rights — a party already using the same process before the filing date may continue within its original scope | Prior user rights |

Both defences rest on the same premise: **you can prove the technology was public or in use
before a given day.** So publish early, and keep the evidence.

## 3. Evidence to fix at first publication

| Item | How |
|---|---|
| Moment of publication | The server-side timestamp; keep a local copy too |
| Commit | The full SHA of the commit that first goes public |
| Tag | A tag such as `v1.0.0`; an annotated tag is better because it carries time and author |
| Content fingerprint | SHA256 of the specification text and of each release artifact |
| Channel | Repository URL, whether a Release was published, whether Pages went live |
| Third-party record | A trusted timestamp or an archived copy with a DOI; optional, but stronger |

This is not ceremony. Articles 67 and 75 both require **proof**; without it the defence does not exist.

## 4. What this statement does not mean

- **It does not affect copyright.** The specification text stays under CC BY-SA 4.0; see `LICENSE` and `LICENSING.md`.
- **It does not affect trademarks.** Rights in the ZT-DSP name and logo are in `TRADEMARK.md`.
- **It is not a warranty about third-party patents.** It says the maintainers seek no patent of their own. It does not say that implementing this protocol avoids everyone else's patents. Users assess that themselves.

## 5. One limit you must know

Defensive publication only blocks patents whose **filing date falls after your publication date**.

If someone filed for the same technology before you published, this publication does not stop
them. In that situation you need the prior-art defence under Article 67, not this statement.

Which is exactly why the evidence in section 3 has to be collected from the start rather than
reconstructed after a dispute begins.

---

Provisions cited: the Patent Law of the PRC as amended in 2020, Articles 22, 24, 67 and 75.

This file is not legal advice.
