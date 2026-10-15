import SwiftUI
import Cocoa

public class SweepingCatViewModel: ObservableObject {
    @Published public var sweepAngle: Double = 0.0
    
    public init() {}
    
    public func startSweeping() {
        // Continuous gentle sweeping motion ONLY when locked
        withAnimation(.easeInOut(duration: 0.65).repeatForever(autoreverses: true)) {
            self.sweepAngle = 3.0
        }
    }
    
    public func stopSweeping() {
        withAnimation(.easeInOut(duration: 0.2)) {
            self.sweepAngle = 0.0
        }
    }
}

public struct SweepingCatView: View {
    @ObservedObject var appState: AppState = AppState.shared
    @ObservedObject var viewModel: SweepingCatViewModel
    
    public init(viewModel: SweepingCatViewModel = SweepingCatViewModel()) {
        self.viewModel = viewModel
    }
    
    private var catImage: NSImage? {
        // 1. Primary: Bundled resource inside PawsLock.app/Contents/Resources/
        if let bundlePath = Bundle.main.path(forResource: "cat_sweeping", ofType: "png"),
           let img = NSImage(contentsOfFile: bundlePath) {
            return img
        }
        
        // 2. Fallback: Relative to current working directory (useful during swift run / dev)
        let relativePath = "Resources/cat_sweeping.png"
        if FileManager.default.fileExists(atPath: relativePath),
           let img = NSImage(contentsOfFile: relativePath) {
            return img
        }
        
        // 3. Fallback: Sibling of executable directory
        let exeDir = Bundle.main.bundleURL.deletingLastPathComponent()
        let siblingPath = exeDir.appendingPathComponent("Resources/cat_sweeping.png").path
        if FileManager.default.fileExists(atPath: siblingPath),
           let img = NSImage(contentsOfFile: siblingPath) {
            return img
        }
        
        return nil
    }
    
    public var body: some View {
        ZStack {
            if let image = catImage {
                Image(nsImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 120, height: 120)
                    .shadow(color: Color.black.opacity(0.25), radius: 6, x: 0, y: 4)
                    // When NOT locked: completely static (0 degrees).
                    // When locked: gentle sweeping motion around the broom base.
                    .rotationEffect(
                        .degrees(appState.isLocked ? viewModel.sweepAngle : 0),
                        anchor: .init(x: 0.8, y: 0.9)
                    )
            } else {
                ZStack {
                    Circle()
                        .fill(Color(white: 0.2))
                        .frame(width: 90, height: 90)
                    Text("🐱🧹")
                        .font(.system(size: 42))
                }
                .frame(width: 120, height: 120)
            }
        }
        .onAppear {
            if appState.isLocked {
                viewModel.startSweeping()
            }
        }
        .onChange(of: appState.isLocked) { locked in
            if locked {
                viewModel.startSweeping()
            } else {
                viewModel.stopSweeping()
            }
        }
    }
}
