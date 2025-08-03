import SwiftUI

struct Complaint: Identifiable, Codable {
    var id = UUID()
    var category: String
    var subcategory: String
    var description: String
    var date = Date()
    var status: Status = .pending
    var hostelType: HostelType = .boys
    var block: String = ""
    var roomNumber: String = ""
    
    enum Status: String, Codable {
        case pending = "⏳ Pending"
        case inProgress = "🛠 In Progress"
        case resolved = "✅ Resolved"
    }
}
