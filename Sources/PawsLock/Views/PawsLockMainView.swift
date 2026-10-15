import SwiftUI

public class MainViewModel: ObservableObject {
    @Published public var isHoveringStart: Bool = false
    
    public init() {}
}

public struct PawsLockMainView: View {
    @ObservedObject var appState: AppState = AppState.shared
    @ObservedObject var viewModel: MainViewModel
    
    public var onStartCleanup: (() -> Void)?
    public var onEmergencyUnlock: (() -> Void)?
    
    public init(
        viewModel: MainViewModel = MainViewModel(),
        onStartCleanup: (() -> Void)? = nil,
        onEmergencyUnlock: (() -> Void)? = nil
    ) {
        self.viewModel = viewModel
        self.onStartCleanup = onStartCleanup
        self.onEmergencyUnlock = onEmergencyUnlock
    }
    
    public var body: some View {
        ZStack {
            // Dark luxury frosted glass background
            Color(red: 0.12, green: 0.12, blue: 0.14)
                .ignoresSafeArea()
            
            // Soft ambient light aura behind the cat
            RadialGradient(
                colors: [
                    Color(red: 0.0, green: 0.50, blue: 1.0).opacity(0.18),
                    Color(red: 0.0, green: 0.25, blue: 0.60).opacity(0.06),
                    Color.clear
                ],
                center: .topTrailing,
                startRadius: 20,
                endRadius: 260
            )
            .ignoresSafeArea()
            
            VStack(spacing: 12) {
                // Header: Centered App Title matching the mockup
                HStack {
                    Spacer()
                    Text("PawsLock")
                        .font(.system(size: 13, weight: .semibold, design: .rounded))
                        .foregroundColor(.white.opacity(0.85))
                    Spacer()
                }
                .padding(.top, 14)
                .padding(.bottom, 2)
                
                // Top Section: Mascot + Dust Particles (only when locked) + Speech Bubble
                HStack(alignment: .center, spacing: 14) {
                    ZStack {
                        SweepingCatView()
                            .frame(width: 125, height: 125)
                        
                        // Animated dust particles appear only during cleaning!
                        DustCleaningParticlesView()
                    }
                    
                    SpeechBubbleView(text: appState.speechQuote)
                        .frame(maxWidth: .infinity)
                }
                .padding(.horizontal, 16)
                
                Spacer().frame(height: 4)
                
                // Bottom Card: Smooth Transition between Idle & Cleaning
                ZStack {
                    if !appState.isLocked {
                        // STATE 1: IDLE / BEFORE CLEANING (matching the approved mockup)
                        VStack(spacing: 16) {
                            // Clean Keyboard Card
                            VStack(spacing: 14) {
                                HStack(alignment: .center) {
                                    VStack(alignment: .leading, spacing: 3) {
                                        Text("Clean Keyboard")
                                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                                            .foregroundColor(.white)
                                        Text("Lock all keys during physical cleaning")
                                            .font(.system(size: 11, weight: .regular))
                                            .foregroundColor(.white.opacity(0.50))
                                    }
                                    
                                    Spacer()
                                    
                                    Toggle("", isOn: $appState.lockKeyboard)
                                        .toggleStyle(SwitchToggleStyle(tint: Color(red: 0.0, green: 0.82, blue: 1.0)))
                                        .shadow(color: Color.cyan.opacity(appState.lockKeyboard ? 0.6 : 0), radius: 8)
                                }
                                .padding(.horizontal, 18)
                                .padding(.top, 16)
                                
                                // Glowing Start Cleanup Button
                                Button(action: {
                                    withAnimation(.spring(response: 0.42, dampingFraction: 0.78)) {
                                        onStartCleanup?()
                                    }
                                }) {
                                    HStack(spacing: 8) {
                                        Text("🧹")
                                            .font(.system(size: 15))
                                        Text("Start Cleanup")
                                            .font(.system(size: 15, weight: .bold, design: .rounded))
                                    }
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(
                                                LinearGradient(
                                                    colors: [
                                                        Color(red: 0.05, green: 0.52, blue: 1.0),
                                                        Color(red: 0.0, green: 0.38, blue: 0.92)
                                                    ],
                                                    startPoint: .top,
                                                    endPoint: .bottom
                                                )
                                            )
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.white.opacity(0.28), lineWidth: 1)
                                    )
                                    .shadow(
                                        color: Color.blue.opacity(viewModel.isHoveringStart ? 0.75 : 0.55),
                                        radius: viewModel.isHoveringStart ? 14 : 9,
                                        x: 0,
                                        y: 4
                                    )
                                    .scaleEffect(viewModel.isHoveringStart ? 1.02 : 1.0)
                                }
                                .buttonStyle(PlainButtonStyle())
                                .onHover { hovering in
                                    withAnimation(.easeInOut(duration: 0.16)) {
                                        viewModel.isHoveringStart = hovering
                                    }
                                }
                                .padding(.horizontal, 18)
                                .padding(.bottom, 16)
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 18)
                                    .fill(Color.white.opacity(0.06))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 18)
                                            .stroke(
                                                LinearGradient(
                                                    colors: [
                                                        Color.white.opacity(0.18),
                                                        Color.white.opacity(0.06)
                                                    ],
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                ),
                                                lineWidth: 1
                                            )
                                    )
                            )
                            .shadow(color: Color.black.opacity(0.35), radius: 10, x: 0, y: 5)
                            .padding(.horizontal, 16)
                            
                            // Footnote instruction
                            Text("To unlock input after cleaning, hold down both left and right Command keys for 3 seconds, or slide to unlock.")
                                .font(.system(size: 11, weight: .regular))
                                .foregroundColor(.white.opacity(0.45))
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity)
                                .padding(.horizontal, 20)
                        }
                        .transition(.asymmetric(
                            insertion: .opacity.combined(with: .scale(scale: 0.95)),
                            removal: .opacity.combined(with: .scale(scale: 0.95))
                        ))
                    } else {
                        // STATE 2: ACTIVE CLEANING MODE (Retaining the clean button, center ring, and slider)
                        VStack(spacing: 16) {
                            DualCmdKeysView()
                                .padding(.horizontal, 16)
                                .padding(.top, 4)
                            
                            // Slide to unlock bar
                            SlideToUnlockBarView {
                                withAnimation(.spring(response: 0.42, dampingFraction: 0.78)) {
                                    onEmergencyUnlock?()
                                }
                            }
                            .padding(.top, 4)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 18)
                                .fill(Color.white.opacity(0.06))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 18)
                                        .stroke(
                                            LinearGradient(
                                                colors: [
                                                    Color.white.opacity(0.18),
                                                    Color.white.opacity(0.06)
                                                ],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ),
                                            lineWidth: 1
                                        )
                                )
                        )
                        .padding(.horizontal, 16)
                        .transition(.asymmetric(
                            insertion: .opacity.combined(with: .scale(scale: 1.03)),
                            removal: .opacity.combined(with: .scale(scale: 0.97))
                        ))
                    }
                }
                
                Spacer()
            }
        }
        .frame(width: 380, height: 440)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white.opacity(0.12), lineWidth: 1)
        )
        .animation(.spring(response: 0.42, dampingFraction: 0.78), value: appState.isLocked)
    }
}
