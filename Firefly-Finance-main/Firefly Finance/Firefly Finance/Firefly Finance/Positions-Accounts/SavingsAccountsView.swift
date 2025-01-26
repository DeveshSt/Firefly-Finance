import SwiftUI

struct SavingsAccountsView: View {
    @Binding var userAccount: UserAccount // Binding to the user's account
    @Binding var selectedAccount: SavingsAccount? // Binding to the selected savings account
    @Binding var showingDepositSheet: Bool // Binding to show/hide deposit sheet
    @Binding var showingWithdrawSheet: Bool // Binding to show/hide withdraw sheet
    
    var body: some View {
        VStack(spacing: 20) {
            // Header for Savings Accounts section
            Section(header:
                HStack {
                    Text("Savings Accounts")
                        .font(.headline)
                        .foregroundColor(.white)
                    NavigationLink(destination: HYSAInfoView()) {
                        Image(systemName: "questionmark.circle")
                            .foregroundColor(.cyan)
                    }
                }
                .padding(.top, 20)) {
                // Display each savings account
                ForEach(userAccount.savingsAccounts) { account in
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text(account.name)
                            Spacer()
                            Text("Interest Rate: \(account.interestRate * 100, specifier: "%.2f")%")
                        }
                        .foregroundColor(.white)
                        HStack {
                            Text("Current Balance: $\(account.balance, specifier: "%.2f")")
                            Spacer()
                        }
                        .foregroundColor(.white)
                        HStack {
                            Spacer()
                            Button(action: {
                                selectedAccount = account
                                showingDepositSheet = true
                            }) {
                                Text("Deposit")
                                    .padding()
                                    .background(Color.cyan)
                                    .foregroundColor(.black)
                                    .cornerRadius(8)
                            }
                            .padding(.trailing)
                            Button(action: {
                                selectedAccount = account
                                showingWithdrawSheet = true
                            }) {
                                Text("Withdraw")
                                    .padding()
                                    .background(Color.cyan)
                                    .foregroundColor(.black)
                                    .cornerRadius(8)
                            }
                            .padding(.leading)
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(12)
                    .shadow(radius: 10)
                }
            }
        }
        .padding()
    }
}

struct SavingsAccountsView_Previews: PreviewProvider {
    static var previews: some View {
        SavingsAccountsView(
            userAccount: .constant(UserAccount(
                cashBalance: 10000,
                savingsAccounts: [SavingsAccount(name: "High Yield Savings", interestRate: 0.05, balance: 0)],
                stocks: [],
                investments: []
            )),
            selectedAccount: .constant(nil),
            showingDepositSheet: .constant(false),
            showingWithdrawSheet: .constant(false)
        )
    }
}
