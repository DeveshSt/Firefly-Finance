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
                    VStack(spacing: 24) {
                        // Add padding at the top to create buffer from status bar
                        Color.clear.frame(height: 40)
                        
                        // For Reset and Help Section
                        YearAndResetView(
                            currentYear: $currentYear,
                            showingResetConfirmation: $showingResetConfirmation,
                            currentView: $currentView
                        )
                        
                        // Account Overview Cards
                        VStack(spacing: 16) {
                            AccountCardView(
                                title: "Cash Balance",
                                amount: userAccount.cashBalance,
                                subtitle: nil,
                                color: .cyan
                            )
                            
                            AccountCardView(
                                title: "Net Worth",
                                amount: userAccount.netAccountValue,
                                subtitle: "Including Investments",
                                color: .green
                            )
                        }
                        .padding(.horizontal)
                        
                        // After the NetWorth box, add:
                        HStack(spacing: 20) {
                            AssetDistributionChart(userAccount: userAccount)
                            RiskIndicator(userAccount: userAccount)
                        }
                        .padding(.horizontal)
                        
                        // Stocks Section
                        VStack(spacing: 16) {
                            HStack {
                                Text("Stocks")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(.white)
                                Spacer()
                                NavigationLink(destination: StocksInfoView(currentView: $currentView)) {
                                    Image(systemName: "info.circle")
                                        .font(.system(size: 20))
                                        .foregroundColor(.cyan)
                                }
                            }
                            .padding(.horizontal)
                            
                            ForEach(userAccount.stocks) { stock in
                                StockCardView(
                                    stock: stock,
                                    onBuy: { purchaseStock(stock, stockTransactionShares[stock.id] ?? "") },
                                    onSell: { sellStock(stock, stockTransactionSellShares[stock.id] ?? "") },
                                    buyShares: Binding(
                                        get: { stockTransactionShares[stock.id, default: ""] },
                                        set: { stockTransactionShares[stock.id] = $0 }
                                    ),
                                    sellShares: Binding(
                                        get: { stockTransactionSellShares[stock.id, default: ""] },
                                        set: { stockTransactionSellShares[stock.id] = $0 }
                                    )
                                )
                                .padding(.horizontal)
                            }
                        }
                        
                        // Savings Account Section
                        VStack(spacing: 16) {
                                HStack {
                                Text("Savings Account")
                                    .font(.system(size: 24, weight: .bold))
                                        .foregroundColor(.white)
                                Spacer()
                                NavigationLink(destination: HYSAInfoView()) {
                                    Image(systemName: "info.circle")
                                        .font(.system(size: 20))
                                            .foregroundColor(.cyan)
                                }
                            }
                            .padding(.horizontal)
                            
                            // Savings Account Card
                            VStack(spacing: 16) {
                                ForEach(userAccount.savingsAccounts) { account in
                                    VStack(alignment: .leading, spacing: 12) {
                                        HStack {
                                            Text(account.name)
                                                .font(.system(size: 18, weight: .bold))
                                        .foregroundColor(.white)
                                            Spacer()
                                            Text("\(Int(account.interestRate * 100))% APY")
                                                .font(.system(size: 16, weight: .medium))
                                                .foregroundColor(.green)
                                        }
                                        
                                        Text("$\(account.balance, specifier: "%.2f")")
                                            .font(.system(size: 24, weight: .bold))
                                            .foregroundColor(.white)
                                        
                                        HStack(spacing: 12) {
                                            Button(action: {
                                                selectedAccount = account
                                                showingDepositSheet = true
                                            }) {
                                            HStack {
                                                    Image(systemName: "arrow.down.circle.fill")
                                                    Text("Deposit")
                                                }
                                                .font(.system(size: 16, weight: .semibold))
                                                .frame(maxWidth: .infinity)
                                                .padding(.vertical, 12)
                                                .background(
                                                    RoundedRectangle(cornerRadius: 12)
                                                        .fill(LinearGradient(
                                                            gradient: Gradient(colors: [Color.green, Color.green.opacity(0.8)]),
                                                            startPoint: .topLeading,
                                                            endPoint: .bottomTrailing
                                                        ))
                                                )
                                                        .foregroundColor(.black)
                                            }
                                            
                                            Button(action: {
                                                selectedAccount = account
                                                showingWithdrawSheet = true
                                            }) {
                                            HStack {
                                                    Image(systemName: "arrow.up.circle.fill")
                                                    Text("Withdraw")
                                                }
                                                .font(.system(size: 16, weight: .semibold))
                                                .frame(maxWidth: .infinity)
                                                        .padding(.vertical, 12)
                                                .background(
                                                    RoundedRectangle(cornerRadius: 12)
                                                        .fill(Color.white.opacity(0.1))
                                                )
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 12)
                                                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                                )
                                                        .foregroundColor(.white)
                                            }
                                        }
                                    }
                                    .padding(20)
                                    .background(
                                        RoundedRectangle(cornerRadius: 24)
                                            .fill(Color(red: 0.12, green: 0.12, blue: 0.15))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 24)
                                                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
                                            )
                                    )
                                    .shadow(color: .black.opacity(0.2), radius: 10)
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        // Simulation Controls
                        VStack(spacing: 16) {
                            HStack {
                                Text("Simulation")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(.white)
                                Spacer()
                            }
                            .padding(.horizontal)
                    
                    VStack(spacing: 16) {
                                HStack {
                                    TextField("Years", text: $simulationYears)
                                        .keyboardType(.decimalPad)
                                        .font(.system(size: 24, weight: .bold))
                                        .foregroundColor(.white)
                                        .multilineTextAlignment(.center)
                                        .padding()
                                        .background(Color.white.opacity(0.05))
                                        .cornerRadius(12)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(Color.white.opacity(0.1), lineWidth: 1)
                                        )
                                    
                                    Button(action: simulateGrowth) {
                                        HStack {
                                            Image(systemName: "play.fill")
                                            Text("Simulate")
                                        }
                                        .font(.system(size: 16, weight: .semibold))
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 16)
                                        .background(
                                            LinearGradient(
                                                gradient: Gradient(colors: [Color.cyan, Color.cyan.opacity(0.8)]),
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .cornerRadius(12)
                                        .foregroundColor(.black)
                                    }
                                }
                        
                        Button(action: { showingSaveProgressAlert = true }) {
                                    HStack {
                                        Image(systemName: "square.and.arrow.down.fill")
                            Text("Save Progress")
                                    }
                                    .font(.system(size: 16, weight: .semibold))
                                .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                                .background(
                                    LinearGradient(
                                            gradient: Gradient(colors: [Color.purple.opacity(0.8), Color.purple.opacity(0.6)]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .cornerRadius(12)
                                    .foregroundColor(.white)
                                }
                            }
                            .padding(20)
                            .background(
                                RoundedRectangle(cornerRadius: 24)
                                    .fill(Color(red: 0.12, green: 0.12, blue: 0.15))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 24)
                                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                                    )
                            )
                            .shadow(color: .black.opacity(0.2), radius: 10)
                            .padding(.horizontal)
                        }
                    }
                    
                    Spacer()
                }
                .padding()
            }
            .background(
                ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.1, green: 0.1, blue: 0.15),
                        Color(red: 0.15, green: 0.15, blue: 0.2)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                    
                    GeometryReader { geometry in
                        ForEach(0..<100, id: \.self) { _ in
                            Circle()
                                .fill(Color.white)
                                .frame(width: .random(in: 1.5...3), height: .random(in: 1.5...3))
                                .position(
                                    x: .random(in: 0...geometry.size.width),
                                    y: .random(in: 0...geometry.size.height)
                                )
                                .opacity(.random(in: 0.3...0.7))
                        }
                    }
                    .opacity(0.7)
                }
            )
            .edgesIgnoringSafeArea(.all)
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
            ZStack {
                // Background color that extends to edges
                Color(red: 0.1, green: 0.1, blue: 0.15)
                .edgesIgnoringSafeArea(.all)
            
                VStack(spacing: 20) {
                    Text("Reset Account")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("This will reset your balance, years, and progress in this session.")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    // Action Buttons
                    HStack(spacing: 16) {
                        Button(action: { showingResetConfirmation = false }) {
                            Text("Cancel")
                                .font(.system(size: 16, weight: .semibold))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color.gray.opacity(0.3))
                                .cornerRadius(12)
                                .foregroundColor(.white)
                        }
                        
                        Button(action: resetAccount) {
                            Text("Reset")
                                .font(.system(size: 16, weight: .semibold))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.red.opacity(0.8), Color.red.opacity(0.6)]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
            .cornerRadius(12)
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
                .padding(24)
            }
            .presentationDragIndicator(.visible)
            .presentationDetents([.height(250)])
            .presentationBackground(Color(red: 0.1, green: 0.1, blue: 0.15))
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

struct StarView: View {
    let position: CGPoint
    let size: CGFloat
    let opacity: Double
    
    var body: some View {
        Circle()
            .fill(Color.white)
            .frame(width: size, height: size)
            .position(x: position.x, y: position.y)
            .opacity(opacity)
    }
}

struct StarryBackgroundView: View {
    let starCount: Int = 100
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(0..<starCount, id: \.self) { _ in
                    StarView(
                        position: CGPoint(
                            x: .random(in: 0...geometry.size.width),
                            y: .random(in: 0...geometry.size.height)
                        ),
                        size: .random(in: 1...2.5),
                        opacity: .random(in: 0.2...0.5)
                    )
                }
            }
        }
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

struct AccountCardView: View {
    let title: String
    let amount: Double
    let subtitle: String?
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.gray)
            
            Text("$\(amount, specifier: "%.2f")")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
            
            if let subtitle = subtitle {
                Text(subtitle)
                    .font(.system(size: 12))
                    .foregroundColor(color)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(red: 0.12, green: 0.12, blue: 0.15))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(color.opacity(0.3), lineWidth: 1)
                )
        )
        .shadow(color: .black.opacity(0.2), radius: 10)
    }
}

struct StockCardView: View {
    let stock: Stock
    let onBuy: () -> Void
    let onSell: () -> Void
    @Binding var buyShares: String
    @Binding var sellShares: String
    @State private var showingTradeSheet = false
    @State private var tradeType: TradeType = .buy
    
    var body: some View {
        VStack(spacing: 16) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(stock.name)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                    Text(stock.ticker)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                }
                Spacer()
                Text("$\(stock.price, specifier: "%.2f")")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.cyan)
            }
            
            // Stats
            HStack(spacing: 20) {
                StatView(title: "Return", value: getReturnRange(stock: stock))
                if let dividend = stock.dividendYield {
                    StatView(title: "Dividend", value: "\(Int(dividend * 100))%")
                }
            }
            
            // Trading Buttons
            HStack(spacing: 12) {
                Button(action: {
                    tradeType = .buy
                    showingTradeSheet = true
                }) {
                    HStack {
                        Image(systemName: "arrow.down.circle.fill")
                            .font(.system(size: 16, weight: .semibold))
                        Text("Buy")
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.cyan, Color.cyan.opacity(0.8)]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
                    .foregroundColor(.black)
                }
                
                Button(action: {
                    tradeType = .sell
                    showingTradeSheet = true
                }) {
                    HStack {
                        Image(systemName: "arrow.up.circle.fill")
                        Text("Sell")
                    }
                    .font(.system(size: 16, weight: .semibold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.red.opacity(0.8), Color.red.opacity(0.6)]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
                    .foregroundColor(.white)
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color(red: 0.12, green: 0.12, blue: 0.15))
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
        )
        .shadow(color: .black.opacity(0.2), radius: 10)
        .sheet(isPresented: $showingTradeSheet) {
            TradeSheetView(
                stock: stock,
                tradeType: tradeType,
                shares: tradeType == .buy ? $buyShares : $sellShares,
                onTrade: tradeType == .buy ? onBuy : onSell,
                isPresented: $showingTradeSheet
            )
        }
    }
    
    private func getReturnRange(stock: Stock) -> String {
        switch stock.name {
        case "Prickler Holdings":
            return "0-8%"
        case "Pinemoore Finance":
            return "-5-15%"
        default:
            return "3-7%"
        }
    }
}

struct StatView: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.gray)
            Text(value)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.05))
        )
    }
}

enum TradeType {
    case buy
    case sell
}

struct TradeSheetView: View {
    let stock: Stock
    let tradeType: TradeType
    @Binding var shares: String
    let onTrade: () -> Void
    @Binding var isPresented: Bool
    
    var body: some View {
        ZStack {
            // Background color that extends to edges
            Color(red: 0.1, green: 0.1, blue: 0.15)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Text("\(tradeType == .buy ? "Buy" : "Sell") \(stock.name)")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                
                Text("Current Price: $\(stock.price, specifier: "%.2f")")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.gray)
                
                // Trade Input
        VStack(spacing: 8) {
                    Text("Number of Shares")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.gray)
                    
                    TextField("0", text: $shares)
                .keyboardType(.decimalPad)
                        .multilineTextAlignment(.center)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                        .padding()
                .background(Color.white.opacity(0.05))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
                }
            
            if let amount = Double(shares) {
                    Text("Total: $\(amount * stock.price, specifier: "%.2f")")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                }
                
                // Action Buttons
                HStack(spacing: 16) {
                    Button(action: { isPresented = false }) {
                        Text("Cancel")
                            .font(.system(size: 16, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.gray.opacity(0.3))
                            .cornerRadius(12)
                            .foregroundColor(.white)
                    }
                    
                    Button(action: {
                        onTrade()
                        isPresented = false
                    }) {
                        Text(tradeType == .buy ? "Buy" : "Sell")
                    .font(.system(size: 16, weight: .semibold))
                    .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                    .background(
                                tradeType == .buy ?
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.cyan, Color.cyan.opacity(0.8)]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ) :
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.red.opacity(0.8), Color.red.opacity(0.6)]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                            )
                            .cornerRadius(12)
                            .foregroundColor(tradeType == .buy ? .black : .white)
                    }
                }
                
                Spacer()
            }
            .padding(24)
        }
        .presentationDragIndicator(.visible)
        .presentationDetents([.height(400)])
        .presentationBackground(Color(red: 0.1, green: 0.1, blue: 0.15))
    }
}

struct AssetDistributionChart: View {
    let userAccount: UserAccount
    
    private var assetDistribution: [(String, Double, Color)] {
        let totalValue = userAccount.netAccountValue
        let cashPercentage = userAccount.cashBalance / totalValue
        let savingsPercentage = userAccount.savingsAccounts.reduce(0) { $0 + $1.balance } / totalValue
        let stocksPercentage = userAccount.investments.reduce(0) { $0 + $1.amount } / totalValue
        
        return [
            ("Cash", cashPercentage, Color.green),
            ("Savings", savingsPercentage, Color.blue),
            ("Stocks", stocksPercentage, Color.orange)
        ]
    }
    
    var body: some View {
        VStack {
            Text("Portfolio Distribution")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
            
            ZStack {
                Circle()
                    .fill(Color(red: 0.12, green: 0.12, blue: 0.15))
                    .frame(width: 120, height: 120)
                
                Circle()
                    .trim(from: 0, to: 1)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 12)
                    .frame(width: 120, height: 120)
                
                ForEach(0..<assetDistribution.count, id: \.self) { index in
                    let startAngle = getStartAngle(for: index)
                    let endAngle = getEndAngle(for: index)
                    
                    Circle()
                        .trim(from: startAngle, to: endAngle)
                        .stroke(assetDistribution[index].2, lineWidth: 12)
                        .frame(width: 120, height: 120)
                        .rotationEffect(.degrees(-90))
                }
                
                VStack(spacing: 4) {
                    ForEach(assetDistribution, id: \.0) { asset in
                        HStack(spacing: 4) {
                            Circle()
                                .fill(asset.2)
                                .frame(width: 8, height: 8)
                            Text("\(asset.0): \(Int(asset.1 * 100))%")
                                .font(.system(size: 10))
                                .foregroundColor(.white)
                        }
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(red: 0.12, green: 0.12, blue: 0.15))
                .shadow(color: Color.black.opacity(0.2), radius: 10)
        )
    }
    
    private func getStartAngle(for index: Int) -> CGFloat {
        let previous = assetDistribution.prefix(index).reduce(0) { $0 + $1.1 }
        return previous
    }
    
    private func getEndAngle(for index: Int) -> CGFloat {
        getStartAngle(for: index) + assetDistribution[index].1
    }
}

struct RiskIndicator: View {
    let userAccount: UserAccount
    
    private var portfolioRisk: (percentage: Double, color: Color) {
        let stockRiskWeights: [RiskLevel: Double] = [
            .low: 0.3,
            .medium: 0.6,
            .high: 1.0
        ]
        
        var totalRisk = 0.0
        var totalInvestment = 0.0
        
        // Calculate weighted risk
        for investment in userAccount.investments {
            if let stockId = investment.stockId,
               let stock = userAccount.stocks.first(where: { $0.id == stockId }) {
                let riskWeight = stockRiskWeights[stock.riskLevel] ?? 0.0
                totalRisk += investment.amount * riskWeight
                totalInvestment += investment.amount
            }
        }
        
        let riskPercentage = totalInvestment > 0 ? (totalRisk / totalInvestment) * 100 : 0
        
        let color: Color
        switch riskPercentage {
        case 0..<30: color = .green
        case 30..<60: color = .yellow
        case 60..<80: color = .orange
        default: color = .red
        }
        
        return (riskPercentage, color)
    }
    
    var body: some View {
        VStack {
            Text("Portfolio Risk")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
            
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.2), lineWidth: 12)
                    .frame(width: 120, height: 120)
                
                Circle()
                    .trim(from: 0, to: portfolioRisk.percentage / 100)
                    .stroke(portfolioRisk.color, lineWidth: 12)
                    .frame(width: 120, height: 120)
                    .rotationEffect(.degrees(-90))
                
                VStack {
                    Text("\(Int(portfolioRisk.percentage))%")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(portfolioRisk.color)
                    Text("Risk")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(red: 0.12, green: 0.12, blue: 0.15))
                .shadow(color: Color.black.opacity(0.2), radius: 10)
        )
    }
}
