import SwiftUI

struct SubcategorySelectionView: View {
    @EnvironmentObject var complaintVM: ComplaintViewModel
    let category: ComplaintCategory
    @Binding var showSubcategorySelection: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            Text(category.name)
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top, 25)
                .padding(.bottom, 20)
            
            ScrollView {
                VStack(spacing: 15) {
                    ForEach(category.subcategories, id: \.self) { item in
                        Button(action: {
                            complaintVM.selectedSubcategory = item
                            showSubcategorySelection = false
                        }) {
                            HStack {
                                Text(item)
                                    .foregroundColor(.primary)
                                    .padding(.vertical, 12)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                if complaintVM.selectedSubcategory == item {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.blue)
                                }
                            }
                            .padding(.horizontal)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(12)
                        }
                    }
                }
                .padding()
            }
            
            Spacer()
            
            // Close Button
            Button(action: {
                showSubcategorySelection = false
            }) {
                Text("Close")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(15)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(UIColor.systemBackground))
        .cornerRadius(30)
    }
}
