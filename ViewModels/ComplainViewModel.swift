import SwiftUI
import Combine

class ComplaintViewModel: ObservableObject {
    @Published var complaints: [Complaint] = []
    @Published var selectedCategory: ComplaintCategory?
    @Published var selectedSubcategory: String = ""
    @Published var customSubcategory: String = ""
    @Published var description = ""
    
    func submitComplaint(hostelType: HostelType, block: String, roomNumber: String) {
        let finalSubcategory = selectedSubcategory == "Other" ? customSubcategory : selectedSubcategory
        
        let newComplaint = Complaint(
            category: selectedCategory?.name ?? "Unknown",
            subcategory: finalSubcategory,
            description: description,
            hostelType: hostelType,
            block: block,
            roomNumber: roomNumber
        )
        
        complaints.insert(newComplaint, at: 0)
        
        // Reset form
        selectedCategory = nil
        selectedSubcategory = ""
        customSubcategory = ""
        description = ""
    }
}
