import SwiftUI
import FirebaseAuth
import FirebaseFirestore

// MARK: - Sign Up View
/// Manages new user registration, Firestore data entry, and email verification.
struct SignUpView: View {
    // MARK: - Properties
    @Environment(\.dismiss) var dismiss
    
    // User Input Fields
    @State private var name = ""
    @State private var surname = ""
    @State private var email = ""
    @State private var password = ""
    @State private var passwordConfirm = ""
    @State private var gender = "Belirtmek İstemiyorum"
    @State private var birthDate = Date()
    
    // UI State Management
    @State private var errorMessage = ""
    @State private var showAlert = false
    @State private var showSuccessAlert = false
    @State private var isLoading = false
    
    private let genders = ["Kadın", "Erkek", "Belirtmek İstemiyorum"]
    
    // MARK: - Body
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            backgroundGlowEffect
            
            ScrollView {
                VStack(spacing: 25) {
                    headerSection
                    registrationForm
                    actionSection
                    Spacer()
                }
                .padding()
            }
        }
        .alert("Hata", isPresented: $showAlert) {
            Button("Tamam", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
        .alert("Başarılı!", isPresented: $showSuccessAlert) {
            Button("Tamam") { dismiss() }
        } message: {
            Text("Hesabınız oluşturuldu. Lütfen e-posta adresinizi doğrulamak için gelen kutunuzu kontrol edin.")
        }
    }
}

// MARK: - UI Components
extension SignUpView {
    
    /// Visual accent for registration background
    private var backgroundGlowEffect: some View {
        Circle()
            .fill(Color.purple.opacity(0.2))
            .frame(width: 300)
            .blur(radius: 80)
            .offset(x: -100, y: -300)
    }
    
    /// Header title subview
    private var headerSection: some View {
        Text("Aramıza Katıl")
            .font(.system(size: 32, weight: .bold, design: .rounded))
            .foregroundColor(.white)
            .padding(.top, 20)
    }
    
    /// Main registration form fields
    private var registrationForm: some View {
        VStack(spacing: 20) {
            HStack(spacing: 15) {
                CustomInputFields(placeholder: "İsim", text: $name, icon: "person")
                CustomInputFields(placeholder: "Soyisim", text: $surname, icon: "person")
            }
            
            CustomInputFields(placeholder: "E-posta", text: $email, icon: "envelope")
                .textInputAutocapitalization(.never)
                .keyboardType(.emailAddress)
            
            HStack(spacing: 15) {
                genderPicker
                dobPicker
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            CustomSecureField(placeholder: "Şifre", text: $password)
            CustomSecureField(placeholder: "Şifre Tekrar", text: $passwordConfirm)
        }
        .padding()
    }
    
    private var genderPicker: some View {
        VStack(alignment: .leading) {
            Text("Cinsiyet").font(.caption).foregroundColor(.gray)
            Picker("Cinsiyet", selection: $gender) {
                ForEach(genders, id: \.self) { gender in
                    Text(gender).tag(gender)
                }
            }
            .accentColor(.blue)
            .padding(8)
            .background(Color.white.opacity(0.05))
            .cornerRadius(10)
        }
    }
    
    private var dobPicker: some View {
        VStack(alignment: .leading) {
            Text("Doğum Tarihi").font(.caption).foregroundColor(.gray)
            DatePicker("", selection: $birthDate, displayedComponents: .date)
                .labelsHidden()
                .colorInvert()
        }
    }
    
    private var actionSection: some View {
        Group {
            if isLoading {
                ProgressView().tint(.white).scaleEffect(1.5)
            } else {
                Button(action: registerUser) {
                    Text("Kayıt Ol")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 55)
                        .background(LinearGradient(colors: [.blue, .purple], startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(15)
                        .shadow(color: .blue.opacity(0.3), radius: 10)
                }
                .padding(.horizontal)
            }
        }
    }
}

// MARK: - Registration Logic
extension SignUpView {
    
    /// Orchestrates the registration flow: Auth -> Firestore -> Verification
    func registerUser() {
        guard validateInput() else { return }
        isLoading = true
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                handleRegistrationError(error)
                return
            }
            
            if let user = result?.user {
                saveUserToFirestore(user: user)
            }
        }
    }
    
    private func validateInput() -> Bool {
        if email.isEmpty || password.isEmpty || password != passwordConfirm {
            errorMessage = "Lütfen tüm alanları doldurun ve şifrelerin eşleştiğinden emin olun."
            showAlert = true
            return false
        }
        return true
    }
    
    private func saveUserToFirestore(user: FirebaseAuth.User) {
        let db = Firestore.firestore()
        let userData: [String: Any] = [
            "uid": user.uid, "name": name, "surname": surname,
            "email": email, "gender": gender, "birthDate": birthDate,
            "createdAt": Date(), "avatarIndex": 0
        ]
        
        db.collection("users").document(user.uid).setData(userData) { error in
            if let error = error {
                print("DEBUG: Firestore error - \(error.localizedDescription)")
            }
            sendEmailVerification(to: user)
        }
    }
    
    private func sendEmailVerification(to user: FirebaseAuth.User) {
        user.sendEmailVerification { error in
            isLoading = false
            if let error = error {
                errorMessage = "Hesap oluşturuldu ancak doğrulama e-postası gönderilemedi: \(error.localizedDescription)"
                showAlert = true
            } else {
                showSuccessAlert = true
            }
        }
    }
    
    private func handleRegistrationError(_ error: Error) {
        isLoading = false
        errorMessage = error.localizedDescription
        showAlert = true
    }
}

// MARK: - Input Components
fileprivate struct CustomInputFields: View {
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

fileprivate struct CustomSecureField: View {
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
