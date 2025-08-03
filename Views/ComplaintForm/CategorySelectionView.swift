import SwiftUI

struct CategorySelectionView: View {
    @EnvironmentObject var complaintVM: ComplaintViewModel
    @Binding var showCategorySelection: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            Text("Select Category")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top, 25)
                .padding(.bottom, 20)
            
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 160))], spacing: 20) {
                    ForEach(ComplaintCategory.all) { category in
                        VStack(spacing: 15) {
                            ZStack {
                                Circle()
                                    .fill(Color.blue)
                                    .frame(width: 70, height: 70)
                                
                                Image(systemName: category.icon)
                                    .font(.title)
                                    .foregroundColor(.white)
                            }
                            
                            Text(category.name)
                                .font(.headline)
                                .fontWeight(.medium)
                                .foregroundColor(.primary)
                                .multilineTextAlignment(.center)
                                .lineLimit(2)
                                .frame(height: 40)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(complaintVM.selectedCategory?.id == category.id ? Color.blue.opacity(0.1) : Color.clear)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(complaintVM.selectedCategory?.id == category.id ? Color.blue : Color.clear, lineWidth: 2)
                        )
                        .onTapGesture {
                            complaintVM.selectedCategory = category
                            complaintVM.selectedSubcategory = ""
                            showCategorySelection = false
                        }
                    }
                }
                .padding()
            }
            
            Spacer()
            
            // Close Button
            Button(action: {
                showCategorySelection = false
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
