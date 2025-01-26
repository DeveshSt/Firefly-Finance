import SwiftUI

struct AccountInfoView: View {
    @Binding var userAccount: UserAccount

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Net Account Value")
                .font(.headline)
                .foregroundColor(.white)
            
            Text("$\(userAccount.netAccountValue, specifier: "%.2f")")
                .font(.title)
                .foregroundColor(.white)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(12)
        .shadow(radius: 10)
        .padding(.bottom, 20)

        VStack(alignment: .leading, spacing: 10) {
            Text("Cash Balance")
                .font(.headline)
                .foregroundColor(.white)
            
            Text("$\(userAccount.cashBalance, specifier: "%.2f")")
                .font(.title)
                .foregroundColor(.white)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(12)
        .shadow(radius: 10)
        .padding(.bottom, 20)
    }
}
