import SwiftUI

struct YearAndResetView: View {
    @Binding var currentYear: Double
    @Binding var showingResetConfirmation: Bool
    @Binding var currentView: String

    var body: some View {
        HStack {
            Text("Year: \(Int(currentYear))")
                .font(.headline)
                .foregroundColor(.white)
                .padding()

            Spacer()

            // Fixed Help Button
            Button(action: {
                currentView = "Help" // Explicitly update the currentView state
            }) {
                Text("Help")
                    .padding()
                    .background(Color.green.opacity(0.8))
                    .foregroundColor(.black)
                    .cornerRadius(8)
            }
            .padding()

            Button(action: {
                showingResetConfirmation = true
            }) {
                Text("Reset")
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.black)
                    .cornerRadius(8)
            }
            .padding()
        }
    }
}
