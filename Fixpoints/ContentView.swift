// MARK: - FixPointsApp.swift
import SwiftUI

@main
struct FixPointsApp: App {
    @StateObject private var themeManager = ThemeManager()
    @StateObject private var complaintVM = ComplaintViewModel()
    @StateObject private var userSettings = UserSettings()
    
    var body: some Scene {
        WindowGroup {
            Group {
                if userSettings.isOnboardingCompleted {
                    MainTabView()
                } else {
                    HostelSelectionView()
                }
            }
            .environmentObject(themeManager)
            .environmentObject(complaintVM)
            .environmentObject(userSettings)
            .preferredColorScheme(themeManager.isDarkMode ? .dark : .light)
        }
    }
}

// MARK: - Models.swift
import SwiftUI

struct Complaint: Identifiable, Codable {
    var id = UUID()
    var category: String
    var subcategory: String
    var description: String
    var date = Date()
    var status: Status = .pending
    var hostelType: HostelType = .boys
    var block: String = ""
    var roomNumber: String = ""
    
    enum Status: String, Codable {
        case pending = "⏳ Pending"
        case inProgress = "🛠 In Progress"
        case resolved = "✅ Resolved"
    }
}

enum HostelType: String, Codable, CaseIterable {
    case boys = "Boys Hostel"
    case girls = "Girls Hostel"
    
    var icon: String {
        switch self {
        case .boys: return "figure.arms.open"
        case .girls: return "figure.dress"
        }
    }
    
    var color: Color {
        switch self {
        case .boys: return .blue
        case .girls: return .pink
        }
    }
    
    var blocks: [String] {
        switch self {
        case .boys: return ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T"]
        case .girls: return ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J"]
        }
    }
}

struct ComplaintCategory: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    let subcategories: [String]
    
    static let all: [ComplaintCategory] = [
        ComplaintCategory(
            name: "Electrician",
            icon: "bolt.fill",
            subcategories: ["Tube Light", "Bulb", "Fan", "AC", "Switch", "Other"]
        ),
        ComplaintCategory(
            name: "Plumber",
            icon: "drop.fill",
            subcategories: ["Tap", "Pipe Leak", "Drain", "Shower", "Other"]
        ),
        ComplaintCategory(
            name: "Carpenter",
            icon: "hammer.fill",
            subcategories: ["Bed", "Chair", "Table", "Cupboard", "Other"]
        ),
        ComplaintCategory(
            name: "WiFi/Network",
            icon: "wifi",
            subcategories: ["Slow Speed", "No Connection", "Router Issue", "Other"]
        ),
        ComplaintCategory(
            name: "Cleaning",
            icon: "bubbles.and.sparkles.fill",
            subcategories: ["Room", "Bathroom", "Common Area", "Other"]
        ),
        ComplaintCategory(
            name: "Security",
            icon: "lock.shield.fill",
            subcategories: ["Access Issue", "Theft Report", "Safety Concern", "Other"]
        ),
        ComplaintCategory(
            name: "Other",
            icon: "questionmark.circle.fill",
            subcategories: ["Other"]
        )
    ]
}

// MARK: - ViewModels.swift
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

class UserSettings: ObservableObject {
    @Published var hostelType: HostelType = .boys
    @Published var block: String = ""
    @Published var roomNumber: String = ""
    @Published var isOnboardingCompleted = false
}

// MARK: - HostelSelectionView.swift
import SwiftUI

struct HostelSelectionView: View {
    @EnvironmentObject var userSettings: UserSettings
    @State private var showBlockSelection = false
    @State private var selectedBlock = ""
    @State private var roomNumber = ""
    
    var body: some View {
        ZStack {
            // Creative background
            LinearGradient(
                gradient: Gradient(colors: [Color(hex: "0F4C81"), Color(hex: "1E90FF")]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)
            
            // Floating bubbles for visual interest
            BubbleBackground()
            
            VStack(spacing: 30) {
                Spacer()
                
                // App Header with improved design
                VStack(spacing: 15) {
                    Image(systemName: "wrench.and.screwdriver.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.white)
                        .padding()
                        .background(Circle().fill(Color.white.opacity(0.2)))
                    
                    Text("FixPoints")
                        .font(.system(size: 42, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(radius: 5)
                    
                    Text("Premium Hostel Solutions")
                        .font(.title3)
                        .foregroundColor(.white.opacity(0.8))
                }
                .padding(.bottom, 40)
                
                // Hostel Selection
                VStack(alignment: .leading, spacing: 15) {
                    Text("SELECT YOUR HOSTEL")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.bottom, 10)
                    
                    HStack(spacing: 30) {
                        ForEach(HostelType.allCases, id: \.self) { type in
                            VStack(spacing: 15) {
                                Image(systemName: type.icon)
                                    .font(.system(size: 48, weight: .bold))
                                    .foregroundColor(userSettings.hostelType == type ? .white : type.color)
                                    .frame(width: 80, height: 80)
                                    .background(
                                        userSettings.hostelType == type ?
                                        type.color : Color.white.opacity(0.2)
                                    )
                                    .clipShape(Circle())
                                    .overlay(
                                        Circle()
                                            .stroke(userSettings.hostelType == type ? type.color : Color.clear, lineWidth: 3)
                                    )
                                    .onTapGesture {
                                        withAnimation {
                                            // Reset selections when changing hostel
                                            selectedBlock = ""
                                            roomNumber = ""
                                            userSettings.hostelType = type
                                        }
                                    }
                                
                                Text(type.rawValue)
                                    .font(.headline)
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(.horizontal, 20)
                
                // Block and Room Selection
                if showBlockSelection {
                    VStack(spacing: 20) {
                        // Block Selection
                        VStack(alignment: .leading, spacing: 10) {
                            Text("SELECT BLOCK")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.bottom, 5)
                            
                            // Flexible grid for blocks
                            let columns = Array(repeating: GridItem(.flexible(), spacing: 15), count: 5)
                            
                            LazyVGrid(columns: columns, spacing: 15) {
                                ForEach(userSettings.hostelType.blocks, id: \.self) { block in
                                    Button(action: {
                                        withAnimation {
                                            selectedBlock = block
                                        }
                                    }) {
                                        Text(block)
                                            .font(.title3)
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                            .frame(width: 50, height: 50)
                                            .background(
                                                selectedBlock == block ?
                                                Color.orange : Color.white.opacity(0.2)
                                            )
                                            .clipShape(Circle())
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                        
                        // Room Number
                        VStack(alignment: .leading, spacing: 10) {
                            Text("ROOM NUMBER")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .center)
                            
                            TextField("Enter room number", text: $roomNumber)
                                .multilineTextAlignment(.center)
                                .padding()
                                .background(Color.white.opacity(0.2))
                                .foregroundColor(.white)
                                .cornerRadius(15)
                                .padding(.horizontal, 40)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(Color.white.opacity(0.5), lineWidth: 1)
                                )
                        }
                        
                        // Continue Button
                        Button(action: {
                            userSettings.block = selectedBlock
                            userSettings.roomNumber = roomNumber
                            userSettings.isOnboardingCompleted = true
                        }) {
                            Text("GET STARTED")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.orange, Color.orange.opacity(0.7)]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .cornerRadius(15)
                                .padding(.horizontal, 40)
                        }
                        .disabled(selectedBlock.isEmpty || roomNumber.isEmpty)
                        .opacity((selectedBlock.isEmpty || roomNumber.isEmpty) ? 0.6 : 1)
                    }
                    .transition(.move(edge: .bottom))
                }
                
                Spacer()
                
                // Continue Button
                if !showBlockSelection {
                    Button(action: {
                        withAnimation(.spring()) {
                            showBlockSelection = true
                        }
                    }) {
                        Text("CONTINUE")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: 250)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.orange, Color.orange.opacity(0.7)]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .cornerRadius(15)
                            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                    }
                    .transition(.move(edge: .bottom))
                }
            }
            .padding(.vertical, 30)
        }
    }
}

// MARK: - BubbleBackground.swift
import SwiftUI

struct BubbleBackground: View {
    @State private var bubbles: [Bubble] = []
    
    struct Bubble: Identifiable {
        let id = UUID()
        let size: CGFloat
        let x: CGFloat
        let y: CGFloat
        let speed: Double
    }
    
    init() {
        // Create random bubbles
        for _ in 0..<15 {
            bubbles.append(Bubble(
                size: CGFloat.random(in: 20...80),
                x: CGFloat.random(in: 0...1),
                y: CGFloat.random(in: 0...1),
                speed: Double.random(in: 5...15)
            ))
        }
    }
    
    var body: some View {
        ZStack {
            ForEach(bubbles) { bubble in
                Circle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: bubble.size, height: bubble.size)
                    .position(
                        x: UIScreen.main.bounds.width * bubble.x,
                        y: UIScreen.main.bounds.height * bubble.y
                    )
                    .modifier(BubbleMoveModifier(speed: bubble.speed))
            }
        }
    }
}

struct BubbleMoveModifier: ViewModifier {
    @State private var move = false
    let speed: Double
    
    func body(content: Content) -> some View {
        content
            .offset(y: move ? -UIScreen.main.bounds.height : 0)
            .animation(
                Animation.linear(duration: speed)
                    .repeatForever(autoreverses: false),
                value: move
            )
            .onAppear {
                move = true
            }
    }
}

// MARK: - MainTabView.swift
import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            ComplaintFormView()
                .tabItem {
                    Label("Report", systemImage: "plus.bubble.fill")
                }
            
            ComplaintHistoryView()
                .tabItem {
                    Label("History", systemImage: "clock.fill")
                }
            
            ChatSupportView()
                .tabItem {
                    Label("Support", systemImage: "message.fill")
                }
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
        }
        .accentColor(.blue)
    }
}

// MARK: - ComplaintFormView.swift
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

// MARK: - SelectionViews.swift
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

// MARK: - ComplaintHistoryView.swift
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

// MARK: - SettingsView.swift
import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var userSettings: UserSettings
    
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
                Button(action: {}) {
                    HStack {
                        Image(systemName: "envelope.fill")
                            .foregroundColor(.blue)
                        Text("Contact Support")
                    }
                }
                
                Button(action: {}) {
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

// MARK: - ChatSupportView.swift
import SwiftUI

struct ChatSupportView: View {
    @State private var messages: [Message] = [
        Message(text: "Hello! I'm your FixPoints support assistant. How can I help you today?", isUser: false)
    ]
    @State private var newMessage = ""
    
    var body: some View {
        VStack {
            // Header with improved design
            VStack(spacing: 10) {
                Text("Premium Support")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                
                Divider()
                    .padding(.horizontal, 40)
            }
            .padding(.top, 30)
            
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(messages) { message in
                            MessageBubble(message: message)
                                .id(message.id)
                        }
                    }
                    .padding()
                }
                .onChange(of: messages.count) { _ in
                    withAnimation {
                        proxy.scrollTo(messages.last?.id, anchor: .bottom)
                    }
                }
            }
            
            // Message input area
            HStack {
                TextField("Type your message...", text: $newMessage)
                    .textFieldStyle(.roundedBorder)
                    .padding(.leading, 8)
                
                Button(action: sendMessage) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.white)
                        .padding(12)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.8)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .clipShape(Circle())
                }
                .disabled(newMessage.isEmpty)
            }
            .padding()
        }
    }
    
    private func sendMessage() {
        guard !newMessage.isEmpty else { return }
        
        let userMessage = Message(text: newMessage, isUser: true)
        messages.append(userMessage)
        
        // Clear input
        newMessage = ""
        
        // Simulate response
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let responses = [
                "I understand your concern. Our team will look into this issue.",
                "Thanks for reporting this. We'll assign someone to your case shortly.",
                "I've noted your complaint. Our maintenance team will contact you soon.",
                "We appreciate your feedback. This will be resolved within 24 hours.",
                "I'm sorry to hear about this issue. We're prioritizing your complaint."
            ]
            
            let response = responses.randomElement() ?? "We've received your complaint and will respond shortly."
            messages.append(Message(text: response, isUser: false))
        }
    }
}

struct Message: Identifiable {
    let id = UUID()
    let text: String
    let isUser: Bool
}

struct MessageBubble: View {
    let message: Message
    
    var body: some View {
        HStack {
            if message.isUser {
                Spacer()
            }
            
            Text(message.text)
                .padding(12)
                .background(
                    message.isUser ?
                    AnyView(LinearGradient(
                        gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.8)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )) : AnyView(Color.gray.opacity(0.2))
                )
                .foregroundColor(message.isUser ? .white : .primary)
                .cornerRadius(18)
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(Color(.systemGray5), lineWidth: message.isUser ? 0 : 1)
                )
            
            if !message.isUser {
                Spacer()
            }
        }
    }
}

// MARK: - Extensions.swift
import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Preview.swift
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
