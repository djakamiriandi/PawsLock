import SwiftUI

public class SlideUnlockViewModel: ObservableObject {
    @Published public var dragOffset: CGFloat = 0
    @Published public var isUnlocked: Bool = false
    
    public init() {}
    
    public func reset() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            dragOffset = 0
            isUnlocked = false
        }
    }
}

public struct SlideToUnlockBarView: View {
    @ObservedObject var viewModel: SlideUnlockViewModel
    
    private let trackWidth: CGFloat = 310
    private let trackHeight: CGFloat = 46
    private let knobSize: CGFloat = 38
    
    public var onUnlock: (() -> Void)?
    
    public init(viewModel: SlideUnlockViewModel = SlideUnlockViewModel(), onUnlock: (() -> Void)? = nil) {
        self.viewModel = viewModel
        self.onUnlock = onUnlock
    }
    
    public var body: some View {
        let maxDrag = trackWidth - knobSize - 8
        
        ZStack(alignment: .leading) {
            // Track Background
            Capsule()
                .fill(Color.white.opacity(0.12))
                .frame(width: trackWidth, height: trackHeight)
                .overlay(
                    Capsule()
                        .stroke(Color.white.opacity(0.18), lineWidth: 1)
                )
            
            // Text hint
            HStack {
                Spacer()
                Text("atau geser untuk membuka ➔")
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .foregroundColor(.white.opacity(0.65))
                    .padding(.leading, 32)
                Spacer()
            }
            .frame(width: trackWidth)
            
            // Progress Fill behind the knob
            Capsule()
                .fill(
                    LinearGradient(
                        colors: [Color.blue.opacity(0.5), Color.green.opacity(0.7)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(width: max(knobSize + 8, viewModel.dragOffset + knobSize + 4), height: trackHeight)
            
            // Draggable Paw Knob
            Circle()
                .fill(
                    LinearGradient(
                        colors: [Color.white, Color(white: 0.90)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: knobSize, height: knobSize)
                .shadow(color: Color.black.opacity(0.35), radius: 5, x: 0, y: 2)
                .overlay(
                    Text("🐾")
                        .font(.system(size: 18))
                )
                .padding(.leading, 4)
                .offset(x: viewModel.dragOffset)
        }
        .frame(width: trackWidth, height: trackHeight)
        .contentShape(Rectangle())
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    guard !viewModel.isUnlocked else { return }
                    if value.translation.width > 0 {
                        viewModel.dragOffset = min(value.translation.width, maxDrag)
                    } else {
                        viewModel.dragOffset = 0
                    }
                }
                .onEnded { value in
                    guard !viewModel.isUnlocked else { return }
                    // Trigger unlock if dragged past 70% of track
                    if viewModel.dragOffset >= maxDrag * 0.70 {
                        viewModel.isUnlocked = true
                        withAnimation(.easeOut(duration: 0.15)) {
                            viewModel.dragOffset = maxDrag
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
                            onUnlock?()
                        }
                    } else {
                        viewModel.reset()
                    }
                }
        )
    }
}
