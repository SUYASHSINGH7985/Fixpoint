import SwiftUI

@main
struct FixPointsApp: App {
    @StateObject private var themeManager = ThemeManager()
    @StateObject private var complaintVM = ComplaintViewModel()
    @StateObject private var userSettings = UserSettings()
    
    var body: some Scene {
        WindowGroup {
            Group {
                if userSettings.isOnboardingCompleted {
                    MainTabView()
                } else {
                    HostelSelectionView()
                }
            }
            .environmentObject(themeManager)
            .environmentObject(complaintVM)
            .environmentObject(userSettings)
            .preferredColorScheme(themeManager.isDarkMode ? .dark : .light)
        }
    }
}
