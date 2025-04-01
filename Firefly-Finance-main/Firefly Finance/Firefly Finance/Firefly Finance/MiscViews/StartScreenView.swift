import SwiftUI

struct StartScreenView: View {
    @Binding var currentView: String
    @Binding var previousView: String?
    @State private var isAnimating = false
    @State private var showButtons = false
    
    // Animation state for floating effect (only for logo)
    @State private var logoOffset: CGFloat = 20
    @State private var glowOpacity: Double = 0.5
    
    var body: some View {
        ZStack {
            // Animated gradient background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.1, green: 0.1, blue: 0.15),
                    Color(red: 0.15, green: 0.15, blue: 0.2)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            // Animated particles
            GeometryReader { geometry in
                ForEach(0..<50) { i in
                    Circle()
                        .fill(Color.white.opacity(0.2))
                        .frame(width: randomSize(), height: randomSize())
                        .position(
                            x: randomPosition(in: geometry.size.width),
                            y: randomPosition(in: geometry.size.height)
                        )
                        .opacity(isAnimating ? 0.5 : 0)
                        .animation(
                            Animation.easeInOut(duration: randomDuration())
                                .repeatForever(autoreverses: true)
                                .delay(randomDelay()),
                            value: isAnimating
                        )
                }
            }
            
            VStack(spacing: 0) {
                Spacer()
                    .frame(height: 50)
                
                // Animated logo with glow effect
                ZStack {
                    // Glow effect
                    Image("firefly_logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 300)
                        .blur(radius: 20)
                        .opacity(glowOpacity)
                        .foregroundColor(.cyan)
                    
                    // Main logo
                    Image("firefly_logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 280, height: 280)
                }
                .offset(y: logoOffset)
                .animation(
                    Animation.easeInOut(duration: 2.0)
                        .repeatForever(autoreverses: true),
                    value: logoOffset
                )
                
                Spacer()
                    .frame(height: 30)
                
                // Title with gradient and animation (now with fixed position)
                VStack(spacing: 15) {
                    Text("Firefly Finance")
                        .font(.system(size: 44, weight: .bold))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.cyan, .blue],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .opacity(isAnimating ? 1 : 0)
                        .offset(y: isAnimating ? 0 : 20)
                        .animation(.easeOut(duration: 1.0), value: isAnimating)
                    
                    Text("A Financial Management Simulation")
                        .font(.system(size: 22))
                        .foregroundColor(.orange)
                        .opacity(isAnimating ? 1 : 0)
                        .offset(y: isAnimating ? 0 : 20)
                        .animation(.easeOut(duration: 1.0), value: isAnimating)
                }
                .frame(height: 100)
                
                Spacer()
                    .frame(height: 50)
                
                // Animated buttons
                VStack(spacing: 20) {
                    // Start New Playthrough Button
                    Button(action: {
                        withAnimation {
                            previousView = currentView
                            currentView = "Home"
                        }
                    }) {
                        GlowingButton(text: "Start New Playthrough", color: .cyan)
                    }
                    .offset(x: showButtons ? 0 : -UIScreen.main.bounds.width)
                    
                    // View Saved Playthroughs Button
                    Button(action: {
                        withAnimation {
                            previousView = currentView
                            currentView = "Playthroughs"
                        }
                    }) {
                        GlowingButton(text: "View Saved Playthroughs", color: .orange)
                    }
                    .offset(x: showButtons ? 0 : UIScreen.main.bounds.width)
                }
                .padding(.bottom, 40)
                
                // Social Media Links with hover effect
                HStack(spacing: 30) {
                    SocialMediaButton(
                        iconName: "TikTok_Icon_Black_Circle",
                        handle: "@firefly_edu",
                        url: "https://www.tiktok.com/@firefly_edu"
                    )
                    SocialMediaButton(
                        iconName: "2111463",
                        handle: "@fireflyedu_",
                        url: "https://www.instagram.com/fireflyedu_"
                    )
                }
                .opacity(isAnimating ? 1 : 0)
                .padding(.bottom, 30)
                
                Spacer()
                    .frame(height: 30)
            }
        }
        .onAppear {
            startAnimations()
        }
    }
    
    private func startAnimations() {
        withAnimation(.easeOut(duration: 1.0)) {
            isAnimating = true
        }
        
        withAnimation(.easeOut(duration: 1.0).delay(0.5)) {
            showButtons = true
        }
        
        // Start floating animation (only for logo)
        withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
            logoOffset = -20
            glowOpacity = 0.8
        }
    }
    
    private func randomSize() -> CGFloat {
        .random(in: 2...4)
    }
    
    private func randomPosition(in range: CGFloat) -> CGFloat {
        .random(in: 0...range)
    }
    
    private func randomDuration() -> Double {
        .random(in: 1.5...3.0)
    }
    
    private func randomDelay() -> Double {
        .random(in: 0...2.0)
    }
}

struct GlowingButton: View {
    let text: String
    let color: Color
    @State private var isHovered = false
    
    var body: some View {
        Text(text)
            .font(.system(size: 20, weight: .bold))
            .padding(.horizontal, 40)
            .padding(.vertical, 20)
            .background(
                ZStack {
                    color.opacity(0.2)
                    color.opacity(0.1)
                        .blur(radius: 20)
                }
            )
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(color, lineWidth: 2)
                    .blur(radius: isHovered ? 3 : 0)
            )
            .foregroundColor(color)
            .cornerRadius(15)
            .scaleEffect(isHovered ? 1.05 : 1.0)
            .shadow(color: color.opacity(0.5), radius: isHovered ? 10 : 5)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isHovered)
            .onHover { hovering in
                isHovered = hovering
            }
    }
}

struct SocialMediaButton: View {
    let iconName: String
    let handle: String
    let url: String
    @State private var isHovered = false
    
    var body: some View {
        Button(action: {
            if let link = URL(string: url) {
                UIApplication.shared.open(link)
            }
        }) {
            HStack(spacing: 12) {
                Image(iconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                
                Text(handle)
                    .font(.system(size: 16, weight: .medium))
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
            )
            .scaleEffect(isHovered ? 1.05 : 1.0)
            .shadow(color: .white.opacity(0.1), radius: isHovered ? 10 : 5)
        }
        .buttonStyle(PlainButtonStyle())
        .foregroundColor(.white)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isHovered)
        .onHover { hovering in
            isHovered = hovering
        }
    }
}

// MARK: - Preview
struct StartScreenView_Previews: PreviewProvider {
    static var previews: some View {
        StartScreenView(currentView: .constant("StartScreen"), previousView: .constant(nil))
    }
}
