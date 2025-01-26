import SwiftUI

struct StartScreenView: View {
    @Binding var currentView: String // Binding to the current view
    @Binding var previousView: String? // Binding to the previous view

    var body: some View {
        VStack {
            Spacer()
            
            // Logo
            Image("firefly_logo")
                .resizable()
                .scaledToFit()
                .frame(width: 350, height: 350)
                .padding(.bottom, 20)
            
            // Title
            Text("Firefly Finance")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.cyan)
                .padding(.bottom, 10)
            
            Text("A Financial Management Simulation")
                .font(.system(size: 22))
                .font(.subheadline)
                .foregroundColor(.orange)
                .padding(.bottom, 50)
            
            // Start New Playthrough Button
            Button(action: {
                previousView = currentView
                currentView = "Home"
            }) {
                Text("Start New Playthrough")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.cyan)
                    .foregroundColor(.black)
                    .cornerRadius(8)
                    .padding(.horizontal, 20)
            }
            .padding(.bottom, 20)
            
            // View Saved Playthroughs Button
            Button(action: {
                previousView = currentView
                currentView = "Playthroughs"
            }) {
                Text("View Saved Playthroughs")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.orange)
                    .foregroundColor(.black)
                    .cornerRadius(8)
                    .padding(.horizontal, 20)
            }
            
            // Social Media Handles (TikTok & Instagram)
            HStack(spacing: 30) {
                SocialMediaButton(iconName: "TikTok_Icon_Black_Circle", handle: "@firefly_edu", url: "https://www.tiktok.com/@firefly_edu")
                SocialMediaButton(iconName: "2111463", handle: "@fireflyedu_", url: "https://www.instagram.com/fireflyedu_")
            }
            .padding(.top, 20)
            
            Spacer()
        }
        .background(Color(UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)).edgesIgnoringSafeArea(.all))
    }
}

// MARK: - Social Media Button Component
struct SocialMediaButton: View {
    let iconName: String
    let handle: String
    let url: String

    var body: some View {
        Button(action: {
            if let link = URL(string: url) {
                UIApplication.shared.open(link)
            }
        }) {
            HStack {
                Image(iconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                
                Text(handle)
                    .font(.headline)
                    .foregroundColor(.black)
            }
            .padding(10)
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 5)
        }
    }
}

// MARK: - Preview
struct StartScreenView_Previews: PreviewProvider {
    static var previews: some View {
        StartScreenView(currentView: .constant("StartScreen"), previousView: .constant(nil))
    }
}
