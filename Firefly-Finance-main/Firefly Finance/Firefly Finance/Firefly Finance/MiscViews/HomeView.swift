import SwiftUI

struct HomeView: View {
    @Binding var userAccount: UserAccount
    @Binding var depositAmount: String
    @Binding var withdrawAmount: String
    @Binding var showingDepositSheet: Bool
    @Binding var showingWithdrawSheet: Bool
    @Binding var selectedAccount: SavingsAccount?
    @Binding var simulationYears: String
    @Binding var currentYear: Double
    @Binding var showingAlert: Bool
    @Binding var alertMessage: String
    @Binding var showingResetConfirmation: Bool
    @Binding var earningsOverTime: [(year: Int, value: Double)]
    @Binding var currentView: String
    @Binding var stockTransactionShares: [UUID: String]
    @Binding var stockTransactionSellShares: [UUID: String]
    
    @State private var showingSavePlaythroughAlert = false
    @State private var showingSimulationLimitAlert = false
    @State private var showingSaveProgressAlert = false

    let purchaseStock: (Stock, String) -> Void
    let sellStock: (Stock, String) -> Void
    let handleDepositWithdrawAction: () -> Void
    let handleDepositWithdrawCancel: () -> Void

    var body: some View {
        VStack {
            ScrollViewReader { proxy in
                ScrollView {
                    VStack {
                        YearAndResetView(
                            currentYear: $currentYear,
                            showingResetConfirmation: $showingResetConfirmation,
                            currentView: $currentView
                        )
                        
                        AccountInfoView(userAccount: $userAccount)
                        
                        ShareHoldingsView(userAccount: $userAccount, scrollToStocks: {
                            withAnimation {
                                proxy.scrollTo("stock-section", anchor: .center)
                            }
                        })
                        
                        SavingsAccountsView(
                            userAccount: $userAccount,
                            selectedAccount: $selectedAccount,
                            showingDepositSheet: $showingDepositSheet,
                            showingWithdrawSheet: $showingWithdrawSheet
                        )
                        
                        VStack(spacing: 20) {
                            Section(header:
                                HStack {
                                    Text("Stocks")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    NavigationLink(destination: StocksInfoView()) {
                                        Image(systemName: "questionmark.circle")
                                            .foregroundColor(.cyan)
                                    }
                                }
                                .padding(.top, 20)
                                .id("stock-section")) {
                                ForEach(userAccount.stocks) { stock in
                                    VStack(alignment: .leading, spacing: 10) {
                                        HStack {
                                            Text(stock.name)
                                            Spacer()
                                            Text("Ticker: \(stock.ticker)")
                                        }
                                        .foregroundColor(.white)
                                        HStack {
                                            Text("Current Price: $\(stock.price, specifier: "%.2f")")
                                            Spacer()
                                        }
                                        .foregroundColor(.white)
                                        if stock.name == "Prickler Holdings" {
                                            HStack {
                                                Text("Projected Yearly Return: 0% to 8%")
                                                Spacer()
                                            }
                                            .foregroundColor(.white)
                                            HStack {
                                                Text("Dividend Yield: 3%")
                                                NavigationLink(destination: DividendInfoView()) {
                                                    Image(systemName: "questionmark.circle")
                                                        .foregroundColor(.cyan)
                                                }
                                                Spacer()
                                            }
                                            .foregroundColor(.white)
                                        } else if stock.name == "Pinemoore Finance" {
                                            HStack {
                                                Text("Projected Yearly Return: -5% to 15%")
                                                Spacer()
                                            }
                                            .foregroundColor(.white)
                                            HStack {
                                                Text("Dividend Yield: 1%")
                                                NavigationLink(destination: DividendInfoView()) {
                                                    Image(systemName: "questionmark.circle")
                                                        .foregroundColor(.cyan)
                                                }
                                                Spacer()
                                            }
                                            .foregroundColor(.white)
                                        } else {
                                            HStack {
                                                Text("Projected Yearly Return: 3% to 7%")
                                                Spacer()
                                            }
                                            .foregroundColor(.white)
                                        }
                                        VStack(spacing: 10) {
                                            HStack {
                                                TextField("Shares", text: Binding(
                                                    get: { stockTransactionShares[stock.id, default: ""] },
                                                    set: { stockTransactionShares[stock.id] = $0 }
                                                ))
                                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                                .keyboardType(.decimalPad)
                                                .padding()
                                                
                                                if let shares = Double(stockTransactionShares[stock.id] ?? ""), shares > 0 {
                                                    Text("Total: $\(shares * stock.price, specifier: "%.2f")")
                                                        .foregroundColor(.white)
                                                }
                                                
                                                Spacer()
                                                
                                                Button(action: {
                                                    purchaseStock(stock, stockTransactionShares[stock.id] ?? "")
                                                }) {
                                                    Text("Buy Shares")
                                                        .padding()
                                                        .background(Color.cyan)
                                                        .foregroundColor(.black)
                                                        .cornerRadius(8)
                                                }
                                                .padding(.trailing)
                                            }
                                            
                                            HStack {
                                                TextField("Sell Shares", text: Binding(
                                                    get: { stockTransactionSellShares[stock.id, default: ""] },
                                                    set: { stockTransactionSellShares[stock.id] = $0 }
                                                ))
                                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                                .keyboardType(.decimalPad)
                                                .padding()
                                                
                                                if let shares = Double(stockTransactionSellShares[stock.id] ?? ""), shares > 0 {
                                                    Text("Total: $\(shares * stock.price, specifier: "%.2f")")
                                                        .foregroundColor(.white)
                                                }
                                                
                                                Spacer()
                                                
                                                Button(action: {
                                                    sellStock(stock, stockTransactionSellShares[stock.id] ?? "")
                                                }) {
                                                    Text("Sell Shares")
                                                        .padding()
                                                        .background(Color.red)
                                                        .foregroundColor(.black)
                                                        .cornerRadius(8)
                                                }
                                                .padding(.trailing)
                                            }
                                        }
                                    }
                                    .padding()
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(12)
                                    .shadow(radius: 10)
                                }
                            }
                        }
                        
                        SimulationView(
                            simulationYears: $simulationYears,
                            simulateGrowth: simulateGrowth
                        )
                        
                        Button(action: { showingSaveProgressAlert = true }) {
                            Text("Save Progress")
                                .padding()
                                .background(Color.green.opacity(0.8))
                                .foregroundColor(.black)
                                .cornerRadius(8)
                        }
                        .padding(.top)
                        
                        Spacer()
                    }
                    .padding()
                }
                .background(Color.black)
                .blur(radius: (showingDepositSheet || showingWithdrawSheet || showingResetConfirmation || showingSaveProgressAlert) ? 3 : 0)
            }
            
            if showingDepositSheet || showingWithdrawSheet {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Spacer()
                    
                    DepositWithdrawView(
                        title: showingDepositSheet ? "Deposit Amount" : "Withdraw Amount",
                        actionTitle: showingDepositSheet ? "Deposit" : "Withdraw",
                        amount: showingDepositSheet ? $depositAmount : $withdrawAmount,
                        action: handleDepositWithdrawAction,
                        cancelAction: handleDepositWithdrawCancel
                    )
                    .frame(width: 300, height: 250)
                    .background(Color.black)
                    .cornerRadius(12)
                    .shadow(radius: 20)
                    
                    Spacer()
                }
                .edgesIgnoringSafeArea(.all)
            }

            if showingResetConfirmation {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                
                ResetConfirmationView(
                    confirmAction: resetAccount,
                    cancelAction: { showingResetConfirmation = false }
                )
                .frame(width: 350, height: 250)
                .background(Color.black)
                .cornerRadius(12)
                .shadow(radius: 20)
            }

            if showingSavePlaythroughAlert {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Text("Save Playthrough")
                        .font(.headline)
                        .padding()
                        .foregroundColor(.white)
                    
                    Text("You have reached year 100. Would you like to save this playthrough?")
                        .padding()
                        .foregroundColor(.white)
                    
                    HStack {
                        Button(action: savePlaythrough) {
                            Text("Save")
                                .padding()
                                .background(Color.cyan)
                                .foregroundColor(.black)
                                .cornerRadius(8)
                        }
                        .padding()

                        Button(action: {
                            showingSavePlaythroughAlert = false
                        }) {
                            Text("Cancel")
                                .padding()
                                .background(Color.gray)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        .padding()
                    }
                }
                .frame(width: 350, height: 250)
                .background(Color.black)
                .cornerRadius(12)
                .shadow(radius: 20)
            }
            
            if showingSimulationLimitAlert {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Text("Simulation Limit Reached")
                        .font(.headline)
                        .padding()
                        .foregroundColor(.white)
                    
                    Text("You cannot simulate beyond year 100.")
                        .padding()
                        .foregroundColor(.white)
                    
                    Button(action: {
                        showingSimulationLimitAlert = false
                    }) {
                        Text("OK")
                            .padding()
                            .background(Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding()
                }
                .frame(width: 350, height: 250)
                .background(Color.black)
                .cornerRadius(12)
                .shadow(radius: 20)
            }
            
            if showingSaveProgressAlert {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Text("Save Progress")
                        .font(.headline)
                        .padding()
                        .foregroundColor(.white)
                    
                    Text("Would you like to save your current progress?")
                        .padding()
                        .foregroundColor(.white)
                    
                    HStack {
                        Button(action: saveProgress) {
                            Text("Save")
                                .padding()
                                .background(Color.cyan)
                                .foregroundColor(.black)
                                .cornerRadius(8)
                        }
                        .padding()

                        Button(action: {
                            showingSaveProgressAlert = false
                        }) {
                            Text("Cancel")
                                .padding()
                                .background(Color.gray)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        .padding()
                    }
                }
                .frame(width: 350, height: 250)
                .background(Color.black)
                .cornerRadius(12)
                .shadow(radius: 20)
            }
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    private func simulateGrowth() {
        guard let years = Double(simulationYears) else { return }
        if currentYear + years > 100 {
            showingSimulationLimitAlert = true
            return
        }

        for _ in 0..<Int(years) {
            for index in userAccount.savingsAccounts.indices {
                let interest = userAccount.savingsAccounts[index].balance * userAccount.savingsAccounts[index].interestRate
                userAccount.savingsAccounts[index].balance += interest
            }
            for index in userAccount.stocks.indices {
                let returnRate: Double
                if userAccount.stocks[index].name == "Prickler Holdings" {
                    returnRate = Double.random(in: 0.0...0.08)
                    let dividend = userAccount.stocks[index].price * userAccount.stocks[index].dividendYield! * (userAccount.investments.first { $0.stockId == userAccount.stocks[index].id }?.amount ?? 0) / userAccount.stocks[index].price
                    userAccount.cashBalance += dividend
                } else if userAccount.stocks[index].name == "Pinemoore Finance" {
                    returnRate = Double.random(in: -0.05...0.15)
                    let dividend = userAccount.stocks[index].price * userAccount.stocks[index].dividendYield! * (userAccount.investments.first { $0.stockId == userAccount.stocks[index].id }?.amount ?? 0) / userAccount.stocks[index].price
                    userAccount.cashBalance += dividend
                } else {
                    returnRate = Double.random(in: 0.03...0.07)
                }
                let projectedReturn = userAccount.stocks[index].price * returnRate
                userAccount.stocks[index].price += projectedReturn

                if let investmentIndex = userAccount.investments.firstIndex(where: { $0.stockId == userAccount.stocks[index].id }) {
                    userAccount.investments[investmentIndex].amount += userAccount.investments[investmentIndex].amount * returnRate
                }
            }
            currentYear += 1
            earningsOverTime.append((year: Int(currentYear), value: userAccount.netAccountValue))
        }
        let fractionalYear = years - Double(Int(years))
        if fractionalYear > 0 {
            for index in userAccount.savingsAccounts.indices {
                let interest = userAccount.savingsAccounts[index].balance * userAccount.savingsAccounts[index].interestRate * fractionalYear
                userAccount.savingsAccounts[index].balance += interest
            }
            for index in userAccount.stocks.indices {
                let returnRate: Double
                if userAccount.stocks[index].name == "Prickler Holdings" {
                    returnRate = Double.random(in: 0.0...0.08)
                    let dividend = userAccount.stocks[index].price * userAccount.stocks[index].dividendYield! * (userAccount.investments.first { $0.stockId == userAccount.stocks[index].id }?.amount ?? 0) / userAccount.stocks[index].price * fractionalYear
                    userAccount.cashBalance += dividend
                } else if userAccount.stocks[index].name == "Pinemoore Finance" {
                    returnRate = Double.random(in: -0.05...0.15)
                    let dividend = userAccount.stocks[index].price * userAccount.stocks[index].dividendYield! * (userAccount.investments.first { $0.stockId == userAccount.stocks[index].id }?.amount ?? 0) / userAccount.stocks[index].price * fractionalYear
                    userAccount.cashBalance += dividend
                } else {
                    returnRate = Double.random(in: 0.03...0.07)
                }
                let projectedReturn = userAccount.stocks[index].price * returnRate * fractionalYear
                userAccount.stocks[index].price += projectedReturn

                if let investmentIndex = userAccount.investments.firstIndex(where: { $0.stockId == userAccount.stocks[index].id }) {
                    userAccount.investments[investmentIndex].amount += userAccount.investments[investmentIndex].amount * returnRate
                }
            }
            currentYear += fractionalYear
            earningsOverTime.append((year: Int(currentYear), value: userAccount.netAccountValue))
        }
        
        userAccount = userAccount
        
        if currentYear >= 100 {
            showingSavePlaythroughAlert = true
        }
    }

    private func savePlaythrough() {
        let playthrough = Playthrough(
            year: Int(currentYear),
            netAccountValue: userAccount.netAccountValue,
            date: Date(),
            userAccount: userAccount,
            earningsOverTime: earningsOverTime
        )
        LocalStorage.savePlaythrough(playthrough)
        showingSavePlaythroughAlert = false
    }

    private func saveProgress() {
        savePlaythrough()
        showingSaveProgressAlert = false
    }

    private func resetAccount() {
        userAccount = UserAccount(cashBalance: 10000, savingsAccounts: [
            SavingsAccount(name: "High Yield Savings", interestRate: 0.05, balance: 0)
        ], stocks: [
            Stock(name: "CyberMosaic Systems", ticker: "CMSY", price: Double.random(in: 100.00...150.00), riskLevel: .high, projectedRateOfReturn: 0.05),
            Stock(name: "Prickler Holdings", ticker: "PHGS", price: Double.random(in: 210.00...265.00), riskLevel: .medium, projectedRateOfReturn: 0.0, dividendYield: 0.03),
            Stock(name: "Pinemoore Finance", ticker: "PIMF", price: Double.random(in: 50.00...100.00), riskLevel: .medium, projectedRateOfReturn: 0.10, dividendYield: 0.01)
        ], investments: [])
        currentYear = 0
        simulationYears = ""
        earningsOverTime.removeAll()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(
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
            depositAmount: .constant(""),
            withdrawAmount: .constant(""),
            showingDepositSheet: .constant(false),
            showingWithdrawSheet: .constant(false),
            selectedAccount: .constant(nil),
            simulationYears: .constant(""),
            currentYear: .constant(0),
            showingAlert: .constant(false),
            alertMessage: .constant(""),
            showingResetConfirmation: .constant(false),
            earningsOverTime: .constant([]),
            currentView: .constant("Home"),
            stockTransactionShares: .constant([:]),
            stockTransactionSellShares: .constant([:]),
            purchaseStock: { _, _ in },
            sellStock: { _, _ in },
            handleDepositWithdrawAction: {},
            handleDepositWithdrawCancel: {}
        )
    }
}
