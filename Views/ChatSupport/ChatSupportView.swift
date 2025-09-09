import SwiftUI

struct ChatMessage: Identifiable {
    let id = UUID()
    var text: String
    let isUser: Bool
    var isTyping: Bool = false
}

struct ChatSupportView: View {
    @State private var messages: [ChatMessage] = [
        ChatMessage(text: "👋 Hey! How can I help you today?", isUser: false)
    ]
    @State private var inputText: String = ""
    @State private var isLoading = false
    
    // 🔑 Replace with your Gemini API Key
    let apiKey = "AIzaSyCxo5uQK9zi9DrrMRHwr5sL7s3E8mkL-mU"
    let endpoint = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent"
    
    var body: some View {
        VStack {
            ScrollViewReader { proxy in
                ScrollView {
                    ForEach(messages) { message in
                        HStack {
                            if message.isUser {
                                Spacer()
                                Text(message.text)
                                    .padding()
                                    .background(Color.blue.opacity(0.2))
                                    .cornerRadius(12)
                                    .frame(maxWidth: 250, alignment: .trailing)
                            } else {
                                if message.isTyping {
                                    Text("✍️ FixPoints AI is typing...")
                                        .italic()
                                        .padding()
                                        .background(Color.gray.opacity(0.1))
                                        .cornerRadius(12)
                                        .frame(maxWidth: 250, alignment: .leading)
                                } else {
                                    Text(message.text)
                                        .padding()
                                        .background(Color.gray.opacity(0.2))
                                        .cornerRadius(12)
                                        .frame(maxWidth: 250, alignment: .leading)
                                }
                                Spacer()
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 4)
                        .id(message.id)
                    }
                }
                .onChange(of: messages.count) { _ in
                    withAnimation {
                        proxy.scrollTo(messages.last?.id, anchor: .bottom)
                    }
                }
            }
            
            HStack {
                TextField("Type a message...", text: $inputText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                if isLoading {
                    ProgressView()
                        .padding(.trailing)
                } else {
                    Button(action: {
                        sendMessage()
                    }) {
                        Image(systemName: "paperplane.fill")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .clipShape(Circle())
                    }
                    .padding(.trailing)
                }
            }
            .padding(.bottom)
        }
    }
    
    func sendMessage() {
        guard !inputText.isEmpty else { return }
        let userMessage = ChatMessage(text: inputText, isUser: true)
        messages.append(userMessage)
        let prompt = inputText
        inputText = ""
        
        // Show typing indicator
        let typingIndicator = ChatMessage(text: "", isUser: false, isTyping: true)
        messages.append(typingIndicator)
        
        isLoading = true
        Task {
            if let response = await callGeminiAPI(prompt: prompt) {
                // Remove typing indicator
                messages.removeAll { $0.isTyping }
                
                // Show response gradually (typing effect)
                var displayedText = ""
                let botMessage = ChatMessage(text: "", isUser: false)
                messages.append(botMessage)
                
                for char in response {
                    displayedText.append(char)
                    if let index = messages.firstIndex(where: { $0.id == botMessage.id }) {
                        messages[index].text = displayedText
                    }
                    try? await Task.sleep(nanoseconds: 30_000_000) // 0.03s per char
                }
            } else {
                messages.removeAll { $0.isTyping }
                let errorMessage = ChatMessage(text: "⚠️ Error: No response from Gemini.", isUser: false)
                messages.append(errorMessage)
            }
            isLoading = false
        }
    }
    
    func callGeminiAPI(prompt: String) async -> String? {
        guard let url = URL(string: "\(endpoint)?key=\(apiKey)") else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "contents": [
                ["parts": [["text": prompt]]]
            ]
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            
            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let candidates = json["candidates"] as? [[String: Any]],
               let content = candidates.first?["content"] as? [String: Any],
               let parts = content["parts"] as? [[String: Any]],
               let text = parts.first?["text"] as? String {
                return text
            }
        } catch {
            print("❌ API Error: \(error)")
        }
        return nil
    }
}
