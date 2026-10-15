import SwiftUI

public struct DualCmdKeysView: View {
    @ObservedObject var appState: AppState = AppState.shared
    
    public init() {}
    
    public var body: some View {
        VStack(spacing: 16) {
            Text("Hold down both Command keys for 3 seconds to unlock")
                .font(.system(size: 13, weight: .medium, design: .rounded))
                .foregroundColor(.white.opacity(0.85))
                .multilineTextAlignment(.center)
            
            HStack(spacing: 24) {
                // Left Command Key
                KeyButtonView(
                    label: "⌘",
                    subtitle: "command",
                    isPressed: appState.isLeftCmdDown
                )
                
                // Progress Indicator between keys
                ZStack {
                    Circle()
                        .stroke(Color.white.opacity(0.12), lineWidth: 4)
                        .frame(width: 44, height: 44)
                    
                    Circle()
                        .trim(from: 0.0, to: CGFloat(appState.dualCmdProgress))
                        .stroke(
                            LinearGradient(
                                colors: [Color.green, Color.cyan],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 4, lineCap: .round)
                        )
                        .rotationEffect(.degrees(-90))
                        .frame(width: 44, height: 44)
                        .animation(.linear(duration: 0.05), value: appState.dualCmdProgress)
                    
                    if appState.dualCmdProgress > 0 {
                        Text("\(Int(appState.dualCmdProgress * 100))%")
                            .font(.system(size: 10, weight: .bold, design: .monospaced))
                            .foregroundColor(.white)
                    } else {
                        Image(systemName: "lock.fill")
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.4))
                    }
                }
                
                // Right Command Key
                KeyButtonView(
                    label: "⌘",
                    subtitle: "command",
                    isPressed: appState.isRightCmdDown
                )
            }
        }
    }
}

struct KeyButtonView: View {
    let label: String
    let subtitle: String
    let isPressed: Bool
    
    var body: some View {
        VStack(spacing: 2) {
            Text(label)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(isPressed ? .black : .white)
            Text(subtitle)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(isPressed ? .black.opacity(0.8) : .white.opacity(0.7))
        }
        .frame(width: 72, height: 56)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(isPressed ? Color.green : Color(white: 0.18))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(isPressed ? Color.white : Color.white.opacity(0.15), lineWidth: 1.5)
        )
        .shadow(color: isPressed ? Color.green.opacity(0.5) : Color.black.opacity(0.3), radius: 6, x: 0, y: 2)
        .scaleEffect(isPressed ? 0.96 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
    }
}
