import SwiftUI

struct DepositWithdrawView: View {
    let title: String
    let actionTitle: String
    @Binding var amount: String
    let action: () -> Void
    let cancelAction: () -> Void

    var body: some View {
        VStack {
            Text(title)
                .font(.headline)
                .padding()
                .foregroundColor(.white)

            TextField("Enter amount", text: $amount)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.decimalPad)
                .padding()
                .foregroundColor(.black) // Ensuring text color is black

            HStack {
                Button(action: action) {
                    Text(actionTitle)
                        .padding()
                        .background(Color.cyan)
                        .foregroundColor(.black)
                        .cornerRadius(8)
                }
                .padding()
                
                Button(action: cancelAction) {
                    Text("Cancel")
                        .padding()
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()
            }

            Spacer()
        }
        .padding()
        .background(Color.black)
        .cornerRadius(12)
        .shadow(radius: 20)
        .frame(width: 300, height: 250) // Centered size
    }
}
