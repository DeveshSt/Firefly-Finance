import SwiftUI

struct StarryBackground: View {
    var body: some View {
        GeometryReader { geometry in
            ForEach(0..<150, id: \.self) { _ in
                Circle()
                    .fill(Color.white)
                    .frame(width: .random(in: 1...4), height: .random(in: 1...4))
                    .position(
                        x: .random(in: 0...geometry.size.width),
                        y: .random(in: 0...geometry.size.height)
                    )
                    .opacity(.random(in: 0.3...0.7))
                    .animation(
                        Animation.easeInOut(duration: .random(in: 1...3))
                            .repeatForever(autoreverses: true),
                        value: UUID()
                    )
            }
        }
        .opacity(0.7)
    }
} 