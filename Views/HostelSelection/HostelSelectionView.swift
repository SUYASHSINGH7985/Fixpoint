import SwiftUI

struct HostelSelectionView: View {
    @EnvironmentObject var userSettings: UserSettings
    @State private var showBlockSelection = false
    @State private var selectedBlock = ""
    @State private var roomNumber = ""
    
    var body: some View {
        ScrollView {
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
            .frame(minHeight: UIScreen.main.bounds.height)
        }
        .edgesIgnoringSafeArea(.all)
    }
}
