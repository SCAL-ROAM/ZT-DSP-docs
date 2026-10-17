# ZT-DSP Chinese–English Glossary (translation baseline)

> Purpose: every English document and every code comment in this project must use the English wording given here, so that terminology stays consistent throughout.
> Status: this file is the **single authoritative source** of terminology and depends on no other document.
> Entries: 124. Register new terms here before using them.

| English | Chinese | Note |
|---|---|---|
| Secure Zeroization | 安全擦除 | also written Secure Wipe |
| Half-open Connection | 半开连接 | a connection whose peer has disappeared without the local side noticing |
| CLOSE_WAIT | CLOSE_WAIT 状态 | one specific TCP connection state |
| Side-Channel Attack | 侧信道攻击 |  |
| Continuous Locking | 持续锁定 |  |
| Big-Endian | 大端序 | full form: Network Byte Order |
| Big-Endian | 大端字节序 | full form: Byte Order |
| Out-of-Band Exchange | 带外交换 |  |
| Dynamic Synchronization | 动态同步 |  |
| End-to-End Encryption | 端到端加密 |  |
| Symmetric Encryption | 对称加密 |  |
| Supply Chain Attack | 供应链攻击 |  |
| Hook | 钩子 | mounting an extension module is called Extension Mounting |
| Hash | 哈希 |  |
| Constant-time Comparison | 恒定时间比较 |  |
| Regression Testing | 回归测试 |  |
| Session Key | 会话密钥 | abbreviated EK (Encryption Key); the encryption key currently in effect |
| Session Salt | 会话盐 | wire field name session_salt, frozen and never renamed |
| Ratchet | 棘轮 | here: the mechanism that advances the key once per packet. Structurally different from the Signal Double Ratchet, which has a DH-ratchet step this protocol does not |
| Race Condition | 竞态条件 |  |
| Silent Drop | 静默丢弃 |  |
| Static Taint Analysis | 静态污点分析 |  |
| Zero Trust | 零信任 |  |
| Token Hash | 令牌哈希 |  |
| Traffic Analysis | 流量分析 |  |
| Path Traversal | 路径穿越 |  |
| Tainted Path | 路径污点 |  |
| Memory-Hard Function | 内存困难函数 | common algorithms: Argon2id, scrypt, Password Hashing |
| Anchor | 锚点 |  |
| Key Pair | 密钥对 |  |
| Fuzzing | 模糊测试 |  |
| OOM | 内存耗尽 | full form: Out of Memory |
| Forward Secrecy | 前向安全 |  |
| Authentication Tag | 认证标签 |  |
| Container | 容器 |  |
| Sandbox | 沙箱 |  |
| Triple-Input Formula | 三元公式 | full form: PSK ‖ DH ‖ session_salt |
| Entropy | 熵 |  |
| Authorization Code | 授权码 |  |
| Digital Signature | 数字签名 |  |
| Rate Limiting | 速率限制 |  |
| Socket Options | 套接字选项 | for example SO_REUSEADDR, SO_EXCLUSIVEADDRUSE, SO_KEEPALIVE |
| File Descriptor | 文件描述符 | abbreviated FD |
| EMFILE | EMFILE | file descriptor exhaustion error |
| Handshake | 握手 |  |
| Heartbeat | 心跳 |  |
| Virtual Room | 虚拟房间 |  |
| Sequence Number | 序列号 |  |
| Steganography | 隐写术 |  |
| Metadata | 元数据 |  |
| Sticky Packet | 粘包 | the remedy is framing |
| Split Packet | 拆包 | the remedy is framing |
| Length Prefix | 长度前缀 |  |
| Replay Attack | 重放攻击 |  |
| Master Key | 主密钥 | abbreviated MK |
| Sub-channel | 子频道 |  |
| Principle of Least Privilege | 最小权限原则 |  |
| Additional Authenticated Data | AAD |  |
| Authenticated Encryption with Associated Data | AEAD |  |
| AES-256-GCM | AES-256-GCM | Advanced Encryption Standard 256 + Galois/Counter Mode |
| Byte Order Mark | 字节顺序标记 | abbreviated BOM |
| Character Encoding | 字符编码 | for example UTF-8, GBK |
| ChaCha20-Poly1305 | ChaCha20-Poly1305 |  |
| Cyclic Redundancy Check | CRC-16 |  |
| Certificate Revocation List | CRL |  |
| Cryptographically Secure Pseudo-Random Number Generator | CSPRNG |  |
| Diffie-Hellman | DH |  |
| Domain Name System | DNS |  |
| Docker | Docker |  |
| Denial of Service | DoS |  |
| Distributed Denial of Service | DDoS |  |
| Deep Packet Inspection | DPI |  |
| Elliptic Curve Diffie-Hellman | ECDH |  |
| Ed25519 | Ed25519 |  |
| fail-open | fail-open | allow on failure |
| fail-closed | fail-closed | deny on failure |
| Firewall | Firewall |  |
| HMAC-based Key Derivation Function | HKDF |  |
| Hash-based Message Authentication Code | HMAC |  |
| HyperText Transfer Protocol | HTTP |  |
| HyperText Transfer Protocol Secure | HTTPS |  |
| Hardware Identifier | HWID |  |
| I/O Multiplexing | I/O 多路复用 | for example selector, epoll, kqueue |
| IP Address | IP 地址 | full form: Internet Protocol Address |
| Initialization Vector | 初始化向量 | also called Nonce in the GCM context |
| JavaScript Object Notation | JSON |  |
| Kerckhoffs's Principle | Kerckhoffs 原则 |  |
| LoRa | LoRa |  |
| Bluetooth Low Energy | BLE | abbreviated BLE |
| Least Significant Bit | LSB |  |
| Man-In-The-Middle | MITM |  |
| Nagle's Algorithm and TCP_NODELAY | Nagle 算法与 TCP_NODELAY |  |
| Operations Security | OPSEC |  |
| Peer-to-Peer | P2P |  |
| Proof of Concept | PoC |  |
| Proof of Work | PoW |  |
| Pseudo-Random Function | PRF |  |
| Pre-Shared Key | PSK |  |
| root | root |  |
| SHA-3-256 | SHA-3-256 | full form: Secure Hash Algorithm 3, 256-bit |
| Slowloris Attack | Slowloris 攻击 |  |
| Socket | Socket |  |
| Subpoena | Subpoena |  |
| Sybil Attack | Sybil 攻击 |  |
| Token Certification Authority | TCA |  |
| TLS 1.3 | TLS 1.3 | full form: Transport Layer Security 1.3 |
| Token | Token |  |
| Trusted Platform Module | TPM |  |
| transcript | transcript | full form: Handshake Transcript |
| True Random Number Generator | TRNG |  |
| Time To Live | TTL |  |
| Virtual Private Network | VPN |  |
| Virtual Private Server | VPS |  |
| WireGuard | WireGuard |  |
| X25519 | X25519 | full form: Curve25519 Key Exchange |
| YAML Ain't Markup Language | YAML |  |
| Nonce | 接入随机数 | carried in Phase 1; the length is set by the parameter random_len, a frozen field name |
| Access Salt | 接入盐 | generated locally, never transmitted with the frame |
| Waiting Pool | 等候池 | server-side pool holding sessions that wait to be paired |
| Session Identifier | 会话标识 | abbreviated SID |
| Confirmation Tag | 确认标签 | not the same thing as an AEAD authentication tag |
| Neighbour-Packet Linkage | 前后包关联 | each packet can be decrypted only against the packet immediately before and the packet immediately after it |
| Data Packet | 数据包 | the only packet type; an empty payload is merely one of its states |
| Framing | 帧界定 | the remedy for sticky and split packets |

## 使用规则

1. 首次出现写「中文（English）」，之后只用其一；英文版一律使用 English 列。
2. 缩写词（TLS、AEAD、HKDF…）不翻译，保持原形。
3. 代码标识符（`session_salt`、`ZTDSPSecurityError`）不翻译，注释中保留原拼写。
4. 协议常量串（`ZT-DSP-PHASE1-NONCE-v3` 等）**永不翻译**。
