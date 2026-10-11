# ZT-DSP Chinese–English Glossary (translation baseline)

> Purpose: every English document and every code comment in this project must use the English wording given here, so that terminology stays consistent throughout.
> Source: the Appendix A glossary of `spec/ZT-DSP_1.0.0_Master_Guide.md` (auto-extracted, then normalized by hand).
> Entries: 108. Register new terms here before using them.

| English | Chinese |
|---|---|
| Secure Zeroization / Secure Wipe | 安全擦除 |
| Half-open Connection / CLOSE_WAIT | 半开连接与 CLOSE_WAIT |
| Side-Channel Attack | 侧信道攻击 |
| Continuous Locking | 持续锁定 |
| Big-Endian (Network Byte Order) | 大端序 |
| Big-Endian (Byte Order) | 大端字节序 |
| Out-of-Band Exchange | 带外交换 |
| Dynamic Synchronization | 动态同步 |
| End-to-End Encryption | 端到端加密 |
| Symmetric Encryption | 对称加密 |
| Supply Chain Attack | 供应链攻击 |
| Hook / Extension Mounting | 钩子 |
| Hash | 哈希 |
| Constant-time Comparison | 恒定时间比较 |
| Regression Testing | 回归测试 |
| Session Key / EK | 会话密钥 |
| Session Salt (session_salt) | 会话盐 |
| Ratchet / Double Ratchet | 棘轮 |
| Race Condition | 竞态条件 |
| Silent Drop | 静默丢弃 |
| Static Taint Analysis | 静态污点分析 |
| Zero Trust | 零信任 |
| Token Hash | 令牌哈希 |
| Traffic Analysis | 流量分析 |
| Path Traversal / Tainted Path | 路径穿越与路径污点 |
| Argon2id / scrypt / Password Hashing | 慢哈希与内存困难函数 |
| Anchor | 锚点 |
| Key Pair | 密钥对 |
| Fuzzing | 模糊测试 |
| OOM (Out of Memory) | 内存耗尽 |
| Forward Secrecy | 前向安全 |
| Authentication Tag | 认证标签 |
| Container / Sandbox | 容器 / 沙箱 |
| Triple-Input Formula (PSK ‖ DH ‖ session_salt) | 三元公式 |
| Entropy | 熵 |
| Authorization Code | 授权码 |
| Digital Signature | 数字签名 |
| Rate Limiting | 速率限制 |
| Socket Options (SO_REUSEADDR / SO_EXCLUSIVEADDRUSE / SO_KEEPALIVE) | 套接字选项 |
| File Descriptor (FD) and EMFILE | 文件描述符与 EMFILE |
| Handshake | 握手 |
| Heartbeat | 心跳 |
| Virtual Room | 虚拟房间 |
| Sequence Number | 序列号 |
| Steganography | 隐写术 |
| Metadata | 元数据 |
| TCP Sticky Packets / Framing | 粘包与拆包 |
| Length Prefix | 长度前缀 |
| Replay Attack | 重放攻击 |
| Master Key / MK | 主密钥 |
| Sub-channel | 子频道 |
| Principle of Least Privilege | 最小权限原则 |
| Additional Authenticated Data | AAD |
| Authenticated Encryption with Associated Data | AEAD |
| Advanced Encryption Standard 256 + Galois/Counter Mode | AES-256-GCM |
| Byte Order Mark / UTF-8 / GBK | BOM 与字符编码 |
| ChaCha20-Poly1305 | ChaCha20-Poly1305 |
| Cyclic Redundancy Check | CRC-16 |
| Certificate Revocation List | CRL |
| Cryptographically Secure Pseudo-Random Number Generator | CSPRNG |
| Diffie-Hellman | DH |
| Domain Name System | DNS |
| Docker | Docker |
| Denial of Service / Distributed DoS | DoS / DDoS |
| Deep Packet Inspection | DPI |
| Elliptic Curve Diffie-Hellman | ECDH |
| Ed25519 | Ed25519 |
| fail-open / fail-closed | fail-open / fail-closed |
| Firewall | Firewall |
| HMAC-based Key Derivation Function | HKDF |
| Hash-based Message Authentication Code | HMAC |
| HyperText Transfer Protocol | HTTP |
| HyperText Transfer Protocol Secure | HTTPS |
| Hardware Identifier | HWID |
| I/O Multiplexing (selector / epoll / kqueue) | I/O 多路复用 |
| IP Address (Internet Protocol Address) | IP 地址 |
| Initialization Vector / Nonce | IV |
| Initialization Vector / Nonce | IV / Nonce |
| JavaScript Object Notation | JSON |
| Kerckhoffs's Principle | Kerckhoffs 原则 |
| LoRa / BLE (Bluetooth Low Energy) | LoRa / BLE |
| Least Significant Bit | LSB |
| Man-In-The-Middle | MITM |
| Nagle's Algorithm and TCP_NODELAY | Nagle 算法与 TCP_NODELAY |
| Operations Security | OPSEC |
| Peer-to-Peer | P2P |
| Proof of Concept | PoC |
| Proof of Work | PoW |
| Pseudo-Random Function | PRF |
| Pre-Shared Key | PSK |
| root | root |
| SHA-3-256 (Secure Hash Algorithm 3, 256-bit) | SHA-3-256 |
| Slowloris Attack | Slowloris 攻击 |
| Socket | Socket |
| Subpoena | Subpoena |
| Sybil Attack | Sybil 攻击 |
| Token Certification Authority | TCA |
| TLS 1.3 (Transport Layer Security 1.3) | TLS 1.3 |
| Token | Token |
| Trusted Platform Module | TPM |
| transcript (Handshake Transcript) | transcript |
| True Random Number Generator | TRNG |
| Time To Live | TTL |
| Virtual Private Network | VPN |
| Virtual Private Server | VPS |
| WireGuard | WireGuard |
| X25519 (Curve25519 Key Exchange) | X25519 |
| YAML Ain't Markup Language | YAML |

## Usage rules

1. On first occurrence write "English (Chinese)"; afterwards use only one of the two. English documents always use the English column.
2. Abbreviations (TLS, AEAD, HKDF, PSK, …) are never translated; keep the original form.
3. Code identifiers (`session_salt`, `ZTDSPSecurityError`) are never translated; keep the original spelling in comments.
4. Protocol constant strings (such as `ZT-DSP-PHASE1-NONCE-v3`) are **never translated**.
