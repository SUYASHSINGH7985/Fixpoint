import SwiftUI

struct ComplaintCategory: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    let subcategories: [String]
    
    static let all: [ComplaintCategory] = [
        ComplaintCategory(
            name: "Electrician",
            icon: "bolt.fill",
            subcategories: ["Tube Light", "Bulb", "Fan", "AC", "Switch", "Other"]
        ),
        ComplaintCategory(
            name: "Plumber",
            icon: "drop.fill",
            subcategories: ["Tap", "Pipe Leak", "Drain", "Shower", "Other"]
        ),
        ComplaintCategory(
            name: "Carpenter",
            icon: "hammer.fill",
            subcategories: ["Bed", "Chair", "Table", "Cupboard", "Other"]
        ),
        ComplaintCategory(
            name: "WiFi/Network",
            icon: "wifi",
            subcategories: ["Slow Speed", "No Connection", "Router Issue", "Other"]
        ),
        ComplaintCategory(
            name: "Cleaning",
            icon: "bubbles.and.sparkles.fill",
            subcategories: ["Room", "Bathroom", "Common Area", "Other"]
        ),
        ComplaintCategory(
            name: "Security",
            icon: "lock.shield.fill",
            subcategories: ["Access Issue", "Theft Report", "Safety Concern", "Other"]
        ),
        ComplaintCategory(
            name: "Other",
            icon: "questionmark.circle.fill",
            subcategories: ["Other"]
        )
    ]
}
