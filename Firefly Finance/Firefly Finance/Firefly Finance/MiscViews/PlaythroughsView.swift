import SwiftUI

struct PlaythroughsView: View {
    @State private var playthroughs: [Playthrough] = LocalStorage.getPlaythroughs()
    @Binding var userAccount: UserAccount
    @Binding var currentYear: Double
    @Binding var earningsOverTime: [(year: Int, value: Double)]
    @Binding var currentView: String
    @Binding var previousView: String?

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    currentView = previousView ?? "StartScreen"
                }) {
                    HStack {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.white)
                        Text("Back")
                            .foregroundColor(.white)
                    }
                }
                Spacer()
            }
            .padding()
            .background(Color.black)
            
            List {
                ForEach(playthroughs) { playthrough in
                    VStack(alignment: .leading) {
                        Text("Year: \(playthrough.year)")
                            .font(.headline)
                        Text("Net Account Value: $\(playthrough.netAccountValue, specifier: "%.2f")")
                        Text("Date: \(playthrough.date, style: .date)")

                        if playthrough.year < 100 {
                            Button(action: { continuePlaythrough(playthrough) }) {
                                Text("Continue")
                                    .padding()
                                    .background(Color.green)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                            .padding(.top, 5)
                        }

                        Button(action: { deletePlaythrough(playthrough) }) {
                            Text("Delete")
                                .padding()
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        .padding(.top, 5)
                    }
                    .padding()
                    .background(playthrough == bestPlaythrough ? Color.yellow : Color.clear)
                }
            }
        }
        .onAppear {
            playthroughs = LocalStorage.getPlaythroughs()
        }
    }

    private func deletePlaythrough(_ playthrough: Playthrough) {
        LocalStorage.deletePlaythrough(playthrough)
        playthroughs = LocalStorage.getPlaythroughs()
    }

    private func continuePlaythrough(_ playthrough: Playthrough) {
        userAccount = playthrough.userAccount
        currentYear = Double(playthrough.year)
        earningsOverTime = playthrough.earningsOverTime
        currentView = "Home"
    }
    
    private var bestPlaythrough: Playthrough? {
        playthroughs.filter { $0.year == 100 }.max(by: { $0.netAccountValue < $1.netAccountValue })
    }
}

struct PlaythroughsView_Previews: PreviewProvider {
    static var previews: some View {
        PlaythroughsView(
            userAccount: .constant(UserAccount(
                cashBalance: 10000,
                savingsAccounts: [SavingsAccount(name: "High Yield Savings", interestRate: 0.05, balance: 0)],
                stocks: [
                    Stock(name: "CyberMosaic Systems", ticker: "CMSY", price: 100, riskLevel: .high, projectedRateOfReturn: 0.05),
                    Stock(name: "Prickler Holdings", ticker: "PHGS", price: 210, riskLevel: .medium, projectedRateOfReturn: 0.0, dividendYield: 0.03),
                    Stock(name: "Pinemoore Finance", ticker: "PIMF", price: 75, riskLevel: .medium, projectedRateOfReturn: 0.10, dividendYield: 0.01)
                ],
                investments: []
            )),
            currentYear: .constant(0),
            earningsOverTime: .constant([]),
            currentView: .constant("Playthroughs"),
            previousView: .constant(nil)
        )
    }
}
