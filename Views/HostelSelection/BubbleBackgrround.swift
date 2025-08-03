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
                y: CGFloat.random(in: 0...1.5), // Extend beyond screen
                speed: Double.random(in: 5...15)
            ))
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(bubbles) { bubble in
                    Circle()
                        .fill(Color.white.opacity(0.1))
                        .frame(width: bubble.size, height: bubble.size)
                        .position(
                            x: geometry.size.width * bubble.x,
                            y: geometry.size.height * bubble.y
                        )
                        .modifier(BubbleMoveModifier(speed: bubble.speed, screenHeight: geometry.size.height))
                }
            }
        }
    }
}

struct BubbleMoveModifier: ViewModifier {
    @State private var move = false
    let speed: Double
    let screenHeight: CGFloat
    
    func body(content: Content) -> some View {
        content
            .offset(y: move ? -screenHeight * 1.5 : 0) // Move beyond screen
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
