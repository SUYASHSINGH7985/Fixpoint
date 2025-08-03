import SwiftUI

class ThemeManager: ObservableObject {
    @Published var isDarkMode = false
    @AppStorage("isDarkMode") private var storedMode = false
    
    init() {
        self.isDarkMode = storedMode
    }
    
    func toggleTheme() {
        isDarkMode.toggle()
        storedMode = isDarkMode
    }
}
