import Foundation
import CoreGraphics
import Cocoa

public class EventTapManager {
    public static let shared = EventTapManager()
    
    private var eventTap: CFMachPort?
    private var runLoopSource: CFRunLoopSource?
    
    private var isLeftCmdDown: Bool = false
    private var isRightCmdDown: Bool = false
    
    // Dedicated heartbeat timer for smooth 3-second progress
    private var heartbeatTimer: Timer?
    private var dualHoldDuration: TimeInterval = 0.0
    private let requiredDuration: TimeInterval = 3.0
    
    public var onUnlockTriggered: (() -> Void)?
    
    private init() {}
    
    public func start() -> Bool {
        guard eventTap == nil else { return true }
        
        isLeftCmdDown = false
        isRightCmdDown = false
        dualHoldDuration = 0.0
        
        let eventMask: CGEventMask = (1 << CGEventType.keyDown.rawValue) |
                                     (1 << CGEventType.keyUp.rawValue) |
                                     (1 << CGEventType.flagsChanged.rawValue)
        
        let selfPointer = Unmanaged.passUnretained(self).toOpaque()
        
        guard let tap = CGEvent.tapCreate(
            tap: .cgSessionEventTap,
            place: .headInsertEventTap,
            options: .defaultTap,
            eventsOfInterest: eventMask,
            callback: { (proxy, type, event, refcon) -> Unmanaged<CGEvent>? in
                guard let refcon = refcon else {
                    return Unmanaged.passRetained(event)
                }
                let manager = Unmanaged<EventTapManager>.fromOpaque(refcon).takeUnretainedValue()
                return manager.handleEvent(proxy: proxy, type: type, event: event)
            },
            userInfo: selfPointer
        ) else {
            print("[PawsLock] Failed to create CGEventTap.")
            return false
        }
        
        self.eventTap = tap
        let source = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, tap, 0)
        self.runLoopSource = source
        
        CFRunLoopAddSource(CFRunLoopGetMain(), source, .commonModes)
        CGEvent.tapEnable(tap: tap, enable: true)
        
        startHeartbeat()
        print("[PawsLock] EventTap started successfully.")
        return true
    }
    
    public func stop() {
        stopHeartbeat()
        
        if let tap = eventTap {
            CGEvent.tapEnable(tap: tap, enable: false)
            if let source = runLoopSource {
                CFRunLoopRemoveSource(CFRunLoopGetMain(), source, .commonModes)
            }
            CFMachPortInvalidate(tap)
        }
        
        eventTap = nil
        runLoopSource = nil
        isLeftCmdDown = false
        isRightCmdDown = false
        AppState.shared.updateCommandKeys(left: false, right: false)
        AppState.shared.updateDualCmdProgress(0.0)
        print("[PawsLock] EventTap stopped.")
    }
    
    private func startHeartbeat() {
        heartbeatTimer?.invalidate()
        dualHoldDuration = 0.0
        
        heartbeatTimer = Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            // Check if both Left Command and Right Command are held
            if self.isLeftCmdDown && self.isRightCmdDown {
                self.dualHoldDuration += 0.03
                let progress = min(self.dualHoldDuration / self.requiredDuration, 1.0)
                AppState.shared.updateDualCmdProgress(progress)
                
                if self.dualHoldDuration >= self.requiredDuration {
                    self.dualHoldDuration = 0.0
                    self.triggerUnlock()
                }
            } else {
                if self.dualHoldDuration > 0.0 {
                    self.dualHoldDuration = 0.0
                    AppState.shared.updateDualCmdProgress(0.0)
                }
            }
        }
        
        if let timer = heartbeatTimer {
            RunLoop.main.add(timer, forMode: .common)
        }
    }
    
    private func stopHeartbeat() {
        heartbeatTimer?.invalidate()
        heartbeatTimer = nil
        dualHoldDuration = 0.0
        AppState.shared.updateDualCmdProgress(0.0)
    }
    
    private func handleEvent(proxy: CGEventTapProxy, type: CGEventType, event: CGEvent) -> Unmanaged<CGEvent>? {
        if type == .tapDisabledByTimeout || type == .tapDisabledByUserInput {
            if let tap = eventTap {
                CGEvent.tapEnable(tap: tap, enable: true)
            }
            return Unmanaged.passRetained(event)
        }
        
        if type == .flagsChanged {
            let keyCode = event.getIntegerValueField(.keyboardEventKeycode)
            let hasCommand = event.flags.contains(.maskCommand)
            
            if !hasCommand {
                // Command modifier is completely released
                isLeftCmdDown = false
                isRightCmdDown = false
            } else {
                // Keycode 55 = Left Command, Keycode 54 = Right Command
                if keyCode == 55 {
                    isLeftCmdDown.toggle()
                    if !isRightCmdDown { isLeftCmdDown = true }
                } else if keyCode == 54 {
                    isRightCmdDown.toggle()
                    if !isLeftCmdDown { isRightCmdDown = true }
                }
            }
            
            AppState.shared.updateCommandKeys(left: isLeftCmdDown, right: isRightCmdDown)
        }
        
        // Swallow keyboard input while locked
        return nil
    }
    
    public func triggerUnlock() {
        DispatchQueue.main.async { [weak self] in
            self?.stop()
            AppState.shared.endCleaningSession(completedNormally: true)
            self?.onUnlockTriggered?()
        }
    }
}
