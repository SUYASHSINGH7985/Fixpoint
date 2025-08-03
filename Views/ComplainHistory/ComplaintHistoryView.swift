import SwiftUI

struct ComplaintHistoryView: View {
    @EnvironmentObject var complaintVM: ComplaintViewModel
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        ScrollView {
            VStack {
                // Header with improved design
                VStack(spacing: 10) {
                    Text("Complaint History")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(themeManager.isDarkMode ? .white : .blue)
                    
                    Divider()
                        .padding(.horizontal, 40)
                        .padding(.bottom, 10)
                }
                .padding(.top, 30)
                
                if complaintVM.complaints.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "doc.text.magnifyingglass")
                            .font(.system(size: 60))
                            .foregroundColor(.secondary)
                            .padding(.top, 100)
                        Text("No Complaints Yet")
                            .font(.title2)
                        Text("Your submitted complaints will appear here")
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                } else {
                    LazyVStack(spacing: 20) {
                        ForEach(complaintVM.complaints) { complaint in
                            ComplaintCard(complaint: complaint)
                        }
                    }
                    .padding(20)
                }
            }
        }
    }
}
