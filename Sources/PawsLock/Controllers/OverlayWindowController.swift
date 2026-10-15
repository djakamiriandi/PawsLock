import Cocoa
import SwiftUI

public class OverlayWindowController: NSObject {
    public static let shared = OverlayWindowController()
    
    public var window: NSWindow?
    
    private override init() {
        super.init()
    }
    
    public func showWindow() {
        if window == nil {
            createWindow()
        }
        
        guard let window = window else { return }
        window.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    public func startCleanup() {
        guard AccessibilityManager.shared.checkAccessibility(promptIfNeeded: true) else {
            let alert = NSAlert()
            alert.messageText = "Izin Aksesibilitas Diperlukan"
            alert.informativeText = "PawsLock membutuhkan izin Aksesibilitas untuk mengunci keyboard saat pembersihan fisik.\n\nSilakan aktifkan PawsLock di System Settings > Privacy & Security > Accessibility."
            alert.alertStyle = .warning
            alert.addButton(withTitle: "Buka System Settings")
            alert.addButton(withTitle: "Batal")
            
            if alert.runModal() == .alertFirstButtonReturn {
                AccessibilityManager.shared.openAccessibilitySettings()
            }
            return
        }
        
        AppState.shared.startCleaningSession()
        let started = EventTapManager.shared.start()
        
        if !started {
            AccessibilityManager.shared.checkAccessibility(promptIfNeeded: true)
        }
        
        EventTapManager.shared.onUnlockTriggered = { [weak self] in
            self?.completeCleanup()
        }
        
        // Keep window floating on top during cleanup
        window?.level = .floating
        window?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    public func completeCleanup() {
        EventTapManager.shared.stop()
        AppState.shared.endCleaningSession(completedNormally: true)
        window?.makeKeyAndOrderFront(nil)
    }
    
    public func cancelCleanup() {
        EventTapManager.shared.stop()
        AppState.shared.endCleaningSession(completedNormally: false)
    }
    
    private func createWindow() {
        let contentRect = NSRect(x: 0, y: 0, width: 380, height: 430)
        
        let win = NSWindow(
            contentRect: contentRect,
            styleMask: [.titled, .closable, .miniaturizable, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        
        win.titlebarAppearsTransparent = true
        win.titleVisibility = .hidden
        // Crucial fix: do NOT allow moving by window background, so mouse drag gestures don't get hijacked!
        win.isMovableByWindowBackground = false
        win.level = .floating
        win.isReleasedWhenClosed = false
        win.center()
        
        let mainView = PawsLockMainView(
            onStartCleanup: { [weak self] in
                self?.startCleanup()
            },
            onEmergencyUnlock: { [weak self] in
                self?.completeCleanup()
            }
        )
        
        win.contentView = NSHostingView(rootView: mainView)
        self.window = win
    }
}
