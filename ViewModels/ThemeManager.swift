import SwiftUI
import Combine

// MARK: - Theme Manager
/// Manages application-wide visual themes and local persistence.
class ThemeManager: ObservableObject {
    
    // MARK: - Properties
    /// Current theme selection (1: Light, 2: Dark).
    /// Persists value to UserDefaults upon modification.
    @Published var selectedTheme: Int {
        didSet {
            UserDefaults.standard.set(selectedTheme, forKey: "selectedTheme")
        }
    }
    
    // MARK: - Initialization
    init() {
        // Retrieve persisted theme or default to Dark Mode
        let savedTheme = UserDefaults.standard.integer(forKey: "selectedTheme")
        self.selectedTheme = savedTheme == 0 ? 2 : savedTheme
    }
    
    // MARK: - Logic
    /// Maps the internal theme index to SwiftUI ColorScheme.
    var userInterfaceStyle: ColorScheme? {
        switch selectedTheme {
        case 1:  return .light
        case 2:  return .dark
        default: return nil
        }
    }
}
