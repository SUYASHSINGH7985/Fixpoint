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
                .onChange(of: messages.count) { newCount, oldCount in
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
