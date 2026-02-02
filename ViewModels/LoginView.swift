import SwiftUI
import FirebaseAuth

// MARK: - Login View
/// Manages user authentication through Firebase services.
struct LoginView: View {
    // MARK: - Properties
    @State private var email = ""
    @State private var password = ""
    
    // UI Logic States
    @State private var errorMessage = ""
    @State private var showAlert = false
    @State private var isLoading = false
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                backgroundGlow
                
                VStack(spacing: 30) {
                    Spacer()
                    headerSection
                    formSection
                    loginButton
                    Spacer()
                    registerLink
                }
            }
            .alert("Giriş Başarısız", isPresented: $showAlert) {
                Button("Tamam", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
        }
    }
}

// MARK: - View Components
extension LoginView {
    
    /// Visual glow effect for the background
    private var backgroundGlow: some View {
        Circle()
            .fill(Color.blue.opacity(0.2))
            .frame(width: 300)
            .blur(radius: 80)
            .offset(x: 100, y: -250)
    }
    
    /// Title and tagline subview
    private var headerSection: some View {
        VStack(spacing: 10) {
            Text("Giriş Yap")
                .font(.system(size: 40, weight: .bold, design: .rounded))
                .foregroundColor(.white)
            
            Text("Hayatını planlamaya devam et.")
                .foregroundColor(.gray)
                .padding(.bottom, 20)
        }
    }
    
    /// Input fields for credentials
    private var formSection: some View {
        VStack(spacing: 20) {
            CustomInputFieldsLogin(placeholder: "E-posta", text: $email, icon: "envelope")
                .textInputAutocapitalization(.never)
                .keyboardType(.emailAddress)
            
            CustomSecureFieldLogin(placeholder: "Şifre", text: $password)
        }
        .padding(.horizontal)
    }
    
    /// Main login action button
    private var loginButton: some View {
        Group {
            if isLoading {
                ProgressView().tint(.white)
            } else {
                Button(action: loginUser) {
                    Text("Giriş Yap")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 55)
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(15)
                        .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.white.opacity(0.2)))
                }
                .padding(.horizontal)
                .disabled(email.isEmpty || password.isEmpty)
                .opacity(email.isEmpty || password.isEmpty ? 0.6 : 1.0)
            }
        }
    }
    
    /// Navigation link to registration
    private var registerLink: some View {
        HStack {
            Text("Hesabın yok mu?")
                .foregroundColor(.gray)
            NavigationLink(destination: SignUpView()) {
                Text("Hemen Kaydol")
                    .bold()
                    .foregroundColor(.blue)
            }
        }
        .padding(.bottom, 40)
    }
}

// MARK: - Auth Logic
extension LoginView {
    
    /// Initiates Firebase sign-in and verifies email status
    func loginUser() {
        isLoading = true
        
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                handleAuthError(error)
                return
            }
            
            guard let user = result?.user else { return }
            
            // Sync with server to check verification status
            user.reload { error in
                isLoading = false
                
                if user.isEmailVerified {
                    print("DEBUG: User verified and logged in.")
                    // TRIGGER: Inform AuthManager to refresh the state and switch the view
                    AuthManager.shared.updateStatus()
                } else {
                    errorMessage = "Lütfen e-posta adresinize gönderilen doğrulama linkine tıklayarak hesabınızı onaylayın."
                    showAlert = true
                    try? Auth.auth().signOut()
                    // Sync state even on failure to ensure UI consistency
                    AuthManager.shared.updateStatus()
                }
            }
        }
    }
    
    private func handleAuthError(_ error: Error) {
        isLoading = false
        errorMessage = "Hata: \(error.localizedDescription)"
        showAlert = true
    }
}

// MARK: - Reusable UI Elements
fileprivate struct CustomInputFieldsLogin: View {
    var placeholder: String; @Binding var text: String; var icon: String
    var body: some View {
        HStack {
            Image(systemName: icon).foregroundColor(.gray)
            TextField(placeholder, text: $text).foregroundColor(.white)
        }
        .padding().background(Color.white.opacity(0.05)).cornerRadius(15)
        .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.white.opacity(0.1)))
    }
}

fileprivate struct CustomSecureFieldLogin: View {
    var placeholder: String; @Binding var text: String
    var body: some View {
        HStack {
            Image(systemName: "lock").foregroundColor(.gray)
            SecureField(placeholder, text: $text).foregroundColor(.white)
        }
        .padding().background(Color.white.opacity(0.05)).cornerRadius(15)
        .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.white.opacity(0.1)))
    }
}
