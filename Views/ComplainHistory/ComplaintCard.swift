import SwiftUI

struct ComplaintCard: View {
    let complaint: Complaint
    @EnvironmentObject var themeManager: ThemeManager
    
    var statusColor: Color {
        switch complaint.status {
        case .pending: return .orange
        case .inProgress: return .blue
        case .resolved: return .green
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text(complaint.category)
                    .font(.subheadline)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(statusColor.opacity(0.2))
                    .foregroundColor(statusColor)
                    .cornerRadius(20)
                
                Spacer()
                
                Text(complaint.date, style: .date)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Text(complaint.subcategory)
                .font(.headline)
                .fontWeight(.semibold)
            
            if !complaint.description.isEmpty {
                Text(complaint.description)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            
            HStack(spacing: 15) {
                HStack {
                    Image(systemName: complaint.hostelType.icon)
                        .foregroundColor(complaint.hostelType.color)
                    Text("\(complaint.block)-\(complaint.roomNumber)")
                        .font(.subheadline)
                }
                
                Spacer()
                
                Text(complaint.status.rawValue)
                    .font(.subheadline)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(statusColor.opacity(0.2))
                    .foregroundColor(statusColor)
                    .cornerRadius(20)
            }
        }
        .padding()
        .background(themeManager.isDarkMode ? Color.gray.opacity(0.2) : Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}
