import SwiftUI
import SwiftData

// MARK: - My Planner View
/// Lists all planned tasks with options to edit, delete, or toggle completion.
struct MyPlannerView: View {
    // MARK: - Properties
    @Query(sort: \PlannerTask.date, order: .forward) private var tasks: [PlannerTask]
    @Environment(\.modelContext) private var modelContext
    
    /// State to hold the specific task currently being edited in a sheet.
    @State private var taskToEdit: PlannerTask?
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            ZStack {
                AppBackground()
                
                VStack {
                    if tasks.isEmpty {
                        emptyStateView
                    } else {
                        taskListView
                    }
                }
                .navigationTitle("Planlarım")
            }
            .sheet(item: $taskToEdit) { task in
                EditTaskView(task: task)
            }
        }
    }
}

// MARK: - View Components (Subviews)
extension MyPlannerView {
    
    /// View displayed when the task list is empty.
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "tray.and.arrow.down.fill")
                .font(.system(size: 80))
                .foregroundColor(.gray.opacity(0.3))
            Text("Henüz bir planın yok.")
                .foregroundColor(.gray)
        }
    }
    
    /// The main scrollable list containing task rows.
    private var taskListView: some View {
        List {
            ForEach(tasks) { task in
                TaskRow(task: task) {
                    taskToEdit = task
                }
                .listRowBackground(Color.white.opacity(0.05))
                
                // MARK: - Swipe Actions
                
                // Leading swipe to trigger edit mode
                .swipeActions(edge: .leading, allowsFullSwipe: false) {
                    Button {
                        taskToEdit = task
                    } label: {
                        Label("Düzenle", systemImage: "pencil")
                    }
                    .tint(.blue)
                }
                
                // Trailing swipe to delete the task
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    Button(role: .destructive) {
                        modelContext.delete(task)
                    } label: {
                        Label("Sil", systemImage: "trash")
                    }
                }
            }
        }
        .scrollContentBackground(.hidden)
    }
}

// MARK: - Supporting Row Component

struct TaskRow: View {
    let task: PlannerTask
    let onEdit: () -> Void
    
    var body: some View {
        HStack(spacing: 15) {
            // Completion Toggle
            Button(action: {
                task.isCompleted.toggle()
            }) {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(task.isCompleted ? .green : .gray)
                    .font(.system(size: 22))
            }
            .buttonStyle(.plain)
            
            // Task Details
            VStack(alignment: .leading, spacing: 5) {
                Text(task.title)
                    .font(.headline)
                    .foregroundColor(.white)
                    .strikethrough(task.isCompleted, color: .gray)
                
                if !task.note.isEmpty {
                    Text(task.note)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .lineLimit(1)
                }
                
                Text(task.date.formatted(date: .abbreviated, time: .shortened))
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.blue)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.gray.opacity(0.5))
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Edit Task View

struct EditTaskView: View {
    @Environment(\.dismiss) var dismiss
    @Bindable var task: PlannerTask
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppBackground()
                
                VStack(spacing: 25) {
                    Text("Planı Güncelle")
                        .font(.title3.bold())
                        .foregroundColor(.white)
                        .padding(.top)
                    
                    VStack(spacing: 15) {
                        TextField("Başlık", text: $task.title)
                            .padding()
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(12)
                            .foregroundColor(.white)
                        
                        TextField("Not", text: $task.note, axis: .vertical)
                            .lineLimit(3...5)
                            .padding()
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(12)
                            .foregroundColor(.white)
                        
                        DatePicker("Zaman Seç:", selection: $task.date)
                            .preferredColorScheme(.dark)
                            .padding()
                            .background(Color.white.opacity(0.05))
                            .cornerRadius(12)
                    }
                    .padding()
                    
                    Button(action: { dismiss() }) {
                        Text("Değişiklikleri Kaydet")
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(15)
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Kapat") { dismiss() }
                        .foregroundColor(.blue)
                }
            }
        }
    }
}
