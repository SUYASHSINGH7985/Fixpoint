// MARK: - AppRootView.swift
import SwiftUI

struct AppRootView: View {
    @EnvironmentObject var userSettings: UserSettings
    
    var body: some View {
        Group {
            if userSettings.isOnboardingCompleted {
                MainTabView()
            } else {
                HostelSelectionView()
            }
        }
    }
}
