import SwiftUI

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
