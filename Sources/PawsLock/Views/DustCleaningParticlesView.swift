import SwiftUI

public class DustParticlesViewModel: ObservableObject {
    @Published public var driftProgress: Double = 0.0
    private var timer: Timer?
    
    public init() {}
    
    public func startDrift() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.04, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.driftProgress = (self.driftProgress + 0.02).truncatingRemainder(dividingBy: 1.0)
        }
        if let t = timer {
            RunLoop.main.add(t, forMode: .common)
        }
    }
    
    public func stopDrift() {
        timer?.invalidate()
        timer = nil
        driftProgress = 0.0
    }
}

public struct DustCleaningParticlesView: View {
    @ObservedObject var appState: AppState = AppState.shared
    @ObservedObject var viewModel: DustParticlesViewModel
    
    public init(viewModel: DustParticlesViewModel = DustParticlesViewModel()) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        ZStack {
            if appState.isLocked {
                // Broom dust puff 1 (soft cloud puff drifting up from broom head)
                Circle()
                    .fill(Color.white.opacity(max(0, 0.65 - viewModel.driftProgress * 0.65)))
                    .frame(width: 6, height: 6)
                    .blur(radius: 0.5)
                    .offset(
                        x: 38 + CGFloat(viewModel.driftProgress * 20),
                        y: 42 - CGFloat(viewModel.driftProgress * 36)
                    )
                
                // Broom dust puff 2 (secondary micro puff)
                Circle()
                    .fill(Color(white: 0.9).opacity(max(0, 0.55 - (viewModel.driftProgress + 0.35).truncatingRemainder(dividingBy: 1.0) * 0.55)))
                    .frame(width: 4.5, height: 4.5)
                    .blur(radius: 0.5)
                    .offset(
                        x: 30 + CGFloat((viewModel.driftProgress + 0.35).truncatingRemainder(dividingBy: 1.0) * 16),
                        y: 46 - CGFloat((viewModel.driftProgress + 0.35).truncatingRemainder(dividingBy: 1.0) * 42)
                    )
                
                // Broom dust puff 3 (drifting slightly right)
                Circle()
                    .fill(Color(white: 0.85).opacity(max(0, 0.45 - (viewModel.driftProgress + 0.7).truncatingRemainder(dividingBy: 1.0) * 0.45)))
                    .frame(width: 3.5, height: 3.5)
                    .offset(
                        x: 44 + CGFloat((viewModel.driftProgress + 0.7).truncatingRemainder(dividingBy: 1.0) * 18),
                        y: 38 - CGFloat((viewModel.driftProgress + 0.7).truncatingRemainder(dividingBy: 1.0) * 32)
                    )
                
                // Clean sparkle 1 (soft cyan star twinkling from fresh surface)
                Text("✧")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(Color(red: 0.4, green: 0.85, blue: 1.0).opacity(max(0, 0.9 - (viewModel.driftProgress + 0.2).truncatingRemainder(dividingBy: 1.0) * 0.9)))
                    .offset(
                        x: 46 + CGFloat((viewModel.driftProgress + 0.2).truncatingRemainder(dividingBy: 1.0) * 12),
                        y: 20 - CGFloat((viewModel.driftProgress + 0.2).truncatingRemainder(dividingBy: 1.0) * 30)
                    )
                
                // Clean sparkle 2 (warm golden sparkle)
                Text("✦")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(Color(red: 1.0, green: 0.88, blue: 0.5).opacity(max(0, 0.85 - (viewModel.driftProgress + 0.55).truncatingRemainder(dividingBy: 1.0) * 0.85)))
                    .offset(
                        x: 22 + CGFloat((viewModel.driftProgress + 0.55).truncatingRemainder(dividingBy: 1.0) * 14),
                        y: 28 - CGFloat((viewModel.driftProgress + 0.55).truncatingRemainder(dividingBy: 1.0) * 38)
                    )
                
                // Clean sparkle 3 (high sparkle near broom handle)
                Text("✨")
                    .font(.system(size: 11))
                    .opacity(max(0, 0.95 - (viewModel.driftProgress + 0.85).truncatingRemainder(dividingBy: 1.0) * 0.95))
                    .offset(
                        x: 52 + CGFloat((viewModel.driftProgress + 0.85).truncatingRemainder(dividingBy: 1.0) * 10),
                        y: 5 - CGFloat((viewModel.driftProgress + 0.85).truncatingRemainder(dividingBy: 1.0) * 24)
                    )
            }
        }
        .onAppear {
            viewModel.startDrift()
        }
        .onDisappear {
            viewModel.stopDrift()
        }
    }
}
