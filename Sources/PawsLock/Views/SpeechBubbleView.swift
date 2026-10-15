import SwiftUI

public struct SpeechBubbleView: View {
    public let text: String
    
    public init(text: String) {
        self.text = text
    }
    
    public var body: some View {
        HStack(alignment: .center, spacing: 0) {
            // Speech triangle pointer pointing left to the cat
            Path { path in
                path.move(to: CGPoint(x: 10, y: 0))
                path.addLine(to: CGPoint(x: 0, y: 10))
                path.addLine(to: CGPoint(x: 10, y: 20))
                path.closeSubpath()
            }
            .fill(Color(red: 0.05, green: 0.52, blue: 1.0))
            .frame(width: 10, height: 20)
            .offset(x: 1)
            
            // Speech bubble container
            Text(text)
                .font(.system(size: 13, weight: .semibold, design: .rounded))
                .foregroundColor(.white)
                .multilineTextAlignment(.leading)
                .lineSpacing(3)
                .padding(.horizontal, 15)
                .padding(.vertical, 13)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 18)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.08, green: 0.55, blue: 1.0),
                                    Color(red: 0.0, green: 0.42, blue: 0.92)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 18)
                                .stroke(Color.white.opacity(0.22), lineWidth: 1)
                        )
                )
                .shadow(color: Color.blue.opacity(0.35), radius: 8, x: 0, y: 3)
        }
        .animation(.spring(response: 0.35, dampingFraction: 0.75), value: text)
    }
}
