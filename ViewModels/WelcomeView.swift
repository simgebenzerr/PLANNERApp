import SwiftUI

// MARK: - Welcome View
/// Introductory screen with animated branding and entry point.
struct WelcomeView: View {
    // MARK: - Properties
    @State private var isAnimating = false
    @State private var navigateToLogin = false
    
    // MARK: - Body
    var body: some View {
        if navigateToLogin {
            // Transitions to Auth flow
            LoginView()
                .transition(.opacity)
        } else {
            ZStack {
                Color.black.ignoresSafeArea()
                
                // Visual aesthetic effects
                backgroundGlow
                
                VStack(spacing: 40) {
                    Spacer()
                    logoSection
                    taglineSection
                    Spacer()
                    getStartedButton
                }
            }
            .onAppear(perform: startAnimations)
        }
    }
}

// MARK: - View Components
extension WelcomeView {
    
    /// Animated background glow effect
    private var backgroundGlow: some View {
        Circle()
            .fill(Color.blue.opacity(0.3))
            .frame(width: 400, height: 400)
            .blur(radius: 100)
            .offset(y: isAnimating ? -50 : 50)
    }
    
    /// Branding section with animated logo
    private var logoSection: some View {
        VStack(spacing: 20) {
            Image(systemName: "sparkles.rectangle.stack.fill")
                .font(.system(size: 100))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.blue, .purple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: .blue.opacity(0.5), radius: 20)
                .scaleEffect(isAnimating ? 1.05 : 0.95)
            
            Text("PLANNER")
                .font(.system(size: 45, weight: .black, design: .rounded))
                .foregroundColor(.white)
                .tracking(8)
        }
    }
    
    /// Descriptive app tagline
    private var taglineSection: some View {
        Text("Hayatını organize et, vizyonunu yönet.")
            .font(.subheadline)
            .foregroundColor(.gray)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 40)
    }
    
    /// Main entry action button
    private var getStartedButton: some View {
        Button(action: handleGetStarted) {
            Text("Hadi Başlayalım")
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .background(
                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [.blue, .purple],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                )
                .shadow(color: .purple.opacity(0.4), radius: 15)
                .padding(.horizontal, 50)
        }
        .padding(.bottom, 50)
    }
}

// MARK: - Logic & Animations
extension WelcomeView {
    
    /// Initiates continuous UI animations
    private func startAnimations() {
        withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
            isAnimating = true
        }
    }
    
    /// Triggers navigation to login screen
    private func handleGetStarted() {
        withAnimation(.easeInOut(duration: 0.5)) {
            navigateToLogin = true
        }
    }
}
