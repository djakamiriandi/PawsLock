import Cocoa
import SwiftUI

public class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem?
    
    public func applicationDidFinishLaunching(_ notification: Notification) {
        setupStatusItem()
        
        // Show main window upon launch
        OverlayWindowController.shared.showWindow()
        
        // Check permissions
        AccessibilityManager.shared.checkAccessibility(promptIfNeeded: false)
    }
    
    public func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        OverlayWindowController.shared.showWindow()
        return true
    }
    
    private func setupStatusItem() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem?.button {
            button.title = "🐾"
            button.toolTip = "PawsLock - Pembersih Keyboard MacBook"
        }
        
        let menu = NSMenu()
        
        let openItem = NSMenuItem(
            title: "🐾 Buka PawsLock",
            action: #selector(openMainWindow),
            keyEquivalent: "o"
        )
        openItem.target = self
        menu.addItem(openItem)
        
        let startItem = NSMenuItem(
            title: "Mulai Bersihkan",
            action: #selector(startCleaning),
            keyEquivalent: "k"
        )
        startItem.target = self
        menu.addItem(startItem)
        
        menu.addItem(NSMenuItem.separator())
        
        let permItem = NSMenuItem(
            title: "Pengaturan Aksesibilitas...",
            action: #selector(openPermissions),
            keyEquivalent: ""
        )
        permItem.target = self
        menu.addItem(permItem)
        
        menu.addItem(NSMenuItem.separator())
        
        let quitItem = NSMenuItem(
            title: "Keluar dari PawsLock",
            action: #selector(quitApp),
            keyEquivalent: "q"
        )
        quitItem.target = self
        menu.addItem(quitItem)
        
        statusItem?.menu = menu
    }
    
    @objc private func openMainWindow() {
        OverlayWindowController.shared.showWindow()
    }
    
    @objc private func startCleaning() {
        OverlayWindowController.shared.startCleanup()
    }
    
    @objc private func openPermissions() {
        AccessibilityManager.shared.openAccessibilitySettings()
    }
    
    @objc private func quitApp() {
        NSApplication.shared.terminate(nil)
    }
}
