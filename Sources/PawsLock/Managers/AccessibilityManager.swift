import Foundation
import Cocoa
import ApplicationServices

public class AccessibilityManager {
    public static let shared = AccessibilityManager()
    
    private var pollTimer: Timer?
    
    private init() {}
    
    @discardableResult
    public func checkAccessibility(promptIfNeeded: Bool = false) -> Bool {
        let options = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: promptIfNeeded] as CFDictionary
        let isTrusted = AXIsProcessTrustedWithOptions(options)
        
        DispatchQueue.main.async {
            AppState.shared.hasAccessibilityPermission = isTrusted
        }
        
        if !isTrusted && pollTimer == nil {
            startPollingPermission()
        } else if isTrusted {
            stopPollingPermission()
        }
        
        return isTrusted
    }
    
    public func openAccessibilitySettings() {
        if let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility") {
            NSWorkspace.shared.open(url)
        }
    }
    
    private func startPollingPermission() {
        pollTimer?.invalidate()
        pollTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            let trusted = AXIsProcessTrusted()
            DispatchQueue.main.async {
                AppState.shared.hasAccessibilityPermission = trusted
                if trusted {
                    self?.stopPollingPermission()
                }
            }
        }
    }
    
    private func stopPollingPermission() {
        pollTimer?.invalidate()
        pollTimer = nil
    }
}
