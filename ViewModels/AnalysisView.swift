import SwiftUI
import Charts
import SwiftData

// MARK: - Analysis View
/// A view providing visual insights into task completion and statistics.
struct AnalysisView: View {
    // MARK: - Properties
    @Query private var tasks: [PlannerTask]
    
    // MARK: - Computed Properties
    private var completedCount: Int { tasks.filter { $0.isCompleted }.count }
    private var pendingCount: Int { tasks.filter { !$0.isCompleted }.count }
    private var totalCount: Int { tasks.count }
    
    // MARK: - Body
    var body: some View {
        ZStack {
            AppBackground()
            
            ScrollView {
                VStack(spacing: 25) {
                    // Overall statistics overview cards
                    statisticsOverview
                    
                    // Visual chart for task distribution
                    WeeklyChart(completed: completedCount, pending: pendingCount)
                    
                    // Circular progress for success rate
                    SuccessRing(completed: completedCount, total: totalCount)
                }
                .padding(.vertical)
            }
        }
        .navigationTitle("Analiz")
    }
    
    // MARK: - Subviews
    private var statisticsOverview: some View {
        HStack(spacing: 15) {
            AnalysisStatCard(title: "Biten", value: "\(completedCount)", color: .green)
            AnalysisStatCard(title: "Bekleyen", value: "\(pendingCount)", color: .orange)
        }
        .padding(.horizontal)
    }
}

// MARK: - Supporting Components

/// A bar chart visualizing completed vs pending tasks.
struct WeeklyChart: View {
    let completed: Int
    let pending: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Haftalık Durum")
                .font(.headline)
                .foregroundColor(.white)
            
            Chart {
                BarMark(
                    x: .value("Durum", "Biten"),
                    y: .value("Sayı", completed)
                )
                .foregroundStyle(Color.green)
                
                BarMark(
                    x: .value("Durum", "Bekleyen"),
                    y: .value("Sayı", pending)
                )
                .foregroundStyle(Color.blue)
            }
            .frame(height: 200)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 20).fill(Color.white.opacity(0.05)))
        .padding(.horizontal)
    }
}

/// A circular progress ring representing completion percentage.
struct SuccessRing: View {
    let completed: Int
    let total: Int
    
    private var progress: Double {
        total == 0 ? 0 : Double(completed) / Double(total)
    }
    
    private var percentage: Int {
        Int(progress * 100)
    }
    
    var body: some View {
        VStack(spacing: 15) {
            Text("Başarı Oranı")
                .font(.headline)
                .foregroundColor(.white)
            
            ZStack {
                // Background Track
                Circle()
                    .stroke(Color.white.opacity(0.1), lineWidth: 15)
                
                // Animated Progress Fill
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(
                        LinearGradient(
                            colors: [.blue, .purple],
                            startPoint: .top,
                            endPoint: .bottom
                        ),
                        style: StrokeStyle(lineWidth: 15, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                
                Text("%\(percentage)")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
            }
            .frame(width: 150, height: 150)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 20).fill(Color.white.opacity(0.05)))
        .padding(.horizontal)
    }
}

/// Helper component for individual metric display.
struct AnalysisStatCard: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 5) {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            Text(value)
                .font(.title2.bold())
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(15)
    }
}
