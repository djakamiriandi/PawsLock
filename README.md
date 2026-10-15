# 🐾 PawsLock

<p align="center">
  <img src="Resources/cat_sweeping.png" alt="PawsLock Mascot" width="160" />
</p>

<p align="center">
  <strong>A cute, minimalist macOS utility to lock your keyboard while cleaning your MacBook.</strong><br>
  No full-screen blackouts, no accidental typing, zero telemetry.
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Platform-macOS%2013.0+-blue?style=flat-square&logo=apple" alt="macOS" />
  <img src="https://img.shields.io/badge/Swift-5.9+-orange?style=flat-square&logo=swift" alt="Swift" />
  <img src="https://img.shields.io/badge/UI-SwiftUI-cyan?style=flat-square" alt="SwiftUI" />
  <img src="https://img.shields.io/badge/License-MIT-green?style=flat-square" alt="License" />
  <img src="https://img.shields.io/badge/Telemetry-Zero-success?style=flat-square" alt="Zero Telemetry" />
</p>

---

## ✨ Why PawsLock?

Ever tried wiping dust or crumbs off your MacBook keyboard, only to accidentally open 10 browser tabs, trigger emergency shortcuts, or send nonsense messages to your coworkers?

**PawsLock** temporarily intercepts and suppresses all physical keyboard input so you can thoroughly clean every key with a cloth or brush. Your screen and mouse/trackpad remain fully functional, and the app runs in a compact, floating HUD inspired by modern macOS design.

---

## 🚀 Features

- 🐱 **Adorable Mascot Companion**: Featuring our tuxedo cat with an orange bandana holding a wooden broom, complete with subtle sweeping dust particles during cleaning.
- 🪟 **Compact Floating HUD**: Minimalist dark frosted-glass window that doesn't obstruct your workspace or black out the display.
- ⌨️ **Total Key Interception**: All key presses are safely intercepted and suppressed via low-level macOS `CGEventTap` during cleaning.
- 🔓 **Two Safe Unlock Mechanisms**:
  1. **Dual Command Hold**: Hold both **Left `⌘`** and **Right `⌘`** keys simultaneously for **3 seconds**.
  2. **Slide to Unlock**: Drag the smooth paw slider with your trackpad or mouse if your keys are unavailable.
- ⚡ **Lightweight & Battery Efficient**: Written in pure Swift and SwiftUI. Zero external dependencies, near-zero idle CPU usage.
- 🔒 **100% Private & Offline**: No network requests, no analytics, no keylogging.

---

## 🛠️ Requirements

- macOS 13.0 (Ventura) or later
- Apple Silicon (M1/M2/M3/M4) or Intel Mac
- Accessibility permissions (required by macOS for input event interception)

---

## 📦 How to Build from Source

1. **Clone the repository**:
   ```bash
   git clone https://github.com/your-username/PawsLock.git
   cd PawsLock
   ```

2. **Run the automated build script**:
   ```bash
   chmod +x build.sh
   ./build.sh
   ```
   This will compile the project in release mode, package it into a proper `PawsLock.app` bundle, and apply an ad-hoc code signature.

3. **Launch the application**:
   ```bash
   open PawsLock.app
   ```

---

## 🔐 macOS Permissions Setup

On the first launch, macOS requires **Accessibility** permission so PawsLock can intercept physical keyboard events during cleaning:

1. Open **System Settings** → **Privacy & Security** → **Accessibility**.
2. Enable the toggle next to **PawsLock**.
3. If prompted, restart PawsLock.

> **Privacy Note**: PawsLock only intercepts events while a cleaning session is actively locked. Keystrokes are discarded immediately and are never recorded, logged, or transmitted anywhere.

---

## 📁 Project Structure

```text
PawsLock/
├── Package.swift           # Swift Package Manager definition
├── Info.plist              # macOS application metadata
├── build.sh                # Release build and bundle packaging script
├── LICENSE                 # MIT License
├── README.md               # Documentation
├── Resources/
│   └── cat_sweeping.png    # Tuxedo cat mascot illustration
└── Sources/
    └── PawsLock/
        ├── main.swift                      # Application entry point
        ├── App/
        │   └── AppDelegate.swift           # App lifecycle & status bar setup
        ├── Controllers/
        │   └── OverlayWindowController.swift # Floating HUD window controller
        ├── Managers/
        │   ├── AccessibilityManager.swift  # TCC permission checks
        │   └── EventTapManager.swift       # CGEventTap keyboard hook & timer
        ├── Models/
        │   └── AppState.swift              # Shared observable app state
        └── Views/
            ├── PawsLockMainView.swift      # Main HUD container & state switch
            ├── SweepingCatView.swift       # Mascot view with subtle lock animation
            ├── DustCleaningParticlesView.swift # Drifting dust & sparkle emitter
            ├── SpeechBubbleView.swift      # Dynamic cheerful speech bubble
            ├── DualCmdKeysView.swift       # Command keys & 3s progress indicator
            └── SlideToUnlockBarView.swift  # Smooth draggable slider to unlock
```

---

## 📄 License

Distributed under the MIT License. See [`LICENSE`](LICENSE) for more information.
