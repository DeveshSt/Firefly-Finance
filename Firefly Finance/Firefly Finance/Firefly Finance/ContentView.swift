import SwiftUI

struct ContentView: View {
    @State private var userAccount = UserAccount(
        cashBalance: 10000,
        savingsAccounts: [
            SavingsAccount(name: "High Yield Savings", interestRate: 0.05, balance: 0)
        ],
        stocks: [
            Stock(name: "CyberMosaic Systems", ticker: "CMSY", price: Double.random(in: 100.00...150.00), riskLevel: .high, projectedRateOfReturn: 0.05),
            Stock(name: "Prickler Holdings", ticker: "PHGS", price: Double.random(in: 210.00...265.00), riskLevel: .medium, projectedRateOfReturn: 0.0, dividendYield: 0.03),
            Stock(name: "Pinemoore Finance", ticker: "PIMF", price: Double.random(in: 50.00...100.00), riskLevel: .medium, projectedRateOfReturn: 0.10, dividendYield: 0.01)
        ],
        investments: []
    )

    @State private var depositAmount: String = ""
    @State private var withdrawAmount: String = ""
    @State private var showingDepositSheet = false
    @State private var showingWithdrawSheet = false
    @State private var selectedAccount: SavingsAccount?
    @State private var simulationYears: String = ""
    @State private var currentYear: Double = 0
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var showingResetConfirmation = false
    @State private var earningsOverTime: [(year: Int, value: Double)] = []
    @State private var currentView: String = "StartScreen"
    @State private var previousView: String? = nil
    @State private var stockTransactionShares: [UUID: String] = [:]
    @State private var stockTransactionSellShares: [UUID: String] = [:]

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                if currentView == "StartScreen" {
                    StartScreenView(currentView: $currentView, previousView: $previousView)
                } else {
                    VStack(spacing: 0) {
                        HStack {
                            Button(action: { currentView = "Graph" }) {
                                Text("Earnings Graph")
                                    .padding()
                                    .background(Color.cyan)
                                    .foregroundColor(.black)
                                    .cornerRadius(8)
                            }
                            Spacer()
                            Button(action: {
                                previousView = currentView
                                currentView = "Playthroughs"
                            }) {
                                Text("Playthroughs")
                                    .padding(15)
                                    .background(Color.cyan)
                                    .foregroundColor(.black)
                                    .cornerRadius(8)
                            }
                            Spacer()
                            Button(action: { currentView = "Chat" }) {
                                Text("Chat with AI")
                                    .padding()
                                    .background(Color.cyan)
                                    .foregroundColor(.black)
                                    .cornerRadius(8)
                            }
                        }
                        .padding()
                        .background(Color.black)

                        Rectangle()
                            .frame(height: 2)
                            .foregroundColor(.white)

                        if currentView == "Home" {
                            HomeView(
                                userAccount: $userAccount,
                                depositAmount: $depositAmount,
                                withdrawAmount: $withdrawAmount,
                                showingDepositSheet: $showingDepositSheet,
                                showingWithdrawSheet: $showingWithdrawSheet,
                                selectedAccount: $selectedAccount,
                                simulationYears: $simulationYears,
                                currentYear: $currentYear,
                                showingAlert: $showingAlert,
                                alertMessage: $alertMessage,
                                showingResetConfirmation: $showingResetConfirmation,
                                earningsOverTime: $earningsOverTime,
                                currentView: $currentView,
                                stockTransactionShares: $stockTransactionShares,
                                stockTransactionSellShares: $stockTransactionSellShares,
                                purchaseStock: purchaseStock,
                                sellStock: sellStock,
                                handleDepositWithdrawAction: handleDepositWithdrawAction,
                                handleDepositWithdrawCancel: handleDepositWithdrawCancel
                            )
                        } else if currentView == "Graph" {
                            EarningsGraphView(
                                earningsOverTime: earningsOverTime,
                                userAccount: $userAccount,
                                currentYear: $currentYear,
                                onNavigateHome: { currentView = "Home" }
                            )
                        } else if currentView == "Playthroughs" {
                            PlaythroughsView(
                                userAccount: $userAccount,
                                currentYear: $currentYear,
                                earningsOverTime: $earningsOverTime,
                                currentView: $currentView,
                                previousView: $previousView
                            )
                        } else if currentView == "Chat" {
                            ChatBotView(
                                userAccount: $userAccount,
                                currentView: $currentView,
                                earningsOverTime: $earningsOverTime,
                                currentYear: $currentYear
                            )
                        } else if currentView == "Help" {
                            HelpView(currentView: $currentView)
                        }
                    }
                }
            }
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }

    private func purchaseStock(stock: Stock, shares: String) {
        if let shares = Double(shares) {
            let totalCost = shares * stock.price
            if totalCost <= userAccount.cashBalance {
                userAccount.purchaseStock(stock: stock, amount: totalCost)
                stockTransactionShares[stock.id] = ""
            } else {
                alertMessage = "Insufficient Funds"
                showingAlert = true
            }
        }
    }

    private func sellStock(stock: Stock, shares: String) {
        if let shares = Double(shares) {
            let totalReturn = shares * stock.price
            if let investmentIndex = userAccount.investments.firstIndex(where: { $0.stockId == stock.id }), userAccount.investments[investmentIndex].amount >= totalReturn {
                userAccount.investments[investmentIndex].amount -= totalReturn
                userAccount.cashBalance += totalReturn
                stockTransactionSellShares[stock.id] = ""
            } else {
                alertMessage = "Insufficient Funds"
                showingAlert = true
            }
        }
    }

    private func handleDepositWithdrawAction() {
        if showingDepositSheet, let amount = Double(depositAmount), let account = selectedAccount {
            userAccount.deposit(amount: amount, to: account.name)
            depositAmount = ""
            showingDepositSheet = false
        } else if showingWithdrawSheet, let amount = Double(withdrawAmount), let account = selectedAccount {
            userAccount.withdraw(amount: amount, from: account.name)
            withdrawAmount = ""
            showingWithdrawSheet = false
        }
    }

    private func handleDepositWithdrawCancel() {
        if showingDepositSheet {
            depositAmount = ""
            showingDepositSheet = false
        } else if showingWithdrawSheet {
            withdrawAmount = ""
            showingWithdrawSheet = false
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//check (ignore this comment)
