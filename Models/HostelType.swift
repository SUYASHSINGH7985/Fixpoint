import SwiftUI

enum HostelType: String, Codable, CaseIterable {
    case boys = "Boys Hostel"
    case girls = "Girls Hostel"
    
    var icon: String {
        switch self {
        case .boys: return "figure.arms.open"
        case .girls: return "figure.dress"
        }
    }
    
    var color: Color {
        switch self {
        case .boys: return .blue
        case .girls: return .pink
        }
    }
    
    var blocks: [String] {
        switch self {
        case .boys: return ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "P", "Q", "R", "S", "T"]
        case .girls: return ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J"]
        }
    }
}
