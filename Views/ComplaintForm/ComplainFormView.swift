import SwiftUI

struct ComplaintFormView: View {
    @EnvironmentObject var complaintVM: ComplaintViewModel
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var userSettings: UserSettings
    @State private var showCategorySelection = false
    @State private var showSubcategorySelection = false
    @State private var showConfirmation = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // App Header with improved design
                VStack(spacing: 15) {
                    Text("FixPoints")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundColor(themeManager.isDarkMode ? .white : .blue)
                        .shadow(color: themeManager.isDarkMode ? .clear : .gray.opacity(0.2), radius: 2, x: 0, y: 2)
                    
                    Text("Premium Hostel Solutions")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.bottom, 10)
                    
                    Divider()
                        .padding(.horizontal, 40)
                }
                .padding(.top, 30)
                .padding(.bottom, 20)
                
                // Form Container with improved UI
                VStack(spacing: 25) {
                    // Hostel Information Card
                    VStack(alignment: .leading, spacing: 15) {
                        HStack {
                            Image(systemName: "building.columns.fill")
                                .foregroundColor(.secondary)
                            Text("HOSTEL INFORMATION")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        HStack {
                            Image(systemName: userSettings.hostelType.icon)
                                .font(.title2)
                                .foregroundColor(userSettings.hostelType.color)
                                .frame(width: 40)
                            
                            VStack(alignment: .leading) {
                                Text(userSettings.hostelType.rawValue)
                                    .font(.headline)
                                
                                HStack {
                                    Text("Block \(userSettings.block)")
                                    Text("•")
                                    Text("Room \(userSettings.roomNumber)")
                                }
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                        }
                        .padding()
                        .background(themeManager.isDarkMode ? Color.gray.opacity(0.2) : Color.white)
                        .cornerRadius(16)
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                    }
                    
                    // Category Selection Card
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "list.bullet.clipboard.fill")
                                .foregroundColor(.secondary)
                            Text("CATEGORY")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Button(action: {
                            showCategorySelection = true
                        }) {
                            HStack {
                                if let category = complaintVM.selectedCategory {
                                    Image(systemName: category.icon)
                                        .foregroundColor(.white)
                                        .frame(width: 24, height: 24)
                                        .padding(10)
                                        .background(Color.blue)
                                        .clipShape(Circle())
                                    
                                    Text(category.name)
                                        .foregroundColor(.primary)
                                } else {
                                    Image(systemName: "plus.circle.fill")
                                        .foregroundColor(.blue)
                                    Text("Select Issue Category")
                                        .foregroundColor(.primary)
                                }
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.secondary)
                            }
                            .padding()
                            .background(themeManager.isDarkMode ? Color.gray.opacity(0.2) : Color.white)
                            .cornerRadius(16)
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                        }
                    }
                    
                    // Subcategory Selection (if category selected)
                    if complaintVM.selectedCategory != nil {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Image(systemName: "list.bullet.indent")
                                    .foregroundColor(.secondary)
                                Text("SUBCATEGORY")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Button(action: {
                                showSubcategorySelection = true
                            }) {
                                HStack {
                                    if complaintVM.selectedSubcategory.isEmpty {
                                        Text("Select Subcategory")
                                            .foregroundColor(.secondary)
                                    } else {
                                        Text(complaintVM.selectedSubcategory)
                                            .foregroundColor(.primary)
                                    }
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.secondary)
                                }
                                .padding()
                                .background(themeManager.isDarkMode ? Color.gray.opacity(0.2) : Color.white)
                                .cornerRadius(16)
                                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                            }
                            
                            // Custom input for "Other" selection
                            if complaintVM.selectedSubcategory == "Other" {
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Image(systemName: "pencil.line")
                                            .foregroundColor(.secondary)
                                        Text("DESCRIBE YOUR ISSUE")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    TextField("Specify your issue...", text: $complaintVM.customSubcategory)
                                        .padding()
                                        .background(themeManager.isDarkMode ? Color.gray.opacity(0.2) : Color.white)
                                        .cornerRadius(16)
                                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                                }
                            }
                        }
                    }
                    
                    // Description (only shown when "Other" is selected)
                    if complaintVM.selectedSubcategory == "Other" {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Image(systemName: "doc.text.fill")
                                    .foregroundColor(.secondary)
                                Text("DETAILS")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            ZStack(alignment: .topLeading) {
                                if complaintVM.description.isEmpty {
                                    Text("Add more details about your issue...")
                                        .foregroundColor(.secondary)
                                        .padding(.top, 20)
                                        .padding(.leading, 20)
                                }
                                
                                TextEditor(text: $complaintVM.description)
                                    .frame(minHeight: 120)
                                    .padding()
                                    .background(themeManager.isDarkMode ? Color.gray.opacity(0.2) : Color.white)
                                    .cornerRadius(16)
                                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                            }
                        }
                    }
                    
                    // Submit Button with improved design
                    Button(action: {
                        complaintVM.submitComplaint(
                            hostelType: userSettings.hostelType,
                            block: userSettings.block,
                            roomNumber: userSettings.roomNumber
                        )
                        showConfirmation = true
                    }) {
                        HStack {
                            Spacer()
                            Text("SUBMIT COMPLAINT")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .padding()
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.8)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .cornerRadius(16)
                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                        .padding(.top, 10)
                    }
                    .disabled(!canSubmit)
                    .opacity(canSubmit ? 1 : 0.6)
                }
                .padding(20)
                .background(themeManager.isDarkMode ? Color.black.opacity(0.8) : Color.white)
                .cornerRadius(30)
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
        }
        .sheet(isPresented: $showCategorySelection) {
            CategorySelectionView(showCategorySelection: $showCategorySelection)
        }
        .sheet(isPresented: $showSubcategorySelection) {
            if let category = complaintVM.selectedCategory {
                SubcategorySelectionView(
                    category: category,
                    showSubcategorySelection: $showSubcategorySelection
                )
            }
        }
        .alert(isPresented: $showConfirmation) {
            Alert(
                title: Text("Complaint Submitted!"),
                message: Text("Your complaint has been successfully registered. Our team will address it shortly."),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    private var canSubmit: Bool {
        complaintVM.selectedCategory != nil &&
        !complaintVM.selectedSubcategory.isEmpty &&
        (complaintVM.selectedSubcategory != "Other" || !complaintVM.customSubcategory.isEmpty)
    }
}
