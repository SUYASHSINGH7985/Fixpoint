import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var userSettings: UserSettings
    
    var body: some View {
        Form {
            Section(header: Text("Appearance").font(.headline)) {
                Toggle(isOn: $themeManager.isDarkMode) {
                    HStack {
                        Image(systemName: themeManager.isDarkMode ? "moon.fill" : "sun.max.fill")
                            .foregroundColor(themeManager.isDarkMode ? .purple : .orange)
                        Text("Dark Mode")
                    }
                }
                .toggleStyle(SwitchToggleStyle(tint: .blue))
            }
            
            Section(header: Text("Hostel Information").font(.headline)) {
                HStack {
                    Image(systemName: userSettings.hostelType.icon)
                        .foregroundColor(userSettings.hostelType.color)
                    Text(userSettings.hostelType.rawValue)
                }
                
                HStack {
                    Image(systemName: "signpost.right")
                        .foregroundColor(.blue)
                    Text("Block \(userSettings.block)")
                }
                
                HStack {
                    Image(systemName: "door.left.hand.open")
                        .foregroundColor(.green)
                    Text("Room \(userSettings.roomNumber)")
                }
            }
            
            Section(header: Text("About FixPoints").font(.headline)) {
                HStack {
                    Image(systemName: "info.circle.fill")
                        .foregroundColor(.blue)
                    Text("Version")
                    Spacer()
                    Text("1.0.0")
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Image(systemName: "calendar")
                        .foregroundColor(.green)
                    Text("Last Updated")
                    Spacer()
                    Text("Jul 30, 2025")
                        .foregroundColor(.secondary)
                }
            }
            
            Section(header: Text("Support").font(.headline)) {
                Button(action: {}) {
                    HStack {
                        Image(systemName: "envelope.fill")
                            .foregroundColor(.blue)
                        Text("Contact Support")
                    }
                }
                
                Button(action: {}) {
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        Text("Rate FixPoints")
                    }
                }
            }
            
            Section {
                Button("Switch Hostel") {
                    userSettings.isOnboardingCompleted = false
                }
                .foregroundColor(.blue)
            }
        }
        .navigationTitle("Settings")
    }
}
