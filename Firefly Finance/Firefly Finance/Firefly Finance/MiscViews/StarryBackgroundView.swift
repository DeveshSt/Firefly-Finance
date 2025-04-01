import SwiftUI

struct Star: Identifiable {
    let id = UUID()
    let x: CGFloat
    let y: CGFloat
    let size: CGFloat
    let opacity: Double
}

struct StarryBackgroundView: View {
    let starCount: Int
    let geometry: GeometryProxy
    @State private var stars: [Star] = []
    
    init(starCount: Int = 150, geometry: GeometryProxy) {
        self.starCount = starCount
        self.geometry = geometry
    }
    
    var body: some View {
        Canvas { context, size in
            for star in stars {
                let path = Path { path in
                    path.addEllipse(in: CGRect(
                        x: star.x,
                        y: star.y,
                        width: star.size,
                        height: star.size
                    ))
                }
                
                context.addFilter(.blur(radius: star.size * 0.3))
                context.setFillStyle(GraphicsContext.FillStyle.color(
                    Color.white.opacity(star.opacity)
                ))
                context.fill(path)
            }
        }
        .onAppear {
            generateStars()
        }
    }
    
    private func generateStars() {
        stars = (0..<starCount).map { _ in
            Star(
                x: CGFloat.random(in: 0...geometry.size.width),
                y: CGFloat.random(in: 0...geometry.size.height),
                size: CGFloat.random(in: 1...3),
                opacity: Double.random(in: 0.2...0.7)
            )
        }
    }
} 