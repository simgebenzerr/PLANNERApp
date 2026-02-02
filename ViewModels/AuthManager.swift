import Foundation
import FirebaseAuth
import Combine

// MARK: - Auth Manager
/// Centralized service to manage user sessions and authentication state.
class AuthManager: ObservableObject {
    
    // MARK: - Shared Instance
    static let shared = AuthManager()
    
    // MARK: - Properties
    @Published var userSession: FirebaseAuth.User?
    @Published var isEmailVerified = false
    
    // Handler to manage the Firebase auth state listener lifecycle
    private var authListener: AuthStateDidChangeListenerHandle?
    
    // MARK: - Initialization
    private init() {
        setupStateListener()
    }
    
    // MARK: - Private Methods
    /// Attaches a listener to track Firebase authentication changes.
    private func setupStateListener() {
        authListener = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                self?.userSession = user
                self?.isEmailVerified = user?.isEmailVerified ?? false
            }
        }
    }
    
    // MARK: - Public Methods
    /// Force refreshes the current user session to sync email verification status.
    func updateStatus() {
        Auth.auth().currentUser?.reload { [weak self] _ in
            DispatchQueue.main.async {
                let user = Auth.auth().currentUser
                self?.userSession = user
                self?.isEmailVerified = user?.isEmailVerified ?? false
            }
        }
    }
    
    // Cleanup listener when manager is deinitialized
    deinit {
        if let listener = authListener {
            Auth.auth().removeStateDidChangeListener(listener)
        }
    }
}
