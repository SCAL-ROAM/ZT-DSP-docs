# ZT-DSP Chinese–English Glossary (translation baseline)

> Purpose: every English document and every code comment in this project must use the English wording given here, so that terminology stays consistent throughout.
> Status: this file is the **single authoritative source** of terminology and depends on no other document.
> Entries: 116. Register new terms here before using them.

| English | Chinese | Note |
|---|---|---|
| Secure Zeroization | 安全擦除 | 亦作 Secure Wipe |
| Half-open Connection | 半开连接 | 对端已消失而本端未察觉的连接形态 |
| CLOSE_WAIT | CLOSE_WAIT 状态 | TCP 连接的一个具体状态 |
| Side-Channel Attack | 侧信道攻击 |  |
| Continuous Locking | 持续锁定 |  |
| Big-Endian | 大端字节序 | full form: Byte Order |
| Out-of-Band Exchange | 带外交换 |  |
| Dynamic Synchronization | 动态同步 |  |
| End-to-End Encryption | 端到端加密 |  |
| Symmetric Encryption | 对称加密 |  |
| Hook | 钩子 | 挂载扩展模块的动作称 Extension Mounting |
| Hash | 哈希 |  |
| Constant-time Comparison | 恒定时间比较 |  |
| Session Key | 会话密钥 | 缩写 EK（Encryption Key），指当前生效的加密密钥 |
| Session Salt | 会话盐 | 线上字段名 session_salt（冻结，不改） |
| Ratchet | 棘轮 | 本协议专指逐包推进密钥的机制。与 Signal 双棘轮结构不同：本协议没有 DH 棘轮步 |
| Silent Drop | 静默丢弃 |  |
| Zero Trust | 零信任 |  |
| Token Hash | 令牌哈希 |  |
| Traffic Analysis | 流量分析 |  |
| Path Traversal | 路径穿越 |  |
| Tainted Path | 路径污点 |  |
| Memory-Hard Function | 内存困难函数 | 常见算法 Argon2id、scrypt、Password Hashing |
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
| Socket Options | 套接字选项 | 例如 SO_REUSEADDR、SO_EXCLUSIVEADDRUSE、SO_KEEPALIVE |
| File Descriptor | 文件描述符 | 缩写 FD |
| EMFILE | EMFILE | 文件描述符耗尽错误 |
| Handshake | 握手 |  |
| Heartbeat Interval | 心跳间隔 | 包本身就是数据包，本词只表示发送周期 |
| Virtual Room | 虚拟房间 |  |
| Sequence Number | 序列号 |  |
| Information Hiding | 信息隐藏 | 涵盖填充、时序扰动等不改变载体的手法 |
| Metadata | 元数据 |  |
| Sticky Packet | 粘包 | 对策为帧界定（Framing） |
| Split Packet | 拆包 | 对策为帧界定（Framing） |
| Length Prefix | 长度前缀 |  |
| Replay Attack | 重放攻击 |  |
| Master Key | 主密钥 | 缩写 MK |
| Sub-channel | 子频道 |  |
| Principle of Least Privilege | 最小权限原则 |  |
| AAD | AAD | full form: Additional Authenticated Data |
| AEAD | AEAD | full form: Authenticated Encryption with Associated Data |
| AES-256-GCM | AES-256-GCM | Advanced Encryption Standard 256 + Galois/Counter Mode |
| Byte Order Mark | 字节顺序标记 | 缩写 BOM |
| Character Encoding | 字符编码 | 例如 UTF-8、GBK |
| ChaCha20-Poly1305 | ChaCha20-Poly1305 |  |
| CRC-16 | CRC-16 | full form: Cyclic Redundancy Check |
| CRL | CRL | full form: Certificate Revocation List |
| CSPRNG | CSPRNG | full form: Cryptographically Secure Pseudo-Random Number Generator |
| Diffie-Hellman | DH |  |
| DoS | DoS | full form: Denial of Service |
| DDoS | DDoS | full form: Distributed Denial of Service |
| ECDH | ECDH | full form: Elliptic Curve Diffie-Hellman |
| Ed25519 | Ed25519 |  |
| fail-open | fail-open | 失败时放行 |
| fail-closed | fail-closed | 失败时拒绝 |
| Firewall | Firewall |  |
| HKDF | HKDF | full form: HMAC-based Key Derivation Function |
| HMAC | HMAC | full form: Hash-based Message Authentication Code |
| HTTP | HTTP | full form: HyperText Transfer Protocol |
| HTTPS | HTTPS | full form: HyperText Transfer Protocol Secure |
| HWID | HWID | full form: Hardware Identifier |
| I/O Multiplexing | I/O 多路复用 | 例如 selector、epoll、kqueue |
| IP Address | IP 地址 | full form: Internet Protocol Address |
| Initialization Vector | 初始化向量 | 在 GCM 语境中又称 Nonce |
| JSON | JSON | full form: JavaScript Object Notation |
| Kerckhoffs's Principle | Kerckhoffs 原则 |  |
| LoRa | LoRa |  |
| BLE | BLE | full form: Bluetooth Low Energy |
| Man-In-The-Middle | MITM |  |
| OPSEC | OPSEC | full form: Operations Security |
| P2P | P2P | full form: Peer-to-Peer |
| Proof of Concept | PoC |  |
| Proof of Work | PoW |  |
| PRF | PRF | full form: Pseudo-Random Function |
| PSK | PSK | full form: Pre-Shared Key |
| root | root |  |
| SHA-3-256 | SHA-3-256 | full form: Secure Hash Algorithm 3, 256-bit |
| Slowloris Attack | Slowloris 攻击 |  |
| Socket | Socket |  |
| Subpoena | Subpoena |  |
| Sybil Attack | Sybil 攻击 |  |
| Token Certification Authority | 令牌认证机构 | 缩写 TCA |
| TLS 1.3 | TLS 1.3 | full form: Transport Layer Security 1.3 |
| Token | 令牌 | 身份凭证 |
| TPM | TPM | full form: Trusted Platform Module |
| Handshake Transcript | 握手记录 | 变量名 transcript（冻结，不改） |
| TRNG | TRNG | full form: True Random Number Generator |
| TTL | TTL | full form: Time To Live |
| VPN | VPN | full form: Virtual Private Network |
| VPS | VPS | full form: Virtual Private Server |
| WireGuard | WireGuard |  |
| X25519 | X25519 | full form: Curve25519 Key Exchange |
| YAML | YAML | full form: YAML Ain't Markup Language |
| Nonce | 接入随机数 | 阶段一携带；长度由参数 random_len 决定（冻结字段名） |
| Access Salt | 接入盐 | 本地生成，不随帧传输 |
| Waiting Pool | 等候池 | 服务器暂存待配对会话的池 |
| Session Identifier | 会话标识 | 缩写 SID |
| Confirmation Tag | 确认标签 | 与 AEAD 的认证标签是两回事 |
| Neighbour-Packet Linkage | 前后包关联 | 每个包只与紧邻的上一包、下一包可互相解密 |
| Data Packet | 数据包 | 唯一包类型；空载只是它的一种状态 |
| Framing | 帧界定 | 解决粘包与拆包的对策 |
| Offer Packet | 提议包 | 阶段二由发起方提交，含其临时公钥与会话盐；对方据此协商后应答 |
| Answer Packet | 应答包 | 阶段二由响应方返还，含其临时公钥；与提议包成对 |

## 使用规则

1. 首次出现写「中文（English）」，之后只用其一；英文版一律使用 English 列。
2. 缩写词（TLS、AEAD、HKDF…）不翻译，保持原形。
3. 代码标识符（`session_salt`、`ZTDSPSecurityError`）不翻译，注释中保留原拼写。
4. 协议常量串（`ZT-DSP-PHASE1-NONCE-v3` 等）**永不翻译**。
