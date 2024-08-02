import SwiftUI

struct YearAndResetView: View {
    @Binding var currentYear: Double // Binding to the current year
    @Binding var showingResetConfirmation: Bool // Binding to show/hide reset confirmation dialog
    @Binding var currentView: String // Binding to the current view

    var body: some View {
        HStack {
            Text("Year: \(Int(currentYear))")
                .font(.headline)
                .foregroundColor(.white)
                .padding()
            
            Spacer()
            
            Button(action: {
                currentView = "Help"
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
