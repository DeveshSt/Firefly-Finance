import SwiftUI

struct ResetConfirmationView: View {
    let confirmAction: () -> Void
    let cancelAction: () -> Void

    var body: some View {
        VStack {
            Text("Reset Account")
                .font(.headline)
                .padding()
                .foregroundColor(.white)

            Text("This will reset your balance, years, and progress in this session.")
                .multilineTextAlignment(.center)
                .padding()
                .foregroundColor(.white)

            HStack {
                Button(action: confirmAction) {
                    Text("Confirm")
                        .padding()
                        .background(Color.red)
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
        }
        .padding()
        .background(Color.black)
        .cornerRadius(12)
        .shadow(radius: 20)
    }
}
