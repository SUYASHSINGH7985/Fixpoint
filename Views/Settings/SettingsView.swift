import SwiftUI
import MessageUI

struct SettingsView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var userSettings: UserSettings
    @State private var showMailView = false
    @State private var showMailError = false
    
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
                Button(action: {
                    if MFMailComposeViewController.canSendMail() {
                        showMailView = true
                    } else {
                        showMailError = true
                    }
                }) {
                    HStack {
                        Image(systemName: "envelope.fill")
                            .foregroundColor(.blue)
                        Text("Contact Support")
                    }
                }
                .sheet(isPresented: $showMailView) {
                    MailView(
                        subject: "FixPoints App Support",
                        toRecipients: ["support@fixpoints.com"]
                    )
                }
                .alert("Mail is not set up on this device", isPresented: $showMailError) {
                    Button("OK", role: .cancel) { }
                }
                
                Button(action: {
                    if let url = URL(string: "https://apps.apple.com/app/idYOUR_APP_ID") {
                        UIApplication.shared.open(url)
                    }
                }) {
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

// MARK: - MailView Wrapper
struct MailView: UIViewControllerRepresentable {
    let subject: String
    let toRecipients: [String]
    
    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let vc = MFMailComposeViewController()
        vc.setSubject(subject)
        vc.setToRecipients(toRecipients)
        return vc
    }
    
    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {}
}
