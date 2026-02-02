import Foundation
import SwiftData

@Model
class PlannerTask {
    var id: UUID
    var title: String      // Görev başlığı
    var note: String       // Detaylı not
    var date: Date         // Hatırlatıcı zamanı
    var isCompleted: Bool  // Tamamlandı mı?
    
    init(title: String = "", note: String = "", date: Date = .now) {
        self.id = UUID()
        self.title = title
        self.note = note
        self.date = date
        self.isCompleted = false
    }
}
