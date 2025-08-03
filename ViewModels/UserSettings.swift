import SwiftUI

class UserSettings: ObservableObject {
    @Published var hostelType: HostelType = .boys
    @Published var block: String = ""
    @Published var roomNumber: String = ""
    @Published var isOnboardingCompleted = false
}
