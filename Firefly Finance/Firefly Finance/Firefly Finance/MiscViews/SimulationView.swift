import SwiftUI

struct SimulationView: View {
    @Binding var simulationYears: String
    let simulateGrowth: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                TextField("Years to simulate", text: $simulationYears)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.decimalPad)
                    .padding()
                
                Button(action: simulateGrowth) {
                    Text("Simulate")
                        .padding()
                        .background(Color.cyan)
                        .foregroundColor(.black)
                        .cornerRadius(8)
                }
                .padding(.trailing)
            }
        }
        .padding()
    }
}
