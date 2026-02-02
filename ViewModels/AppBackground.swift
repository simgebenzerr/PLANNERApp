import SwiftUI

// MARK: - App Background
/// Provides a consistent mesh-gradient aesthetic with blurred glow effects.
struct AppBackground: View {
    
    // MARK: - Constants
    private let glowOpacity: Double = 0.2
    private let blurRadius: CGFloat = 80
    private let circleSize: CGFloat = 300
    
    // MARK: - Body
    var body: some View {
        ZStack {
            // Dark base layer
            Color.black.ignoresSafeArea()
            
            // Secondary accent (Top-Left)
            glowCircle(color: .purple, x: -150, y: -300)
            
            // Primary accent (Bottom-Right)
            glowCircle(color: .blue, x: 150, y: 300)
        }
    }
    
    // MARK: - Components
    /// Renders a blurred circular glow at a specific coordinate.
    private func glowCircle(color: Color, x: CGFloat, y: CGFloat) -> some View {
        Circle()
            .fill(color.opacity(glowOpacity))
            .frame(width: circleSize)
            .blur(radius: blurRadius)
            .offset(x: x, y: y)
    }
}

// MARK: - Previews
#Preview {
    AppBackground()
}
