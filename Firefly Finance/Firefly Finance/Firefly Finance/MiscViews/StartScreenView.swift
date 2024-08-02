import SwiftUI

struct StartScreenView: View {
    @Binding var currentView: String // Binding to the current view
    @Binding var previousView: String? // Binding to the previous view

    var body: some View {
        VStack {
            Spacer()
            
            Image("firefly_logo")
                .resizable()
                .scaledToFit()
                .frame(width: 350, height: 350)
                .padding(.bottom, 20)
            
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
            
            // Button to start a new playthrough
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
            
            // Button to view saved playthroughs
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
            
            Spacer()
        }
        .background(Color(UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)).edgesIgnoringSafeArea(.all))
    }
}

struct StartScreenView_Previews: PreviewProvider {
    static var previews: some View {
        StartScreenView(currentView: .constant("StartScreen"), previousView: .constant(nil))
    }
}
