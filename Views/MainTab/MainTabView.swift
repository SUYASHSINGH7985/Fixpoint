import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            ComplaintFormView()
                .tabItem {
                    Label("Report", systemImage: "plus.bubble.fill")
                }
            
            ComplaintHistoryView()
                .tabItem {
                    Label("History", systemImage: "clock.fill")
                }
            
            ChatSupportView()
                .tabItem {
                    Label("Support", systemImage: "message.fill")
                }
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
        }
        .accentColor(.blue)
    }
}
