import SwiftUI
import UserNotifications

// MARK: - Notification Manager
/// Handles local notification permissions and scheduling operations.
class NotificationManager {
    
    // MARK: - Shared Instance
    /// Singleton instance for global access within the app.
    static let instance = NotificationManager()
    
    // MARK: - Initialization
    private init() {} // Enforces singleton pattern
    
    // MARK: - Authorization
    /// Requests user permission for alerts, sounds, and badges.
    func requestAuthorization() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { success, error in
            if let error = error {
                print("DEBUG: Auth failed - \(error.localizedDescription)")
            } else {
                print("DEBUG: Auth status - \(success)")
            }
        }
    }
    
    // MARK: - Scheduling
    /// Schedules a local notification based on a specific date and task title.
    func scheduleNotification(taskTitle: String, taskDate: Date) {
        // 1. Notification Content Configuration
        let content = UNMutableNotificationContent()
        content.title = "Plan Hatırlatıcı 🚀"
        content.subtitle = taskTitle
        content.sound = .default
        content.badge = 1
        
        // 2. Extract Date Components
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: taskDate)
        
        // 3. Setup Trigger
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        // 4. Create Unique Request
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger
        )
        
        // 5. Register with System
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("DEBUG: Scheduling error - \(error.localizedDescription)")
            } else {
                print("DEBUG: Notification set for \(taskDate)")
            }
        }
    }
}
