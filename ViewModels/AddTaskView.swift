import SwiftUI
import SwiftData

// MARK: - Add Task View
/// A view that allows users to create new plans with optional notes and notifications.
struct AddTaskView: View {
    // MARK: - Properties
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    
    // User Input States
    @State private var taskTitle = ""
    @State private var taskNote = ""
    @State private var taskDate = Date()
    @State private var isNotificationEnabled = false
    
    // MARK: - Body
    var body: some View {
        ZStack {
            // Layer 1: Persistent Background
            AppBackground()
            
            // Layer 2: Form Content
            VStack(spacing: 20) {
                headerSection
                
                ScrollView {
                    VStack(spacing: 20) {
                        titleInputField
                        notesInputField
                        notificationAndDatePicker
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 100)
                }
                
                saveButton
            }
        }
        .onTapGesture {
            hideKeyboard()
        }
    }
}

// MARK: - UI Components (Subviews)
extension AddTaskView {
    
    /// Header title for the creation screen
    private var headerSection: some View {
        Text("Yeni Plan Oluştur")
            .font(.title2.bold())
            .foregroundColor(.white)
            .padding(.top, 20)
    }
    
    /// Input field for the task title
    private var titleInputField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("GÖREV ADI").font(.caption).foregroundColor(.gray).padding(.leading, 5)
            TextField("Örn: Matematik çalış", text: $taskTitle)
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(12)
                .foregroundColor(.white)
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.2), lineWidth: 1))
        }
    }
    
    /// Input field for task-specific notes
    private var notesInputField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("NOTLAR").font(.caption).foregroundColor(.gray).padding(.leading, 5)
            TextField("Detay ekle...", text: $taskNote, axis: .vertical)
                .lineLimit(3)
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(12)
                .foregroundColor(.white)
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.2), lineWidth: 1))
        }
    }
    
    /// Combined picker for notifications and date/time selection
    private var notificationAndDatePicker: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("ALARM VE ZAMANLAMA").font(.caption).foregroundColor(.gray).padding(.leading, 5)
            
            VStack(spacing: 0) {
                // Notification Toggle
                Toggle(isOn: $isNotificationEnabled) {
                    HStack {
                        Image(systemName: isNotificationEnabled ? "bell.fill" : "bell.slash")
                            .foregroundColor(isNotificationEnabled ? .orange : .gray)
                        Text("Hatırlatıcı")
                            .foregroundColor(.white)
                    }
                }
                .padding()
                
                Divider().background(Color.white.opacity(0.2))
                
                // Date and Time Picker
                DatePicker(
                    "Zaman Seç:",
                    selection: $taskDate,
                    displayedComponents: [.date, .hourAndMinute]
                )
                .datePickerStyle(.compact)
                .colorScheme(.dark)
                .padding()
            }
            .background(Color.white.opacity(0.1))
            .cornerRadius(12)
        }
    }
    
    /// Main action button to persist the task
    private var saveButton: some View {
        Button(action: saveTask) {
            Text("Listeye Ekle")
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 55)
                .background(LinearGradient(colors: [.blue, .purple], startPoint: .leading, endPoint: .trailing))
                .cornerRadius(15)
                .shadow(color: .blue.opacity(0.4), radius: 10)
        }
        .padding(.horizontal)
        .padding(.bottom, 20)
        .disabled(taskTitle.isEmpty)
        .opacity(taskTitle.isEmpty ? 0.5 : 1.0)
    }
}

// MARK: - Logic & Actions
extension AddTaskView {
    
    /// Validates and saves the task to the local database.
    private func saveTask() {
        let newTask = PlannerTask(title: taskTitle, note: taskNote, date: taskDate)
        modelContext.insert(newTask)
        
        // Schedule notification if requested by the user
        if isNotificationEnabled {
            NotificationManager.instance.scheduleNotification(taskTitle: taskTitle, taskDate: taskDate)
        }
        
        dismiss()
    }
    
    /// Utility to dismiss the software keyboard.
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
