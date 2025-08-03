import SwiftUI

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let complaintVM = ComplaintViewModel()
        complaintVM.complaints = [
            Complaint(category: "Electrician", subcategory: "Tube Light", description: "Tube light not working in room", hostelType: .boys, block: "A", roomNumber: "205"),
            Complaint(category: "Plumber", subcategory: "Tap", description: "Leaking tap in bathroom", status: .inProgress, hostelType: .girls, block: "B", roomNumber: "312"),
            Complaint(category: "Carpenter", subcategory: "Bed", description: "Bed frame is broken", status: .resolved, hostelType: .boys, block: "C", roomNumber: "108")
        ]
        
        let userSettings = UserSettings()
        userSettings.hostelType = .boys
        userSettings.block = "A"
        userSettings.roomNumber = "205"
        userSettings.isOnboardingCompleted = true
        
        return Group {
            HostelSelectionView()
                .environmentObject(UserSettings())
                .previewDisplayName("Hostel Selection")
            
            ComplaintFormView()
                .environmentObject(complaintVM)
                .environmentObject(ThemeManager())
                .environmentObject(userSettings)
                .previewDisplayName("Complaint Form")
            
            ComplaintHistoryView()
                .environmentObject(complaintVM)
                .environmentObject(ThemeManager())
                .previewDisplayName("Complaint History")
        }
    }
}
