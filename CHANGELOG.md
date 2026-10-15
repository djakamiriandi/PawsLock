# Changelog 🐾

All notable changes to **PawsLock** will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-10-16

### Added
- **Compact Floating HUD**: Minimalist dark frosted-glass window that stays lightweight and avoids full-screen blackouts.
- **Tuxedo Cat Mascot**: Cute mascot with orange bandana and wooden straw broom.
- **Dual Lock States**:
  - *Idle Mode*: Mascot is completely calm and static.
  - *Cleaning Mode*: Dynamic micro dust puffs and sparkles drift up from the broom bristles.
- **Low-Level Key Interception**: Built on macOS `CGEventTap` to intercept physical keyboard events cleanly.
- **Dual Command 3-Second Unlock**: Hold Left `⌘` (keycode 55) and Right `⌘` (keycode 54) simultaneously for 3 seconds with circular countdown ring.
- **Slide to Unlock Fallback**: Smooth draggable trackpad/mouse slider with 70% threshold.
- **Native macOS Squircle App Icon**: Multi-resolution `AppIcon.icns` (16x16 up to 1024x1024 Retina) adhering to Apple Human Interface Guidelines.
- **Automated Build Script**: One-click release compilation and ad-hoc code-signing via `./build.sh`.
- **Zero Telemetry**: 100% offline, local-only architecture with zero network permissions.
