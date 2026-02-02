import SwiftUI
import SwiftData
import FirebaseCore
import Combine

// MARK: - App Delegate
/// Manages app lifecycle and third-party service initialization.
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        // Setup Firebase SDK
        FirebaseApp.configure()
        
        // Permission request for local notifications
        NotificationManager.instance.requestAuthorization()
        
        print("DEBUG: Firebase initialized and notifications requested.")
        return true
    }
}

// MARK: - App Entry Point
@main
struct PLANNERApp: App {
    // MARK: - Properties
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    // Global state for theme management
    @StateObject private var themeManager = ThemeManager()

    // Persistent storage container for SwiftData
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            PlannerTask.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            // Fatal error if local database fails to initialize
            fatalError("CRITICAL: Could not create ModelContainer - \(error)")
        }
    }()

    // MARK: - Scene
    var body: some Scene {
        WindowGroup {
            /* RootView acts as a router between the
               Authentication flow and Main Content.
            */
            RootView()
                .environmentObject(themeManager)
                .preferredColorScheme(themeManager.userInterfaceStyle)
        }
        .modelContainer(sharedModelContainer)
    }
}
