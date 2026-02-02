import SwiftUI
import FirebaseAuth

// MARK: - Root View
/// App entry point that manages the primary navigation flow.
/// Orchestrates switching between Auth and Main Content based on session state.
struct RootView: View {
    
    // MARK: - Properties
    /// Observed singleton managing the global authentication state.
    @StateObject private var authManager = AuthManager.shared
    
    // MARK: - Body
    var body: some View {
        Group {
            // Re-evaluates on every change in AuthManager status
            if isAuthenticated {
                ContentView()
            } else {
                LoginView()
            }
        }
    }
    
    // MARK: - Logic
    /// Verifies if a valid session exists and the email is confirmed.
    private var isAuthenticated: Bool {
        return authManager.userSession != nil && authManager.isEmailVerified
    }
}

// MARK: - Previews
#Preview {
    RootView()
}
