import SwiftUI

struct ContentView: View {
    @State private var userAccount = UserAccount(
        cashBalance: 10000,
        savingsAccounts: [
            SavingsAccount(name: "High Yield Savings", interestRate: 0.05, balance: 0)
        ],
        stocks: [
            Stock(
                name: "CyberMosaic Systems",
                ticker: "CMSY",
                price: Double.random(in: 80.00...120.00),
                riskLevel: .high,
                projectedRateOfReturn: 0.15,
                dividendYield: nil
            ),
            Stock(
                name: "Prickler Holdings",
                ticker: "PHGS",
                price: Double.random(in: 180.00...220.00),
                riskLevel: .low,
                projectedRateOfReturn: 0.07,
                dividendYield: 0.04
            ),
            Stock(
                name: "Pinemoore Finance",
                ticker: "PIMF",
                price: Double.random(in: 40.00...60.00),
                riskLevel: .medium,
                projectedRateOfReturn: 0.10,
                dividendYield: 0.02
            )
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
    
    @State private var quizScore = 0
    @State private var totalQuizQuestions = 0

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                VStack(spacing: 0) {
                    if currentView == "StartScreen" {
                        StartScreenView(currentView: $currentView, previousView: $previousView)
                    } else {
                        switch currentView {
                        case "Home":
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
                        case "Graph":
                            EarningsGraphView(
                                earningsOverTime: earningsOverTime,
                                userAccount: $userAccount,
                                currentYear: $currentYear,
                                onNavigateHome: { currentView = "Home" }
                            )
                        case "Playthroughs":
                            PlaythroughsView(
                                userAccount: $userAccount,
                                currentYear: $currentYear,
                                earningsOverTime: $earningsOverTime,
                                currentView: $currentView,
                                previousView: $previousView
                            )
                        case "Chat":
                            ChatBotView(
                                userAccount: $userAccount,
                                currentView: $currentView,
                                earningsOverTime: $earningsOverTime,
                                currentYear: $currentYear
                            )
                        case "Help":
                            HelpView(currentView: $currentView)
                        case "Quiz":
                            QuizView(currentView: $currentView)
                        case "QuizQuestionView":
                            QuizQuestionView(
                                currentView: $currentView,
                                quizScore: $quizScore
                            )
                        case "QuizResultView":
                            QuizResultView(
                                currentView: $currentView,
                                score: quizScore,
                                didPass: quizScore >= 3
                            )
                        default:
                            Text("View not found")
                        }
                    }
                }
                .frame(maxHeight: .infinity)

                if currentView != "StartScreen" {
                    footerBar
                }
            }
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }

    private var footerBar: some View {
        HStack(spacing: 15) {
            Button(action: { currentView = "Home" }) {
                VStack(spacing: 4) {
                    Image(systemName: "house")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                    Text("Home")
                        .font(.caption)
                }
                .foregroundColor(currentView == "Home" ? .cyan : .gray)
                .padding(.vertical, 8)
            }

            Spacer()

            Button(action: {
                previousView = currentView
                currentView = "Playthroughs"
            }) {
                VStack(spacing: 4) {
                    Image(systemName: "book.closed")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                    Text("History")
                        .font(.caption)
                }
                .foregroundColor(currentView == "Playthroughs" ? .cyan : .gray)
                .padding(.vertical, 8)
            }

            Spacer()

            Button(action: { currentView = "Graph" }) {
                VStack(spacing: 4) {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                    Text("Graph")
                        .font(.caption)
                }
                .foregroundColor(currentView == "Graph" ? .cyan : .gray)
                .padding(.vertical, 8)
            }

            Spacer()

            Button(action: { currentView = "Quiz" }) {
                VStack(spacing: 4) {
                    Image(systemName: "trophy")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                    Text("Quiz")
                        .font(.caption)
                }
                .foregroundColor(currentView == "Quiz" ? .cyan : .gray)
                .padding(.vertical, 8)
            }

            Spacer()

            Button(action: { currentView = "Chat" }) {
                VStack(spacing: 4) {
                    Image(systemName: "bubble.left.and.bubble.right")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                    Text("Chat")
                        .font(.caption)
                }
                .foregroundColor(currentView == "Chat" ? .cyan : .gray)
                .padding(.vertical, 8)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.1, green: 0.1, blue: 0.15).opacity(0.98),
                    Color(red: 0.15, green: 0.15, blue: 0.2).opacity(0.98)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .overlay(
            Rectangle()
                .frame(height: 0.5)
                .foregroundColor(Color.gray.opacity(0.2)),
            alignment: .top
        )
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
        depositAmount = ""
        withdrawAmount = ""
        showingDepositSheet = false
        showingWithdrawSheet = false
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
