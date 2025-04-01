import SwiftUI

struct ChatBotView: View {
    @Binding var userAccount: UserAccount
    @Binding var currentView: String
    @Binding var earningsOverTime: [(year: Int, value: Double)]
    @Binding var currentYear: Double
    @State private var messages: [ChatMessage] = [
        ChatMessage(text: "How can I assist you today?", isUser: false)
    ]
    @State private var userInput: String = ""
    @State private var pendingTransaction: (type: TransactionType, amount: Double)? = nil
    @State private var showingHelp: Bool = false
    @FocusState private var isFocused: Bool
    
    struct ChatMessage: Identifiable, Equatable {
        let id = UUID()
        let text: String
        let isUser: Bool
        var isGraph: Bool = false
        
        // Implement Equatable
        static func == (lhs: ChatMessage, rhs: ChatMessage) -> Bool {
            return lhs.id == rhs.id &&
                   lhs.text == rhs.text &&
                   lhs.isUser == rhs.isUser &&
                   lhs.isGraph == rhs.isGraph
        }
    }
    
    enum TransactionType {
        case deposit, withdraw
    }
    
    var body: some View {
        ZStack {
            // Background gradient with stars
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.1, green: 0.1, blue: 0.15),
                    Color(red: 0.15, green: 0.15, blue: 0.2)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            // Star effect
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
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: { currentView = "Home" }) {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.gray)
                            .frame(width: 44, height: 44)
                            .background(
                                Circle()
                                    .fill(Color.white.opacity(0.05))
                                    .overlay(
                                        Circle()
                                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                                    )
                            )
                    }
                    
                    Spacer()
                    
                    Text("Chat Assistant")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: { showingHelp = true }) {
                        Image(systemName: "questionmark.circle")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.cyan)
                            .frame(width: 44, height: 44)
                            .background(
                                Circle()
                                    .fill(Color.white.opacity(0.05))
                                    .overlay(
                                        Circle()
                                            .stroke(Color.cyan.opacity(0.3), lineWidth: 1)
                                    )
                            )
                    }
                }
                .padding()
                
                // Messages
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(messages) { message in
                                if message.isGraph, let image = getGraphImage(from: message.text) {
                                    Image(uiImage: image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(maxWidth: .infinity)
                                        .padding(.horizontal)
                                } else {
                                    ChatBubble(message: message)
                                }
                            }
                        }
                        .padding()
                    }
                    .onChange(of: messages) { _ in
                        withAnimation {
                            proxy.scrollTo(messages.last?.id, anchor: .bottom)
                        }
                    }
                }
                
                // Input area
                VStack(spacing: 0) {
                    Divider()
                        .background(Color.white.opacity(0.1))
                    
                    HStack(spacing: 16) {
                        TextField("Type your message...", text: $userInput)
                            .textFieldStyle(.plain)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.white.opacity(0.05))
                            )
                            .foregroundColor(.white)
                            .focused($isFocused)
                        
                        Button(action: handleUserInput) {
                            Image(systemName: "arrow.up.circle.fill")
                                .font(.system(size: 32))
                                .foregroundColor(userInput.isEmpty ? .gray : .cyan)
                        }
                        .disabled(userInput.isEmpty)
                    }
                    .padding(16)
                }
                .background(
                    Color(red: 0.12, green: 0.12, blue: 0.15)
                        .opacity(0.98)
                )
            }
        }
        .sheet(isPresented: $showingHelp) {
            ChatHelpView(showingHelp: $showingHelp)
        }
    }
    
    private func getGraphImage(from text: String) -> UIImage? {
        if text.hasPrefix("Graph:") {
            let base64String = text.replacingOccurrences(of: "Graph:", with: "")
            if let data = Data(base64Encoded: base64String) {
                return UIImage(data: data)
            }
        }
        return nil
    }
    
    @MainActor
    private func handleUserInput() {
        let input = userInput.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !input.isEmpty else { return }
        
        messages.append(ChatMessage(text: input, isUser: true))
        userInput = ""
        
        let response = generateResponse(to: input)
        messages.append(ChatMessage(text: response, isUser: false))
    }
    
    private func generateResponse(to input: String) -> String {
        let lowercasedInput = input.lowercased()
        
        // Check for pending transactions first
        if let pending = pendingTransaction {
            return handlePendingTransaction(with: lowercasedInput, pending: pending)
        }
        
        // Create intent matcher with current user account
        let matcher = IntentMatcher(userAccount: userAccount)
        
        // Try to get intent response
        if let intentResponse = matcher.getIntentResponse(input) {
            return intentResponse
        }
        
        // Handle specific commands
        if let amount = extractAmount(from: lowercasedInput) {
            if lowercasedInput.contains("deposit") {
                pendingTransaction = (.deposit, amount)
                return "You would like to deposit \(Self.formatBalance(amount)) into your High Yield Savings Account, correct? (yes/no)"
            }
            if lowercasedInput.contains("withdraw") {
                pendingTransaction = (.withdraw, amount)
                return "You would like to withdraw \(Self.formatBalance(amount)) from your High Yield Savings Account, correct? (yes/no)"
            }
            if lowercasedInput.contains("simulate") {
                return simulateGrowth(years: amount)
            }
        }
        
        // Handle greetings
        if isGreeting(lowercasedInput) {
            return getRandomGreeting()
        }
        
        // Handle graph requests
        if isGraphRequest(lowercasedInput) {
            // Instead of directly calling displayGraph, add a message about generating the graph
            Task { @MainActor in
                let graphResponse = displayGraph()
                messages.append(ChatMessage(text: graphResponse, isUser: false))
            }
            return "Generating your earnings graph..."
        }
        
        // Default response
        return """
            I'm not sure what you mean. You can:
            - Check your balance
            - Deposit or withdraw money
            - Buy stocks
            - Simulate growth
            - Learn about financial concepts
            
            Just ask naturally and I'll help you out!
            """
    }

    func handlePendingTransaction(with input: String, pending: (type: TransactionType, amount: Double)) -> String {
        let lowercasedInput = input.lowercased()
        if let account = userAccount.savingsAccounts.first(where: { $0.name.lowercased() == "high yield savings" }) {
            if pending.type == .deposit && isAffirmative(lowercasedInput) {
                userAccount.deposit(amount: pending.amount, to: account.name)
                pendingTransaction = nil
                return "Deposited \(Self.formatBalance(pending.amount)) into \(account.name). Your cash balance is now \(Self.formatBalance(userAccount.cashBalance)). Your net account value is \(Self.formatBalance(userAccount.netAccountValue))."
            } else if lowercasedInput == "no" {
                pendingTransaction = nil
                return "Deposit canceled. Your balance remains \(Self.formatBalance(userAccount.cashBalance))."
            }
        }
        return "Account not found or action canceled. Please specify a valid action."
    }

    // Function to simulate growth over years
    func simulateGrowth(years: Double) -> String {
        if currentYear + years > 100 {
            return "You cannot simulate more than 100 years in total."
        }

        for _ in 0..<Int(years) {
            for index in userAccount.savingsAccounts.indices {
                let interest = userAccount.savingsAccounts[index].balance * userAccount.savingsAccounts[index].interestRate
                userAccount.savingsAccounts[index].balance += interest
            }
            for index in userAccount.stocks.indices {
                let returnRate = Double.random(in: 0.03...0.07)
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
                let returnRate = Double.random(in: 0.03...0.07)
                let projectedReturn = userAccount.stocks[index].price * returnRate * fractionalYear
                userAccount.stocks[index].price += projectedReturn

                if let investmentIndex = userAccount.investments.firstIndex(where: { $0.stockId == userAccount.stocks[index].id }) {
                    userAccount.investments[investmentIndex].amount += userAccount.investments[investmentIndex].amount * returnRate
                }
            }
            currentYear += fractionalYear
            earningsOverTime.append((year: Int(currentYear), value: userAccount.netAccountValue))
        }

        userAccount = userAccount // Force view update
        return "Simulated \(years) years. Your new net account value is \(Self.formatBalance(userAccount.netAccountValue))."
    }

    // Function to display graph
    @MainActor func displayGraph() -> String {
        let chartView = EarningsGraphView(earningsOverTime: earningsOverTime, userAccount: $userAccount, currentYear: $currentYear, onNavigateHome: {})

        let renderer = ImageRenderer(content: chartView)
        renderer.scale = UIScreen.main.scale

        if let image = renderer.uiImage {
            let cropRect = CGRect(x: 0, y: 50, width: image.size.width, height: image.size.height - 50) // Adjust the cropRect as needed
            if let cgImage = image.cgImage?.cropping(to: cropRect) {
                let croppedImage = UIImage(cgImage: cgImage)
                let imageData = croppedImage.pngData()!
                let base64String = imageData.base64EncodedString()

                messages.append(ChatMessage(text: "Graph:\(base64String)", isUser: false, isGraph: true))
                return "Displaying earnings graph."
            } else {
                return "Failed to crop the earnings graph."
            }
        } else {
            return "Failed to generate the earnings graph."
        }
    }

    // Helper functions
    static func formatBalance(_ amount: Double) -> String {
        return String(format: "$%.2f", amount)
    }

    func extractAmount(from input: String) -> Double? {
        let words = input.split(separator: " ")
        for word in words {
            if let amount = Double(word) {
                return amount
            }
        }
        return nil
    }

    func extractStockName(from input: String) -> String? {
        let stockKeywords = ["stock", "of"]
        let words = input.split(separator: " ")
        var stockName: String?

        for i in 0..<words.count {
            if stockKeywords.contains(words[i].lowercased()) {
                if i + 1 < words.count {
                    stockName = String(words[i + 1])
                    break
                }
            }
        }

        return stockName
    }

    func isStandaloneAmount(_ input: String) -> Bool {
        return Double(input.trimmingCharacters(in: .whitespacesAndNewlines)) != nil
    }

    func isGreeting(_ input: String) -> Bool {
        let greetings = ["hello", "hi", "hey", "helo", "hii", "yo", "wsg"]
        return greetings.contains(input)
    }

    func isAffirmative(_ input: String) -> Bool {
        let affirmatives = ["yes", "yea", "yuh", "yep", "yeah", "ye"]
        return affirmatives.contains(input)
    }

    func isGraphRequest(_ input: String) -> Bool {
        let graphKeywords = ["graph", "chart", "graf", "chartz", "grap"]
        return graphKeywords.contains(where: input.contains)
    }

    func getRandomGreeting() -> String {
        let greetings = [
            "Hello! How can I assist you today?",
            "Hi there! What can I do for you?",
            "Hey! How can I help you?",
            "Hi! How can I assist with your finances today?"
        ]
        return greetings.randomElement() ?? "Hello! How can I assist you today?"
    }

    private func handleStockPurchase(stockName: String, amount: Double) -> String {
        if let stock = userAccount.stocks.first(where: { $0.name.lowercased().contains(stockName.lowercased()) }) {
            if userAccount.cashBalance >= amount {
                userAccount.purchaseStock(stock: stock, amount: amount)
                return "Successfully purchased \(Self.formatBalance(amount)) of \(stock.name).\n" +
                       "Your new cash balance is \(Self.formatBalance(userAccount.cashBalance))."
            } else {
                return "Insufficient funds. You have \(Self.formatBalance(userAccount.cashBalance)) available."
            }
        }
        return "I couldn't find a stock matching '\(stockName)'. Available stocks are CMSY, PHGS, and PIMF."
    }
}

struct ChatBubble: View {
    let message: ChatBotView.ChatMessage
    
    var body: some View {
        HStack {
            if message.isUser {
                Spacer()
                
                Text(message.text)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.cyan)
                    )
                    .foregroundColor(.black)
            } else {
                Text(message.text)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(red: 0.18, green: 0.18, blue: 0.24))
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
                            )
                    )
                    .foregroundColor(.white)
                
                Spacer()
            }
        }
    }
}

struct Intent {
    let patterns: [String]
    let responses: [String]
    let handler: ((String) -> String)?
}

struct IntentMatcher {
    let userAccount: UserAccount
    
    static let conceptExplanations: [String: String] = [
        "budget": "A budget is a financial plan that helps you track income and expenses. It's crucial for managing your money effectively.",
        "investing": "Investing means putting money into assets like stocks or savings accounts with the goal of growing your wealth over time.",
        "stock": "A stock represents ownership in a company. When you buy stocks, you become a partial owner of that company.",
        "interest": "Interest is the cost of borrowing money or the return on lending money. With our High Yield Savings Account, you earn 5% interest annually.",
        "dividend": "Dividends are payments companies make to shareholders from their profits. They're a way to earn income from stocks.",
        "risk": "Risk in investing refers to the possibility of losing money. Generally, higher potential returns come with higher risks.",
        "diversification": "Diversification means spreading your investments across different assets to reduce risk.",
        "compound": "Compound interest is when you earn interest on both your initial investment and previously earned interest.",
        "market": "The stock market is where stocks are bought and sold. Prices can go up or down based on various factors."
    ]
    
    func getBalanceResponse() -> String {
        return "Your cash balance is \(ChatBotView.formatBalance(userAccount.cashBalance)).\nYour net account value is \(ChatBotView.formatBalance(userAccount.netAccountValue))."
    }
    
    func getIntentResponse(_ input: String) -> String? {
        let lowercasedInput = input.lowercased()
        
        // Check for balance queries
        if lowercasedInput.contains("balance") || lowercasedInput.contains("worth") || lowercasedInput.contains("money") {
            return getBalanceResponse()
        }
        
        // Check for stock information
        if lowercasedInput.contains("stock") || lowercasedInput.contains("invest") {
            return """
                Here are the available stocks:
                - CyberMosaic Systems (CMSY): High risk, high potential return
                - Prickler Holdings (PHGS): Medium risk with dividends
                - Pinemoore Finance (PIMF): Medium risk with growth potential
                
                You can say 'buy [amount] of [stock name]' to purchase stocks.
                """
        }
        
        // Check for savings/interest information
        if lowercasedInput.contains("savings") || lowercasedInput.contains("interest") {
            return "Your High Yield Savings Account offers a 5% annual interest rate. It's a great way to grow your money safely.\n\nWould you like to deposit money into your High Yield Savings Account? Just say 'deposit [amount]'."
        }
        
        // Check for concept explanations
        for (concept, explanation) in Self.conceptExplanations {
            if lowercasedInput.contains(concept) {
                return explanation
            }
        }
        
        return nil
    }
}
