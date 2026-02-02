import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import SwiftData

// MARK: - Profile View
/// A comprehensive view for user profile management, statistics, and task history.
struct ProfileView: View {
    // MARK: - Properties
    @Environment(\.modelContext) private var modelContext
    @Query private var tasks: [PlannerTask]
    
    // User State Management
    @State private var userName = "Yükleniyor..."
    @State private var userSurname = ""
    @State private var avatarIndex: Int = 0
    @State private var showEditSheet = false
    @State private var showAvatarSelectionSheet = false
    
    /// Visual configuration for avatar options.
    private let avatars: [(icon: String, colors: [Color])] = [
        ("person.crop.circle.fill", [.blue, .purple]),
        ("person.crop.circle.fill", [.pink, .red]),
        ("person.crop.circle.fill", [.purple, .pink]),
        ("person.crop.circle.fill", [.cyan, .blue]),
        ("person.crop.circle.fill", [.green, .teal])
    ]
    
    // MARK: - Body
    var body: some View {
        ZStack {
            AppBackground()
            
            ScrollView {
                VStack(spacing: 30) {
                    profileHeaderSection
                    statisticsSection
                    recentPlansSection
                    Spacer()
                    signOutButton
                }
            }
        }
        .onAppear(perform: fetchUserData)
        .sheet(isPresented: $showEditSheet) {
            EditProfileView(currentName: userName, currentSurname: userSurname) { newName, newSurname in
                self.userName = newName
                self.userSurname = newSurname
            }
            .presentationDetents([.medium])
        }
        .sheet(isPresented: $showAvatarSelectionSheet) {
            AvatarSelectionView(avatars: avatars, selectedIndex: $avatarIndex)
                .presentationDetents([.medium])
        }
    }
}

// MARK: - View Components (Subviews)
extension ProfileView {
    
    /// Renders user identity information and avatar.
    private var profileHeaderSection: some View {
        VStack(spacing: 15) {
            ZStack(alignment: .bottomTrailing) {
                // Avatar interaction point
                Button(action: { showAvatarSelectionSheet = true }) {
                    let currentAvatar = avatars[avatarIndex]
                    Image(systemName: currentAvatar.icon)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 110, height: 110)
                        .foregroundColor(.white.opacity(0.9))
                        .padding(4)
                        .background(Circle().stroke(LinearGradient(colors: currentAvatar.colors, startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 3))
                        .shadow(color: currentAvatar.colors.first?.opacity(0.5) ?? .purple, radius: 10)
                }
                
                // Profile edit trigger
                Button(action: { showEditSheet = true }) {
                    Image(systemName: "pencil.circle.fill")
                        .resizable()
                        .frame(width: 35, height: 35)
                        .foregroundStyle(.white, .blue)
                        .background(Circle().fill(.black))
                }
                .offset(x: 5, y: 5)
            }
            
            Text("\(userName) \(userSurname)")
                .font(.title2.bold())
                .foregroundColor(.white)
        }
        .padding(.top, 30)
    }
    
    /// Displays key performance metrics.
    private var statisticsSection: some View {
        HStack(spacing: 15) {
            NavigationLink(destination: TaskDetailListView(title: "Toplam Planlar", filteredTasks: tasks)) {
                StatCard(title: "Toplam Plan", value: "\(tasks.count)", icon: "list.bullet.clipboard", color: .blue)
            }
            
            NavigationLink(destination: TaskDetailListView(title: "Tamamlananlar", filteredTasks: tasks.filter { $0.isCompleted })) {
                StatCard(title: "Tamamlanan", value: "\(tasks.filter { $0.isCompleted }.count)", icon: "checkmark.circle.fill", color: .green)
            }
        }
        .padding(.horizontal)
    }
    
    /// Lists the user's latest planning activity.
    private var recentPlansSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Son Planların")
                .font(.headline)
                .foregroundColor(.white.opacity(0.8))
                .padding(.leading, 5)
            
            if tasks.isEmpty {
                emptyRecentState
            } else {
                ForEach(tasks.prefix(3)) { task in
                    ProfileTaskRow(task: task)
                }
            }
        }
        .padding(.horizontal)
    }
    
    private var emptyRecentState: some View {
        Text("Henüz bir planın yok.")
            .foregroundColor(.gray)
            .italic()
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.white.opacity(0.05))
            .cornerRadius(15)
    }
    
    /// Provides session termination functionality.
    private var signOutButton: some View {
        Button(action: signOut) {
            HStack {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                Text("Çıkış Yap")
            }
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 55)
            .background(Color.red.opacity(0.8))
            .cornerRadius(15)
            .shadow(color: .red.opacity(0.4), radius: 10)
        }
        .padding(.horizontal)
        .padding(.bottom, 30)
    }
}

// MARK: - Methods & Service Logic
extension ProfileView {
    
    /// Fetches user details from Firestore database.
    func fetchUserData() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("users").document(uid).getDocument { doc, error in
            if let error = error {
                print("DEBUG: Firestore fetch failed - \(error.localizedDescription)")
                return
            }
            
            if let d = doc, d.exists {
                let data = d.data()
                self.userName = data?["name"] as? String ?? "İsimsiz"
                self.userSurname = data?["surname"] as? String ?? ""
                self.avatarIndex = data?["avatarIndex"] as? Int ?? 0
            }
        }
    }
    
    /// Ends the current Firebase authentication session.
    func signOut() {
        do {
            try Auth.auth().signOut()
            print("DEBUG: Sign out successful.")
        } catch {
            print("DEBUG: Sign out failed - \(error.localizedDescription)")
        }
    }
}

// MARK: - Supporting Components

struct TaskDetailListView: View {
    let title: String
    let filteredTasks: [PlannerTask]
    
    var body: some View {
        ZStack {
            AppBackground()
            ScrollView {
                VStack(spacing: 15) {
                    if filteredTasks.isEmpty {
                        Text("Plan bulunamadı.").foregroundColor(.gray).padding(.top, 50)
                    } else {
                        ForEach(filteredTasks) { ProfileTaskRow(task: $0) }
                    }
                }
                .padding()
            }
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ProfileTaskRow: View {
    let task: PlannerTask
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(task.title).foregroundColor(.white).bold().strikethrough(task.isCompleted, color: .gray)
                Text(task.date.formatted(date: .abbreviated, time: .shortened)).font(.caption).foregroundColor(.gray)
            }
            Spacer()
            Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                .foregroundColor(task.isCompleted ? .green : .gray)
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
    }
}

struct EditProfileView: View {
    @Environment(\.dismiss) var dismiss
    @State var currentName: String
    @State var currentSurname: String
    var onSave: (String, String) -> Void
    @State private var isSaving = false
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(spacing: 20) {
                Text("Profili Düzenle").font(.title3.bold()).foregroundColor(.white).padding(.top, 20)
                
                TextField("İsim", text: $currentName)
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(10)
                    .foregroundColor(.white)
                
                TextField("Soyisim", text: $currentSurname)
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(10)
                    .foregroundColor(.white)
                
                Button(action: save) {
                    if isSaving {
                        ProgressView().tint(.white)
                    } else {
                        Text("Kaydet").bold()
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                
                Spacer()
            }
            .padding()
        }
    }
    
    private func save() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        isSaving = true
        Firestore.firestore().collection("users").document(uid).updateData([
            "name": currentName,
            "surname": currentSurname
        ]) { error in
            if let error = error {
                print("DEBUG: Data update error - \(error.localizedDescription)")
            }
            onSave(currentName, currentSurname)
            isSaving = false
            dismiss()
        }
    }
}

struct AvatarSelectionView: View {
    @Environment(\.dismiss) var dismiss
    let avatars: [(icon: String, colors: [Color])]
    @Binding var selectedIndex: Int
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(spacing: 20) {
                Text("Avatar Seç").font(.headline).foregroundColor(.white).padding()
                
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: 20) {
                    ForEach(0..<avatars.count, id: \.self) { index in
                        let avatar = avatars[index]
                        Button(action: {
                            selectedIndex = index
                            if let uid = Auth.auth().currentUser?.uid {
                                Firestore.firestore().collection("users").document(uid).updateData(["avatarIndex": index])
                            }
                            dismiss()
                        }) {
                            Image(systemName: avatar.icon)
                                .resizable()
                                .frame(width: 60, height: 60)
                                .foregroundColor(.white)
                                .background(Circle().stroke(LinearGradient(colors: avatar.colors, startPoint: .top, endPoint: .bottom), lineWidth: index == selectedIndex ? 4 : 1))
                        }
                    }
                }
                Spacer()
            }
            .padding()
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon).foregroundColor(color).font(.title2)
            Text(value).font(.title2.bold()).foregroundColor(.white)
            Text(title).font(.caption).foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(15)
    }
}
