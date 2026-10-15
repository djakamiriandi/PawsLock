# Security Policy 🔒

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 1.0.x   | :white_check_mark: |

## Privacy & Security Guarantee
- **Zero Telemetry**: PawsLock contains no analytics, tracking, or network code.
- **No Keystroke Logging**: The low-level `CGEventTap` is used strictly to swallow `keyDown` and `keyUp` events while a cleaning session is active. Events are never recorded, cached, or saved to disk.
- **Local Execution**: All processing occurs strictly on your local Mac.

## Reporting a Vulnerability
If you discover a security or privacy vulnerability, please do NOT open a public GitHub issue. Instead, report it privately by opening a [Security Advisory](https://github.com/your-username/PawsLock/security/advisories) on GitHub or contacting the repository owner directly.
