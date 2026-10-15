# Contributing to PawsLock 🐾

Thank you for your interest in contributing to PawsLock! We welcome bug fixes, documentation improvements, and thoughtful feature ideas.

## 🛠️ Development Setup

### Prerequisites
- macOS 13.0 (Ventura) or newer
- Xcode 15+ or macOS Command Line Tools (`xcode-select --install`)
- Swift 5.9+

### Building Locally
1. Clone the repository:
   ```bash
   git clone https://github.com/djakamiriandi/PawsLock.git
   cd PawsLock
   ```
2. Build and sign the application bundle:
   ```bash
   chmod +x build.sh
   ./build.sh
   ```
3. Run the compiled app:
   ```bash
   open PawsLock.app
   ```

## 📋 Code Guidelines
- **Pure Swift & SwiftUI**: Keep dependencies at zero. PawsLock relies exclusively on standard Apple frameworks (`SwiftUI`, `AppKit`, `CoreGraphics`).
- **No `@State` Macro in CLI Builds**: To ensure compatibility with lightweight `CommandLineTools` without Xcode plugin dependencies, view state is managed via `ObservableObject` / `@Published` classes.
- **Privacy & Safety First**: Any new feature must uphold our zero-telemetry and offline guarantee. Key inputs must never be logged or stored.

## 🔀 Submitting a Pull Request
1. Fork the repo and create your feature branch: `git checkout -b feature/amazing-feature`
2. Commit your changes: `git commit -m 'feat: add amazing feature'`
3. Push to the branch: `git push origin feature/amazing-feature`
4. Open a Pull Request on GitHub.
