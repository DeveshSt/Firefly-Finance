import Foundation

// Enum to represent the type of investment
enum InvestmentType: String, Codable {
    case savings
    case stock
}

// Enum to represent the risk level of stocks
enum RiskLevel: String, Codable {
    case low
    case medium
    case high
}

// Model for a savings account
struct SavingsAccount: Identifiable, Codable {
    var id: UUID = UUID() // Automatically generate a UUID for each instance
    let name: String
    let interestRate: Double // Annual interest rate as a decimal
    var balance: Double // Current balance in the account
}

// Model for a stock
struct Stock: Identifiable, Codable {
    var id: UUID = UUID() // Automatically generate a UUID for each instance
    let name: String
    let ticker: String
    var price: Double // New price property
    let riskLevel: RiskLevel
    var projectedRateOfReturn: Double // Used only for random value during simulation
    var dividendYield: Double? // Optional dividend yield for stocks that pay dividends
}

// Model for an investment
struct Investment: Identifiable, Codable {
    var id: UUID = UUID() // Automatically generate a UUID for each instance
    let stockId: UUID?
    let type: InvestmentType
    var amount: Double
}

// Model for the user's account
struct UserAccount: Codable {
    var cashBalance: Double
    var savingsAccounts: [SavingsAccount]
    var stocks: [Stock]
    var investments: [Investment]

    // Total value of all accounts including cash and investments
    var netAccountValue: Double {
        let savingsTotal = savingsAccounts.reduce(0) { $0 + $1.balance }
        let investmentsTotal = investments.reduce(0) { $0 + $1.amount }
        return cashBalance + savingsTotal + investmentsTotal
    }

    mutating func deposit(amount: Double, to accountName: String) {
        guard cashBalance >= amount else { return }
        cashBalance -= amount
        if let index = savingsAccounts.firstIndex(where: { $0.name == accountName }) {
            savingsAccounts[index].balance += amount
        }
    }

    mutating func withdraw(amount: Double, from accountName: String) {
        if let index = savingsAccounts.firstIndex(where: { $0.name == accountName }), savingsAccounts[index].balance >= amount {
            savingsAccounts[index].balance -= amount
            cashBalance += amount
        }
    }

    mutating func purchaseStock(stock: Stock, amount: Double) {
        guard cashBalance >= amount else { return }
        cashBalance -= amount
        investments.append(Investment(stockId: stock.id, type: .stock, amount: amount))
    }
}
