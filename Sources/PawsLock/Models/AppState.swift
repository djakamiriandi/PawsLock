import Foundation
import Combine

public class AppState: ObservableObject {
    public static let shared = AppState()
    
    @Published public var isLocked: Bool = false
    @Published public var lockKeyboard: Bool = true
    
    @Published public var dualCmdProgress: Double = 0.0 // 0.0 to 1.0 (3.0s total)
    @Published public var isLeftCmdDown: Bool = false
    @Published public var isRightCmdDown: Bool = false
    
    @Published public var speechQuote: String = "Pawsitive Vibes Only!\nLet's sweep away those messy keyboard typos, hooman! 🐱✨"
    @Published public var hasAccessibilityPermission: Bool = false
    
    private init() {}
    
    public func startCleaningSession() {
        isLocked = true
        dualCmdProgress = 0.0
        isLeftCmdDown = false
        isRightCmdDown = false
        speechQuote = "Sweeping in progress...\nTake your time to clean every key! 🧹✨"
    }
    
    public func endCleaningSession(completedNormally: Bool = true) {
        isLocked = false
        dualCmdProgress = 0.0
        isLeftCmdDown = false
        isRightCmdDown = false
        if completedNormally {
            speechQuote = "Nice! Your keyboard now looks like it just stepped out of an Apple keynote! 🎉"
        } else {
            speechQuote = "Pawsitive Vibes Only!\nLet's sweep away those messy keyboard typos, hooman! 🐱✨"
        }
    }
    
    public func updateDualCmdProgress(_ progress: Double) {
        DispatchQueue.main.async {
            self.dualCmdProgress = min(max(progress, 0.0), 1.0)
        }
    }
    
    public func updateCommandKeys(left: Bool, right: Bool) {
        DispatchQueue.main.async {
            self.isLeftCmdDown = left
            self.isRightCmdDown = right
        }
    }
}
