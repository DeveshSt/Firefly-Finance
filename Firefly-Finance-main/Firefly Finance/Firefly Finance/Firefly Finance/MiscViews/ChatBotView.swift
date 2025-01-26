import SwiftUI

struct ChatBotView: View {
    @Binding var userAccount: UserAccount
    @Binding var currentView: String
    @Binding var earningsOverTime: [(year: Int, value: Double)]
    @Binding var currentYear: Double
    @State private var messages: [String] = ["AI: How can I assist you today?"]
    @State private var userInput: String = ""
    @State private var pendingTransaction: (type: TransactionType, amount: Double)? = nil
    @State private var showingHelp: Bool = false

    enum TransactionType {
        case deposit, withdraw
    }

    var body: some View {
        VStack {
            if showingHelp {
                ChatHelpView(showingHelp: $showingHelp)
            } else {
                VStack {
                    HStack {
                        Button(action: { currentView = "Home" }) {
                            Image(systemName: "arrow.left")
                                .padding()
                                .background(Color.black.opacity(0.8))
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        Spacer()
                        Button(action: { showingHelp = true }) {
                            Image(systemName: "questionmark.circle")
                                .padding()
                                .background(Color.black.opacity(0.8))
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                    }
                    .padding()

                    ScrollViewReader { proxy in
                        ScrollView {
                            VStack {
                                ForEach(messages, id: \.self) { message in
                                    if message.hasPrefix("Graph:") {
                                        if let image = UIImage(data: Data(base64Encoded: message.replacingOccurrences(of: "Graph:", with: ""))!) {
                                            Image(uiImage: image)
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .padding()
                                        }
                                    } else {
                                        HStack {
                                            if message.hasPrefix("User:") {
                                                Spacer()
                                                Text(message.replacingOccurrences(of: "User: ", with: ""))
                                                    .padding()
                                                    .background(Color.blue.opacity(0.1))
                                                    .cornerRadius(10)
                                                    .foregroundColor(Color.black)
                                            } else {
                                                Text(message)
                                                    .padding()
                                                    .background(Color.gray.opacity(0.2))
                                                    .cornerRadius(10)
                                                    .foregroundColor(Color.black)
                                                Spacer()
                                            }
                                        }
                                        .padding(.vertical, 2)
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .onChange(of: messages) { _ in
                                proxy.scrollTo(messages.last, anchor: .bottom)
                            }
                        }
                    }

                    HStack {
                        TextField("Enter your message", text: $userInput)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                            .background(Color.white)
                            .foregroundColor(Color.black)

                        Button(action: handleUserInput) {
                            Text("Send")
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        .padding(.trailing)
                    }
                    .padding(.bottom)
                }
                .background(Color.white.edgesIgnoringSafeArea(.all))
            }
        }
    }

    @MainActor func handleUserInput() {
        let input = userInput.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !input.isEmpty else { return }

        messages.append("User: \(userInput)")
        userInput = ""

        let response = generateResponse(to: input.lowercased())
        messages.append("AI: \(response)")
    }

    @MainActor func generateResponse(to input: String) -> String {
        let lowercasedInput = input.lowercased()

        if let pending = pendingTransaction {
            return handlePendingTransaction(with: lowercasedInput, pending: pending)
        } else if lowercasedInput.contains("balance") {
            return "Your cash balance is \(formattedBalance(userAccount.cashBalance)). Your net account value is \(formattedBalance(userAccount.netAccountValue))."
        } else if lowercasedInput.contains("deposit") && !lowercasedInput.contains("simulate") {
            if let amount = extractAmount(from: lowercasedInput) {
                pendingTransaction = (.deposit, amount)
                return "You would like to deposit \(formattedBalance(amount)) into your High Yield Savings Account, correct?"
            } else {
                return "Please specify the amount to deposit."
            }
        } else if lowercasedInput.contains("withdraw") {
            if let amount = extractAmount(from: lowercasedInput) {
                pendingTransaction = (.withdraw, amount)
                return "Please specify the savings account to withdraw \(formattedBalance(amount)) from."
            } else {
                return "Please specify the amount to withdraw."
            }
        } else if lowercasedInput.contains("simulate") {
            if let years = extractAmount(from: lowercasedInput) {
                return simulateGrowth(years: years)
            } else {
                return "Please specify the number of years to simulate."
            }
        } else if lowercasedInput.contains("purchase stock") {
            if let stockName = extractStockName(from: lowercasedInput), let amount = extractAmount(from: lowercasedInput) {
                if userAccount.cashBalance >= amount {
                    if let stock = userAccount.stocks.first(where: { $0.name.lowercased() == stockName.lowercased() }) {
                        userAccount.purchaseStock(stock: stock, amount: amount)
                        return "Purchased \(formattedBalance(amount)) of \(stock.name). Your new balance is \(formattedBalance(userAccount.cashBalance))."
                    } else {
                        return "Stock \(stockName) not found."
                    }
                } else {
                    return "Insufficient funds to purchase stock. Your balance is \(formattedBalance(userAccount.cashBalance))."
                }
            } else {
                return "Please specify the stock name and amount to purchase."
            }
        } else if lowercasedInput.contains("financial literacy") {
            return "Financial literacy involves understanding key financial concepts like budgeting, investing, managing debt, and planning for retirement."
        } else if isGreeting(lowercasedInput) {
            return getRandomGreeting()
        } else if isGraphRequest(lowercasedInput) {
            return displayGraph()
        } else {
            return "Sorry, I cannot help with that. Here are some things you can ask me:\n- Check balance\n- Deposit money\n- Withdraw money\n- Purchase stocks\n- Simulate growth\n- Learn about financial literacy"
        }
    }

    func handlePendingTransaction(with input: String, pending: (type: TransactionType, amount: Double)) -> String {
        let lowercasedInput = input.lowercased()
        if let account = userAccount.savingsAccounts.first(where: { $0.name.lowercased() == "high yield savings" }) {
            if pending.type == .deposit && isAffirmative(lowercasedInput) {
                userAccount.deposit(amount: pending.amount, to: account.name)
                pendingTransaction = nil
                return "Deposited \(formattedBalance(pending.amount)) into \(account.name). Your cash balance is now \(formattedBalance(userAccount.cashBalance)). Your net account value is \(formattedBalance(userAccount.netAccountValue))."
            } else if lowercasedInput == "no" {
                pendingTransaction = nil
                return "Deposit canceled. Your balance remains \(formattedBalance(userAccount.cashBalance))."
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
        return "Simulated \(years) years. Your new net account value is \(formattedBalance(userAccount.netAccountValue))."
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

                messages.append("Graph:\(base64String)")
                return "Displaying earnings graph."
            } else {
                return "Failed to crop the earnings graph."
            }
        } else {
            return "Failed to generate the earnings graph."
        }
    }

    // Helper functions
    func formattedBalance(_ balance: Double) -> String {
        return String(format: "$%.2f", balance)
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
}
