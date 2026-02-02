import SwiftUI
import SwiftData

// MARK: - Main Content View
struct ContentView: View {
    // MARK: - Properties
    @Query(sort: \PlannerTask.date, order: .forward) private var tasks: [PlannerTask]
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var themeManager: ThemeManager
    @State private var showingAddTask = false

    // MARK: - Body
    var body: some View {
        NavigationStack {
            ZStack {
                // Background handling based on selected theme
                backgroundLayer
                
                VStack(spacing: 20) {
                    headerSection
                    dashboardMenu
                    upcomingTasksSection
                    Spacer()
                }
            }
            .sheet(isPresented: $showingAddTask) { AddTaskView() }
        }
    }
}

// MARK: - View Components
extension ContentView {
    
    /// Dynamic background layer responsive to theme state
    private var backgroundLayer: some View {
        Group {
            if themeManager.selectedTheme == 1 {
                Color(UIColor.systemGroupedBackground).ignoresSafeArea()
            } else {
                AppBackground()
            }
        }
    }
    
    /// Header section: Greeting, Theme Toggle, and Profile navigation
    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text("Merhaba,")
                    .font(.title3)
                    .foregroundColor(themeManager.selectedTheme == 1 ? .secondary : .white.opacity(0.7))
                
                Text("PLANLAMAYA BAŞLA")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                    .foregroundColor(themeManager.selectedTheme == 1 ? .primary : .white)
            }
            Spacer()
            
            // Theme Toggle Button
            Button(action: {
                themeManager.selectedTheme = (themeManager.selectedTheme == 1) ? 2 : 1
            }) {
                Image(systemName: themeManager.selectedTheme == 1 ? "moon.stars.fill" : "sun.max.fill")
                    .font(.title2)
                    .foregroundColor(.orange)
                    .padding(10)
                    .background(Color.orange.opacity(0.1))
                    .clipShape(Circle())
            }
            
            NavigationLink(destination: ProfileView()) {
                Image(systemName: "person.crop.circle.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.blue)
            }
        }
        .padding(.horizontal, 25)
        .padding(.top)
    }
    
    /// Dashboard menu for core application features
    private var dashboardMenu: some View {
        VStack(spacing: 12) {
            Button(action: { showingAddTask = true }) {
                CustomDashboardButton(title: "Yeni Plan Ekle", icon: "plus.circle.fill", color: .blue)
            }
            NavigationLink(destination: MyPlannerView()) {
                CustomDashboardButton(title: "Planlarım", icon: "calendar.badge.plus", color: .purple)
            }
            NavigationLink(destination: AnalysisView()) {
                CustomDashboardButton(title: "Haftalık Analiz", icon: "chart.pie.fill", color: .orange)
            }
        }
        .padding(.horizontal, 25)
    }
    
    /// Section displaying upcoming planner tasks
    private var upcomingTasksSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Yaklaşan Planların")
                .font(.headline)
                .foregroundColor(themeManager.selectedTheme == 1 ? .primary : .white)
                .padding(.leading, 30)
            
            if tasks.isEmpty {
                emptyStateView
            } else {
                taskListView
            }
        }
    }
    
    /// Empty state UI when no tasks exist
    private var emptyStateView: some View {
        VStack(spacing: 10) {
            Image(systemName: "doc.text.magnifyingglass")
                .font(.largeTitle)
                .foregroundColor(.gray)
            Text("Henüz plan yok.")
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(40)
        .background(RoundedRectangle(cornerRadius: 20)
            .fill(themeManager.selectedTheme == 1 ? Color.gray.opacity(0.1) : Color.white.opacity(0.05)))
        .padding(.horizontal, 25)
    }
    
    /// Scrollable list displaying limited task preview
    private var taskListView: some View {
        ScrollView {
            VStack(spacing: 12) {
                ForEach(tasks.prefix(3)) { task in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(task.title)
                                .font(.headline)
                                .foregroundColor(themeManager.selectedTheme == 1 ? .primary : .white)
                                .strikethrough(task.isCompleted, color: .gray)
                            
                            Text(task.date.formatted(date: .omitted, time: .shortened))
                                .font(.caption)
                                .foregroundColor(.blue)
                        }
                        Spacer()
                        
                        // Task Status Toggle
                        Button(action: { task.isCompleted.toggle() }) {
                            Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(task.isCompleted ? .green : .gray)
                                .font(.title2)
                        }
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 15)
                        .fill(themeManager.selectedTheme == 1 ? Color.white : Color.white.opacity(0.08)))
                }
            }
            .padding(.horizontal, 25)
        }
    }
}

// MARK: - UI Components
struct CustomDashboardButton: View {
    @EnvironmentObject var themeManager: ThemeManager
    let title: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(color)
                .frame(width: 50, height: 50)
                .background(color.opacity(0.2))
                .clipShape(Circle())
            
            Text(title)
                .font(.headline)
                .foregroundColor(themeManager.selectedTheme == 1 ? .primary : .white)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(themeManager.selectedTheme == 1 ? .secondary : .white.opacity(0.3))
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 22)
            .fill(themeManager.selectedTheme == 1 ? Color.white : Color.white.opacity(0.05)))
    }
}
