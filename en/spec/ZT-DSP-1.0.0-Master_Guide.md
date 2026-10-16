# ZT-DSP Protocol Master Guide Library (1.0.0)

> **Generalisation proposal (2026-10-14, draft)**
> A proposal exists to lift ZT-DSP from a communication protocol to a **general-purpose one**: a core layer doing PSK-based
> mutual authentication and key agreement, independent of transport and application, with communication and
> authentication as profiles. The proposal text (a Chinese draft, pending review) is not included in this repository.
> **This file remains in force**; the proposal is unreviewed and does not replace it.

**Zero Trust Dynamic Synchronization Protocol**
(Zero Trust Dynamic Synchronization Protocol)

- **docs version**: 1.0.0 (the revision number of this document itself, not involved in network communication)
- **applicable client versions**: `ZT-DSP_PY-1.0.0` (Python), `ZT-DSP_RS-1.0.0` (Rust)
- **applicable server version**: `ZT-DSP_SV-1.0.0` (repository `ZT-DSP-server`, placeholder, not implemented yet)
- **Release date**: 2026-10-11
- **Document status**: **Public Test Release**
- **Content classification**: The main body of this specification is an implementation specification; sections marked [Theory] [Experimental] are ideas and do not mean they have been implemented or verified.
- **Maintaining team**: Protocol Founding Team

> **What this document is and what it governs** (two-way declaration · document side):
>
> - **This document**: the *ZT-DSP Protocol Master Guide*.
> - **Applies to**: This file specifies the protocol behavior and tunable parameters on the code side — `random_len`, `random_rate`, `window`, `time_window`, `key_len`, `hash`, `aead`, `module_flags`, `padding`, `jitter`, etc.; adjusting these settings is governed by this document.
> - **Corresponding implementation**: the code side declares at its entry point that "this implementation follows the *ZT-DSP Protocol Master Guide*" (for the Python implementation in this repository, see `FOLLOWS_DOC` in `zt_dsp_py/version.py`).
> - **About version numbers**: this project has three kinds of version number — the **total-guide version** (the revision number of this document itself, 1.0.0), and the **client versions** / **server versions** (the full identifier of each implementation). The relation between them and this document is **many-to-many**, not one-to-one: several implementations of the same kind whose protocol behaviour has not changed share one applicability declaration, and the same guide may apply to several client and server versions at once. **Identical version numbers do not mean the same implementation and do not constitute a compatibility claim.** **The handshake frames carry no version string whatsoever**: neither the Phase One parameter JSON nor the Phase Four AAD contains a version or protocol identifier field. Whether the peer is compatible is reflected by the Phase Three confirmation tag check.

## Beginner's Guide (Please Read This First)

### What is this file for?

This document is the **master guide** to the ZT-DSP communication protocol, and it serves three purposes at once: specification definition, usage instructions, and teaching material. It defines five core things:

1. How two devices **find each other** (door-number mechanism, Volume 3, Section 4.1)
2. How two devices **confirm each other's identity** (token mechanism, Section 4.1)
3. How two devices **communicate in encrypted form** (four-phase handshake, Section 4.2)
4. How the protocol **defends itself** when attacked (Volume 5)

### Why does it exist (what problem does it solve)?

When communicating on the Internet, by default anyone may snoop on or tamper with your messages. The problem ZT-DSP solves is: **letting two people who already know each other communicate securely under the premise of "trusting no one"**.

Imagine a scenario: you want to send a letter to a friend, but the postal workers may peek at the contents or forge the letter. ZT-DSP provides a set of methods that let the post office only help deliver the letter, while it can never know what is written in the letter, and can never forge a letter that "looks like you wrote it". (The above is a scenario, not a technical description.)

### Which parts should beginners focus on?

| Your background | Suggested reading path |
|----------|--------------|
| Complete beginner | Introduction → Volume 3 (Hotel Model) → Volume 1 (Core Ideas) → Volume 8 (FAQ) → Glossary |
| Want to understand the principles | Volume 1 → Volume 4 (Core Protocol) → Volume 5 (Threat Model) |
| Want to set up a server | Appendix B (Parameter Configuration Reference) |
| Want to develop an implementation | Volume 4 + Appendix F (Byte-by-Byte On-Wire Specification) + Appendix H (State Machine and Timeout Matrix) + Appendix C (Minimal Implementation Checklist) |
| Want to get it up and running right away | `ZT-DSP-client` repository README (installation, commands and troubleshooting for `zt_dsp_py` / `zt-dsp-rs`) |

> **Note on volume numbering**: volume numbers are fixed — each number maps to one volume of the body text, and numbers not listed have no corresponding volume.

> **Reading tip**: When you hit a term you do not understand, look it up in the Glossary, then come back and keep reading. Every term has a [Terminology Note] pointer and a one-sentence explanation the first time it appears in the main text.
>
> **Note for new readers**: appendices F/G/H are at the "protocol engineering blueprint" level — when writing an implementation, take Appendix F/H as authoritative (every sentence of them has been checked line by line against the official implementations), while Volume 4 is better suited to understanding and remembering; for byte-level self-checks, compare against Appendix F.

### Terminology Annotation Rules (learn these rules first, and reading will be much easier)

This version mandates annotation for **all technical terms** (abbreviations, proper nouns, industry idioms), uniformly using the tree format:

```plain
term (full name / original English wording)
├── Meaning: one sentence explaining what this thing is
├── Principle: the basic mechanism or design idea behind how it works
└── Rationale: why this thing exists, and what problem it was born to solve
```

- **In the main text**, when a term first appears: the name + full name + a one-sentence explanation are given, with a note "see the Glossary"
- Complex concepts are supplemented with **everyday analogies**; easily misunderstood concepts are flagged **Common Misconceptions**
- Content involving network communication, user data, or identity verification carries dedicated [Privacy Risk] [Protection Advice] [Compliance Note] annotations

## [Important Statement]

This document is the **master guide** to the ZT-DSP protocol, maintained with full authority by the Protocol Founding Team. ZT-DSP is an open communication protocol, not a fixed device or mandatory software. All parameters — including but not limited to random number length, generation rate, time window, hash algorithm, and encryption mode — may be freely declared by the server operator in its Library, and a client must match the parameters before it can connect.

This protocol does not rely on any centralized trust anchor. Every device holds a unique identity credential (token), issued by a third-party certification authority (TCA), but the TCA does not take part in the communication process, nor does it hold any key material. The two communicating parties exchange token hashes in advance out of band, then look for each other on the network and establish a connection.

This document is aimed at three kinds of readers:

1. **Beginners**: who wish to understand the protocol's principles and connect to an existing network
2. **Server builders**: who wish to deploy their own ZT-DSP relay node
3. **Protocol developers**: who wish to develop a custom implementation based on ZT-DSP

### [About the Version Number]

**1.0.0 is the first published version of this guide.** **The technical content of this document is itself the normative baseline** — protocol behaviour is governed by the main text, Appendix F (byte-by-byte on-wire specification) and Appendix H (state machine and timeout matrix).

## Table of Contents

**Volume 1**: Core Ideas and Design Principles

**Volume 3**: The Hotel Model — an intuitive metaphor for understanding ZT-DSP

**Volume 4**: Core Protocol Specification (the minimal set that must be implemented)

**Volume 5**: Security Boundaries and Threat Model

**Volume 8**: FAQ and Common Misconceptions

**Appendix B**: Parameter Configuration Reference

**Appendix C**: Minimal Implementation Checklist

**Appendix F**: Byte-by-Byte On-Wire Protocol Specification

**Appendix G**: Traffic Analysis Defense Implementation Details

**Appendix H**: State Machines, Timeouts, and Error Handling Matrix

# Volume 1: Core Ideas and Design Principles

> **[Introduction to this volume]** This volume answers three questions: ① What is "zero trust"? ② What is "dynamic synchronization"? ③ Which four core principles does the protocol follow? This volume is the ideological foundation of everything that follows — if you understand this volume, the technical details of Volume 4 have an answer to "why".
>
> **[What beginners should focus on]** Focus on understanding 1.1 and 1.3, the four principles, especially "out-of-band exchange" and "silent drop" — they will recur again and again later.
>
> **[Prerequisites]** None. This volume requires only everyday life experience.

## 1.1 What is "zero trust"?

```plain
zero trust (Zero Trust)
├── Meaning: a security design philosophy — by default, trust no person or link in the network until cryptographic evidence proves it trustworthy
├── Principle: strip "trust" away from human morality and institutional reputation, and hand it only to mathematics (cryptography). Because people make mistakes and institutions get breached, but the laws of mathematics do not
└── Rationale: traditional security models assume "the internal network is trustworthy and the external network is not", but in reality internal attacks (insiders, compromised servers) are the main source of threats, hence the "never trust, always verify" model was born
```

In traditional network communication, we usually assume that certain links are trustworthy. For example, we assume that the chat software's server will not peek at chat records, and that the telecom operator will not tamper with SMS contents. But the design principle of ZT-DSP is: **assume that no one is trustworthy**.

> **Everyday analogy**: Imagine a scenario: traditional security is like a residential compound gate — once you are through the main gate you are by default "one of us". Zero trust is like airport security — even after you have passed the first check, you are checked again before the boarding gate, and no link can "skip inspection by face recognition".
> (The above is a scenario, not a technical description.)

"Zero trust" means:

- It does not assume the server is honest — the server may try to snoop on your communication
- It does not assume the network path is safe — a man in the middle may intercept, tamper with, or replay your packets
- It does not assume the certification authority is permanently reliable — the TCA may be breached, coerced, or shut down
- It assumes only that mathematics is reliable — relying on cryptographic mathematical principles, not human morality

> **Common misconception**: Zero trust ≠ "trusting no one at all, unable to collaborate". Zero trust is not a refusal to trust, but **replacing verbal promises with verifiable credentials** — it merely changes the source of trust from "identity/location" to "mathematical evidence".

## 1.2 What is "dynamic synchronization"?

"Dynamic" means the protocol's state is not static. Every round of communication updates the keys, and every session generates a new encryption context. "Synchronization" means the two communicating parties reach a state of agreement by mathematical means — both sides independently compute the same key, without any third party taking part.

> **Everyday analogy**: Imagine a scenario: dynamic synchronization is like "setting your watches" — two people each look at their own watch, but a shared set of rules (say, both listening to the same hourly chime) keeps their time consistent. In ZT-DSP, both sides each hold the same material (PSK, DH result, session salt) and independently compute exactly the same key with the same set of formulas — no third party is needed to "agree on it for them".
> (The above is a scenario, not a technical description.)
>
> **Key term preview**: the "key" (Key) mentioned in this paragraph is explained in the Glossary. In plain terms: a key is the key to a "digital lock"; a message encrypted with it can only be unlocked by someone holding the same key.

## 1.3 The Four Core Principles

### Principle One: Open protocol, free implementation

All ZT-DSP specifications are public. Anyone may read, modify, and implement their own version. There is no *mandatory* official client, no forced update, no centralized control. This openness is both the protocol's advantage and the source of its security — an attacker cannot control the whole network by breaking a single official client.

> **Related knowledge**: This resembles the idea of Open Source software — public code does not mean insecure; "security rests on public review" (Kerckhoffs's principle: even if an attacker knows the entire design of the system, the system remains secure as long as the key is kept secret). Kerckhoffs's principle is explained in the Glossary.

> **Common misconception**: Many people think "public protocol = vulnerabilities seen by attackers = insecure". The opposite is true: a public protocol is reviewed by countless people, so vulnerabilities are found and fixed faster; a secret protocol (Security by Obscurity, achieving security by concealment) is, on the contrary, often proved riddled with holes once it is made public.

### Principle Two: Parameter autonomy, silent drop

Every server operator may define its own "dialect" — a specific combination of parameters. Packets that do not match the parameters are dropped outright, with no error returned and no processing triggered. This "silent drop" mechanism makes port scanning and protocol probing extremely difficult: an attacker cannot tell "port closed" from "parameters do not match".

```plain
silent drop (Silent Drop)
├── Meaning: when the server receives a packet that does not match the declared parameters, it returns no response, logs nothing, and consumes no computing resources, behaving as if the port did not exist at all
├── Principle: error messages are an attacker's "source of intelligence". If the server returns a different error code for each kind of error, an attacker can infer the protocol's parameter details by trial and error; no response = no intelligence
└── Rationale: traditional protocols (such as HTTP) return error codes like 400/404, which are convenient for debugging but also for probing. Anonymous network protocols need to "stay invisible", hence the silent drop was born
```

> **Everyday analogy**: Imagine a scenario: silent drop is like a "secret room with no signboard" — no one answers a knock, no one replies to a shout, so a passer-by cannot tell whether anyone is inside or what model of lock is on the door.
> (The above is a scenario, not a technical description.)

### Principle Three: Out-of-band exchange, door number first

In ZT-DSP you cannot "search for a username" and add someone the way you add a WeChat friend. Before entering the network you must already have obtained the other party's "door number" through some secure channel (face to face, encrypted email, a QR code, etc.). This is not a design flaw but the fundamental guarantee of anonymity.

```plain
out-of-band exchange (Out-of-Band Exchange)
├── Meaning: exchanging information through channels "outside the communication network" (face to face, a letter, another channel already confirmed secure), rather than inside the ZT-DSP network
├── Principle: exchanges inside the network may be monitored or tampered with; an out-of-band channel does not pass through the network, and a man in the middle cannot control both channels at once, so it can serve as the "starting point of trust"
└── Rationale: any encrypted communication needs an "initial trust" — the two sides must first confirm "the other party really is that person". Out-of-band exchange provides this initial trust and depends on no centralized authority
```

> **Common misconception**: Out-of-band exchange ≠ having to meet offline. QR code scanning, encrypted email, or another chat tool whose trust you have already established all count as out of band. The core criterion is: **this channel does not pass through a ZT-DSP server, and you have already confirmed that it is trustworthy**.

### Principle Four: Layered isolation, least privilege

Each role in the protocol (TCA, server, client) holds only the minimum privilege necessary to fulfil its function. The TCA only issues identity cards and does not enter the room; the server only forwards packages and does not open the boxes; the client only manages its own keys and does not interfere with others.

```plain
principle of least privilege (Principle of Least Privilege)
├── Meaning: each role/program/user is granted only the minimum privilege necessary to complete its task, not a shred more
├── Principle: the greater the privilege, the greater the scope of damage when it is breached. Compressing privilege to the minimum confines the loss to a local area even if some link is broken
└── Rationale: a long-standing lesson in security — a large number of data-leak incidents stem from "some employee account having excessive privilege". Least privilege is the first principle of secure design
```

> **Related knowledge**: The principle of least privilege is also widely applied in operating systems (e.g. running services as a non-root user on Linux), databases (read-only accounts), and cloud services (RAM roles). Once you have learned this principle, you can apply it in any technical field.

# Volume 3: The Hotel Model — an intuitive metaphor for understanding ZT-DSP

> **[Introduction to this volume]** This volume uses the metaphor of a "special hotel" to translate abstract cryptographic concepts into everyday life scenarios. It is **the fastest entry point for understanding the whole protocol** — readers with no background are strongly advised to read this volume first.
>
> **[What beginners should focus on]** Remember the role mapping table in 3.3 and the five core rules in 3.4. After reading, try to restate in your own words the duties of the "door number" and the "front desk"; if you can do that, you have grasped the skeleton of the protocol.
>
> **[Related knowledge]** Every concept in this volume has a corresponding technical implementation in Volume 4: door number = token hash (4.1.1), front desk = server, security guard = TCA (4.1.2).

## 3.1 Why use a hotel as the metaphor?

Cryptographic protocols are often full of abstract concepts — hashing, key derivation, forward secrecy, man-in-the-middle attacks. To a beginner, imagine a scenario: these terms are like a wall. The hotel model turns this wall into a window: through scenarios familiar from everyday life, you understand the protocol's security boundary. (The above is a scenario, not a technical description.)

> **Important reminder**: **The hotel model is a teaching tool, not a technical specification.** When you need a precise implementation, return to the mathematical description in Volume 4. The metaphors in the model (such as "box") correspond technically to specific encryption algorithms (AES-256-GCM); do not mix them up.

## 3.2 Scenario setup

Imagine a scenario: a special hotel —

- Anyone may build their own hotel (deploy a server)
- The hotel front desk does not know any guest (anonymity)
- The hotel security guard only verifies whether an identity card is genuine and does not record who comes to see whom (the TCA's function)
- The rooms have no keyholes, and the front desk cannot enter (end-to-end encryption)
- Before guests enter a room, they must already know each other's room number (out-of-band exchange)

> **Everyday analogy, upgraded**: Imagine a scenario: this hotel is more like a hybrid of "parcel transit station + star-rated hotel" — the front desk is responsible for moving parcels from room A to room B, but the front desk has neither a key to open them nor any record of the parcels' contents.
> (The above is a scenario, not a technical description.)

## 3.3 Role mapping

| Role in the hotel | Entity in ZT-DSP | Function |
|--------------|------------------|----------|
| Hotel | Server | Provides a place to connect and forwards data packets |
| Front desk | Server software | Registers, matches, and forwards, without decrypting |
| Security guard | TCA (token certification authority) | Issues identity cards and verifies their authenticity |
| Butler | TCA inspection program | Periodically checks whether credentials have expired or been revoked |
| Room | Matching pool (pairing space) | Only two parties holding the same door number can enter |
| Lobby | Waiting area (waiting pool) | Holds temporary devices that have not yet matched with the other party |
| Guest | Client device | The two parties actually communicating |
| Box | Encrypted data packet | The front desk can only see the outside and cannot open it |
| Door number | Token hash H(Token) | The identifier used to find the other party |

## 3.4 The Five Core Rules

### Rule One: The door number is not collected at the hotel

When you go to a hotel to find a friend, you do not ask at the front desk "which room is my friend in"; your friend told you the room number before you set off (via WeChat, a phone call, or a note). In ZT-DSP, this "telling in advance" is out-of-band exchange — through QR code scanning, encrypted email, an offline meeting, a direct P2P connection, or other means, both sides know each other's door number (token hash) before entering any server.

**If you do not bring the door number, the hotel front desk will not tell you anyone's room number. This is not a bug; it is the bottom line of anonymity.**

> **Practical tip**: The door number (token hash) is **public information** and can be safely told to friends; but the "token itself" (identity card) behind the door number is **top-secret information** and must never be given to anyone. Imagine a scenario: you can print your phone number on a business card, but you must never hand the original of your ID card to anyone. (The above is a scenario, not a technical description.)

### Rule Two: The front desk cannot open any box

After guests A and B enter a room, they begin exchanging boxes. Every box is locked, and only A and B hold the key. The front desk is responsible for moving the boxes from A's room to B's room, but the front desk has no key and cannot open the boxes to see the contents. Even if the front desk is malicious, at most it can do two things: refuse to move them (cut the connection) or delay moving them (slow down), but it can never know what is inside the box.

> **Related knowledge**: This is "end-to-end encryption" — encryption and decryption happen only at the two ends of the communication, and the intermediate link (the server) only ever sees ciphertext. Instant messaging software such as WeChat and Signal advertises "end-to-end encryption" on the same principle.

### Rule Three: The security guard does not enter the room

The duty of the security guard (TCA) is to verify at the hotel entrance whether a guest's identity card is forged. Once verification passes, the guard does not follow the guest into the room, nor does it learn whom the guest wants to find or what is said in the room. The guard does not even live in this hotel — it may be in another city, verifying the authenticity of the identity card only through digital signatures.

```plain
digital signature (Digital Signature)
├── Meaning: an "anti-counterfeiting mark" generated over data with a private key; anyone holding the corresponding public key can verify whether the mark is genuine, but cannot forge it
├── Principle: sign with the private key, verify with the public key — the signer uses a private key that only it knows to generate the signature; the verifier uses the public public key to check whether the signature matches; if it does not match, the data has been tampered with or the signer's identity is suspect
└── Rationale: handwritten signatures in the real world can be imitated; digital signatures are guaranteed unforgeable by mathematics, and are the cornerstone of electronic identity authentication
```

> **Practical tip**: When the security guard verifies an identity card, it uses a "verification algorithm" (public key verification) and does not need to see the entire contents of the identity card — imagine a scenario: a security inspector only needs to verify whether the passport chip is genuine, and does not need to know all your entry and exit records in the passport. This is why the TCA can hold none of your communication data. (The above is a scenario, not a technical description.)

### Rule Four: Guests in the lobby cannot see each other

When A arrives at the hotel and shows the room number to find B, B has not arrived yet. A is placed in the lobby (the waiting pool) to wait. **Key security property: none of the guests in the lobby know of each other's existence.** A does not know that C, D, and E are in the lobby too; C, D, and E do not know whom A is waiting for. The front desk does not broadcast "A is waiting for B"; it merely quietly keeps this record.

> **Everyday Analogy**: Imagine this scenario: this is like an "anonymous reception room" -- all the waiters are in the same room, but each is separated by a partition, nobody can see anyone else, and only the front desk knows where each person is.
> (The above is an imagined scenario, not a technical description)

> **Related Knowledge**: This corresponds to "Unobservability" in cryptography -- not only is the content kept secret, but even metadata such as "who is communicating with whom" is not exposed. Note: metadata (who, when, how often) often exposes privacy more than the content itself, which is also why section 4.2.4 hashes the encrypted token.

### Rule Five: Once a Room Is Paired, Outsiders Cannot Break In

When B finally arrives, the front desk checks the room number match and sends A and B into the same room. From this moment on, the room is locked. If a third party C also holds the same room number hash (theoretically possible, but extremely unlikely) and tries to join this room, the front desk will directly intercept and drop its request. This protected placeholder space is the "virtual room" -- it exists, but is invisible and inaccessible from the outside.

```plain
Hash (Hash, Hash Function)
├── Meaning: a function that "compresses" data of arbitrary length into a fixed-length string (e.g., 256 bits); the same input always yields the same output, and an input differing by a little yields a completely unrecognizable output
├── Principle: a one-way function -- computing the output from the input is easy, while recovering the input from the output is computationally infeasible (unless by brute force); the probability that different inputs produce the same output is extremely low (collision resistance)
└── Rationale: scenarios that need a "fingerprint" -- verifying data integrity, storing passwords (storing only the hash, not the plaintext), generating public identifiers (room numbers)
```

> **Common Misconception**: Hash ≠ encryption. Encryption is reversible (with the key you can restore the plaintext); hashing is irreversible (you can only verify, not restore). Storing only the hash of a password, or using a hash as encryption, are mistakes beginners commonly make.

# Book Four: Core Protocol Specification (the Minimum Set That Must Be Implemented)

> **Reading Guide to This Book** This book is the **core protocol** of zt-dsp-py -- any implementation claiming compatibility with ZT-DSP must support the contents of this book (the extension modules in Book Three are all optional). This book answers: where identity comes from (4.1), how two parties establish an encrypted session (4.2), and how the server stays hidden (4.3).
>
> **Focus for Beginners** First understand the identity system in 4.1 (the difference between a token and a room number), then walk through the four-phase flow in 4.2. Every formula block has line-by-line comments; read them by matching "Input → Compute → Output". The descriptions in this book have been checked item by item against the implementation of the official client `zt_dsp_py`  (client version `ZT-DSP_PY-1.0.0`), and you can verify them by running the `ZT-DSP-client` implementation as its README describes.
>
> **Prerequisites** the hotel model of Book Three (this book is its technical implementation); the explanations of the four concepts "hash, encryption, key exchange, digital signature" in the Glossary.
>
> **Security Note** This book involves authentication and key material and is the book with the densest security annotations. Operations involving tokens or PSK are accompanied by **Privacy Risk**, **Protection Recommendation**, and **Compliance Note**; please do not skip them.

## 4.1 Identity and Credential System

> **Version support statement (TPM and HWID)** The storage, binding and writing of the TPM (Trusted Platform Module) and HWID (Hardware Identifier) described in this section is a **design goal at the protocol level**, and the **current 1.0.0 release does not implement it**. The official clients `zt_dsp_py` and `zt_dsp_rs` **do not support writing, reading or modifying the TPM or the HWID in any way**; the PSK and the token are currently supplied as ordinary configuration values (`--psk-file` / `--psk-env` / `--psk`), and keeping them secret is the caller's responsibility -- the client provides no hardware-level protection. This capability is **planned for a later version**; only then will the "storage location / physical binding / non-exportable" statements in this section correspond to running code. wherever TPM/HWID appears in this section, this statement governs.

In ZT-DSP, your identity consists of two parts:

1. **Token** -- your "identity card", issued by a TCA and, by protocol design, stored in the device's TPM/HWID (**not implemented in 1.0.0 -- see the version support statement at the head of this section**)
2. **Token Hash (H(Token))** -- your "room number", used to find the other party on the server

```plain
Token
├── Meaning: a device identity credential issued by a TCA and protected by a digital signature; imagine this scenario: it is equivalent to a "digital identity card" (the above is an imagined scenario, not a technical description)
├── Principle: the token contains a random seed (the core entropy source) and the TCA's Ed25519 signature; anyone can use the TCA public key to verify whether the signature is genuine, but no one can forge it (without the TCA private key)
└── Rationale: the network needs a form of identity proof that is "unforgeable and verifiable offline"; the token was created for this purpose
```

**Key distinction: the identity card is secret, while the room number is public.** You never show your identity card to others, but you can tell your room number to friends so that they can find you in the hotel.

> **Everyday Analogy**: Imagine this scenario: the token is like the original identity card (containing chip information, never lent out); the token hash is like the identity card number (which can be printed on a form to be recognized by others). A leaked identity card number does not equal identity theft -- but combined with other information it can still be abused, so both must be kept safe.
> (The above is an imagined scenario, not a technical description)

> **Privacy Risk** Once a token leaks (e.g., the device is implanted with malware or a backup file is stolen), an attacker can impersonate your identity and join any session. Although the token hash (room number) can be public, long-term use of the same room number will be used by servers or observers to correlate your behavioral trail (traffic analysis).
>
> **Protection Recommendation** Store the token only in the TPM/HWID (hardware secure area); do not write it to disk in plaintext, do not export it, and do not back it up; if you need to change your identity, you can apply for a new token and change the room number. (**Not implemented in 1.0.0: no TPM/HWID storage** -- this is a protocol-level goal state; the current client treats the token as ordinary configuration and hardware-level protection must be provided by the deployer)
>
> **Compliance Note** A token is "identity-identifying data" and should follow the **principle of minimization**: store only the fields necessary to perform the protocol functions (see the field table in 4.1.1), and do not write any personally identifying information (name, phone number, etc.), so as to reduce the damage in case of a data leak.

### 4.1.1 Token Structure

A token is a 256-bit data structure containing the following fields:

| Field Name | Length | Description |
|----------|------|------|
| Vendor ID (optional) | 32 bits | Custom, may be fully random. Used to identify the device manufacturer or community |
| Device Type (optional) | 16 bits | Custom, may be fully random. Used to identify the device type (phone, router, IoT sensor, etc.) |
| User-Defined (optional) | 64 bits | Custom, may be fully random. Users may define the purpose themselves |
| Random Seed | 128 bits | **Required.** A true random number; the core entropy source of the entire token |
| Checksum | 16 bits | CRC-16; used only to detect accidental corruption during transmission |

```plain
Entropy
├── Meaning: a measure of randomness. The higher the entropy, the more unpredictable the data; 128 bits of entropy means there are 2^128 equally likely values
├── Principle: cryptographic security relies on "the attacker cannot guess". If the random seed is predictable (e.g., generated from a timestamp), the entire token system can be broken
└── Rationale: why is true randomness needed? Because a pseudo-random generator (if its seed is predictable) turns "random" into "predictable", and in cryptography predictable = insecure
```

```plain
CRC-16 (Cyclic Redundancy Check)
├── Meaning: a 16-bit check code used to detect accidental corruption of data during transmission/storage (such as bit flips)
├── Principle: treat the data as a polynomial and perform division; the remainder is the check code; the receiver recomputes and compares, and a mismatch means the data was altered
└── Rationale: transmission media (network cables, Wi-Fi, electromagnetic interference) randomly corrupt bits. Note: CRC can only detect **accidental corruption**, not prevent **malicious tampering** (an attacker can recompute the CRC); tamper resistance relies on the Ed25519 signature and the GCM authentication tag
```

> **Common Misconception**: CRC verification ≠ integrity protection. CRC is "carelessness detection" (against accidents), while a digital signature/GCM is "strict authentication" (against malice). Treating CRC as a tamper-proofing measure is a common beginner misunderstanding.

**Token Hash = SHA-3-256 (full token)**

> **Addendum (P2P direct-connection placeholder path)**: The above is the standard algorithm for the case "with a TCA token". However, the **pure P2P direct-connection** scenario without a TCA (the official client's default mode) has no token body, so in this case the official client derives a **placeholder token hash** from the PSK:

```plain
placeholder token hash = first 32 bytes of HMAC-SHA3-256(PSK, role label)
role label = "ZT-DSP-TOKEN-INITIATOR-v3" (when oneself is the initiator)
        or "ZT-DSP-TOKEN-RESPONDER-v3" (when oneself is the responder)
```

- The initiator's own room number = HMAC(PSK, "ZT-DSP-TOKEN-INITIATOR-v3"), and the peer's room number = HMAC(PSK, "ZT-DSP-TOKEN-RESPONDER-v3"); **the responder swaps the two labels** (it uses the RESPONDER label for itself and the INITIATOR label for the peer). In this way A's src is exactly equal to B's dst, ensuring that the phase-four bidirectional token-hash verification is self-consistent
- This path only guarantees **frame structural integrity** and **both parties' identity being bound to the PSK**; it does not have the "third-party notarization" property of a TCA; when a notarized identity is needed, the TCA module should still be mounted to inject a real token hash

```plain
SHA-3-256 (Secure Hash Algorithm 3, 256-bit output)
├── Meaning: a hash function standardized by NIST that compresses an input of arbitrary length into a fixed 256-bit output
├── Principle: based on the Keccak sponge construction -- absorb the input and squeeze the output; one-wayness + collision resistance are guaranteed by the mathematical structure
└── Rationale: NIST standardized SHA-3 in 2015 as a backup for the SHA-2 family, to avoid "if a single algorithm is broken, the entire industry is paralyzed"
```

### 4.1.2 Token Issuance and the TCA Federation

**Responsibilities of the TCA (Token Certification Authority):**

```plain
TCA (Token Certification Authority)
├── Meaning: a third-party authority that issues tokens for devices and maintains a revocation list, similar to a "police department + notary office" in the real world
├── Principle: the TCA holds its own Ed25519 private key and uses it to sign tokens; a verifier only needs the TCA's publicly known public key to verify whether a token is genuine, without contacting the TCA itself
└── Rationale: without a TCA, anyone could generate unlimited fake identities (Sybil attack) and public-interest servers would be flooded with junk connections; the TCA provides an "identity cost" and at the same time avoids central monopoly through federation
```

1. Verify the applicant's identity (the degree of verification is decided by each TCA itself)
2. Issue the token and attach an Ed25519 digital signature
3. Maintain the revocation list (CRL), marking tokens that have become invalid
4. Respond to server queries about token status

```plain
CRL (Certificate Revocation List)
├── Meaning: a list recording tokens (identity cards) that have been revoked; the server queries this list during verification
├── Principle: the TCA publishes the list periodically; when verifying a token the server simultaneously checks "whether this certificate has already been revoked"
└── Rationale: a token may be revoked because the device was lost, the private key leaked, or the user was banned for abuse; without a revocation mechanism, a revoked token would remain valid forever
```

**The TCA federation model:**

- Anyone can set up their own TCA. As long as you generate an Ed25519 key pair, you can start issuing tokens for friends
- One device can hold multiple tokens issued by multiple TCAs (imagine this scenario: it is like holding an identity card, a passport, and a driver's license at the same time) (the above is an imagined scenario, not a technical description)
- One server can hold the whitelists of multiple TCAs; the server operator can declare "I recognize tokens issued by TCA-A and TCA-B, but not TCA-C"
- The authority of a TCA depends on community recognition. There is no mandatory monopoly authority and no "root CA"

> **Related Knowledge**: The TCA federation is similar to the CA (certificate authority) system of HTTPS, but with one key difference: HTTPS has a "root CA" (a trust list preinstalled in browsers), while ZT-DSP does not -- each server decides for itself whom to trust. This is the design of "decentralized trust".

> **Privacy Risk** When issuing a token, the TCA may learn your device information (depending on its verification process). The TCA does not participate in communication and does not hold communication keys, but the "device-token" mapping it holds is sensitive data; if the TCA is compromised or coerced, it may leak your identity-correlation information.
>
> **Protection Recommendation** Choose a TCA with a low degree of verification (e.g., verifying only the existence of the device); rotate among multiple tokens; server operators should not ask the TCA for information beyond what "signature verification" requires.
>
> **Compliance Note** As an "identity data processor", a TCA should follow the data minimization principle, collect only the necessary information in the issuance/revocation process, and clearly inform applicants of the purpose of the data and the retention period.

### 4.1.3 Authorization Code (Optional Strengthening Layer)

Some servers require the client to provide an authorization code in addition to the token. The authorization code is issued by a TCA and bound to a specific server, and by protocol design the device writes it into the TPM/HWID on first access (**not implemented in 1.0.0 -- writing to TPM/HWID is planned for a later version**). The server can thereby manage each device individually (ban, mute, rate-limit). A client without an authorization code cannot enter a server that requires one, even if it holds a valid token.

- **Token = identity card**: proves "you are a legitimate person"
- **Authorization code = access card**: proves "you are allowed to enter this particular hotel"

> **Everyday Analogy**: Imagine this scenario: the token is an identity card (valid nationwide), and the authorization code is a company access card (valid only for this company). Losing the access card does not affect the validity of the identity card; revoking the access card also does not affect your identity on other servers.
> (The above is an imagined scenario, not a technical description)

### 4.1.4 Device-Specific Key (PSK)

PSK (Pre-Shared Key) is the core anchor of the ZT-DSP security system.

- **Length**: a 256-bit true random number
- **Storage location**: by protocol design, the device's TPM (Trusted Platform Module) or HWID (Hardware Identifier); **not implemented in 1.0.0 -- the caller keeps it in a configuration file or environment variable**
- **Properties**: the protocol goal is physical binding, non-exportability and non-copyability; **1.0.0 provides none of these hardware protections -- planned for a later version**
- **Purpose**: participates in session key derivation; it is the root basis of trust across all communication scenarios

```plain
TPM (Trusted Platform Module)
├── Meaning: an independent security chip soldered onto the motherboard, dedicated to securely generating and storing keys
├── Principle: key generation and signature operations are performed inside the chip, and the private key never leaves the chip; even if the operating system is compromised, the attacker cannot export the key inside the chip
└── Rationale: keys stored in software can be read by malicious programs; the TPM uses "hardware isolation" to lock keys into a physical chip, which is the industry-standard practice for mobile devices/computers
```

```plain
HWID (Hardware Identifier)
├── Meaning: a unique device identifier derived from device hardware characteristics (CPU serial number, storage serial number, etc.)
├── Principle: binds the key to "this device" -- it becomes invalid when the device is changed, preventing the key from being copied to other machines
└── Rationale: low-cost devices without a TPM chip (IoT sensors, etc.) need an alternative; HWID provides "physical binding at the software level"
```

**Key security properties:**

- The PSK never leaves the device. It is not transmitted over the network, not stored in the cloud, and not backed up to an SD card
- The PSK is a long-term key. Unlike a session key, it is not replaced after every communication; it is the device's "root identity"
- **PSK leak = total collapse.** If an attacker obtains your PSK by some means (such as a side-channel attack or a supply-chain implant), he can impersonate you and join any session. Therefore the physical protection of the PSK is the highest priority

> **Privacy Risk** The PSK is key material with "single-point leakage causing global damage": after a leak, an attacker can impersonate your identity, decrypt communications (within the range of the leaked history), and join any session. It is also a primary target of supply-chain attacks (implanting a backdoor before the hardware/software leaves the factory).
>
> **Protection Recommendation** (1) Use only devices with a TPM (the PSK never leaves the chip) -- **note: the 1.0.0 client neither writes the PSK into a chip nor uses a TPM, so the deployer must enforce this themselves**; (2) regularly check the origin of device firmware and be wary of "preinstalled software" of unknown origin; (3) if you suspect the PSK has leaked, immediately revoke the old token, apply for a new token, and change the device (when the PSK is bound to hardware, changing the device changes the key); (4) side-channel attacks (power analysis, electromagnetic leakage) are threats in physical-contact scenarios, and high-security scenarios should use devices with shielding measures.
>
> **Compliance Note** The PSK is "key material"; follow cryptographic management best practices: keys should be managed in layers (root keys / session keys separated), the scope of use should be minimized (the PSK only participates in derivation and does not directly encrypt data), and key rotation and destruction mechanisms should be established.

> **Common Misconception**: A PSK is a "pre-shared key", but it is **not a passphrase/password**. A password is a short string memorable by humans (guessable, brute-forceable); a PSK is a 256-bit true random number (unguessable, generated by hardware). The security of the two differs by orders of magnitude; do not treat a PSK with the mindset of "setting a password".

### 4.1.5 Multi-Token and Multi-Server Strategy

One device can hold multiple tokens and connect to multiple servers:

1. **Isolation**: use a TCA-A token to connect to server X and a TCA-B token to connect to server Y. Even if server X is compromised, communication with server Y is unaffected
2. **Redundancy**: if TCA-A is shut down, you can immediately switch to a TCA-B token and continue communicating
3. **Anonymity**: different servers see you using different token hashes, so they cannot correlate your identity across servers

> **Related Knowledge**: This is like the "one password per website" strategy in password managers -- spreading trust across multiple independent authorities, so that the failure or betrayal of any single authority has only a local effect.

## 4.2 Four-Phase Handshake Specification (Standard Flow)

Before two people begin a secret conversation, they need to first confirm each other's identity and agree on a common "secret code" -- an encryption key known only to the two of them. This process is the "handshake".

```plain
Handshake
├── Meaning: the interaction process in which two communicating parties complete identity confirmation and key agreement before formally transmitting data
├── Principle: exchange the necessary information (identity proof, public keys, random numbers) in a few rounds of "question and answer", and both parties independently compute the same session key
└── Rationale: if encrypted communication began directly without a handshake, the two parties would have no shared key and could not confirm each other's identity -- the handshake is the "preliminary step" of encrypted communication
```

In ZT-DSP, the handshake is divided into four phases:

1. **Identity Announcement** -- "who I am and whom I want to find"
2. **Key Synchronization** -- "we jointly compute a secret key"
3. **Anchor Locking** -- "confirm that we are in the same session"
4. **Encrypted Transmission** -- "start encrypting messages with the key"

### 4.2.1 Phase One: Identity Announcement (Check-In Registration)

**Scenario:** Guest A comes to the hotel front desk and shows two room numbers: its own room number H(Token_A) and the room number of the person being sought, H(Token_B).

**Technical Flow:** Client A sends an identity announcement to server S (the phase-one frame is **plaintext** -- at this point the two parties do not yet share a session key, and the security of this frame comes from "the access nonce binding the PSK" and the confirmation tag of the subsequent phase three, not from encryption), containing the following information:

1. **Source token hash H(Token_A)**: identifies oneself; in phase one it is used in plaintext for routing
2. **Target token hash H(Token_B)**: identifies the person being sought; the server uses it to look up a match in the waiting pool
3. **The TCA-signed token body**: proves that A's identity is legitimate; the server verifies the validity of the signature
4. **Authorization code (if the server requires it)**: proves that A is allowed to enter this particular hotel
5. **Capability flags**: declares the modules and cryptographic parameters that A supports (such as the list of supported encryption algorithms and parameters)
6. **Access nonce**: conforms to the parameters declared by the server library (length, rate, format); it serves as an identity heartbeat, proving that A is "alive" and holds the correct key material

> **On-the-wire frame format (checked byte by byte against the official client)**: On the network, the above 6 items of information are not "6 independent fields"; they are packed into one phase-one frame (**for the complete byte-by-byte layout, the on-the-wire structure and validation rules of the parameter JSON, and the upper-limit constants, see Appendix F.1; under the default parameters this frame is about 228 bytes minimum**):

```plain
Phase-one frame (on-the-wire format):
[param_len(4B)] [parameter JSON] [identity_len(4B)] [identity_blob] [nonce_len(4B)] [access nonce]

Field mapping:
• parameter JSON (capability flags) → "random_len", "random_rate", "window",
  "key_len", "hash", "aead", "module_flags" (JSON key-value pairs, length limit 4096 bytes)
• identity_blob (identity material, limit 8192 bytes) → default content = source token hash(32B) ‖ target token hash(32B);
  if a TCA/authorization module is mounted, it is replaced by a hook with identity declarations such as "TCA-signed token + authorization code"
• access nonce (nonce, limit 512 bytes) → see the formula below; the peer verifies whether its length equals the declared random_len
```

> **The true origin of the access nonce (common pitfall)**: a common misreading treats the access nonce as "derived from the PSK, the TPM/HWID, and the TCA token", which does not match the official implementation. The official client actually does:

```plain
access nonce = HKDF-SHA3-256(IKM = PSK, salt = fresh random salt(32B), info = "ZT-DSP-PHASE1-NONCE-v3", output length = random_len bits)
```

| Element | Annotation (input/output/effect) |
|------|------------------------|
| Access nonce | **Output**: the "identity heartbeat" of length = random_len bits (256 bits by default) |
| HKDF-SHA3-256(...) | **Function**: a key derivation function. The same IKM with a different salt → a different output; but only two parties holding the same PSK can compute the same sequence (determinism) |
| IKM = PSK | **Input**: the device-specific key. Only a client holding the correct PSK can generate a nonce that "looks correct"; this is the secret code that "proves I hold the key" |
| salt = fresh random salt | **Input**: a random salt newly generated for each handshake, preventing an attacker from precomputing (offline brute-forcing) the PSK derivation result |
| info = "ZT-DSP-PHASE1-NONCE-v3" | **Context string**: identifies the purpose and prevents producing the same value as other derivations (MK/EK, etc.) |

> **Practical Note**: The access nonce is **not** a purely random number, but a "PSK-driven deterministic random number" -- the peer only verifies that its length equals the declared random_len, and **cannot (and does not attempt to) recompute it**; whether "it was derived from the correct PSK" is indirectly reflected by the phase-three confirmation tag (wrong PSK → wrong MK → the tag must be wrong). This is why it is called an "identity heartbeat": only those holding the same PSK know the rhythm of the heartbeat.

> **Practical Interpretation**: The core logic of phase one is to "**prove that you hold a legitimate identity, but never reveal the identity secret**". What A presents is the **hash** of the token (the room number) and the TCA's **signature** (publicly verifiable), not the token itself or the PSK -- imagine this scenario: it is like a guest showing the front desk a photocopy of an identity card and its anti-counterfeit watermark, rather than handing over the original identity card. (The above is an imagined scenario, not a technical description)

> **Privacy Risk** In phase one, the source/target token hashes are transmitted in **plaintext**, so the server (and any observers along the path) can see that "H(Token_A) is looking for H(Token_B)". This means the server knows the metadata of "who is looking for whom" -- although it does not know who the real person behind the room number is, long-term observation can build a behavioral profile of the device.
>
> **Protection Recommendation** (1) The token hash can be changed periodically (change the token); (2) in multi-server scenarios use different tokens to avoid cross-server correlation; (3) from phase four onward the token hash is transmitted encrypted (see 4.2.4), so the server can see only the session ID needed for routing.
>
> **Compliance Note** "Who is looking for whom" is communication metadata. Under privacy protection principles, server operators should **not record and not store** the pairing information of phase one (the 30-second automatic clearing of the waiting pool was designed precisely for this) and should state this clearly in the privacy policy.

**Server Processing Flow:**

1. **Parameter check**: check whether the length, rate, and format of the access nonce conform to the library declaration. If not → **Silent Drop**. No error is returned, no log is written, and no computing resources are consumed. From the attacker's perspective, this port is indistinguishable from a closed port
2. **Token verification**: verify whether the TCA signature is valid; query the CRL (revocation list) to confirm that the token has not been revoked; if the server requires an authorization code, verify whether the authorization code is in the whitelist
3. **Waiting-pool matching**: look in the waiting pool for whether there is a guest holding H(Token_A) (that is, B has already arrived and is waiting for A). If there is → pair A and B and send them into the same room; if there is not → put A into the waiting pool and wait for B to arrive
4. **Waiting-pool management**: each registration form in the waiting pool is stored independently and is invisible to the others; waiting entries are automatically cleared after 30 seconds (to prevent long-term occupation of memory); the front desk never broadcasts A's registration information to the other people in the lobby

> **Practical Note (parameter-tuning pitfall)**: The most common mistake beginners make when setting up a server is "parameters not aligned" -- the client sends packets with the default parameters while the server checks against a custom library declaration, so all packets are silently dropped, showing up as "cannot connect and no error at all". Troubleshooting method: compare, one by one, the **7 matching parameters** in both parties' library files -- random nonce length (random_len), generation rate (random_rate), negotiation window (window), key length (key_len), hash algorithm (hash), encryption algorithm (aead), module flags (module_flags) -- they must match exactly (the official client's `--version` and its startup parameter printout can be compared directly).

### 4.2.2 Phase Two: Key Synchronization (Exchanging Secret Codes Inside the Room)

**Scenario:** After A and B enter the room, the room has already been isolated. At this point both parties each generate an ephemeral key pair and exchange public keys, completing the "secret code exchange" process.

**Technical Flow:**

**Step 1: Generate an ephemeral key pair**

A generates the ephemeral key pair (sk_A, pk_A), and B generates the ephemeral key pair (sk_B, pk_B).

```plain
Key Pair
├── Meaning: a mathematically related pair of keys -- the private key (secret key, sk) is kept secret, and the public key (public key, pk) is public
├── Principle: the public key can be computed from the private key, but the private key cannot be derived back from the public key; after the two parties exchange public keys, each can compute the same shared secret using "its own private key × the other party's public key"
└── Rationale: symmetric encryption needs "the same key", but transmitting the key over the network would be eavesdropped; an asymmetric key pair lets both parties "each compute the same key" without revealing their private keys
```

An ephemeral key pair is "one-time". A new key pair is generated for every session and destroyed immediately (memory zeroized) after the session ends. This differs from the long-term PSK -- the PSK is the device's "root identity", while an ephemeral key is only the "temporary identity" of this session. **Why are ephemeral keys needed?** Because even if an attacker records all your communications today, your ephemeral keys will already have changed by tomorrow, and he cannot decrypt tomorrow's communications. This is "Forward Secrecy" -- a long-term key leak does not affect historical sessions.

```plain
Forward Secrecy (FS)
├── Meaning: even if the long-term key (PSK) leaks some day in the future, past sessions that already occurred cannot be decrypted
├── Principle: each session uses an independent ephemeral key to derive the session key, and the ephemeral private key is destroyed when the session ends. Even if the attacker obtains the PSK afterwards, he is missing the link of "the ephemeral private key of that time" and cannot compute past session keys
└── Rationale: a long-term key leak is something that may happen sooner or later (the device is compromised, the authority is coerced); forward secrecy limits the damage to "after the leak" and protects all historical communications
```

> **Everyday Analogy**: Imagine this scenario: forward secrecy is like "changing to a new lock at every meeting" -- even if your master key (PSK) is stolen some day, the thief can only open future doors and cannot open any of the past rooms that used the old locks.
> (The above is an imagined scenario, not a technical description)

**Step 2: Exchange public keys**

A and B exchange public keys pk_A and pk_B through the server. Public keys can be transmitted openly, and it does no harm even if they are intercepted; the server is only responsible for forwarding the public keys and cannot derive the shared secret.

> **On-the-wire flow (checked against the official client)**:
>
> 1. Initiator A sends: `[pub_len(4B)] [pk_A(32B)] [session_salt(32B)]` -- the session salt is sent together with A's public-key packet
> 2. After receiving it, responder B **computes DH first**, and only then decides whether to respond: if the public-key length is abnormal or it is a low-order point (such as all zeros, u=1, or other invalid values), B will **strictly silently drop** it -- sending no bytes at all and not actively closing the connection (security hardening: prevents "the response frame from being leaked before verification fails")
> 3. Only after B passes verification does it send back: `[pub_len(4B)] [pk_B(32B)]` (the initiator frame is 68 bytes in total and the responder frame is 36 bytes in total; for the ordering constraint that the responder "computes DH before responding" and the frame layout details, see Appendix F.3)
>
> **Common Misconception**: A public key is **public** information and can safely be handed to the server for forwarding; but the private keys (sk_A/sk_B) must **never** leave the device. Imagine this scenario: think of the public key as a "locked mailbox number" -- anyone can drop a letter into the mailbox (encrypt with the public key), but only the person holding the key (the private key) can open it. (The above is an imagined scenario, not a technical description)

**Step 3: Compute the shared secret**

- A computes: DH = X25519(sk_A, pk_B)
- B computes: DH = X25519(sk_B, pk_A)

Mathematical guarantee: the DH values computed by both parties are exactly the same.

```plain
DH (Diffie-Hellman)
├── Meaning: a mathematical protocol that lets two parties each compute the same shared secret over an insecure channel
├── Principle: uses a "one-way function" (modular exponentiation / elliptic-curve scalar multiplication): computing the shared value is easy, while deriving the private key back is computationally infeasible. A operates with its own private key and B's public key, and B operates with its own private key and A's public key; the results are the same
└── Rationale: the earliest solution to the problem of "transmitting secrets across the air" (1976), and the ancestor of all modern key exchanges. X25519 is its modern elliptic-curve version
```

> **Common Misconception**: The DH exchange itself **does not prevent man-in-the-middle** attacks -- an attacker can perform one DH with A and one with B separately (the "two-person circle" attack). ZT-DSP prevents MITM with two barriers: **(1) the PSK participates in derivation** (Step 4) -- the attacker has no PSK, so even after completing DH he derives a wrong key; **(2) the phase-three confirmation tag exchange** (4.2.3) -- the two parties exchange HMAC confirmation tags that bind all handshake material, and if either party's identity announcement is replaced, the tags will not match and the handshake fails immediately. All three layers of protection (PSK + DH + salt) are indispensable.

**Step 4: Derive the session master key**

```
MK = HKDF-SHA3-256(IKM = PSK ‖ DH, salt = session_salt, info = "ZT-DSP-MK-v3", output = 256 bits)
```

| Line | Code Element | Annotation (input/output/effect) |
|----|----------|------------------------|
| 1 | `MK` | **Output**: the session master key (Master Key), 256 bits. All subsequent keys are derived from it; it is the "master key" of this session |
| 1 | `HKDF-SHA3-256(...)` | **Function**: the key derivation function (see 4.2.2). Processes the input material into a qualified key |
| 1 | `IKM = PSK ‖ DH` | **Input 1**: the PSK (the long-term device-specific key shared by both parties, 256 bits) and the DH result (the shared secret produced by the X25519 ephemeral key exchange, 256 bits) are **concatenated** into the IKM (Input Keying Material). The PSK provides "identity anchoring" -- only two parties holding the same PSK can compute the same MK, which is the key to preventing impersonation; DH provides "session uniqueness" -- every session is different, so even if the PSK leaks, historical sessions cannot be decrypted (forward secrecy) |
| 1 | `salt = session_salt` | **Input 2**: a 256-bit random number generated by the initiator and sent in plaintext together with the public-key packet. **Note: session_salt is the salt parameter of HKDF, not key material concatenated into the IKM**. Effect: it provides "unpredictability" -- preventing an attacker from precomputing (offline brute-forcing the PSK derivation result) |
| 1 | `info = "ZT-DSP-MK-v3"` | **Context string**: the protocol version identifier. Prevents key confusion between different protocol versions/purposes (if two protocols derived from the same input, they would get the same key, which is dangerous) |
| 1 | `output = 256 bits` | **Output length**: requires deriving a 256-bit key |

> **Common Misconception (common pitfall)**: a common way to write the formula is `MK = HKDF(PSK ‖ DH ‖ session_salt)`, which makes the three inputs look "equal and parallel". But the official implementation (the `HKDF` class of the `cryptography` library) passes `session_salt` as a **separate salt parameter** (the standard usage of RFC 5869), and the IKM is only `PSK ‖ DH`. The two derivation results are **completely different** -- a client implemented with the "three equal inputs" form will inevitably fail the handshake with the official client (the phase-three confirmation tags will not match). This is also a cautionary tale about "open protocol, free implementation": freedom of implementation does not mean that formula details may be changed at will; the parameters and the formula must be consistent with the library declaration.

> **Practical Interpretation (triple-input formula)**: Why three inputs instead of one? Historical lessons tell us: using only the PSK (the DRNG approach) → a leak means total collapse; using only DH → impersonation cannot be prevented; using only a salt → anyone can compute it. Each of the three has its own role: **the PSK handles "who you are" (identity anchoring, as part of the IKM), DH handles "this session is unique" (forward secrecy, the other part of the IKM), and the salt handles "cannot be guessed" (as the salt parameter of HKDF)**. If any one is missing, the security model collapses.

**Step 5: Destroy the ephemeral private keys**

sk_A and sk_B are thoroughly zeroized from memory and are no longer retained. The ephemeral private keys exist only within the brief window of phase two. Even if an attacker compromises the device immediately after the session ends, he cannot recover the already-destroyed ephemeral private keys, so he cannot recompute the DH and cannot decrypt historical communications. **This is the engineering realization of forward secrecy.**

> **Practical Tip (Implementation Notes)**: Destruction is not merely "zeroing out"; it must also prevent the compiler from optimizing the zeroing away (the optimizer may treat the zeroing as dead code and skip it). Implementations should use a dedicated "secure zeroization" function (APIs such as `secure_zeroize`/`explicit_bzero`) and lock the memory pages holding keys (mlock) to prevent them from being paged out to disk.

### 4.2.3 Phase 3: Anchor Locking (Confirming Room Uniqueness)

**[Scenario]**: After key derivation completes, both parties need to confirm "we really are in the same room," preventing man-in-the-middle attacks or session confusion.

**[Technical Flow]:**

**1. Compute the anchor**

```
anchor = HMAC-SHA3-256(MK, "ZT-DSP-ANCHOR-v3")
```

| Line | Code element | Comment (input/output/role) |
|----|----------|------------------------|
| 1 | `anchor` | **Output**: a 256-bit anchor value, this session's "identity fingerprint," used to bind the session context |
| 1 | `HMAC-SHA3-256(...)` | **Function**: a keyed hash operation (see 4.2.2). Difference from an ordinary hash: a key participates; without the key the correct result cannot be computed |
| 1 | `MK` | **Input (1)**: the session master key derived in step 4. Only parties that compute the same MK can compute the same anchor |
| 1 | `"ZT-DSP-ANCHOR-v3"` | **Input (2)**: context string, preventing confusion with HMAC results for other purposes |

The anchor's role is: ensuring both parties are in the same session context; deriving all subsequent encryption keys; preventing replay attacks (the sequence number is bound to the anchor). The anchor is a deterministic derivation result -- both parties using the same MK and the same message string will inevitably compute the same anchor.

**2. Derive the session ID (routing identifier)**

```
session ID = the first 32 bytes of HKDF-SHA3-256(IKM = anchor, info = "ZT-DSP-SID-v3", output 256 bits)
```

| Line | Code element | Comment (input/output/role) |
|----|----------|------------------------|
| 1 | `session ID` | **Output**: a 32-byte session routing identifier. The **plaintext** header field of Phase 4 packets; the server delivers the packet to the correct room based on it |
| 1 | `HKDF-SHA3-256(...)` | **Function**: key derivation function, same as above |
| 1 | `IKM = anchor` | **Input**: the anchor computed in step 1. Both parties compute the same anchor -> they inevitably obtain the same session ID |
| 1 | `info = "ZT-DSP-SID-v3"` | **Context string**: marks the purpose as "session ID," preventing confusion with other derivations |
| 1 | `the first 32 bytes` | **Truncation**: after deriving 256 bits, take only the first 32 bytes (the session ID field length) |

> **Practical Interpretation**: The session ID is **plaintext** (the server must read it to route), but it is deterministically derived from the anchor -- a session ID forged by an attacker without the correct MK is discarded outright in Phase 4 as a "session ID mismatch." This is the design of "routing information visible but unforgeable."

**3. Derive the session encryption keys (distinguishing send and receive directions)**

```
(Initiator A's perspective)
EK_send = HKDF-SHA3-256(IKM = MK ‖ anchor ‖ 0x01, info = "ZT-DSP-EK-v3", output 256 bits)
EK_recv = HKDF-SHA3-256(IKM = MK ‖ anchor ‖ 0x02, info = "ZT-DSP-EK-v3", output 256 bits)

(Responder B's perspective: the two role bytes are swapped -- B's EK_send uses 0x02 and EK_recv uses 0x01)
```

| Line | Code element | Comment (input/output/role) |
|----|----------|------------------------|
| 1 | `EK_send` | **Output**: the encryption key used to send data in this direction (Encryption Key), 256 bits |
| 1 | `EK_recv` | **Output**: the encryption key used to receive peer data, 256 bits. EK_send is used for sending and EK_recv for receiving; the two differ |
| 1 | `HKDF(...)` | **Function**: key derivation function, same as above |
| 1 | `IKM = MK ‖ anchor` | **Input**: the master key concatenated with the anchor. Including the anchor guarantees that "each session's EK is unique" -- even if the MK is the same (a theoretical scenario), different anchors derive different EKs |
| 1 | `0x01 / 0x02` | **Role byte**: `0x01` is appended to the end of the IKM for the Initiator direction, and `0x02` for the Responder direction. Role: **distinguish the keys of the send and receive directions** -- A's EK_send exactly equals B's EK_recv, and vice versa; neither side can impersonate the peer using "its own send key" |
| 1 | `info = "ZT-DSP-EK-v3"` | **Context string**: marks the key's purpose as "encryption," distinguishing it from keys for the anchor, authentication, and other purposes |

> **Common Misconception (common pitfall)**: a common way to write it is `EK = HKDF(MK ‖ anchor, ...)` -- direction-agnostic, as if both sides shared a single EK. The official implementation actually derives **two** directional keys, distinguished by the role byte (0x01/0x02) at the end of the IKM. This is both a security design (preventing "reflection attacks": bouncing a packet the peer sent you straight back) and an interoperability detail: a client implemented with the direction-agnostic EK form will fail the handshake due to key mismatch.

**4. Exchange confirmation tags (anchor confirmation)**

After key derivation completes, both parties must still prove to each other that "our handshake material is fully consistent" -- including both parties' identity announcements, parameter JSON, session salt, and public keys. This "complete conversation record" is called the **transcript**:

```
transcript = both parties' Phase 1 raw frames (initiator first) ‖ session_salt ‖ both parties' ephemeral public keys (initiator first)

Initiator sends: confirm_tag_A = HMAC-SHA3-256(MK, "ZT-DSP-CONFIRM-INIT-v3" ‖ transcript)
Responder sends: confirm_tag_B = HMAC-SHA3-256(MK, "ZT-DSP-CONFIRM-RESP-v3" ‖ transcript)
```

| Line | Code element | Comment (input/output/role) |
|----|----------|------------------------|
| 1 | `transcript` | **Input (1)**: concatenate all handshake material exchanged by both parties in a fixed order: both parties' Phase 1 raw frames (initiator first) -> session salt -> both parties' ephemeral public keys (initiator first). If either party's identity announcement, parameters, or public key is replaced, the transcript changes |
| 1 | `HMAC-SHA3-256(MK, ...)` | **Function**: a keyed hash operation. Only parties holding the same MK can compute the same confirmation tag |
| 1 | `"ZT-DSP-CONFIRM-INIT-v3"` / `"ZT-DSP-CONFIRM-RESP-v3"` | **Context string**: distinguishes the tag purposes of initiator and responder, preventing "reflection attacks" (bouncing the peer's tag straight back to impersonate it) |
| 1 | `confirmation tag` | **Output**: a 32-byte HMAC tag. Each side sends one and verifies one: the initiator verifies B's tag, and the responder verifies A's tag |

Exchange order (per the official implementation): the initiator sends its own tag first -> the responder reads it (silently discarding only on frame-level errors -- read failure/abnormal length/timeout) -> the responder sends its own tag -> **both parties each** compare the peer's tag in constant time; on mismatch -> erase all keys and report "anchor confirmation failed: PSK mismatch, role mismatch, or reflection/man-in-the-middle attack." Note: validation of the tag **content** happens after both parties have finished exchanging, not "the responder validates before sending" -- this differs from the "validate first, then respond" order of Phases 1/2 (for the precise timing see Appendix F.4 and Appendix H).

> **Practical Interpretation**: The confirmation tag is the "final exam" of the whole handshake -- if any earlier step (the identity announcement of Phase 1, the public keys and DH of Phase 2) was tampered with or miscomputed, the final tag is bound to mismatch and the handshake fails outright. This is also where the "PSK prevents impersonation" of 4.2.2 truly lands: an attacker without the PSK completes DH but derives a wrong MK, so tag validation is bound to fail.

**5. Initialize the sequence number**

Initial sequence number = 0 (both sides synchronize to zero). The sequence number starts at 0 and increments by 1 for each data packet sent. The receiver accepts only packets whose sequence number is greater than the last received value, preventing replay attacks.

> **Practical tip**: the sequence number is a 64-bit (8-byte) integer; at 1024 packets per second (the default `random_rate`) it takes roughly 570 million years to wrap — but an implementation still must handle the two edge cases of "sequence resets to zero after a session restart" and "an out-of-order packet arrives". **This protocol mandates a strictly monotonic check and forbids a sliding window**: the receiver accepts only `seq > seq_recv` (`seq_recv` starts at −1); any packet with `seq <= seq_recv` is handled as a replay or stale out-of-order packet — drop it, wipe all keys and terminate the session (see 4.2.4 and Appendix F.5). **Why**: the phase-four nonce is built directly as "fixed 4-byte prefix ‖ seq"; tolerating reordering with a sliding window would reuse a nonce under the same key and break both the confidentiality and the integrity guarantees of the AEAD.

```plain
Replay Attack
├── Meaning: the attacker resends intercepted legitimate data packets to the receiver as-is, trying to make the receiver process them repeatedly (e.g., duplicate charges, duplicate commands)
├── Principle: if the receiver cannot distinguish "a new message" from "a replayed old message," it executes it repeatedly. The sequence number (monotonically increasing) is the classic defense: a replayed old packet's sequence number <= the maximum received value, so it is discarded outright
└── Rationale: network attackers inherently possess the ability to "record and replay"; any protocol without stateful validation faces this threat
```

**6. Erase root key material**

After the confirmation tag is verified and the handshake announcement is complete, **MK, anchor, and PSK are all zeroed from memory** (the official client executes `secure_zero` at the end of Phase 3). Thereafter the entire session retains only: EK_send / EK_recv (for data encryption), the session ID (for routing), and the sequence number (for anti-replay).

> **Practical Interpretation**: Why erase after use? This is the "minimal exposure surface" principle: the PSK and MK are needed only during the handshake; the earlier they are destroyed, the less key material remains on a compromised device. Even if an attacker compromises the device at that moment, they cannot obtain the PSK and MK -- only the current session's EK, and the EK is continuously locked and constantly rotated (4.2.5).

### 4.2.4 Phase 4: Encrypted Data Transmission (Box Delivery)

**[Scenario]**: After completing the first three phases, A and B begin exchanging boxes (encrypted data packets). Each box is locked; the front desk can see only its exterior and cannot open it.

**[Packet Structure (complete fields)]:**

> **Wire Layout (verified byte-by-byte against the official client)**: A Phase 4 packet consists of two parts, a "plaintext header + GCM ciphertext," and inside the ciphertext are 7 more fields (**the byte-by-byte layout table with offsets, the fixed order of the receive-validation pipeline, and the measured 165-byte heartbeat packet size are in Appendix F.5; the precise encoding of random padding and the fmt marker is in Appendix G**):

```plain
Wire packet (after encryption):
[session ID(32B, plaintext)] [sequence number(8B, plaintext)] [ciphertext length(4B, plaintext)] [GCM ciphertext(variable) + authentication tag(16B)]

Plaintext payload (before encryption, i.e. the content of the GCM ciphertext):
[timestamp(8B)] [payload format marker fmt(1B)] [destination token hash(32B)] [source token hash(32B)]
[user plaintext(variable)] [random padding(0~2048B, present only when fmt=0x01)] [padding length(2B, present only when fmt=0x01)] [next_seed(32B)]
```

| Field name | Length | Encrypted | Description |
|----------|------|------|------|
| Destination token hash | 32B | Yes | Encrypted with the session key EK, preventing plaintext identity linkage. The server sees the encrypted destination hash and cannot know whom the message is sent to |
| Source token hash | 32B | Yes | Same as above. Encryption prevents traffic analysts from building a social graph through source-destination linkage |
| Timestamp | 8B | Yes | Millisecond Unix timestamp (uint64 big-endian). The receiver checks `|current time − timestamp| <= timestamp window` (default 30 seconds), preventing replay and delayed interception |
| Payload format marker fmt | 1B | Yes | `0x00` = no random padding (default), `0x01` = with random padding. The receiver strips padding per this marker; the official client can enable padding unilaterally without negotiation between the two parties |
| Random padding | 0~2048B | Yes | Reference recommendation 512~2048B. Padding removes the length fingerprint so that all packets are similar in size. Off by default in the official client (enabled via `--padding-min/max`) |
| Pre-key seed next_seed | 32B | Yes | Ratchet seed for the next packet: `new_EK = HKDF-SHA3-256(IKM = current EK ‖ next_seed, info = "ZT-DSP-EK-ROTATE", output 256 bits)` (continuous locking, see 4.2.5) |
| User plaintext | variable | Yes | The actual message content (including heartbeat empty packets: plaintext length 0) |
| Session ID | 32B | No | Plaintext routing field, derived from the anchor. The server delivers the packet to the correct room based on the session ID |
| Sequence number | 8B | No | Plaintext; 64-bit monotonically increasing, preventing replay attacks. The receiver checks that the sequence number is greater than the last received value, otherwise it discards the packet |
| Ciphertext length | 4B | No | Plaintext length field; the receiver reads it first, then reads the ciphertext |
| GCM authentication tag | 16B | No | The authentication tag automatically attached by AES-256-GCM. **Authentication scope = AAD + all ciphertext**; tampering with any field causes validation to fail |

> **Two key constructions (required reading for implementers)**:
>
> - **AAD (Additional Authenticated Data, not encrypted but authenticated)**: `AAD = session ID ‖ sequence number(8B big-endian)`, 40 bytes in total. The server must be able to read the session ID and sequence number to route and filter, yet must not let attackers tamper with them -- AAD exactly satisfies "visible and tamper-proof." AAD contains no version string.
> - **GCM nonce (number used once)**: `nonce = 0x00000000(4B) ‖ sequence number(8B big-endian)`, 12 bytes in total. The sequence number increases monotonically -> each packet's nonce is unique, satisfying the hard requirement that "a nonce is never reused under the same key."

```plain
AES-256-GCM (Advanced Encryption Standard 256 + Galois/Counter Mode)
├── Meaning: a symmetric encryption algorithm (AES, 256-bit key) paired with an authenticated encryption mode (GCM); a single algorithm provides both "encryption" and "integrity authentication"
├── Principle: AES turns plaintext into ciphertext (confidentiality); GCM mode generates an authentication tag (like an "anti-counterfeiting code"), so tampering with any single bit makes tag validation fail (integrity + authenticity)
└── Rationale: encryption without authentication would let a "ciphertext flipping" attack tamper with the content; GCM fuses encryption and authentication, with good performance (parallelizable) and strong security, and is the de facto standard of modern communication
```

```plain
IV (Initialization Vector) / Nonce (number used once)
├── Meaning: a random value introduced during encryption so that "the same plaintext" encrypts into "different ciphertext"
├── Principle: cryptography requires each encryption operation under the same key to use a different IV; otherwise the same plaintext produces the same ciphertext, from which an attacker can infer content patterns
└── Rationale: without an IV, encryption degrades into a "guessable substitution table." The uniqueness of GCM's IV is crucial -- reusing an IV directly destroys GCM's security
```

```plain
AAD (Additional Authenticated Data)
├── Meaning: data that is not encrypted but participates in authentication -- the receiver verifies its integrity, while its content remains publicly visible
├── Principle: GCM computes the authentication tag over "ciphertext + AAD" together; if the AAD is tampered with, tag validation fails
└── Rationale: routing fields (session ID, sequence number) must be visible to the server for forwarding, yet must be tamper-proof -- AAD exactly satisfies the dual requirement of "visible and tamper-proof"
```

> **Common Misconception**: GCM "authentication" is not the same as a "signature." A GCM authentication tag proves that "the data has not been tampered with and was indeed sent by a party holding the EK," but it cannot prove the sender's identity to a third party (that is the job of Ed25519 signatures). The two mechanisms serve different purposes; do not conflate them.

> [Privacy Risk] Although the payload is encrypted, **traffic patterns can still leak information**: packet size (already mitigated by padding), sending frequency, session duration, and connection relationships (the server still knows that "session IDs X and Y are communicating"). This is why the protocol emphasizes random padding + timing jitter (Section 5.4).
>
> [Protection Recommendations] (1) Use random padding (512~2048B) to flatten the length fingerprint; (2) enable send timing jitter in high-security scenarios (Appendix G.3); (3) rotate the session ID periodically (via continuous-locking hops) to shorten the correlatable window.
>
> [Compliance Note] Under end-to-end encryption (E2EE), the server never touches plaintext, which is itself the strongest privacy protection practice. But operators should still follow the metadata minimization principle: do not record correlatable data such as session duration or traffic volume.

**[Sending Flow]:**

1. A encrypts the payload (message content) using EK_send, generating the GCM ciphertext and authentication tag
2. A packs the destination token hash, source token hash, timestamp, fmt marker, and next_seed together into the plaintext payload (preventing plaintext identity exposure)
3. A forwards the entire packet to B through the server
4. The server is responsible only for delivery; it does not open the box

> **Practical Detail ("consume state first, then attempt to send")**: Before sending, the official client first completes three things: (1) generates a new next_seed and derives the next packet's key `new_EK = HKDF(current EK ‖ next_seed, "ZT-DSP-EK-ROTATE")`; (2) zeroes the current EK in memory and replaces it with new_EK; (3) increments the sequence number by 1. Only then does it encrypt and send the current packet. This means: even if the send fails (network outage, connection cut), the key has already been rotated -- an attacker cannot exploit "send failure means the key was not rotated" to replay old packets. The price is that the session cannot recover after a send failure and can only reconnect (the official client prompts "the session has irreversibly desynchronized").

**[Receiving Flow]:**

1. After B receives the packet, it first checks whether the **sequence number** is strictly greater than the last received value (`seq > seq_recv`, with `seq_recv` starting at −1); otherwise -> **drop the packet, wipe all keys and terminate the session** (replay attack or a stale out-of-order packet)
2. B then checks whether the **session ID** matches the current session; on mismatch -> **drop the packet and terminate the session** (crosstalk or a leftover packet from an old session)
3. B verifies the **GCM authentication tag**; on failure -> **drop the packet and terminate the session** (data tampered with or key mismatch)
4. After decrypting the payload, B performs **three internal checks**: (1) whether the payload structure length is self-consistent (bounds checking); (2) whether the payload format marker is valid (unknown fmt); (3) **bidirectional token hash validation** -- the in-packet destination token hash must equal the local identity and the source token hash must equal the peer identity (preventing traffic reflection/crosstalk/identity forgery). Failure of any of these -> **drop the packet and terminate the session**
5. B checks the timestamp: `|current time − timestamp| > timestamp window` (default 30 seconds) -> the packet **has passed GCM authentication but is outside the window**; in this case **only the plaintext is discarded, while the EK is still rotated and the sequence number advanced** (preventing a permanent session desynchronization when the sender has rotated but the receiver has not) -- **this is the only failure branch that does not terminate the session**
6. B obtains the plaintext message normally. A packet with plaintext length 0 is a **heartbeat packet**, which the receiver silently skips (the official client sends one every 30 seconds to detect half-open connections)

> **Practical Tip (both the receive order and the failure policy matter)**: Always process in the order "sequence number -> session ID -> authentication tag -> decryption and internal validation -> timestamp." This order is itself a security design: cheap filtering first (sequence number/session ID), then expensive cryptographic verification (GCM), and only then decryption -- preventing both DoS (junk packets do not trigger decryption) and information leakage (not exposing "why it was dropped"). **Except for the timestamp-window case in step 5, every validation failure must "terminate silently"**: drop the packet, wipe all keys, end the session, and return no error code to the peer -- consistent with the termination policy of Appendix F.5 and with the reference implementation's `session.py` behavior.

### 4.2.5 Continuous Locking and Forward Secrecy

In the fourth phase, each encrypted data packet carries not only a message but also an extra "pre-key seed":

- Current packet: encrypted message + "key seed for the next packet"
- Next packet: uses the seed announced by the previous packet to derive a new EK, then carries the seed for the packet after that

The official client's ratchet rotation formula (once per packet):

```plain
new_EK = HKDF-SHA3-256(IKM = current EK ‖ next_seed, info = "ZT-DSP-EK-ROTATE", output = 256 bits)
```

| Element | Comment (input/output/role) |
|------|------------------------|
| new_EK | **Output**: the next packet's encryption key, replacing the current EK (the current EK is zeroed immediately afterward) |
| current EK ‖ next_seed | **Input**: the current key concatenated with the 32-byte pre-key seed carried by this packet. The seed is freshly generated by the sender each time (true random), so the next packet's key is unpredictable |
| info = "ZT-DSP-EK-ROTATE" | **Context string**: distinguished from "ZT-DSP-EK-v3" -- the latter derives the initial EK, while the former performs per-packet rotation |

This process is **continuous locking**:

- Even if an attacker intercepts the Nth packet, they cannot decrypt the N+1th packet (the key has changed)
- The two parties continuously "hop channels" via pre-keys, forming a forward-secrecy chain
- The virtual room ensures this hopping process is not interrupted by external connections
- Sub-channels allow multiple independent forward-secrecy chains to exist in parallel within the same room

> **Practical Tip (keepalive and desynchronization)**: The official client sends an **empty-payload heartbeat packet** (plaintext length 0) every 30 seconds, specifically to detect "half-open connections" (one side has dropped off, but the TCP connection is undetected because no data was sent). Heartbeat packets also participate in ratchet rotation -- even with no messages, the key chain keeps advancing. This is also why "an out-of-window packet must still rotate the EK and advance the sequence number" (4.2.4 receiving flow step 5) is so important: if the sender's heartbeat packet is discarded wholesale for being outside the timestamp window without rotation, the two ratchets desynchronize and all subsequent packets become undecryptable.

> **Related Knowledge**: Continuous locking shares its origin with the "Double Ratchet" idea of the Signal protocol (the encryption foundation of WhatsApp/Signal) -- both "change the key with every message sent." The difference is that ZT-DSP's hopping is done entirely internally by the two parties (the pre-key seed travels with the packet) and does not depend on any server logic.

## 4.3 Silent Drop Mechanism

Silent Drop is the core of ZT-DSP's confrontation architecture. Picture this scenario: an attacker is scanning the internet, looking for ZT-DSP servers. They send various probe packets to the target port: 1 byte of junk data, 32 bytes of random data, 128 bytes of forged data. (The above is a hypothetical scenario, not a technical description)

If the server returned a different error code for each kind of error (e.g., "length error," "format error," "invalid signature"), the attacker could infer from the differences in the error codes: "this port is running ZT-DSP, and its parameters are like so..."

**Silent drop eliminates this information leakage.** Whatever the attacker sends, the server behaves like a "closed port" -- no response at all. This makes large-scale protocol probing extremely difficult.

> **Everyday Analogy**: Picture this scenario: silent drop is like a "light-proof door" -- the person knocking can only get "silence" and cannot tell from the response whether an empty room, a vault, or a whole squad of guards is behind the door. An ordinary protocol's door, by contrast, reveals its internal structure through "creaks" (error codes).
> (The above is a hypothetical scenario, not a technical description)

> **Practical Tip (implementation pitfalls)**: The "silence" of silent drop must be carried through to the end -- (1) return no network response; (2) record no logs (logs themselves are feedback for the attacker and also make the server a forensic target); (3) perform no expensive operation before dropping (drop at the outermost parameter check, preventing DoS amplification); (4) keep the timing of the drop path as consistent as possible with the normal path (so that attackers cannot infer "this really is a ZT-DSP server" from "response time differences").

> **Common Misconception**: Silent drop ≠ "no defenses." It is an "anti-probing" layer, not an "anti-attack" layer -- a legitimate packet that passes the parameter check must still go through the full line of defenses: signature verification, CRL lookup, GCM validation, and so on. A server that relies only on silent drop without implementing validation logic will be easily breached by a malicious client holding a legitimate token.

> **Supplementary note**: This section discusses the **idea** of silent drop. The Responder-side **behavioral contract** of "strict silence" -- which failures must be silent (the full trigger table), the precise semantics of "send nothing, close nothing, suspend and swallow bytes" during silence, and why the initiator is asymmetric -- is in **Appendix F.2**; the complete matrix of failure paths at each phase is in **Appendix H.4**.

# Volume Five: Security Boundaries and Threat Model

> **[Reader's Guide to This Book]** This book answers a key question: **Under which attacks is ZT-DSP still secure? Under which attacks does it fail?** Understanding "security boundaries" matters more than understanding "security features" -- knowing what you cannot defend against is what prevents a false sense of security.
>
> **[Focus for Beginners]** Focus on 5.1 (untrusted server) and 5.4 (the defense matrix for layered attacks (nine-layer threat)). The "Security Guarantees and Boundaries" of 5.5 is the most important honest statement in the whole document; be sure to read it through.
>
> **[Prerequisites]** The four-phase handshake of Book Four. This book is the "stress test" of Book Four's security properties.

## 5.1 Untrusted Server Scenario

**Threat**: The server operator tries to snoop on users' communication content.

**Defense**:

- **End-to-end encryption**: The server can only see encrypted data packets and cannot decrypt them

```plain
End-to-End Encryption (E2EE)
├── Meaning: data is encrypted only at the sender and decrypted only at the receiver; every intermediate link (server, carrier) can see only ciphertext
├── Principle: encryption keys are derived only at the two endpoints (Book Four, Phases 2/3); the server never holds any key material
└── Rationale: a server being breached, coerced, or acting maliciously from within are all real threats; E2EE makes the server "unable to see even if it wants to"
```

- **Server-layer encryption**: Server-layer encryption is disabled by default, or a TLS 1.3/WireGuard tunnel is used (the server does not hold the tunnel keys)

```plain
TLS 1.3 (Transport Layer Security 1.3)
├── Meaning: the encryption foundation of HTTPS, protecting the transmission security of the "client--server" link
├── Principle: the client and server first handshake to negotiate keys (certificate verification + key exchange), after which all traffic is encrypted in transit
└── Rationale: preventing eavesdropping and tampering in transit (Wi-Fi phishing, carrier hijacking). Note: TLS protects the "link" (you to the server), while E2EE protects "end to end" (you to the peer); the two are different layers and can be stacked
```

```plain
WireGuard (a modern VPN tunneling protocol)
├── Meaning: a lightweight, fast encrypted tunneling protocol, often used to form private networks out of multiple devices
├── Principle: based on Curve25519 key exchange + ChaCha20 encryption; simple to configure (one public key is one node identity)
└── Rationale: replaces the aging IPsec/OpenVPN -- less code, easier to audit, higher performance; it has become the de facto new standard for VPNs
```

- **Token hash encryption**: In Phase 4 and beyond, token hashes are encrypted with the session key, so the server cannot link long-term identities

**The worst the server can do**: refuse to forward (disconnect), delay forwarding (slow down), drop packets for specific sessions -- all availability attacks, but it cannot steal content.

**What the server cannot do**: decrypt any data packet (no PSK, no session key); impersonate a resident (no token private key, no authorization code); correlate identities across sessions (token hashes are encrypted and the session key changes each time).

> [Privacy Risk] Although the server cannot decrypt the content, it **still possesses communication metadata**: the correspondence between session IDs, traffic volume and frequency, and connection duration. Under extreme surveillance, metadata suffices to paint a social graph of "who communicates with whom and when" (even without knowing what is said).
>
> [Protection Recommendations] (1) The server operator voluntarily "does not record" ; (2) users spread and break up correlation through multiple servers; (3) scenarios sensitive to session duration can reconnect periodically (cutting off correlatable continuous sessions).
>
> [Compliance Note] The server operator is in the position of a "data processor": even if it technically cannot decrypt content, it should follow the metadata minimization principle and publish a privacy policy stating "what is recorded and what is not."

## 5.2 Untrusted Client Scenario

**Threat**: A malicious client tries to join the network, launch attacks, or steal information.

**Defense**:

- Token signature verification: tokens without a valid Ed25519 signature cannot pass Phase 1
- Authorization code whitelist: clients without an authorization code cannot enter servers that require one
- PSK verification: even inside a room, without the PSK the HKDF derivation after X25519 cannot be completed
- Sequence number and anchor: a malicious client cannot predict the sequence number and keys of a legitimate session

> **Practical Interpretation**: The defenses in this section are **layered** -- signature verification stops "the undocumented," the authorization code stops "those without access," the PSK stops "impersonators," and the sequence number stops "replayers." Each layer works independently; breach one and the next still stands. This is the idea of "Defense in Depth": never stake security on a single mechanism.

## 5.3 Untrusted TCA Scenario

**Threat**: A TCA private key leaks, is coerced into issuing forged tokens, or is shut down by a government.

**Defense**:

- Multi-TCA federation: the defection of a single TCA does not destroy the whole ecosystem; users can switch to another TCA
- Fast freezing: the system supports freezing the public key of a compromised TCA, invalidating its signatures
- Historical sessions unaffected: X25519 provides forward secrecy; the keys of established sessions do not depend on the TCA
- Multiple tokens per device: users can hold tokens from multiple TCAs, reducing single-point dependence

> **Everyday Analogy**: Picture this scenario: multi-TCA federation is like "multiple national passports" -- if one country invalidates your passport, you still have other countries' passports to use; the server operator is like "multi-national border control" -- a hotel that does not accept country A's passport may accept country B's.
> (The above is a hypothetical scenario, not a technical description)

## 5.4 Full-Chain Active Confrontation Scenario (Layered Attacks (Nine-Layer Threat))

**Threat model (layered attacks (nine-layer threat)):**

1. **Information Interception**: the attacker intercepts all network traffic
2. **Secondary Replay**: the attacker repeatedly sends legitimate data packets
3. **Environment Simulation**: the attacker forges servers, clients, or TCAs
4. **Traffic Reflection**: the attacker reflects packets back to the sender
5. **Traffic Monitoring**: the attacker analyzes traffic patterns, timing, and sizes
6. **Encrypted Traffic Reflection**: the attacker re-sends intercepted encrypted traffic to test reactions
7. **Traffic Confusion Packing**: the attacker corrupts packet structure and injects junk data
8. **Random Traffic Killing**: the attacker randomly drops packets
9. **Random Traffic Delayed Interception**: the attacker delays packet arrival times

```plain
Traffic Analysis
├── Meaning: without breaking the encrypted content, inferring communication behavior solely by observing traffic characteristics (size, timing, direction, frequency)
├── Principle: even when the content is encrypted, metadata remains exposed; for example, "sending exactly 1KB packets every hour late at night" itself leaks a behavior pattern
└── Rationale: this is the dominant surveillance method of the encryption era -- the attacker need not decrypt, since the pattern alone suffices; the defense is "flattening the characteristics" (padding, jitter, noise)
```

**Defense matrix:**

| Attack Method | Defense Mechanism |
|----------|----------|
| Information interception | End-to-end X25519+AES-GCM; the interceptor cannot decrypt |
| Secondary replay | 64-bit incrementing sequence number + timestamp window; a replayed packet's sequence number <= the maximum received value -> drop the packet, wipe all keys and terminate the session |
| Environment simulation | PSK verification + Ed25519 signature + silent drop; no PSK = cannot generate the correct randomness/beacon |
| Traffic reflection | Session ID binding + source/destination token hash validation; a looped-back packet's destination hash does not match the receiver's identity -> drop the packet and terminate the session |
| Traffic monitoring | Random padding (512~2048B) + timing jitter, eliminating length and timing fingerprints |
| Encrypted traffic reflection | GCM tag validation failure -> terminate silently (drop the packet, wipe all keys, end the session) |
| Traffic confusion packing | Length check -> terminate silently; GCM validation failure -> terminate silently (each drops the packet and ends the session) |
| Random traffic killing | Single-path dependency; interruption possible (mitigated by spreading across multiple servers) |
| Random traffic delayed interception | Timestamp + sequence number + pre-key hopping; an out-of-window packet only has its plaintext dropped and does not terminate the session |

> **Practical Interpretation (what the table teaches)**: Note that almost every defense mechanism means "**if validation fails, do not converse with the attacker**" -- the protocol only checks, handles failures silently, and never returns an error code. Two layers must be distinguished: **failures before the session is established** (PSK/signature/format) are true silent drops; **failures after the session is established** (sequence number/session ID/GCM/token hash) follow the silent termination of Appendix F.5 (drop the packet, wipe the keys, end the session). This "say little, do much" style runs through the whole protocol: every defense mechanism reduces the information an attacker can exploit (timing information, error information, length information). The **precise wire encoding** of the two defenses, padding and jitter (the fmt marker, the pad_len field position, unilateral-enablement semantics), is in Appendix G.

## 5.5 Security Guarantees and Boundaries

Under the layered attacks (nine-layer threat) above, ZT-DSP can guarantee:

- **Guaranteed** — **Confidentiality**: the attacker cannot decrypt communication content (unless the PSK is leaked)
- **Guaranteed** — **Integrity**: the attacker cannot tamper with data without being detected
- **Conditional** — **Availability**: under extreme attacks, communication may be interrupted
- **Not guaranteed** — **Anonymity (absolute)**: if an attacker monitors globally and correlates multiple carriers, anonymity may be reduced
**Absolute security does not exist.** The goal of ZT-DSP is: unbreakable at the cryptographic level, as resilient as possible at the engineering level (resilient, i.e. the ability to recover and survive in a degraded state after being attacked), and to maintain a minimum level of survival in extreme scenarios.

> **Common Misconception (the single most important one in this document)**: **Anonymity ≠ Encryption.** What ZT-DSP guarantees is "content is not decrypted, identity is not impersonated", but it **does not guarantee** that "you as a person will not be discovered". Through traffic analysis, physical positioning, and behavioral patterns, an attacker may still narrow down your range. In addition, cryptographic security ≠ operational security (OPSEC) -- no matter how strong the encryption you use, if spyware is installed on the device, or you yourself leak the door number, you are still not secure.
>
> [Privacy Risk] Boundaries of the threat model: this protocol does not defend against "physical contact attacks" (forensics after a device is confiscated), does not defend against "side-channel attacks" (power/electromagnetic analysis), and does not defend against "social engineering" (tricking you into handing over a token/door number).
>
> [Protection Recommendation] Complete protection in high-threat scenarios = protocol encryption (this protocol) + device physical security (TPM, full-disk encryption) + operational discipline (OPSEC, not using it on insecure devices). The absence of any single link lowers the overall security level.

# Volume 8: FAQ and Common Misconceptions

> **[Introduction to This Volume]** This volume collects the 15 questions beginners ask most often. Each question is annotated with the corresponding technical points and common misconceptions; it is a volume of the "quick reference manual" kind.
>
> **[What Beginners Should Focus On]** It is recommended to read through this volume after finishing Volume 3 -- it can verify whether your understanding is on track (you can find a corresponding chapter for every question in Volume 3/4).

## Q1: I don't have a door number, so how do I enter the hotel to find someone? Isn't this an infinite loop?

**A: It is not an infinite loop.** The door number is not issued at the hotel; you carry it with you before you even enter the door. In ZT-DSP, the door number (token hash) is obtained through out-of-band channels: QR code scanning, encrypted email, meeting in person, direct P2P, etc. If you did not bring a door number, the hotel front desk will not tell you anyone's room number -- this is not a bug, it is the bottom line of anonymity.

The flow is: ① Before going out, obtain the other party's door number H(Token_B) through an out-of-band channel -> ② At the hotel, show the front desk your own door number H(Token_A) and the other party's door number H(Token_B) -> ③ The front desk checks the match and sends you into the same room.

> **Common Misconception**: "without a door number you cannot get in the door" ≠ a flawed protocol. Picture this scenario: this is like "without an address you cannot send a letter" -- it is not a problem with the post office, but an essential requirement of communication. ZT-DSP explicitly does not do "stranger discovery" (Q4); this is a feature, not a bug. (The above is a scenario, not a technical description)

## Q2: Then where does my door number come from? What exactly does the TCA do?

**A: The TCA (security guard) is not there to help you find people, but to issue you an ID card.**

- TCA = identity factory: after verifying your device, it issues a token (containing a random seed + Ed25519 signature)
- Door number = the hash of the ID card: you make a copy of the ID card (SHA-3-256) to obtain the door number, which is used to find people in the hotel
- Token storage: by protocol design your original ID card (token) should be securely kept in the device's TPM/HWID, non-exportable and non-copyable (**no hardware storage is implemented in 1.0.0**)

Key point: one device can hold multiple ID cards issued by multiple TCAs (multiple tokens); a TCA is only responsible for "does this person have a legitimate ID card", not for "whom this person wants to find"; finding people is your own business.

## Q3: Why must there be a TCA? Isn't this centralization?

**A: The TCA is not a centralized authority, but a social consensus.**

Anyone can build their own TCA and issue tokens for a small circle. A TCA's authority depends on how many people recognize and join it. One device can hold tokens from multiple TCAs, and one server can hold the whitelists of multiple TCAs.

If no TCA existed, anarchic clients would destroy the entire protocol ecosystem: anyone could generate identities infinitely, launch spam connections and DDoS attacks, and public-interest servers would collapse within hours. **The existence of the TCA is reasonable control of users while maintaining anonymity.** You do not need to cling to one TCA authority.

> **Common Misconception**: TCA ≠ central server. The TCA only does "issuing + revocation"; it does not participate in communication, does not hold keys, and is not on the data transmission path. Picture this scenario: comparing it to a "passport-issuing country" is more accurate -- the passport country knows you have a passport, but does not know where you took the passport or whom you met. (The above is a scenario, not a technical description)

## Q4: If my friend and I have never met and cannot exchange door numbers out-of-band, can we still use ZT-DSP?

**A: No direct connection.** The core design of ZT-DSP is "no presupposed trust, no presupposed connection" -- if you do not know the other party's door number, the protocol will not help you "discover" them.

Alternatives: forward the door number through a trusted intermediary (a mutual friend); publish the door number on a public bulletin board and wait for the other party to make contact; use a third-party application-layer protocol that supports group discovery, establish initial trust on it, and then descend to ZT-DSP for encrypted communication.

**ZT-DSP is a pipe, not a yellow pages directory.** It is responsible for letting people who already know each other communicate securely, not for letting strangers discover each other.

## Q5: Can the server see which sub-channel I am speaking in?

**A: No.** The server (front desk) can only see which room you entered (based on door number hash matching) and that you are sending data packets (boxes). But the boxes are encrypted (AES-256-GCM) and the server cannot open them; the session key of a sub-channel is independently derived by the clients inside the room, with the server taking no part; the instructions to create/destroy a sub-channel are themselves encrypted.

The server knows "there are devices communicating in this room", but not "which sub-channel they are in, or what they said".

> **Related Knowledge**: This embodies the "minimum information" design -- the server gets only the minimum information needed for routing (the room number), cannot get the content (encrypted), and cannot get the substructure (sub-channels). This echoes the metadata discussion in Section 5.1.

## Q6: Wanting both anonymity and a TCA to "manage" -- are these two contradictory?

**A: Anonymity and management are not opposites; they are isolated by layers.**

| Layer | Who knows you | How much they know |
|------|----------|----------|
| TCA (security guard) | Knows you | Only knows your device has a legitimate ID card, not whom you want to find or what you said |
| Server (front desk) | Does not know you | Only recognizes the door number hash, not the real person behind the ID card |
| Communication peer | Knows you | Only they know that the door number corresponds to you (because you exchanged it out-of-band) |

The TCA exists to prevent anarchic abuse. With a TCA, the server can filter out "guests without a legitimate ID card" through a whitelist, protecting public-interest resources. But you can always choose: use multiple TCAs and do not lock yourself to a single authority; use P2P mode and bypass TCAs and servers entirely.

> **Common Misconception**: "anonymity" ≠ "no one knows any information about you". ZT-DSP's anonymity is **layered anonymity**: each layer knows only the minimum information needed to perform its function (see the table above). Absolute, unconditional anonymity does not exist in the real world (see 5.5).

## Q7: What is a virtual room?

**A: A virtual room is a protective shield in the "continuous lock" state.** After A and B enter Phase Four (encrypted data transmission), both parties start continuous locking -- continuously jumping to a new encryption context through the "next pre-key" inside the data packets, to prevent external tracking.

In this process, the server maintains a room placeholder for this pair of devices; if a third party C also holds the same door number hash (rare but possible) and tries to join this room, the server directly intercepts and discards the request. This protected placeholder space is the virtual room -- it exists, but is invisible and inaccessible to the outside.

## Q8: What is a sub-channel?

**A: A sub-channel is a "temporary group chat" inside a room.** In one room (matching pool), A and B have established a one-to-one connection, but both parties can negotiate to open a sub-channel and invite more devices holding the same door number prefix or derived tokens to join. Each sub-channel has an independent session key (EK), sequence number space, and anchor derivation path.

Key features: content is not saved (all data flows only in memory; the server neither records, caches, nor writes to disk); mutual non-interference (room-level continuous locking and sub-channel-level continuous locking run independently); burn-after-use (sub-channels can be dynamically created and destroyed, and keys are immediately discarded after closing).

> **Practical Interpretation**: "burn-after-use" (immediate key discard) is the core mechanism of the sub-channel design -- once the session ends, the key is void, leaving not even room for "decrypting history". This is precisely the embodiment of the "data minimization" principle at the session layer.

## Q9: How is channel hopping implemented? What does "next pre-key" mean?

**A:** In Phase Four, each encrypted data packet, besides carrying a message, additionally carries a pre-key seed: current packet = encrypted message + "key seed of the next packet"; next packet = derive a new EK using the seed announced by the previous packet, then carry the seed of the packet after next.

This is continuous locking: even if an attacker intercepts the Nth packet, they cannot decrypt the N+1th packet (the key has changed); the two parties keep "hopping channels" through pre-keys, forming a forward-secure chain; the virtual room ensures this hopping process cannot be interrupted by external connections; sub-channels allow multiple independent forward-secure chains to exist in parallel within the same room.

> **Everyday Analogy**: Picture this scenario: continuous locking is like "changing to a new password in every exchange" -- the last character of the previous sentence tells you the password for the next one. Even if an eavesdropper records the entire conversation, without the ability to derive the "next sentence's password", they can only hear a mass of encrypted noise.
> (The above is a scenario, not a technical description)

## Q10: Why is there no 32KB hash exchange?

**A:** A common design adds a "collision mechanism" to Phase Two: both parties generate 1024 random numbers and exchange 32KB of hash values for comparison. This design is cryptographically redundant — both parties already hold the same PSK, and a deterministic derivation function necessarily yields the same output; exchanging hashes to verify adds neither security nor authentication.

More importantly, the 32KB exchange brings problems such as traffic correlation (a strong fingerprint, which can be used to identify a ZT-DSP handshake), DoS amplification (a forged handshake request forces the server to forward a huge amount of hash data), and excessive latency (close to the performance limit on a 200ms-latency network). The protocol therefore omits any redundant collision phase and derives keys directly (X25519 + HKDF).

> **Common Misconception**: "exchanging hashes for verification" sounds more secure (one extra check), but is in fact **redundant and harmful**: what both parties derive is the result of the same deterministic function, so verifying it amounts to "verifying yourself with yourself"; and the 32KB traffic signature instead gives attackers a chance to identify the protocol. Security design is not "the more checks the better", but "every step has independent value".

## Q11: Is emergency mode still there?

**A: It has been removed from this specification.** The former "emergency whistle" (once called "emergency mode") relied on premises that do not hold under current engineering and physical conditions, and was subsequently deleted; the corresponding entry in the terminology table was removed at the same time.

## Q12: Can I modify the protocol's parameters?

**A: Yes, and this is a core feature of the protocol design.** ZT-DSP is an open protocol, and all parameters can be modified freely: random number length (16-bit, 64-bit, 256-bit, 1024-bit), generation rate (1 per second, 128 per second, 1024 per second, no software upper limit), time window (10 seconds, 30 seconds, 60 seconds, custom), encryption algorithm (AES-GCM, ChaCha20-Poly1305, or another algorithm you trust). The official client also provides two additional adjustable items: the **timestamp window** (`--time-window`, default 30 seconds, configurable per-peer; a narrow window gives high security, a wide window gives high availability) and **random padding/timing jitter** (`--padding-min/max`, `--jitter`, off by default).

But note: **the client and the server must use the same parameters to communicate.** If the server declares "I only accept 128 64-bit random numbers per second" while your client sends "1024 16-bit random numbers per second", the server will directly silently discard your packet, with no error message at all. This is the role of the "library": the server declares its parameter dialect in its library, and the client must fetch the library and match its parameters.

> **Practical Tip (security reminder)**: Parameters can be changed, but **weakening security parameters is not recommended**: a random number length below 128 bits or the use of known weak algorithms (such as MD5, SHA-1, DES) will significantly reduce security. The protocol allows free modification to "adapt to scenarios" (e.g. low-power devices using shorter random numbers), not to "cut corners".

## Q13: What is "silent drop"? Why does it not return an error when parameters do not match?

**A: Silent Drop is the core of ZT-DSP's adversarial architecture.** If the server returned a different error code for every kind of error (such as "length error" or "format error"), an attacker could infer from the differences in error codes: "this port is running ZT-DSP, and its parameters are like this..."

Silent drop eliminates this information leak. Whatever the attacker sends, the server behaves like a "closed port" -- with no response at all. This makes large-scale protocol probing extremely difficult.

> **Common Misconception**: silent drop means "no error reported" when you troubleshoot, but this does not mean the protocol is poorly designed -- it is a **deliberate** stealth mechanism. When debugging, check the parameters item by item against the library file (length/rate/window/algorithm), or temporarily enable debug mode in a test environment (be sure to turn it off in production).

## Q14: Can I use ZT-DSP to do illegal things? Will the protocol assist me?

**A: ZT-DSP is a communication protocol. Like TCP/IP, HTTP, and SMTP, it is a neutral technical tool.** The protocol itself neither encourages nor prevents any particular use. It can be used for privacy-protecting personal communication, secure contact between journalists and sources, encrypted communication within an enterprise, and academic research and technical experiments; it can also be abused for spreading illegal content or coordinating criminal activity.

**A protocol cannot distinguish between legitimate and illegitimate uses. Responsibility for the user's behavior rests with the user, not with the protocol designer or implementer.** At the same time, note: technical anonymity is not legal anonymity, and cryptographic security is not operational security (OPSEC). In extreme scenarios, the reliable approach is not to transmit over any channel at all.

> **Common Misconception**: encrypted communication ≠ legal exemption. Different countries have different rules on encrypted communication and anonymous networks (some require "lawful interception" capability and prohibit unlicensed encryption); "technically unbreakable" does not mean "legally unaccountable" -- your devices, the people you meet, and your behavioral patterns can all become law-enforcement evidence. Before using any encryption tool, understand and comply with local law.


## Q15: Why can't single-digit comparison confirm whether the peer is trustworthy?

**A: Because a single digit has only 10 to 52 possibilities, an attacker can guess it without the PSK, and one captured packet is enough to recover the PSK offline.**

One proposal: two parties share a PSK, each substitutes it into a formula to compute **the same single digit** (a number or letter), report it to each other, and treat a match as proof that the peer is the target. This proposal **must never be adopted**.

It fails for three reproducible reasons:

1. **Determinism** -- the same PSK always yields the same answer; the scheme contains no freshness whatsoever.
2. **Tiny output space** -- a single decimal digit has 10 possibilities, a letter at most 52; guessing 10 to 52 times succeeds, **entirely independent of PSK strength**.
3. **It constitutes an offline verification oracle** -- after intercepting one comparison value, an attacker can **recompute that digit offline for any guessed PSK**; each guess costs one hash, so **verification cost equals guessing cost**, with no extra barrier.

The conclusion: this practice does not cover the PSK -- it **deliberately provides a free offline PSK brute-force interface**. It **does not constitute authentication**.

The correct approach: the random value must be **salted and ever-changing**. The nonce is derived via HKDF using the PSK as input keying material, a **fresh random salt generated per session**, and `random_len` as the output length (see F.3). The salt is secret and **is not transmitted with any frame**, so an attacker who captures the nonce still cannot verify any PSK guess. Authentication is performed by the phase-three confirmation tags.

> **Common Misconception**: given that both parties genuinely hold the same PSK, any digit is necessarily identical. That is a **property** explaining why the two sides can agree; it **must never** be treated as a **verification step**. Treating a property as a mechanism regresses to the practice prohibited above. Any citation of this property must state that it is not usable for verification.

## Q16: Why can't packet keys be generated by deriving a world from a seed?

> This question borrows the Minecraft world seed as a **metaphor**; it is not a technical description. The basis for judgement is the cryptographic facts that follow.

**A: Because a key uniquely determined by a seed is not a key -- it is merely a publicly computable extension of that seed.**

One proposal: treat the PSK as a world seed and the sequence number as a chunk coordinate, then compute each packet key directly with one deterministic formula (`EK = HKDF(PSK, n)`), so that neither side stores a key chain and no fresh randomness is needed per packet -- tell me which packet to compute and I can compute it in a second.

This proposal **must never be adopted**. It has three independent flaws, each fatal on its own:

1. **Loss of key independence** -- under deterministic derivation, an attacker who obtains **any single** `EK` or **captures any single packet** can derive **all** `EK` values and decrypt **all traffic, past and future**. Keys must be mutually independent; knowing one must never yield another.
2. **Complete loss of forward secrecy** -- once the PSK leaks, an attacker can recompute the keys of **every past session** and decrypt all previously recorded traffic in one pass.
3. **GCM nonce reuse** -- this protocol's GCM nonce is the 4-byte prefix `0x00000000` followed by the 8-byte `seq` (see F.4). If the key is also determined by seq, then **both the key and the nonce are fixed by the same seq**; after a session restart seq returns to zero, so the same key, the same nonce, and the same AAD recur. AES-GCM then allows not only plaintext recovery but also **recovery of the authentication key, letting an attacker forge arbitrary messages**.

**Why this scheme admits no simplification**: a Minecraft world seed works because **chunk generation is independent and reproducibility is desirable** -- the same seed must always rebuild the same world, which is precisely what makes it useful. But **keys must be irreproducible**: the world needs to be reproducible, a key needs to be irreproducible -- two sides of one property. Hence the analogy does not hold here, and no simplification can rescue it.

Three steps in the current implementation are **not omittable** (see F.5): a fresh genuine random value `next_seed` per packet; the key chain rolled forward by that random value; immediate erasure of the old key. Convenient seeking, storage savings, and computational savings are not grounds for adopting this scheme.

> **Common Misconception**: anything that can be computed is not a key. Any key derivable from the PSK or from another key is equivalent to no key at all.
# Appendix B: Parameter Configuration Reference

> **[Appendix Guide]** All parameters are **reference values and are all freely modifiable**. Both communicating parties must use the same parameters. For the boundaries and risks of parameter modification, see Q12.

## B.1 Default Reference for Core Parameters

| Parameter | Reference Value | Description |
|--------|--------|------|
| Random number length random_len | 256 bits (default); 1024 bits (optional) | Provides a 2^256 space, freely modifiable (official client `--random-len`) |
| Random number generation rate random_rate | 1024 per second (default); no software upper limit (optional) | Freely modifiable, server-defined (`--random-rate`) |
| Negotiation window window | 60 seconds (default) | **Both parties' parameters must be consistent** (one of the parameter matching check items); note that it ≠ the timestamp window (`--window`) |
| Timestamp window time_window | 30 seconds (default, per-peer configurable) | Packet timestamp tolerance; the official client `--time-window` is adjustable; a narrow window means high security, a wide window means high availability |
| Hash algorithm | SHA-3-256 | NIST standard, collision-resistant and length-extension resistant |
| Symmetric Encryption | AES-256-GCM (Phase 4 standard) | Replaceable with other trusted algorithms |
| Key Exchange | X25519 ECDH | Provides Forward Secrecy |
| Key Derivation | HKDF-SHA-3-256 | Standardized extract-expand; session_salt is the salt parameter (RFC 5869) |
| Token Signature | Ed25519 | High-performance elliptic curve (implemented by the TCA module, verified by the core client through a hook) |
| Device-Specific Key PSK | 32 bytes (256 bits) true random | At the protocol level, storage in TPM/HWID (physical binding) is recommended; **the 1.0.0 official clients do not implement TPM/HWID storage -- planned for a later version**; the official client accepts 64-character hex/Base64 and rejects weak keys and public default values |
| Default Port | 37291 | Official client default (changeable with `--port`) |
| Handshake Timeout | 15 seconds | Total time limit for each of Phases 1-3 |
| Data-Phase Timeout | 60 seconds | Socket timeout after handshake completion (prevents silent disconnection at the 15-second handshake timeout) |
| Heartbeat Interval | 30 seconds (empty-payload packet) | Detects half-open connections and participates in ratchet rotation |
| Connection Retry | 3 times, 5-second interval | Initiator only (`--retry-count` / `--retry-interval`) |
| Silent-Drop Hold Duration | 15 seconds (= handshake timeout, configurable) | Holds the read and discards peer data; for server-embedded scenarios it is advisable to reduce it and combine it with per-IP rate limiting |
| Session Salt session_salt | 32 bytes (256 bits) random | Generated by the initiator, sent in plaintext with the public-key packet, and used as the HKDF salt parameter |
| Random Padding | Reference 512~2048B; disabled by default in the official client | 0~2048B configurable (`--padding-min/max`), can be enabled on one side only, eliminates the packet-length fingerprint |
| Send-Timing Jitter jitter | Default 0 (disabled) | Configurable via `--jitter`, eliminates the timing fingerprint |
| Waiting-Pool Timeout | 30 seconds | Prevents long-term memory occupation |
| Frame and Payload Limits | Parameter JSON ≤ 4096B, identity announcement ≤ 8192B, ciphertext ≤ 1MiB, etc. | See Appendix F.6 for the complete limit-constant table |

## B.2 Three-Tier Server Configuration Reference

### Beginner Public-Benefit Server (default parameters)

| Parameter | Value |
|------|------|
| Random number length | 256 bits |
| Generation rate | 1024 per second |
| Time window | 60 seconds |
| Encryption algorithm | AES-256-GCM |
| Key exchange | X25519 |
| Hash algorithm | SHA-3-256 |
| Token signature | Ed25519 |
| Governing document | *ZT-DSP Protocol General Guide* (docs 1.0.0) |

### Advanced Server (moderate customization)

| Parameter | Value |
|------|------|
| Random number length | 512 bits |
| Generation rate | 512 per second |
| Time window | 45 seconds |
| Encryption algorithm | AES-256-GCM |
| Key exchange | X25519 |
| Hash algorithm | SHA-3-256 |
| Token signature | Ed25519 |
| Governing document | *ZT-DSP Protocol General Guide* (docs 1.0.0) |

### High-Anonymity Server (heavy customization)

| Parameter | Value |
|------|------|
| Random number length | 1024 bits |
| Generation rate | 128 per second |
| Time window | 30 seconds |
| Encryption algorithm | ChaCha20-Poly1305 |
| Key exchange | X25519 |
| Hash algorithm | SHA-3-256 |
| Token signature | Ed25519 |
| Governing document | *ZT-DSP Protocol General Guide* (docs 1.0.0) |

# Appendix C: Minimal Implementation Checklist

> **[Appendix Guide]** A self-check checklist before releasing an implementation. C.1 is for implementers, C.2 is for users. Every item has a corresponding chapter reference. For **byte-level** self-checks verify item by item against Appendix F (Byte-by-Byte On-Wire Specification), and for **failure paths and timeouts** self-checks verify against Appendix H (State Machine, Timeout, and Error-Handling Matrix).

## C.1 Implementer Self-Check

Before releasing your ZT-DSP implementation, confirm the following:

- [ ] **Configurable parameters**: all parameters (random number length, rate, window, etc.) are freely modifiable, with no hard-coded mandatory values (4.2.1)
- [ ] **Silent Drop implementation**: packets that do not match the parameters are dropped directly, with no error code returned and no logging (4.3)
- [ ] **Forward secrecy**: use X25519 ephemeral key exchange; the ephemeral private key is zeroed after the session ends (4.2.2 step 5)
- [ ] **Authenticated encryption**: use AES-256-GCM or ChaCha20-Poly1305; do not design your own encryption (4.2.4)
- [ ] **Sequence number check**: strictly increasing; packets equal to or smaller than the last received value are dropped (4.2.3)
- [ ] **GCM nonce construction**: nonce = 4-byte zero prefix ‖ 8-byte big-endian sequence number (12B total); never reused under the same key (4.2.4)
- [ ] **AAD content**: AAD = session ID ‖ sequence number (8B big-endian), 40 bytes total; routing fields are visible but tamper-proof (4.2.4)
- [ ] **Timestamp window**: configurable (official default 30 seconds); out-of-window packets **still rotate the EK and advance the sequence number, and only the plaintext is dropped**, preventing ratchet desynchronization (4.2.4)
- [ ] **Bidirectional Token Hash verification**: after decryption, verify that dst_hash in the packet == the local identity and src_hash == the peer identity (4.2.4)
- [ ] **Confirmation tag exchange**: Phase 3 exchanges HMAC confirmation tags (CONFIRM-INIT/RESP), and the transcript binds both sides' Phase 1 raw frames + session salt + both public keys (4.2.3)
- [ ] **Root key erasure**: after Phase 3 confirms successfully, the MK, Anchor, and PSK are all zeroed, and the session retains only the EK/session ID/sequence number (4.2.3)
- [ ] **Ratchet rotation**: each packet carries next_seed, new_EK = HKDF(current EK ‖ next_seed, "ZT-DSP-EK-ROTATE"); rotate before sending (consume state first, then send) (4.2.5)
- [ ] **Heartbeat keep-alive**: during the data phase, periodically send empty-payload packets (official client: 30 seconds) to detect half-open connections (4.2.5)
- [ ] **Token verification**: TCA signature verification + CRL query + Authorization Code whitelist (if required) (4.1.2/4.1.3)
- [ ] **Waiting-pool management**: cleared on 30-second timeout, registry entries are mutually invisible, no broadcasting (4.2.1)
- [ ] **TCA optional**: allow a TCA-less P2P direct-connection mode (placeholder Token Hash derivation), or support multi-TCA federation (4.1.1/4.1.2)
- [ ] **No backdoors**: plant no master key, log no user communications, report no data to any server (Volume 5.5, Security Guarantees and Boundaries)

## C.2 User Self-Check

Before using ZT-DSP, confirm the following:

- [ ] Understanding Out-of-Band Exchange: you have obtained the peer's house number through a secure channel (1.3/3.4)
- [ ] Understanding PSK protection: the protocol requires your PSK to be stored in the TPM/HWID and to be non-exportable (4.1.4); **the 1.0.0 official clients do not implement this binding -- use `--psk-file` with 0600 permissions as the substitute**
- [ ] Understanding TCA selection: the TCA you trust is community-recognized, not a mandatory authority (4.1.2)
- [ ] Understanding parameter matching: your client parameters are consistent with the target server's library declaration (Appendix B)
- [ ] Understanding risk: you understand your own threat model and the protocol's limitations (Volume 5)

# Appendix F: Byte-by-Byte On-Wire Protocol Specification

> **[Appendix Guide]** Volume 4 explains "what the protocol does"; this appendix explains "what it actually looks like on the wire". This appendix describes the precise byte layout of **all four on-wire frame types** of ZT-DSP, the common encoding conventions, the limit constants, and the Silent Drop behavior contract; every sentence has been checked line by line against the implementation of the official client (`zt_dsp_py`). **Any two implementations claiming ZT-DSP compatibility must produce network traffic identical to this appendix at the byte level** — otherwise the Phase 3 confirmation tag verification will fail immediately.
>
> **[Points of Interest for Beginners]** This appendix is an "engineering blueprint"; absolute beginners do not need to read it through. It is suggested to first read the four common conventions in F.0 to build intuition, and then consult each section as needed.
>
> **[Points of Interest for Implementers]** This appendix is used together with Appendix H (state machine/timeouts/error matrix) and Appendix C (checklist). The **limit check of the length field must be completed before reading the payload** — this is the first gate against memory bombs.

## F.0 Common Encoding Conventions

```plain
Big-Endian (network byte order)
├── Meaning: the byte arrangement order of multi-byte integers — the most significant byte (leftmost) is sent and stored first
├── Principle: the value 258 (0x0102) in big-endian order is byte 0x01 followed by 0x02 on the wire; the receiver restores it in the same order. Network protocols traditionally use big-endian uniformly, hence it is also called "network byte order"
└── Rationale: different CPU architectures have different native byte orders (x86 is little-endian), so one order must be fixed on the wire; otherwise the same byte string would be interpreted as different numbers
```

The following conventions apply to **all four frame types**:

1. **Transport carrier**: a TCP byte stream with no message boundaries. Every frame/packet carries its own length information, and the receiver parses field by field: "read length → read payload".
2. **Byte order**: all multi-byte integers use **big-endian (network byte order)** without exception. Specifically: the 4-byte length field and ciphertext length = uint32 big-endian; the 8-byte sequence number and timestamp = uint64 big-endian; the 2-byte padding length = uint16 big-endian.
3. **Length-prefix mode**: variable-length fields are always encoded as `[length(4B uint32 BE)][payload(length bytes)]`; fixed-length fields (session ID, sequence number, public key, salt, timestamp, Token Hash, next_seed) are arranged directly by bytes, with no prefix.
4. **No magic number, no frame-type field, no frame-level CRC**: a frame's "type" is determined by its position in the handshake flow (the sequential order) and is not marked on the wire. Frame-level integrity is guaranteed by the Phase 3 confirmation tag (handshake period) and GCM authentication (data period); CRC exists only at the token layer.
5. **Length first, payload after**: after reading any length field, the receiver must first compare it with the limit (see F.6); if it exceeds the limit the frame is immediately judged invalid — it is never allowed to "allocate memory according to the length declared by the peer".
6. **Raw frames participate in authentication**: the **raw bytes** of both sides' Phase 1 frames (including all length prefixes) enter the Phase 3 transcript; any "canonicalized re-encoding" of a frame (reordering JSON keys, adding or removing whitespace) will cause the confirmation tag to mismatch.

## F.1 Phase 1 Frame: Identity Announcement and Parameter Exchange

**Frame layout (offset table):**

| Offset | Field | Length | Encoding | Description |
|------|------|------|------|------|
| 0 | param_len | 4B | uint32 BE | Parameter JSON length, ≤ 4096 |
| 4 | param_json | param_len | UTF-8 JSON | Parameter set (structure below) |
| 4+P | identity_len | 4B | uint32 BE | Identity announcement length, ≤ 8192 |
| … | identity_blob | identity_len | Raw bytes | Default = source Token Hash (32B) ‖ destination Token Hash (32B), 64B total; when the TCA module is mounted it is replaced by declarations such as signature tokens |
| … | nonce_len | 4B | uint32 BE | Access nonce length, ≤ 512 |
| … | nonce | nonce_len | Raw bytes | Access nonce (derivation formula in 4.2.1) |

**On-wire structure of the parameter JSON**: keys are arranged in **lexicographic order**, using **compact separators** (`,` and `:`, no spaces) and UTF-8 encoding. The parameter JSON **contains no version or protocol identifier field**. Actual on-wire bytes under the official default parameters (120 bytes total):

```json
{"aead":"AES-256-GCM","hash":"SHA3-256","key_len":256,"module_flags":{},"random_len":256,"random_rate":1024,"window":60}
```

**Parameter validation rules** (both sides must execute these when constructing and parsing; if any rule is not satisfied the parameters are judged invalid):

| Key | Validation Rule | Official Default |
|----|----------|-----------|
| random_len | Positive integer and a **multiple of 8** | 256 |
| random_rate | Positive integer | 1024 |
| window | Positive integer | 60 |
| key_len | Only **128 / 192 / 256** allowed | 256 |
| hash | Officially supports SHA3-256/384/512 and SHA-256/384/512 | `"SHA3-256"` |
| aead | The official implementation contains only AES-256-GCM | `"AES-256-GCM"` |
| module_flags | Keys must be strings; values may only be string/integer/float/boolean/list/dict/null; **nesting depth ≤ 32, total node count ≤ 1024** | `{}` |

**Parameter match verification**: both sides must be **equal item by item** on the following 7 items, and verification is performed in this fixed order (it stops at the first unequal item):
`random_len → key_len → window → random_rate → hash → aead → module_flags`.

**On-wire contract of the access nonce**:

- Derivation: `nonce = HKDF-SHA3-256(IKM = PSK, salt = local fresh random salt (32B), info = "ZT-DSP-PHASE1-NONCE-v3", output length = random_len / 8 bytes)`
- **The salt used for derivation is not transmitted with the frame** (it is newly generated locally for each handshake). Therefore **the core protocol has only one peer-side check: `len(nonce) × 8 == the random_len declared by the peer`** — the peer cannot (and does not attempt to) recompute that random number; the verification of "whether it was derived from the correct PSK" is borne indirectly by the confirmation tag (wrong PSK → wrong MK → the tag must be wrong). Statistical-level checks (random number quality enhancement, etc.) are the responsibility of the extension layer.
- Each side sends its own nonce, and the two nonces are mutually independent.

**Exchange order**: the initiator sends the complete frame first → the responder reads the whole frame, verifies the parameters, and checks the nonce length (plus extension-layer verification, if any) → **only after everything passes** does the responder send back its own frame. Under the default parameters (JSON 120B + identity announcement 64B + nonce 32B), the Phase 1 frame = 4+120+4+64+4+32 = **228 bytes**.

## F.2 Strict Silent Drop Behavior Specification (Responder-side behavior contract)

Section 4.3 explained the **idea** of Silent Drop; this section gives its **behavior contract** — the five elements of "strict silence", none of which may be missing:

1. **Send no bytes at all**. This includes error responses, empty packets, and any application-layer response beyond the TCP layer.
2. **Do not actively close the connection**. Closing a connection (FIN/RST) is itself an observable signal — an attacker can use it to distinguish "rejected because of a parameter mismatch" from "nobody is listening on the port at all".
3. **Hang, read, and discard subsequent data**: continuously `recv` in 8192-byte blocks and discard them until the peer closes or the hold duration is exhausted. The hold duration defaults to the handshake timeout (**15 seconds, configurable**; for server-embedded scenarios it is advisable to reduce it and combine it with per-IP rate limiting, to prevent malicious connections from occupying connection slots for a long time).
4. **Diagnostics go only to the local stderr**: the discard reason (such as "Phase 1 parse failed" or "parameter mismatch: random_len") is printed for the local operator to see, **never enters the network side**, and should not be connected to an externally facing logging system.
5. **Network appearance is indistinguishable from a "closed port"**: from the attacker's perspective, a scan against a nonexistent service and a ZT-DSP server with wrong parameters should look like the same kind of "silence".

**Complete trigger-point table** (responder's perspective; any single trigger immediately enters strict silence):

| Phase | Trigger Condition |
|------|----------|
| Phase 1 | Frame parsing failure (length over limit / invalid JSON / UTF-8 error / timeout); invalid parameters (validation rules not satisfied); mismatch in the 7 parameters (any one); nonce length ≠ declared random_len; TCA token verification failure / CRL hit / server library declaration mismatch (when extensions are mounted) |
| Phase 2 | Frame read failure or timeout; public-key length ≠ 32B; DH computation failure (**low-order point public key** such as all-zero, u=1, or **all-zero DH output**) |
| Phase 3 | Confirmation frame read failure, length ≠ 32B, or timeout |

**Initiator asymmetry**: the initiator has already actively sent a frame in Phase 1, so the peer already knows it exists; therefore, when the initiator detects a failure it **actively disconnects and raises a local exception** (such as ZTDSPParamError) without breaking silence. The silence constraint applies only to "the side that waits passively".

**Timing consistency**: the silent path should avoid producing a measurable response-time difference from the normal path (the silent path has no response anyway; what is meant here is that the "hold duration" should not vary with the error type).

## F.3 Phase 2 Frame: Ephemeral Public Key and Session Salt Exchange

**Initiator → Responder (68 bytes total):**

| Offset | Field | Length | Encoding | Description |
|------|------|------|------|------|
| 0 | pub_len | 4B | uint32 BE | Always 32 |
| 4 | pk_A | 32B | Raw bytes | Initiator X25519 ephemeral public key (Raw encoding) |
| 36 | session_salt | 32B | Raw bytes | Session salt generated by the initiator, transmitted in **plaintext**, and subsequently used as the HKDF salt parameter |

**Responder → Initiator (36 bytes total):**

| Offset | Field | Length | Encoding | Description |
|------|------|------|------|------|
| 0 | pub_len | 4B | uint32 BE | Always 32 |
| 4 | pk_B | 32B | Raw bytes | Responder X25519 ephemeral public key |

**Ordering constraint (security-critical)**: The responder MUST **receive the initiator's frame in full and complete the DH computation, and only send the response frame after everything passes**. If it responds first and computes DH afterwards, an attacker using a low-order point / invalid public key can create an observable timing difference between "the response frame is received" and "the connection is dropped" — "the response frame was already leaked before verification failed". This is precisely the engineering meaning of "strict silence extended to phase two" described in 4.2.2.

**DH failure determination** (silent drop if either condition holds): the peer public key length ≠ 32 bytes; the X25519 computation outputs **all zeros** (the mathematical signature of a low-order point attack — a malicious public key collapses the shared secret into a constant).

## F.4 Phase Three Frame: Confirmation Tag Exchange

**Frame layout (identical for both sides, each sends once):**

| Offset | Field | Length | Encoding | Description |
|------|------|------|------|------|
| 0 | confirm_len | 4B | uint32 BE | Always 32 |
| 4 | tag | 32B | Raw bytes | HMAC-SHA3-256 confirmation tag |

**Exact construction of the transcript** (both sides concatenate independently using the same formula, in a fixed order):

```plain
transcript = Phase One initiator raw frame (including all length prefixes, byte for byte)
           ‖ Phase One responder raw frame (including all length prefixes, byte for byte)
           ‖ session_salt (32 bytes)
           ‖ initiator ephemeral public key (32 bytes)
           ‖ responder ephemeral public key (32 bytes)

tag_init = HMAC-SHA3-256(MK, "ZT-DSP-CONFIRM-INIT-v3" ‖ transcript)
tag_resp = HMAC-SHA3-256(MK, "ZT-DSP-CONFIRM-RESP-v3" ‖ transcript)
```

> **The transcript contains no version or protocol identifier**: there is no version string in the concatenated material. Whether the peer follows the same document is reflected by the `tag_init` / `tag_resp` verification — a mismatch means the tags do not match.

**Exchange sequencing (per the official implementation)**:

1. The initiator sends the `tag_init` frame
2. The responder reads that frame — **only frame-level errors** (read failure / length ≠ 32 / timeout) trigger strict silence
3. The responder sends the `tag_resp` frame (note: at this point it has **not yet** verified the peer's tag content)
4. Each side checks the peer's tag using **constant-time comparison**; if either side does not match → erase all key material → handshake failure (both the initiator and the responder report ZTDSPSecurityError)

> **Common misconception**: "the responder sends its own tag only after verification passes" is a common misreading and does not match the official implementation. The responder "sends first, compares after". This is not a security hole: the tags are each side's own HMAC, and an attacker cannot impersonate either side by "sending a correct tag first" — it has no MK and cannot compute either side's correct tag; whichever side compares wrong immediately erases the keys and terminates.

**Binding meaning**: the transcript covers the **raw bytes** of both sides' Phase One frames — the parameter JSON, the identity declaration, and the access nonce are all included. Any substitution of the identity declaration or parameters by a man-in-the-middle, and any "canonical re-encoding" in either implementation, will make the transcript differ and the tags necessarily wrong. Legitimate modifications to parameters/identity by the TCA extension layer also cause no false failure, because "what is changed is the raw frame that both sides can see" (both sides bind the same byte sequence).

## F.5 Phase Four Data Packet: Encrypted Data Transmission

**Plaintext header (44 bytes, fixed):**

| Offset | Field | Length | Encoding | Description |
|------|------|------|------|------|
| 0 | session_id | 32B | Raw bytes | Session routing identifier (for the derivation see 4.2.3); the server delivers based on it |
| 32 | seq | 8B | uint64 BE | Sender sequence number; the first data packet is 0 |
| 40 | ct_len | 4B | uint32 BE | Ciphertext length, ≤ 1 MiB |

**Ciphertext** = `AES-256-GCM(EK_direction, nonce, payload, AAD)`, with a 16-byte authentication tag appended at the end.

**payload (GCM plaintext, i.e. the internal payload before encryption) offset table:**

| Offset | Field | Length | Encoding | Description |
|------|------|------|------|------|
| [0:8] | Timestamp | 8B | uint64 BE | Millisecond-level Unix timestamp |
| [8] | fmt | 1B | uint8 | `0x00` = no random padding; `0x01` = with random padding |
| [9:41] | dst_token_hash | 32B | Raw bytes | Destination token hash (the "recipient" of this packet) |
| [41:73] | src_token_hash | 32B | Raw bytes | Source token hash (the "sender" of this packet) |
| [73:…] | User plaintext | Variable | Raw bytes | Actual message content; empty here for a heartbeat packet |
| (fmt=0x01) | Random padding | pad_len | Raw bytes | True random padding, see Appendix G.2 |
| (fmt=0x01) | pad_len | 2B | uint16 BE | **Immediately before next_seed** (i.e. at bytes 34–33 counted from the end of the payload); the receiver locates the padding from the tail based on it |
| [-32:] | next_seed | 32B | Raw bytes | Ratchet seed for the next packet |

- **Minimum payload length** = 8 + 1 + 32 + 32 + 32 = **105 bytes** (fmt=0x00 with empty user plaintext, i.e. the payload of a heartbeat packet)
- **User plaintext upper bound** = 1 MiB − 64 − 1 − 64 − 8 − 32 − 2 − 2048 = **1046357 bytes** (reserving margin for the frame header, the authentication tag, and the padding upper bound)
- **Heartbeat packet under default parameters** (no padding) total wire length = 44 (header) + 105 (payload) + 16 (GCM tag) = **165 bytes** — interoperability testing can use it for a size assertion

**nonce (12 bytes)**: `0x00000000 (4B) ‖ seq (8B uint64 BE)`. The monotonically increasing sequence number guarantees that the nonce is never reused under the same key.

**AAD**: `session_id ‖ seq (8B uint64 BE)`, **40 bytes** in total (session_id 32B + seq 8B). The routing fields are "visible but tamper-proof". **The AAD contains no version or protocol identifier**.

**Receive verification pipeline (fixed order; any step that fails terminates processing immediately)**:

| Step | Verification | Meaning of failure | Consequence of failure |
|------|------|----------|----------|
| 1 | `seq > seq_recv` (seq_recv is initially −1) | Replay or out-of-order old packet | Session termination (security error) |
| 2 | `session_id == local session ID` | Cross-talk or residual packet from an old session | Session termination (security error) |
| 3 | GCM decryption and authentication (AAD participates in authentication) | Tampering or key mismatch | Session termination (security error) |
| 4 | Payload length ≥ 105B | Truncated structure | Session termination (protocol error) |
| 5 | `fmt ∈ {0x00, 0x01}` | Unknown payload format | Session termination (security error) |
| 6 | Structural length consistency: fixed header + tail (including pad_len ≤ 2048) does not exceed the total payload length | Out-of-bounds/negative-slice attack | Session termination (protocol error) |
| 7 | Bidirectional token hash verification: dst in the packet == local identity, src == peer identity | Traffic reflection / cross-talk / identity forgery | Session termination (security error) |
| 8 | Timestamp window: `|now − ts| ≤ time_window` | Authenticated but out-of-window replay/delayed packet | **Special**: does not terminate the session — it still rotates EK and advances seq_recv, discarding only the plaintext (to prevent ratchet desynchronization, see 4.2.4 receive flow step 5) |

**Sender-side state roll-forward ("consume state first, attempt to send after")**: Before encrypted sending, the following are completed in order — generate next_seed → `new_EK = HKDF-SHA3-256(EK ‖ next_seed, info = "ZT-DSP-EK-ROTATE")` → erase the old EK and swap in new_EK → `seq += 1`. Therefore, when sending fails the key has already rolled forward and the session is unrecoverable (reconnection is the only option), but an attacker can never exploit "send failure leaving the state un-rolled-forward" to replay.

## F.6 Summary Table of Upper-Bound Constants

The implementation must build in the following hard upper bounds; **all upper-bound checks precede the reading of the corresponding payload**:

| Constant | Value | Constrained object |
|------|-----|----------|
| Parameter JSON upper bound | 4096 B | Phase One param_json |
| Identity declaration upper bound | 8192 B | Phase One identity_blob |
| Access nonce upper bound | 512 B | Phase One nonce (the lower bound is indirectly determined by the random_len check) |
| Ciphertext upper bound | 1 MiB (1048576 B) | Phase Four ct_len |
| User plaintext upper bound | 1046357 B | Phase Four user plaintext |
| Random padding upper bound | 2048 B | Phase Four pad_len |
| Padding interval validity | 0 ≤ min ≤ max ≤ 2048 | Sender padding configuration |
| module_flags nesting depth | 32 | Parameter JSON |
| module_flags total node count | 1024 | Parameter JSON |
| Read block size | 8192 B | A single recv in the receive loop |
| Confirmation tag length | Always 32 B | Phase Three tag |
| Session ID / token hash / next_seed / salt / public key | Always 32 B | Each fixed-length field |
| Sequence number / timestamp | 8 B (uint64 BE) | Phase Four |
| GCM nonce | 12 B | Phase Four |

# Appendix G: Traffic Analysis Defense Implementation Details

> **[Reading guide for this appendix]** The defense matrix in Section 5.4 states "what to defend with"; this appendix states "exactly how to encode it". The three defenses — padding, jitter, and the timestamp window — are all provisions at the **protocol behavior layer**; two implementations can interoperate even when their algorithms are correct but their parameters differ — this is precisely the design value of their "unilateral enablement".
>
> **[Implementer's focus]** Stripping of padding depends on the precise location of the fmt marker and the pad_len field (G.2); an encoding error will directly cause the peer's parsing to fail; jitter is purely local behavior (G.3) and does not affect the wire bytes.

## G.1 Three Traffic Fingerprints and Their Corresponding Defenses

| Fingerprint type | What it leaks | Corresponding defense | How to enable |
|----------|----------|----------|----------|
| Length fingerprint | Message size → content-type guessing, behavioral profiling | Random padding (G.2) | Sender-side unilateral |
| Timing fingerprint | Sending rhythm → typing habits, automation characteristics | Timing jitter (G.3) + heartbeat baseline (G.5) | Sender-side unilateral |
| Lack of old/new distinction | Delayed old packets are treated as new | Timestamp window (G.4) | Configured by each side independently |

## G.2 Exact Encoding of Random Padding

- **Configuration**: the sender holds a pair `(padding_min, padding_max)` satisfying `0 ≤ min ≤ max ≤ 2048` (unit: bytes). Official CLI parameters `--padding-min` / `--padding-max` (must be given together); **no configuration by default = padding off**.
- **Independent per packet**: `pad_len = randbelow(max − min + 1) + min` (uniform distribution within the interval); the padding content is **truly random bytes** (zero padding must not be used — a zero run is a low-entropy fingerprint).
- **Wire encoding**: when enabled, `fmt = 0x01`, and the payload layout becomes `…user plaintext ‖ random padding (pad_len B) ‖ pad_len (2B uint16 BE) ‖ next_seed (32B)`. **The pad_len field must be immediately before next_seed** — the receiver reads it from a fixed position at the tail of the payload (bytes 34–33 counted from the end), so that it can locate the padding boundary without knowing the plaintext length.
- **Receive-side stripping**: the receiver parses padding only when it sees `fmt = 0x01`; a packet with `fmt = 0x00` is legal even when it comes from "a peer that pads" (**padding is decided per packet, enabled unilaterally, and requires no negotiation**). pad_len > 2048 → protocol error.
- **Cost**: pad_len extra bytes + 2 bytes per packet; bandwidth is traded for privacy. A reference recommended interval is 512–2048 bytes, enough to smooth out the length stratification of common messages.

## G.3 Sending Timing Jitter

- **Configuration**: `jitter ≥ 0` (seconds), official CLI `--jitter`, default 0 (off).
- **Behavior**: each data packet waits a random duration in the interval `[0, jitter)` after encryption is complete and before it is actually written to the socket.
- **Semantics**: purely **local sending behavior**; it changes no wire bytes at all; the peer is unaware and needs no cooperation.
- **Design boundary**: jitter smooths only the "sending instant", not the "packet rate distribution" — when defense against statistical rhythm analysis is needed, it should be combined with the heartbeat baseline (G.5).

## G.4 Timestamp Window

- **Configuration**: `time_window > 0` (seconds), official CLI `--time-window`, default 30; **configurable per peer** (the same client can use different windows for different peers).
- **Semantics**: the receiver verifies `|current time − in-packet timestamp| ≤ time_window × 1000` (comparison in milliseconds). Delivery is normal within the window; **a packet that is out of window but has already passed GCM authentication still performs the ratchet rotation and the sequence-number advance, and only the plaintext is discarded** (see F.5 pipeline step 8) — this "availability completion" is the key to preventing permanent desynchronization when "the sender has rotated but the receiver has not", and **implementers must not omit it**.
- **Trade-off**: a narrow window (e.g. 10s) → rejects delayed replay packets faster, but requires small clock skew between the two sides and low network latency; a wide window (e.g. 60s) → tolerates slow networks and clock drift, at the cost that replay packets have a longer "validity period". The core line of replay defense is always the sequence number (F.5 step 1); the timestamp window is the second line.

## G.5 Heartbeat as Baseline Traffic

- The official client sends a **heartbeat packet with empty plaintext** every **30 seconds** (165 bytes on the wire under default parameters, see F.5).
- Triple role: (1) detect half-open connections (TCP is usually unaware that "the peer has disappeared" until send fails); (2) flatten the "silent period" — a traffic observer cannot infer that the session is idle from "no packets for a long time"; (3) participate in ratchet rotation so that the key chain keeps advancing even with no messages.
- A heartbeat failure (send error) is treated as the connection being broken, and the session is cleaned up.

## G.6 Recommended Deployment Combinations

| Deployment scenario | Padding | Jitter | Timestamp window | Description |
|----------|------|------|------------|------|
| Ordinary private communication | Off | 0 | 30s (default) | Minimal overhead; confidentiality is unaffected |
| Advanced (anti-length-profiling) | 512~2048B | 0~0.5s | 30s | Message lengths are smoothed out |
| High-adversary | 1024~2048B | ≥ 1s | 15~30s | Combined with sending timing jitter (G.3) |
| High-latency/unreliable links | Optional | — | 60s+ | A wide window is traded for availability; replay protection is delegated to the sequence number |

# Appendix H: State Machines, Timeouts, and Error Handling Matrix

> **[Reading guide for this appendix]** Volume Four narrates the four phases along "the successful path"; this appendix completes **all branches**: the two roles' respective state machines (H.1/H.2), every "alarm clock" in the protocol (H.3), the behavior of each side when each kind of failure occurs (H.4), the protocol-layer exception hierarchy (H.5), and the key cleanup semantics after a failure (H.6).
>
> **[Implementer's focus]** Interoperability requires not only "identical bytes on the successful path" but also "identical behavior on the failure path" — especially the trigger point of silent drop (F.2) and the ratchet handling of out-of-window packets (F.5 step 8). A single mistake here produces the hardest-to-diagnose problems, such as "implementation A and implementation B cannot connect in one direction / lose synchronization".

## H.1 Initiator State Machine

```plain
[New Peer (inject PSK/parameters/role)]
        │ perform_handshake()
        ▼
┌──────────────┐  Build parameter JSON, identity_blob, access nonce
│ PHASE1_BUILD │──────────────────────────────┐
└──────────────┘                              │ Build failure (e.g. after a hook substitution the
        │ Build complete                      │ nonce length is mismatched)
        ▼                                     ▼
┌──────────────┐  Send phase-one frame (228B+)   [Disconnect + erase keys]
│ PHASE1_SENT  │────────────────┐            ▲
└──────────────┘                │ 15s timeout│
        │ Received              │ peer closed│
        ▼                       ▼            │
┌──────────────┐  7-item parameter comparison + nonce length check
│ PHASE1_CHECK │─────────────fail──→ [Disconnect + erase keys]
└──────────────┘        (Initiator is asymmetric: disconnects proactively)
        │ Pass
        ▼
┌──────────────┐  Generate ephemeral key pair + session salt (32B)
│ PHASE2_BUILD │
└──────────────┘
        │ Send [pub_len‖pk_A‖salt] (68B)
        ▼
┌──────────────┐  Receive [pub_len‖pk_B] (36B)
│ PHASE2_RECV  │────len≠32/time ──→ [Disconnect + erase keys]
└──────────────┘
        │ Received
        ▼
┌──────────────┐  DH = X25519(sk_A, pk_B)
│ DH_COMPUTE   │────all-zero/low-pt──→ [Disconnect + erase keys]
└──────────────┘
        │ Success → MK = HKDF(PSK‖DH, salt)
        ▼
┌──────────────┐  Anchor/session ID/EK_send/EK_recv derivation
│ PHASE3_DERIVE│  Build transcript, compute tag_init
└──────────────┘
        │ Send [confirm_len‖tag_init] (36B)
        ▼
┌───────────────┐  Receive peer confirmation frame
│ CONFIRM_RECV  │────err/timeout──→ [Disconnect + erase keys]
└───────────────┘
        │ Received
        ▼
┌───────────────┐  Constant-time comparison of tag_resp
│ CONFIRM_CHECK │────differ──→ [Erase all keys + security error]
└───────────────┘
        │ Match → erase MK/anchor/PSK
        ▼
┌──────────────┐  Full-duplex encrypted transport; rotate EK before sending each packet
│ ESTABLISHED  │  Heartbeat every 30s
└──────────────┘
        │ Any: security error / disconnect / no packet for 60s / send failure / proactive exit
        ▼
     [CLOSED] (idempotent cleanup: close socket + erase all key material)
```

## H.2 Responder State Machine

```plain
[New Peer]  ──→ [LISTENING] (accept enters the connection)
                        │ Phase One frame received
                        ▼
                ┌────────────────┐  Parse frame → parameter validation → 7-item comparison
                │ PHASE1_VALIDATE│  → nonce length → (extension-layer validation)
                └────────────────┘
                        │              │ Any failure
                        │ Pass         ▼
                        │      ┌────────────────┐
                        │      │ SILENT_HOLD    │ No send, no close;
                        │      │ (15s, config.)  │ suspend and swallow bytes until the peer
                        │      └───────┬────────┘ closes or the suspension times out
                        │              ▼
                        │        [CLOSED] (zero response throughout)
                        ▼
                ┌────────────────┐  This frame is already built (not sent)
                │ PHASE1_REPLIED │
                └────────────────┘
                        │ Receive [pub_len‖pk_A‖salt]
                        ▼
                ┌────────────────┐  Receive the full frame first → compute DH first
                │ PHASE2_PRECHECK│──err/low-order──→ SILENT_HOLD
                └────────────────┘   (before sending any bytes!)
                        │ DH success → MK derivation
                        ▼
                ┌────────────────┐  Send back [pub_len‖pk_B] (36B)
                │ PHASE2_REPLIED │
                └────────────────┘
                        │ Receive the confirmation frame
                        ▼
                ┌────────────────┐
                │ CONFIRM_RECV   │──frameErr──→ SILENT_HOLD
                └────────────────┘
                        │ Received → send its own tag_resp
                        ▼
                ┌────────────────┐  Constant-time comparison of tag_init
                │ CONFIRM_CHECK  │────differ──→ [Erase all keys + close]
                └────────────────┘
                        │ Match → erase MK/anchor/PSK
                        ▼
                  [ESTABLISHED] (same as the initiator; identical behavior in the data phase)
```

> **Three asymmetry points between the two state machines**: (1) in Phase One the initiator sends first, and the responder replies only after validating; (2) in Phase Two the responder "computes DH first, then replies" (the precondition for low-order-point silence); (3) silent drop constrains only the responder — when the initiator fails it disconnects proactively (F.2).

## H.3 Full Timer Table

| Timer | Default | Start | End | Timeout behavior |
|--------|--------|------|------|----------|
| Handshake timeout | 15s | Entering each handshake phase | Completion of that phase | Phase failure: the responder suspends silently; the initiator disconnects and reports a timeout |
| Total read deadline (Slowloris protection) | 15s (= handshake timeout) | Reading the first byte within a phase | The whole frame is read | **The whole frame shares one deadline**, rather than "restarting the timer on every recv" — an attacker cannot stall indefinitely by "sending 1 byte every 14 seconds" |
| Half-packet timeout | Same as above | Deadline exhausted after some bytes have been read | — | **Forcibly close the socket**: frame synchronization is already broken and cannot be recovered; distinct from an "initial timeout" (not a single byte read, so the upper layer may safely retry) |
| Data-phase timeout | 60s | After the handshake completes | Session end | Report a timeout and clean up the session (the 30s heartbeat stays inside the 60s window) |
| Heartbeat interval | 30s | The previous heartbeat (or session establishment) | The next heartbeat | Send failure → determine a half-open connection and clean up the session |
| Silent suspension duration | 15s (= handshake timeout, configurable) | Entering silent drop | The peer closes or the duration is exhausted | Close the connection (it has already been "silent" for 15s at this point) |
| Waiting-pool timeout (server side) | 30s | Entering the waiting pool | Successful pairing or timeout | The registry entry is cleared to prevent memory occupation |
| Timestamp window | 30s (configurable per peer) | — | — | Not a timer but a verification threshold; for out-of-window packet handling see F.5 step 8 |

> **Common misconception**: the key to Slowloris protection is not "the number 15 seconds" but **how the deadline is shared**. If every `recv` enjoys its own independent 15-second timeout, an attacker dragging out a single frame can stretch reading the 4-byte length field to 60 seconds; with a shared deadline, no matter how the peer dribbles, the whole frame budget is only 15 seconds.

## H.4 Error Handling Matrix (Phase × Failure → Behavior of Both Sides)

| Phase | Failure mode | Initiator behavior | Responder behavior |
|------|----------|------------|------------|
| Phase One | Frame construction failure (illegal parameters / nonce length does not match the declaration) | Local exception, nothing sent | Local exception, no effect on the listening side |
| Phase One | Peer frame parsing failure / illegal parameters / 7-item mismatch / nonce length mismatch / TCA·CRL·library declaration failure | Wait for the peer's reply frame → disconnect after a 15s timeout | **Strict silence** (suspend for 15s swallowing bytes, zero response) |
| Phase Two | Peer public key length ≠ 32B / read failure / timeout | Disconnect + erase + protocol/timeout error | **Strict silence** |
| Phase Two | DH failure (low-order point, all-zero output) | Disconnect + erase + cryptographic error (the initiator has already sent its frame) | **Strict silence** (DH is front-loaded before sending) |
| Phase Three | Peer confirmation frame error / timeout | Disconnect + erase + timeout error | **Strict silence** |
| Phase Three | Tag content mismatch | Constant-time comparison fails → **erase all keys** + security error, disconnect | Same as the left (both sides compare independently and each fails separately) |
| Data phase | seq repeated/regressed (replay) | — (an error on the peer side triggered by the sender) | Intercepted before the constant-time path → **session termination + erase**, security error |
| Data phase | session_id mismatch / GCM authentication failure / unknown fmt / structural contradiction / bidirectional token hash verification failure | Same as above (all these checks happen on the receiving side) | **Session termination + erase** (security or protocol error) |
| Data phase | Timestamp out of window (but GCM already passed) | — | **Do not terminate**: rotate EK, advance seq_recv, discard the plaintext (return an empty plaintext) |
| Data phase | Send failure (disconnect / BrokenPipe / OSError) | **The session is irreversibly desynchronized**: the keys have already rolled forward and cannot be reclaimed → clean up the session and prompt for reconnection | The peer will terminate due to a read failure/timeout |
| Data phase | No packet at all for 60s (half-open connection) | A heartbeat send failure immediately triggers cleanup ("the connection may already be broken") | Same as the left |
| Any | Any handshake step throws an exception | Unified cleanup at the handshake entry point: **erase all PSK/MK/anchor/EK material** | Same as the left |

## H.5 Protocol-Layer Exception Hierarchy

Implementers should converge local errors into **typed exceptions**, so that the upper layer can distinguish "should retry" from "should terminate" (the following is the exception tree of the official client; other implementations are advised to keep the same classification granularity):

```plain
ZTDSPError (protocol exception base class)
├── ZTDSPSecurityError
│   └── Meaning: security event — PSK mismatch, anchor confirmation failure, replay/out-of-order, session ID mismatch,
│       AEAD decryption failure, unknown payload format, bidirectional token hash verification failure
│   └── Handling: always terminate the session and erase the keys; no retry, no ignoring
├── ZTDSPParamError
│   ├── Meaning: parameter problem — the two sides' parameters do not match, illegal parameter value
│   └── Handling: failure during the handshake; the initiator should check the parameters before disconnecting and retrying
│   └── SilentDropError (its subclass)
│       └── Meaning: **this side has entered strict silence** (F.2) — this is a "signal" rather than an ordinary error:
│           after the upper layer catches it, it must never send any further data to the peer or close the connection (the silent path has taken over)
├── ZTDSPProtocolError
│   └── Meaning: frame format problem — length over the limit, invalid JSON, structural length contradiction, nonce length mismatch
│   └── Handling: during the handshake, follow silence/disconnect according to the role; during the data phase, terminate the session
├── ZTDSPCryptoError
│   └── Meaning: cryptographic failure — weak DH output (low-order point), derivation failure, unsupported algorithm
│   └── Handling: same as a security event (a low-order point is an attack)
└── ZTDSPTimeoutError
    └── Meaning: timeout — handshake timeout, total read deadline exhausted, half-packet timeout, no packet in the data phase
    └── Handling: a half-packet timeout must be accompanied by a forced socket close; the rest follows the H.4 matrix
```

## H.6 Key Cleanup Semantics After Failure

- **Any failure during the handshake** (including a hook abort or an escaping exception) → the entry point uniformly performs a complete cleanup: PSK, MK, anchor, and EK_send/EK_recv are all securely zeroed, and the session state is reset. **Never exit with keys** — this is the hard requirement of "minimal exposure surface" (the failure-path version of step 6 in 4.2.3).
- **Send failure during the data phase** → the keys have already rolled forward (F.5), and the session is **irreversibly desynchronized**: clean up and require reconnection. The peer object is single-use — reconnection must create a new Peer and provide the PSK again (after a successful handshake the PSK has been erased per protocol, so the old object cannot be reused).
- **Security error on the receive side during the data phase** → session termination + complete cleanup; a security event may optionally be reported to the upper layer for auditing (but note the no-logging principle in Volume 5 — local auditing and external records are two different things).
- **Cleanup must be idempotent**: the three threads for sending, receiving, and heartbeats may each be the first to discover that the session is dead, and the cleanup logic must guarantee that "the socket is closed exactly once, the keys are erased exactly once, and the final notification is triggered exactly once"; otherwise a long-running server will accumulate half-open sockets (file descriptor leaks) and residual keys.
